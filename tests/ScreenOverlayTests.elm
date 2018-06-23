module ScreenOverlayTests exposing (..)

import Css
import Html.Styled exposing (..)
import Html.Styled.Attributes as Attrs
import ScreenOverlay as Overlay
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector


type Msg
    = Close


overlayMarkup : Html Msg
overlayMarkup =
    div [ Attrs.class "my-overlay-markup" ] [ text "hi" ]


showScreenOverlay : Html Msg
showScreenOverlay =
    Overlay.overlayView Overlay.initOverlay Close overlayMarkup


overlayViewTests : Test
overlayViewTests =
    describe "screen overlay view tests"
        [ test "style overrides are applied" <|
            \_ ->
                let
                    styles =
                        [ Css.color (Css.hex "abc123")
                        , Css.top (Css.px 15)
                        , Css.displayFlex
                        ]
                in
                Overlay.initOverlay
                    |> Overlay.withOverlayStyles styles
                    |> Overlay.show
                    |> (\overlay -> Overlay.overlayView overlay Close overlayMarkup)
                    |> toUnstyled
                    |> Query.fromHtml
                    |> Query.has [ Selector.class "_b2a5436a" ]
        , test "outputs the given markup" <|
            \_ ->
                Overlay.initOverlay
                    |> (\overlay -> Overlay.overlayView overlay Close overlayMarkup)
                    |> toUnstyled
                    |> Query.fromHtml
                    |> Query.find [ Selector.class "my-overlay-markup" ]
                    |> Query.has [ Selector.text "hi" ]
        ]
