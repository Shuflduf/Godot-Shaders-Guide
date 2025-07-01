Godot is a hybrid 2D-3D game engine, which means it supports both 2D and 3D games. To account for this, Godot has two different shader modes: `spatial`, for 3D objects, and `canvas_item`, for 2D objects.

A shader can be labelled as either of these, by using the `shader_type` keyword at the top of the code. In the editor, you can see it's a 2D shader by the fact that it has this at the top:

```c
shader_type canvas_item;
 ``` 

To apply a shader to a node in Godot, you will have to use the `material` property. The engine already has the shader code linked to the material, but if you want to setup a new shader yourself in Godot, follow these instructions:
> ## Godot Shader Setup 
1. Select the node which you want the shader to apply to. This could be any node which inherits from `CanvasItem` (for 2D), or `GeometryInstance3D` (for 3D)
2. Find the `material` property on the node
  - In 2D, this is under `CanvasItem` > `Material` > `Material`
  - In 3D, this is under `GeometryInstance3D` > `Geometry` > `Material Override`
3. Click on the property (where it says "\<empty>"), and click "New ShaderMaterial"
4. In the newly created `ShaderMaterial`, create a new shader by clicking where it says "\<empty>"
5. Call the shader whatever you want. In my case, I called it `my_own_shader`:
<image here>
6. The shader editor should open at the bottom of the editor, making any changes to the code and saving will update the changes in the viewport

Continue to the next chapter to learn more about fragment shaders.
