/**
 * Speak English text using Web Speech API (SpeechSynthesis).
 * Note: some browsers (especially Safari) require a user gesture.
 *
 * @param {string} text
 * @returns {boolean} true if speech was started, false otherwise
 */
export function speakEN(text) {
  // Works in many browsers; Safari can be picky about user gesture.
  if (!("speechSynthesis" in window)) return false;

  const u = new SpeechSynthesisUtterance(text);
  u.lang = "en-US";
  u.rate = 1.0;
  u.pitch = 1.0;
  u.volume = 1.0;

  // Cancel queue to avoid “stacking”
  window.speechSynthesis.cancel();
  window.speechSynthesis.speak(u);
  return true;
}
