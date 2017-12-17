module Layout exposing (Columns, Gutter, column, group, responsive, responsiveCustom, row)

{-|

@docs Columns
@docs Gutter
@docs column
@docs row
@docs group
@docs responsive
@docs responsiveCustom

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
        groupedElements =
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
    div [] (List.map (ul [ columnStyle ] << List.indexedMap (rowItem columnsAsFloat gutter << getMargin)) groupedElements)


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


{-| -}
group : Gutter -> List (Html msg) -> Html msg
group gutter layouts =
    let
        columns =
            List.length layouts

        columnsAsFloat =
            toFloat columns

        getMargin index =
            if index + 1 == columns then
                0
            else
                gutter
    in
    div
        [ style [ ( "width", "100%" ) ] ]
        (List.indexedMap (groupItem columnsAsFloat gutter << getMargin) layouts)


groupItem : Float -> Gutter -> Float -> Html msg -> Html msg
groupItem columns gutter margin element =
    div
        [ style
            [ ( "margin-bottom", toString gutter ++ "px" )
            , ( "margin-right", toString margin ++ "px" )
            , ( "width"
              , "calc("
                    ++ toString (100 / columns)
                    ++ "% - "
                    ++ toString (gutter * (columns - 1) / columns)
                    ++ "px"
              )
            , ( "float", "left" )
            ]
        ]
        [ element ]


{-| -}
responsive : Int -> Int
responsive windowWidth =
    List.foldl (responsiveHelper windowWidth) 1 defaultBreakpoints


{-| -}
responsiveCustom : Int -> List ( Int, Int ) -> Int
responsiveCustom windowWidth breakpoints =
    List.foldl (responsiveHelper windowWidth) 1 breakpoints


responsiveHelper : Int -> ( Int, Int ) -> Int -> Int
responsiveHelper windowWidth ( columns, breakpoint ) acc =
    if breakpoint <= windowWidth then
        columns
    else
        acc


defaultBreakpoints : List ( Int, Int )
defaultBreakpoints =
    [ ( 1, 480 )
    , ( 2, 768 )
    , ( 3, 1024 )
    , ( 4, 1280 )
    , ( 5, 1660 )
    , ( 6, 1920 )
    ]
