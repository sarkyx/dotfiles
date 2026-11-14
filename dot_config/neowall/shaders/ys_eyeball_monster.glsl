#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURF_DIST .0005
#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.0),b,d)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define Tri(p,s,a) max(-dot(p,vec2(cos(-a),sin(-a))),max(dot(p,vec2(cos(a),sin(a))),max(abs(p).x-s.x,abs(p).y-s.y)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define ZERO (min(iFrame,0))

float SimpleVesicaDistanceX(vec2 p, float r, float d) {
    p.y = abs(p.y);
    p.y+=d;
    return length(p)-r;
}

float eyeBall(vec2 p){
    
    p.x+=sin(iTime*0.5)*0.1;
    vec2 prevP = p;
    
    float d = abs(length(p)-0.13)-0.005;
    float d2 = length(p)-0.045;
    d = min(d,d2);
    
    p*=Rot(radians(iTime*-20.));
    p=DF(p,8.);
    p-=vec2(0.08);
    p*=Rot(radians(45.));
    d2 = B(p,vec2(0.003,0.01));
    d = min(d,d2);
    
    p = prevP;
    
    p*=Rot(radians(iTime*30.));
    d2 = abs(length(p)-0.075)-0.012;
    
    float a = radians(45.);
    p.x = abs(p.x);
    
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    
    d = min(d,d2);
    
    p = prevP;
    d2 = abs(length(p)-0.075)-0.002;
    d = min(d,d2);
    
    return d;
}

float eye(vec3 p, float mask, float mask2){
    vec3 prevP = p;
    p.z = abs(p.z);
    p.z-=0.55;
    
    float eye = eyeBall(p.xy);
    p = prevP;
    p.z = abs(p.z);
    p.z-=0.55;
    float s = mod(iTime*0.5,2.3);
    if(s<1.){
        p.y*=1.+s;
    } else if(s>=1. && s<2.){
        p.y*=1.+2.-s;
    }
    
    float d2 = abs(SimpleVesicaDistanceX(p.xy,0.25,0.1))-0.01;
    float d3 = SimpleVesicaDistanceX(p.xy,0.25,0.1);
    
    
    eye = max(abs(p.z)-0.03,eye);
    
    
    d2 = max(abs(p.z)-0.07,d2);
    d2 = max(mask,d2);
    
    d3 = max(abs(p.z)-0.1,d3);
    d3 = max(mask2,d3);
    eye = max(d3,eye);
    
    
    return  min(eye,d2);
}

float pattern(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(-30.*iTime));
    float d = abs(length(p)-0.1)-0.005;
    d = max(abs(p.x)-0.05,d);
    p = prevP;
    float d2 = abs(length(p)-0.07)-0.001;
    
    d = min(d,d2);
    
    p*=Rot(radians(90.+30.*iTime));
    p.y = abs(p.y)-0.15;
    d2 = Tri(p,vec2(0.03),radians(45.));
    d = min(d,d2);
    
    return d;
}

float pattern2(vec2 p, float thickness){
    vec2 prevP = p;
    p*=Rot(radians(45.));
    float d = abs(B(p, vec2(0.1)))-0.002;
    float d2 = abs(B(p, vec2(0.06)))-0.002;
    d2 = max(-(abs(p.x)-0.02),d2);
    d2 = max(-(abs(p.y)-0.02),d2);
    d = min(d,d2);
    d2 = abs(B(p, vec2(0.1)))-thickness;
    p*=Rot(radians(30.*iTime));
    d2 = max(-(abs(p.x)-0.05),d2);
    d2 = max(-(abs(p.y)-0.05),d2);
    d = min(d,d2);
    return d;
}

vec2 GetDist(vec3 p) {

    p.yz *= Rot(radians(iTime*-3.0));
    vec3 prevP = p;
    
    float mask = length(p)-0.58;
    float mask2 = length(p)-0.565;
    float d = length(p)-0.55;
    
    float d2 = eye(p,mask,mask2);
    
    d = min(d,d2);
    
    p.xz*=Rot(radians(90.));
    d2 = eye(p,mask,mask2);
    d = min(d,d2);
    
    p = prevP;
    p.yz*=Rot(radians(90.));
    d2 = eye(p,mask,mask2);    
    d = min(d,d2);
    
    p = prevP;
    p.yz*=Rot(radians(45.));
    p.xz*=Rot(radians(35.));
    d2 = pattern(p.xy);
    d2 = max(mask,d2);
    d = min(d,d2);
    
    p = prevP;
    p.yz*=Rot(radians(-45.));
    p.xz*=Rot(radians(35.));
    d2 = pattern(p.xy);
    d2 = max(mask,d2);
    d = min(d,d2);
    
    p = prevP;
    p.yz*=Rot(radians(-45.));
    p.xz*=Rot(radians(-35.));
    d2 = pattern(p.xy);
    d2 = max(mask,d2);
    d = min(d,d2);
    
    p = prevP;
    p.yz*=Rot(radians(45.));
    p.xz*=Rot(radians(-35.));
    d2 = pattern(p.xy);
    d2 = max(mask,d2);
    d = min(d,d2);    
    
    p = prevP;
    p.yz*=Rot(radians(45.));
    d2 = pattern2(p.xy,0.01);    
    d2 = max(mask,d2);
    d = min(d,d2);   
    
    p = prevP;
    p.yz*=Rot(radians(-45.));
    d2 = pattern2(p.xy,0.01);    
    d2 = max(mask,d2);
    d = min(d,d2);       
    
    p = prevP;
    p.xz*=Rot(radians(45.));
    d2 = pattern2(p.xy,0.01);    
    d2 = max(mask,d2);
    d = min(d,d2);   
        
    p = prevP;
    p.xz*=Rot(radians(-45.));
    d2 = pattern2(p.xy,0.01);    
    d2 = max(mask,d2);
    d = min(d,d2);   
    
    p = prevP;
    p.xz*=Rot(radians(90.));
    p.yz*=Rot(radians(-35.));
    d2 = pattern2(p.xy,0.01);    
    d2 = max(mask,d2);
    d = min(d,d2);      
    
    
    p = prevP;
    p.xz*=Rot(radians(-90.));
    p.yz*=Rot(radians(-35.));
    d2 = pattern2(p.xy,0.01);    
    d2 = max(mask,d2);
    d = min(d,d2);         
    
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
    vec3 lightDir = normalize(vec3(1,10,-10));
    float diff = clamp(dot(n,lightDir),0.0,1.0);
    //float shadow = step(RayMarch(p+n*0.3,lightDir,1.0, 15).x,0.9);
    float skyDiff = clamp(0.5+0.5*dot(n,vec3(0,1,0)),0.0,1.0);
    float bounceDiff = clamp(0.5+0.5*dot(n,vec3(0,-1,0)),0.0,1.0);
    //diffCol = col*vec3(-0.5)*diff*shadow*occ;
    diffCol += col*vec3(1.0,1.0,0.95)*skyDiff*occ;
    diffCol += col*vec3(0.95)*bounceDiff*occ;
    diffCol += col*pow(max(dot(rd, reflect(lightDir, n)), 0.0), 60.)*occ; // spec
        
    return diffCol;
}

vec3 materials(int mat, vec3 n, vec3 rd, vec3 p, vec3 col){
    col = diffuseMaterial(n,rd,p,vec3(1.));
    return col;
}

float bg (vec2 p){
    vec2 prevP = p;
    float d = 10.;
    for(float i = 0.; i<5.; i++){
        p*=Rot(radians(i*60.0+sin(i)*20.));
        p = abs(p)-0.18;
        p.y+=0.05;
        float d2 = abs(pattern2(p*Rot(0.1*iTime*-(i+1.)),0.007))-0.001;
        d = min(d,d2);
    }
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    vec2 m =  iMouse.xy/iResolution.xy;
    
    vec3 ro = vec3(0, 0, -1.35);
    if(iMouse.z>0.){
        ro.yz *= Rot(m.y*3.14+1.);
        ro.y = max(-0.9,ro.y);
        ro.xz *= Rot(-m.x*6.2831);
    } else {
        ro.yz *= Rot(radians(-5.0));
        ro.xz *= Rot(radians(sin(iTime*0.3)*60.0));
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
        float bd = bg(uv);
        col = mix(col,vec3(0.5),S(bd,0.0));
    }
      

    fragColor = vec4(col,1.0);
}
