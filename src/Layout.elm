module Layout
    exposing
        ( column
        , columnVariable
        , golden
        , goldenInversed
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
@docs golden
@docs goldenInversed

@docs group
@docs responsive
@docs responsiveCustom
@docs responsiveVariable
@docs rowVariable
@docs groupVariable

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import List.Extra exposing (cycle, greedyGroupsOf, groupsOfVarying, transpose)


type alias Index =
    Int


type alias Columns =
    Int


type alias Fraction =
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
columnVariable : List Fraction -> Gutter -> List (Html msg) -> List (Html msg)
columnVariable fractions gutter elements =
    columnInternal fractions (GutterInternal gutter gutter) elements


columnInternal : List Fraction -> GutterInternal -> List (Html msg) -> List (Html msg)
columnInternal fractions gutter elements =
    let
        columnsEqualLength =
            fractions
                |> List.repeat (List.length elements)
                |> List.concat

        max =
            List.length fractions

        columns =
            List.foldl helper ( elements, 1, 1, [] ) columnsEqualLength
                |> (\( _, _, _, columns ) -> List.reverse columns)

        helper fraction (( elements, x, y, selection ) as acc) =
            case ( elements, x == max, rem y fraction == 0 ) of
                ( head :: tail, True, True ) ->
                    ( tail, 1, y + 1, Just head :: selection )

                ( head :: tail, False, True ) ->
                    ( tail, x + 1, y, Just head :: selection )

                ( _, True, False ) ->
                    ( elements, 1, y + 1, Nothing :: selection )

                ( _, False, False ) ->
                    ( elements, x + 1, y, Nothing :: selection )

                _ ->
                    acc

        columnsWithSize =
            List.map2 (,) columnsEqualLength (toColumns fractions columns)
    in
    List.indexedMap (columnInternalList fractions gutter) columnsWithSize


columnInternalList : List Fraction -> GutterInternal -> Index -> ( Fraction, List (Html msg) ) -> Html msg
columnInternalList fractions ((GutterInternal gutterRight _) as gutter) index ( fraction, elements ) =
    let
        width =
            (100 / toFloat (List.sum fractions))
                |> (*) (toFloat fraction)
                |> toString

        marginAdjusted =
            toFloat (List.length fractions)
                |> (\length -> gutterRight * (length - 1) / length)
                |> toString

        marginRight =
            toString (allButLast gutterRight (List.length fractions) index)

        columnStyle =
            style
                [ ( "list-style", "none" )
                , ( "margin-top", "0" )
                , ( "margin-bottom", "0" )
                , ( "padding", "0" )
                , ( "float", "left" )
                , ( "margin-right", marginRight ++ "px" )
                , ( "width", "calc(" ++ width ++ "% - " ++ marginAdjusted ++ "px" )
                ]
    in
    ul [ columnStyle ] (List.map (columnInternalItem gutter) elements)


columnInternalItem : GutterInternal -> Html msg -> Html msg
columnInternalItem (GutterInternal _ gutterBottom) element =
    li [ style [ ( "margin-bottom", toString gutterBottom ++ "px" ) ] ] [ element ]



-- ROW


{-| -}
row : Columns -> Gutter -> List (Html msg) -> List (Html msg)
row columns gutter elements =
    rowInternal (List.repeat columns 1) (GutterInternal gutter gutter) elements


{-| -}
rowVariable : List Fraction -> GutterRight -> GutterBottom -> List (Html msg) -> List (Html msg)
rowVariable fractions gutterRight gutterBottom elements =
    rowInternal fractions (GutterInternal gutterRight gutterBottom) elements


rowInternal : List Fraction -> GutterInternal -> List (Html msg) -> List (Html msg)
rowInternal fractions gutter elements =
    let
        elementsWithFraction =
            cycle (List.length elements) fractions
                |> List.map2 (,) elements
    in
    List.map (rowInternalList fractions gutter) (toRows (List.length fractions) elementsWithFraction)


rowInternalList : List Fraction -> GutterInternal -> List ( Html msg, Fraction ) -> Html msg
rowInternalList fractions gutter elements =
    let
        columnStyle =
            style
                [ ( "list-style", "none" )
                , ( "margin-top", "0" )
                , ( "margin-bottom", "0" )
                , ( "padding", "0" )
                , ( "width", "100%" )
                , ( "clear", "both" )
                , ( "display", "inline-block" )
                ]
    in
    ul [ columnStyle ] (List.indexedMap (rowInternalItem fractions gutter) elements)


rowInternalItem : List Fraction -> GutterInternal -> Index -> ( Html msg, Fraction ) -> Html msg
rowInternalItem fractions (GutterInternal gutterRight gutterBottom) index ( element, fraction ) =
    let
        width =
            (100 / toFloat (List.sum fractions))
                |> (*) (toFloat fraction)
                |> toString

        marginAdjusted =
            toFloat (List.length fractions)
                |> (\length -> gutterRight * (length - 1) / length)
                |> toString

        marginRight =
            toString (allButLast gutterRight (List.length fractions) index)

        itemStyle =
            style
                [ ( "margin-bottom", toString gutterBottom ++ "px" )
                , ( "margin-right", marginRight ++ "px" )
                , ( "width", "calc(" ++ width ++ "% - " ++ marginAdjusted ++ "px" )
                , ( "float", "left" )
                ]
    in
    li [ itemStyle ] [ element ]



-- GROUP


{-| -}
group : GutterRight -> GutterBottom -> List (Html msg) -> List (Html msg)
group gutterRight gutterBottom layouts =
    groupCustomInternal (List.repeat (List.length layouts) 1) (GutterInternal gutterRight gutterBottom) layouts


{-| -}
groupVariable : List Fraction -> GutterRight -> GutterBottom -> List (Html msg) -> List (Html msg)
groupVariable fractions gutterRight gutterBottom layouts =
    groupCustomInternal (List.take (List.length layouts) fractions) (GutterInternal gutterRight gutterBottom) layouts


groupCustomInternal : List Fraction -> GutterInternal -> List (Html msg) -> List (Html msg)
groupCustomInternal fractions gutter layouts =
    rowInternal fractions gutter layouts



-- SIZING


{-| -}
majorFifth : Columns -> List Fraction
majorFifth columns =
    List.foldl (sizeHelper 1.5) [] (List.repeat columns 100)


{-| -}
golden : Columns -> List Fraction
golden columns =
    List.foldl (sizeHelper 1.618) [] (List.repeat columns 100)


{-| -}
goldenInversed : Columns -> List Fraction
goldenInversed columns =
    List.reverse (golden columns)


sizeHelper : Float -> Columns -> List Fraction -> List Fraction
sizeHelper mulitplier frac acc =
    case acc of
        [] ->
            [ frac ]

        x :: _ ->
            floor (mulitplier * toFloat x) :: acc



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


toColumns : List Fraction -> List (Maybe (Html msg)) -> List (List (Html msg))
toColumns fractions elements =
    greedyGroupsOf (List.length fractions) elements
        |> transpose
        |> List.map (List.filterMap identity)


toRows : Int -> List a -> List (List a)
toRows columns elements =
    greedyGroupsOf columns elements


allButLast : GutterRight -> Columns -> Index -> GutterRight
allButLast gutterRight columns index =
    if columns == index + 1 then
        0
    else
        gutterRight
