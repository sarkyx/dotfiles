#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.5),-antialiasing(1.5),d - b)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define PUV(p) vec2(log(length(p)),atan(p.y/p.x))
#define num_0 0
#define num_1 1
#define num_2 2
#define num_3 3
#define num_4 4
#define num_5 5
#define num_6 6
#define num_7 7
#define num_8 8
#define num_9 9

float updateDist(float d, float div, float dir){
    return cos(d/div+ iTime*5.0*dir);
}

float checkChar(int targetChar, int char){
    return 1.-abs(sign(float(targetChar) - float(char)));
}

float numMask(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.35,0.35));
    p.y=abs(p.y)-0.36;
    float a = radians(-45.);
    float d2 = B(p,vec2(0.1,0.03));
    p.x = abs(p.x)-0.08;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    p = prevP;
    p.x=abs(p.x)-0.36;
    a = radians(-45.);
    d2 = B(p,vec2(0.03,0.1));
    p.y = abs(p.y)-0.08;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    d = max(-d2,d);
    
    p = prevP;
    a = radians(50.);
    p = abs(p)-0.32;

    d = max(dot(p,vec2(cos(a),sin(a))),d);

    return d;
}

float num0(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(-0.05,0.29),vec2(0.12,0.06));
    float a = radians(-45.);
    p*=Rot(radians(-45.));
    p-=vec2(-0.01,0.33);
    float d2 = B(p,vec2(0.15,0.06));
    d2 = max(-B(p-vec2(0.,0.03),vec2(0.06,0.005)),d2);
    d = min(d,d2);
    p = prevP;
    
    p-=vec2(-0.29,0.);
    d2 = B(p,vec2(0.06,0.15));
    d2 = max(-B(p-vec2(0.04,0.02),vec2(0.005,0.09)),d2);
    d = min(d,d2);
    p = prevP;

    p*=Rot(radians(-45.));
    p-=vec2(-0.31,0.035);
    d2 = B(p,vec2(0.06,0.16));
    d = min(d,d2);
    p = prevP;

    p*=Rot(radians(-45.));
    p-=vec2(0.25,0.03);
    d2 = B(p,vec2(0.06,0.22));
    d2 = max(-B(p-vec2(-0.03,-0.03),vec2(0.005,0.1)),d2);
    d = min(d,d2);
    p = prevP;

    p-=vec2(0.29,-0.02);
    d2 = B(p,vec2(0.06,0.105));
    d = min(d,d2);
    p = prevP;

    p*=Rot(radians(45.));
    p-=vec2(0.31,-0.01);
    d2 = B(p,vec2(0.06,0.2));
    d = min(d,d2);
    p = prevP;

    p-=vec2(-0.013,-0.29);
    d2 = B(p,vec2(0.16,0.06));
    d = min(d,d2);
    p = prevP;

    p*=Rot(radians(-45.));
    p-=vec2(-0.23,-0.15);
    d2 = B(p,vec2(0.02,0.22));
    d = max(-d2,d);
    p = prevP;

    p = prevP;
    return max(numMask(p),d);
}

float num1(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(0.29,-0.29),vec2(0.06,0.18));
    
    p-=vec2(0.06,0.08);
    p*=Rot(radians(-50.));
    float d2 = B(p,vec2(0.06,0.6));
    d2 = max(-B(p-vec2(0.04,0.05),vec2(0.005,0.3)),d2);
    d = min(d,d2);
    p = prevP;
    
    p-=vec2(0.1,0.25);
    p*=Rot(radians(-50.));
    d2 = B(p,vec2(0.06,0.45));
    d2 = max(-B(p-vec2(0.04,-0.1),vec2(0.005,0.17)),d2);
    d = min(d,d2);

    p = prevP;
    return max(numMask(p),d);
}

float num2(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(0.11,0.29),vec2(0.24,0.06));
    float a = radians(50.);
    
    p-=vec2(-0.3,0.15);
    p*=Rot(radians(50.));
    float d2 = B(p,vec2(0.06,0.3));
    d2 = max(-B(p-vec2(0.04,0.05),vec2(0.005,0.1)),d2);
    d = min(d,d2);
    p = prevP;

    p-=vec2(0.,0.0);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.6));
    d2 = max(-B(p-vec2(0.04,0.05),vec2(0.005,0.3)),d2);
    d = min(d,d2);
    p = prevP;

    d2 = B(p-vec2(-0.11,-0.29),vec2(0.24,0.06));
    d = min(d,d2);
    p = prevP;
    
    p-=vec2(0.29,-0.15);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.3));
    d2 = max(-B(p-vec2(-0.04,-0.03),vec2(0.005,0.12)),d2);
    d = min(d,d2);
    
    p = prevP;
    return max(numMask(p),d);
}

float num3(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(0.11,0.29),vec2(0.24,0.06));
    
    p-=vec2(-0.3,0.15);
    p*=Rot(radians(50.));
    float d2 = B(p,vec2(0.06,0.3));
    d2 = max(-B(p-vec2(0.04,0.05),vec2(0.005,0.1)),d2);
    d = min(d,d2);
    p = prevP;

    p-=vec2(0.18,0.153);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.4));
    d2 = max(-B(p-vec2(0.04,-0.1),vec2(0.005,0.25)),d2);
    d = min(d,d2);
    p = prevP;

    d2 = B(p-vec2(-0.268,-0.09),vec2(0.18,0.06));
    
    d = min(d,d2);
    p = prevP;
    
    p-=vec2(0.3,-0.15);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.3));
    d = min(d,d2);
    p = prevP;
    
    d2 = B(p-vec2(-0.11,-0.29),vec2(0.24,0.06));
    float a = radians(50.);
    p.y+=0.52;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    d = min(d,d2);
    p = prevP;
    
    d2 = B(p-vec2(0.29,0.06),vec2(0.06,0.2));
    a = radians(-50.);
    p.x-=0.16;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    d = min(d,d2);
    
    p = prevP;
    return max(numMask(p),d);
}

float num4(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(-0.22,-0.06),vec2(0.18,0.06));
    
    p-=vec2(-0.2,0.14);
    p*=Rot(radians(50.));
    float d2 = B(p,vec2(0.06,0.4));
    d2 = max(-B(p-vec2(-0.04,0.1),vec2(0.005,0.1)),d2);
    d = min(d,d2);
    p = prevP;

    p-=vec2(0.228,0.183);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.4));
    d2 = max(-B(p-vec2(0.04,-0.13),vec2(0.005,0.22)),d2);
    d = min(d,d2);
    p = prevP;
    
    d2 = B(p-vec2(-0.18,-0.29),vec2(0.18,0.06));
    d = min(d,d2);
    p = prevP;
    
    p-=vec2(0.119,-0.178);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.4));
    d = min(d,d2);
    p = prevP;    
    
    d2 = B(p-vec2(0.29,-0.19),vec2(0.06,0.18));
    d = min(d,d2);
    
    p = prevP;
    return max(numMask(p),d);
}

float num5(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(-0.05,0.29),vec2(0.29,0.06));
    d = max(-B(p-vec2(0.05,0.25),vec2(0.15,0.005)),d);
    
    p-=vec2(0.29,0.24);
    float d2 = B(p,vec2(0.06,0.12));
    float a = radians(50.);
    p.y+=0.06;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    d = min(d,d2);
    p = prevP;

    p-=vec2(0.,0.0);
    p*=Rot(radians(-50.));
    d2 = B(p,vec2(0.06,0.6));
    d2 = max(-B(p-vec2(-0.04,0.05),vec2(0.005,0.2)),d2);
    d = min(d,d2);
    p = prevP;

    d2 = B(p-vec2(0.11,-0.29),vec2(0.24,0.06));
    d = min(d,d2);
    p = prevP;
    
    p-=vec2(-0.29,-0.15);
    p*=Rot(radians(-50.));
    d2 = B(p,vec2(0.06,0.3));
    d2 = max(-B(p-vec2(0.04,-0.05),vec2(0.005,0.1)),d2);
    d = min(d,d2);
    
    p = prevP;
    return max(numMask(p),d);
}

float num6(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(0.18,0.0),vec2(0.185,0.06));
    float a = radians(50.);
    
    p-=vec2(-0.06,0.15);
    p*=Rot(radians(50.));
    float d2 = B(p,vec2(0.06,0.5));
    d2 = max(-B(p-vec2(-0.04,-0.05),vec2(0.005,0.25)),d2);
    d = min(d,d2);
    p = prevP;

    p-=vec2(-0.198,-0.18);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.303));
    d2 = max(-B(p-vec2(-0.04,0.1),vec2(0.005,0.12)),d2);
    d = min(d,d2);
    p = prevP;

    d2 = B(p-vec2(-0.18,-0.29),vec2(0.24,0.06));
    d = min(d,d2);
    p = prevP;
    
    p-=vec2(0.23,-0.15);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.3));
    d2 = max(-B(p-vec2(0.04,-0.05),vec2(0.005,0.1)),d2);
    d = min(d,d2);
    
    p = prevP;
    return max(numMask(p),d);
}

float num7(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(0.11,0.29),vec2(0.24,0.06));
    
    p-=vec2(-0.3,0.15);
    p*=Rot(radians(50.));
    float d2 = B(p,vec2(0.06,0.3));
    d = min(d,d2);
    p = prevP;

    p-=vec2(0.,0.0);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.6));
    d2 = max(-B(p-vec2(-0.04,-0.05),vec2(0.005,0.3)),d2);
    d = min(d,d2);
    p = prevP;

    d2 = B(p-vec2(-0.17,-0.29),vec2(0.18,0.06));
    float a = radians(-50.);
    p.x-=0.24;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    d = min(d,d2);
    
    p = prevP;
    return max(numMask(p),d);
}

float num8(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(0.11,0.29),vec2(0.24,0.06));
    
    p-=vec2(-0.3,0.15);
    p*=Rot(radians(50.));
    float d2 = B(p,vec2(0.06,0.3));
    d = min(d,d2);
    p = prevP;

    p-=vec2(0.24,0.188);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.3));
    d2 = max(-B(p-vec2(-0.04,-0.12),vec2(0.005,0.1)),d2);
    d = min(d,d2);
    p = prevP;

    d2 = B(p-vec2(-0.18,0.01),vec2(0.23,0.06));
    d = min(d,d2);
    p = prevP;
    
    p-=vec2(0.04,-0.178);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.5));
    d2 = max(-B(p-vec2(-0.04,0.15),vec2(0.005,0.2)),d2);
    d = min(d,d2);
    p = prevP;       
    
    d2 = B(p-vec2(0.14,-0.29),vec2(0.24,0.06));
    d = min(d,d2);
    
    d2 = B(p-vec2(0.29,-0.23),vec2(0.06,0.24));
    d = min(d,d2);
    
    p = prevP;
    return max(numMask(p),d);
}

float num9(vec2 p){
    vec2 prevP = p;
    float d = B(p-vec2(0.11,0.29),vec2(0.24,0.06));
    
    p-=vec2(-0.3,0.15);
    p*=Rot(radians(50.));
    float d2 = B(p,vec2(0.06,0.3));
    d = min(d,d2);
    p = prevP;

    p-=vec2(0.24,0.188);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.3));
    d2 = max(-B(p-vec2(-0.04,-0.12),vec2(0.005,0.1)),d2);
    d = min(d,d2);
    p = prevP;

    d2 = B(p-vec2(-0.18,0.01),vec2(0.23,0.06));
    d = min(d,d2);
    p = prevP;
    
    p-=vec2(0.04,-0.178);
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.06,0.5));
    d2 = max(-B(p-vec2(-0.04,0.08),vec2(0.005,0.2)),d2);
    d = min(d,d2);
    p = prevP;       
    
    p = prevP;
    return max(numMask(p),d);
}


float drawFont(vec2 p, int char){
    //p.x*=0.85;
    //p.y*=1.1;
    float d = num0(p)*checkChar(num_0,char);
    d += num1(p)*checkChar(num_1,char);
    d += num2(p)*checkChar(num_2,char);
    d += num3(p)*checkChar(num_3,char);
    d += num4(p)*checkChar(num_4,char);
    d += num5(p)*checkChar(num_5,char);
    d += num6(p)*checkChar(num_6,char);
    d += num7(p)*checkChar(num_7,char);
    d += num8(p)*checkChar(num_8,char);
    d += num9(p)*checkChar(num_9,char);
    
    return d;
}

float drawNumber(vec2 p){
    vec2 prevP = p;
    p*=2.;
    //p*=SkewX(radians(-30.));
    float d = drawFont(p-vec2(-0.37,0.),int(mod(iTime*3.,10.)));
    float d2 = drawFont(p-vec2(0.37,0.),int(mod(iTime*5.+3.,10.)));
    d = min(d,d2);
    
    p = prevP;
    
    d2 = abs(B(p,vec2(0.4,0.22)))-0.005;
    d2 = max(-(abs(p.x)-0.36),d2);
    d2 = max(-(abs(p.y)-0.18),d2);
    d = min(d,d2);
    
    return d;
}

float arrow(vec2 p){
    float d = Tri(p,vec2(50.));
    p-=vec2(0.,-25.);
    
    float d2 = Tri(p,vec2(50.));
    d = max(-d2,d);
    
    return d;
}

float drawArrow(vec2 p){
    p*=200.;
    p.y-=iTime*20.;
    p.y = mod(p.y,50.)-25.;
    p.y-=25.;
    float d = arrow(p);
    d = updateDist(d,1.,1.);
    
    float mask = arrow(p);
    d = max(mask,d);
    float d2 = abs(arrow(p))-0.5;
    d = min(d,d2);
    return d;
}

float bgArrow(vec2 p){
    vec2 prevP2 = p;
    p.y+=0.06;
    p.y-=iTime*0.1;
    p.y = mod(p.y,0.12)-0.06;
    vec2 prevP = p;
    p.y-=0.05;
    p.x*=1.5;
    float d = Tri(p,vec2(0.012));
    p = prevP;
    float d2 = B(p,vec2(0.001,0.05));
    d = min(d,d2);
    
    /*
    p = prevP2;
    d = max((abs(p.y)-0.05),d);
    */
    return d;
}

float drawBg(vec2 p){
    vec2 prevP = p;
    p.x = mod(p.x,0.24)-0.12;
    p.y = mod(p.y,0.12)-0.06;
    float d = bgArrow(p);
    p = prevP;
    p.x+=0.12;
    p.x = mod(p.x,0.24)-0.12;
    p.y = mod(p.y,0.12)-0.06;
    p.y*=-1.;
    float d2 = bgArrow(p);
    d = min(d,d2);
    p = prevP;
    p.x = mod(p.x,0.12)-0.06;
    p.y = mod(p.y,0.24)-0.12;
    p*=Rot(radians(90.));
    d2 = bgArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.y+=0.12;
    p.x = mod(p.x,0.12)-0.06;
    p.y = mod(p.y,0.24)-0.12;
    p*=Rot(radians(-90.));
    d2 = bgArrow(p);
    d = min(d,d2);
    
    return d;
}

float drawItems(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.2;
    p.y = mod(p.y,0.2)-0.1;
    p*=Rot(radians(45.));
    float d = abs(B(p,vec2(0.02)))-0.003;
    p = prevP;
    
    p.y+=0.1;
    p.y-=iTime*0.2;
    p.y = mod(p.y,0.2)-0.1;
    
    float d2 = min(B(p,vec2(0.003,0.02)),B(p,vec2(0.02,0.003)));
    d = min(d,d2);
    return d;
}

float mainVisual(vec2 p){
    vec2 prevP = p;
    p = PUV(p);
    p*=0.47;
    p.x-=iTime*0.1;
    p = mod(p,0.5)-0.25;
    p*=Rot(radians(90.));
    p.x*=1.5;
    
    float d = drawArrow(p);
    
    p = prevP;
    
    p = DF(p,3.);
    p = abs(p)-0.1;
    p*=Rot(radians(45.));
    float d2 = drawItems(p);
    p = prevP;
    d2 = max(-(abs(p.x)-0.05),d2);
    p*=Rot(radians(60.));
    d2 = max(-(abs(p.x)-0.05),d2);
    p = prevP;
    p*=Rot(radians(-60.));
    d2 = max(-(abs(p.x)-0.05),d2);
    d = min(d,d2);
    
    return d;
}

float uiItem0(vec2 p){
    vec2 prevP = p;
    float d = abs(B(p,vec2(0.05)))-0.003;
    d = max(-(abs(p.x)-0.035),d);
    d = max(-(abs(p.y)-0.035),d);
    p*=Rot(radians(45.));
    float d2 = min(B(p,vec2(0.003,0.04)),B(p,vec2(0.04,0.003)));
    d = min(d,d2);
    return d;
}

float drawUI(vec2 p){
    vec2 prevP = p;
    p.x+=0.6;
    p.y+=0.36;
    float d = uiItem0(p);
    p.x = abs(p.x)-0.12;
    float d2 = uiItem0(p);
    d = min(d,d2);
    
    p = prevP;
    
    p.x-=0.6;
    p.y-=0.36;
    d2 = uiItem0(p);
    d = min(d,d2);
    p.x = abs(p.x)-0.12;
    d2 = uiItem0(p);
    d = min(d,d2);
    
    p = prevP;
    
    p.y = abs(p.y)-0.25;
    p.y*=-1.;
    d2 = Tri(p,vec2(0.02));
    d = min(d,d2);
    
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    vec3 col = vec3(0.0);
    
    float d = drawBg(uv);
    /* // for debug
    d = abs(B(uv,vec2(0.35)))-0.001;
    col = mix(col,vec3(0.8,0.0,0.0),S(d,0.));
    
    uv = mod(uv,0.1)-0.05;
    d = min(abs(uv.x)-0.001,abs(uv.y)-0.001);
    col = mix(col,vec3(0.1),S(d,0.));
    
    uv = prevUV;
    d = drawNumber(uv);
    */

    col = mix(col,vec3(0.3),S(d,0.));
    
    d = mainVisual(uv);
    col = mix(col,vec3(0.5),S(d,0.));
    
    col*=length(uv)-0.1;
    
    d = drawNumber(uv);
    col = mix(col,vec3(1.),S(d,0.));
    
    d = drawUI(uv);
    col = mix(col,vec3(1.),S(d,0.));
    
    fragColor = vec4(sqrt(col),1.0);
}
