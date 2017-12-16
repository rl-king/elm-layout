module Example exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Layout


-- Create a four row grid of Html elements with a gutter of 12px


main : Html msg
main =
    div [ style [ ( "padding", "12px" ) ] ]
        [ Layout.column 3 12 htmlElements
        , Layout.row 3 12 htmlElements
        ]


htmlElements : List (Html msg)
htmlElements =
    List.indexedMap element data


element : Int -> ( String, String ) -> Html msg
element index ( color, height ) =
    div []
        [ div [ style [ ( "height", height ), ( "background-color", color ) ] ] [ text (toString index) ] ]


data : List ( String, String )
data =
    [ ( "#333", "100px" )
    , ( "#666", "150px" )
    , ( "#666", "150px" )
    , ( "#999", "200px" )
    , ( "#666", "150px" )
    , ( "#999", "300px" )
    , ( "#666", "150px" )
    , ( "#666", "150px" )
    , ( "#999", "200px" )
    , ( "#999", "300px" )
    , ( "#666", "150px" )
    , ( "#999", "200px" )
    ]
