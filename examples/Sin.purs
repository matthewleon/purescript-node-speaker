module Sin where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Ref (REF)
import Data.ArrayBuffer.Safe.TypedArray as TA
import Data.ArrayBuffer.Safe.TypedArray.Uint8Array as U8A
import Data.Int (ceil, round, toNumber)
import Data.List as L
import Data.Maybe (Maybe(..), fromJust)
import Data.Tuple (Tuple(..))
import Math (pi, sin)
import Node.Buffer as NB
import Node.Speaker (SPEAKER, newSpeaker')
import Node.Stream.Readable as SR
import Partial.Unsafe (unsafePartial)

sinWave :: Int -> Int -> Number -> Number -> TA.Int16Array
sinWave channels sampleRate frequency duration =
  let numSamples = ceil $ toNumber sampleRate * duration
      amplitude = 32760.0 -- max amplitude for 16-bit audio
      samplesPerCycle = ceil $ toNumber sampleRate / frequency
      cyclesPerSample = frequency / toNumber sampleRate
      angle = pi * 2.0 * cyclesPerSample / toNumber channels
  in  unsafePartial $ fromJust $ TA.generate (numSamples * channels) \sample ->
        round (amplitude * sin (angle * toNumber sample))

main :: forall eff. Eff (console :: CONSOLE, buffer :: NB.BUFFER, speaker :: SPEAKER, ref :: REF | eff) Unit
main = do
  let speaker = newSpeaker' { channels: 2, bitDepth: 16, sampleRate: 44100 }
      noteFrequencies = L.fromFoldable
        [440.0, 493.883, 523.251, 587.330, 659.255, 698.456, 783.991]

  sinStream <- flip SR.unfoldr noteFrequencies $ \freqs -> case L.uncons freqs of
    Just {head: x, tail: xs} ->
      Just $ Tuple
        (U8A.fromArrayBuffer <<< TA.buffer $ sinWave 2 44100 x 1.0)
        xs
    Nothing -> Nothing

  log "Let me play you a scale."
  void $ sinStream `SR.pipe` speaker
  log "playing"
