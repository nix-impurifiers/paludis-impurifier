# Testing

`nix flake check -L` runs emitter contracts and a real cave/QEMU test in pinned
Gentoo OpenRC userspace. The fixture uses Paludis's Portage configuration mode,
an EAPI 6-compatible minimal profile, and its documented sandbox-disable switch.
It validates solving, blockers, protected config on remove/reinstall and upgrade,
batching, lifecycle retries, accounts/directories, permission-only updates,
service administrator intent, native foreign-ROOT and wrapper guards, direct
phase activation, native driver dependencies and updates, removal and GC.

Nix and Python are preinstalled. This does not claim Exherbo boot or optional
PBINS functionality. Native source/license provenance lives in THIRD_PARTY.md.
