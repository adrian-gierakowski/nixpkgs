{ runCommand, python3, coreutils }:
paths: runCommand "layers-for-paths"
{
  exportReferencesGraph.graph = paths;
  __structuredAttrs = true;
  PATH = "${coreutils}/bin:${python3}/bin";
  builder = builtins.toFile "builder"
    ''
      . .attrs.sh
      python3 ${./closure-graph.py} .attrs.json graph > ''${outputs[out]}
    '';
  }
  ""
