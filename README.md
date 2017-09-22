# Elm-Giphy-Search

App to get gifs from GIPHY.

## Getting Started

First You have to implement your own GPIHY API_KEY here:

```
getInfo : String -> Cmd Msg
getInfo string = 
  let
    url = 
      "http://api.giphy.com/v1/gifs/search?q=" ++ string ++ "&api_key=API_KEY" 

    req = 
      Http.get url decodeGifs

  in
    Http.send OpenGifs req
```

and then run `elm-package install` before running `elm-reactor` or `elm-make`.