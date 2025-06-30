In short, *shaders* are just functions that change the way something looks.

There are two main kinds of these functions: `vertex` and `fragment`. Each of these affect the resulting visual, but in their own ways. This guide will be going more in depth on each of these, but here's a quick summary.

## The Vertex Shader
The vertex shader runs once for each vertex in the target mesh. For example, a vertex shader on a standard cube would run 8 times, once for each corner in the cube.

## The Fragment Shader
The fragment shader runs once for each pixel covered by the target mesh. For example, a fragment shader on an image taking 50 pixels on the screen will run 50 times. 

In the shader editor on the right, you can see these two functions.

There are also other shader types, such as `light`, `start`, `process`, `sky`, and `fog`. This guide will mainly be focused on vertex and fragment shaders, as they are the most important.

