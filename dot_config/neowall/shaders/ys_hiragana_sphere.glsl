#define PI 3.1415
#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d) 1.-smoothstep(-1.5,1.5, (d)*iResolution.y )
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define OUTLINE_THICK 0.01

const int TOTAL_POINTS = 88;
const int TOTAL_SEGS = 38;

const int SEG_START[5] = int[5](0,11,15,20,28);
const int SEG_COUNT[5] = int[5](11,4,5,8,10);
const int PT_START[5]  = int[5](0,25,35,47,65);
const int PT_COUNT[5]  = int[5](25,10,12,18,23);

const int ANCHOR_LEN[5] = int[5](7,5,5,6,7);
const int ANCHORS[35] = int[35](
    0,5,4,24,10,9,0,
    25,29,30,34,25,25,25,
    35,37,38,46,35,35,35,
    47,51,52,58,64,47,47,
    65,67,68,84,85,87,65
);

const vec2 BASE[88] = vec2[88](
    vec2(-0.2998,0.2627), vec2(-0.1956,0.2512), vec2(-0.0693,0.2529), vec2(0.1333,0.2593),
    vec2(0.2822,0.2930), vec2(-0.0889,0.3984), vec2(-0.1149,0.2647), vec2(-0.1006,0.0566),
    vec2(-0.0739,-0.1662), vec2(-0.0186,-0.2979), vec2(0.1411,0.1528), vec2(0.1414,0.0099),
    vec2(0.0005,-0.1782), vec2(-0.1142,-0.3213), vec2(-0.2573,-0.3120), vec2(-0.3323,-0.2421),
    vec2(-0.2974,-0.1147), vec2(-0.1961,0.0534), vec2(-0.0747,0.0659), vec2(0.0607,0.1537),
    vec2(0.3149,0.0073), vec2(0.3785,-0.1104), vec2(0.3149,-0.2300), vec2(0.2284,-0.3716),
    vec2(0.0542,-0.3589), vec2(-0.3330,0.3232), vec2(-0.2791,-0.3184), vec2(-0.1729,-0.3271),
    vec2(-0.1102,-0.3323), vec2(-0.0293,-0.1172), vec2(0.1909,0.2827), vec2(0.2630,0.2066),
    vec2(0.3325,0.0298), vec2(0.3809,-0.1320), vec2(0.3755,-0.2300), vec2(-0.2275,0.3799),
    vec2(-0.0146,0.3122), vec2(0.2119,0.3174), vec2(-0.3262,0.0771), vec2(0.1376,0.2245),
    vec2(0.2617,0.0527), vec2(0.2967,-0.0216), vec2(0.2715,-0.1123), vec2(0.2183,-0.2354),
    vec2(0.1240,-0.2803), vec2(-0.0434,-0.3737), vec2(-0.1533,-0.3682), vec2(-0.1885,0.3848),
    vec2(-0.1011,0.3561), vec2(0.0215,0.3398), vec2(0.1222,0.3286), vec2(0.2012,0.3320),
    vec2(-0.2915,0.1431), vec2(-0.2128,0.1367), vec2(-0.0767,0.1460), vec2(0.2203,0.1948),
    vec2(0.2134,0.1831), vec2(-0.0858,-0.1295), vec2(-0.3423,-0.3423), vec2(-0.2095,-0.1720),
    vec2(0.0825,-0.1069), vec2(0.1119,-0.2035), vec2(0.1626,-0.3296), vec2(0.2731,-0.3840),
    vec2(0.4204,-0.3071), vec2(-0.3450,0.2071), vec2(-0.1172,0.2042), vec2(0.1052,0.2511),
    vec2(-0.1126,0.4317), vec2(-0.1177,0.2842), vec2(-0.1126,0.0343), vec2(-0.0836,-0.3207),
    vec2(-0.1448,-0.3437), vec2(-0.2949,-0.3749), vec2(-0.3577,-0.2353), vec2(-0.3445,-0.1533),
    vec2(-0.2425,-0.0976), vec2(-0.1278,0.0479), vec2(0.2849,-0.0175), vec2(0.3391,-0.0369),
    vec2(0.3796,-0.1337), vec2(0.3954,-0.2700), vec2(0.2565,-0.3359), vec2(0.1432,-0.3688),
    vec2(0.0544,-0.2802), vec2(0.2146,0.3263), vec2(0.3389,0.2680), vec2(0.4177,0.1544)
);

const ivec3 SEGS[38] = ivec3[38](
    ivec3(0,1,2), ivec3(2,3,4), ivec3(5,6,7), ivec3(7,8,9),
    ivec3(10,11,12), ivec3(12,13,14), ivec3(14,15,16), ivec3(16,17,18),
    ivec3(18,19,20), ivec3(20,21,22), ivec3(22,23,24), ivec3(25,26,27),
    ivec3(27,28,29), ivec3(30,31,32), ivec3(32,33,34), ivec3(35,36,37),
    ivec3(38,39,40), ivec3(40,41,42), ivec3(42,43,44), ivec3(44,45,46),
    ivec3(47,48,49), ivec3(49,50,51), ivec3(52,53,54), ivec3(54,55,56),
    ivec3(56,57,58), ivec3(58,59,60), ivec3(60,61,62), ivec3(62,63,64),
    ivec3(65,66,67), ivec3(68,69,70), ivec3(70,71,72), ivec3(72,73,74),
    ivec3(74,75,76), ivec3(76,77,78), ivec3(78,79,80), ivec3(80,81,82),
    ivec3(82,83,84), ivec3(85,86,87)
);

float random (vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

float hash21(vec2 p) {
    p = fract(p*vec2(234.56,789.34));
    p += dot(p,p+34.56);
    return fract(p.x+p.y);
}

vec2 hash22(vec2 p) {
    float x = hash21(p);
    float y = hash21(p + vec2(17.13, 9.71));
    return vec2(x,y);
}

vec2 valueNoise2(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f*f*(3.0-2.0*f);

    vec2 a = hash22(i) *2.0-1.0;
    vec2 b = hash22(i+vec2(1,0)) *2.0-1.0;
    vec2 c = hash22(i+vec2(0,1)) *2.0-1.0;
    vec2 d = hash22(i+vec2(1,1)) *2.0-1.0;

    vec2 ab = mix(a,b,u.x);
    vec2 cd = mix(c,d,u.x);
    return mix(ab,cd,u.y);
}

vec2 wander(float id, float t, float amp)
{
    vec2 off = vec2(0.0);
    float freq = 0.9;
    vec2 seed = vec2(id*17.13, id*9.71);
    float scene = mod(iTime,10.);
    if(scene>5. && scene<=7.){
        amp += 0.1;
        freq += 0.9;
    }

    vec2 samplePos = vec2(t*freq, 4.2) + seed;
    off += valueNoise2(samplePos) * amp;
    freq *= 2.3;
    amp  *= 0.55;
    return off;
}

float lineTo(vec2 p, vec2 a, vec2 b){
    float k = dot(p-a,b-a)/dot(b-a,b-a);
    vec2 closeToDist = mix(a,b,clamp(k,0.,1.));
    return length(p-closeToDist);
}

// thx iq! https://iquilezles.org/articles/distfunctions2d/
float dot2( vec2 v ) { return dot(v,v); }
float sdBezier( in vec2 pos, in vec2 A, in vec2 B, in vec2 C )
{
    vec2 a = B - A;
    vec2 b = A - 2.0*B + C;
    vec2 c = a * 2.0;
    vec2 d = A - pos;
    float kk = 1.0/dot(b,b);
    float kx = kk * dot(a,b);
    float ky = kk * (2.0*dot(a,a)+dot(d,b)) / 3.0;
    float kz = kk * dot(d,a);
    float res = 0.0;
    float p = ky - kx*kx;
    float p3 = p*p*p;
    float q = kx*(2.0*kx*kx-3.0*ky) + kz;
    float h = q*q + 4.0*p3;
    if( h >= 0.0)
    {
        h = sqrt(h);
        vec2 x = (vec2(h,-h)-q)/2.0;
        vec2 uv = sign(x)*pow(abs(x), vec2(1.0/3.0));
        float t = clamp( uv.x+uv.y-kx, 0.0, 1.0 );
        res = dot2(d + (c + b*t)*t);
    }
    else
    {
        float z = sqrt(-p);
        float v = acos( q/(p*z*2.0) ) / 3.0;
        float m = cos(v);
        float n = sin(v)*1.732050808;
        vec3  t = clamp(vec3(m+m,-n-m,n-m)*z-kx,0.0,1.0);
        res = min( dot2(d+(c+b*t.x)*t.x),
                   dot2(d+(c+b*t.y)*t.y) );
        // the third root cannot be the closest
        // res = min(res,dot2(d+(c+b*t.z)*t.z));
    }
    return sqrt( res );
}

float renderRingAndLine(vec2 p, vec2 pt, vec2 a, vec2 b){
    float d = 10.;
    float ring = abs(length(p-pt)-0.05)-0.005;
    float l = lineTo(p,a,b)-0.003;
    vec2 q = p-pt;
    q *=Rot(radians(iTime*60.));
    ring = max(-(abs(q.y)-0.01),ring);
    
    d = min(ring, l);
    return d;
}

float sdHiragana(vec2 p, vec2 c[TOTAL_POINTS], int typo)
{
    float d = 10.;
    int start = SEG_START[typo];
    int count = SEG_COUNT[typo];
    for (int i = 0; i < count; i++)
    {
        int segIdx = start + i;
        ivec3 s = SEGS[segIdx];
        d = min(d, sdBezier(p, c[s.x], c[s.y], c[s.z]));
    }
    return d;
}

vec3 renderHiragana(vec2 p, int typo, vec3 col, float n1, float n2){
    vec2 c[TOTAL_POINTS];
    int pStart = PT_START[typo];
    int pCount = PT_COUNT[typo];
    float amp = clamp(n1,0.5,1.)*0.05;
    for (int i=0; i<pCount; i++)
    {
        int idx = pStart + i;
        c[idx] = BASE[idx] + wander(float(idx)+n1, n2, amp);
    }

    float d = sdHiragana(p, c, typo);

    col = mix( col, vec3(1.0), S(abs(d)-OUTLINE_THICK) );

    if(n1 < 0.5){
        int len = ANCHOR_LEN[typo];
        int rowBase = typo*7;
        for (int i=0; i<len-1; i++)
        {
            int ia = ANCHORS[rowBase + i];
            int ib = ANCHORS[rowBase + i + 1];
            vec2 pt = c[ia];
            float d2 = renderRingAndLine(p, pt, c[ia], c[ib]);
            d = min(d,d2);
        }
        col = mix( col, vec3(0.6), S(d) );
    }

    return col;
}

float renderQuads(vec2 p,float n1, float n2){
    float s = 0.43;
    float amp = clamp(n1,0.3,1.)*0.03;
    
    vec2 a = vec2(s,s)+wander(n1, n2, amp);
    vec2 b = vec2(-s,s)+wander(1.+n1, n2, amp);
    vec2 c = vec2(-s,-s)+wander(2.+n1, n2, amp);
    vec2 d = vec2(s,-s)+wander(3.+n1, n2, amp);
    float d2 = lineTo(p,a,b);
    float d3 = lineTo(p,b,c);
    d2 = min(d2,d3);
    d3 = lineTo(p,c,d);
    d2 = min(d2,d3);
    d3 = lineTo(p,d,a);
    d2 = min(d2,d3);
    d3 = lineTo(p,a,c);
    d2 = min(d2,d3);
    
    d3 = B(p-a,vec2(0.03));
    d2 = min(d2,d3);
    d3 =B(p-b,vec2(0.03));
    d2 = min(d2,d3);
    d3 = B(p-c,vec2(0.03));
    d2 = min(d2,d3);
    d3 = B(p-d,vec2(0.03));
    d2 = min(d2,d3);
    return d2-0.003;
}

float renderStripe(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(45.));
    p.x += iTime*0.1;
    p.x = mod(p.x,0.08)-0.04;
    float d = abs(p.x)-0.01;
    d = max(B(prevP,vec2(0.43)),d);
    return d;
}

vec2 getSphereMap(vec2 p, float size){
    p*=size;
    float r = dot(p, p);
    float z = sqrt(1.0 - r);
    vec3 q = vec3(p, z);
    q.xz*=Rot(radians(53.+20.*iTime*0.5));
    vec3 normal = normalize(q);

    float longitude = atan(normal.x, normal.z);
    float latitude  = asin(normal.y);

    float u = longitude / (2. * PI) + 0.5;
    float v = latitude / (2.*PI) + 0.5;

    p = vec2(u,v);
    p -= 0.5;
    p*=size;
    return p;
}

// principal value of logarithm of z
// https://gist.github.com/ikr7/d31b0ead87c73e6378e6911e85661b93
vec2 clog (vec2 z) {
	return vec2(log(length(z)), atan(z.y, z.x));
}

// The following code will return the Droste Zoom UV.
// by roywig https://www.shadertoy.com/view/Ml33R7
vec2 drosteUV(vec2 p){
    float speed = 0.3;
    float animate = mod(iTime*speed,2.07);
    float rate = sin(iTime*0.5);
    p = clog(p)*mat2(1,.11,rate*0.5,1);
    //p = clog(p);
    p = exp(p.x+animate) * vec2( cos(p.y), sin(p.y));
    vec2 c = abs(p);
    vec2 duv = .5+p*exp2(ceil(-log2(max(c.y,c.x))-2.));
    return duv;
}

vec2 verticalSplitUV(vec2 p){
    if(mod(p.x,2.)>1.){
        p.y+=iTime*0.5;
    } else {
        p.y-=iTime*0.5;
    }
    return p;
}

vec3 renderAll(vec2 p, vec3 col){    
    p = verticalSplitUV(p);
    
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    float n = random(id);
    int typo = int(n*5.);
    if(n>0.7)typo = int(mod(iTime*n*float(typo)*0.5,5.));
    if (typo > 4) typo = 4;
    
    col = renderHiragana(gr, typo, col, n, iTime*clamp(n,0.5,2.)*30.);
    return col;
}

float renderBg(vec2 p){
    p = drosteUV(p);
    p*=8.;
    p*=Rot(radians(-90.));
    
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    float n = random(id);
    
    float d = renderQuads(gr,n, iTime*clamp(n,0.5,2.)*30.);
    if(n>0.8)d = renderStripe(gr);
    return d;
}

float renderSphereBg(vec2 p){    
    p = verticalSplitUV(p);
    
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;

    vec2 prevGR = gr;
    
    gr *= Rot(radians(45.));
    float d = B(gr,vec2(0.005,0.5));
    float d2 = B(gr,vec2(0.5,0.005));
    d = min(d,d2);
    
    gr = prevGR;
    
    d2 = abs(B(gr,vec2(0.47)))-0.005;
    d2 = max(-(abs(gr.x)-0.42),d2);
    d2 = max(-(abs(gr.y)-0.42),d2);
    d = min(d,d2);

    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
			
    vec3 col = vec3(0.);
    
    float d = renderBg(uv);
    col = mix(col,vec3(0.2),S(d));
    col = mix(col,vec3(0.),S(length(uv)-0.5));
    
    uv = getSphereMap(uv,2.);
    uv*=7.;
    d = renderSphereBg(uv);
    d = max((length(prevUV)-0.5),d);
    col = mix(col,vec3(0.3),S(d));
    
    col = renderAll(uv,col);
    
    uv = prevUV;
    col *= abs( length(uv) -0.5)+0.2;
    fragColor = vec4(sqrt(col),1.0);
}
