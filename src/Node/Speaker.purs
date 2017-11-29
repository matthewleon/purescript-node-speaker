module Node.Speaker (
  Speaker
, SPEAKER
, SpeakerOptions
, newSpeaker
, newSpeaker'
, onOpen
, onFlush
, module Node.Stream
) where

import Prelude

import Control.Monad.Eff (kind Effect, Eff)
import Node.Stream (Writable, onClose)

foreign import data SPEAKER :: Effect

type Speaker eff = Writable () (speaker :: SPEAKER | eff)

foreign import newSpeaker :: forall eff. Speaker eff

-- TODO: Either
newSpeaker'
  :: forall eff r r'
   . Union r r' SpeakerOptions
  => Record r
  -> Speaker eff
newSpeaker' = newSpeakerWithOptions

foreign import newSpeakerWithOptions
  :: forall eff r
   . Record r
  -> Speaker eff

type SpeakerOptions = (
-- speaker options
  channels :: Int
, bitDepth :: Int
, sampleRate :: Int
, signed :: Boolean
, float :: Boolean
, samplesPerFrame :: Int
)

foreign import onOpen
  :: forall eff. Speaker eff -> Eff eff Unit -> Eff eff Unit

foreign import onFlush
  :: forall eff. Speaker eff -> Eff eff Unit -> Eff eff Unit
