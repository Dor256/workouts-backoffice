module Page.Login exposing (..)

import Api exposing (Cred)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http exposing (..)
import Route exposing (Route)


type alias Model =
    { email : String
    , password : String
    , navKey : Nav.Key
    , err : String
    }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { email = ""
      , password = ""
      , navKey = navKey
      , err = ""
      }
    , Cmd.none
    )


type Msg
    = OnLogin
    | EmailChange String
    | PasswordChange String
    | LoginResult (Result Http.Error ())


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLogin ->
            ( model
            , Api.logIn LoginResult { email = model.email, password = model.password }
            )

        EmailChange email ->
            ( { model | email = email }
            , Cmd.none
            )

        PasswordChange password ->
            ( { model | password = password }
            , Cmd.none
            )

        LoginResult (Ok res) ->
            ( { model | err = "" }
            , Route.pushUrl Route.Home model.navKey
            )

        LoginResult (Err err) ->
            ( { model | err = errorToString err }
            , Cmd.none
            )


errorToString : Http.Error -> String
errorToString err =
    case err of
        BadStatus 401 ->
            "The email or password are incorrect, please try again."

        _ ->
            "An unknown error occured"


view : Model -> Html Msg
view model =
    main_
        [ class "login-container" ]
        [ h1 [] [ text "Welcome to Workouts" ]
        , div
            [ class "container" ]
            [ span
                [ if model.err /= "" then
                    class "login-error-active"

                  else
                    class "login-error-inactive"
                ]
                [ text model.err ]
            , input
                [ type_ "text"
                , class "login-input"
                , onInput EmailChange
                , value model.email
                , placeholder "Enter email..."
                ]
                []
            , input
                [ type_ "password"
                , class "login-input"
                , onInput PasswordChange
                , value model.password
                , placeholder "Enter password..."
                ]
                []
            , button
                [ class "button", onClick OnLogin ]
                [ text "Login" ]
            ]
        ]
