import express from "express";
import fs from "fs";

const app = express();
app.use(express.json({ limit: "64kb" }));

const PORT = Number(process.env.PORT || 3000);
const TOKEN = process.env.VOICE_TOKEN || "";
const NOTES_PATH = process.env.NOTES_PATH || "C:\\Users\\Surface\\OneDrive\\SIRENSSD\\ASPEN_CODES\\5RAGONC1RCUS\\[oasis@nomad]\\notes.txt";

if (!TOKEN) {
  console.error("VOICE_TOKEN is required");
  process.exit(1);
}

app.post("/api/voice-note", (req, res) => {
  const auth = req.headers.authorization || "";
  if (auth !== `Bearer ${TOKEN}`) {
    return res.status(401).json({ ok: false, error: "unauthorized" });
  }

  const text = String(req.body?.text || "").trim();
  if (!text) {
    return res.status(400).json({ ok: false, error: "empty" });
  }

  const ts = req.body?.timestamp ? String(req.body.timestamp) : new Date().toISOString();
  const source = req.body?.source ? String(req.body.source) : "iphone";
  const line = `${ts} | ${source} | ${text}\n`;

  fs.appendFile(NOTES_PATH, line, (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ ok: false, error: "write_failed" });
    }
    res.json({ ok: true });
  });
});

app.get("/api/health", (_req, res) => {
  res.json({ ok: true });
});

app.listen(PORT, () => {
  console.log(`voice-note server listening on ${PORT}`);
});
