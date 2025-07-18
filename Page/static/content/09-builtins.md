In gGLSL, built-ins can simply be described as variables that are declared by Godot. They can be identified by their casing, where if their `FULL_CAPS`, you can usually assume you're dealing with a built-in. In all shader types (2D, 3D), you can use these built-ins:
- `TIME`: Global time in ms since the engine started 
- `PI`: Approximately 3
- `TAU`: 6.28318530717958647692528676655900576839433879875021164194988918461563281257241799725606965068423413596429617302656461329418768921910116446345071881625696223490056820540387704221111928924589790986076392885762195133186689225695129646757356633054240381829129713384692069722090865329642678721452049828254744917401321263117634976304184192565850818343072873578518072002266106109764093304276829390388302321886611454073151918390618437223476386522358621023709614892475992549913470377150544978245587636602389825966734672488131328617204278989279044947438140435972188740554107843435258635350476934963693533881026400113625429052712165557154268551557921834727435744293688180244990686029309917074210158455937851784708403991222425804392172806883631962725954954261992103741442269999999674595609990211946346563219263719004891891069381660528504461650668937007052386237634202000627567750577317506641676284123435533829460719650698085751093746231912572776470757518750391556371556106434245361322600385575322239181843284039787619051440213097172655773187230676365593646060390407060370593799154724519882778249944355056695826303114971448490830139190165906623372345571177815019676350927492987863851012080185540334227801969764802571672320712741532020942036388591119239789353567489
- `E`: Euler's number

Available in all 2D functions:
- `UV`: Already covered. Refer to <UV LINK HERE>

Available in 2D vertex functions:
- `VERTEX`: Current vertex position in local space (relative to mesh origin)
- `MODEL_MATRIX`: Local to World transform, to get the vertex position in the game world
- `CANVAS_MATRIX`: World to Canvas transform
- `SCREEN_MATRIX`: Canvas to Clip transform. Clip space coordinates range from `(1.0, 1.0)` to `(-1.0, -1.0)`.

Available in 2D fragment functions:
- `COLOR`: The color of the current fragment (pixel). By default it's set to the corresponding texture color. (TECHNICALLY `COLOR` is also available in the vertex function, except the use cases are extremely limited)
- `TEXTURE`: The texture on the current mesh. More info in the next section.
- `SCREEN_UV`: Screen space coordinates of a pixel

## How built-ins work
If we were to think of the shaders as GDScript functions, it might look like this:

```py
func fragment():
  color.r = 0.8
```

However, the way this function would be used might look like this:

```py
for pixel in pixels:
  color = pixel.color
  fragment()
  pixel.color = color
  # Same goes for every other built-in, and something similar happens with vertex shaders
```

## More built-ins 
This list only covers the common built-ins, and are the main ones you would be using for shaders (in 2D, more info on 3D later). However, a full list is available [here](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/canvas_item_shader.html#built-ins).

This chapter covers the basics of the gGLSL language, and the next chapter will cover more advanced uses of shaders, starting with textures.
