module Main where

import Prelude
import App.Presentation (view)
import App.Text (Language(..))
import Control.Monad.Eff (Eff)
import DOM (DOM)
import Pux (App, Config, CoreEffects, renderToDOM, start, fromSimple)
import Pux.Devtool (Action, start) as Pux.Devtool
import Pux.Router (sampleUrl)
import Signal ((~>))

type Action = Unit

type State = Unit

type AppEffects = (dom :: DOM)

config :: forall eff. State -> Eff (dom :: DOM | eff) (Config State Action AppEffects)
config state = do
  urlSignal <- sampleUrl
  let routeSignal = urlSignal ~> const unit
  pure
    { initialState: state
    , update: fromSimple \_ s -> s
    , view: const (view PT)
    , inputs: [routeSignal]
    }

main :: State -> Eff (CoreEffects AppEffects) (App State Action)
main state = do
  app <- start =<< config state
  renderToDOM "#app" app.html
  pure app

debug :: State -> Eff (CoreEffects AppEffects) (App State (Pux.Devtool.Action Action))
debug state = do
  app <- Pux.Devtool.start =<< config state
  renderToDOM "#app" app.html
  pure app
