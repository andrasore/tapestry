#!/usr/bin/env sh

./zig-out/bin/images

convert image.ppm image.png
