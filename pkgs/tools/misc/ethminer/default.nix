{
  stdenv,
  fetchFromGitHub,
  opencl-headers,
  cmake,
  jsoncpp,
  boost,
  makeWrapper,
  cudatoolkit,
  mesa,
  ethash,
  opencl-info,
  ocl-icd,
  openssl,
  pkg-config,
  cli11
}:

stdenv.mkDerivation rec {
  pname = "ethminer";
  version = "0.19.0";

  src =
    fetchFromGitHub {
      owner = "ethereum-mining";
      repo = "ethminer";
      rev = "v${version}";
      sha256 = "1kyff3vx2r4hjpqah9qk99z6dwz7nsnbnhhl6a76mdhjmgp1q646";
      fetchSubmodules = true;
    };

  # NOTE: dbus is broken
  cmakeFlags = [
    "-DHUNTER_ENABLED=OFF"
    "-DETHASHCUDA=ON"
    "-DAPICORE=ON"
    "-DETHDBUS=OFF"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCUDA_PROPAGATE_HOST_FLAGS=off"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    cli11
    boost
    opencl-headers
    mesa
    cudatoolkit
    ethash
    opencl-info
    ocl-icd
    openssl
    jsoncpp
  ];

  preConfigure = ''
    sed -i 's/_lib_static//' libpoolprotocols/CMakeLists.txt
  '';

  postInstall = ''
    wrapProgram $out/bin/ethminer --prefix LD_LIBRARY_PATH : /run/opengl-driver/lib
  '';

  meta = with stdenv.lib; {
    description = "Ethereum miner with OpenCL, CUDA and stratum support";
    homepage = "https://github.com/ethereum-mining/ethminer";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nand0p ];
    license = licenses.gpl2;
    # Doesn't build with gcc9, and if overlayed to use gcc8 stdenv fails on CUDA issues.
    broken = true;
  };

}
