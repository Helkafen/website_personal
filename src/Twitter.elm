module Twitter exposing (twitterAdventuresPage)

import Html exposing (Html, text, h1, a, br, li, ul, img, div)
import Html.Attributes exposing (src, href, class, href)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Bootstrap.Text as Text

import Datatypes exposing (Msg)

-- 
twitterAdventuresPage : Html Msg
twitterAdventuresPage = div []
        [ Grid.row [Row.attrs [class "mt-5"]] [ Grid.col [Col.textAlign Text.alignMdCenter] [ h1 [] [text "Twitter adventures"] ] ]
          , Grid.row [Row.middleXs, Row.attrs [class "mt-5"]]
            [ Grid.col [Col.textAlign Text.alignMdRight] [ twitter_pypsa ]
            , Grid.col [Col.textAlign Text.alignMdLeft] twitter_pypsa_comment
            ]
          , Grid.row [Row.middleXs, Row.attrs [class "mt-5"]]
            [ Grid.col [Col.textAlign Text.alignMdRight] [ twitter_weitzman ]
            , Grid.col [Col.textAlign Text.alignMdLeft] twitter_weitzman_comment
            ]
          , Grid.row [Row.middleXs, Row.attrs [class "mt-5"]]
            [ Grid.col [Col.textAlign Text.alignMdRight] [ twitter_pricing ]
            , Grid.col [Col.textAlign Text.alignMdLeft] twitter_pricing_comment
            ]
        ]

twitter_pypsa : Html Msg
twitter_pypsa = a [href "https://twitter.com/Helkafen/status/1215857505949179905?ref_src=twsrc%5Etfw"] [ img [src "images/twitter_pypsa.jpg", class "u-max-full-width"] [] ]

twitter_pypsa_comment : List (Html Msg)
twitter_pypsa_comment = 
    [ br [] []
    , text "A conversation about electricity grid modelling, demand-side management, storage and how to secure energy supply during extreme climatic events.  Renewable systems benefit from cross-border transmissions, which help each country minimize storage costs and specialize in their best renewable resources."
    , br [] []
    , br [] []
    , text "Sources:"
    , ul []
        [ li [] [ a [ href "https://www.sciencedirect.com/science/article/pii/S1364032118303307" ] [ text "A response to 'Burden of proof: A comprehensive review of the feasibility of 100% renewable-electricity systems'" ] ]
        , li [] [ a [ href "https://arxiv.org/abs/1704.05492" ]                                    [ text "The benefits of cooperation in a highly renewable European electricity network" ] ]
        , li [] [ a [ href "https://pypsa.org/" ]                                                  [ text "PyPSA: Python for Power System Analysis" ] ] ]
    ]


twitter_weitzman : Html Msg
twitter_weitzman = a [href "https://twitter.com/Helkafen/status/1195028098988855297?ref_src=twsrc%5Etfw"] [ img [src "images/twitter_weitzman.jpg", class "u-max-full-width"] [] ]

twitter_weitzman_comment : List (Html Msg)
twitter_weitzman_comment = 
    [ br [] []
    , text "Assessing the economic impacts of climate change."
    , br [] []
    , br [] []
    , text "The most discussed assessments are flawed. They focus on central tendencies and do not account for fat-tailed uncertainties. Some possible impacts are too large and the risk function cannot be defined properly."
    , br [] []
    , br [] []
    , text "The results of this work is inconsistent with the qualitative knowledge of climate scientists."
    , br [] []
    , br [] []
    , text "Sources:"
    , ul []
        [ li [] [ a [ href "https://scholar.harvard.edu/files/weitzman/files/fattaileduncertaintyeconomics.pdf" ]                                                     [ text "Fat-tailed uncertainty in the economics of catastrophic climate change" ] ]
        , li [] [ a [ href "https://theconversation.com/4-c-of-global-warming-is-optimal-even-nobel-prize-winners-are-getting-things-catastrophically-wrong-125802" ] [ text "'4C of global warming is optimal': When Nobel prize winners are getting things catastrophically wrong" ] ]
        ]
    ]


twitter_pricing : Html Msg
twitter_pricing = a [href "https://twitter.com/Helkafen/status/1230959212689338374?ref_src=twsrc%5Etfw"] [ img [src "images/twitter_pricing.jpg", class "u-max-full-width"] [] ]

twitter_pricing_comment : List (Html Msg)
twitter_pricing_comment = [
    br [] []
    , text "Understanding the effect of carbon pricing and subsidies on the market value of renewables."
    , br [] [] , br [] []
    , text "A low market value does not necessarily indicate a problem with the integration of variable sources of energy."
    , br [] [] , br [] []
    , text "Source:"
    , ul []
        [ li [] [ a [ href "https://arxiv.org/abs/2002.05209" ] [ text "Decreasing market value of variable renewables is a result of policy, not variability" ] ] ]
    ]