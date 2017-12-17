module Layout
    exposing
        ( column
        , columnVariable
        , group
        , groupVariable
        , responsive
        , responsiveCustom
        , responsiveVariable
        , row
        , rowVariable
        )

{-|

@docs column
@docs columnVariable
@docs row
@docs group
@docs responsive
@docs responsiveCustom
@docs responsiveVariable
@docs rowVariable
@docs groupVariable

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import List.Extra exposing (greedyGroupsOf, transpose)


type alias Columns =
    Int


type alias Gutter =
    Float


type alias GutterRight =
    Float


type alias GutterBottom =
    Float


type GutterInternal
    = GutterInternal GutterRight GutterBottom



-- COLUMN


{-| -}
column : Columns -> Gutter -> List (Html msg) -> List (Html msg)
column columns gutter elements =
    columnInternal (List.repeat columns 1) (GutterInternal gutter gutter) elements


{-| -}
columnVariable : List Columns -> Gutter -> List (Html msg) -> List (Html msg)
columnVariable columns gutter elements =
    columnInternal columns (GutterInternal gutter gutter) elements


columnInternal : List Columns -> GutterInternal -> List (Html msg) -> List (Html msg)
columnInternal columns gutter elements =
    let
        columnsEqualLength =
            columns
                |> List.repeat (List.length elements // List.length columns)
                |> List.concat

        columnsWithSize =
            List.map2 (,) columnsEqualLength (toColumns (List.length columns) elements)
    in
    List.indexedMap (columnInternalList columns gutter) columnsWithSize


columnInternalList : List Columns -> GutterInternal -> Int -> ( Int, List (Html msg) ) -> Html msg
columnInternalList columns ((GutterInternal right _) as gutter) index ( partCount, elements ) =
    let
        part =
            100 / toFloat (List.sum columns)

        columnAsFloat =
            toFloat (List.length columns)

        columnStyle =
            style
                [ ( "list-style", "none" )
                , ( "margin-top", "0" )
                , ( "margin-bottom", "0" )
                , ( "padding", "0" )
                , ( "float", "left" )
                , ( "margin-right", toString (allButLast right (List.length columns) index) ++ "px" )
                , ( "width"
                  , "calc("
                        ++ toString (part * toFloat partCount)
                        ++ "% - "
                        ++ toString (right * (columnAsFloat - 1) / columnAsFloat)
                        ++ "px"
                  )
                ]
    in
    ul [ columnStyle ] (List.map (columnInternalItem gutter) elements)


columnInternalItem : GutterInternal -> Html msg -> Html msg
columnInternalItem (GutterInternal _ bottom) element =
    li [ style [ ( "margin-bottom", toString bottom ++ "px" ) ] ] [ element ]



-- ROW


{-| -}
row : Columns -> Gutter -> List (Html msg) -> List (Html msg)
row columns gutter elements =
    rowInternal (List.repeat columns 1) (GutterInternal gutter gutter) elements


{-| -}
rowVariable : List Columns -> GutterRight -> GutterBottom -> List (Html msg) -> List (Html msg)
rowVariable columns gutterRight gutterBottom elements =
    rowInternal columns (GutterInternal gutterRight gutterBottom) elements


rowInternal : List Columns -> GutterInternal -> List (Html msg) -> List (Html msg)
rowInternal columns gutter elements =
    let
        columnsEqualLength =
            columns
                |> List.repeat (List.length elements // List.length columns)
                |> List.concat

        elementsWithSize =
            List.map2 (,) columnsEqualLength elements
    in
    List.map (rowInternalList columns gutter) (toRows (List.length columns) elementsWithSize)


rowInternalList : List Columns -> GutterInternal -> List ( Columns, Html msg ) -> Html msg
rowInternalList columns gutter elements =
    let
        columnStyle =
            style
                [ ( "list-style", "none" )
                , ( "margin-top", "0" )
                , ( "margin-bottom", "0" )
                , ( "padding", "0" )
                , ( "width", "100%" )
                , ( "clear", "both" )
                , ( "display", "block" )
                ]
    in
    ul [ columnStyle ] (List.indexedMap (rowInternalItem columns gutter) elements)


rowInternalItem : List Columns -> GutterInternal -> Int -> ( Columns, Html msg ) -> Html msg
rowInternalItem columns (GutterInternal right bottom) index ( partCount, element ) =
    let
        part =
            100 / toFloat (List.sum columns)

        columnsLength =
            toFloat (List.length columns)

        itemStyle =
            style
                [ ( "margin-bottom", toString bottom ++ "px" )
                , ( "margin-right", toString (allButLast right (List.length columns) index) ++ "px" )
                , ( "width"
                  , "calc("
                        ++ toString (part * toFloat partCount)
                        ++ "% - "
                        ++ toString (right * (columnsLength - 1) / columnsLength)
                        ++ "px"
                  )
                , ( "float", "left" )
                ]
    in
    li [ itemStyle ] [ element ]



-- GROUP


{-| -}
group : GutterRight -> GutterBottom -> List (Html msg) -> List (Html msg)
group gutterRight gutterBottom layouts =
    groupCustomInternal [ List.length layouts ] (GutterInternal gutterRight gutterBottom) layouts


{-| -}
groupVariable : List Int -> GutterRight -> GutterBottom -> List (Html msg) -> List (Html msg)
groupVariable columns gutterRight gutterBottom layouts =
    groupCustomInternal (List.take (List.length layouts) columns) (GutterInternal gutterRight gutterBottom) layouts


groupCustomInternal : List Int -> GutterInternal -> List (Html msg) -> List (Html msg)
groupCustomInternal columns gutter layouts =
    rowInternal columns gutter layouts



-- RESPONSIVE


{-| -}
responsive : Int -> Int
responsive windowWidth =
    responsiveCustom windowWidth defaultBreakpoints


{-| -}
responsiveCustom : Int -> List ( Int, Int ) -> Int
responsiveCustom windowWidth breakpoints =
    List.foldr (responsiveHelper windowWidth) 0 breakpoints


responsiveHelper : Int -> ( Int, Int ) -> Int -> Int
responsiveHelper windowWidth ( columns, breakpoint ) acc =
    if breakpoint <= windowWidth || acc == 0 then
        columns
    else
        acc


{-| -}
responsiveVariable : Int -> List ( List Int, Int ) -> List Int
responsiveVariable windowWidth breakpoints =
    List.foldr (responsiveVariableHelper windowWidth) [] breakpoints


responsiveVariableHelper : Int -> ( List Int, Int ) -> List Int -> List Int
responsiveVariableHelper windowWidth ( columns, breakpoint ) acc =
    if windowWidth <= breakpoint || List.isEmpty acc then
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



-- HELPERS


toColumns : Columns -> List (Html msg) -> List (List (Html msg))
toColumns columns elements =
    transpose (greedyGroupsOf columns elements)


toRows : Int -> List a -> List (List a)
toRows columns elements =
    greedyGroupsOf columns elements


allButLast : GutterRight -> Columns -> Int -> GutterRight
allButLast gutterRight columns index =
    if columns == index + 1 then
        0
    else
        gutterRight
