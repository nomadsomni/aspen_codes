const canvas = document.getElementById("signal");
const ctx = canvas.getContext("2d");

function resize() {
  canvas.width = window.innerWidth * devicePixelRatio;
  canvas.height = window.innerHeight * devicePixelRatio;
  ctx.scale(devicePixelRatio, devicePixelRatio);
}

resize();
window.addEventListener("resize", () => {
  ctx.setTransform(1, 0, 0, 1, 0, 0);
  resize();
});

const pulses = Array.from({ length: 24 }, () => ({
  x: Math.random() * window.innerWidth,
  y: Math.random() * window.innerHeight,
  r: 0,
  speed: 0.6 + Math.random() * 1.2,
  alpha: 0.4 + Math.random() * 0.4
}));

function draw() {
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.save();
  ctx.scale(devicePixelRatio, devicePixelRatio);

  pulses.forEach(p => {
    p.r += p.speed;
    if (p.r > 180) {
      p.r = 0;
      p.x = Math.random() * window.innerWidth;
      p.y = Math.random() * window.innerHeight;
    }
    ctx.beginPath();
    ctx.arc(p.x, p.y, p.r, 0, Math.PI * 2);
    ctx.strokeStyle = `rgba(102, 255, 214, ${p.alpha * (1 - p.r / 180)})`;
    ctx.lineWidth = 1;
    ctx.stroke();
  });

  ctx.restore();
  requestAnimationFrame(draw);
}

requestAnimationFrame(draw);

const consoleEl = document.getElementById("console");
const lines = [
  "Intent received: holographic clinic",
  "Routing: photonic spine -> metro ring -> edge node",
  "Proof: SLA signed, telemetry chained",
  "Intent received: orbital whisper",
  "Routing: ground mesh -> MEO relay -> LEO burst",
  "Proof: multi-orbit failover log",
  "Intent received: autonomous freight swarm",
  "Routing: edge quorum -> intermittent backhaul",
  "Proof: quorum receipts verified",
  "Self-heal: packet turbulence smoothed",
  "Energy-aware shift: route to cooler corridors"
];

let lineIndex = 0;

function appendLine(text) {
  const div = document.createElement("div");
  div.className = "console-line";
  div.textContent = text;
  consoleEl.appendChild(div);
  consoleEl.scrollTop = consoleEl.scrollHeight;
}

function runAction(action) {
  if (action === "ignite") {
    appendLine("Fabric ignition: photonic lanes aligned");
    return;
  }
  if (action === "brief") {
    appendLine("Proof packet: signed telemetry + deterministic SLA");
    return;
  }
  if (action === "route") {
    appendLine(lines[lineIndex % lines.length]);
    lineIndex++;
    return;
  }
  if (action === "verify") {
    appendLine("Verification: hop chain intact, trust confirmed");
    return;
  }
  if (action === "heal") {
    appendLine("Self-heal: rerouting around congestion");
  }
}

document.querySelectorAll("[data-action]").forEach(btn => {
  btn.addEventListener("click", () => runAction(btn.dataset.action));
});

// Animate counters
const counters = document.querySelectorAll("[data-count]");
const observer = new IntersectionObserver(entries => {
  entries.forEach(entry => {
    if (!entry.isIntersecting) return;
    const el = entry.target;
    const target = parseFloat(el.dataset.count);
    const duration = 1200;
    const start = performance.now();

    function tick(now) {
      const p = Math.min(1, (now - start) / duration);
      const value = target * p;
      if (target >= 1000) {
        el.textContent = Math.round(value).toLocaleString();
      } else {
        el.textContent = value.toFixed(1).replace(/\.0$/, "");
      }
      if (p < 1) requestAnimationFrame(tick);
    }

    requestAnimationFrame(tick);
    observer.unobserve(el);
  });
}, { threshold: 0.6 });

counters.forEach(el => observer.observe(el));
