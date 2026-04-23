import { promises as fs } from 'node:fs';
import path from 'node:path';

const root = process.cwd();
const outputJson = path.join(root, 'file_stats.json');
const outputSvg = path.join(root, 'file_stats_graph.svg');
const outputTxt = path.join(root, 'file_stats_for_gemini.txt');

const formatMiB = (bytes) => (bytes / (1024 * 1024)).toFixed(2);
const formatKiB = (bytes) => (bytes / 1024).toFixed(2);

async function collectStats(startDir) {
  const files = [];
  let directoryCount = 0;

  async function walk(currentDir) {
    let entries;
    try {
      entries = await fs.readdir(currentDir, { withFileTypes: true });
    } catch {
      return;
    }

    for (const entry of entries) {
      const fullPath = path.join(currentDir, entry.name);

      if (entry.isDirectory()) {
        directoryCount += 1;
        await walk(fullPath);
        continue;
      }

      if (!entry.isFile()) {
        continue;
      }

      try {
        const stat = await fs.stat(fullPath);
        files.push({
          fullPath,
          relativePath: path.relative(startDir, fullPath) || entry.name,
          ext: path.extname(entry.name) || '[no extension]',
          size: stat.size,
          modified: stat.mtime.toISOString().slice(0, 16).replace('T', ' '),
        });
      } catch {
        // Skip unreadable files and continue scanning.
      }
    }
  }

  await walk(startDir);

  const totalBytes = files.reduce((sum, file) => sum + file.size, 0);
  const averageBytes = files.length ? totalBytes / files.length : 0;

  const byExtension = new Map();
  const byFolder = new Map();

  for (const file of files) {
    const extEntry = byExtension.get(file.ext) ?? { label: file.ext, count: 0, bytes: 0 };
    extEntry.count += 1;
    extEntry.bytes += file.size;
    byExtension.set(file.ext, extEntry);

    const topLevel = file.relativePath.includes(path.sep)
      ? file.relativePath.split(path.sep)[0]
      : '[root]';
    const folderEntry = byFolder.get(topLevel) ?? { label: topLevel, count: 0, bytes: 0 };
    folderEntry.count += 1;
    folderEntry.bytes += file.size;
    byFolder.set(topLevel, folderEntry);
  }

  const extensions = [...byExtension.values()]
    .sort((a, b) => b.count - a.count)
    .map((item) => ({
      label: item.label,
      count: item.count,
      sizeMiB: Number(formatMiB(item.bytes)),
    }));

  const folders = [...byFolder.values()]
    .sort((a, b) => b.bytes - a.bytes)
    .map((item) => ({
      label: item.label,
      count: item.count,
      sizeMiB: Number(formatMiB(item.bytes)),
    }));

  const largestFiles = [...files]
    .sort((a, b) => b.size - a.size)
    .slice(0, 8)
    .map((file) => ({
      path: file.relativePath,
      sizeMiB: Number(formatMiB(file.size)),
      modified: file.modified,
    }));

  return {
    generatedAt: new Date().toISOString().slice(0, 19).replace('T', ' '),
    summary: {
      root: startDir,
      files: files.length,
      directories: directoryCount,
      totalMiB: Number(formatMiB(totalBytes)),
      averageKiB: Number(formatKiB(averageBytes)),
    },
    extensions,
    folders,
    largestFiles,
  };
}

function escapeXml(value) {
  return value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&apos;');
}

function renderBarChart({ x, y, width, itemHeight, gap, title, subtitle, items, maxValue, valueKey, fill }) {
  const rows = items
    .map((item, index) => {
      const rowY = y + 60 + index * (itemHeight + gap);
      const barWidth = maxValue > 0 ? Math.max(6, (item[valueKey] / maxValue) * width) : 0;
      const label = escapeXml(item.label);
      const metric =
        valueKey === 'count'
          ? `${item.count} files`
          : `${item.sizeMiB.toFixed(2)} MiB`;

      return `
        <text x="${x}" y="${rowY - 10}" class="row-label">${label}</text>
        <rect x="${x}" y="${rowY}" width="${width}" height="${itemHeight}" rx="10" fill="#172033" />
        <rect x="${x}" y="${rowY}" width="${barWidth}" height="${itemHeight}" rx="10" fill="${fill}" />
        <text x="${x + width}" y="${rowY + itemHeight - 6}" text-anchor="end" class="row-value">${escapeXml(metric)}</text>
      `;
    })
    .join('');

  return `
    <g>
      <text x="${x}" y="${y}" class="section-title">${escapeXml(title)}</text>
      <text x="${x}" y="${y + 24}" class="section-subtitle">${escapeXml(subtitle)}</text>
      ${rows}
    </g>
  `;
}

function renderSvg(stats) {
  const width = 1400;
  const height = 980;
  const extensions = stats.extensions.slice(0, 6);
  const folders = stats.folders.slice(0, 6);
  const maxExtCount = Math.max(...extensions.map((item) => item.count), 1);
  const maxFolderSize = Math.max(...folders.map((item) => item.sizeMiB), 1);
  const summary = stats.summary;

  const largestFileLines = stats.largestFiles
    .slice(0, 5)
    .map((file, index) => {
      const y = 760 + index * 34;
      return `
        <text x="820" y="${y}" class="small-label">${index + 1}. ${escapeXml(file.path)}</text>
        <text x="1320" y="${y}" text-anchor="end" class="small-value">${file.sizeMiB.toFixed(2)} MiB</text>
      `;
    })
    .join('');

  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="${width}" height="${height}" viewBox="0 0 ${width} ${height}" role="img" aria-labelledby="title desc">
  <title id="title">Research Lab File Statistics</title>
  <desc id="desc">Overview of file counts, storage use by extension and top-level folder, and largest files.</desc>
  <defs>
    <linearGradient id="bg" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#09111f" />
      <stop offset="100%" stop-color="#13233c" />
    </linearGradient>
    <linearGradient id="accentA" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0%" stop-color="#f59e0b" />
      <stop offset="100%" stop-color="#ef4444" />
    </linearGradient>
    <linearGradient id="accentB" x1="0" y1="0" x2="1" y2="0">
      <stop offset="0%" stop-color="#38bdf8" />
      <stop offset="100%" stop-color="#22c55e" />
    </linearGradient>
  </defs>

  <rect width="${width}" height="${height}" fill="url(#bg)" />
  <circle cx="1200" cy="120" r="220" fill="#1d3557" opacity="0.22" />
  <circle cx="180" cy="860" r="260" fill="#ef4444" opacity="0.08" />

  <text x="80" y="90" class="eyebrow">WORKSPACE STORAGE SNAPSHOT</text>
  <text x="80" y="140" class="headline">Research Lab File Statistics</text>
  <text x="80" y="176" class="subhead">Generated ${escapeXml(stats.generatedAt)} from ${escapeXml(summary.root)}</text>

  <g transform="translate(80, 230)">
    <rect width="270" height="120" rx="22" fill="#111a2b" />
    <text x="28" y="42" class="card-label">Files</text>
    <text x="28" y="88" class="card-value">${summary.files}</text>
  </g>
  <g transform="translate(380, 230)">
    <rect width="270" height="120" rx="22" fill="#111a2b" />
    <text x="28" y="42" class="card-label">Directories</text>
    <text x="28" y="88" class="card-value">${summary.directories}</text>
  </g>
  <g transform="translate(680, 230)">
    <rect width="270" height="120" rx="22" fill="#111a2b" />
    <text x="28" y="42" class="card-label">Total Size</text>
    <text x="28" y="88" class="card-value">${summary.totalMiB.toFixed(2)} MiB</text>
  </g>
  <g transform="translate(980, 230)">
    <rect width="270" height="120" rx="22" fill="#111a2b" />
    <text x="28" y="42" class="card-label">Average File</text>
    <text x="28" y="88" class="card-value">${summary.averageKiB.toFixed(2)} KiB</text>
  </g>

  ${renderBarChart({
    x: 80,
    y: 420,
    width: 520,
    itemHeight: 18,
    gap: 28,
    title: 'Top Extensions By File Count',
    subtitle: 'Dominant file types in the workspace.',
    items: extensions,
    maxValue: maxExtCount,
    valueKey: 'count',
    fill: 'url(#accentA)',
  })}

  ${renderBarChart({
    x: 820,
    y: 420,
    width: 520,
    itemHeight: 18,
    gap: 28,
    title: 'Top Folders By Size',
    subtitle: 'Storage concentration by top-level folder.',
    items: folders,
    maxValue: maxFolderSize,
    valueKey: 'sizeMiB',
    fill: 'url(#accentB)',
  })}

  <text x="820" y="720" class="section-title">Largest Files</text>
  <text x="820" y="744" class="section-subtitle">Top files by size across the workspace.</text>
  ${largestFileLines}

  <style>
    text {
      font-family: "Segoe UI", "Trebuchet MS", sans-serif;
      fill: #eef4ff;
    }
    .eyebrow {
      font-size: 16px;
      letter-spacing: 0.24em;
      font-weight: 700;
      fill: #7dd3fc;
    }
    .headline {
      font-size: 42px;
      font-weight: 700;
    }
    .subhead {
      font-size: 18px;
      fill: #b7c6df;
    }
    .card-label {
      font-size: 16px;
      fill: #9fb0cb;
    }
    .card-value {
      font-size: 32px;
      font-weight: 700;
    }
    .section-title {
      font-size: 26px;
      font-weight: 700;
    }
    .section-subtitle {
      font-size: 15px;
      fill: #9fb0cb;
    }
    .row-label {
      font-size: 16px;
    }
    .row-value {
      font-size: 15px;
      fill: #d7e4f7;
    }
    .small-label {
      font-size: 16px;
      fill: #dce8f8;
    }
    .small-value {
      font-size: 16px;
      font-weight: 700;
    }
  </style>
</svg>
`;
}

function renderGeminiText(stats) {
  const summary = stats.summary;
  const extensions = stats.extensions.slice(0, 8);
  const folders = stats.folders.slice(0, 8);
  const largestFiles = stats.largestFiles.slice(0, 8);

  return [
    'Use the following local file statistics to analyze the workspace and suggest cleanup priorities.',
    '',
    `Root: ${summary.root}`,
    `Generated at: ${stats.generatedAt}`,
    `Files: ${summary.files}`,
    `Directories: ${summary.directories}`,
    `Total size: ${summary.totalMiB.toFixed(2)} MiB`,
    `Average file size: ${summary.averageKiB.toFixed(2)} KiB`,
    '',
    'Top extensions:',
    ...extensions.map((item) => `- ${item.label}: ${item.count} files, ${item.sizeMiB.toFixed(2)} MiB`),
    '',
    'Top folders by size:',
    ...folders.map((item) => `- ${item.label}: ${item.count} files, ${item.sizeMiB.toFixed(2)} MiB`),
    '',
    'Largest files:',
    ...largestFiles.map((item) => `- ${item.path}: ${item.sizeMiB.toFixed(2)} MiB, modified ${item.modified}`),
    '',
    'Please summarize the main storage patterns, identify likely cleanup opportunities, and recommend a sensible archival strategy.',
  ].join('\n');
}

const stats = await collectStats(root);

await fs.writeFile(outputJson, JSON.stringify(stats, null, 2) + '\n', 'utf8');
await fs.writeFile(outputSvg, renderSvg(stats), 'utf8');
await fs.writeFile(outputTxt, renderGeminiText(stats) + '\n', 'utf8');

console.log(
  JSON.stringify(
    {
      json: outputJson,
      svg: outputSvg,
      txt: outputTxt,
      summary: stats.summary,
    },
    null,
    2,
  ),
);
