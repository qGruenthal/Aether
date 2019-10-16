module Tests exposing (..)
import Html exposing (..)

type TestResult
    = Pass
    | Fail

type alias Test =
    { name : String
    , result : TestResult
    , value : Int
    }

type alias Category =
    { name : String
    , threshold : Float
    }

possible : Test -> Int -> Int
possible t s =
    s + t.value

earned : Test -> Int -> Int
earned t s =
    case t.result of
        Pass ->
            s + t.value
        _ ->
            s

gradeTests : List Test -> Float
gradeTests ts =
    let
        p = List.foldl (possible) 0 ts
        e = List.foldl (earned) 0 ts
    in
    100.0 * ((toFloat e) / (toFloat p))

displayTest : Test -> Html msg
displayTest t =
    let
        v = (String.fromInt t.value)
    in
    case t.result of
        Pass ->
            tr [] [ td [] [ text "PASSED" ]
                  , td [] [ text t.name ]
                  , td [] [ text (v ++ "/" ++ v) ]
                  ]
        Fail ->
            tr [] [ td [] [ text "FAILED" ]
                  , td [] [ text t.name ]
                  , td [] [ text ("0/" ++ v) ]
                  ]

displayTests : List Test -> Html msg
displayTests ts =
    table [] ((tr [] [ th [] [ text "Status" ], th [] [ text "Name" ], th [] [ text "Score" ] ]) :: ( List.map displayTest ts ))

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
