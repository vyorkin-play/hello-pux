module Play.Counter where

import Prelude (id, const, show, (+), (-))

import Pux.Html (Html, button, div, span, (!), (#>), (##))
import Pux.Html.Events (onClick)

data Action = Inc | Dec
type State = Int

init :: Int -> State
init = id

update :: Action -> State -> State
update Inc count = count + 1
update Dec count = count - 1

view :: State -> Html Action
view count =
  div ##
    [ button ! onClick (const Inc) #> "+"
    , span #> show count
    , button ! onClick (const Dec) #> "-"
    ]
