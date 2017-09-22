module Main exposing(..)

import Html exposing(..)
import Html.Attributes exposing(..)
import Html.Events exposing(..)
import Http
import Json.Decode as Decode 

--model

type alias Model = 
  {
    gifs : List Gif,
    searchString : String
  }

type alias Gif = 
  {
    id : String,
    embed_url : String
  }

init : (Model, Cmd Msg)
init = 
  (Model [] "", Cmd.none)

--update

type Msg = 
  OpenGifs (Result Http.Error (List Gif))
  | UpdateSearchString String
  | GetGifs

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of 
    OpenGifs (Ok json) ->
      ( {model | gifs = json}, Cmd.none )
    OpenGifs (Err e) ->
      ( Debug.log (toString  e) model, Cmd.none )
    UpdateSearchString search ->
      ( {model | searchString = search}, Cmd.none )
    GetGifs ->
      ( model, getInfo model.searchString )

--view

view : Model -> Html Msg
view model = 
  div []
  [
    input [ 
      type_ "text",
      onInput UpdateSearchString
     ] [],
    button [ onClick GetGifs ] [ text "Go!" ],
    h5 [] [ text model.searchString ],
    div [] <| List.map gifView model.gifs
  ]

gifView : Gif -> Html Msg
gifView gif = 
  div []
  [
    img [ src gif.embed_url ] []
  ]

--subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none

--commands

getInfo : String -> Cmd Msg
getInfo string = 
  let
    url = 
      "http://api.giphy.com/v1/gifs/search?q=" ++ string ++ "&api_key=API_KEY" 

    req = 
      Http.get url decodeGifs

  in
    Http.send OpenGifs req
      

--json

decodeGifs : Decode.Decoder (List Gif)
decodeGifs = 
  Decode.at ["data"] (Decode.list decodeGif)

decodeGif : Decode.Decoder Gif
decodeGif = 
  Decode.map2 Gif
    (Decode.at ["id"] Decode.string)
    (Decode.at ["images", "fixed_height", "url"] Decode.string)

main = 
  Html.program
    {
      init = init,
      update = update,
      view = view,
      subscriptions = subscriptions
    }