{ bionix
, flags ? null
, outfmt ? null
}:

inputs:

with bionix;
with lib;

let
  inherit (bionix.types) matchFiletype matchSorting;
  inputIsHomogenous = length (unique (map (matchFiletype "samtools-merge" {bam = x: x // {sorting = matchSorting "samtools-merge" {coord = _: "coord";} x;};}) inputs)) == 1;
in

assert inputIsHomogenous;

stage {
  name = "samtools-merge";
  buildInputs = with pkgs; [ samtools ];
  buildCommand = ''
    samtools merge ${optionalString (flags != null) flags} $out ${concatStringsSep " " inputs}
  '';
  passthru.filetype = (builtins.elemAt inputs 0).filetype;
}
