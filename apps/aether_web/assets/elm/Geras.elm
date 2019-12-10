import Browser
import Html exposing (..)
import Html.Attributes exposing (class)
import Http
import Json.Decode exposing (Value)

import Tests exposing (..)
import Parser exposing (..)

-- MAIN

main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


-- MODEL

type alias Model =
    { items : Gradable
    }

getTests : String -> Cmd Msg
getTests url =
  Http.get
    { url = "/api/" ++ url
    , expect = Http.expectJson GotTests resultsDecoder
    }

getGrades : String -> Cmd Msg
getGrades url =
  Http.get
    { url = "/api/" ++ url
    , expect = Http.expectJson GotGrades assignmentsDecoder
    }

init : (String, String) -> (Model, Cmd Msg)
init flg =
    case flg of
        ("tests", url) ->
            (Model None, getTests url)
        ("grades", url) ->
            (Model None, getGrades url)
        _ ->
            (Model None, Cmd.none)


-- UPDATE

type Msg
    = GetScore
    | GotTests (Result Http.Error JSONResults)
    | GotGrades (Result Http.Error JSONAssignments)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GetScore ->
            (model, Cmd.none)
        GotTests r ->
            case r of
                Ok rs -> (Model (Tests (List.map parseTest (parseResults rs))), Cmd.none)
                Err _ -> (model, Cmd.none)
        GotGrades r ->
            case r of
                Ok rs -> (Model (Course (List.map parseGrade (parseAssignments rs))), Cmd.none)
                Err _ -> (Model (Course [Grade "Ant" 10 10]), Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW

view : Model -> Html Msg
view model =
    case model.items of
        Tests ts -> 
            div [ class "container" ] [ h1 [] [ text "Grades" ]
                                      , showTests ts
                                      ]
        Course gs -> 
            div [ class "container" ] [ h1 [] [ text "Course" ]
                                      , showGrades gs
                                      ]
        _ ->
            div [ class "container" ] [ h1 [] [ text "Waiting..." ] ]
