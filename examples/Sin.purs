module Sin where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Data.ArrayBuffer.Safe.TypedArray as TA
import Data.Int (ceil, round, toNumber)
import Data.Maybe (fromJust)
import Math (pi, sin)
import Node.Buffer as NB
import Node.Speaker (SPEAKER, newSpeaker')
import Node.Stream (write)
import Partial.Unsafe (unsafePartial)


sinWave :: Int -> Int -> Int -> Number -> TA.Int16Array
sinWave channels sampleRate frequency duration =
  let numSamples = ceil $ toNumber sampleRate * duration
      amplitude = 32760.0 -- max amplitude for 16-bit audio
      samplesPerCycle = ceil $ toNumber sampleRate / toNumber frequency
      cyclesPerSample = toNumber frequency / toNumber sampleRate
      angle = pi * 2.0 * cyclesPerSample / toNumber channels
  in  unsafePartial $ fromJust $ TA.generate (numSamples * channels) \sample ->
        round (amplitude * sin (angle * toNumber sample))

main :: forall eff. Eff (console :: CONSOLE, buffer :: NB.BUFFER, speaker :: SPEAKER | eff) Unit
main = do
  let sw = sinWave 2 44100 440 1.0
      speaker = newSpeaker' { channels: 2, bitDepth: 16, sampleRate: 44100 }
  log "writing sinwave"
  sinBuffer <- NB.fromArrayBuffer $ TA.buffer sw
  void $ write speaker sinBuffer (
    log "wrote sinwave"
  )
