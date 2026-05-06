const http = require("http");

const TOKEN = process.env.CF_API_TOKEN;
const PORT = process.env.PORT || 8787;

function sendJson(res, status, obj) {
  const body = JSON.stringify(obj);
  res.writeHead(status, {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET,OPTIONS",
    "Access-Control-Allow-Headers": "Content-Type, Authorization"
  });
  res.end(body);
}

async function fetchJson(url) {
  if (!TOKEN) {
    const err = new Error("Missing CF_API_TOKEN env var");
    err.status = 500;
    throw err;
  }
  const res = await fetch(url, {
    headers: { "Authorization": "Bearer " + TOKEN }
  });
  if (!res.ok) {
    const text = await res.text();
    const err = new Error(`Upstream HTTP ${res.status}: ${text.slice(0, 200)}`);
    err.status = res.status;
    throw err;
  }
  return await res.json();
}

const server = http.createServer(async (req, res) => {
  if (req.method === "OPTIONS") {
    res.writeHead(204, {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET,OPTIONS",
      "Access-Control-Allow-Headers": "Content-Type, Authorization"
    });
    res.end();
    return;
  }

  if (req.method !== "GET") {
    sendJson(res, 405, { error: "Method not allowed" });
    return;
  }

  const url = new URL(req.url, `http://${req.headers.host}`);
  try {
    if (url.pathname === "/api/locations") {
      const limit = url.searchParams.get("limit") || "500";
      const data = await fetchJson(
        `https://api.cloudflare.com/client/v4/radar/entities/locations?limit=${encodeURIComponent(limit)}`
      );
      sendJson(res, 200, data);
      return;
    }
    if (url.pathname === "/api/traffic") {
      const limit = url.searchParams.get("limit") || "80";
      const dateRange = url.searchParams.get("dateRange") || "1d";
      const data = await fetchJson(
        `https://api.cloudflare.com/client/v4/radar/netflows/top/locations?dateRange=${encodeURIComponent(dateRange)}&limit=${encodeURIComponent(limit)}`
      );
      sendJson(res, 200, data);
      return;
    }
    if (url.pathname === "/health") {
      sendJson(res, 200, { ok: true, token: !!TOKEN });
      return;
    }
    sendJson(res, 404, { error: "Not found" });
  } catch (err) {
    sendJson(res, err.status || 500, { error: err.message });
  }
});

server.listen(PORT, () => {
  console.log(`Proxy listening on http://localhost:${PORT}`);
  if (!TOKEN) {
    console.log("Set CF_API_TOKEN to enable Cloudflare Radar access.");
  }
});
