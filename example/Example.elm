module Example exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Layout
import Task
import Window


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


update : Msg -> Int -> ( Int, Cmd Msg )
update (OnWindowSize { width }) model =
    ( width, Cmd.none )


view : Int -> Html Msg
view windowWidth =
    main_ [ style [ ( "margin", "0 auto" ), ( "max-width", "1280px" ), ( "padding", "24px" ) ] ]
        [ div [] (Layout.columnVariable [ 2, 2 ] 12 htmlElements)
        , viewRelated windowWidth
        , div []
            (Layout.groupVariable (Layout.golden 3)
                12
                0
                [ viewArticle
                , viewAside windowWidth
                ]
            )
        ]


viewArticle : Html Msg
viewArticle =
    article []
        [ h1 [] [ text "Elm Layout" ]
        , p [] [ text loremIpsum ]
        ]


viewAside : Int -> Html Msg
viewAside windowWidth =
    aside [] (Layout.row 2 12 (List.take 4 htmlElements))


viewRelated : Int -> Html Msg
viewRelated windowWidth =
    section [] (Layout.row 6 12 htmlElements)


htmlElements : List (Html Msg)
htmlElements =
    List.indexedMap element data


element : Int -> ( String, String ) -> Html Msg
element index ( color, height ) =
    div []
        [ div [ style [ ( "padding-bottom", height ), ( "background-color", color ) ] ] [ text (toString index) ] ]


data : List ( String, String )
data =
    [ ( "SlateBlue", "100%" )
    , ( "Tomato", "75%" )
    , ( "Tomato", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "Tomato", "75%" )
    , ( "Violet", "100%" )
    , ( "SlateBlue", "75%" )
    , ( "Tomato", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "SlateBlue", "75%" )
    , ( "Tomato", "100%" )
    , ( "Violet", "100%" )
    , ( "MediumSeaGreen", "75%" )
    ]


loremIpsum : String
loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla congue est ut risus varius accumsan. Etiam eget fermentum risus, quis egestas tellus. Nam a tincidunt neque. Cras nec metus tincidunt, venenatis ante et, ultricies felis. Vestibulum commodo blandit placerat. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nullam in tempor tellus. Vestibulum enim est, blandit quis facilisis at, elementum eu justo. Vestibulum quis metus id lorem sagittis viverra fringilla id enim. Curabitur egestas sapien vitae justo sodales, nec sodales massa pulvinar. Quisque ac molestie ligula. Donec ipsum turpis, tristique eu ipsum nec, feugiat efficitur risus."
