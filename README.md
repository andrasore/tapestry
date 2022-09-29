# tapestry

This is a toy program for generating tiled wallpapers written in Zig. Currently WIP as I'm still experimenting with various language features.

## Build

I used the Zig compiler from the master branch. Use `nix-shell` to get the exact same version.

Run `zig-build` to build the program. Edit `main.zig` to set the dimensions for
the image, since they are compile time variables.

## Run

Invoke `run.sh` which will run the program and call `imagemagick` to convert the result into PNG.
