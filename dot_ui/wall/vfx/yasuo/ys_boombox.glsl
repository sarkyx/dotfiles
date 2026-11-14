#define MAX_STEPS 64
#define MAX_DIST 64.
#define SURF_DIST .0005
#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.0),b,d)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define SUV(p) vec2(atan(p.x,p.z),acos(p.y))
#define ZERO (min(iFrame,0))

// thx iq! https://iquilezles.org/articles/distfunctions/
float sdBox( vec3 p, vec3 b )
{
    vec3 q = abs(p) - b;
    return length(max(q,0.0)) + min(max(q.x,max(q.y,q.z)),0.0);
}

// thx iq! https://iquilezles.org/articles/distfunctions/
float sdTorus( vec3 p, vec2 t )
{
    vec2 q = vec2(length(p.xy)-t.x,p.z);
    return length(q)-t.y;
}

// thx iq! https://iquilezles.org/articles/distfunctions/
float sdCone( vec3 p, vec2 c, float h )
{
  // c is the sin/cos of the angle, h is height
  // Alternatively pass q instead of (c,h),
  // which is the point at the base in 2D
  vec2 q = h*vec2(c.x/c.y,-1.0);
    
  vec2 w = vec2( length(p.xy), -p.z );
  vec2 a = w - q*clamp( dot(w,q)/dot(q,q), 0.0, 1.0 );
  vec2 b = w - q*vec2( clamp( w.x/q.x, 0.0, 1.0 ), 1.0 );
  float k = sign( q.y );
  float d = min(dot( a, a ),dot(b, b));
  float s = max( k*(w.x*q.y-w.y*q.x),k*(w.y-q.y)  );
  return sqrt(d)*sign(s);
}

float knob(vec3 p, float speed){
    p.xy*=Rot(radians(30.*sin(iTime*speed)));
    float d = max(abs(p.z)-0.01,length(p.xy)-0.015);
    float d2 = sdBox(p-vec3(0.,0.,-0.02),vec3(0.004,0.1,0.014));
    d = max(-d2,d);
    return d;
}

float circleSlider(vec3 p, float speed){
    p.yz*=Rot(radians(30.*sin(iTime*speed)));
    float d = max(abs(p.x)-0.01,length(p.yz)-0.02);
    float d2 = sdBox(p-vec3(0.,0.,-0.017),vec3(0.01,0.008,0.01));
    d = min(d,d2);
    return d;
}

float rectSlider(vec3 p, float speed){
    p.y+=sin(iTime*speed)*0.025;
    float d = sdBox(p,vec3(0.008,0.015,0.02));
    return d;
}

float upperFarSideItem(vec3 p){
    vec3 prevP = p;
    float d = sdBox(p,vec3(0.05,0.04,0.04));
    float a = radians(-30.);
    p.y = abs(p.y);
    float c = dot(p-vec3(0.,0.07,0.),vec3(0.0,sin(a),cos(a)));
    d = max(-c,d);
    p = prevP;
    d = max(-sdBox(p-vec3(0.,0.0,-0.03),vec3(0.04,0.03,0.05)),d);
    float d2 = sdBox(p-vec3(0.,0.0,-0.035),vec3(0.05,0.004,0.003));
    d = min(d,d2);
    return d;
}

float centerBottomItem(vec3 p){
    vec3 prevP = p;
    float d = sdBox(p,vec3(0.09,0.025,0.025));
    float a = radians(-30.);
    float c = dot(p-vec3(0.,0.04,0.),vec3(0.0,sin(a),cos(a)));
    d = max(-c,d);
    
    p.x = abs(p.x)-0.01;
    p.y+=-0.013;
    p.z+=0.02;
    p.yz*=Rot(radians(-30.));
    float d2 = sdBox(p,vec3(0.008,0.015,0.005));
    d = min(d,d2);
    p.x = abs(p.x)-0.02;
    d2 = sdBox(p,vec3(0.008,0.015,0.005));
    d = min(d,d2);
    p.x = abs(p.x)-0.02;
    d2 = sdBox(p,vec3(0.008,0.015,0.005));
    d = min(d,d2);
    return d;
}

float speaker(vec3 p){
    vec3 prevP = p;
    float d = sdTorus(p,vec2(0.105,0.005));
    float d2 = sdCone(p-vec3(0.,0.0,-0.1),vec2(0.15),0.13);
    d2 = max((abs(p.z)-0.015),d2);
    d2 = max(-(length(p.yx)-0.075),d2);
    d = min(d,d2);
    d2 = length(p-vec3(0.,0.0,0.05))-0.028;
    d = min(d,d2);
    
    p.y = abs(p.y)-0.022;
    p.y+=-0.01;
    p.z+=0.015;
    d2 = sdBox(p,vec3(0.1,0.01,0.01));
    float a = radians(-50.);
    p.x = abs(p.x)-0.09;
    float c = dot((p-vec3(0.,0.02,0.)),vec3(sin(a),cos(a),0.0));
    d2 = max(-c,d2);
    p = prevP;
    p.y = abs(p.y)-0.022;
    p.z+=0.015;
    d2 = max(-d2,sdBox(p,vec3(0.09,0.012,0.005)));
    d = min(d,d2);
    
    p = prevP;
    p.z+=0.015;
    p.x = abs(p.x)-0.08;
    d2 = sdBox(p,vec3(0.01,0.007,0.01));
    d = min(d,d2);
    
    return d;
}

float boomBox(vec3 p){
    vec3 prevP = p;
    float d = sdBox(p,vec3(0.35,0.22,0.08));
    float a = radians(-30.);
    float c = dot(p-vec3(0.,0.3,0.),vec3(0.0,sin(a),cos(a)));
    d = max(-c,d);
    p.x = abs(p.x)-0.35;
    float d2 = sdBox(p-vec3(0.,-0.02,0.),vec3(0.005,0.16,0.06));
    d = max(-d2,d);
    p = prevP;
    p+=vec3(0.3,-0.19,0.06);
    d2 = max(abs(p.z)-0.02,length(p.xy)-0.01);
    d = min(d,d2);
    p = prevP;
    p+=vec3(-0.29,-0.175,0.07);
    d2 = max(abs(p.z)-0.02,length(p.xy)-0.025);
    d = min(d,d2);
    
    // antenna
    p = prevP;
    p.x = abs(p.x)-0.05;
    p.y-=0.25;
    p.xy*=Rot(radians(45.));
    d2 = max(abs(p.y)-0.2,length(p.xz)-0.005);
    d = min(d,d2);
    p = prevP;
    p.y-=0.21;
    d2 = sdBox(p,vec3(0.06,0.02,0.01));
    d = min(d,d2);
    
    // handle
    p = prevP;
    p+=vec3(0.0,-0.25,-0.03);
    d2 = sdBox(p,vec3(0.32,0.05,0.012));
    d2 = max(-sdBox(p-vec3(0.,-0.005,0.),vec3(0.305,0.025,0.05)),d2);
    d = min(d,d2);
    
    // right circle slider
    p = prevP;
    p.x -= 0.19;
    p.y+=-0.08;
    p.x = abs(p.x)-0.02;
    p += vec3(0.0,0.0,0.08);
    d = max(-sdBox(p,vec3(0.017,0.027,0.02)),d);
    p -= vec3(0.0,0.0,0.01);
    d2 = circleSlider(p,1.5);
    d = min(d,d2);
    
    p = prevP;
    p.y+=-0.08;
    p.x = abs(p.x)-0.1;
    p += vec3(0.0,0.0,0.08);
    d = max(-sdBox(p,vec3(0.017,0.027,0.02)),d);
    p -= vec3(0.0,0.0,0.01);
    d2 = circleSlider(p,-1.2);
    d = min(d,d2);    
    
    // center slider
    p = prevP;
    p.y+=-0.1;
    p.x = abs(p.x)-0.015;
    p += vec3(0.0,0.0,0.08);
    d = max(-sdBox(p,vec3(0.012,0.045,0.02)),d);
    p -= vec3(0.0,0.0,0.01);
    d2 = rectSlider(p,-1.2);
    d = min(d,d2); 
    
    p = prevP;
    p.y+=-0.1;
    p.x = abs(p.x)-0.045;
    p += vec3(0.0,0.0,0.08);
    d = max(-sdBox(p,vec3(0.012,0.045,0.02)),d);
    p -= vec3(0.0,0.0,0.01);
    d2 = rectSlider(p,1.7);
    d = min(d,d2); 
    
    // knobs
    p = prevP;
    p.x += 0.18;
    p.y+=-0.07;
    p.z+=0.08;
    d2 = knob(p,1.7);
    d = min(d,d2); 
    
    p.x = abs(p.x)-0.04;
    d2 = knob(p,-1.2);
    d = min(d,d2); 
    
    // upper far side parts
    p = prevP;
    p.y+=-0.095;
    p.z+=0.08;
    p.x = abs(p.x)-0.29;
    d2 = upperFarSideItem(p);
    d = min(d,d2); 
    
    // bottom center
    p = prevP;
    p.z+=0.08;
    p.y-=0.01;
    d2 = sdBox(p,vec3(0.09,0.03,0.01));
    d2 = max(-sdBox(p,vec3(0.04,0.01,0.02)),d2);
    d = min(d,d2); 
    p.y+=0.05;
    d2 = sdBox(p,vec3(0.09,0.01,0.01));
    d = min(d,d2); 
    p.y+=0.06;
    d2 = sdBox(p,vec3(0.09,0.04,0.01));
    d2 = max(-sdBox(p,vec3(0.04,0.02,0.02)),d2);
    d = min(d,d2);
    p.y+=0.075;
    d2 = centerBottomItem(p);
    d = min(d,d2);
    
    // speakers
    p = prevP;
    p.y+=0.08;
    p.z+=0.08;
    p.x = abs(p.x)-0.22;
    d2 = sdBox(p,vec3(0.12,0.12,0.01));
    d = min(d,d2); 
    p.z+=0.01;
    d2 = speaker(p);
    p.z+=0.035;
    d = max(-(length(p)-0.08),d);
    d = min(d,d2); 
    return d;
}

vec2 GetDist(vec3 p) {
    vec3 prevP = p;
    
    float d = boomBox(p);
    
    return vec2(d,0);
}

vec2 RayMarch(vec3 ro, vec3 rd, float side, int stepnum) {
    vec2 dO = vec2(0.0);
    
    for(int i=0; i<stepnum; i++) {
        vec3 p = ro + rd*dO.x;
        vec2 dS = GetDist(p);
        dO.x += dS.x*side;
        dO.y = dS.y;
        
        if(dO.x>MAX_DIST || abs(dS.x)<SURF_DIST) break;
    }
    
    return dO;
}

vec3 GetNormal(vec3 p) {
    float d = GetDist(p).x;
    vec2 e = vec2(.001, 0);
    
    vec3 n = d - vec3(
        GetDist(p-e.xyy).x,
        GetDist(p-e.yxy).x,
        GetDist(p-e.yyx).x);
    
    return normalize(n);
}

vec3 R(vec2 uv, vec3 p, vec3 l, float z) {
    vec3 f = normalize(l-p),
        r = normalize(cross(vec3(0,1,0), f)),
        u = cross(f,r),
        c = p+f*z,
        i = c + uv.x*r + uv.y*u,
        d = normalize(i-p);
    return d;
}

// https://www.shadertoy.com/view/3lsSzf
float calcOcclusion( in vec3 pos, in vec3 nor )
{
    float occ = 0.0;
    float sca = 1.0;
    for( int i=ZERO; i<3; i++ )
    {
        float h = 0.01 + 0.15*float(i)/4.0;
        vec3 opos = pos + h*nor;
        float d = GetDist( opos ).x;
        occ += (h-d)*sca;
        sca *= 0.95;
    }
    return clamp( 1.0 - 2.0*occ, 0.0, 1.0 );
}

vec3 diffuseMaterial(vec3 n, vec3 rd, vec3 p, vec3 col) {
    float occ = calcOcclusion(p,n);
    vec3 diffCol = vec3(0.0);
    vec3 lightDir = normalize(vec3(1,10,10));
    float diff = clamp(dot(n,lightDir),0.0,1.0);
    float skyDiff = clamp(0.5+0.5*dot(n,vec3(0,1,0)),0.0,1.0);
    float bounceDiff = clamp(0.5+0.5*dot(n,vec3(0,-1,0)),0.0,1.0);
    diffCol = col*vec3(-0.5)*diff*occ;
    diffCol += col*vec3(1.0,1.0,0.9)*skyDiff*occ;
    diffCol += col*vec3(0.8)*bounceDiff*occ;
    diffCol += col*pow(max(dot(rd, reflect(lightDir, n)), 0.0), 60.)*occ; // spec
        
    return diffCol;
}

// the reflection code reference from the following: https://www.shadertoy.com/view/tsXSRs
vec3 reflectionBg(vec2 uv){
    const float pi = 3.14159;
    return mix(vec3(0.05), vec3(2.), smoothstep(pi*0.35, pi*0.98, uv.y));
}

vec3 materials(int mat, vec3 n, vec3 rd, vec3 p, vec3 col){    
    float IOR =	1.309; //IOR:index of reflection
    vec3 rdir = refract(-rd,n,1.0/IOR); 
    col = reflectionBg(SUV(rdir));
    col = diffuseMaterial(n,rd,p,sqrt(col));
    return col;
}

float dots(vec2 p, float size, float dirX, float dirY){
    p.x-=iTime*0.02*dirX;
    p.y-=iTime*0.02*dirY;
    return length(mod(p,0.03)-0.015)-size;
}

float bgItem(vec2 p){
    p*=Rot(radians(-25.));
    p*=0.7;
    p.x-=0.13;
    vec2 prevP = p;
    p.y*=1.5;
    p-=vec2(0.12,-0.02);
    p*=Rot(radians(100.));
    float d = Tri(p,vec2(0.2));
    p = prevP;
    p-=vec2(-0.1,0.03);
    p*=Rot(radians(115.));
    float d2 = B(p,vec2(0.05,0.12));
    d = min(d,d2);
    p = prevP;
    p-=vec2(-0.4,0.04);
    p*=Rot(radians(-100.));
    p.x*=4.;
    p.y*=0.9;
    d2 = Tri(p,vec2(0.2));

    d = min(d,d2);
    p = prevP;
    return max(d,dots(p,0.007,3.,0.));
}

float stripes(vec2 p, float dir){
    vec2 prevP = p;
    
    p*=Rot(radians(30.));
    p.x+=iTime*0.05*dir;
    p.x = mod(p.x,0.02)-0.01;
    
    float d = B(p,vec2(0.003,10.));
    return d;
}

vec3 triBg(vec2 p, vec3 col){
    vec2 prevP = p;
    float d = max(Tri(p,vec2(0.3)),dots(p,0.001,0.,1.));
    return mix(col,vec3(0.7),S(d,0.0));
}

vec3 circleBg(vec2 p, vec3 col){
    vec2 prevP = p;
    float d = max(abs(length(p)-0.15)-0.02,dots(p,0.001,0.,1.));
    return mix(col,vec3(0.7),S(d,0.0));
}

vec3 stripeBg(vec2 p, vec3 col){
    vec2 prevP = p;
    float d = stripes(p,1.);
    d = max(B(p,vec2(0.55,0.25)),d);
    return mix(col,vec3(0.13),S(d,0.0));
}

vec3 drawBg(vec2 p, vec3 col) {
    vec2 prevP = p;
    p*=Rot(radians(iTime*-10.0));
    // https://en.wikipedia.org/wiki/Log-polar_coordinates
    float r = log(sqrt(p.x*p.x+p.y*p.y)); // or log(length(p))
    float theta = atan(p.y/p.x);
    p.x = r;
    p.y = theta;
    
    p.x-=iTime*0.3;
    p*=2.0;
    p = fract(p)-0.5;
    p*=0.75;
    
    float d = bgItem(p);
    p = prevP;
    col = triBg(p-vec2(-0.5,-0.1),col);
    col = triBg((vec2(p.x,p.y*-1.)-vec2(0.5,-0.1)),col);
    col = circleBg(p-vec2(-0.54,0.25),col);
    col = circleBg(vec2(p.x,p.y*-1.)-vec2(0.54,0.25),col);
    col = stripeBg(p,col);
    col += mix(col,vec3(0.7),S(d,0.0));
    
    d = length(p)-0.01;
    col = mix(col,vec3(0.7),S(d,0.0));
    
    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    
    vec3 ro = vec3(0, 0, -1.);
    ro.yz *= Rot(radians(-5.0));
    ro.xz *= Rot(radians(sin(iTime*0.6)*30.0));
    
    vec3 rd = R(uv, ro, vec3(0,0.0,0), 1.0);
    vec2 d = RayMarch(ro, rd, 1.,MAX_STEPS);
    vec3 col = vec3(.0);
    
    if(d.x<MAX_DIST) {
        vec3 p = ro + rd * d.x;
        vec3 n = GetNormal(p);
        int mat = int(d.y);
        col = materials(mat,n,rd,p,col);
    } else {
        col = drawBg(uv,col);
    }

    fragColor = vec4(col,1.0);
}
