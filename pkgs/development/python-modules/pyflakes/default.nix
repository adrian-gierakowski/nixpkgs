{ lib, buildPythonPackage, fetchPypi, pythonOlder, unittest2 }:

buildPythonPackage rec {
  pname = "pyflakes";
  version = "2.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vw0r2ac56h8254d7rhfdr8s00qjfnjfb1c83f7kb275a3kxi7z5";
  };

  checkInputs = [ unittest2 ];

  # some tests are output dependent, which have changed slightly
  doCheck = pythonOlder "3.9";

  meta = with lib; {
    homepage = "https://launchpad.net/pyflakes";
    description = "A simple program which checks Python source files for errors";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
