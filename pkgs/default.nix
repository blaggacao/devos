{ name }: final: prev: {
  "${name}" = {
    lib = import ../lib { pkgs = prev; };
    # put your further packages here
  };
}
