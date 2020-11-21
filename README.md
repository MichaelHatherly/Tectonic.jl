# Tectonic

![CI](https://github.com/MichaelHatherly/Tectonic.jl/workflows/CI/badge.svg)
[![Codecov](https://codecov.io/gh/MichaelHatherly/Tectonic.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/MichaelHatherly/Tectonic.jl)

Compile LaTeX files in Julia using the [*tectonic*][tectonic] typesetting
system. Also provides a [`biber`][biber] binary that is compatible with the
version of the `biblatex` package provided with *tectonic*.

## Binaries

This package wraps the official binaries for both bundled programs:

  - [*tectonic* `0.3.3`][tectonic-binaries] (MIT license)
  - [*biber* `2.14`][biber-binaries] (Artistic 2.0 license)

## Supported Operating Systems and Julia Versions

The package provides binaries for 64-bit Linux, MacOS, and Windows and has been
tested against Julia `1.3` to `1.5`.

## Examples

```
(@v1.5) pkg> add Tectonic

julia> using Tectonic

julia> tectonic() do bin
           run(`$bin file.tex`)
       end

julia> using Tectonic.Biber

julia> biber() do bin
           run(`$bin file`)
       end
```

## Using `biber` with `tectonic`

If you need to compile a document that contains `biblatex` then you will need
to rerun `tectonic` manually since it currently does not provide integrated use
with `biber`. To do this run

```julia
tectonic() do bin
    # We only need to run a single time, but actually keep the intermediate files.
    run(`$bin --keep-intermediates --reruns 0 file.tex`)
end
biber() do bin
    # Then run biber on those files.
    run(`$bin file`)
end
tectonic() do bin
    # And finally run tectonic again as normal to put it all together.
    run(`$bin file.tex`)
end
```

[tectonic]: https://github.com/tectonic-typesetting/tectonic
[tectonic-binaries]: https://github.com/tectonic-typesetting/tectonic/releases

[biber]: https://github.com/plk/biber
[biber-binaries]: https://sourceforge.net/projects/biblatex-biber/files/biblatex-biber/