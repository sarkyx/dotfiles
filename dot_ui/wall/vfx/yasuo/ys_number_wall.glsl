#define MAX_STEPS 128
#define MAX_DIST 128.
#define SURF_DIST .0005
#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.0),b,d)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define seg_0 0
#define seg_1 1
#define seg_2 2
#define seg_3 3
#define seg_4 4
#define seg_5 5
#define seg_6 6
#define seg_7 7
#define seg_8 8
#define seg_9 9

float random (vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

float segBase(vec2 p){
    vec2 prevP = p;
    
    float size = 0.02;
    float padding = 0.05;

    float w = padding*3.0;
    float h = padding*5.0;

    p = mod(p,0.05)-0.025;
    float thickness = 0.005;
    float gridMask = min(abs(p.x)-thickness,abs(p.y)-thickness);
    
    p = prevP;
    float d = B(p,vec2(w*0.5,h*0.5));
    float a = radians(40.0);
    p.x = abs(p.x)-0.11;
    p.y = abs(p.y)-0.06;
    float d2 = dot(p,vec2(cos(a),sin(a)));
    d = max(d2,d);
    return d;
}

float seg0(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    float mask = B(p,vec2(size,size*2.7));
    d = max(-mask,d);
    return d;
}

float seg1(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x+=size;
    p.y+=size;
    float mask = B(p,vec2(size*2.,size*3.7));
    d = max(-mask,d);
    
    p = prevP;
    
    p.x+=size*1.9;
    p.y-=size*3.2;
    mask = B(p,vec2(size,size+0.01));
    d = max(-mask,d);
    
    return d;
}

float seg2(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x+=size;
    p.y-=0.05;
    float mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);

    p = prevP;
    p.x-=size;
    p.y+=0.05;
    mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);
    
    return d;
}

float seg3(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.y = abs(p.y);
    p.x+=size;
    p.y-=0.05;
    float mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);

    p = prevP;
    p.x+=0.06;
    mask = B(p,vec2(size,size+0.01));
    d = max(-mask,d);
    
    return d;
}

float seg4(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    
    p.x+=size;
    p.y+=0.08;
    float mask = B(p,vec2(size*2.,size*2.0));
    d = max(-mask,d);

    p = prevP;
    
    p.y-=0.08;
    mask = B(p,vec2(size,size*2.0));
    d = max(-mask,d);
    
    return d;
}

float seg5(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x-=size;
    p.y-=0.05;
    float mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);

    p = prevP;
    p.x+=size;
    p.y+=0.05;
    mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);
    
    return d;
}

float seg6(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x-=size;
    p.y-=0.05;
    float mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);

    p = prevP;
    p.y+=0.05;
    mask = B(p,vec2(size,size));
    d = max(-mask,d);
    
    return d;
}

float seg7(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.x+=size;
    p.y+=size;
    float mask = B(p,vec2(size*2.,size*3.7));
    d = max(-mask,d);
    return d;
}

float seg8(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.y = abs(p.y);
    p.y-=0.05;
    float mask = B(p,vec2(size,size));
    d = max(-mask,d);
    
    return d;
}

float seg9(vec2 p){
    vec2 prevP = p;
    float d = segBase(p);
    float size = 0.03;
    p.y-=0.05;
    float mask = B(p,vec2(size,size));
    d = max(-mask,d);

    p = prevP;
    p.x+=size;
    p.y+=0.05;
    mask = B(p,vec2(size*2.,size));
    d = max(-mask,d);
    
    return d;
}

float checkChar(int targetChar, int char){
    return 1.-abs(sign(float(targetChar) - float(char)));
}

float drawFont(vec2 p, int char){
    p.x*=0.55;
    float d = seg0(p)*checkChar(seg_0,char);
    d += seg1(p)*checkChar(seg_1,char);
    d += seg2(p)*checkChar(seg_2,char);
    d += seg3(p)*checkChar(seg_3,char);
    d += seg4(p)*checkChar(seg_4,char);
    d += seg5(p)*checkChar(seg_5,char);
    d += seg6(p)*checkChar(seg_6,char);
    d += seg7(p)*checkChar(seg_7,char);
    d += seg8(p)*checkChar(seg_8,char);
    d += seg9(p)*checkChar(seg_9,char);
    
    return d;
}

float pattern1(vec3 p, float n){
    vec3 prevP = p;
    float d =drawFont(p.xy*vec2(0.15,0.135),int(mod(9.+iTime*n,10.0)));
    d = max((abs(p.z)-0.1),d);
    return d;
}

float pattern2(vec3 p, float n){
    vec3 prevP = p;
    float d = drawFont((p.xy*0.3)-vec2(-0.15,0.15),int(mod(8.+iTime*n*1.,10.0)));
    float d2 = drawFont((p.xy*0.3)-vec2(0.15,0.15),int(mod(7.+iTime*n*1.2,10.0)));
    d = min(d,d2);
    d2 = drawFont((p.xy*0.3)-vec2(-0.15,-0.15),int(mod(5.+iTime*n*1.5,10.0)));
    d = min(d,d2);
    d2 = drawFont((p.xy*0.3)-vec2(0.15,-0.15),int(mod(3.+iTime*n*1.3,10.0)));
    d = min(d,d2);
    
    d = max((abs(p.z)-0.1),d);
    return d;
}

vec2 GetDist(vec3 p) {
    
    vec3 prevP = p;
    p.y-=0.5*iTime;
    vec2 id = floor(p.xy*0.5);
    p.z-=3.;
    p.xy = mod(p.xy,2.0)-1.0;
    float n = random(id);
    
    float t = iTime*2.;
    float d = 10.;
    if(n<0.5){
        d = pattern1(p,n);
    } else {
        d = pattern2(p,n);
    }

    return vec2(d,0.0);
}

vec2 RayMarch(vec3 ro, vec3 rd, float side, int stepnum) {
    vec2 dO = vec2(0.0);
    
    for(int i=0; i<stepnum; i++) {
        vec3 p = ro + rd*dO.x;
        vec2 dS = GetDist(p);
        dO.x += dS.x;
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

vec3 diffuseMaterial(vec3 n, vec3 rd, vec3 p, vec3 col) {
    vec3 diffCol = vec3(0.0);
    vec3 lightDir = normalize(vec3(15,-10,1));
    float diff = clamp(dot(n,lightDir),0.0,1.0);
    float skyDiff = clamp(0.5+0.5*dot(n,vec3(0,1,0)),0.0,1.0);
    float bounceDiff = clamp(0.5+0.5*dot(n,vec3(0,-1,0)),0.0,1.0);
    diffCol = col*vec3(-0.5)*diff;
    diffCol += col*vec3(1.0,1.0,0.9)*skyDiff;
    diffCol += col*vec3(0.5)*bounceDiff;
    diffCol += col*pow(max(dot(rd, reflect(lightDir, n)), 0.0), 60.); // spec
        
    return diffCol;
}

vec3 materials(int mat, vec3 n, vec3 rd, vec3 p, vec3 col){
    col = diffuseMaterial(n,rd,p,vec3(0.1));
    return col;
}

float dots(vec2 p){
    vec2 prevP = p;
    p.x = abs(p.x)-0.008;
    p.y = abs(p.y)-0.007;
    float d = length(p)-0.001;
    p = prevP;
    float d2 =  length(p)-0.001;
    d = min(d,d2);
    return d;
}

float circleUI(vec2 p){
    vec2 prevP = p;
    
    p*=Rot(radians(20.*iTime));
    p = DF(p,vec2(20.));
    p-=vec2(0.25);
    
    p*=Rot(radians(45.));
    float d = B(p,vec2(0.002,0.01));
    
    p = prevP;
    p*=Rot(radians(20.*iTime));
    p = DF(p,vec2(2.));
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.04,1.)),d);
    
    p = prevP;
    
    float d2 = abs(length(p)-0.4)-0.001;
    p*=Rot(radians(120.*sin(iTime*0.5)));
    p = DF(p,vec2(1.3));
    p*=Rot(radians(45.));
    d2 = max(-B(p,vec2(0.1,1.)),d2);
    p = prevP;
    p*=Rot(radians(120.*sin(iTime*0.5)));
    d2 = max(p.x,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = abs(length(p)-0.28)-0.001;
    p*=Rot(radians(-150.*sin(iTime*0.3)));
    p = DF(p,vec2(1.));
    p*=Rot(radians(45.));
    d2 = max(-B(p,vec2(0.02,1.)),d2);
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(20.*iTime));
    p = DF(p,vec2(2.));
    p-=vec2(0.25);
    p*=Rot(radians(45.));
    d2 = Tri(p,vec2(0.01));
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(-5.*iTime));
    p = DF(p,vec2(18.));
    p-=vec2(0.22);
    p*=Rot(radians(45.));
    d2 = dots(p);
    d = min(d,d2);
    
    return d;
}

float centerUI(vec2 p){
    vec2 prevP = p;
    
    p+=0.015;
    p.y-=iTime*0.05;
    p =mod(p,0.03)-0.015;
    float d = length(p)-0.0012;
    p = prevP;
    p = abs(p)-0.08;
    float a = radians(45.);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    p = prevP;
    p.x = abs(p.x)-0.16;
    float d2 = length(p)-0.005;
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(120.*sin(iTime*0.2)));
    d2 = abs(length(p)-0.18)-0.004;
    d2 = max(abs(p.y)-0.08,d2);
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(-100.*sin(iTime*0.4)));
    p.y = abs(p.y)-0.23;
    d2 = Tri(p,vec2(0.01));
    d = min(d,d2);
    
    return d;
}

float sideGuageUI(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.002,0.25));
    p.x-=0.012;
    p.y = abs(p.y)-0.09;
    
    float d2 = B(p,vec2(0.012,0.003));
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.012;
    p.y = abs(p.y)-0.247;
    d2 = B(p,vec2(0.012,0.003));
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.006;
    p.y+=iTime*0.05;
    p.y = mod(p.y,0.016)-0.008;
    d2 = B(p,vec2(0.006,0.001));
    d2 = max((abs(prevP.y)-0.25),d2);
    d = min(d,d2);
    
    return d;
}

float stripesBoxUI(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.12,0.015));
    
    p*=Rot(radians(40.));
    p.x-=iTime*0.03;
    p.x = mod(p.x,0.02)-0.01;
    float d2 = abs(p.x)-0.004;
    d = max(d2,d);
    
    p = prevP;
    d2 = abs(B(p,vec2(0.13,0.025)))-0.0001;
    d = min(d,d2);
    
    return d;
}

float drawUI(vec2 p){
    vec2 prevP = p;
   
    float d = circleUI(p);
    float d2 = centerUI(p);
    d = min(d,d2);
    p.x = abs(p.x)-0.7;
    d2 = sideGuageUI(p);
    d = min(d,d2);
    p = prevP;
    p.x+=0.5;
    p.y-=0.35;
    d2 = stripesBoxUI(p);
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.5;
    p.y+=0.35;
    p.x*=-1.0;
    d2 = stripesBoxUI(p);
    d = min(d,d2);
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    vec2 m =  iMouse.xy/iResolution.xy;
    
    vec3 ro = vec3(0, 0, -1.35);
    ro.yz *= Rot(radians(-45.0));
    ro.xy *= Rot(radians(15.));
    
    vec3 rd = R(uv, ro, vec3(0,0.0,0), 1.0);
    vec2 d = RayMarch(ro, rd, 1.,MAX_STEPS);
    vec3 col = vec3(0.0);
    
    if(d.x<MAX_DIST) {
        vec3 p = ro + rd * d.x;
        vec3 n = GetNormal(p);
        int mat = int(d.y);
        col = materials(mat,n,rd,p,col);
    }
    
    float ud = drawUI(uv);
    col = mix(col,vec3(1.),S(ud,0.0));
    
    fragColor = vec4(sqrt(col),1.0);
}
