{
  description = "Verilog development environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin"; # most stable with x86 darwin

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages =
              with pkgs;
              [
                python3
                python3Packages.pip
                python3Packages.pytest
                verilator
                gtkwave
              ]
              ++ lib.optional (system == "x86_64-linux") python3Packages.cocotb # only accessable on x86 based linux machines otherwise follow windows install
              ++ lib.optional (system != "x86_64-darwin") iverilog; # iverilog cannot be installed (for some reason) on x86_64 darwin/MacOS, ggs
          };
        }
      );
    };
}
