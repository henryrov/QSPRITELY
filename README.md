What?
=====
A short script to encode grayscale 8x8 raw image files into C arrays, so they can be compiled into code for small embedded systems.

This is meant primarily as a tool for making sprites for use with an SSD1306 display. Because data is written to the display 8 bits at time corresponding to 8 pixels in a column, each generated array is transposed in relation to its source image to simplify transfers to the display.

How?
====
Run `./qspritely.sh <files>`. The result will be placed in "sprites.h" with each sprite named according to its original image file.

example.raw demonstrates the supported image encoding.