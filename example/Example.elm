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
    div [ style [ ( "padding", "48px" ) ] ]
        [ Layout.group 48
            [ Layout.column (Layout.responsive windowWidth) 12 htmlElements
            , Layout.row 3 12 htmlElements
            ]
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
    [ ( "SlateBlue", "100px" )
    , ( "Tomato", "150px" )
    , ( "Tomato", "150px" )
    , ( "MediumSeaGreen", "200px" )
    , ( "Tomato", "150px" )
    , ( "Violet", "300px" )
    , ( "SlateBlue", "100px" )
    , ( "Tomato", "150px" )
    , ( "MediumSeaGreen", "200px" )
    , ( "SlateBlue", "100px" )
    , ( "Tomato", "150px" )
    , ( "Violet", "300px" )
    , ( "MediumSeaGreen", "200px" )
    ]
