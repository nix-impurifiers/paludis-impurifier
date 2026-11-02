# Native tooling

`nix/tools.nix` builds Paludis from the pinned official
https://gitlab.exherbo.org/paludis/paludis source. GPL-2.0-only notices remain
upstream. Build adjustments patch interpreter locations, select the standard
/etc configuration directory, generate prerequisite headers before parallel
compilation, and supply offline documentation catalogs. These do not alter the
native dependency resolver or package ownership rules.

The real eselect shell framework is extracted from the pinned Gentoo stage3
fixture, with its data path and interpreter adjusted for the Nix store. Its
upstream notices remain in the extracted files. No manager executable is mocked.
