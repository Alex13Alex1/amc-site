// Simple autocorrelation pitch detection (good enough for beginner single notes)

export function freqToNoteName(freq) {
  // A4 = 440 Hz
  const A4 = 440;
  const noteNumber = Math.round(12 * Math.log2(freq / A4) + 69); // MIDI note
  const names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
  const name = names[(noteNumber + 1200) % 12];
  const octave = Math.floor(noteNumber / 12) - 1;
  return `${name}${octave}`;
}

export function autoCorrelate(buf, sampleRate) {
  // Returns fundamental frequency or -1
  const SIZE = buf.length;
  let rms = 0;
  for (let i = 0; i < SIZE; i++) rms += buf[i] * buf[i];
  rms = Math.sqrt(rms / SIZE);
  if (rms < 0.01) return -1; // too quiet

  // Remove DC offset
  let mean = 0;
  for (let i = 0; i < SIZE; i++) mean += buf[i];
  mean /= SIZE;
  const x = new Float32Array(SIZE);
  for (let i = 0; i < SIZE; i++) x[i] = buf[i] - mean;

  let bestOffset = -1;
  let bestCorr = 0;

  const minFreq = 50; // Hz
  const maxFreq = 1000; // Hz (piano fundamentals)
  const minOffset = Math.floor(sampleRate / maxFreq);
  const maxOffset = Math.floor(sampleRate / minFreq);

  for (let offset = minOffset; offset <= maxOffset; offset++) {
    let corr = 0;
    for (let i = 0; i < SIZE - offset; i++) {
      corr += x[i] * x[i + offset];
    }
    corr = corr / (SIZE - offset);
    if (corr > bestCorr) {
      bestCorr = corr;
      bestOffset = offset;
    }
  }

  if (bestCorr < 0.02 || bestOffset === -1) return -1;
  return sampleRate / bestOffset;
}
