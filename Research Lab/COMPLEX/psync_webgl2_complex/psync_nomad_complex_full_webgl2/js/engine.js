// PSYNC / NOMAD Complex WebGL2 Graph
// Self-contained engine — no external libraries.

// --- Minimal mat4 utilities (column-major, WebGL-style) ---
const Mat4 = {
  create() {
    return new Float32Array([
      1,0,0,0,
      0,1,0,0,
      0,0,1,0,
      0,0,0,1
    ]);
  },
  identity(out) {
    out[0]=1; out[1]=0; out[2]=0; out[3]=0;
    out[4]=0; out[5]=1; out[6]=0; out[7]=0;
    out[8]=0; out[9]=0; out[10]=1; out[11]=0;
    out[12]=0; out[13]=0; out[14]=0; out[15]=1;
    return out;
  },
  multiply(out, a, b) {
    const a00 = a[0], a01 = a[1], a02 = a[2], a03 = a[3];
    const a10 = a[4], a11 = a[5], a12 = a[6], a13 = a[7];
    const a20 = a[8], a21 = a[9], a22 = a[10], a23 = a[11];
    const a30 = a[12], a31 = a[13], a32 = a[14], a33 = a[15];

    const b00 = b[0], b01 = b[1], b02 = b[2], b03 = b[3];
    const b10 = b[4], b11 = b[5], b12 = b[6], b13 = b[7];
    const b20 = b[8], b21 = b[9], b22 = b[10], b23 = b[11];
    const b30 = b[12], b31 = b[13], b32 = b[14], b33 = b[15];

    out[0]  = b00 * a00 + b01 * a10 + b02 * a20 + b03 * a30;
    out[1]  = b00 * a01 + b01 * a11 + b02 * a21 + b03 * a31;
    out[2]  = b00 * a02 + b01 * a12 + b02 * a22 + b03 * a32;
    out[3]  = b00 * a03 + b01 * a13 + b02 * a23 + b03 * a33;
    out[4]  = b10 * a00 + b11 * a10 + b12 * a20 + b13 * a30;
    out[5]  = b10 * a01 + b11 * a11 + b12 * a21 + b13 * a31;
    out[6]  = b10 * a02 + b11 * a12 + b12 * a22 + b13 * a32;
    out[7]  = b10 * a03 + b11 * a13 + b12 * a23 + b13 * a33;
    out[8]  = b20 * a00 + b21 * a10 + b22 * a20 + b23 * a30;
    out[9]  = b20 * a01 + b21 * a11 + b22 * a21 + b23 * a31;
    out[10] = b20 * a02 + b21 * a12 + b22 * a22 + b23 * a32;
    out[11] = b20 * a03 + b21 * a13 + b22 * a23 + b23 * a33;
    out[12] = b30 * a00 + b31 * a10 + b32 * a20 + b33 * a30;
    out[13] = b30 * a01 + b31 * a11 + b32 * a21 + b33 * a31;
    out[14] = b30 * a02 + b31 * a12 + b32 * a22 + b33 * a32;
    out[15] = b30 * a03 + b31 * a13 + b32 * a23 + b33 * a33;
    return out;
  },
  perspective(out, fovy, aspect, near, far) {
    const f = 1.0 / Math.tan(fovy / 2);
    const nf = 1 / (near - far);
    out[0] = f / aspect;
    out[1] = 0;
    out[2] = 0;
    out[3] = 0;
    out[4] = 0;
    out[5] = f;
    out[6] = 0;
    out[7] = 0;
    out[8] = 0;
    out[9] = 0;
    out[10] = (far + near) * nf;
    out[11] = -1;
    out[12] = 0;
    out[13] = 0;
    out[14] = (2 * far * near) * nf;
    out[15] = 0;
    return out;
  },
  lookAt(out, eye, center, up) {
    let x0, x1, x2, y0, y1, y2, z0, z1, z2;
    let eyex = eye[0], eyey = eye[1], eyez = eye[2];
    let upx = up[0], upy = up[1], upz = up[2];
    let centerx = center[0], centery = center[1], centerz = center[2];

    if (Math.abs(eyex - centerx) < 1e-6 &&
        Math.abs(eyey - centery) < 1e-6 &&
        Math.abs(eyez - centerz) < 1e-6) {
      return Mat4.identity(out);
    }

    z0 = eyex - centerx;
    z1 = eyey - centery;
    z2 = eyez - centerz;

    let len = 1 / Math.hypot(z0, z1, z2);
    z0 *= len; z1 *= len; z2 *= len;

    x0 = upy * z2 - upz * z1;
    x1 = upz * z0 - upx * z2;
    x2 = upx * z1 - upy * z0;
    len = Math.hypot(x0, x1, x2);
    if (!len) {
      x0 = 0; x1 = 0; x2 = 0;
    } else {
      len = 1 / len;
      x0 *= len; x1 *= len; x2 *= len;
    }

    y0 = z1 * x2 - z2 * x1;
    y1 = z2 * x0 - z0 * x2;
    y2 = z0 * x1 - z1 * x0;
    len = Math.hypot(y0, y1, y2);
    if (!len) {
      y0 = 0; y1 = 0; y2 = 0;
    } else {
      len = 1 / len;
      y0 *= len; y1 *= len; y2 *= len;
    }

    out[0] = x0; out[1] = y0; out[2] = z0; out[3] = 0;
    out[4] = x1; out[5] = y1; out[6] = z1; out[7] = 0;
    out[8] = x2; out[9] = y2; out[10] = z2; out[11] = 0;
    out[12] = -(x0 * eyex + x1 * eyey + x2 * eyez);
    out[13] = -(y0 * eyex + y1 * eyey + y2 * eyez);
    out[14] = -(z0 * eyex + z1 * eyey + z2 * eyez);
    out[15] = 1;
    return out;
  }
};

(function() {
  const canvas = document.getElementById("glcanvas");
  const gl = canvas.getContext("webgl2");
  if (!gl) {
    alert("WebGL2 not supported in this browser.");
    return;
  }

  function resize() {
    const dpr = window.devicePixelRatio || 1;
    const w = Math.floor(window.innerWidth * dpr);
    const h = Math.floor(window.innerHeight * dpr);
    canvas.width = w;
    canvas.height = h;
    canvas.style.width = window.innerWidth + "px";
    canvas.style.height = window.innerHeight + "px";
    gl.viewport(0, 0, w, h);
  }
  window.addEventListener("resize", resize);
  resize();

  // --- Raw PSYNC data ---
  const rawData = `
NOMAD.PSYNC.SANDBOX
AVALANCHE.OASIS.PSYNC
PSYNC.OASIS.NOMAD
NOMAD.OASIS.AVALANCHE
OASIS.SANDBOX.PSYNC
AVALANCHE.OASIS.PSYNC

PSYNC.OASIS.NOMAD
SANDBOX.AVALANCHE.PSYNC
PSYNC.NOMAD.OASIS
PSYNC.NOMAD.SANDBOX
AVALANCHE.PSYNC.SANDBOX
NOMAD.PSYNC.AVALANCHE
PSYNC.OASIS.NOMAD
AVALANCHE.OASIS.PSYNC
OASIS.SANDBOX.PSYNC
AVALANCHE.OASIS.NOMAD
NOMAD.COMPLEX.SANDBOX
AVALANCHE.NOMAD.OASIS
SANDBOX.AVALANCHE.OASIS
AVALANCHE.OASIS.NOMAD
AVALANCHE.COMPLEX.PSYNC
OASIS.SANDBOX.PSYNC
OASIS.AVALANCHE.PSYNC
AVALANCHE.PSYNC.NOMAD
PSYNC.NOMAD.SANDBOX
AVALANCHE.OASIS.PSYNC
NOMAD.SANDBOX.AVALANCHE
OASIS.AVALANCHE.PSYNC
OASIS.COMPLEX.PSYNC
PSYNC.NOMAD.OASIS
SANDBOX.OASIS.PSYNC
AVALANCHE.NOMAD.PSYNC
COMPLEX.PSYNC.AVALANCHE
OASIS.NOMAD.PSYNC
AVALANCHE.COMPLEX.PSYNC
AVALANCHE.PSYNC.OASIS
PSYNC.SYSTEM.NOMAD
SANDBOX.PSYNC.OASIS
PSYNC.OASIS.NOMAD
OASIS.SANDBOX.PSYNC
OASIS.NOMAD.AVALANCHE
PSYNC.COMPLEX.SANDBOX
SANDBOX.COMPLEX.PSYNC
PSYNC.OASIS.NOMAD
PSYNC.COMPLEX.OASIS
AVALANCHE.PSYNC.NOMAD
OASIS.PSYNC.AVALANCHE
AVALANCHE.NOMAD.SANDBOX
COMPLEX.OASIS.PSYNC
AVALANCHE.COMPLEX.SANDBOX
PSYNC.COMPLEX.AVALANCHE
OASIS.NOMAD.SANDBOX.
NOMAD.PSYNC.AVALANCHE
OASIS.NOMAD.SANDBOX
PSYNC.NOMAD.COMPLEX
AVALANCHE.NOMAD.SANDBOX
NOMAD.COMPLEX.OASIS
OASIS.COMPLEX.SANDBOX
NOMAD.PSYNC.OASIS
AVALANCHE.OASIS.PSYNC
SANDBOX.OASIS.COMPLEX
SANDBOX.OASIS.PSYNC
NOMAD.SANDBOX.AVALANCHE
NOMAD.COMPLEX.SANDBOX
AVALANCHE.SANBOX.NOMAD
NOMAD.SANDBOX.AVALANCHE
OASIS.SANDBOX.PSYNC
NOMAD.OASIS.AVALANCHE
NOMAD.PSYNC.OASIS
SANDBOX.NOMAD.COMPLEX
OASIS.NOMAD.SANDBOX
NOMAD.AVALANCHE.PSYNC
SANDBOX.COMPLEX.OASIS
NOMAD.PSYNC.AVALANCHE
NOMAD.COMPLEX.SANDBOX
SANDBOX.OASIS.PSYNC
NOMAD.SANDBOX.COMPLEX
NOMAD.SANDBOX.PSYNC
OASIS.PSYNC.COMPLEX
AVALANCHE.NOMAD.OASIS
OASIS.NOMAD.PSYNC
$AVALANCHE.PSYNC.NOMAD
OASIS.NOMAD.PSYNC
OASIS.COMPLEX.SANDBOX
SANDBOX.COMPLEX.OASIS
NOMAD.PSYNC.OASIS
PSYNC.OASIS.AVALANCHE
NOMAD.OASIS.PSYNC
SANDBOX.OASIS.AVALANCHE
NOMAD.COMPLEX.PSYNC
COMPLEX.OASIS.SANDBOX
PSYNC.COMPLEX.SANDBOX
OASIS.PSYNC.AVALANCHE
AVALANCHE.PSYNC.COMPLEX
OASIS.PSYNC.NOMAD
SANDBOX.NOMAD.PSYNC
OASIS.COMPLEX.AVALANCHE
AVALANCHE.PSYNC.NOMAD
PSYNC.OASIS.NOMAD
NOMAD.AVALANCHE.SANDBOX
AVALANCHE.NOMAD.COMPLEX
PSYNC.NOMAD.SANDBOX
PSYNC.NOMAD.AVALANCHE
AVALANCHE.NOMAD.PSYNC
AVALANCHE.NOMAD.COMPLEX
PSYNC.NOMAD.AVALANCHE
COMPLEX.NOMAD.AVALANCHE
AVALANCHE.SANDBOX.PSYNC
AVALANCHE.PSYNC.SANDBOX
SANDBOX.PSYNC.NOMAD
COMPLEX.PSYNC.OASIS
SANDBOX.OASIS.PSYNC
AVALANCHE.PSYNC.NOMAD
AVALANCHE.SANDBOX.NOMAD
PSYNC.NOMAD.SANDBOX
OASIS.SANDBOX.NOMAD
NOMAD.AVALANCHE.OASIS
COMPLEX.PSYNC.NOMAD
COMPLEX.PSYNC.SANDBOX
AVALANCHE.SANDBOX.PSYNC
NOMAD.OASIS.SANDBOX 
AVALANCHE.PSYNC.NOMAD
SANDBOX.NOMAD.COMPLEX
SANDBOX.NOMAD.MACHINIMA
SANDBOX.NOMAD.PSYNC
PSYNC.NOMAD.SANDBOX
PSYNC.SANDBOX.NOMAD
PSYNC.OASIS.AVALANCHE
COMPLEX.PSYNC.SANDBOX
NOMAD.PSYNC.SANDBOX
AVALANCHE.PSYNC.COMPLEX
OASIS.NOMAD.COMPLEX
OASIS.PSYNC.AVALANCHE 
-AVALANCHE.COMPLEX
AVALANCHE.NOMAD.COMPLEX
COMPLEX.PSYNC.NOMAD
AVALANCHE.PSYNC.NOMAD
PSYNC.AVALANCHE.NOMAD.SANDBOX.COMPLEX.OASIS
PSYNC.NOMAD.COMPLEX -OASIS.SANDBOX.NOMAD 
TERMINAL BREACH
`;

  const nodeIndex = new Map();
  const nodes = [];
  const edges = [];

  function getNodeId(name) {
    if (!nodeIndex.has(name)) {
      nodeIndex.set(name, nodes.length);
      nodes.push({ name, position: [0,0,0] });
    }
    return nodeIndex.get(name);
  }

  rawData.split("\\n").forEach(line => {
    line = line.trim();
    if (!line) return;
    const parts = line.toUpperCase().split(/[^A-Z]+/).filter(Boolean);
    if (parts.length === 1) {
      getNodeId(parts[0]);
      return;
    }
    const ids = parts.map(getNodeId);
    for (let i = 0; i < ids.length - 1; i++) {
      edges.push({ from: ids[i], to: ids[i+1] });
    }
  });

  const radius = 6.5;
  const count = nodes.length || 1;
  for (let i = 0; i < count; i++) {
    const node = nodes[i];
    const t = i / count * Math.PI * 2;
    const y = Math.sin(i * 0.9) * 1.0;
    node.position = [
      Math.cos(t) * radius,
      y,
      Math.sin(t) * radius
    ];
  }

  function colorForName(name) {
    switch (name) {
      case "NOMAD":      return [0.20, 0.90, 1.00];
      case "PSYNC":      return [1.00, 0.10, 0.70];
      case "SANDBOX":    return [1.00, 0.85, 0.20];
      case "OASIS":      return [0.40, 1.00, 0.55];
      case "AVALANCHE":  return [1.00, 0.45, 0.10];
      case "COMPLEX":    return [1.00, 0.20, 0.30];
      case "SYSTEM":     return [0.35, 0.75, 1.00];
      case "MACHINIMA":  return [0.85, 0.50, 1.00];
      case "TERMINAL":   return [0.95, 0.95, 0.95];
      case "BREACH":     return [1.00, 0.22, 0.35];
      default:           return [0.60, 0.65, 0.80];
    }
  }

  const nodePositions = new Float32Array(nodes.length * 3);
  const nodeColors = new Float32Array(nodes.length * 3);
  for (let i = 0; i < nodes.length; i++) {
    const p = nodes[i].position;
    nodePositions[i*3+0] = p[0];
    nodePositions[i*3+1] = p[1];
    nodePositions[i*3+2] = p[2];
    const c = colorForName(nodes[i].name);
    nodeColors[i*3+0] = c[0];
    nodeColors[i*3+1] = c[1];
    nodeColors[i*3+2] = c[2];
  }

  const edgePositions = new Float32Array(edges.length * 2 * 3);
  for (let i = 0; i < edges.length; i++) {
    const e = edges[i];
    const a = nodes[e.from].position;
    const b = nodes[e.to].position;
    const o = i * 6;
    edgePositions[o+0] = a[0];
    edgePositions[o+1] = a[1];
    edgePositions[o+2] = a[2];
    edgePositions[o+3] = b[0];
    edgePositions[o+4] = b[1];
    edgePositions[o+5] = b[2];
  }

  function createBuffer(data) {
    const buf = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, buf);
    gl.bufferData(gl.ARRAY_BUFFER, data, gl.STATIC_DRAW);
    return buf;
  }

  const nodePosBuffer = createBuffer(nodePositions);
  const nodeColorBuffer = createBuffer(nodeColors);
  const edgeBuffer = createBuffer(edgePositions);

  function compileShader(type, src) {
    const sh = gl.createShader(type);
    gl.shaderSource(sh, src);
    gl.compileShader(sh);
    if (!gl.getShaderParameter(sh, gl.COMPILE_STATUS)) {
      console.error(gl.getShaderInfoLog(sh));
      gl.deleteShader(sh);
      return null;
    }
    return sh;
  }

  function createProgram(vs, fs) {
    const vsObj = compileShader(gl.VERTEX_SHADER, vs);
    const fsObj = compileShader(gl.FRAGMENT_SHADER, fs);
    const prog = gl.createProgram();
    gl.attachShader(prog, vsObj);
    gl.attachShader(prog, fsObj);
    gl.linkProgram(prog);
    if (!gl.getProgramParameter(prog, gl.LINK_STATUS)) {
      console.error(gl.getProgramInfoLog(prog));
      gl.deleteProgram(prog);
      return null;
    }
    return prog;
  }

  const vsPoints = `#version 300 es
  precision highp float;
  layout(location = 0) in vec3 a_position;
  layout(location = 1) in vec3 a_color;
  uniform mat4 u_mvp;
  uniform float u_time;
  out vec3 v_color;
  void main() {
    float pulse = 1.0 + 0.6 * sin(u_time * 2.5 + a_position.x * 0.7);
    gl_Position = u_mvp * vec4(a_position, 1.0);
    gl_PointSize = 8.0 * pulse;
    v_color = a_color;
  }`;

  const fsPoints = `#version 300 es
  precision highp float;
  in vec3 v_color;
  out vec4 outColor;
  void main() {
    vec2 p = gl_PointCoord * 2.0 - 1.0;
    float d = dot(p, p);
    if (d > 1.0) discard;
    float glow = 1.0 - smoothstep(0.6, 1.0, d);
    vec3 base = v_color;
    vec3 col = mix(base * 0.4, base, glow);
    outColor = vec4(col, glow);
  }`;

  const vsLines = `#version 300 es
  precision highp float;
  layout(location = 0) in vec3 a_position;
  uniform mat4 u_mvp;
  void main() {
    gl_Position = u_mvp * vec4(a_position, 1.0);
  }`;

  const fsLines = `#version 300 es
  precision highp float;
  uniform vec3 u_color;
  out vec4 outColor;
  void main() {
    outColor = vec4(u_color, 0.35);
  }`;

  const pointProgram = createProgram(vsPoints, fsPoints);
  const lineProgram = createProgram(vsLines, fsLines);

  const uPointsMvp = gl.getUniformLocation(pointProgram, "u_mvp");
  const uPointsTime = gl.getUniformLocation(pointProgram, "u_time");
  const uLinesMvp = gl.getUniformLocation(lineProgram, "u_mvp");
  const uLinesColor = gl.getUniformLocation(lineProgram, "u_color");

  let yaw = 0.6;
  let pitch = 0.3;
  let distance = 16;

  let dragging = false;
  let lastX = 0, lastY = 0;

  canvas.addEventListener("mousedown", e => {
    dragging = true;
    lastX = e.clientX;
    lastY = e.clientY;
  });
  window.addEventListener("mouseup", () => dragging = false);
  window.addEventListener("mousemove", e => {
    if (!dragging) return;
    const dx = e.clientX - lastX;
    const dy = e.clientY - lastY;
    lastX = e.clientX;
    lastY = e.clientY;
    yaw += dx * 0.006;
    pitch += dy * 0.006;
    const limit = Math.PI / 2 - 0.1;
    pitch = Math.max(-limit, Math.min(limit, pitch));
  });

  canvas.addEventListener("wheel", e => {
    e.preventDefault();
    distance *= (1 + e.deltaY * 0.001);
    distance = Math.max(6, Math.min(30, distance));
  }, { passive: false });

  const proj = Mat4.create();
  const view = Mat4.create();
  const mvp = Mat4.create();

  gl.enable(gl.BLEND);
  gl.blendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
  gl.enable(gl.DEPTH_TEST);

  function render(t) {
    t *= 0.001;
    const w = canvas.width;
    const h = canvas.height;
    const aspect = w / h;

    gl.viewport(0, 0, w, h);
    gl.clearColor(0.01, 0.01, 0.04, 1.0);
    gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);

    const orbitYaw = yaw + t * 0.06;
    const cx = Math.cos(orbitYaw) * Math.cos(pitch) * distance;
    const cy = Math.sin(pitch) * distance * 0.9;
    const cz = Math.sin(orbitYaw) * Math.cos(pitch) * distance;

    Mat4.perspective(proj, Math.PI / 3, aspect, 0.1, 100.0);
    Mat4.lookAt(view, [cx, cy, cz], [0, 0, 0], [0, 1, 0]);
    Mat4.multiply(mvp, proj, view);

    gl.useProgram(lineProgram);
    gl.uniformMatrix4fv(uLinesMvp, false, mvp);
    gl.uniform3f(uLinesColor, 0.30, 0.45, 0.95);
    gl.bindBuffer(gl.ARRAY_BUFFER, edgeBuffer);
    gl.enableVertexAttribArray(0);
    gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);
    gl.drawArrays(gl.LINES, 0, edgePositions.length / 3);

    gl.useProgram(pointProgram);
    gl.uniformMatrix4fv(uPointsMvp, false, mvp);
    gl.uniform1f(uPointsTime, t);
    gl.bindBuffer(gl.ARRAY_BUFFER, nodePosBuffer);
    gl.enableVertexAttribArray(0);
    gl.vertexAttribPointer(0, 3, gl.FLOAT, false, 0, 0);
    gl.bindBuffer(gl.ARRAY_BUFFER, nodeColorBuffer);
    gl.enableVertexAttribArray(1);
    gl.vertexAttribPointer(1, 3, gl.FLOAT, false, 0, 0);
    gl.drawArrays(gl.POINTS, 0, nodes.length);

    requestAnimationFrame(render);
  }

  requestAnimationFrame(render);
})();