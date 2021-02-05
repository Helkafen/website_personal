module Header exposing (menu)

import Html exposing (Html, text)
import Html.Attributes exposing ( href)
import Bootstrap.Navbar as Navbar
import Datatypes exposing (Msg(..), Page(..), Model, urlOfPage)

menu : Model -> Html Msg
menu model =
    Navbar.config NavMsg
        |> Navbar.withAnimation
        |> Navbar.container
        |> Navbar.brand [ href "#" ] [ text "Home" ]
        |> Navbar.items
            [ Navbar.dropdown
                { id = "resources_dropdown"
                , toggle = Navbar.dropdownToggle [ href (urlOfPage model.page) ] [ text "Resources" ]
                , items =
                    [ Navbar.dropdownItem [ href "#energy" ]         [ text "Energy" ]
                    , Navbar.dropdownItem [ href "#agriculture" ]    [ text "Agriculture" ]
                    , Navbar.dropdownItem [ href "#social-systems" ] [ text "Social systems" ]
                    ]
                }
            , Navbar.itemLink [ href "#twitter" ] [ text "Twitter" ]
            , Navbar.itemLink [ href "#about" ]   [ text "About" ]
            ]
        |> Navbar.view model.navState
