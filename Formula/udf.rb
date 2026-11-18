class Udf < Formula
  desc "Local-first CLI for inspecting and exporting UYAP UDF documents"
  homepage "https://github.com/mobinova/udf"
  version "0.1.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_darwin_arm64.tar.gz"
      sha256 "133f7020c2e89a6153e6ed21b87c53f4cd1fd23d0d65df32f6a73ba6448f4e41" # udf:darwin_arm64
    end
    on_intel do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_darwin_amd64.tar.gz"
      sha256 "e541a0a96f6ac8961d89a9f629fda68f8d6de220fecf41ba04e59c8e89aebb47" # udf:darwin_amd64
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_linux_arm64.tar.gz"
      sha256 "57e977a36104fad5403bb6417327b27a9b908a830466dc36f025546e5c6b7105" # udf:linux_arm64
    end
    on_intel do
      url "https://github.com/mobinova/udf/releases/download/v#{version}/udf_#{version}_linux_amd64.tar.gz"
      sha256 "edcfaf35e0f25381323113ba28f0aa03ce8abddefbaa59b1dfd0d1e2080f7905" # udf:linux_amd64
    end
  end

  def install
    bin.install "udf"
  end

  test do
    assert_match "udf #{version}", shell_output("#{bin}/udf version")
  end
end
