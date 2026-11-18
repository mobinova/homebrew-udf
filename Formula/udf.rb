class Udf < Formula
  desc "Local-first CLI for inspecting and exporting UYAP UDF documents"
  homepage "https://github.com/mobinova/udf"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_darwin_arm64.tar.gz"
      sha256 "5da1e83db744a7b8527ecff0d7f22cee80d43dd3cafac023ed51b83a4cac517f" # udf:darwin_arm64
    end
    on_intel do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_darwin_amd64.tar.gz"
      sha256 "260886c12990d739c2b6579105122778ba4305e83007f48907611d61ee8a5523" # udf:darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_linux_arm64.tar.gz"
      sha256 "eacbc7ecb63d939bc7acf6c48290b948217208a0de45a8e22909aad9edfed676" # udf:linux_arm64
    end
    on_intel do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_linux_amd64.tar.gz"
      sha256 "fe38ba0e1f37b898d0ff090de0f7af43a2c312c394c7d4b7604f704cf6e6c04b" # udf:linux_amd64
    end
  end

  def install
    bin.install "udf"
  end

  test do
    assert_match "udf #{version}", shell_output("#{bin}/udf version")
  end
end
