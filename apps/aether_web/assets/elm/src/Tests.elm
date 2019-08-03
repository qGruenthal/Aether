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
    
displayTest : Test -> Html msg
displayTest t =
    case t.result of
        Pass ->
            tr [] [ th [] [ text t.name ]
                  , th [] [ text "PASSED" ]
                  , th [] [ text (String.fromInt t.value) ]
                  ]
        Fail ->
            tr [] [ th [] [ text t.name ]
                  , th [] [ text "FAILED" ]
                  , th [] [ text (String.fromInt t.value) ]
                  ]

displayTests : List Test -> Html msg
displayTests ts =
    table [] ( List.map displayTest ts )
