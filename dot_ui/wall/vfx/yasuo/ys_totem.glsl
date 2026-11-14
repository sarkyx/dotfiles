#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.0),b,d)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define Tri(p,s,a) max(-dot(p,vec2(cos(-a),sin(-a))),max(dot(p,vec2(cos(a),sin(a))),max(abs(p).x-s.x,abs(p).y-s.y)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define SkewX(a) mat2(1.0,tan(a),0.0,1.0)
#define SkewY(a) mat2(1.0,0.0,tan(a),1.0)
#define PI 3.14159265
//#define REACT_SOUND

float Hash21(vec2 p) {
    p = fract(p*vec2(234.56,789.34));
    p+=dot(p,p+34.56);
    return fract(p.x+p.y);
}

float SimpleVesicaDistanceY(vec2 p, float r, float d) {
    p.x = abs(p.x);
    p.x+=d;
    return length(p)-r;
}

float circleItem0(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(30.+iTime*20.));
    float d = abs(length(p)-0.04)-0.01;
    d = max(-(abs(p.x)-0.015),d);
    return abs(d)-0.003;
}

float circleItem1(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(35.-iTime*20.));
    float d = abs(length(p)-0.04)-0.01;
    float mask = max(-p.x,d);
    d = abs(mask)-0.003;
    p = prevP;
    float d2 = abs(length(p)-0.04)-0.001;
    d2 = max(-mask,d2);
    d = min(d,d2);
    return d;
}

float circleItem2(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(iTime*25.));
    float d = abs(length(p)-0.05)-0.015;
    p=DF(p,1.);
    p-=vec2(0.1);
    p*=Rot(radians(45.));
    float d2 = B(p,vec2(0.01,0.2));
    d = max(-d2,d);
    
    return abs(d)-0.003;
}

float circleItem3(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(iTime*20.));
    p=DF(p,2.);
    p-=vec2(0.03);
    p*=Rot(radians(20.));
    float d = B(p,vec2(0.005,0.02));
    float a = radians(-45.);
    p.y-=0.006;
    d = max(-dot(p,vec2(cos(a),sin(a))),d);
    return d;
}

float nose(vec2 p, float y){
    vec2 prevP = p;
    p.y*=0.4;
    float d = Tri(p,vec2(0.04),radians(-45.));
    p = prevP;
    p.y-=y;
    float d2 = Tri(p,vec2(0.04),radians(45.));
    d = min(d,d2);
    return d;
}

float body0(vec2 p){
    vec2 prevP = p;
    p.x = abs(p.x)-0.08;
    float d = circleItem0(p);
    p = prevP;
    
    p.y+=0.17;
    float d2 = nose(p,0.14);
    p.y-=0.022;
    d2 = max(-nose(p*1.3,0.137),d2);
    d = min(d,d2);
    
    p = prevP;
    p.y+=0.12;
    p.x = abs(p.x)-0.09;
    p*=SkewY(radians(-30.));
    d2 = B(p,vec2(0.03,0.04));
    d2 = max(-(abs(p.y)-0.01),d2);
    d = min(d,abs(d2)-0.003);
    
    return d;
}

float arrow0(vec2 p){
    vec2 prevP = p;
    
    p.y+=iTime*0.05;
    p.y = mod(p.y,0.06)-0.03;
    p.y+=0.025;
    float d = abs(Tri(p,vec2(0.04),radians(-45.)))-0.005;
    p = prevP;
    float d2 = Tri(p,vec2(0.05),radians(-45.));
    
    d = max(d2,d);
    
    return d;
}

float arrow1(vec2 p){
    vec2 prevP = p;
    
    p.x+=iTime*0.05;
    p.x = mod(p.x,0.06)-0.03;
    p.x+=0.025;
    p*=Rot(radians(90.));
    p.x*=3.;
    float d = Tri(p,vec2(0.04),radians(-45.));
    p = prevP;
    p*=Rot(radians(90.));
    p.x*=3.;
    float d2 = Tri(p,vec2(0.04),radians(-45.));
    d = max(d2,d);
    
    return d;
}

float arrow2(vec2 p){
    vec2 prevP = p;
    
    p.y+=iTime*0.05;
    p.y = mod(p.y,0.1)-0.05;
    p.y+=0.045;
    
    float d = Tri(p,vec2(0.065),radians(-45.));
    float d2 = Tri(p-vec2(0.0,0.035),vec2(0.05),radians(-45.));
    p = prevP;
    float mask = Tri(p-vec2(0.0,-0.01),vec2(0.09),radians(-45.));
    
    d = abs(max(-d2,d))-0.003;
    
    d = max(mask,d);
    
    return d;
}

float arrow3(vec2 p){
    vec2 prevP = p;
    
    p.y+=iTime*0.05;
    p.y = mod(p.y,0.06)-0.03;
    p.y+=0.025;
    p.x*=3.;
    float d = Tri(p,vec2(0.04),radians(-45.));
    p = prevP;
    p.x*=3.;
    float d2 = Tri(p,vec2(0.05),radians(-45.));
    
    d = max(d2,d);
    
    return d;
}

float body1(vec2 p){
    vec2 prevP = p;
    
    p = abs(p)-vec2(0.035,0.03);
    p*=Rot(radians(50.));
    float d = B(p,vec2(0.01,0.07));
    p.y-=0.12;
    p*=vec2(1.5,0.8);
    float d2 = Tri(p,vec2(0.04),radians(45.));
    d = min(d,d2);
    
    p = prevP;
    p.y = abs(p.y)-0.05;
    d2 = arrow0(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.07;
    p*=Rot(radians(90.));
    d2 = arrow0(p);
    d = min(d,d2);
    
    return d;
}

float rectFractal(vec2 p){
    vec2 prevP = p;
    p*=20.;
    p.y+=iTime*0.5;
    vec2 id = floor(p);
    vec2 gv = fract(p)-0.5;
    
    float n = Hash21(id);
    
    float w = 0.1;
    if(n<0.5 || n>=0.8){
        float dir = (n>=0.8)?1.0:-1.0;
        gv*=Rot(radians(dir*45.0));
        gv.x = abs(gv.x);
        gv.x-=0.355;
    } else {
        w = 0.135;
    }
    
    float d = B(gv,vec2(w,1.));
    return d;
}

float body2(vec2 p){
    vec2 prevP = p;
    float d = abs(B(p,vec2(0.12,0.1)))-0.003;
    d = max(-(abs(p.x)-0.08),d);
    d = max(-(abs(p.y)-0.07),d);
    float mask = B(p,vec2(0.115,0.09));

    float d2 = 10.;
    for(float i = 0.; i<4.; i++){
        p*=Rot(radians(i*50.0+sin(i)*20.));
        p = abs(p)-0.18;
        p.y+=0.05;
        float d3 = rectFractal(p*Rot(0.1*iTime*-(i+1.)));
        d2 = min(d,d3);
    }
    
    d2 = max(mask,d2);
    d = min(d,d2);
    return d;
}

float body3(vec2 p){
    vec2 prevP = p;
    p.y+=0.04;
    p.x*=0.4;
    float d = Tri(p,vec2(0.1),radians(-45.));
    float mask = d;
    d = abs(d)-0.003;
    p = prevP;
    p.x = abs(p.x)-0.08;
    float d2 = length(p)-0.065;
    d = max(-d2,d);
    d2 = circleItem1(p);
    d = min(d,d2);
    p = prevP;
    
    p.y+=0.07;
    p.y*=2.5;
    d2 = Tri(p,vec2(0.1),radians(45.));
    mask = d2;
    d = min(d,abs(d2)-0.008);
    p = prevP;
    
    p.y-=iTime*0.02;
    p = mod(p,0.02)-0.01;
    float thickness = 0.001;
    d2 = min(abs(p.x)-thickness,abs(p.y)-thickness);
    d2 = max(mask,d2);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.07;
    p.y+=0.075;
    d2 = arrow1(p);
    d = min(d,d2);
    
    return d;
}

float leg(vec2 p){
    p.x = abs(p.x)-0.11;
    vec2 prevP = p;
    
    float d = B(p,vec2(0.1,0.02));
    float a = radians(45.);
    p.x-=0.08;
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    
    p = prevP;
    p.x-=0.03;
    p.y+=0.04;
    float d2 = B(p,vec2(0.04));
    p.x = abs(p.x)-0.06;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    
    p = prevP;
    p.x+=0.04;
    p.y-=0.04;
    a = radians(-45.);
    d2 = B(p,vec2(0.04));
    p.x = abs(p.x)-0.06;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    
    p = prevP;
    p.x+=0.09;
    a = radians(45.);
    d = max(-dot(p,vec2(cos(a),sin(a))),d);
    
    return d;
}

float wing(vec2 p){
    p.x = abs(p.x)-0.22;
    vec2 prevP = p;
    p.y-=0.05;
    float d = circleItem2(p);
    p = prevP;
    p.y+=0.13;
    float d2 = arrow2(p);
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.105;
    p.y-=0.02;
    d2 = B(p,vec2(0.02,0.1));
    
    float a = radians(-45.);
    p.y+=0.05;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    
    p.y-=0.055;

    p.x+=0.02;
    float d3 = B(p,vec2(0.02,0.05));
    a = radians(45.);

    p.y=abs(p.y)-0.05;
    d3 = max(dot(p,vec2(cos(a),sin(a))),d3);
    d2 = max(-d3,d2);
    
    a = radians(-45.);
    p.y-=0.02;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    
    d = min(d,d2);
    
    p = prevP;
    p.y+=iTime*0.1;
    p.y+=0.024;
    p.x-=0.16;
    p.y-=0.11;
    
    p.y = mod(p.y,0.1)-0.05;
    p.y+=0.03;
    d2 = length(p)-0.01;

    p.y-=0.05;
    d3 = length(p)-0.015;
    d2 = min(d2,d3);
    
    p = prevP;
    p.x-=0.16;
    p.y-=0.055;
    d2 = max((abs(p.y)-0.065),d2);
    
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.24;
    p.y-=0.065;
    d2 = circleItem3(p);
    
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.32;
    p.y-=0.065;
    d2 = arrow3(p);
    d = min(d,d2);
    
    return d;
}

float flower(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(90.));
    p = DF(p,1.5);
    p = abs(p)-0.065;
    p*=Rot(radians(45.));
    float d = SimpleVesicaDistanceY(p,0.15,0.12);
    return d;
}

float bg(vec2 p){
    p*=1.5;
    p.y-=iTime*0.1;
    vec2 prevP = p;
    p.x = mod(p.x,0.32)-0.16;
    p.y = mod(p.y,0.2)-0.1;
    float d = flower(p);
    p = prevP;
    
    p.x+=0.16;
    p.y+=0.1;
    p.x = mod(p.x,0.32)-0.16;
    p.y = mod(p.y,0.2)-0.1;
    float d2 = flower(p);
    
    d = min(d,d2);
    
    return abs(d)-0.001;
}

float bodyMask(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.14,0.4));
    p.x = abs(p.x)-0.08;
    float d2 = length(p-vec2(0.0,0.43))-0.07;
    d = min(d,d2);
    p = prevP;
    
    p.x = abs(p.x)-0.11;
    p.y+=0.45;
    d2 = B(p,vec2(0.15,0.05));
    float a = radians(45.);
    p.x-=0.12;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    d = min(d,d2);
    
    p = prevP;
    p.x*=0.5;
    p.y+=0.375;
    d2 = Tri(p,vec2(0.16),radians(-45.));    
    d = min(d,d2);
    
    p = prevP;
    p.x*=0.6;
    p.y+=0.155;
    d2 = Tri(p,vec2(0.42),radians(-45.)); 
    p = prevP;
    d2 = max(abs(p.x)-0.57,d2);
    d = min(d,d2);
    
    return d;
}

float smallCircle(vec2 p, float s){
    
    vec2 prevP = p;
    
    p*=Rot(radians(45.-iTime*40.));
    float d = abs(length(p)-s)-0.001;
    
    p = DF(p,2.);
    p = abs(p)-0.01;
    p*=Rot(radians(45.));
    float mask = B(p,vec2(0.02,0.1));
    d = max(-mask,d);
    
    p = prevP;
    p*=Rot(radians(iTime*30.));
    p.y=abs(p.y)-0.05;
    float d2 = B(p,vec2(0.001,0.01));
    d = min(d,d2);
    d2 = B(p,vec2(0.01,0.001));
    d = min(d,d2);
    
    p = prevP;
    d2 = length(p)-0.005;
    d = min(d,d2);
    return d;
}

float ring(vec2 p){
    vec2 prevP = p;
    float len = 0.4;
    float d = abs(length(p)-len)-0.001;
    
    p*=Rot(radians(-45.-iTime*20.));
    p.x = abs(p.x)-len;
    float s = 0.08;
    float d2 = smallCircle(p,s);
    d = max(-(length(p)-s),d);
    d = min(d,d2);
    
    p = prevP;
    p*=Rot(radians(-25.-iTime*20.));
    p.x = abs(p.x)-len;
    d2 = length(p)-0.03;
    d = max(-d2,d);
    d = min(d,abs(d2)-0.001);
    
    p = prevP;
    p*=Rot(radians(-13.-iTime*20.));
    p.x = abs(p.x)-len;
    d2 = length(p)-0.02;
    d = max(-d2,d);
    d = min(d,abs(d2)-0.001);
    
    p = prevP;
    p = abs(p)-vec2(0.47,0.4);
    p*=Rot(radians(45.+-iTime*25.));
    d2 = abs(length(p)-0.07)-0.005;
    d2 = max(-(abs(p.x)-0.02),d2);
    
    float d3 = abs(length(p)-0.03)-0.003;
    d = min(d,d2);
    d = min(d,d3);
    
    p = prevP;
    
    #ifdef REACT_SOUND
    p.x = abs(p.x);
    float a  = atan(p.y / p.x) / (PI * 8.) + 0.5; 
    float r= texture(iChannel0,vec2(a, 0.5)).r;
    
    p = prevP;
    d2 = abs(length(p)-(0.27+r*0.1))-0.001;
    d = min(d,d2);
    #endif
    
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    vec2 prevP = p;
    
    vec3 col = vec3(0.);

    float d = bg(p);
    col = mix(col,vec3(0.3),S(d,0.));
    
    d = bodyMask(p);
    float mask = d;
    col = mix(col,vec3(0.0),S(d,0.));
    
    d = ring(p);
    d = max(-mask,d);
    col = mix(col,vec3(1.0),S(d,0.));
    
    d = body0(p-vec2(0.0,0.43));
    col = mix(col,vec3(1.),S(d,0.));
    
    d = body1(p-vec2(0.0,0.13));
    col = mix(col,vec3(1.),S(d,0.));
    
    d = body2(p-vec2(0.0,-0.1));
    col = mix(col,vec3(1.),S(d,0.));
        
    d = body3(p-vec2(0.0,-0.29));
    col = mix(col,vec3(1.),S(d,0.));
    
    d = leg(p-vec2(0.0,-0.45));
    col = mix(col,vec3(1.),S(d,0.));
    
    d = wing(p-vec2(0.0,0.13));
    col = mix(col,vec3(1.),S(d,0.));
    
    fragColor = vec4(col,1.0);
}
