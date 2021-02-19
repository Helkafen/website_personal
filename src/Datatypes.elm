module Datatypes exposing (..)

import Browser.Navigation as Navigation
import Browser exposing (UrlRequest)
import Http

import Url exposing (Url)
import Bootstrap.Navbar as Navbar

type Msg
    = NavMsg Navbar.State
    | UrlChange Url
    | ClickedLink UrlRequest
    | SubmitDate
    | GotTimeSeries (Result Http.Error String)
    | ChangeStartDate String
    | ChangeEndDate String
    | ChangeFrequency Frequency
    | UpdateFigure
    -- | RefreshFigure String String
    -- | Failure
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
   TwitterPage        -> "#twitter"
   AboutPage          -> "#about"
   NotFound           -> "#"

type alias Model = 
    { page : Page
    , navState : Navbar.State
    , navKey : Navigation.Key
    , startDate : String
    , endDate : String
    , datesValid : Bool
    , frequency : Frequency
    , time_series : (List String, List String)
    }

type Frequency
    = Minute
    | Month

type alias Flags =
    {}