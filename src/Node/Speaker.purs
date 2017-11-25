module Node.Speaker (
  Speaker
, SPEAKER
, mkSpeaker
, mkSpeaker'
, SpeakerOptions
, module Node.Stream
) where

import Prelude

import Control.Monad.Eff (kind Effect, Eff)
import Node.Stream (Writable, onClose)

foreign import data SPEAKER :: Effect

type Speaker eff = Writable () (speaker :: SPEAKER | eff)

foreign import mkSpeaker :: forall eff. Speaker eff

-- TODO: Either
mkSpeaker'
  :: forall eff r r'
   . Union r r' SpeakerOptions
  => Record r
  -> Speaker eff
mkSpeaker' = mkSpeakerWithOptions

foreign import mkSpeakerWithOptions
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
