module Page.Login exposing (..)

import Api exposing (Cred)
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Route exposing (Route)


type alias Model =
    { email : String
    , password : String
    , navKey : Nav.Key
    }


init : Nav.Key -> ( Model, Cmd Msg )
init navKey =
    ( { email = ""
      , password = ""
      , navKey = navKey
      }
    , Cmd.none
    )


type Msg
    = OnLogin
    | EmailChange String
    | PasswordChange String
    | LoginSuccess (Result Http.Error ())


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLogin ->
            ( model
            , Api.logIn LoginSuccess { email = model.email, password = model.password }
            )

        EmailChange email ->
            ( { model | email = email }
            , Cmd.none
            )

        PasswordChange password ->
            ( { model | password = password }
            , Cmd.none
            )

        LoginSuccess (Ok res) ->
            ( model
            , Route.pushUrl Route.Home model.navKey
            )

        _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    main_
        [ class "login-container" ]
        [ h1 [] [ text "Welcome to Workouts" ]
        , div
            [ class "container" ]
            [ input
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
