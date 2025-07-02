The `vertex` function in a Godot shader runs once per vertex in the mesh, unlike fragment shaders which run on every pixel.

In the default sprite used in the engine on the right, the mesh has 4 verticies, one in each corner.

This means that the vertex function will run four times, once on each vertex.

To start using vertex shaders, use the `VERTEX` keyword, which is a two-dimensional vector, with an `x` part and a `y` part. For example, to move the sprite to the left, you can use this statement inside of the vertex shader: 
```c 
VERTEX = vec2(VERTEX.x + 20.0, VERTEX.y);
```
This moves each vertex 20 pixels to it's left, which moves the resulting image 20 pixels to the left. This can also be simplified to this statement:
```c 
VERTEX.x += 20.0;
```
It is also possible to multiply the vertex position to stretch the mesh, like so:
```c 
VERTEX.x *= 2.0;
```
You can also use UV maps to change the vertex position based on where the vertex is:
```c 
VERTEX.y *= UV.x + 1.0;
```
Notice how the sprite deforms in this case, since the two triangles that make up the mesh are scaled differently, it affects the sprite not as would be expected.

Compared to fragment shaders, vertex shaders are much simpler, since all they do is adjust the positions of the verticies that make up the mesh. The next chapter will expand more on gGLSL, and what tools you can use to write shaders.
