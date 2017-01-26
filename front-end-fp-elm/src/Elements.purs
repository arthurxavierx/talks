module App.Elements where

import Spectacle as H
import App.Colors (primary, secondary, tertiary, white)
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Pux.Html (Attribute, Html, code, div, pre, (!), (#), (#>), (##))
import Pux.Html.Attributes (className, href, size, style, target) as A
import Spectacle.Attributes (bgColor, textColor, textSize) as A

type Component = forall a. Array (Attribute a) -> Array (Html a) -> Html a

type Style = Tuple String String

thin :: Style
thin = "fontWeight" /\ "100"

light :: Style
light = "fontWeight" /\ "300"

regular :: Style
regular = "fontWeight" /\ "400"

bold :: Style
bold = "fontWeight" /\ "bold"

color :: String -> Style
color = (/\) "color"

link :: Component
link = H.link ! A.style [ "color" /\ tertiary ] ! A.target "_blank"

heading :: Component
heading = H.heading ! A.style [ thin ]

title :: Component
title =
  heading
    ! A.size 4
    ! A.style [ thin, color secondary ]

subtitle :: Component
subtitle = heading ! A.size 5

contentSlide :: Component
contentSlide =
  H.slide ! A.bgColor white

list :: Component
list =
  H.list ! A.style [ color tertiary, "listStyleType" /\ "none" ]

sectionTitleSlide :: forall a. String -> String -> Html a
sectionTitleSlide _color _title =
  H.slide
    ! A.bgColor _color
    # heading
      ! A.size 3
      ! A.textColor white
      #> _title

appearingItem :: String -> Component
appearingItem _color attrs children =
  H.appear
  # H.listItem
  # (H.text
    ! A.textSize "6rem"
    ! A.style [ color _color, thin, "marginBottom" /\ "1.0rem" ]
    ) attrs children

appearingItemMedium :: String -> Component
appearingItemMedium _color attrs children =
  H.appear
  # H.listItem
  # (H.text
    ! A.textSize "3.6rem"
    ! A.style [ color _color, thin, "marginBottom" /\ "1.0rem" ]
    ) attrs children

appearingItemSmall :: String -> Component
appearingItemSmall _color attrs children =
  H.appear
  # H.listItem
  # (H.text
    ! A.textSize "2rem"
    ! A.style
      [ color _color
      , thin
      , "marginTop" /\ "-1.0rem"
      , "marginBottom" /\ "1.0rem"
      ]
    ) attrs children

codePane :: forall a. String -> String -> Html a
codePane l src =
  pre
    ! A.style
      [ "textAlign" /\ "left"
      , "lineHeight" /\ "1.1em"
      ]
    # code
      ! A.bgColor white
      ! A.style
        [ "fontSize" /\ "2.0rem"
        , "margin" /\ "0 auto"
        ]
      #> src

codePaneSmall :: forall a. String -> String -> Html a
codePaneSmall l src =
  pre
    ! A.style
      [ "textAlign" /\ "left"
      , "lineHeight" /\ "1.0em"
      ]
    # code
      ! A.className l
      ! A.bgColor white
      ! A.style
        [ "fontSize" /\ "1.5rem"
        , "margin" /\ "0 auto 0"
        , "padding" /\ "0 1em"
        ]
      #> src

resource :: forall a. String -> String -> Html a
resource name uri =
  H.listItem ##
    [ H.text ! A.textSize "2rem" ! A.textColor secondary #> name
    , div
      ! A.style
        [ "fontSize" /\ "1.2rem"
        , color primary
        , "marginBottom" /\ "2.0rem"
        ]
      # link ! A.href uri #> uri
    ]
