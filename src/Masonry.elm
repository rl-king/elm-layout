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

        columnStyle =
            style
                [ ( "width"
                  , "calc("
                        ++ toString (100 / columnAsFloat)
                        ++ "% - "
                        ++ toString (gutter * (columnAsFloat - 1) / columnAsFloat)
                        ++ "px"
                  )
                ]
    in
    div
        [ class "elm-masonry-container"
        , style [ ( "display", "flex" ), ( "justify-content", "space-between" ) ]
        ]
        (List.map (div [ class "elm-masonry-column", columnStyle ] << List.map (gridItem gutter)) colums)


gridItem : Gutter -> Html msg -> Html msg
gridItem gutter element =
    div
        [ class "elm-masonry-item", style [ ( "margin-bottom", toString gutter ++ "px" ) ] ]
        [ element ]
