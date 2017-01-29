module Play.App where

import Play.Counter as Counter
import Prelude (($), const, map)
import Pux.Html (Html, (!), (#>), (##), div, button)
import Pux.Html.Events (onClick)

data Action
  = Top (Counter.Action)
  | Bottom (Counter.Action)
  | Reset

type State =
  { top :: Counter.State
  , bottom :: Counter.State
  }

init :: Int -> State
init count =
  { top: Counter.init count
  , bottom: Counter.init count
  }

update :: Action -> State -> State
update (Top action) state = state { top = Counter.update action state.top }
update (Bottom action) state = state { bottom = Counter.update action state.bottom }
update Reset state = state { top = 0, bottom = 0 }

view :: State -> Html Action
view state = div ##
  [ map Top $ Counter.view state.top
  , map Bottom $ Counter.view state.bottom
  , button ! onClick (const Reset) #> "x"
  ]
