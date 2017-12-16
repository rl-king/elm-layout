module Example exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Masonry exposing (..)


-- Create a four row grid of Html elements with a gutter of 12px


main : Html msg
main =
    div [ style [ ( "padding", "12px" ) ] ] [ Masonry.grid 4 12 htmlElements ]


htmlElements : List (Html msg)
htmlElements =
    List.map element data


element : ( String, String ) -> Html msg
element ( color, height ) =
    div [ style [ ( "height", height ), ( "background-color", color ) ] ] []


data : List ( String, String )
data =
    [ ( "#333", "100px" )
    , ( "#666", "150px" )
    , ( "#666", "150px" )
    , ( "#999", "200px" )
    , ( "#333", "100px" )
    , ( "#333", "100px" )
    , ( "#666", "150px" )
    , ( "#999", "200px" )
    , ( "#333", "100px" )
    , ( "#999", "200px" )
    , ( "#999", "200px" )
    , ( "#333", "100px" )
    , ( "#999", "200px" )
    , ( "#666", "150px" )
    , ( "#333", "100px" )
    , ( "#666", "150px" )
    , ( "#999", "200px" )
    , ( "#333", "100px" )
    , ( "#333", "100px" )
    , ( "#666", "150px" )
    , ( "#999", "200px" )
    ]
