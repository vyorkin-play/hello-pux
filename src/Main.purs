module Play where

import Control.Monad.Eff (Eff)
import Prelude (Unit, bind, const, show, (+), (-))
import Pux (CoreEffects, fromSimple, renderToDOM, start)
import Pux.Html (Html, button, div, span, text)
import Pux.Html.Events (onClick)

data Action = Inc | Dec
type State = Int

update :: Action -> State -> State
update Inc count = count + 1
update Dec count = count - 1

view :: State -> Html Action
view count =
  div
    []
    [ button [onClick (const Inc)] [text "+"]
    , span [] [text (show count)]
    , button [onClick (const Dec)] [text "-"]
    ]

main :: forall e. Eff (CoreEffects e) Unit
main = do
  app <- start
    { initialState: 0
    , update: fromSimple update
    , view: view
    , inputs: []
    }

  renderToDOM "#app" app.html
