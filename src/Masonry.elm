module Masonry exposing (Column, Gutter, grid)

{-|

@docs Column
@docs Gutter
@docs grid

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import List.Extra exposing (greedyGroupsOf, transpose)


{-| -}
type alias Column =
    Int


{-| -}
type alias Gutter =
    Float


{-| -}
grid : Column -> Gutter -> List (Html msg) -> Html msg
grid columnCount gutter elements =
    let
        colums =
            transpose (greedyGroupsOf columnCount elements)

        columnAsFloat =
            toFloat columnCount

        getMargin index =
            if index + 1 == columnCount then
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
                        ++ toString (100 / columnAsFloat)
                        ++ "% - "
                        ++ toString (gutter * (columnAsFloat - 1) / columnAsFloat)
                        ++ "px"
                  )
                ]
    in
    div
        [ class "elm-masonry-container" ]
        (List.indexedMap
            (\index column ->
                ul
                    [ class "elm-masonry-column"
                    , columnStyle (getMargin index)
                    ]
                    (List.map (gridItem gutter) column)
            )
            colums
        )


gridItem : Gutter -> Html msg -> Html msg
gridItem gutter element =
    li
        [ class "elm-masonry-item", style [ ( "margin-bottom", toString gutter ++ "px" ) ] ]
        [ element ]
