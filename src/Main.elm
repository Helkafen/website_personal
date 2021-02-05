module Main exposing (..)

import Browser
import Browser.Navigation as Navigation
import Html exposing (Html, text, div, h1, h2, h3, h4, h5, h6, img, a, table, tr, th, br, ul, li, p, hr, button)
import Html.Attributes exposing (src, attribute, href, class, id, alt, style, attribute)
import Html.Events exposing (onClick)

import Url exposing (Url)
import Url.Parser as UrlParser exposing ((</>), Parser, s, top)

import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Text as Text

import Datatypes exposing (..)
import Header exposing (menu)
import Resources exposing (resource_index, energyPage, agriculturePage, socialSystemsPage)
import Twitter exposing (twitterAdventuresPage)
import Bootstrap.Navbar exposing (subscriptions)



---- BOOK KEEPING ----
init : Flags -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        ( navState, navCmd ) =
            Navbar.initialState NavMsg

        ( model, urlCmd ) =
            urlUpdate url { navKey = key, navState = navState, page = AgriculturePage }
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

        NoOp -> (model, Cmd.none )


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
                                     , li [] [a [href "https://github.com/Helkafen/wai-middleware-metrics"]                               [text "wai-middleware-metrics: a webserver monitoring tools (Haskell)" ]]
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

pageHome : Model -> Html Msg
pageHome m = 
    div [ class "bg-white" ]
        [ title_div
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
