#define MAX_STEPS 100
#define MAX_DIST 100.
#define SURF_DIST .0005
#define Rot(a)  mat2(cos(a - vec4(0,11,33,0)))
#define S(d) 1.-smoothstep(-1.2,1.2, (d)*iResolution.y )
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define ZERO (min(iFrame,0))

float Hash21(vec2 p) {
    p = fract(p*vec2(234.56,789.34));
    p+=dot(p,p+34.56);
    return fract(p.x+p.y);
}

float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

float getTime(float t, float duration){
    return clamp(t,0.0,duration)/duration;
}

float getAnimationValue(){
    float easeValue = 0.0;
    float frame = mod(iTime,10.0);
    float time = frame;
    
    float duration = 1.;
    if(frame>=4. && frame<5.){
        time = getTime(time-4.,duration);
        easeValue = cubicInOut(time);
    } else if(frame>=5. && frame<9.){
        easeValue = 1.;
    } else if(frame>=9. && frame<10.){
        time = getTime(time-9.,duration);
        easeValue = 1.0-cubicInOut(time);
    } else {
        easeValue = 0.0;
    }
    
    return easeValue;
}

float layer1_1(vec3 p, float anim){
    float thick = 0.001+(0.05*anim);  
    
    p.xy*=Rot(radians(30.*iTime));
    vec3 prevP = p;
   
    float d = abs(length(p.xy)-0.4)-0.05;
    
    float d2 = abs(length(p.xy)-0.33)-0.05;
    p.xy*=Rot(radians(20.));
    p.x = abs(p.x)-0.23;
    p.y = abs(p.y);
    p.xy*=Rot(radians(-20.));
    d2 = max(p.x,d2);
    d2 = max(-p.y,d2);
    d = max(-d2,d);
    
    p = prevP;
    p.xy*=Rot(radians(10.));
    d2 = abs(length(p.xy)-0.33)-0.05;
    p.x = abs(p.x);
    p.y = abs(p.y)-0.23;
    p.xy*=Rot(radians(20.));
    d2 = max(p.y,d2);
    d2 = max(-p.x,d2);
    d = max(-d2,d);
    
    p = prevP;
    p.xy*=Rot(radians(20.));
    p.x = abs(p.x);
    p.x *= -1.;
    d2 = abs(length(p.xy)-0.47)-0.05;
    p.y = abs(p.y)+0.25;
    p.xy*=Rot(radians(45.));
    d2 = max(p.y,d2);
    d = max(-d2,d);

    p = prevP;
    p.xy*=Rot(radians(-50.));
    p.x = abs(p.x);
    p.x *= -1.;
    d2 = abs(length(p.xy)-0.47)-0.05;
    p.y = abs(p.y)+0.25;
    p.xy*=Rot(radians(45.));
    d2 = max(p.y,d2);
    d = max(-d2,d);

    p = prevP;
    p.xy*=Rot(radians(-25.));
    d2 = abs(length(p.xy)-0.39)-0.008;
    d2 = max(abs(p.x)-0.12,d2);
    d = max(-d2,d);
     
    p = prevP;
    p.xy*=Rot(radians(60.));
    d2 = abs(length(p.xy)-0.38)-0.008;
    d2 = max(abs(p.x)-0.1,d2);
    d = max(-d2,d);     
     
    d = max(abs(p.z)-thick,d);
     
    return d;
}

float layer1_2(vec3 p, float anim){
    float thick = 0.001+(0.02*anim);  
   
    
    p.xy*=Rot(radians(-20.*iTime));
    vec3 prevP = p;
    
    p.xy = DF(p.xy,vec2(18.));
    p.xy -= 0.215;
    p.xy*=Rot(radians(45.));
    float d = B(p.xy,vec2(0.006,0.025));
    
    p = prevP;
    float a = radians(54.);
    p.x = abs(p.x);
    d = max(-dot(p.xy,vec2(cos(a),sin(a))),d);
    a = radians(-54.);
    d = max(-dot(p.xy,vec2(cos(a),sin(a))),d);
    
    d = max(abs(p.z)-thick,d);
    return d;
}

float layer1_3(vec3 p, float anim){
    float thick = 0.001+(0.2*anim);  
    
    p.xy*=Rot(radians(50.*iTime));
    vec3 prevP = p;
    
    float d = abs(length(p.xy)-0.22)-0.03;
    
    p = prevP;
    p.xy*=Rot(radians(80.));
    float a = radians(60.);
    p.x = abs(p.x);
    d = max(-dot(p.xy,vec2(cos(a),sin(a))),d);
    a = radians(-60.);
    d = max(-dot(p.xy,vec2(cos(a),sin(a))),d);
    
    d = max(abs(p.z)-thick,d);
    return d;
}

float layer1_4(vec3 p, float anim){
    float thick = 0.001+(0.03*anim);  
    
    p.xy*=Rot(radians(-10.*iTime));
    vec3 prevP = p;
    
    p.xy = DF(p.xy,vec2(4.));
    p.xy -= 0.12;
    p.xy*=Rot(radians(45.));
    float d = B(p.xy,vec2(0.005));
    
    d = max(abs(p.z)-thick,d);
    return d;
}


float layer1_5(vec3 p, float anim){
    float thick = 0.001+(0.02*anim);  
    
    p.xy*=Rot(radians(40.*iTime));
    vec3 prevP = p;
    
    float d = abs(length(p.xy)-0.12)-0.02;
    
    p = prevP;
    p.xy*=Rot(radians(-20.));
    float a = radians(60.);
    p.x = abs(p.x);
    d = max(-dot(p.xy,vec2(cos(a),sin(a))),d);
    a = radians(-60.);
    d = max(-dot(p.xy,vec2(cos(a),sin(a))),d);
    
    
    p = prevP;
    p.xy*=Rot(radians(-20.));
    float d2 = abs(length(p.xy)-0.1)-0.012;
    p.x = abs(p.x);
    p.y = abs(p.y)-0.085;
    p.xy*=Rot(radians(26.));
    d2 = max(p.y,d2);
    d2 = max(-p.x,d2);
    d = max(-d2,d);
    
    d = max(abs(p.z)-thick,d);
    return d;
}

float layer1(vec3 p){

    
    vec3 prevP = p;
    float anim = getAnimationValue();
    
    float d = layer1_1(p,anim);
    float d2= layer1_2(p,anim);
    d = min(d,d2);
    d2= layer1_3(p,anim);
    d = min(d,d2);
    d2= layer1_4(p,anim);
    d = min(d,d2);
    d2= layer1_5(p,anim);
    d = min(d,d2);
    return d;
}

float arrow_item1(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.1,0.015));
    p.x-=0.025;
    p.y+=0.02;
    float d2 = B(p,vec2(0.05,0.015));
    float a = radians(45.);
    p.x = abs(p.x)-0.04;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    p = prevP;
    
    p.x+=0.025;
    p.y-=0.02;
    d2 = B(p,vec2(0.05,0.015));
    a = radians(-45.);
    p.x = abs(p.x)-0.04;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    p = prevP;
    
    a = radians(45.);
    d = max(-dot(p-vec2(-0.1,0.0),vec2(cos(a),sin(a))),d);

    d = max(dot(p-vec2(0.1,0.0),vec2(cos(a),sin(a))),d);
    
    return d;
}

float layer2_1(vec3 p){
    float thick = 0.001;
    vec3 prevP = p;
    p.x-=iTime*0.1;
    
    p.x = mod(p.x,0.06)-0.03;
    float d = abs(p.x)-0.01;
    
    p = prevP;
    p.x-=iTime*0.1;
    p.x += 0.025;
    p.x = mod(p.x,0.06)-0.03;
    float d2 = abs(p.x)-0.005;
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.05;
    d = max(abs(p.x)-0.4,d);
    d = max(abs(p.y)-0.03,d);

    d = max(abs(p.z)-thick,d);
    return d;
}

float layer2_2(vec3 p){
    float thick = 0.001;
    p.y = abs(p.y)-0.18;
    p.xy *=Rot(radians(90.));
    vec3 prevP = p;

    float d = B(p,vec2(0.03,0.4));
    
    float d2 = B(p,vec2(0.04,0.42));
    
    float a = radians(45.);
    p.y+=0.19;
    d2 = max(-dot(p.xy,vec2(cos(a),sin(a))),d2);
    p = prevP;
    d2 = max(-p.x-0.02,d2);
    d = max(-d2,d);
    
    p = prevP;
    p.y+=0.23;
    d = max(-dot(p.xy,vec2(cos(a),sin(a))),d);
    
    p = prevP;
    p.xy*=Rot(radians(45.));
    p.y+=iTime*0.05;
    p.y = mod(p.y,0.03)-0.015;
    d2 = B(p.xy,vec2(0.4,0.005));
    p = prevP;
    p.x-=0.03;
    p.y+=0.16;
    d2 = max(abs(p.x)-0.02,d2);
    d2 = max(-dot(p.xy,vec2(cos(a),sin(a))),d2);
    d2 = max(abs(p.y)-0.6,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y+=iTime*0.05;
    p.x-=0.1;
    p.y = mod(p.y,0.2)-0.1;
    d2 = B(p.xy,vec2(0.003,0.08));
    p = prevP;
    p.y-=0.1;
    d2 = max(abs(p.y)-0.4,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y-=iTime*0.1;
    p.x+=0.1;
    p.y-=0.05;
    p.y = mod(p.y,0.22)-0.11;
    p.xy*=Rot(radians(90.));
    d2 = arrow_item1(p.xy);
    p = prevP;
    p.y-=0.15;
    d2 = max(abs(p.y)-0.35,d2);
    d = min(d,d2);
    
    p = prevP;
    p.x+=0.17;
    p.xy*=Rot(radians(45.));
    d2 = abs(Tri(p.xy,vec2(0.12)))-0.01;
    float d3 = abs(Tri(p.xy,vec2(0.12)))-0.002;
    p.y+=0.085;
    p.xy*=Rot(radians(30.*iTime+45.));
    d2 = max(-(abs(p.x)-0.02),d2);
    d2 = min(d2,d3);
    d = min(d,d2);
    
    p = prevP;
    p.y-=0.06;
    p.x+=0.17;
    p.xy*=Rot(radians(135.));
    d2 = abs(Tri(p.xy,vec2(0.17)))-0.01;
    d3 = abs(Tri(p.xy,vec2(0.17)))-0.002;
    p.y+=0.1;
    p.xy*=Rot(radians(30.*iTime+45.));
    d2 = max(-(abs(p.x)-0.02),d2);
    d2 = min(d2,d3);
    d = min(d,d2);
    
    p = prevP;
    p.y-=0.35;
    p.x+=0.2;
    p.xy*=Rot(radians(90.));
    d2 = abs(Tri(p.xy,vec2(0.25)))-0.01;
    d3 = abs(Tri(p.xy,vec2(0.25)))-0.002;
    p.y+=0.23;
    p.xy*=Rot(radians(30.*iTime+45.));
    d2 = max(-(abs(p.x)-0.02),d2);
    d2 = min(d2,d3);
    d = min(d,d2);    
    
    p = prevP;
    p.y+=0.29;
    p.x+=0.06;
    p.xy*=Rot(radians(45.));
    p.x = abs(abs(p.x)-0.025)-0.025;
    d2 = length(p.xy)-0.01;
    d = min(d,d2); 
    d2 = abs(length(p.xy)-0.019)-0.001;
    d = min(d,d2); 
    
    d = max(abs(p.z)-thick,d);
    return d;
}

float arrow1(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.1;
    p.x = abs(p.x)-0.05;
    p.y = mod(p.y,0.16)-0.08;
    p *= Rot(radians(45.));
    float d = arrow_item1(p.xy);
    p = prevP;
    p.y-=0.2;
    d = max(abs(p.y)-0.5,d);
    return d;
}

float layer2_3(vec3 p){
    float thick = 0.001;
    vec3 prevP = p;
    p.xy = DF(p.xy,vec2(1.));
    p.xy -=0.5;
    p.xy *=Rot(radians(45.));
    float d = arrow1(p.xy);
    d = max(abs(p.z)-thick,d);
    return d;
}

float layer2(vec3 p){
    vec3 prevP = p;
    
    p.xy *=Rot(radians(45.));
    p.xy = DF(p.xy,vec2(1.));
    p.xy -=0.55;
    p.xy *=Rot(radians(-45.));
    float d = layer2_1(p);
    float d2 = layer2_2(p);
    d = min(d,d2);
    p = prevP;
    d2 = layer2_3(p);
    d = min(d,d2);
    
    return d;
}

vec2 GetDist(vec3 p) {
    vec3 prevP = p;
    float anim = getAnimationValue();
    float r = 1.;
    p.z+=iTime*0.5;
    p.z = mod(p.z,r)-(r*0.5);
    
    float d = layer1(p);
    p = prevP;
    float d2 = layer1(p);
    d = mix(d2,d,anim);
    
    p = prevP;
    d = max(-(p.z+1.2),d);
    d = max((p.z-1.5),d);
    //d = d2;
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
    for( int i=ZERO; i<4; i++ )
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
    vec3 diffCol = vec3(0.0);
    vec3 lightDir = normalize(vec3(1,10,-10));
    float diff = clamp(dot(n,lightDir),0.0,1.0);
    float skyDiff = clamp(0.5+0.5*dot(n,vec3(0,1,0)),0.0,1.0);
    float bounceDiff = clamp(0.5+0.5*dot(n,vec3(0,-1,0)),0.0,1.0);
    diffCol = col*vec3(-0.5)*diff;
    diffCol += col*vec3(1.)*skyDiff;
    diffCol += col*vec3(0.95)*bounceDiff;
    diffCol += col*pow(max(dot(rd, reflect(lightDir, n)), 0.0), 60.); // spec
        
    return diffCol;
}

vec3 materials(int mat, vec3 n, vec3 rd, vec3 p, vec3 col){
    col = diffuseMaterial(n,rd,p,vec3(1.6));
    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    
    vec3 ro = vec3(0, 0, -1.35);    
    vec3 rd = R(uv, ro, vec3(0,0.0,0), 1.0);
    vec2 d = RayMarch(ro, rd, 1.,MAX_STEPS);
    vec3 col = vec3(.0);
    
    if(d.x<MAX_DIST) {
        vec3 p = ro + rd * d.x;
        vec3 n = GetNormal(p);
        int mat = int(d.y);
        col = materials(mat,n,rd,p,col);
        col*=exp( -0.1*d.x*d.x*d.x*d.x );
    } else {
        uv*=1.35;
        float d2 = layer1(vec3(uv,0.0));
        float d3 = layer2(vec3(uv,0.0));
        vec3 uicol = mix(vec3(0.),vec3(0.7),S(d2));
        float anim = getAnimationValue();
        col = mix(uicol,col,anim);
        col = mix(col,vec3(0.7),S(d3));
    }

    fragColor = vec4(sqrt(col),1.0);
}
