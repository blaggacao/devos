# Quick Start
The only dependency is nix, so make sure you have it [installed][install-nix].

## Get the Template
Here is a snippet that will get you the template without the git history:
```sh
nix-shell https://github.com/nrdxp/nixflk/archive/core.tar.gz -A shell \
  --run "flk get core"

cd flk

nix-shell

git init
git add .
git commit -m init

cachix use nrdxp
```

This will place you in a new folder named `flk` with git initialized, and a
nix-shell that provides all the dependencies, including the unstable nix
version required.

In addition, the [binary cache](../../cachix) is added for faster deployment.

> ##### _Notes:_
> - You can change `core` to [`community`](../../index.md#community-profiles)
>   in the call to `flk get`
> - Flakes ignore files that have not been added to git, so be sure to stage new
>   files before building the system.

## Next Steps:
- [Make installable ISO](./iso.md)
- [Already on NixOS](./from-nixos.md)


[install-nix]: https://nixos.org/manual/nix/stable/#sect-multi-user-installation