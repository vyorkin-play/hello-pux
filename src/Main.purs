module Play.Main where

import Control.Monad.Eff (Eff)
import Network.HTTP.Affjax (AJAX)
import Play.Todos (init, view, update)
import Prelude (Unit, bind)
import Pux (CoreEffects, renderToDOM, start)

main :: Eff (CoreEffects (ajax :: AJAX)) Unit
main = do
  app <- start
    { initialState: init
    , update: update
    , view: view
    , inputs: []
    }

  renderToDOM "#app" app.html
