module Api exposing (..)

import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, bool, field, int, list, string)


type alias Workout =
    { name : String
    }


baseUrl : String
baseUrl =
    "http://localhost:3000"


getWorkouts : (Result Http.Error (List Workout) -> action) -> Cmd action
getWorkouts action =
    Http.get
        { url = baseUrl ++ "/workout"
        , expect = Http.expectJson action workoutListDecoder
        }


workoutListDecoder : Decoder (List Workout)
workoutListDecoder =
    Decode.list workoutDecoder


workoutDecoder : Decoder Workout
workoutDecoder =
    Decode.map Workout
        (field "name" Decode.string)
