gGLSL is a programming language, and like all other programming languages, you can take advantage of various tools to make writing code simpler and easier.

## Variables
gGLSL variables take the form of:
```c 
type name = value;
```
For example, to declare an integer, you would use this statement:
```c 
int my_int = 53;
```
And to declare a floating-point number, you would use this statement:
```c 
float my_float = 0.3;
```
You can these use these variables in your shader code, like this:
```c 
COLOR.b = my_float;
```
### Common Shader Types
`bool`: `true` or `false`
`int`: signed integer
`vecX`: vector with X dimensions (`vec2`)
`ivecX`: integer vector with X dimensions (`ivec2`)
`float`: floating-point number (scalar)
`sampler2D`: basically just a 2D texture
`sampler3D`: basically just a 3D texture

### Uniforms
Declaring a variable at the top level using the `uniform` keyword will allow that variable to be changed in the Godot property editor. Try putting this statement in your code, below the `shader_type` declaration, and notice how a new property is available below the editor to change.
```c 
uniform float my_uniform_float = 0.2;
```
Then try using this variable in your code somewhere else, such as your fragment shader:
```c 
COLOR.b = my_uniform_float;
```
Changing the uniform property will update the shader with the new value, which is very useful for quickly changing small things about how a shader works to instantly see how it will affect the result, without needing to manually edit the code.

### Constants
Use the `const` keyword before the type:
```c 
const int my_const_integer = 83;
```
### Arrays
```c
type name[X] = { val, val };
```
Example:
```c 
float my_float_arr[3] = { 0.2, 0.5, 1.0 };
```
Arrays can be accessed like so, starting for index 0 for the first element, like in GDScript:
```c 
float my_val = my_float_arr[1];
```

## Functions
gGLSL functions take the form of:
```c 
type name(args) {
  return type;
}
```
For example, a sum function can be written as such:
```c 
float sum(float a, float b) {
  return a + b;
}
```
And it can be used like so:
```c 
COLOR.r = sum(COLOR.b, 0.2);
```
> [!NOTE]
> Functions have to be declared above where they are used, unlike in GDScript.

### Built-in Functions 
The various trig functions:
- `sin()`
- `cos()`
- `tan()`
- etc...
All the construction functions, one for each type:
- `radians(degrees)`
- `degrees(radians)`
- `float()`
- `int()`
- etc...
Math functions:
- `pow()`
- `sqrt()`
- `abs()`
- `sign()`
- `floor()`
- `round()`
- `ceil()`
- `mod()`
- `min()`
- `max()`
- `clamp()`
- `step()` (b < a ? 0.0 : 1.0)
- etc...

## Operators
*Ranked in Priority*
- `()` (Grouping)
- `!` (Not)
- `-` (Negative)
- `*` (Multiply)
- `/` (Division)
- `<`, `>`, `<=`, `>=` (Relational Comparison)
- `==`, `!=` (Equality Comparison)
- `&&` (And)
- `||` (Or)

## Flow Control 
### If/Else
```c 
if (cond) {

} else if (other_cond) {

} else {

}
```
### Ternary Operator 
*aka inline if*
```c 
int result = cond ? 9 : 5;
```
### For Loop 
```c 
for (int i = 0; i < 10; i++) {

}
```
### While Loop 
```c
while (cond) {

}
```

## Comments
```c 
// Single line comments

/*
Multi 
Line 
Comments
*/
```

The next topic will cover **swizzling**, a small but useful feature of gGLSL.
