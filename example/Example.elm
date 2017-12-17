module Example exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Layout
import Task
import Window


-- Create a four row grid of Html elements with a gutter of 12px


main : Program Never Int Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Int -> Sub Msg
subscriptions _ =
    Window.resizes OnWindowSize


init : ( Int, Cmd Msg )
init =
    ( 0, Task.perform OnWindowSize Window.size )


type Msg
    = OnWindowSize Window.Size


update : Msg -> Int -> ( Int, Cmd msg )
update (OnWindowSize { width }) model =
    ( width, Cmd.none )


view : Int -> Html Msg
view windowWidth =
    div [ style [ ( "padding", "12px" ) ] ]
        [ Layout.column (Layout.responsive windowWidth) 12 htmlElements
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
    , ( "#999", "200px" )
    ]
