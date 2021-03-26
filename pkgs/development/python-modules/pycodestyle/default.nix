{ buildPythonPackage
, fetchPypi
, lib
, python
}:

buildPythonPackage rec {
  pname = "pycodestyle";
  version = "2.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vqwmzmjdv331kmfq3q9j3as2x7r2r49lf83r9w4147pdg8c32f3";
  };

  dontUseSetuptoolsCheck = true;

  # https://github.com/PyCQA/pycodestyle/blob/2.5.0/tox.ini#L14
  checkPhase = ''
    ${python.interpreter} pycodestyle.py --max-doc-length=72 --testsuite testsuite
    ${python.interpreter} pycodestyle.py --statistics pycodestyle.py
    ${python.interpreter} pycodestyle.py --max-doc-length=72 --doctest
    ${python.interpreter} -m unittest discover testsuite -vv
  '';

  meta = with lib; {
    description = "Python style guide checker (formerly called pep8)";
    homepage = "https://pycodestyle.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [
      kamadorueda
    ];
  };
}
