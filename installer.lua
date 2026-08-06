local paths = {
  ['rednet_secure.lua'] = 'https://github.com/Legomountain14/rednet_secure/releases/latest/download/rednet_secure.lua',
  ['share_keys.lua'] = 'https://github.com/Legomountain14/rednet_secure/releases/latest/download/share_keys.lua',



  ['crypto/hkdf.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/crypto/hkdf.lua',
  ['crypto/blake2s/blake2s.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/crypto/blake2s/blake2s.lua',
  ['crypto/blake2s/blake2s-kat.txt'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/crypto/blake2s/blake2s-kat.txt',
  ['crypto/chacha20/chacha20.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/crypto/chacha20/chacha20.lua',
  ['crypto/chacha20/chacha20core.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/crypto/chacha20/chacha20core.lua',
  ['crypto/chacha20/chacha20rng.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/crypto/chacha20/chacha20rng.lua',
  ['crypto/chacha20/xchacha20.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/crypto/chacha20/xchacha20.lua',
  ['crypto/x25519/x25519.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/crypto/x25519/x25519.lua',

  ['util/misc.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/util/misc.lua',
  ['util/base64/base64.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/util/base64/base64.lua',
  ['util/bitops/bitops.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/util/bitops/bitops.lua',

  ['util/bitops/lookup_tables/u8_and.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/util/bitops/lookup_tables/u8_and.lua',
  ['util/bitops/lookup_tables/u8_or.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/util/bitops/lookup_tables/u8_or.lua',
  ['util/bitops/lookup_tables/u8_xor.lua'] = 'https://raw.githubusercontent.com/BernhardZat/pure-lua-5.1-crypto/refs/heads/main/util/bitops/lookup_tables/u8_xor.lua',
}

for path, url in pairs(paths) do
  local logicalPath = shell.resolve(path)

  print('Downloading ' .. path .. ' from ' .. url)

  local response = http.get(url)

  if response then
    local file = fs.open(logicalPath, 'w')
    file.write(response.readAll())
    file.close()
  end
end

print('Done!')