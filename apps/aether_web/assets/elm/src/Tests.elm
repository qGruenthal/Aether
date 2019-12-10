module Tests exposing (..)
import Html exposing (..)
import Html.Attributes exposing (class)
import Round exposing (round)

cs = [ Category "A" 93.0
     , Category "A-" 90.0
     , Category "B+" 87.0
     , Category "B" 83.0
     , Category "B-" 80.0
     , Category "C+" 77.0
     , Category "C" 73.0
     , Category "C-" 70.0
     , Category "D" 60.0
     , Category "F" 0.0
     ]

type TestResult
    = Pass
    | Fail
    | Skip

type alias Test =
    { name : String
    , result : TestResult
    , value : Int
    }

type alias Grade =
    { name : String
    , earned : Int
    , possible : Int
    }

type alias Category =
    { name : String
    , threshold : Float
    }

type Gradable
    = Tests (List Test)
    | Course (List Grade)
    | None

possibleTest : Test -> Int -> Int
possibleTest t s =
    s + t.value

earnedTest : Test -> Int -> Int
earnedTest t s =
    case t.result of
        Pass ->
            s + t.value
        _ ->
            s

possibleGrade : Grade -> Int -> Int
possibleGrade g s =
    s + g.possible

earnedGrade : Grade -> Int -> Int
earnedGrade g s =
    s + g.earned

sumTests : List Test -> (Int, Int)
sumTests ts =
    let
        p = List.foldl (possibleTest) 0 ts
        e = List.foldl (earnedTest) 0 ts
    in
    (e, p)

gradeTests : List Test -> Float
gradeTests ts =
    let
        p = List.foldl (possibleTest) 0 ts
        e = List.foldl (earnedTest) 0 ts
    in
    100.0 * ((toFloat e) / (toFloat p))

sumGrades : List Grade -> (Int, Int)
sumGrades gs =
    let
        p = List.foldl (possibleGrade) 0 gs
        e = List.foldl (earnedGrade) 0 gs
    in
    (e, p)

gradeGrades : List Grade -> Float
gradeGrades gs =
    let
        p = List.foldl (possibleGrade) 0 gs
        e = List.foldl (earnedGrade) 0 gs
    in
    100.0 * ((toFloat e) / (toFloat p))

displayTest : Test -> Html msg
displayTest t =
    let
        v = (String.fromInt t.value)
    in
    case t.result of
        Pass ->
            tr [] [ td [] [ text t.name ]
                  , td [] [ text "PASSED" ]
                  , td [] [ text (v ++ "/" ++ v) ]
                  ]
        Fail ->
            tr [ class "failed" ] [ td [] [ text t.name ]
                                  , td [] [ text "FAILED" ]
                                  , td [] [ text ("0/" ++ v) ]
                                  ]
        Skip ->
            tr [ class "failed" ] [ td [] [ text t.name ]
                                  , td [] [ text "SKIPPED" ]
                                  , td [] [ text ("0/" ++ v) ]
                                  ]

displayGrade : Grade -> Html msg
displayGrade g =
    let
        e = (String.fromInt g.earned)
        p = (String.fromInt g.possible)
        f = 100 * ((toFloat g.earned) / (toFloat g.possible))
    in
    tr [] [ td [] [ text g.name ]
          , td [] [ text (letterGrade cs f) ]
          , td [] [ text (e ++ "/" ++ p) ]
          ]

displayTests : List Test -> Html msg
displayTests ts =
    let
        b = ((thead [] [ th [] [ text "Name" ], th [] [ text "Status" ], th [] [ text "Score" ] ]) :: ( List.map displayTest ts ))
        s = sumTests ts
    in
    table [] (b ++ [tfoot [] [ td [] [], td [] [], td [] [ text ((String.fromInt (Tuple.first s)) ++ "/" ++ (String.fromInt (Tuple.second s))) ] ] ])

displayGrades : List Grade -> Html msg
displayGrades gs =
    let
        b = ((thead [] [ th [] [ text "Name" ], th [] [ text "Letter" ], th [] [ text "Score" ] ]) :: ( List.map displayGrade gs ))
        s = sumGrades gs
    in
    table [] (b ++ [tfoot [] [ td [] [], td [] [], td [] [ text ((String.fromInt (Tuple.first s)) ++ "/" ++ (String.fromInt (Tuple.second s))) ] ] ])

letterGrade : List Category -> Float -> String
letterGrade cts f =
    let
        h = (List.head cts)
    in
    case h of
        Just c ->
            if f >= c.threshold then
                c.name
            else
                letterGrade (List.drop 1 cts) f
        Nothing ->
            "-"
    

displayCategorization : Float -> Html msg
displayCategorization f =
    let
        s = (round 2 f)
    in
    section [ class "phx-hero letter-box" ] [ h1 [] [ text (letterGrade cs f)]
                                            , text (s ++ "%")
                                            ]

showTests : List Test -> Html msg
showTests ts =
    section [ class "row" ] [ article [ class "column column-90" ] [ displayTests ts ]
                            , article [ class "column" ] [ displayCategorization (gradeTests ts) ]
                            ]

showGrades : List Grade -> Html msg
showGrades gs =
    section [ class "row" ] [ article [ class "column column-90" ] [ displayGrades gs ]
                            , article [ class "column" ] [ displayCategorization (gradeGrades gs) ]
                            ]
