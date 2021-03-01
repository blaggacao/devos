{ name, nixos }: final: prev: {
  "${name}" = {
    lib = import ../lib { inherit nixos; };
    # put your further packages here
  };
}
