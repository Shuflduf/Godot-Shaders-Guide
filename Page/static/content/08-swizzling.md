In GLSL, you can access a part of a vector by putting a period, followed by the property you want to access, like this:
```c 
COLOR.g
```
This will let you access the green channel of the pixel color, so it can either be set or read. However, if you want to access two or more variables, you can either use the naive approach of setting each channel individually...
```c 
COLOR.g = 0.2;
COLOR.r = 0.5;
```
...Or, access the entire color variable:
```c 
COLOR = vec4(0.5, 0.2, COLOR.b, COLOR.a);
```
But with swizzling, you can access just the channels you want, in the order you want:
```c 
COLOR.rg = vec2(0.5, 0.2);
```
Another way of thinking about this is like this:
```c 
COLOR.rgba = vec4(COLOR.r, COLOR.g, COLOR.b, COLOR.a);
```
You can also use swizzling to bind the values of some parts to other parts, like this:
```c 
COLOR.rgb = COLOR.rrr;
// equivalent to:
COLOR.rgb = vec3(COLOR.r);
// equivalent to:
COLOR.rgb = vec3(COLOR.r, COLOR.r, COLOR.r);
// equivalent to:
COLOR = vec4(COLOR.r, COLOR.r, COLOR.r, COLOR.a);
```
Although in these examples I'm using the `COLOR` variable, the same applies to all vectors (`vec2`, `vec3`, etc.).
