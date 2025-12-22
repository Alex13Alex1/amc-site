import { useMemo, useState } from "react";
import { lesson1 } from "./lessons/lesson1";
import { speakEN } from "./teacher/speak";
import { useMicPitch } from "./audio/useMicPitch";

export default function App() {
  const lesson = useMemo(() => lesson1, []);
  const [stepIdx, setStepIdx] = useState(0);
  const [listening, setListening] = useState(false);

  const step = lesson.steps[stepIdx];
  const { status, note, freq } = useMicPitch(listening);

  const ok = step.target && note === step.target;

  function next() {
    setStepIdx((i) => Math.min(i + 1, lesson.steps.length - 1));
  }
  function prev() {
    setStepIdx((i) => Math.max(i - 1, 0));
  }

  return (
    <div style={{ fontFamily: "system-ui", padding: 16, maxWidth: 900, margin: "0 auto" }}>
      <h1>{lesson.title}</h1>

      <div style={{ display: "grid", gridTemplateColumns: "1.1fr 0.9fr", gap: 16 }}>
        {/* Teacher */}
        <div style={{ border: "1px solid #ddd", borderRadius: 16, padding: 16 }}>
          <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
            <div
              style={{
                width: 88,
                height: 88,
                borderRadius: 20,
                background: "#f2f4f7",
                display: "grid",
                placeItems: "center",
                fontSize: 36,
              }}
              aria-label="Teacher avatar"
              title="Teacher"
            >
              🎹
            </div>
            <div>
              <div style={{ fontWeight: 700 }}>Mr. Piano</div>
              <div style={{ opacity: 0.7 }}>English only • Beginner course</div>
            </div>
          </div>

          <div style={{ marginTop: 16, fontSize: 18, lineHeight: 1.4 }}>{step.say}</div>

          <div style={{ display: "flex", gap: 10, marginTop: 14, flexWrap: "wrap" }}>
            <button onClick={() => speakEN(step.say)} style={btn()}>
              🔊 Speak (EN)
            </button>

            <button onClick={() => setListening((v) => !v)} style={btn(listening)}>
              {listening ? "🎙 Stop listening" : "🎙 Start listening"}
            </button>

            <button onClick={prev} style={btn()} disabled={stepIdx === 0}>
              ← Back
            </button>
            <button onClick={next} style={btn()} disabled={stepIdx === lesson.steps.length - 1}>
              Next →
            </button>
          </div>

          {step.target && (
            <div style={{ marginTop: 14, padding: 12, borderRadius: 12, background: "#f8fafc" }}>
              <div>
                <b>Target:</b> {step.target}
              </div>
              <div>
                <b>Heard:</b> {note ?? "—"} {freq ? `(${freq.toFixed(1)} Hz)` : ""}
              </div>
              <div style={{ marginTop: 8 }}>
                {ok ? (
                  <b style={{ color: "green" }}>✅ Correct!</b>
                ) : (
                  <span style={{ opacity: 0.7 }}>Play the target note on the real piano.</span>
                )}
              </div>
            </div>
          )}
        </div>

        {/* “Virtual keyboard” (пока как подсказка) */}
        <div style={{ border: "1px solid #ddd", borderRadius: 16, padding: 16 }}>
          <div style={{ fontWeight: 700, marginBottom: 8 }}>Keyboard (visual guide)</div>
          <div style={{ opacity: 0.7, marginBottom: 12 }}>
            Child plays on a real piano, this is only a visual reference.
          </div>

          <KeyboardHint highlight={step.target} />
          <div style={{ marginTop: 12, fontSize: 13, opacity: 0.7 }}>Mic status: {status}</div>
        </div>
      </div>
    </div>
  );
}

function btn(active = false) {
  return {
    padding: "10px 12px",
    borderRadius: 12,
    border: "1px solid #ccc",
    background: active ? "#e6f0ff" : "white",
    cursor: "pointer",
    fontWeight: 600,
  };
}

function KeyboardHint({ highlight }) {
  // Simplified: show C4 D4 E4 only for MVP
  const keys = ["C4", "D4", "E4", "F4", "G4"];
  return (
    <div style={{ display: "flex", gap: 8 }}>
      {keys.map((k) => (
        <div
          key={k}
          style={{
            flex: 1,
            height: 120,
            borderRadius: 14,
            border: "1px solid #cbd5e1",
            background: highlight === k ? "#dbeafe" : "#fff",
            display: "grid",
            placeItems: "center",
            fontWeight: 800,
            fontSize: 18,
          }}
        >
          {k}
        </div>
      ))}
    </div>
  );
}
