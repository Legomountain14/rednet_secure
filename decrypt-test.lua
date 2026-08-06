local blake2s   = require("crypto.blake2s.blake2s");
local x25519    = require("crypto.x25519.x25519");
local ChaCha20  = require("crypto.chacha20.chacha20");
local base64    = require("util.base64.base64");
local hkdf      = require("crypto.hkdf");

local function writeKeyFile(keys)
    local handle, err = fs.open("publickey2", "w")
    if not handle then error(err, 2) end

    handle.write(textutils.serialise(keys))
    handle.close()
end
local function readEncryptedFile()
    local file = fs.open("encrypted", "r")
    local contents = file.readAll()
    file.close()
    return contents
end
local message = base64.decode(readEncryptedFile())

-- 32 bytes for use as a private key
local local_private = "2bf552944c4c48802615fdb0962dd1c4"

-- Compute local public key
local local_public = x25519.get_public_key(local_private);

writeKeyFile({base64.encode(local_public)})




local sender_public =    base64.decode("WwSt6TXD1qQJ3u4oJPJDCLg+WW0h2WwBLmigPPDwWRE=")

local shared_secret = x25519.get_shared_secret(local_private, sender_public);

local received_nonce = message:sub(1, 12);   -- First 12 bytes are the nonce
local received_mac = message:sub(13, 44);    -- Next 32 bytes are the MAC (BLAKE2s produces a 32-byte hash)
local received_ciphertext = message:sub(45); -- The rest is the ciphertext

-- local expected_mac = blake2s.digest(received_ciphertext, mac_key);
-- assert(received_mac == expected_mac, "MAC verification failed!");

local hkdf_salt = "0c39e186179ef4ec29a024dc5354c693db92ff7204a8d77327a0c8fbc28741cb"
local session_info = "ChaCha20 session key";
local session_key = hkdf.derive(shared_secret, hkdf_salt, session_info, 32);

local mac_info = "BLAKE2s MAC key";
local mac_key = hkdf.derive(shared_secret, hkdf_salt, mac_info, 32);

local expected_mac = blake2s.digest(received_ciphertext, mac_key);
-- assert(received_mac == expected_mac, "MAC verification failed!");

local cipher = ChaCha20.new(session_key, received_nonce);
local plaintext = cipher:apply_keystream(received_ciphertext);

shell.run("clear")
print("Private key  : " .. base64.encode(local_private));
print("Public key   : " .. base64.encode(local_public));
print("Shared Secret: " .. base64.encode(shared_secret));
print("Nonce        : " .. received_nonce)
print("Mac          : " .. received_mac)
print("Ciphertext   : " .. base64.encode(received_ciphertext));
print("Message      : " .. readEncryptedFile())
print("Plaintext    : " .. plaintext)
