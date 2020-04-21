port module ScreenOverlayExample exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Browser
import Html.Events exposing (onClick)
import ScreenOverlay exposing (ScreenOverlay)


-- *****
-- Ports
-- *****


port lockScroll : Maybe String -> Cmd msg


port unlockScroll : Maybe String -> Cmd msg


{-| Port is used to lock the scroll on the <body> element so scoll only happens
on the overlay and not unlerlying elements

-- app.js

app.ports.lockScroll.subscribe(() => {
document.body.classList.add('scroll-lock')
})

app.ports.unlockScroll.subscribe(() => {
document.body.classList.remove('scroll-lock')
})

-- app.css

.scroll-lock {
overflow: hidden;
}

-}



-- *****
-- Model
-- *****


type alias Model =
    { overlay : ScreenOverlay }


initialModel : Model
initialModel =
    { overlay = ScreenOverlay.initOverlay }



-- *******
-- Message
-- *******


type Msg
    = OpenOverlay
    | CloseOverlay



-- ******
-- Update
-- ******


init : () -> ( Model, Cmd Msg )
init _ = ( initialModel, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OpenOverlay ->
            ( { model | overlay = ScreenOverlay.show model.overlay }, lockScroll Nothing )

        CloseOverlay ->
            ( { model | overlay = ScreenOverlay.hide model.overlay }, unlockScroll Nothing )



-- ****
-- View
-- ****


view : Model -> Html Msg
view { overlay } =
    div
        [ id "main"
        , style "padding" "2rem"
        , style "background-color" "#c5dae6"
        , style  "height" "100%"
        ]
        [ h2 [] [ text "This is the main page content" ]
        , div []
            [ button [ style "color" "#6290ea", onClick OpenOverlay ]
                [ text "Show Overlay" ]
            ]
        , ScreenOverlay.overlayView overlay CloseOverlay overlayContent
        ]


overlayContent : Html Msg
overlayContent =
    div [ style "width" "75%" ]
        [ h3 [] [ text "This is in the Overlay View" ]
        , div [] [ text "Bacon ipsum dolor amet kevin swine chicken filet mignon cupim. Boudin pork chop rump drumstick capicola kevin cupim ham. Meatball jerky andouille frankfurter sausage short ribs. Chuck cupim kevin capicola." ]
        ]


-- ***
-- App
-- ***


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
