{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    packages.${system} = {
      watch = pkgs.writeShellApplication {
        name = "watch";
        text = ''
          ${pkgs.typst}/bin/typst \
            --watch \
            doc.typ \
            doc.pdf
        '';
      };

      default = pkgs.stdenvNoCC.mkDerivation {
        name = "typst-todo";

        src = pkgs.lib.cleanSource ./.;

        buildPhase = ''
          runHook preBuild
          ${pkgs.typst}/bin/typst \
            --root $src \
            $src/doc.typ \
            doc.pdf
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          install -m644 -D *.pdf --target $out/
          runHook postInstall
        '';
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        typst
      ];
    };
  };
}
