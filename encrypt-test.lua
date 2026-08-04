local blake2s   = require("crypto.blake2s.blake2s");
local x25519    = require("crypto.x25519.x25519");
local ChaCha20  = require("crypto.chacha20.chacha20");
local Rng       = require("crypto.chacha20.chacha20rng");
local base64    = require("util.base64.base64");
local hkdf      = require("crypto.hkdf");
local randutils = require("randutils")

local function writeKeyFile(keys)
    local handle, err = fs.open("publickey", "w")
    if not handle then error(err, 2) end

    handle.write(textutils.serialise(keys))
    handle.close()
end
local function writeEncryptedFile(text)
    local handle, err = fs.open("encrypted", "w")
    if not handle then error(err, 2) end
    handle.write(text)
    handle.close()
end


-- 32 bytes for use as a private key
local local_private = "9e98b26b6cb95b1cf4cec1b783a3e673"

-- Compute local public key
local local_public = x25519.get_public_key(local_private);

writeKeyFile({base64.encode(local_public)})


local plaintext = "Encryption test again"

local recipient_public = base64.decode("++P4OCChwQHbBE51oQVzFrdDEK3ovZYbBwxk9Yn5xHM=")

local shared_secret = x25519.get_shared_secret(local_private, recipient_public);

local hkdf_salt = "a12fb33f9fe20356eb7bb1a2f99ef81f1d6b279230aca44fbb152ab4774284a3f5937bf77cf67713f349a8583905094865306c1fbb66c10bcfb089a932a297f1ed69965754d72078225cb8e6f34931303af0010e5d048680f076111d30ae449a325355ad3400190b664935bc0f9d2ab4e5468f6d97b928473b5fe2254d21b5fb"
local session_info = "ChaCha20 session key";
local session_key = hkdf.derive(shared_secret, hkdf_salt, session_info, 32);
local nonce = hkdf.derive(shared_secret, hkdf_salt, "nonce", 12);
local cipher = ChaCha20.new(session_key, nonce);

local ciphertext = cipher:apply_keystream(plaintext);

local mac_info = "BLAKE2s MAC key";
local mac_key = hkdf.derive(shared_secret, hkdf_salt, mac_info, 32);
local mac = blake2s.digest(ciphertext, mac_key);

local emessage = nonce .. mac .. ciphertext;

shell.run("clear")
print("Private key  : " .. base64.encode(local_private));
print("Public key   : " .. base64.encode(local_public));
print("Shared Secret: " .. base64.encode(shared_secret));
print("Nonce        : " .. nonce)
print("Mac          : " .. mac)
print("Ciphertext   : " .. base64.encode(ciphertext));
print("Message      : " .. base64.encode(emessage));
print("Plaintext    : " .. plaintext)
writeEncryptedFile(base64.encode(emessage))