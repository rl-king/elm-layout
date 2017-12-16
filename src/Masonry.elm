module Masonry exposing (grid)

{-|

@docs grid

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import List.Extra exposing (greedyGroupsOf, transpose)


type alias Rows =
    Int


type alias Gutter =
    Float


{-| -}
grid : Rows -> Gutter -> List (Html msg) -> Html msg
grid rowCount gutter elements =
    let
        rows =
            transpose (greedyGroupsOf rowCount elements)

        rowAsFloat =
            toFloat rowCount

        rowStyle =
            style
                [ ( "width"
                  , "calc("
                        ++ toString (100 / rowAsFloat)
                        ++ "% - "
                        ++ toString (gutter * (rowAsFloat - 1) / rowAsFloat)
                        ++ "px"
                  )
                ]
    in
    div
        [ class "elm-masonry-container"
        , style [ ( "display", "flex" ), ( "justify-content", "space-between" ) ]
        ]
        (List.map (div [ class "elm-masonry-row", rowStyle ] << List.map (gridItem gutter)) rows)


gridItem : Gutter -> Html msg -> Html msg
gridItem gutter element =
    div
        [ class "elm-masonry-item", style [ ( "margin-bottom", toString gutter ++ "px" ) ] ]
        [ element ]
