module Tests exposing (..)
import Html exposing (..)

type Result
    = Pass
    | Fail

type alias Test =
    { name : String
    , result : Result
    , value : Int
    }

type alias Category =
    { name : String
    , threshold : Float
    }

displayTest : Test -> Html msg
displayTest t =
    let
        v = (String.fromInt t.value)
    in
    case t.result of
        Pass ->
            tr [] [ th [] [ text "PASSED" ]
                  , th [] [ text t.name ]
                  , th [] [ text (v ++ "/" ++ v) ]
                  ]
        Fail ->
            tr [] [ th [] [ text "FAILED" ]
                  , th [] [ text t.name ]
                  , th [] [ text ("0/" ++ v) ]
                  ]

displayTests : List Test -> Html msg
displayTests ts =
    table [] ( List.map displayTest ts )

displayCategorization : List Category -> Float -> Html msg
displayCategorization cs f =
    let
        h = (List.head cs)
        s = (String.fromFloat f)
    in
    case h of
        Just c ->
            if f >= c.threshold then
                div [] [ text ("Score: " ++ s ++ " - " ++c.name) ]
            else
                displayCategorization (List.drop 1 cs) f
        Nothing ->
            div [] [ text "No Such Category" ]
