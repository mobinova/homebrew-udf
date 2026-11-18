class Udf < Formula
  desc "Local-first CLI for inspecting and exporting UYAP UDF documents"
  homepage "https://github.com/mobinova/udf"
  version "0.2.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_darwin_arm64.tar.gz"
      sha256 "2edce3f0f102d83722524362542af160c0b45fc14c5614103823a20188ed7e4e" # udf:darwin_arm64
    end
    on_intel do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_darwin_amd64.tar.gz"
      sha256 "af758c133b0f6b974ed976e5f102f2134577dfb562d92f10c8412ad4b2d57782" # udf:darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_linux_arm64.tar.gz"
      sha256 "aef042840a6da6ad916d946809a2bf2dd05174ad9b76b963abe13010e595b8a9" # udf:linux_arm64
    end
    on_intel do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_linux_amd64.tar.gz"
      sha256 "b22ffc1f8264c52a1e385cdd4da573fca7c137aa34af530627a87999e7f97dac" # udf:linux_amd64
    end
  end

  def install
    bin.install "udf"
  end

  test do
    assert_match "udf #{version}", shell_output("#{bin}/udf version")
  end
end
