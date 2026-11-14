int getCharMask(int id) {
    if (id == 0)  return 0;
    if (id == 1)  return 2;
    if (id == 2)  return 1040;
    if (id == 3)  return 448;
    if (id == 4)  return 1392;
    if (id == 5)  return 21973;
    if (id == 6)  return 3960;
    if (id == 7)  return 24573;
    if (id == 8)  return 31687;
    return 0;
}

float drawChar(vec2 cellUV, int charId) {
    if (charId == 0) return 0.0;

    vec2 p = (cellUV - 0.5) * vec2(1.3, 1.2) + 0.5;
    if (p.x < 0.0 || p.x >= 1.0 || p.y < 0.0 || p.y >= 1.0) return 0.0;

    int col = clamp(int(floor(p.x * 3.0)), 0, 2);
    int row = clamp(int(floor((1.0 - p.y) * 5.0)), 0, 4);

    int bitIndex = 14 - (row * 3 + col);
    int mask = getCharMask(charId);

    return float((mask >> bitIndex) & 1);
}

vec3 getSceneColor(vec2 uv, vec2 p) {
    float loopDuration = 10.0;
    float t = mod(iTime, loopDuration);
    float angle = (t / loopDuration) * 6.28318530718;

    float radial = length(p - vec2(0.0, -0.05));
    vec3 bg = mix(vec3(0.02, 0.22, 0.45), vec3(0.01, 0.04, 0.15), smoothstep(0.1, 0.95, radial));

    float w1 = 0.22 * sin(p.x * 2.2 + angle) + 0.12 * cos(p.x * 4.1 - angle) + 0.05 * sin(p.x * 6.0 + angle * 2.0);
    float d1 = abs(p.y - w1);
    vec3 ribbon1 = vec3(0.12, 0.55, 0.95) * (0.026 / (d1 + 0.022));

    float w2 = 0.18 * sin(p.x * 1.7 - angle * 2.0 + 2.0) + 0.14 * sin(p.x * 3.3 + angle) - 0.14;
    float d2 = abs(p.y - w2);
    vec3 ribbon2 = vec3(0.20, 0.85, 0.50) * (0.024 / (d2 + 0.024));

    float w3 = 0.15 * cos(p.x * 2.5 + angle * 2.0) + 0.08 * sin(p.x * 5.0 - angle) + 0.12;
    float d3 = abs(p.y - w3);
    vec3 ribbon3 = vec3(0.5, 0.90, 0.80) * (0.016 / (d3 + 0.018));

    vec3 orbs = vec3(0.0);
    for (int i = 0; i < 10; i++) {
        float fi = float(i);
        float cycleMultiplier = floor(1.0 + mod(fi, 3.0));
        vec2 orbPos = vec2(
            sin(fi * 2.71 + angle),
            fract(fi * 0.15 + (t / loopDuration) * cycleMultiplier) * 2.2 - 1.1
        );
        float r = 0.025 + 0.02 * sin(fi * 1.8);
        float dist = length(p - orbPos);
        float circle = smoothstep(r, 0.0, dist);
        float pulse = 0.6 + 0.4 * sin(angle * 2.0 + fi * 1.5);
        vec3 orbCol = mix(vec3(0.2, 0.7, 1.0), vec3(0.25, 0.95, 0.55), mod(fi, 2.0));
        orbs += orbCol * circle * pulse * 0.35;
    }

    vec3 baseScene = bg + ribbon1 + ribbon2 + ribbon3 + orbs;

    vec2 lp = p - vec2(0.0, 0.08);
    lp.y += 0.025 * sin(lp.x * 6.0 + angle * 2.0);
    lp.x += 0.010 * cos(lp.y * 7.0 + angle);

    float gap = 0.012;
    float boxW = 0.085;
    float boxH = 0.075;

    vec2 paneCenter = vec2(
        (lp.x > 0.0 ? 1.0 : -1.0) * (gap + boxW),
        (lp.y > 0.0 ? 1.0 : -1.0) * (gap + boxH)
    );

    vec2 d = abs(lp - paneCenter) - vec2(boxW, boxH);
    float dPane = max(d.x, d.y);
    float paneMask = smoothstep(0.005, -0.005, dPane);

    vec3 logoCol = vec3(0.0);
    if (lp.x < 0.0 && lp.y > 0.0)      logoCol = vec3(1.00, 0.15, 0.10);
    else if (lp.x > 0.0 && lp.y > 0.0) logoCol = vec3(0.35, 0.95, 0.10);
    else if (lp.x < 0.0 && lp.y < 0.0) logoCol = vec3(0.00, 0.65, 1.00);
    else                               logoCol = vec3(1.00, 0.85, 0.00);

    float aura = 0.008 / (max(dPane, 0.0) + 0.015);
    vec3 logoAura = vec3(0.3, 0.75, 0.9) * aura * 0.35;

    return mix(baseScene + logoAura, logoCol, paneMask);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord / iResolution.xy;
    vec2 p = (fragCoord - 0.5 * iResolution.xy) / iResolution.y;

    vec2 gridDim = vec2(96.0, 48.0);
    vec2 cellIndex = floor(uv * gridDim);
    vec2 cellUV = fract(uv * gridDim);
    vec2 cellCenterUV = (cellIndex + 0.5) / gridDim;
    vec2 cellCenterP = (cellCenterUV * iResolution.xy - 0.5 * iResolution.xy) / iResolution.y;

    vec3 sceneCol = getSceneColor(cellCenterUV, cellCenterP);
    float lum = dot(sceneCol, vec3(0.299, 0.587, 0.114));

    int charId = 0;
    if (lum < 0.06)      charId = 0;
    else if (lum < 0.14) charId = 1;
    else if (lum < 0.25) charId = 2;
    else if (lum < 0.38) charId = 3;
    else if (lum < 0.52) charId = 4;
    else if (lum < 0.66) charId = 5;
    else if (lum < 0.80) charId = 6;
    else if (lum < 0.92) charId = 7;
    else                 charId = 8;

    float glyph = drawChar(cellUV, charId);

    vec3 col = sceneCol * glyph;
    col += sceneCol * 0.12;

    vec2 gridLine = smoothstep(0.0, 0.05, cellUV) * smoothstep(1.0, 0.95, cellUV);
    col *= (0.85 + 0.15 * gridLine.x * gridLine.y);

    fragColor = vec4(col, 1.0);
}