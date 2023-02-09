class SaneBackends < Formula
  desc "Backends for scanner access"
  homepage "http://www.sane-project.org/"
  url "https://gitlab.com/sane-project/backends/uploads/110fc43336d0fb5e514f1fdc7360dd87/sane-backends-1.2.1.tar.gz"
  sha256 "f832395efcb90bb5ea8acd367a820c393dda7e0dd578b16f48928b8f5bdd0524"
  license "GPL-2.0-or-later"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "e9969c0a40d3a0d9635231908a44c548cdb3e54bb35619f92a440a9585fd11b3"
    sha256 arm64_monterey: "1d403d6940c131a753c2305a830bb56599b733158edb3810e349a2c9a6fbcf54"
    sha256 arm64_big_sur:  "597dbfeb7517f0b6d3a8c320fb3acbeb152cf74be7f91538ecb847a49e9ea53c"
    sha256 ventura:        "0d3615b6c44a42b21403fcfa2ab296cfdcc6547d48defc196bc03c003f28c934"
    sha256 monterey:       "5c2ba0815984ffc9597884db2b1fc13f1677a5dea344c73e0c090bf99cd8974b"
    sha256 big_sur:        "381d3502dc3cd2c22e95e8a870578891b0da3580b800e70ab061029c47b52873"
    sha256 catalina:       "b0d4a34cc8c506c4fc024edfdf13e5a1be13a551aaef21dfae8d8ffec3c2f93f"
    sha256 x86_64_linux:   "be8cdd2d42cc791ba9773007c905ed73abeb3873e5d53cc1cc628ac4084f61d4"
  end

  head do
    url "https://gitlab.com/sane-project/backends.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "autoconf-archive" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libusb"
  depends_on "net-snmp"
  depends_on "openssl@1.1"

  uses_from_macos "python" => :build
  uses_from_macos "libxml2"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--localstatedir=#{var}",
                          "--without-gphoto2",
                          "--enable-local-backends",
                          "--with-usb=yes"
    system "make", "install"
  end

  def post_install
    # Some drivers require a lockfile
    (var/"lock/sane").mkpath
  end

  test do
    assert_match prefix.to_s, shell_output("#{bin}/sane-config --prefix")
  end
end
