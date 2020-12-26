module Api exposing (..)

import Http exposing (..)
import Json.Decode as Decode exposing (Decoder, bool, field, int, list, string)
import Json.Encode as Encode exposing (Value)


type alias Workout =
    { name : String
    }


type alias Cred =
    { email : String
    , password : String
    }


type alias Response result =
    Result Http.Error result


baseUrl : String
baseUrl =
    "http://localhost:3000"


getWorkouts : (Response (List Workout) -> msg) -> Cmd msg
getWorkouts msg =
    Http.get
        { url = baseUrl ++ "/workouts"
        , expect = Http.expectJson msg workoutListDecoder
        }


addWorkout : (Response () -> msg) -> Workout -> Cmd msg
addWorkout msg workout =
    Http.post
        { url = baseUrl ++ "/workouts"
        , body = workoutEncoder workout |> Http.jsonBody
        , expect = Http.expectWhatever msg
        }


logIn : (Response () -> msg) -> Cred -> Cmd msg
logIn msg cred =
    Http.post
        { url = baseUrl ++ "/login"
        , body = credEncoder cred |> Http.jsonBody
        , expect = Http.expectWhatever msg
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


credEncoder : Cred -> Value
credEncoder cred =
    Encode.object
        [ ( "email", Encode.string cred.email )
        , ( "password", Encode.string cred.password )
        ]
