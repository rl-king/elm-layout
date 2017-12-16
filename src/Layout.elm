module Layout exposing (Columns, Gutter, column, row)

{-|

@docs Columns
@docs Gutter
@docs column
@docs row

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import List.Extra exposing (greedyGroupsOf, transpose)


{-| -}
type alias Columns =
    Int


{-| -}
type alias Gutter =
    Float


{-| -}
column : Columns -> Gutter -> List (Html msg) -> Html msg
column columns gutter elements =
    let
        colums =
            transpose (greedyGroupsOf columns elements)

        columnsAsFloat =
            toFloat columns

        getMargin index =
            if index + 1 == columns then
                0
            else
                gutter

        columnStyle margin =
            style
                [ ( "list-style", "none" )
                , ( "margin-top", "0" )
                , ( "margin-bottom", "0" )
                , ( "padding", "0" )
                , ( "float", "left" )
                , ( "margin-right", toString margin ++ "px" )
                , ( "width"
                  , "calc("
                        ++ toString (100 / columnsAsFloat)
                        ++ "% - "
                        ++ toString (gutter * (columnsAsFloat - 1) / columnsAsFloat)
                        ++ "px"
                  )
                ]
    in
    div
        []
        (List.indexedMap
            (\index column ->
                ul
                    [ columnStyle (getMargin index) ]
                    (List.map (columnItem gutter) column)
            )
            colums
        )


columnItem : Gutter -> Html msg -> Html msg
columnItem gutter element =
    li
        [ style [ ( "margin-bottom", toString gutter ++ "px" ) ] ]
        [ element ]


{-| -}
row : Columns -> Gutter -> List (Html msg) -> Html msg
row columns gutter elements =
    let
        colums =
            greedyGroupsOf columns elements

        columnsAsFloat =
            toFloat columns

        getMargin index =
            if index + 1 == columns then
                0
            else
                gutter

        columnStyle =
            style
                [ ( "list-style", "none" )
                , ( "margin-top", "0" )
                , ( "margin-bottom", "0" )
                , ( "padding", "0" )
                , ( "width", "100%" )
                , ( "clear", "both" )
                ]
    in
    div [] (List.map (ul [ columnStyle ] << List.indexedMap (rowItem columnsAsFloat gutter << getMargin)) colums)


rowItem : Float -> Gutter -> Float -> Html msg -> Html msg
rowItem columnsAsFloat gutter margin element =
    li
        [ style
            [ ( "margin-bottom", toString gutter ++ "px" )
            , ( "margin-right", toString margin ++ "px" )
            , ( "width"
              , "calc("
                    ++ toString (100 / columnsAsFloat)
                    ++ "% - "
                    ++ toString (gutter * (columnsAsFloat - 1) / columnsAsFloat)
                    ++ "px"
              )
            , ( "float", "left" )
            ]
        ]
        [ element ]
