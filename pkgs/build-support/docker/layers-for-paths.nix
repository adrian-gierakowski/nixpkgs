{ flattenReferencesGraph, runCommand, coreutils }:
{
  paths,
  strategy ? [],
}: runCommand "docker-layers-for-paths"
{
  exportReferencesGraph.graph = paths;
  __structuredAttrs = true;
  inherit strategy;
  # PATH = "${coreutils}/bin:${flattenReferencesGraph}/bin";
  PATH = "${flattenReferencesGraph}/bin";
  builder = builtins.toFile "docker-layers-for-paths-builder"
    ''
      . .attrs.sh
      flatten_references_graph .attrs.json > ''${outputs[out]}
    '';
  }
  ""
