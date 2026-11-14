#define MAX_STEPS 256
#define MAX_DIST 256.
#define SURF_DIST .0005
#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.0),b,d)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define SUV(p) vec2(atan(p.x,p.z),acos(p.y))
#define ZERO (min(iFrame,0))
#define ch_0 0
#define ch_1 1
#define ch_2 2
#define ch_3 3
#define ch_4 4
#define ch_5 5
#define ch_6 6
#define ch_7 7
#define ch_8 8
#define ch_9 9

float grid(vec2 p){
    vec2 prevP = p;
    float thickness = 0.001;
    float size = 0.1;
    p+=vec2(size*0.5);
    p = mod(p,size)-(size*0.5);
    
    float d = abs(p.x)-thickness;
    float d2 = abs(p.y)-thickness;
    d = min(d,d2);
    p = prevP;
    p.x = abs(p.x)-0.15;
    d2 = B(p,vec2(thickness,100.));
    d = min(d,d2);
    return d;
}

float char0(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.2));
    float d2 = B(p,vec2(0.1));
    d = max(-d2,d);
    p = prevP;
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.02,2.)),d);
    return d;
}

float char1(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.05,0.2));
    float d2 = B(p-vec2(-0.075,0.15),vec2(0.025,0.05));
    d = min(d,d2);
    p = prevP;
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.02,2.)),d);
    return d;
}

float char2(vec2 p){
    vec2 prevP = p;
    p.y = abs(p.y);
    float d = B(p-vec2(0.0,0.15),vec2(0.2,0.05));
    
    p = prevP;
    p*=Rot(radians(50.));
    float d2 = B(p,vec2(0.05,0.25));
    d = min(d,d2);
    p = prevP;
    d2 = B(p-vec2(-0.15,0.075),vec2(0.05,0.025));
    d = min(d,d2);
    d2 = B(p-vec2(0.15,-0.075),vec2(0.05,0.025));
    d = min(d,d2);
    d = max(abs(p.x)-0.2,d);
    
    p = prevP;
    d = max(-B(p,vec2(2.,0.02)),d);    
    
    return d;
}

float char3(vec2 p){
    vec2 prevP = p;
    p.y = abs(p.y);
    float d = B(p-vec2(0.0,0.15),vec2(0.2,0.05));
    p = prevP;
    float d2 = B(p-vec2(0.15,0.0),vec2(0.05,0.2));
    d = min(d,d2);
    d2 = B(p-vec2(0.0,0.0),vec2(0.1,0.05));
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.15;
    p.y-=0.15;
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.02,0.11)),d);      
    
    return d;
}

float char4(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.2,0.05));
    p = prevP;
    float d2 = B(p-vec2(0.15,0.0),vec2(0.05,0.2));
    d = min(d,d2);
    d2 = B(p-vec2(-0.15,0.1),vec2(0.05,0.1));
    d = min(d,d2);
    
    p = prevP;
    p.x+=0.15;
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.02,0.11)),d);        
    
    return d;
}

float char5(vec2 p){
    vec2 prevP = p;
    p.y = abs(p.y);
    float d = B(p-vec2(0.0,0.15),vec2(0.2,0.05));
    
    p = prevP;
    p*=Rot(radians(-50.));
    float d2 = B(p,vec2(0.05,0.25));
    d = min(d,d2);
    p = prevP;
    d2 = B(p-vec2(-0.15,-0.075),vec2(0.05,0.025));
    d = min(d,d2);
    d = max(abs(p.x)-0.2,d);
    
    p = prevP;
    d = max(-B(p,vec2(2.,0.02)),d);      
    
    return d;
}

float char6(vec2 p){
    vec2 prevP = p;
    p.y+=0.075;
    p.y=abs(p.y)-0.075;
    
    float d = B(p,vec2(0.2,0.05));
    p = prevP;
    float d2 = B(p-vec2(-0.15,0.0),vec2(0.05,0.2));
    d = min(d,d2);
    d2 = B(p-vec2(0.15,-0.1),vec2(0.05,0.1));
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.15;
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.02,0.11)),d);       
    
    return d;
}

float char7(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(0.0,0.15),vec2(0.2,0.05));
    
    p = prevP;
    p.x-=0.05;
    p*=Rot(radians(42.));
    float d2 = B(p,vec2(0.05,0.35));
    d = min(d,d2);
    p = prevP;
    d = max(abs(p.x)-0.2,d);
    d = max(abs(p.y)-0.2,d);
    
    p = prevP;
    p*=Rot(radians(-45.));
    d = max(-B(p,vec2(0.02,0.11)),d);        
    
    return d;
}

float char8(vec2 p){
    vec2 prevP = p;
    p.y = abs(p.y)-0.15;
    float d = B(p,vec2(0.2,0.05));
    p = prevP;
    p.x = abs(p.x);
    float d2 = B(p-vec2(0.15,0.0),vec2(0.05,0.2));
    d = min(d,d2);
    p = prevP;
    d2 = B(p-vec2(-0.15,0.1),vec2(0.05,0.1));
    d = min(d,d2);
    d2 = B(p,vec2(0.2,0.025));
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.02,2.)),d);    
    
    return d;
}

float char9(vec2 p){
    vec2 prevP = p;
    p.y-=0.075;
    p.y = abs(p.y)-0.075;
    float d = B(p,vec2(0.2,0.05));
    p = prevP;
    float d2 = B(p-vec2(0.15,0.0),vec2(0.05,0.2));
    d = min(d,d2);
    d2 = B(p-vec2(-0.15,0.1),vec2(0.05,0.1));
    d = min(d,d2);
    p = prevP;
    p.x-=0.15;
    p.y-=0.15;
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.02,0.11)),d);    
    return d;
}

float checkChar(int targetChar, int char){
    return 1.-abs(sign(float(targetChar) - float(char)));
}

float drawFont(vec2 p, int char){
    p*=1.3;
 
    vec2 prevP = p;
    float d = char0(p)*checkChar(ch_0,char);
    d += char1(p)*checkChar(ch_1,char);
    d += char2(p)*checkChar(ch_2,char);
    d += char3(p)*checkChar(ch_3,char);
    d += char4(p)*checkChar(ch_4,char);
    d += char5(p)*checkChar(ch_5,char);
    d += char6(p)*checkChar(ch_6,char);
    d += char7(p)*checkChar(ch_7,char);
    d += char8(p)*checkChar(ch_8,char);
    d += char9(p)*checkChar(ch_9,char);
    
    float a = radians(-45.);
    p.x+=0.35;
    d = max(-dot(p,vec2(cos(a),sin(a))),d);
    a = radians(-45.);
    p = prevP;
    p.x-=0.35;
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    return d;
}

float number(vec3 p, float n, float height){
    vec3 prevP = p;
    
    float d =drawFont(p.xy*vec2(0.093),int(mod(3.*iTime*n+(n*10.),10.0)));
    d = max((abs(p.z)-max(height,0.5)),d);
    return d;
}

// thx for the tutorial, Blackle Mori! https://www.youtube.com/watch?v=I8fmkLK1OKg
vec2 edge(vec2 p){
    vec2 p2 = abs(p);
    if(p2.x>p.y) return vec2((p.x<0.)?-1.:1. ,0.);
    else  return vec2(0., (p.y<0.)?-1.:1. );
}

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

float drawNumbers(vec3 p){
    p.y-=iTime*2.5;
    
    float spacing = 3.5;
    vec2 scaledP = p.xy / spacing;
    vec2 center = floor(scaledP)+0.5;
    float randomOffset = hash(center) * 6.28;
    vec2 neighbour = center + edge(scaledP-center);
    float maxAnimHeight = 1.5;
    float height = sin(iTime+center.x + center.y + randomOffset)*maxAnimHeight;
    float width = 2.;
    
    float n = hash(center);
    
    float d1 = number(p-vec3(center.x * spacing,center.y * spacing,0.0),n,height);
    float d2 = number(p-vec3(neighbour.x * spacing,neighbour.y * spacing,0.0),n,maxAnimHeight);
    
    return min(d1,d2);
}

vec2 GetDist(vec3 p) {
    vec3 prevP = p;
    
    float d = drawNumbers(p);
    d = max(p.z,d);
    
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
    vec3 lightDir = normalize(vec3(15,-10,1));
    float diff = clamp(dot(n,lightDir),0.0,1.0);
    float skyDiff = clamp(0.5+0.5*dot(n,vec3(0,1,0)),0.0,1.0);
    float bounceDiff = clamp(0.5+0.5*dot(n,vec3(0,-1,0)),0.0,1.0);
    diffCol = col*vec3(-0.5)*diff*occ;
    diffCol += col*vec3(1.0,1.0,0.9)*skyDiff*occ;
    diffCol += col*vec3(0.5)*bounceDiff*occ;
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
    col = diffuseMaterial(n,rd,p,col);
    return col;
}

float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

float getTime(float t, float duration){
    return clamp(t,0.0,duration)/duration;
}

vec3 cameraAnim(vec3 p){

    float rotX = 0.;
    float rotY = -10.;

    float frame = mod(iTime,20.0);
    float time = frame;

    if(frame>=5. && frame<10.){
        time = getTime(time-5.,0.6);

        rotY = -10.+cubicInOut(time)*-10.;
        rotX = cubicInOut(time)*-30.;
    } else if(frame>=10. && frame<15.){
        time = getTime(time-10.,0.6);
        
        rotY = -20.;
        rotX = -30.+cubicInOut(time)*60.;
    } else if(frame>=15.){
        time = getTime(time-15.,0.6);

        rotY = -20.+cubicInOut(time)*10.;
        rotX = 30.+cubicInOut(time)*-30.;
    }

    p.xz*=Rot(radians(rotX));
    p.yz*=Rot(radians(rotY));
    return p;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    vec2 m =  iMouse.xy/iResolution.xy;
    
    vec3 ro = vec3(0, 0., -12.);
    if(iMouse.z>0.){
        ro.yz *= Rot(m.y*3.14+1.);
        ro.y = max(-0.9,ro.y);
        ro.xz *= Rot(-m.x*6.2831);
    } else {
        ro = cameraAnim(ro);
    }
    
    vec3 rd = R(uv, ro, vec3(0,0.0,0), 1.0);
    vec2 d = RayMarch(ro, rd, 1.,MAX_STEPS);
    vec3 col = vec3(.0);
    
    if(d.x<MAX_DIST) {
        vec3 p = ro + rd * d.x;
        vec3 n = GetNormal(p);
        int mat = int(d.y);
        col = materials(mat,n,rd,p,col);
    } else {
        uv.y-=iTime*0.1;
        uv = mod(uv,0.06)-0.03;
        float d2 = length(uv)-0.001;
        col = mix(col,vec3(0.5),S(d2,0.0));
    }
    
    /*
    col = vec3(0.);
    float d2 = grid(uv);
    col = mix(col,vec3(0.5),S(d2,0.0));
    d2 = drawFont(uv,int(mod(iTime,10.)));
    col = mix(col,vec3(1.),S(d2,0.0));
    */   

    fragColor = vec4(sqrt(col),1.0);
}
