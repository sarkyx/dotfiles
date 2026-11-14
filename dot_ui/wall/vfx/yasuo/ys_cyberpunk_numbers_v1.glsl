#define MAX_STEPS 64
#define MAX_DIST 64.
#define SURF_DIST .0005
#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.5),-antialiasing(1.5),d - b)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define PUV(p) vec2(log(length(p)),atan(p.y/p.x))
#define SUV(p) vec2(atan(p.x,p.z),acos(p.y))
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

float random (vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

float Hash21(vec2 p) {
    p = fract(p*vec2(234.56,789.34));
    p+=dot(p,p+34.56);
    return fract(p.x+p.y);
}

float checkChar(int targetChar, int char){
    return 1.-abs(sign(float(targetChar) - float(char)));
}

float numMaskItemX0(vec2 p, vec2 s, float dist, float deg){
    vec2 prevP = p;
    float a = radians(deg);
    float d = B(p,s);
    p.x = abs(p.x)-dist;
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    return d;
}

float numMaskItemY0(vec2 p, vec2 s, float dist, float deg){
    vec2 prevP = p;
    float a = radians(deg);
    float d = B(p,s);
    p.y = abs(p.y)-dist;
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    return d;
}

float numRectMaskItem0(vec2 p){
    vec2 prevP = p;
    float size = 0.008;
    p.x = abs(p.x)-0.014;
    float d = B(p,vec2(size));
    p.y = abs(p.y)-0.027;
    float d2 = B(p,vec2(size));
    d = min(d,d2);
    return d;
}

float numRectMaskItem1(vec2 p){
    vec2 prevP = p;
    float size = 0.005;
    float a = radians(20.);
    
    p*=Rot(a);
    float d = abs(p.x)-size;
    p.x = abs(p.x)-(size+0.015);
    float d2 = abs(p.x)-size;
    d = min(d,d2);
    p = prevP;
    d = max(abs(p.y)-0.02,d);
    return d;
}

float numMask(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.35,0.35));
    p.y=abs(p.y)-0.36;
    float a = radians(-45.);
    float d2 = numMaskItemX0(p,vec2(0.1,0.03),0.08,-45.);
    d = max(-d2,d);
    
    p = prevP;
    p.x=abs(p.x)-0.36;
    d2 = numMaskItemY0(p,vec2(0.03,0.1),0.08,-225.);
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
    d2 = numMaskItemX0(p-vec2(-0.097,0.225),vec2(0.1,0.03),0.06,45.);
    d = max(-d2,d);

    d2 = numMaskItemY0(p-vec2(0.22,-0.073),vec2(0.03,0.1),0.06,45.);
    d = max(-d2,d);

    p*=Rot(radians(45.));
    d2 = numMaskItemY0(p-vec2(0.24,-0.025),vec2(0.03,0.1),0.06,45.);
    d = max(-d2,d);

    p = prevP;
    d2 = numMaskItemX0(p-vec2(0.05,-0.225),vec2(0.1,0.03),0.08,-45.);
    d = max(-d2,d);

    p*=Rot(radians(45.));
    d2 = numMaskItemY0(p-vec2(0.38,0.0),vec2(0.03,0.1),0.08,-225.);
    d = max(-d2,d);

    p = prevP;
    p*=Rot(radians(-45.));
    d2 = numMaskItemY0(p-vec2(-0.24,-0.03),vec2(0.03,0.1),0.08,-225.);
    d = max(-d2,d);

    p = prevP;
    p*=Rot(radians(-45.));
    d2 = numRectMaskItem0(p-vec2(-0.32,-0.1));
    d = max(-d2,d);

    p = prevP;
    p*=Rot(radians(45.));
    d2 = numRectMaskItem0(p-vec2(0.31,0.1));
    d = max(-d2,d);
    
    p = prevP;
    p*=Rot(radians(90.));
    d2 = numRectMaskItem0(p-vec2(-0.28,0.05));
    d = max(-d2,d);
    
    p = prevP;
    d2 = numRectMaskItem1(p-vec2(0.12,-0.3));
    d = max(-d2,d);
    
    p.x = abs(p.x)-0.29;
    p*=Rot(radians(-90.));
    d2 = Tri(p,vec2(0.02));
    d = max(-d2,d);
    
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
    p*=Rot(radians(40.));
    p.x+=0.1;
    p.x = abs(p.x)-0.15;
    d2 = numMaskItemX0(p-vec2(0.0,0.03),vec2(0.12,0.03),0.1,45.);
    d = max(-d2,d);

    p = prevP;
    d2 = numRectMaskItem0(p-vec2(0.29,-0.22));
    d = max(-d2,d);
    
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
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p-vec2(-0.05,0.065),vec2(0.18,0.03),0.15,-45.);
    d = max(-d2,d);    
    
    p = prevP;
    p-=vec2(-0.28,-0.23);
    p*=Rot(radians(50.));
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);
    
    p = prevP;
    p-=vec2(0.24,0.29);
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);    
    
    p = prevP;
    d2 = numRectMaskItem1(p-vec2(0.01,-0.28));
    d = max(-d2,d);
    
    p = prevP;
    d2 = numRectMaskItem1(p-vec2(-0.01,0.28));
    d = max(-d2,d);    
    
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
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p-vec2(0.05,0.065),vec2(0.12,0.03),0.1,-45.);
    d = max(-d2,d);    
    
    p = prevP;
    d2 = numMaskItemX0(p-vec2(-0.1,-0.225),vec2(0.15,0.03),0.12,-45.);
    d = max(-d2,d);   
    
    p = prevP;
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p-vec2(0.03,-0.37),vec2(0.1,0.03),0.08,45.);
    d = max(-d2,d);       
    
    p = prevP;
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p-vec2(-0.03,0.37),vec2(0.1,0.03),0.08,-45.);
    d = max(-d2,d);         
    
    p = prevP;
    p-=vec2(0.24,0.29);
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);    
    
    p = prevP;
    p-=vec2(-0.24,-0.09);
    p*=Rot(radians(90.));
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);   
    
    p = prevP;
    d2 = numRectMaskItem1(p-vec2(0.01,-0.295));
    d = max(-d2,d);
    
    p = prevP;
    d2 = numRectMaskItem1(p-vec2(-0.01,0.28));
    d = max(-d2,d);        
    
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
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p-vec2(0.17,0.065),vec2(0.15,0.03),0.13,-45.);
    d = max(-d2,d);    
    
    d2 = numMaskItemX0(p-vec2(0.02,-0.14),vec2(0.1,0.03),0.08,-45.);
    d = max(-d2,d); 
    
    p = prevP;
    d2 = numMaskItemX0(p-vec2(-0.2,-0.22),vec2(0.12,0.03),0.1,-45.);
    d = max(-d2,d);       
    
    p = prevP;
    d2 = numRectMaskItem1(p-vec2(-0.01,-0.28));
    d = max(-d2,d);       
    
    p = prevP;
    p-=vec2(-0.25,-0.06);
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(-0.2,-0.3);
    p*=Rot(radians(90.));
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);        
    
    p = prevP;
    p-=vec2(0.29,-0.25);
    p*=Rot(radians(90.));
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);       
    
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
    p*=Rot(radians(40.));
    d2 = numMaskItemX0(p-vec2(0.1,0.065),vec2(0.17,0.03),0.15,-45.);
    d = max(-d2,d);    
    
    p = prevP;
    d2 = numMaskItemX0(p-vec2(0.04,-0.225),vec2(0.1,0.03),0.07,-45.);
    d = max(-d2,d);     
    
    p = prevP;
    p*=Rot(radians(40.));
    d2 = numMaskItemX0(p-vec2(-0.02,-0.365),vec2(0.12,0.03),0.1,45.);
    d = max(-d2,d);        
    
    p = prevP;
    p-=vec2(-0.26,0.27);
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(0.26,-0.27);
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);     
    
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
    p-=vec2(-0.02,0.1);
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p,vec2(0.15,0.03),0.13,45.);
    d = max(-d2,d);  
    
    p = prevP;
    p-=vec2(0.16,0.07);
    d2 = numMaskItemX0(p,vec2(0.12,0.03),0.1,-45.);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(0.01,-0.285);
    d2 = numRectMaskItem1(p);
    d = max(-d2,d);        
    
    p = prevP;
    p-=vec2(-0.27,-0.24);
    p*=Rot(radians(50.));
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(0.16,-0.01);
    p*=Rot(radians(90.));
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);        
    
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
    p-=vec2(0.07,-0.02);
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p,vec2(0.17,0.03),0.15,45.);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(-0.21,0.14);
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p,vec2(0.1,0.03),0.08,45.);
    d = max(-d2,d);  
    
    p = prevP;
    p-=vec2(-0.25,0.28);
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p,vec2(0.1,0.03),0.08,-45.);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(-0.01,0.285);
    d2 = numRectMaskItem1(p);
    d = max(-d2,d);        
    
    p = prevP;
    p-=vec2(-0.27,-0.24);
    p*=Rot(radians(50.));
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(0.23,0.29);
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);    
    
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
    p-=vec2(-0.26,0.27);
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p,vec2(0.1,0.03),0.08,-45.);
    d = max(-d2,d);        
    
    p = prevP;
    p-=vec2(-0.14,-0.24);
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p,vec2(0.1,0.03),0.08,-45.);
    d = max(-d2,d);     
        
    p = prevP;
    p-=vec2(-0.15,-0.055);
    d2 = numMaskItemX0(p,vec2(0.12,0.03),0.1,45.);
    d = max(-d2,d);    
    
    p = prevP;
    p-=vec2(-0.01,0.285);
    d2 = numRectMaskItem1(p);
    d = max(-d2,d);        
    
    p = prevP;
    p-=vec2(0.01,-0.285);
    d2 = numRectMaskItem1(p);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(0.29,-0.19);
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(0.23,0.29);
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);        
    
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
    p-=vec2(-0.26,0.27);
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p,vec2(0.1,0.03),0.08,-45.);
    d = max(-d2,d);        
    
    p = prevP;
    p-=vec2(0.15,-0.17);
    p*=Rot(radians(-40.));
    d2 = numMaskItemX0(p,vec2(0.17,0.03),0.15,45.);
    d = max(-d2,d);     
        
    p = prevP;
    p-=vec2(-0.15,-0.055);
    d2 = numMaskItemX0(p,vec2(0.12,0.03),0.1,45.);
    d = max(-d2,d);        
    
    p = prevP;
    p-=vec2(-0.01,0.285);
    d2 = numRectMaskItem1(p);
    d = max(-d2,d);           
    
    p = prevP;
    p-=vec2(-0.1,-0.29);
    p*=Rot(radians(50.));
    d2 = numRectMaskItem0(p);
    d = max(-d2,d);      
    
    p = prevP;
    p-=vec2(0.23,0.29);
    d2 = numRectMaskItem0(p);
    d = max(-d2,d); 
    
    p = prevP;
    return max(numMask(p),d);
}

float drawFont(vec2 p, int char){
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

float drawNumber(vec2 p, float n){
    vec2 prevP = p;
    p*=0.4;
    float d = drawFont(p,int(mod(3.*iTime*n+(n*10.),10.)));
    return d;
}


vec2 GetDist(vec3 p) {
    
    vec3 prevP = p;
    
    p.y+=1.1;
    p.y-=0.5*iTime;
    vec2 id = floor(p.xy*0.5);
    
    p.xy = mod(p.xy,2.0)-1.0;
    
    vec2 randP = fract(sin(id*123.456)*567.89);
    randP += dot(randP,randP*34.56);
    float n = fract(randP.x*randP.y);
    
    float t = iTime*2.;
    float d = drawNumber(p.xy,n);
    p = prevP;
    p.z-=3.5;
    d = max((abs(p.z)-0.08),d);
    
    p = prevP;
    
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

float stripeRect(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(45.));
    p.x+=iTime*0.1;
    p.x = mod(p.x,0.1)-0.05;
    
    float d = B(p,vec2(0.03,1.));
    p = prevP;
    d = max(B(p,vec2(0.43)),d);
    return d;
}

float plus(vec2 p){
    return min(B(p,vec2(0.001,0.05)),B(p,vec2(0.05,0.001)));
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    
    vec3 ro = vec3(0., 0, -1.35);
    vec3 rd = R(uv, ro, vec3(0,0.0,0), 1.0);
    vec2 d = RayMarch(ro, rd, 1.,MAX_STEPS);
    vec3 col = vec3(0.0);
    
    if(d.x<MAX_DIST) {
        vec3 p = ro + rd * d.x;
        vec3 n = GetNormal(p);
        int mat = int(d.y);
        col = materials(mat,n,rd,p,col);
    } else {
        prevUV.y+=1.07;
        uv = prevUV;
        uv.y-=0.105*iTime;
        uv-=vec2(0.21);
        uv = mod(uv,0.42)-0.21;
        float d = min(abs(uv.x)-0.0005,abs(uv.y)-0.0005);
        col = mix(col,vec3(0.03),S(d,0.));
        uv = prevUV;
        
        uv.y-=0.105*iTime;
        uv*=1.19*2.;
        
        vec2 gv = fract(uv)-0.5;
        vec2 id = floor(uv);
        float n = random(id);
        if(n<0.3){
            d = stripeRect(gv);
            col = mix(col,vec3(0.05),S(d,0.));
        } else if (n>=0.3 && n<0.6){
            gv*=Rot(radians(45.));
            d = min(B(gv,vec2(0.001,0.6)),B(gv,vec2(0.6,0.001)));
            col = mix(col,vec3(0.15),S(d,0.));
        }
        
        uv = prevUV;
        uv.y-=0.105*iTime;
        uv-=vec2(0.21);
        uv*=1.19*2.;
        gv = fract(uv)-0.5;
        d = plus(gv);
        col = mix(col,vec3(1.),S(d,0.));
    }
    
    // Output to screen
    fragColor = vec4(sqrt(col),1.0);
}
