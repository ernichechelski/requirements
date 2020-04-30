class Requirements < Formula
  desc "Tool for generation raports of requirements fullfillment"
  homepage "https://github.com/ernichechelski/requirements"
  url "https://github.com/ernichechelski/requirements.git"
  version "0.0.0"
  depends_on :xcode => ["11.0", :build]

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/Requirements" "import Foundation\n"
  end
end
