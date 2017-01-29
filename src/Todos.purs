module Play.Todos where

import Control.Monad.Aff (attempt)
import Data.Argonaut (class DecodeJson, decodeJson, (.?))
import Data.Either (Either(Left, Right), either)
import Network.HTTP.Affjax (AJAX, get)
import Prelude (bind, const, map, pure, show, ($), (<<<), (<>))
import Pux (EffModel, noEffects)
import Pux.Html (Html, button, div, h1, li, ol, text, (!), (#>), (##))
import Pux.Html.Attributes (className, key)
import Pux.Html.Events (onClick)

newtype Todo = Todo
  { id :: Int
  , title :: String
  }

type Todos = Array Todo

data Action
  = RequestTodos
  | ReceiveTodos (Either String Todos)

type State =
  { todos :: Todos
  , status :: String
  }

init :: State
init = { todos: []
       , status: "Nothing to see here yet"
       }

instance decodeJsonTodo :: DecodeJson Todo where
  decodeJson json = do
    obj <- decodeJson json
    id <- obj .? "id"
    title <- obj .? "title"
    pure $ Todo { id: id, title: title }

update :: Action -> State -> EffModel State Action (ajax :: AJAX)
update (ReceiveTodos (Left err)) state =
  noEffects $ state { status = "Error: " <> show err }
update (ReceiveTodos (Right todos)) state =
  noEffects $ state { status = "Todos", todos = todos }
update (RequestTodos) state =
  { state: state { status = "Fetching..." }
  , effects:
    [ do
      res <- attempt $ get "http://jsonplaceholder.typicode.com/users/1/todos"
      let decode r = decodeJson r.response :: Either String Todos
      let todos = either (Left <<< show) decode res
      pure $ ReceiveTodos todos
    ]
  }

view :: State -> Html Action
view state =
  div ##
    [ h1 #> state.status
    , div ##
      [ button ! onClick (const RequestTodos) #> "fetch"
      , ol ## map todo state.todos
      ]
    ]

todo :: Todo -> Html Action
todo (Todo state) =
  li [ key (show state.id), className "todo" ] [ text state.title ]
