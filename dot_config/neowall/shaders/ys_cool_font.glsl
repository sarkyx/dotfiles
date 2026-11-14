#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.5),-antialiasing(1.5),d - b)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define SkewX(a) mat2(1.0,tan(a),0.0,1.0)
#define SkewY(a) mat2(1.0,0.0,tan(a),1.0)
#define LINE_THICK 0.005
#define char_A 10
#define char_B 11
#define char_C 12
#define char_D 13
#define char_E 14
#define char_F 15
#define char_G 16
#define char_H 17
#define char_I 18
#define char_J 19
#define char_K 20
#define char_L 21
#define char_M 22
#define char_N 23
#define char_O 24
#define char_P 25
#define char_Q 26
#define char_R 27
#define char_S 28
#define char_T 29
#define char_U 30
#define char_V 31
#define char_W 32
#define char_X 33
#define char_Y 34
#define char_Z 35

float random (vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

float coolFontBase(vec2 p){    
    float d = abs(p.x)-LINE_THICK;
    p.x = abs(p.x)-0.1;
    float d2 = abs(p.x)-LINE_THICK;
    d = min(d,d2);
    d = max(abs(p.y)-0.15,d);
    d = max(-(abs(p.y)-0.05),d);
    return d;
}

float coolArrow(vec2 p){
    float a = radians(-45.);
    float d = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    a = radians(45.);
    float d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d = min(d,d2);
    return d;
}

float coolA(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    p = prevP;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(p.y+0.05,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolB(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x += 0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    
    p = prevP;
    float a = radians(-45.);
    p.y = abs(p.y)+0.05;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolC(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x += 0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    
    p = prevP;
    float a = radians(-60.);
    p.y = abs(p.y)+LINE_THICK;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d = min(d,d2);
    
    p = prevP;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.1,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolD(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    p = prevP;
    d2 = max(-p.x,d2);
    d = min(d,d2);
    p.x+=0.1;
    d2 = abs(p.x)-LINE_THICK;
    d = min(d,d2);
    p = prevP;
    p.y=abs(p.y)-0.25+LINE_THICK;
    d2 = abs(p.y)-LINE_THICK;
    d2 = max(p.x-LINE_THICK,d2);
    d = min(d,d2);
    p = prevP;
    
    p = prevP;
    p.x = abs(p.x)-0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.1,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolE(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    float a = radians(45.);
    p.y = abs(p.y)+0.05;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.05;
    d2 = coolArrow(p);
    d2 = max(-prevP.x-LINE_THICK,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolF(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y-=0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x += 0.1;
    p.y+=0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.2,d2);
    d = min(d,d2);
    
    p = prevP;
    float a = radians(-45.);
    p.y+=0.15;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d2 = max(p.y-LINE_THICK,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = min(p.x-LINE_THICK,-p.y);
    d = max(d2,d);
    
    p = prevP;
    a = radians(-45.);
    p.y+=0.05;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d2 = max(-prevP.x-LINE_THICK,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y-=0.05+LINE_THICK;
    d2 = abs(p.y)-LINE_THICK;
    d2 = max(-p.x-LINE_THICK,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolG(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x += 0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    
    p = prevP;
    float a = radians(-60.);
    p.y += LINE_THICK;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d2 = max(-prevP.x,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.1,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y+=0.15;
    d2 = min(p.x,-p.y);
    d = max(d2,d);    
    
    p = prevP;
    p.x -= 0.1;
    p.y+=0.15;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.1,d2);
    d = min(d,d2);    
    
    p = prevP;
    
    p.y+=0.15-LINE_THICK;
    p.y = abs(p.y)-0.1;
    d2 = abs(p.y)-LINE_THICK;
    d2 = max(-p.x-LINE_THICK,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolH(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    p = prevP;
    
    d2 = abs(p.x)-LINE_THICK;
    
    d2 = max(-(abs(p.y)-0.05),d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolI(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.05;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.2,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = min(-(abs(p.x)-0.01),-(abs(p.y)-0.16));
    d = max(d2,d);
    
    p = prevP;
    return max(abs(p.x)-0.05-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolJ(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    p = prevP;
    p.y-=0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.16,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = min(-p.x-LINE_THICK,p.y+0.05);
    d = max(d2,d);    
    
    p = prevP;
    float a = radians(-45.);
    p.y-=0.05;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d2 = max(prevP.x,d2);
    d = min(d,d2);    
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolK(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x += 0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(-(abs(p.y)-0.05),d2);
    d = min(d,d2);
    
    p = prevP;
    float a = radians(-45.);
    p.y = abs(p.y)+0.05;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolL(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    d = max(p.x-LINE_THICK,d);
    d = max(-p.y-0.14,d);
    
    p.x += 0.1;
    p.y+=0.1;
    float d2 = abs(p.x)-LINE_THICK;
    d = min(d,d2);
    
    p = prevP;
    float a = radians(45.);
    p.y-=0.15;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d2 = max(prevP.x-LINE_THICK,d2);
    d = min(d,d2);
    
    p = prevP;
    a = radians(45.);
    p.y+=0.14;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d2 = max(-prevP.x-LINE_THICK,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y+=0.25-LINE_THICK;
    d2 = abs(p.y)-LINE_THICK;
    d = min(d,d2);
    
    p = prevP;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max((abs(p.y)-0.06),d2);
    d = min(d,d2);    
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolM(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    d = max(p.y,d);
    p.y+=0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    p = prevP;
    p.y-=0.15;
    d2 = coolArrow(p);
    d2 = max(-p.y,d2);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.1;
    p.y-=0.05;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.2,d2);
    d = min(d,d2);
    p = prevP;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(p.y+0.05,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolN(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    d = max(p.y,d);
    p.y+=0.15;
    float d2 = coolArrow(p);
    d2 = max(p.y,d2);
    d = min(d,d2);
    p = prevP;
    p.y-=0.25;
    d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.1;
    p.y+=0.05;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.2,d2);
    d = min(d,d2);
    p = prevP;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15-LINE_THICK,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolO(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    p = prevP;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.1,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolP(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y-=0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.x += 0.1;
    p.y+=0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.2,d2);
    d = min(d,d2);
    
    p = prevP;
    float a = radians(-45.);
    p.y+=0.15;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d2 = max(p.y-LINE_THICK,d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = min(p.x-LINE_THICK,-p.y);
    d = max(d2,d);
    
    p = prevP;
    a = radians(-45.);
    p.y+=0.05;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d2 = max(-prevP.x-LINE_THICK,d2);
    d = min(d,d2);

    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolQ(vec2 p){
    p*=vec2(1.2,1.);
    vec2 prevP = p;
    float d = coolO(p);
    
    p.x-=0.073;
    float d2 = abs(p.x)-0.022;
    p.y+=0.15;
    d2 = max(abs(p.y)-0.03,d2);
    d = max(-d2,d);
    p = prevP;
    p.y+=0.175;
    d2 = abs(p.y)-0.019;
    d2 = max(-(p.x-LINE_THICK),d2);
    d = max(-d2,d);
    
    p = prevP;
    d2 = max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
    d = min(d,d2);
    
    float a = radians(45.);
    p.y+=0.051;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-(LINE_THICK+0.002);
    d2 = max(-prevP.x+0.095,d2);
    d2 = max(prevP.x-0.15,d2);
    d = min(d,d2);     
    p = prevP;
    
    p.y+=0.2;
    d2 = abs(p.y)-(LINE_THICK+0.001);
    d2 = max(-p.x+0.05,d2);
    d2 = max(p.x-0.15,d2);
    d = min(d,d2);     
    p = prevP;
    
    d = max(p.x-0.145,d);
    
    return d;
}

float coolR(vec2 p){
    vec2 prevP = p;
    float d = coolB(p);
    
    p = prevP;
    p.y+=0.25;
    float d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.1,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolS(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    float a = radians(-45.);
    p.y=abs(p.y)-0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.y+=0.05;
    a = radians(45.);
    d2 = max(prevP.x-LINE_THICK,abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK);
    d = min(d,d2);
    
    p = prevP;
    p.x-=0.1;
    p.y+=0.05;
    a = radians(45.);
    d2 = max(-prevP.x-LINE_THICK,abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK);
    d = min(d,d2);
    
    p = prevP;
    a = radians(-62.);
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    p = prevP;
    a = radians(45.);
    d2 = max(-(abs(dot(p,vec2(cos(a),sin(a))))-0.035),d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolT(vec2 p){
    vec2 prevP = p;
    float d = coolI(p);
    d = max(p.y-0.15,d);
    
    p = prevP;
    float a = radians(-45.);
    
    p.x = abs(p.x)-0.15;
    p.x*=-1.;
    p.y-=0.2;
    p.y = abs(p.y)+0.05;
    float d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    p = prevP;
    d2 = max(-(abs(p.x)-(0.05-LINE_THICK)),d2);
    d = min(d,d2);    
    
    p.y-=0.25-LINE_THICK;
    d2 = abs(p.y)-LINE_THICK;
    d2 = max((abs(p.x)-(0.05+LINE_THICK)),d2);
    d = min(d,d2);  
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolU(vec2 p){
    vec2 prevP = p;
    float d = coolO(p);
    p.y-=0.25;
    float d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.1,d2);
    d = min(d,d2);
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolV(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y+=0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    p = prevP;
    p.y-=0.15;
    d2 = coolArrow(p);
    d2 = max(-p.y,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y-=0.05;
    p.x = abs(p.x)-0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.2,d2);
    d = min(d,d2);
    p = prevP;
    p.y-=0.01;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.15,d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolW(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p.y+=0.15;
    float d2 = coolArrow(p);
    d2 = max(p.y,d2);
    d = min(d,d2);
    p = prevP;
    p.y-=0.25;
    d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.y+=0.05;
    p.x = abs(p.x)-0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.2,d2);
    d = min(d,d2);
    p = prevP;
    p.y-=0.15;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(abs(p.y)-0.2,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y+=0.1;
    d2 = min(-(abs(p.x)-0.03), -(abs(p.y)-0.05));
    d = max(d2,d);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolX(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    p = prevP;
    p.y=abs(p.y)-0.15;
    float d2 = coolArrow(p);
    d2 = max(-p.y,d2);
    d = min(d,d2);
    
    p = prevP;
    float a = radians(-45.);
    p.y = abs(p.y)+0.05;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d = min(d,d2);
    
    p = prevP;
    a = radians(45.);
    p.y = abs(p.y)+0.05;
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(-(abs(p.y)-0.05),d2);
    d = min(d,d2);
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolY(vec2 p){
    vec2 prevP = p;
    float d = coolFontBase(p);
    float a = radians(-45.);
    p.y+=0.25;
    float d2 = coolArrow(p);
    d = min(d,d2);
    
    p = prevP;
    p.y-=0.15;
    d2 = coolArrow(p);
    d2 = max(-p.y,d2);
    d = min(d,d2);
    
    p = prevP;
    p.y+=0.05;
    a = radians(45.);
    d2 = max(prevP.x-LINE_THICK,abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK);
    d = min(d,d2);
    
    p = prevP;
    p.x -= 0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max((abs(p.y)-0.05),d2);
    d = min(d,d2);
    
    p = prevP;
    a = radians(-62.);
    d2 = abs(dot(p,vec2(cos(a),sin(a))))-LINE_THICK;
    p = prevP;
    a = radians(45.);
    d2 = max(-(abs(dot(p,vec2(cos(a),sin(a))))-0.035),d2);
    d2 = max(p.x,d2);
    d = min(d,d2);
    
    p.x = abs(p.x)-0.1;
    d2 = abs(p.x)-LINE_THICK;
    d2 = max(-p.y+0.05,d2);
    d = min(d,d2);    
    
    p = prevP;
    return max(abs(p.x)-0.1-LINE_THICK,max(abs(p.y)-0.25,d));
}

float coolZ(vec2 p){
    vec2 prevP = p;
    p.x*=-1.0;
    float d = coolS(p);
    return d;
}

float checkChar(int targetChar, int char){
    return 1.-abs(sign(float(targetChar) - float(char)));
}

float drawFont(vec2 p, int char){
    float dd=length(p*2.);
    float z = sqrt(1.0 - dd * dd);
    float r = atan(dd, z) / 3.14159;
    float a = atan(p.y, p.x)*0.01;
    
    p *= vec2(r*cos(a)-0.65,r*sin(a)-0.95);
    
    float d = coolA(p)*checkChar(char_A,char);
    d += coolB(p)*checkChar(char_B,char);
    d += coolC(p)*checkChar(char_C,char);
    d += coolD(p)*checkChar(char_D,char);
    d += coolE(p)*checkChar(char_E,char);
    d += coolF(p)*checkChar(char_F,char);
    d += coolG(p)*checkChar(char_G,char);
    d += coolH(p)*checkChar(char_H,char);
    d += coolI(p)*checkChar(char_I,char);
    d += coolJ(p)*checkChar(char_J,char);
    d += coolK(p)*checkChar(char_K,char);
    d += coolL(p)*checkChar(char_L,char);
    d += coolM(p)*checkChar(char_M,char);
    d += coolN(p)*checkChar(char_N,char);
    d += coolO(p)*checkChar(char_O,char);
    d += coolP(p)*checkChar(char_P,char);
    d += coolQ(p)*checkChar(char_Q,char);
    d += coolR(p)*checkChar(char_R,char);
    d += coolS(p)*checkChar(char_S,char);
    d += coolT(p)*checkChar(char_T,char);
    d += coolU(p)*checkChar(char_U,char);
    d += coolV(p)*checkChar(char_V,char);
    d += coolW(p)*checkChar(char_W,char);
    d += coolX(p)*checkChar(char_X,char);
    d += coolY(p)*checkChar(char_Y,char);
    d += coolZ(p)*checkChar(char_Z,char);
    
    return d;
}

float bg(vec2 p){
    p.x+=iTime*0.125;
    p = mod(p,0.03)-0.015;
    return min(abs(p.y)-0.0001,abs(p.x)-0.0001);
}

float arrow(vec2 p){
    vec2 prevPv = p;
    p.x = abs(p.x)-0.35;
    p.x+=iTime*0.1;
    p.x = mod(p.x,0.1)-0.05;
    p*=Rot(radians(-90.));
    p.x*=1.5;
    float d = Tri(p,vec2(0.05));
    p = prevPv;
    d = max(-(abs(p.x)-0.33),d);
    d = max((abs(p.x)-0.45),d);
    return d;
}

float fonts(vec2 p){
    p*=4.0;
    p.x+=iTime*0.5;
    vec2 gv = fract(p)-0.5;
    vec2 id = floor(p);

    float n = random(id)*float(char_Z-char_A);
    
    float size = 0.7;
    int char = int(mod(float(int(n)+char_A)+iTime*0.1*float(n),float(char_Z-char_A)+1.0))+char_A;
    float d = drawFont(gv*size,char);
    float d2 = arrow(gv);
    d = min(d,d2);
    return d;
}

float plus(vec2 p){
    float d = B(p,vec2(0.004,0.05));
    float d2 = B(p,vec2(0.05,0.004));
    return min(d,d2);
}

float graphic(vec2 p){
    p*=4.0;
    p.x+=iTime*0.5;
    p+=0.5;
    vec2 gv = fract(p)-0.5;
    vec2 id = floor(p);

    float d = plus(gv);
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    vec2 prevP = p;

    vec3 col = vec3(0.0);
    float d = bg(p);
    col = mix(col,vec3(0.5),S(d,0.0));
    d = fonts(p);
    col = mix(col,vec3(1.),S(d,0.0));
    d = graphic(p);
    col = mix(col,vec3(1.),S(d,0.0));
    
    fragColor = vec4(col,1.0);
}
