port module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Html exposing (Html, text, div, h1, h2, h3, h4, h5, h6, img, a, table, tr, th, br, ul, li, p, hr, button, input, form)
import Html.Attributes exposing (src, attribute, href, class, id, alt, style, attribute)
import Html.Events exposing (onClick, onInput)
import Http exposing (get)

import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser, s, top)

import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Text as Text
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Bootstrap.ButtonGroup as ButtonGroup

import Datatypes exposing (..)
import Header exposing (menu)
import Resources exposing (resource_index, energyPage, agriculturePage, socialSystemsPage)
import Twitter exposing (twitterAdventuresPage)
import Bootstrap.Navbar exposing (subscriptions)
import Html.Attributes exposing (placeholder, value, type_)



---- BOOK KEEPING ----
init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        ( model, urlCmd ) =
            urlUpdate url { navKey = key, navState = navState, page = HomePage, startDate = "2015-01-01", endDate = "2020-09-30", datesValid = True, frequency = Minute, time_series = ([], []) }
    in
        ( model, Cmd.batch [ urlCmd, navCmd ] )


urlUpdate : Url -> Model -> ( Model, Cmd Msg )
urlUpdate url model =
    case decode url of
        Nothing ->
            ( { model | page = NotFound }, Cmd.none )

        Just route ->
            ( { model | page = route }, Cmd.none )


decode : Url -> Maybe Page
decode url =
    { url | path = Maybe.withDefault "" url.fragment, fragment = Nothing }
    |> UrlParser.parse routeParser

routeParser : Parser (Page -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map HomePage top
        , UrlParser.map EnergyPage (s "energy")
        , UrlParser.map AgriculturePage (s "agriculture")
        , UrlParser.map SocialSystemsPage (s "social-systems")
        , UrlParser.map TwitterPage (s "twitter")
        , UrlParser.map AboutPage (s "about")
        ]

subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navState NavMsg


---- UPDATE ----
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
    case msg of
        ClickedLink req ->
             case req of
                 Browser.Internal url ->
                     ( model, Navigation.pushUrl model.navKey <| Url.toString url )

                 Browser.External href ->
                     ( model, Navigation.load href )


        UrlChange url ->
            urlUpdate url model

        NavMsg state ->
            ( { model | navState = state }
            , Cmd.none
            )

        SubmitDate ->
            (model, fetchTimeSeries model.startDate model.endDate)

        ChangeStartDate start ->
            ( { model | startDate = start, datesValid = validateModel model }
            , Cmd.none
            )

        ChangeEndDate end ->
            ( { model | endDate = end, datesValid = validateModel model }
            , Cmd.none
            )

        ChangeFrequency frequency ->
            ( { model | frequency = frequency }
            , Cmd.none
            )

        GotTimeSeries result ->
            case result of
                Ok fullText ->
                    update UpdateFigure { model | time_series = parseTimeSeries(fullText) }

                Err _ ->
                    (model, Cmd.none) -- TODO display the error somehow

        UpdateFigure ->
            let (x,y) = model.time_series
                (x_scaled, y_scaled) = scale model.frequency x y
                js_scatter_plot = formatScatterPlotDescription x y
            in
                ( model, login ("[" ++ js_scatter_plot ++ "]", figure_div_name) )
        
        NoOp -> (model, Cmd.none)

validateModel : Model -> Bool
validateModel model = 
    model.startDate < model.endDate

scale: Frequency -> List String -> List String -> (List String, List String)
scale freq x y = (x,y)

formatScatterPlotDescription : List String -> List String -> String
formatScatterPlotDescription x y = 
    let x_hs = String.join ", " (List.map (\a -> "\"" ++ a ++ "\"") x)
        y_hs = String.join ", " y
    in """{"x": [""" ++ x_hs ++ """], "y": [""" ++ y_hs ++ """], "type": "scatter"}"""

fetchTimeSeries : String -> String -> Cmd Msg
fetchTimeSeries start end =
    let url = "https://www.sebastiandebellefon.com/time_series/gb_wind_actual?start=" ++ start ++ "&end=" ++ end
    in
        Http.get
            { url = url
            , expect = Http.expectString GotTimeSeries
            }

parsePoint s = 
    case String.split " " s of
       [a, b] -> Maybe.Just (a,b)
       _ -> Maybe.Nothing

parseTimeSeries : String -> (List String, List String)
parseTimeSeries s =
    let
        lines = String.split "\n" s
        pairs = List.filterMap identity (List.map parsePoint lines)
        x = List.map (\ (a,_) -> a) pairs
        y = List.map (\ (_,b) -> b) pairs
    in
        (x,y)

---- VIEW ----
pageNotFound : Html Msg
pageNotFound = 
    div [] [ h1 [] [ text "Not found" ]
    , text "Could not find this page"
    ]


---- VIEW ----
publication : String -> String -> String -> String -> Html Msg
publication url description image alt_text = 
    tr [] [
        th [style "text-align" "center"] [ a [ href url ] [ img [class "u-max-full-width", style "border-radius" "5px", src image, alt alt_text] [] ] ],
        th [] [ a [ href url] [ h6 [] [ text description ] ] ]
    ]

figure_div_name = "figure"
--featured : Html Msg
--featured =
--    let article_description = "The decline in average revenue seen in some recent literature is due to an implicit policy assumption that technologies are forced into the system, whether it be with subsidies or quotas. If instead the driving policy is a carbon dioxide cap or tax, wind and solar shares can rise without cannibalising their own market revenue, even at penetrations of wind and solar above 80%."
--        article_title = "Decreasing market value of variable renewables is a result of policy, not variability"
--        article_url = "https://arxiv.org/abs/2002.05209" in
--    div []
--        [ Grid.row [Row.attrs [class "mt-5", class "mb-4"]] [ Grid.col [Col.textAlign Text.alignMdCenter] [ h1 [] [text "What I'm reading"] ] ]
--        , Grid.row [Row.middleXs]
--                [ Grid.col [Col.lgAuto] [ img [style "border-radius" "5px", style "max-width" "150px", src "images/Cornell_Seal_Black.png", alt "journal"] [] ]
--                , Grid.col [Col.textAlign Text.alignMdLeft]
--                            [a [href article_url] [text article_title ]
--                            , br [] [], br [] []
--                            , text article_description
--                            ]
--                ]
--        ]

publications : Html Msg
publications = 
    div []
        [ Grid.row [Row.attrs [class "mt-5", class "mb-4"]] [Grid.col [Col.textAlign Text.alignMdCenter] [ h1 [] [text "My writings & publications"] ] ]
        , Grid.row [Row.middleXs]
                   [Grid.col [Col.textAlign Text.alignMdLeft, Col.xs10, Col.offsetSm1 ]
                             [ text "Research articles:"
                             , ul [] [
                                       li [] [a [href "https://genomebiology.biomedcentral.com/articles/10.1186/s13059-019-1749-5"] [text "Integrative analysis of vascular endothelial cell genomic features identifies AIDA as a coronary artery disease candidate gene" ]]
                                     , li [] [a [href "https://www.biorxiv.org/content/10.1101/2020.11.23.394296v1"]                [text "find-tfbs: a tool to identify functional non-coding variants associated with complex human traits using open chromatin maps and phased whole-genome sequences" ]]
                                     ]
                             , text "Blog articles for Octo Technology:"
                             , ul [] [
                                       li [] [ a [href "https://blog.octo.com/le-multithreading-zen"]                               [text "Le multithreading zen" ]]
                                     , li [] [ a [href "https://blog.octo.com/design-patterns-saison-2"]                            [text "Design Patterns : Saison 2" ]]
                                     , li [] [ a [href "https://blog.octo.com/newsql-comment-distribuer-ses-donnees-avec-sqlfire"]  [text "NewSQL: Comment distribuer ses données avec SQLFire" ]]
                                     , li [] [ a [href "https://blog.octo.com/une-base-de-donnees-purement-fonctionnelle-2"]        [text "Une base de données purement fonctionnelle " ]]
                                     ]
                             , text "Open source software:"
                             , ul [] [
                                       li [] [a [href "https://github.com/Helkafen/website_personal"]                                     [text "This website (Elm framework, Bootstrap)" ]]
                                     , li [] [a [href "https://github.com/Helkafen/find-tfbs"]                                            [text "find-tfbs: a bioinformatics tool (Rust)" ]]
                                     , li [] [a [href "https://github.com/Helkafen/wai-middleware-metrics"]                               [text "wai-middleware-metrics: a webserver monitoring tool (Haskell)" ]]
                                     , li [] [a [href "https://github.com/Helkafen/haskell-linode"]                                       [text "haskell-linode: a cloud provisioning library (Haskell)" ]]
                                     , li [] [a [href "https://github.com/NixOS/nixpkgs/commit/93ce77af405b0be6a6f5f5108b8e59cbac97249d"] [text "Snakemake package for Nix (devops tool, reproducible research)" ]]
                                     ]
                             ]
                             
                   ]
        ]


pageAbout : Html Msg
pageAbout = 
        let about_description =
                    [
                      h1 [ id "about" ] [ text "About Me" ]
                    , text "I see broken things and fix them. Background in electrical engineering, software engineering and genetics. Interested in sustainability and energy systems."
                    , br [] [], br[] []
                    , text "Here's what I do best:"
                    , div [] [
                              ul []
                                    [ li [] [ text "Bring clarity to complex systems" ]
                                    , li [] [ text "Build robust software and databases" ]
                                    , li [] [ text "Deliver accurate research and communicate my findings to expert and non-expert audiences" ]
                                    , a [ href "/files/resume_sebastian_meric_de_bellefon.pdf" ] [ text "Resume" ]
                                    , text "/"
                                    , a [ href "https://twitter.com/Helkafen" ] [ text "Twitter" ]
                                    , text "/"
                                    , a [ href "https://www.linkedin.com/in/sebastian-de-bellefon-69804b6/" ] [ text "LinkedIn" ]
                                    ]
                                ]
                    ] in
        div [] [
            div [] [ Grid.row [Row.attrs [class "mt-5", class "mb-1"]] [ Grid.col [Col.textAlign Text.alignMdCenter] [ h1 [] [text ""] ] ]
                   , Grid.row [Row.middleXs]
                               [ Grid.col [Col.lgAuto] [ img [style "border-radius" "5px", attribute "style" "max-width: 320px;", src "images/sebastian meric de bellefon.jpg", alt "portrait"] [] ]
                               , Grid.col [Col.textAlign Text.alignMdLeft] about_description
                               ]
                   ]
            , publications
        ]


vara = """{x: ['2016-01-01T00:00:00Z', '2016-01-01T00:01:00Z', '2016-01-01T00:02:00Z'], y: [1, 3, 6], type: 'scatter'}"""
varb = """{x: ['2016-01-01T00:00:00Z', '2016-01-01T00:01:00Z', '2016-01-01T00:02:00Z'], y: [1.2, 3.1, 6.7], type: 'scatter'}"""
vard = "[" ++ vara ++ ", " ++ varb ++ "]" 

vara_js = """{"x": ["2016-01-01T00:00:00Z", "2016-01-01T00:01:00Z", "2016-01-01T00:02:00Z"], "y": [1, 3, 6], "type": "scatter"}"""
varb_js = """{"x": ["2016-01-01T00:00:00Z", "2016-01-01T00:01:00Z", "2016-01-01T00:02:00Z"], "y": [1.2, 3.1, 6.7], "type": "scatter"}"""
vard_js = "[" ++ vara_js ++ ", " ++ varb_js ++ "]" 


view : Model -> Browser.Document Msg
view model =
        { title = "Sébastian Méric de Bellefon"
        , body =
            [ div []
                [ menu model
                , mainContent model
                ]
            ]
        }

mainContent : Model -> Html Msg
mainContent model = 
    Grid.container [] <|
        case model.page of
            HomePage ->          [pageHome model]
            EnergyPage ->        [energyPage]
            AgriculturePage ->   [agriculturePage]
            SocialSystemsPage -> [socialSystemsPage]
            TwitterPage ->       [twitterAdventuresPage]
            AboutPage ->         [pageAbout]
            NotFound ->          [pageNotFound]

minDate = "2015-01-01"
maxDate = "2020-09-30"

pageHome : Model -> Html Msg
pageHome model = 
    div [ class "bg-white" ]
        [ title_div
        , div [id figure_div_name, class "mt-3 mb-0", style "width" "100%", style "height" "300px"] []
        , div []
                    [ h4 [] [ text "Select a date range"]
                    , Form.group []
                        [ Form.label [] [ text "Start date" ]
                        , Input.text [ Input.attrs [ type_ "date", value model.startDate, onInput ChangeStartDate, attribute "min" minDate, attribute "max" maxDate] ]
                        ]
                    , Form.group []
                        [ Form.label [] [ text "End date" ]
                        , Input.text [ Input.attrs [ type_ "date", value model.endDate, onInput ChangeEndDate, attribute "min" minDate, attribute "max" maxDate ]]
                        ]
                    , Form.group []
                        [ --Form.label [class "mb-1"] [ text "Frequency:  " ]
                          ButtonGroup.radioButtonGroup []
                              [ ButtonGroup.radioButton
                                  (model.frequency == Minute)
                                  [ Button.primary, Button.onClick <| ChangeFrequency Minute ]
                                  [ text "Minute" ]
                              , ButtonGroup.radioButton
                                  (model.frequency == Month)
                                  [ Button.primary, Button.onClick <| ChangeFrequency Month ]
                                  [ text "Month" ]
                              ]
                        ]
                    , button ([Html.Attributes.type_ "submit", class "btn btn-primary mb-2", onClick SubmitDate] ++ (if model.datesValid then [] else [attribute "disabled" ""])) [text "Submit"]
                    ]
        , resource_index
        --, hr [attribute "border-top" "10px double #8c8b8b", attribute "width" "80%"] []
        , div [class "bg-white"] [publications]
        ]

title_div : Html Msg
title_div = 
    div [class "masthead text-white text-center"]
        [
           div [class "overlay"] []
        ,  div [class "container"]
               [div [class "row col-xl-9 mx-auto" ]
                    [
                      h1 [class "md-5"] [text "A guide to clean technology and addressing climate change"]
                    , div [class "col-md-10 col-lg-8 col-xl-7 mx-auto"]
                          [
                              br [] [], h5 [class "mb-1"] [text "by Sébastian Méric de Bellefon "]
                          ,   a [class "mt-1 text-white", attribute "text-decoration" "none", attribute "hovercolor" "95a5a6", href "#about"] [h6 [] [text "About me »"]]
                          ]
                    ]
               ]
        ]

---- PROGRAM ----
main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = ClickedLink
        , onUrlChange = UrlChange
        }

port login : (String, String) -> Cmd msg