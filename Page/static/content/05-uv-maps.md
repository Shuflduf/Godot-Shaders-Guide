UV maps are a texture of each mesh that represents the position of the pixel, relative to the model.

The UV map starts at the top left, with positive x going right, and positive y going down. You can access the UV map in shaders by using the `UV` variable in the fragment shader. This statement will help visualize the UV map:
```c 
COLOR = vec4(UV.x, UV.y, 0.0, 1.0);
```
The `x` part of the `UV` gets bound to the `r` part of `COLOR`, meaning the more left the pixel is, the more red it is. A similar effect happens with the `y` part getting bound to the green channel, making it more green the further down the pixel is. It also sets the blue and alpha channels to not interfere with the UV map.

This can be used for various effects, such as making it darker the closer it is to the side, which can be done with this fragment shader:
```c 
COLOR = vec4(COLOR.rgb - UV.x, COLOR.a);
```
*evil godot >:)*

More info on how UV maps can be used can be found in <FUTURE TOPICS>

These were the basics of fragment shaders in Godot. The next chapter will discuss more about vertex shaders.
