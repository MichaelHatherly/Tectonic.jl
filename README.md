# Tectonic

![CI](https://github.com/MichaelHatherly/Tectonic.jl/workflows/CI/badge.svg)
[![Codecov](https://codecov.io/gh/MichaelHatherly/Tectonic.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/MichaelHatherly/Tectonic.jl)

Compile LaTeX files in Julia using the [*tectonic*][tectonic] typesetting
system. Also provides a [`biber`][biber] binary that is compatible with the
version of the `biblatex` package provided with *tectonic*.

## Binaries

This package wraps the official binaries for both bundled programs:

  - [*tectonic* `0.8.0`][tectonic-binaries] (MIT license)
  - [*biber* `2.14`][biber-binaries] (Artistic 2.0 license)

## Supported Operating Systems and Julia Versions

The package provides binaries for 64-bit Linux, MacOS, and Windows and has been
tested against Julia `1.3` to `1.8`.

## Examples

```
(@v1.6) pkg> add Tectonic

julia> using Tectonic

julia> tectonic() do bin
           run(`$bin file.tex`)
       end

```

## Using `biber` with `tectonic`

If you need to compile a document that contains `biblatex` then you will need
to provide the `biber` program to `tectonic` by adding it to the `PATH`. This
can be done by calling `Biber.biber` as follows

```
julia> biber() do _
           tectonic() do bin
               run(`$bin file.tex`)
           end
       end
```

If `biber` already exists on your `PATH` then calling `Tectonic.tectonic`
will find it automatically and use it.

[tectonic]: https://github.com/tectonic-typesetting/tectonic
[tectonic-binaries]: https://github.com/tectonic-typesetting/tectonic/releases

[biber]: https://github.com/plk/biber
[biber-binaries]: https://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/
