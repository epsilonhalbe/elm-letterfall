port module Letterfall exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import String exposing (..)
import Random exposing (Seed, Generator)
import Array
import Random.Array
import Random.Int

main = Html.program
     { init          = init
     , view          = view
     , update        = update
     , subscriptions = subscriptions }

-- MODEL

type alias Model = {letters : List String}

alphabet : List String
alphabet = String.split "" "abcdefghijklmnopqrstuvwxyz"

init : (Model, Cmd Msg)
init = (Model  alphabet,  d3Update alphabet)

-- UPDATE

type Msg = Shuffle  | ReplaceCards (Int, Array.Array String)

port d3Update : List String -> Cmd msg

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = case msg of
  Shuffle ->
      let shufleBet = (Random.Array.shuffle <| Array.fromList alphabet)
       in (model, Random.generate ReplaceCards <| Random.pair (Random.int 1 25) shufleBet)
  ReplaceCards (len, chars) ->
      let newAlpha = Array.toList <| Array.slice 0 len chars
       in (Model newAlpha, d3Update newAlpha)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

-- VIEW
-- am going to pass this off to D3 soonish

view : Model -> Html Msg
view model =
  Html.div []
    [ Html.h1 [] [ Html.text <| toString model.letters ]
    , Svg.svg [ width "960", height "120", viewBox "0 0 960 120"]
              [ g [class "letters", transform "translate(32,60)"] [] ]

    , Html.button [ onClick Shuffle ] [ Html.text "Roll" ]
    ]

