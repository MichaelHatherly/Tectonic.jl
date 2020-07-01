# Tectonic

[![Build Status](https://travis-ci.org/MichaelHatherly/Tectonic.jl.svg?branch=master)](https://travis-ci.org/MichaelHatherly/Tectonic.jl)
[![Codecov](https://codecov.io/gh/MichaelHatherly/Tectonic.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/MichaelHatherly/Tectonic.jl)

Compile LaTeX files in Julia using the [tectonic](https://github.com/tectonic-typesetting/tectonic) typesetting system.

```
(@v1.4) pkg> add https://github.com/MichaelHatherly/Tectonic.jl

julia> using Tectonic

julia> run(`$(tectonic()) file.tex`)
```
