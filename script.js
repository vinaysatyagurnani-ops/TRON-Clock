// Tron timestamp: MM:DD:YY:WD:HH:MM:SS:CS
// WD is the ISO weekday (Monday = 01 ... Sunday = 07). CS is centiseconds.
function formatTronTime(now) {
  const pad2 = (n) => String(n).padStart(2, "0");

  const rawDay = now.getDay(); // 0 = Sunday ... 6 = Saturday
  const weekday = pad2(rawDay === 0 ? 7 : rawDay);

  const month = pad2(now.getMonth() + 1);
  const day = pad2(now.getDate());
  const year = pad2(now.getFullYear() % 100);
  const hour = pad2(now.getHours());
  const minute = pad2(now.getMinutes());
  const second = pad2(now.getSeconds());
  const centisecond = pad2(Math.floor(now.getMilliseconds() / 10));

  return `${month}:${day}:${year}:${weekday}:${hour}:${minute}:${second}:${centisecond}`;
}

// Two states: "clock" (live timestamp) and "password" (the digits scramble into PASSWORD:).
// The macOS screensaver flips the state from native code; in a browser any key flips it and Esc flips back.
function createTron(element) {
  const SCRAMBLE = "0123456789ABCDEF:";
  const TARGET = "PASSWORD:";
  const MORPH_MS = 650;

  let mode = "clock";
  let morphStart = 0;
  let cursor = null;

  const setText = (text) => {
    element.textContent = text;
    if (cursor) element.appendChild(cursor);
  };

  const renderClock = () => setText(formatTronTime(new Date()));

  const renderMorph = (now) => {
    const t = Math.min(1, (now - morphStart) / MORPH_MS);
    const settled = Math.floor(t * TARGET.length);
    let out = "";
    for (let i = 0; i < TARGET.length; i++) {
      if (i < settled) out += TARGET[i];
      else out += SCRAMBLE[Math.floor(Math.random() * SCRAMBLE.length)];
    }
    setText(out);
    if (t >= 1) {
      mode = "password";
      cursor = document.createElement("span");
      cursor.className = "cursor";
      setText(TARGET);
    }
  };

  const tick = (now) => {
    if (mode === "clock") renderClock();
    else if (mode === "morphing") renderMorph(now);
    requestAnimationFrame(tick);
  };
  requestAnimationFrame(tick);

  return {
    showPassword() {
      if (mode !== "clock") return;
      mode = "morphing";
      morphStart = performance.now();
      element.classList.add("password");
    },
    showClock() {
      mode = "clock";
      cursor = null;
      element.classList.remove("password");
      renderClock();
    },
    get mode() {
      return mode;
    },
  };
}

if (typeof document !== "undefined") {
  const element = document.querySelector(".timestamp");
  if (element) {
    window.tron = createTron(element);
    window.addEventListener("keydown", (e) => {
      if (e.key === "Escape") window.tron.showClock();
      else if (!e.metaKey && !e.ctrlKey && !e.altKey) window.tron.showPassword();
    });
  }
}

if (typeof module !== "undefined") {
  module.exports = { formatTronTime };
}
