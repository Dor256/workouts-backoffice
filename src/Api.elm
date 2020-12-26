module Api exposing (..)

import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, bool, field, int, list, string)
import Json.Encode as Encode exposing (Value)


type alias Workout =
    { name : String
    }


type alias Response result =
    Result Http.Error result


baseUrl : String
baseUrl =
    "http://localhost:3000"


getWorkouts : (Response (List Workout) -> action) -> Cmd action
getWorkouts action =
    Http.get
        { url = baseUrl ++ "/workouts"
        , expect = Http.expectJson action workoutListDecoder
        }


addWorkout : (Response () -> action) -> Workout -> Cmd action
addWorkout action workout =
    Http.post
        { url = baseUrl ++ "/workouts"
        , body = workoutEncoder workout |> Http.jsonBody
        , expect = Http.expectWhatever action
        }


ignoreResponse : Decoder Bool
ignoreResponse =
    Decode.succeed True


workoutListDecoder : Decoder (List Workout)
workoutListDecoder =
    Decode.list workoutDecoder


workoutDecoder : Decoder Workout
workoutDecoder =
    Decode.map Workout
        (field "name" Decode.string)


workoutEncoder : Workout -> Value
workoutEncoder workout =
    Encode.object
        [ ( "name", Encode.string workout.name )
        ]
