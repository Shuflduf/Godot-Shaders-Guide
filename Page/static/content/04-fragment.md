You can think of the fragment shader as a function that runs on each for each pixel that the target mesh is covering. For example, the GDScript version of a fragment shader that sets the color looks like this:
```py
for x in range(width):
  for y in range(height):
    set_color(x, y, some_color)
```
As you can see, it loops over each pixel in the range, and sets it to be `some_color`. The shader version of this would be:
```c
void fragment() {
  COLOR = some_color;
}
```
The fragment shader automatically loops over each pixel in the range, and the `COLOR` variable of the pixel gets set to `some_color`.

## The `COLOR` Variable 
This variable is defined as a four-dimensional vector, which is just a list of four numbers. In terms of `COLOR`, the four parts are `r`, `g`, `b`, and `a`, which represent the different color channels in a pixel. However, these parts can also be accessed with `x`, `y`, `z`, and `w`, in that order. The purpose of this naming convention will be explained in <FUTURE CHAPTER HERE>.

In gGLSL, vectors can be created using the `vecx()` functions, where `x` is the dimension of the vector (ex. `vec3()` for a three-dimensional vector).

Try putting this statement inside of your fragment shader:
```c 
COLOR = vec4(0.0, 0.0, 1.0, 1.0);
```
To break this down, the first parameter of `vec4()` is the `r` value, which in this case is `0.0`, which means there's nothing in the red channel of the pixel. The second parameter is the `g` value, which is also `0.0`, which means nothing in the green channel. The `b` parameter is `1.0`, meaning the blue channel is full. The last value is for the alpha channel, which is also full. The resulting vector represents a blue color, since only the blue and alpha channels have parts.

Normally in computer graphics, these values are expressed as an integer between 0 and 255, but gGLSL expresses these values as a floating-point value between 0 and 1.

Just like in GDScript (and other programming languages), you can also get existing variables, along with setting them. Try putting this statement in your fragment shader:
```c 
COLOR = vec4(COLOR.r, 1.0, COLOR.b, COLOR.a);
```
This shader leaves the existing red, blue, and alpha channels, and sets the green channel to `1.0`, resulting in a very green Godot. Alternatively, you can simply use this statement for the same result:
```c 
COLOR.g = 1.0;
```
After all, `COLOR` is just a vector, and each part can be changed by itself.

This topic covers the very basics of fragment shaders in 2D, and the next topic will cover a more advanced use of this shader: UV Maps.
