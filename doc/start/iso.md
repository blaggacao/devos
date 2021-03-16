# ISO

Making and writing an installable iso for `hosts/NixOS.nix` is as simple as:
```sh
flk iso NixOS

dd bs=4M if=result/iso/*.iso of=/dev/$your_installation_device \
  status=progress oflag=sync
```

This works for any file matching `hosts/*.nix` excluding `default.nix`.

## Remote access to the live installer

The iso live installer comes preconfigured with a network configuration
which announces it's hostname via [MulticastDNS][mDNS] as `hostname.local`, 
that is `NixOS.local` in the above example.

In the rare case that [MulticastDNS][mDNS] is not availabe or turned off
in your network, there is a static link-local IPv6 address configured to
`fe80::47`(mnemonic from the letter's position in the english alphabet:
`n=14 i=9 x=24; 47 = n+i+x`).

Provided that you have added your public key to the authorized keys of the
`nixos` user, you can ssh into the live installer through one of the 
following options:

```console
ssh nixos@NixOS.local

ssh nixos@fe80::47%eno1  # where eno1 is your network interface on which you are linked to the target
```

_Note: the [static link-local IPv6 address][staticLLA] and [MulticastDNS][mDNS] is only
configured on the live installer. If you wish to enable [MulticastDNS][mDNS]
for your environment, you ought to configure that in a regular [profile](../../profiles)._

## EUI-64 LLA & Host Identity

The iso's IPv6 Link Local Address (LLA) is configured with a static 64-bit Extended
Unique Identifiers (EUI-64) that is derived from the host interface's Message
Authentication Code (MAC) address.

***This LLA is stable for the host, unless you need to swap that particular network card.*** 
Under this reservation, though, you may use this EUI-64 to wire up a specific
(cryptographic) host identity.

After a little while (a few seconds), you can remotely disvover this unique and host
specific address over [NDP][NDP] for example with:

```console
ip -6 neigh show # also shows fe80::47
```

## Bootstrap Target Machine

Once your target host has booted into the live iso, you need to partion
and format your disk according to the [official manual][manual].

Then properly mount the formatted partitions at `/mnt`, so that you can
install your system to those new partitions.

Mount `nixos` partition to `/mnt` and &mdash; for UEFI &mdash; `boot` 
partition to `/mnt/boot`:

```console
$ mount /dev/disk/by-label/nixos /mnt
$ mkdir -p /mnt/boot && mount /dev/disk/by-label/boot /mnt/boot # UEFI only
$ swapon /dev/$your_swap_partition
```

_Note: nothing prevents you from executing those command remotely._


### On the target machine

Install using the `flk` wrapper baked into the iso off of a copy of devos 
from the time the iso was built:

```console
$ cd /iso/devos
$ nix develop
$ flk install NixOS --impure # use same host as above
```

<!-- TODO: find out why --impure is necesary / PRs welcome! -->

_Note: You _could_ install another machine than the one your iso was built for,
but the iso doesn't carry all the necesary build artifacts so the target would
start to build the missing parts on demand instead of substituting them from
the iso itself._

<!--
### From a remote

From within the devshell:

```console
deploy "flk#NixOS" --ssh-user nixos --hostname NixOS.local # or, if multicastDNS fails:
deploy "flk#NixOS" --ssh-user nixos --hostname [fe80::47%eno1]
```

The latter option is currently blocked by [Nix Issue 4643](https://github.com/NixOS/nix/issues/4643).

TODO: The former did not complete on my machine as the MulticastDNS seemed to be too unstable.
-->

[manual]: https://nixos.org/manual/nixos/stable/index.html#sec-installation-partitioning
[mDNS]: https://en.wikipedia.org/wiki/Multicast_DNS
[NDP]: https://en.wikipedia.org/wiki/Neighbor_Discovery_Protocol
[staticLLA]: https://tools.ietf.org/html/rfc7404
