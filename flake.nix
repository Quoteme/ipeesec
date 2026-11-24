{
  description = "iPeeSec: a formally correct IPsec implementation";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          # Symbola (the \emoji fallback font) has an unfree license.
          config.allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) [ "symbola" ];
        };
        tex = pkgs.texliveFull;
        # XeLaTeX looks fonts up by name through fontconfig (see latex/imports.tex):
        # TeX Gyre Pagella (main), JuliaMono (\texttt, minted), Symbola (\emoji).
        fonts = pkgs.makeFontsConf {
          fontDirectories = [
            "${tex}/share/texmf/fonts/opentype"
            pkgs.julia-mono
            pkgs.symbola
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          name = "ipeesec";
          packages = with pkgs; [
            # Lean 4 + mathlib (elan reads ./lean-toolchain)
            elan
            git
            curl
            # LaTeX (latexmk + xelatex + biber, minted via pygments)
            tex
            python3Packages.pygments
          ];
          FONTCONFIG_FILE = fonts;
        };
      }
    );
}
