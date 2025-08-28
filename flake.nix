
{
  description = "Nix shell for Manim and Manim-Slides with uv, ruff, and basedpyright";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        # Custom TeXlive set with only the required packages for Manim
        manim-texlive = pkgs.texlive.withPackages (ps: with ps; [
          amsmath
          babel-english
          cbfonts-fd
          cm-super
          count1to
          ctex
          doublestroke
          dvisvgm
          everysel
          fontspec
          frcursive
          fundus-calligra
          gnu-freefont
          jknapltx
          latex-bin
          mathastext
          microtype
          multitoc
          physics
          preview
          prelim2e
          ragged2e
          relsize
          rsfs
          setspace
          standalone
          tipa
          wasy
          wasysym
          xcolor
          xetex
          xkeyval
        ]);
        in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            pkg-config # Required for pycairo to find cairo
            cairo # Native dependency for pycairo
            ffmpeg # Required for Manim video rendering
            manim-texlive # Customized TeXlive set for Manim
            pango # Required for text rendering in Manim
            libjpeg # Required for image handling in Manim
            zlib # Required for compression tasks
            uv # Python package manager
            ruff # Python linter
            basedpyright # Python type checker
            nushell # Better shell for me
            quarto # .qmd -> blog
          ];

          shellHook = ''
            echo "Nix shell with dependencies for Manim and Manim-Slides"
            echo "Tools included:"
            echo "  - uv: $(uv --version)"
            echo "  - ruff: $(ruff --version)"
            echo "  - basedpyright: $(basedpyright --version)"
            echo "  - LaTeX: Custom TeXlive set for Manim"
            echo "Use 'uv' to manage Python dependencies (e.g., 'uv add manim manim-slides[pyside6-full]')"
          '';
        };
      }
    );
}
