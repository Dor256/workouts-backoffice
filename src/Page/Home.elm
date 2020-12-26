module Page.Home exposing (..)

import Api exposing (Workout, addWorkout, getWorkouts)
import Card exposing (card)
import Html exposing (Attribute, Html, button, div, h1, input, li, main_, text, ul)
import Html.Attributes exposing (class, placeholder, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Http exposing (..)
import Json.Decode as Json
import Loader exposing (loader)


type alias Model =
    { search : String
    , workouts : Maybe (List Workout)
    }


init : ( Model, Cmd Msg )
init =
    ( { search = ""
      , workouts = Nothing
      }
    , getWorkouts GotWorkouts
    )


type Msg
    = OnChange String
    | GotWorkouts (Result Http.Error (List Workout))
    | OnSubmit Int
    | AddWorkout (Result Http.Error ())


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        OnChange text ->
            ( { model
                | search = text
              }
            , Cmd.none
            )

        GotWorkouts (Ok res) ->
            ( { model
                | workouts = Just res
              }
            , Cmd.none
            )

        GotWorkouts (Err res) ->
            ( { model
                | workouts = Nothing
              }
            , Cmd.none
            )

        OnSubmit key ->
            if key == enterKey then
                ( model
                , addWorkout AddWorkout { name = model.search }
                )

            else
                ( model, Cmd.none )

        AddWorkout (Ok res) ->
            case model.workouts of
                Just workouts ->
                    ( { model | workouts = Just (List.append workouts [ { name = model.search } ]), search = "" }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


enterKey : Int
enterKey =
    13


onKeyPress : (Int -> msg) -> Attribute msg
onKeyPress mapper =
    on "keypress" (Json.map mapper keyCode)


view : Model -> Html Msg
view model =
    main_
        []
    <|
        case model.workouts of
            Just workouts ->
                [ h1 [] [ text "Workouts" ]
                , div
                    [ class "container " ]
                    [ input
                        [ type_ "text"
                        , onInput OnChange
                        , onKeyPress OnSubmit
                        , class "searchbar"
                        , placeholder "Enter workout..."
                        , value model.search
                        ]
                        []
                    , div [ class "card-container" ] <|
                        List.map (\workout -> card workout) workouts
                    ]
                ]

            Nothing ->
                [ loader ]
