require 'package'

class Openssl < Package
  description 'OpenSSL is an open source project that provides a robust, commercial-grade, and full-featured toolkit for the Transport Layer Security (TLS) and Secure Sockets Layer (SSL) protocols.'
  homepage 'https://www.openssl.org/'
  version '1.0.2k'

  source_url 'ftp://openssl.org/source/openssl-1.0.2k.tar.gz'
  source_sha1 '5f26a624479c51847ebd2f22bb9f84b3b44dcb44'

  depends_on 'perl'
  depends_on 'zlibpkg'

  def self.build
    options="shared zlib-dynamic"
    if `uname -m`.strip == 'aarch64'
      options = options + " no-asm"
    end
    system "./config --prefix=/usr/local --openssldir=/etc/ssl #{options}"
    system "make"
  end

  def self.install
    # installing using multi cores may cause empty libssl.so.1.0.0 or libcrypto.so.1.0.0 problem
    system "make", "-j1", "INSTALL_PREFIX=#{CREW_DEST_DIR}", "install"

    # remove all files pretended to install /etc/ssl (use system's /etc/ssl as is)
    system "rm", "-rf", "#{CREW_DEST_DIR}/etc"
  end

end
