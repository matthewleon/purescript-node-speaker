module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Node.Speaker (mkSpeaker')

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = void (pure $ mkSpeaker' {bitDepth: -1, sampleRate: -300})
