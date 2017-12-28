module Example exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Layout
import Task
import Window


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions _ =
    Window.resizes OnWindowSize


type alias Model =
    { windowSize : Window.Size
    , tab : Tab
    }


init : ( Model, Cmd Msg )
init =
    ( { windowSize = Window.Size 0 0
      , tab = Article (LayoutSettings 0 0 [ 1, 1 ])
      }
    , Task.perform OnWindowSize Window.size
    )


type Tab
    = Article LayoutSettings


type alias LayoutSettings =
    { gutterRight : Float
    , gutterBottom : Float
    , fractions : List Int
    }


type LayoutField
    = GutterRight String
    | GutterBottom String
    | Fractions String


type Msg
    = OnWindowSize Window.Size
    | UpdateArticle LayoutField


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnWindowSize size ->
            ( { model | windowSize = size }, Cmd.none )

        UpdateArticle field ->
            ( { model | tab = updateArticle field model.tab }, Cmd.none )


updateArticle : LayoutField -> Tab -> Tab
updateArticle field (Article settings) =
    let
        toInt string =
            String.toInt string |> Result.withDefault 1

        toFloat_ string =
            String.toFloat string |> Result.withDefault 1
    in
    case field of
        GutterRight value ->
            Article { settings | gutterRight = toFloat_ value }

        GutterBottom value ->
            Article { settings | gutterBottom = toFloat_ value }

        Fractions value ->
            Article { settings | fractions = List.map (toInt << String.trim) (String.split "," value) }


view : Model -> Html Msg
view model =
    main_ [ style [ ( "margin", "0 auto" ), ( "padding", "24px" ) ] ]
        [ nav [] []
        , div [] (Layout.columnVariable [ 1, 2, 3, 4 ] 2 htmlElements)

        -- , viewLayout model.tab
        ]


viewLayout : Tab -> Html Msg
viewLayout ((Article { gutterRight, gutterBottom, fractions }) as tab) =
    section []
        [ viewLayoutHeader tab
        , div [] (Layout.groupVariable fractions gutterRight gutterBottom [ viewArticle, viewArticle ])
        , viewArticle
        ]


viewLayoutHeader : Tab -> Html Msg
viewLayoutHeader (Article { gutterRight, gutterBottom, fractions }) =
    header []
        [ fieldset []
            [ label [] [ text "Gutter right" ]
            , input [ onInput (UpdateArticle << GutterRight) ] []
            ]
        , fieldset []
            [ label [] [ text "Gutter bottom" ]
            , input [ onInput (UpdateArticle << GutterBottom) ] []
            ]
        , fieldset []
            [ label [] [ text "Fractions" ]
            , input [ onInput (UpdateArticle << Fractions) ] []
            ]
        ]


viewArticle : Html Msg
viewArticle =
    article []
        [ h1 [] [ text "Elm Layout" ]
        , p [] [ text loremIpsum ]
        ]


viewAside : Int -> Html Msg
viewAside windowSize =
    aside [] [ text loremIpsum ]


viewRelated : Int -> Html Msg
viewRelated windowSize =
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
    , ( "Tomato", "100%" )
    , ( "Tomato", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "Tomato", "100%" )
    , ( "Violet", "100%" )
    , ( "SlateBlue", "100%" )
    , ( "Tomato", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "SlateBlue", "100%" )
    , ( "Tomato", "100%" )
    , ( "Violet", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "Tomato", "100%" )
    , ( "Violet", "100%" )
    , ( "SlateBlue", "100%" )
    , ( "Tomato", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "SlateBlue", "100%" )
    , ( "Tomato", "100%" )
    , ( "Violet", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "SlateBlue", "100%" )
    , ( "Tomato", "100%" )
    , ( "Violet", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "Tomato", "100%" )
    , ( "Violet", "100%" )
    , ( "SlateBlue", "100%" )
    , ( "Tomato", "100%" )
    , ( "MediumSeaGreen", "100%" )
    , ( "SlateBlue", "100%" )
    , ( "Tomato", "100%" )
    , ( "Violet", "100%" )
    , ( "MediumSeaGreen", "100%" )
    ]


loremIpsum : String
loremIpsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla congue est ut risus varius accumsan. Etiam eget fermentum risus, quis egestas tellus. Nam a tincidunt neque. Cras nec metus tincidunt, venenatis ante et, ultricies felis. Vestibulum commodo blandit placerat. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nullam in tempor tellus. Vestibulum enim est, blandit quis facilisis at, elementum eu justo. Vestibulum quis metus id lorem sagittis viverra fringilla id enim. Curabitur egestas sapien vitae justo sodales, nec sodales massa pulvinar. Quisque ac molestie ligula. Donec ipsum turpis, tristique eu ipsum nec, feugiat efficitur risus."
