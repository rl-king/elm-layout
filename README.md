#  Elm Layout
A package that makes it super easy to create grids, mosaics, collages, moodboards ect.

<img src="./example.png">

## Usage
For now there are just two styles: `column` and `row`. Both have this signature.
```elm 
column : Columns -> Gutter -> List (Html msg) -> Html msg
```
This should be quite self-explanatory, it takes an `Int` for the amount of colums, a `Float` for the amount of space inbetween the elements and the list of `Html msg` to display.  
