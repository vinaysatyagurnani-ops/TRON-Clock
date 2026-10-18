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

function startClock() {
  const element = document.querySelector(".timestamp");
  if (!element) return;

  let last = "";
  const tick = () => {
    const text = formatTronTime(new Date());
    if (text !== last) {
      element.textContent = text;
      last = text;
    }
    requestAnimationFrame(tick);
  };
  requestAnimationFrame(tick);
}

if (typeof document !== "undefined") {
  startClock();
}

if (typeof module !== "undefined") {
  module.exports = { formatTronTime };
}
