#  Elm Masonry
Simple masonry grid layout.

<img src="./example.png">

## Usage
For now there is only one function: `grid`.

With this type signature.
```elm 
grid : Columns -> Gutter -> List (Html msg) -> Html msg
```
This should be quite self-explanatory, it takes an `Int` for the amount of colums, a `Float` for the amount of space inbetween the colums and the list of `Html msg` to display.  

## Future
It would be nice if this library contains more alternate ways to layout elements on a page, suggestions are welcome. 