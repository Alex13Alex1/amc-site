import { useEffect, useRef, useState } from "react";
import { autoCorrelate, freqToNoteName } from "./pitch";

export function useMicPitch(enabled) {
  const [status, setStatus] = useState("idle"); // idle | starting | listening | error
  const [freq, setFreq] = useState(null);
  const [note, setNote] = useState(null);

  const rafRef = useRef(null);
  const audioRef = useRef(null);
  const analyserRef = useRef(null);
  const streamRef = useRef(null);

  useEffect(() => {
    let cancelled = false;

    async function start() {
      try {
        setStatus("starting");

        if (!navigator.mediaDevices?.getUserMedia) {
          if (!cancelled) setStatus("error");
          return;
        }

        const stream = await navigator.mediaDevices.getUserMedia({
          audio: {
            echoCancellation: true,
            noiseSuppression: true,
            autoGainControl: true,
          },
          video: false,
        });

        if (cancelled) {
          stream.getTracks().forEach((t) => t.stop());
          return;
        }

        const AudioCtx = window.AudioContext || window.webkitAudioContext;
        const ctx = new AudioCtx();
        const src = ctx.createMediaStreamSource(stream);
        const analyser = ctx.createAnalyser();
        analyser.fftSize = 2048;
        src.connect(analyser);

        const buf = new Float32Array(analyser.fftSize);

        audioRef.current = ctx;
        analyserRef.current = analyser;
        streamRef.current = stream;

        setStatus("listening");

        const tick = () => {
          const a = analyserRef.current;
          const c = audioRef.current;
          if (!a || !c) return;

          a.getFloatTimeDomainData(buf);

          const f = autoCorrelate(buf, c.sampleRate);
          if (f > 0) {
            setFreq(f);
            setNote(freqToNoteName(f));
          } else {
            setFreq(null);
            setNote(null);
          }

          rafRef.current = requestAnimationFrame(tick);
        };

        rafRef.current = requestAnimationFrame(tick);
      } catch (e) {
        console.error(e);
        if (!cancelled) setStatus("error");
      }
    }

    function stop() {
      if (rafRef.current) cancelAnimationFrame(rafRef.current);
      rafRef.current = null;

      if (audioRef.current) audioRef.current.close();
      audioRef.current = null;

      if (streamRef.current) {
        streamRef.current.getTracks().forEach((t) => t.stop());
      }
      streamRef.current = null;
      analyserRef.current = null;

      setStatus("idle");
      setFreq(null);
      setNote(null);
    }

    if (enabled) start();
    else stop();

    return () => {
      cancelled = true;
      stop();
    };
  }, [enabled]);

  return { status, freq, note };
}

