module Resources exposing (resource_index, energyPage, agriculturePage, socialSystemsPage)

import Html exposing (Html, text, div, h1, h2, h3, h4, h5, h6, img, a, b, br, ul, li, p)
import Html.Attributes exposing (src, attribute, href, class, id, alt, attribute, style)
import Datatypes exposing (Msg(..), Page(..))


article : String -> String -> String -> Html Msg
article url title description = 
    li []
        [
            p [class "mb-0"] [a [ href url ][ b [] [ text title ]]]
        ,   text description
        ,   p[] []
        ]

section : String -> List (Html Msg) -> Html Msg
section title articles = div [] [h5 [ class "mt-5" ] [text title], ul [] articles]

pageHeader : String -> String -> String -> Html Msg
pageHeader title description image = 
    div [] [ h1 [ class "mt-5", style "text-align" "center" ] [ text title ]
           , h4 [ class "mb-3", style "text-align" "center"] [ text description ]
           , div [style "text-align" "center", class "mb-5"] [img [style "border-radius" "5px", style "max-width" "250px", src image, style "text-align" "center"] []]]

energyPage : Html Msg
energyPage =
    div [] [
      pageHeader "Energy Resources" "A collection of research papers about the decarbonization of the electricity sector" "images/energy.jpg"
    , section "Feasibility studies about low-carbon electricity grids"
        [
          article "https://arxiv.org/abs/1801.05290" "Synergies of sector coupling and transmission reinforcement in a cost-optimised, highly-renewable European energy system" "The decarbonization of transport and heating facilitates the integration of variable renewables and balances seasonal variations. Cross-border integration aggregates and smooths the output of intermittent electricity sources, reducing the need for storage. Power-to-gas units provide affordable long-term storage (hydrogen, synthetic methane)."
        , article "https://environmenthalfcentury.princeton.edu/sites/g/files/toruqf331/files/2020-12/Princeton_NZA_Interim_Report_15_Dec_2020_FINAL.pdf" "Net zero America - Potential Pathways, infrastructure and impacts" "Five pathways to decarbonize the USA"
        , article "https://energyinnovation.org/wp-content/uploads/2020/09/Pathways-to-100-Zero-Carbon-Power-by-2035-Without-Increasing-Customer-Costs.pdf" "Illustrative pathways too 100 percent zero carbon power by 2035 without increasing customer costs" "Bridging the gap between a 90% and 100% clean grid: hydrogen, CCS, synthetic methane and Direct air capture"
        , article "https://www.sciencedirect.com/science/article/pii/S1364032118303307?via%3Dihub" "Response to 'Burden of proof: A comprehensive review of the feasibility of 100% renewable-electricity systems'" "Evidence for the feasibility and viability of renewables-based systems"
        , article "https://www.sciencedirect.com/science/article/pii/S1876610218310221" "The role of storage technologies for the transition to a 100% renewable energy system in Europe" "Hourly simulation of a European grid"
        , article "https://www.sciencedirect.com/science/article/pii/S0378779620304934?via%3Dihub" "The near-optimal feasible space of a renewable power system model" "Exploring the design space and answering questions like: 'What happens if we build 10% less offshore wind compared to a cost-optimal grid?'"
        ]
    , section "Storage technologies"
        [
          article "https://www.sciencedirect.com/science/article/pii/S254243511830583X" "Projecting the future levelized cost of electricity storage technologies" "Comparing the costs of storage technologies: lithium-ion batteries are the cheapest option for short-term storage, while hydrogen, pumped storage and compressed air shine for long discharges. Costs will keep going down between 2030 and 2050."
        , article "https://www.sciencedirect.com/science/article/abs/pii/S0360319914021223" "Geologic storage of hydrogen: scaling up to meet transportation demands" "The storage of green hydrogen in geologic sites (e.g salt caverns, aquifers, depleted oil/gas reservoirs) is cheap."
        , article "https://about.bnef.com/blog/liebreich-separating-hype-from-hydrogen-part-two-the-demand-side/" "Liebreich: Separating Hype from Hydrogen – Part Two: The Demand Side" "The markets for hydrogen: industrial feedstock and heat, steel making, grid storage, aviation, but not ground transport."
        ]
    , section "Decarbonization policies"
        [
            article "https://arxiv.org/abs/1809.03157" "Counter-intuitive behaviour of energy system models under CO2 caps and prices" "Paradoxically, a low carbon cap can favor cheap high-emissions technologies in the presence of a tight budget. This is similar to cap-and-trade systems where technical innovations can lower the cost of permits and allow high emission industries."
        ,   article "https://arxiv.org/abs/2002.05209" "Decreasing market value of variable renewables is a result of policy, not variability" "The decline in average revenue seen in some recent literature is due to an implicit policy assumption that technologies are forced into the system, whether it be with subsidies or quotas. If instead the driving policy is a carbon dioxide cap or tax, wind and solar shares can rise without cannibalising their own market revenue, even at penetrations of wind and solar above 80%."
        ]
    ]

agriculturePage : Html Msg
agriculturePage = 
    div [] [
      pageHeader "Agriculture Resources" "Potential for regenerative agriculture and dietary changes to turn agriculture into a carbon sink" "images/agroforestry.jpg"
    , article "http://carbonfarmingsolution.com" "The Carbon Farming Solution" "A fantastic overview of regenerative agriculture practices, with a focus on carbon capture, food security and biodiversity."
    , article "https://www.rethinkx.com/food-and-agriculture" "Rethinking Food and Agriculture" "A report about the possible disruption of agriculture by precision biology, which would lead to a significant reduction in carbon emissions, and the potential to rewild vast areas."
    , article "https://science.sciencemag.org/content/360/6392/987.full" "Reducing food's environmental impacts through producers and consumers" "Solutions for the carbon emissions of the food industry, including transport and packaging."
    ]


socialSystemsPage : Html Msg
socialSystemsPage = 
    div [] [
      pageHeader "Social Systems Resources" "Social sciences and psychology show us how to enact systemic change for the environment" "images/social.jpg"
    , article "https://onlinelibrary.wiley.com/doi/full/10.1002/sd.1947" "The contradiction of the sustainable development goals: Growth versus ecology on a finite planet - Jason Hickel" "Perpetual growth is inconsistent with climate change mitigation and biodiversity. The Sustainable Development Goals are therefore inconsistent."
    , article "https://www.bbc.com/future/article/20190513-it-only-takes-35-of-people-to-change-the-world" "The '3.5% rule': How a small minority can change the world - David Robson" "Protests engaging a threshold of 3.5% of the population have never failed to bring about change."
    , article "https://areomagazine.com/2019/10/01/bad-psychology-why-climate-change-wont-be-solved-by-better-decisions-at-the-supermarket" "Bad psychology: Why climate change won't be solved by better decisions at the supermarket - Mads Nordmo Arnestad" "The limits of individual actions are rooted in psychology."
    , article "https://www.theclimatemobilization.org/transformative" "The transformative power of climate truth - Margaret Klein Salamon, PhD" "The strategic necessity of speaking the truth about climate change."
    , article "https://www.vox.com/energy-and-environment/2017/9/26/16356524/the-population-question" "I’m an environmental journalist, but I never write about overpopulation. Here’s why. -  David Roberts" "Reminders about the empowerment of young women, eugenics, and environmental inequalities."
    , article "https://www-cdn.oxfam.org/s3fs-public/file_attachments/mb-extreme-carbon-inequality-021215-en.pdf" "Extreme carbon inequality - Oxfam" "An estimate of the environmental footprint of consumption, and how it differs between and within countries."
    ]


resource_index : Html Msg
resource_index = 
    let one_link label image url description =
            div [class "col-md-4"] [
                div [class "card", class "mb-4", class "border-0"] [
                    a [ href url ] [ img [ alt label, class "card-img-to img-fluid", src image, attribute "style" "border-radius: 5px" ] [] , text " "]
                    , div [class "card-text"]
                        [
                            p [class "mb-1", class "mt-1" ] [a [ href url ][ b [] [ text description ]]]
                        ] 
                ]
            ] in
    div [ class "album py-5 bg-white" ]
        [
            div [ class "container", style "text-align" "center" ]
            [ div [ class "row mt-4 mb-0" ] [ div [class "col-md-8 mx-auto"] [ h1 [class "center"] [ text "Resources" ] ] ]
            , div [ class "row mt-0 mb-2" ] [ div [class "col-md-10 mx-auto"] [ h6 [class "center"] [ text "A collection of science-based articles about clean energy, farming and social change" ] ] ]
            , div [ class "row" ]
                [ one_link "Renewable energy"                         "images/energy.jpg"       "#energy"        "Energy"
                , one_link "Regenerative and sustainable agriculture" "images/agroforestry.jpg" "#agriculture"   "Agriculture"
                , one_link "Social systems"                           "images/social.jpg"       "#social-systems" "Social systems"
                ]
            ]
        ]
