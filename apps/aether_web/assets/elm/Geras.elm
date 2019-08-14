import Browser
import Html exposing (..)
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
    { tests : List Test
    , categories : List Category
    , score : Float
    }

getTests : String -> Cmd Msg
getTests ts =
  Http.get
    { url = "/api/" ++ ts
    , expect = Http.expectJson GotTests resultsDecoder
    }

--ts = [Test "t1" Pass 1, Test "t2" Pass 1, Test "t3" Fail 1]
cs = [Category "A" 0.9, Category "B" 0.8, Category "C" 0.7, Category "D" 0.6, Category "F" 0.0]
f = 0.59

init : String -> (Model, Cmd Msg)
init ts =
    (Model [] cs f, getTests ts)


-- UPDATE

type Msg
    = GetScore
    | GotTests (Result Http.Error JSONResults)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GetScore ->
            (model, Cmd.none)
        GotTests r ->
            case r of
                Ok rs -> (Model (List.map parseTest (parseResults rs)) cs f, Cmd.none)
                Err _ -> (model, Cmd.none)


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


-- VIEW

view : Model -> Html Msg
view model =
    div [] [ displayTests model.tests
           , displayCategorization model.categories model.score
           ]
