import Browser
import Html exposing (..)

import Tests exposing (..)

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

ts = [Test "t1" Pass 1, Test "t2" Pass 1, Test "t3" Fail 1]
cs = [Category "A" 0.9, Category "B" 0.8, Category "C" 0.7, Category "D" 0.6, Category "F" 0.0]
f = 0.59

init : () -> (Model, Cmd Msg)
init _ =
    (Model ts cs f, Cmd.none)


-- UPDATE

type Msg
    = GetScore

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GetScore ->
            (model, Cmd.none)


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
