module Datatypes exposing (..)

import Browser.Navigation as Navigation
import Browser exposing (UrlRequest)

import Url exposing (Url)
import Bootstrap.Navbar as Navbar

type Msg
    = NavMsg Navbar.State
    | UrlChange Url
    | ClickedLink UrlRequest
    | NoOp


type Page
    = HomePage
    | EnergyPage
    | AgriculturePage
    | SocialSystemsPage
    | TwitterPage
    | AboutPage
    | NotFound

urlOfPage : Page -> String
urlOfPage page = case page of
   HomePage           -> "#"
   EnergyPage         -> "#energy"
   AgriculturePage    -> "#agriculture"
   SocialSystemsPage  -> "#social-systems"
   TwitterPage        -> "#social-media"
   AboutPage          -> "#about"
   NotFound           -> "#"

type alias Model = 
    { page : Page
    , navState : Navbar.State
    , navKey : Navigation.Key
    }

type alias Flags =
    {}