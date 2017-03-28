port module Auth exposing (..)


port storeToken : String -> Cmd msg

port clearToken : () -> Cmd msg
