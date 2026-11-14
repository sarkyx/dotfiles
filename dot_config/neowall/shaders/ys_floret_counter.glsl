#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.5),-antialiasing(1.5),d - b)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )
#define SkewX(a) mat2(1.0,tan(a),0.0,1.0)
#define BASE_FONT_SIZE 0.0714

float stripe(vec2 p, float s, float space){
    vec2 prevP = p;
    p*=Rot(radians(-45.));
    p.x-=iTime*0.05;
    p.x = mod(p.x,space)-(space*0.5);
    float d = B(p,vec2(s,10.));
    return d;
}

int c0[20] = int[](2,1,1,3,1,0,1,0,1,0,1,0,1,0,1,0,5,1,3,0);
int c1[20] = int[](0,1,3,0,0,1,0,0,0,1,0,0,0,1,0,0,0,3,0,0);
int c2[20] = int[](2,1,1,3,0,0,1,0,2,1,3,0,1,0,0,0,5,1,4,0);
int c3[20] = int[](2,1,1,3,0,0,1,0,2,1,1,0,0,0,1,0,2,1,3,0);
int c4[20] = int[](4,0,1,3,1,0,1,0,5,1,1,0,0,0,1,0,0,0,3,0);
int c5[20] = int[](2,1,1,3,1,0,0,0,5,1,4,0,0,0,1,0,2,1,3,0);
int c6[20] = int[](2,1,1,3,1,0,0,0,1,1,4,0,1,0,1,0,5,1,3,0);
int c7[20] = int[](2,1,1,3,0,0,1,0,0,0,1,0,0,0,1,0,0,0,3,0);
int c8[20] = int[](2,1,1,3,1,0,1,0,1,1,1,0,1,0,1,0,5,1,3,0);
int c9[20] = int[](2,1,1,3,1,0,1,0,1,1,1,0,0,0,1,0,2,1,3,0);

float baseFontShape(vec2 p){
    float size = BASE_FONT_SIZE-0.001;
    float d = B(p,vec2(size));
    return d;
}

float baseFontShape2(vec2 p, float deg){
    float size = BASE_FONT_SIZE-0.001;
    float d = B(p,vec2(size));
    float a = radians(deg);
    d = max(dot(p,vec2(cos(a),sin(a))),d);
    return d;
}

float chars(vec2 p, int[20] data){
    vec2 prevP  = p;
    float size = BASE_FONT_SIZE;
    float d = 10.;
    for(int i = 0; i<data.length(); i++){
        p = prevP;
        p.x-=(float(i%4)*(size*2.))-(size*2.);
        p.y+=(float(i/4)*(size*2.))-(size*4.);
        
        if(data[i] == 1){
            float d2 = baseFontShape(p);
            d = min(d,d2);
        } else if(data[i] == 2){
            float d2 = baseFontShape2(p,-225.);
            d = min(d,d2);
        } else if(data[i] == 3){
            float d2 = baseFontShape2(p,-45.);
            d = min(d,d2);
        } else if(data[i] == 4){
            float d2 = baseFontShape2(p,45.);
            d = min(d,d2);
        } else if(data[i] == 5){
            float d2 = baseFontShape2(p,-135.);
            d = min(d,d2);
        } else if(data[i] == 0){
            float d2 = max(B(p,vec2(size)),stripe(p,0.001,0.02));
            d = min(d,d2);
        }
    }
    return d;
}

float drawFont(vec2 p, int char){
    float d = 10.;
    if(char == 0) {
        d = chars(p,c0);
    } else if(char == 1) {
        d = chars(p,c1);
    } else if(char == 2) {
        d = chars(p,c2);
    } else if(char == 3) {
        d = chars(p,c3);
    } else if(char == 4) {
        d = chars(p,c4);
    } else if(char == 5) {
        d = chars(p,c5);
    } else if(char == 6) {
        d = chars(p,c6);
    } else if(char == 7) {
        d = chars(p,c7);
    } else if(char == 8) {
        d = chars(p,c8);
    } else if(char == 9) {
        d = chars(p,c9);
    }
    
    return d;
}

float random (vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

float arrowItem0(vec2 p){
    vec2 prevP = p;
    
    p.y-=iTime*0.05;
    p.x*=4.;
    p.y*=0.7;
    
    p.y = mod(p.y,0.04)-0.02;
    p.y-=0.02;
    float d = Tri(p,vec2(0.025));
    p = prevP;
    d = max(p.y-0.03,d);
    return d;
}

float arrowItem1(vec2 p){
    vec2 prevP = p;
    
    p.y-=iTime*0.02;
    p.x*=4.;
    
    p.y = mod(p.y,0.04)-0.02;
    p.y-=0.02;
    p.y+=0.006;
    float d = Tri(p,vec2(0.025));
    p = prevP;
    d = max(p.y,d);
    return d;
}

float shape0(vec2 p){
    vec2 prevP = p;
    p.x*=3.5;
    p.y*=0.9;
    p.y= abs(p.y)-0.09;
    float d = Tri(p,vec2(0.1));
    
    p = prevP;
    p.x*=3.5;
    p.y*=0.9;
    p.y= abs(p.y)-0.07;
    float d2 = Tri(p,vec2(0.08));
    d = max(-d2,d);
    
    p = prevP;
    p.y= abs(p.y)-0.05;
    d2 = arrowItem0(p);
    p = prevP;
    d2 = max(-B(p,vec2(0.01)),d2);
    d = min(d,d2);
    
    p = prevP;
    d2 = length(p)-0.005;
    d = min(d,d2);
    
    p.x= abs(p.x)-0.03;
    d2 = arrowItem1(p);
    d = min(d,d2);
    
    return d;
}

float shape1_1(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.02,0.1));
    float a = radians(-10.);
    p.x-=0.001;
    d = max(-dot(p,vec2(cos(a),sin(a))),d);
    p = prevP;
    a = radians(30.);
    p.y+=0.05;
    d = max(-dot(p,vec2(cos(a),sin(a))),d);
    return d;
}

float shape1_2(vec2 p){
    vec2 prevP = p;
    
    p.x = abs(p.x)-0.012;
    p.x*=-1.;
    p.y = abs(p.y)-0.1;
    float d = shape1_1(p);
    p = prevP;
    d = min(length(p)-0.01,d);
    return d;
}

float shape1(vec2 p){
    vec2 prevP = p;
    p.y+=0.04;
    p*=-1.;
    float d = shape1_1(p);
    p = prevP;
    p.x-=0.065;
    p.y-=0.02;
    p*=Rot(radians(60.));
    float d2 = shape1_1(p);
    d = min(d,d2);
    
    p = prevP;
    p.x+=0.02;
    p.y-=0.05;
    p*=Rot(radians(-60.));
    d2 = shape1_1(p);
    d = min(d,d2);
    
    return d;
}

float shape2(vec2 p){
    vec2 prevP = p;
    p.x = abs(p.x)-0.25;
    p*=Rot(radians(-30.*iTime));
    float d = min(B(p,vec2(0.002,0.03)),B(p,vec2(0.03,0.002)));
    return d;
}

float baseShape(vec2 p){
    p*=Rot(radians(90.));
    p = DF(p,1.5);
    p-=0.07;
    p*=Rot(radians(45.));
    float d = shape0(p);
    return d;
}

float drawGlitchStripe(vec2 p){
    vec2 prevP = p;
    float d = stripe(p,0.012,0.05);
    d = max(abs(p.y)-0.023,d);
    d = max(p.y,d);
    p.x+=0.085;
    float d2 = stripe(p,0.012,0.05);
    d2 = max(abs(p.y)-0.023,d2);
    d2 = max(-p.y,d2);
    d = min(d,d2);
    
    p = prevP;
    d = max(abs(p.x)-0.165,d);
    
    p = prevP;
    p.x-=0.14;
    d2 = B(p,vec2(0.07,0.03));
    float a = radians(45.);
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    
    a = radians(45.);
    p.x-=0.05;
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    
    d = min(d,d2);
    
    p = prevP;
    p.x+=0.14;
    d2 = B(p,vec2(0.07,0.03));
    a = radians(45.);
    d2 = max(dot(p,vec2(cos(a),sin(a))),d2);
    
    a = radians(45.);
    p.x+=0.05;
    d2 = max(-dot(p,vec2(cos(a),sin(a))),d2);
    
    d = min(d,d2);
    
    return d;
}

float ring(vec2 p, float speed){
    vec2 prevP = p;
    float size = 0.03;
    float d = abs(length(p)-size)-0.001;
    p*=Rot(radians(sin(iTime*speed)*240.));
    float d2 = abs(length(p)-size)-0.003;
    d2 = max(abs(p.y)-size*0.5,d2);
    d = min(d,d2);
    return d;
}

float slider(vec2 p){
    vec2 prevP = p;
    float d = B(p,vec2(0.002,0.06));
    p.y+=sin(iTime*1.5)*0.05;
    float d2 = B(p,vec2(0.0035,0.015));
    d = min(d,d2);
    return d;
}

float arrows(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.05;
    p.y = mod(p.y,0.03)-0.015;
    p.y-=0.015;
    p.x*=2.;
    float d = Tri(p,vec2(0.015));
    p = prevP;
    d = max(abs(p.y)-0.03,d);
    return d;
}

float mainGraphic(vec2 p){
    vec2 prevP = p;
    float d = baseShape(p);
    p.y=abs(p.y)-0.2;
    
    float d2 = baseShape(p);
    d = min(d,d2);
    p.y=abs(p.y)-0.2;
    d2 = baseShape(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.17;
    p.y = abs(p.y)-0.1;
    d2 = baseShape(p);
    d = min(d,d2);
    p.y = abs(p.y)-0.2;
    d2 = baseShape(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.34;
    d2 = baseShape(p);
    d = min(d,d2);
    p.y = abs(p.y)-0.2;
    d2 = baseShape(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.47;
    p.y = abs(p.y)-0.43;
    p*=Rot(radians(-30.+iTime*20.));
    p*=1.3;
    d2 = shape1(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.57;
    d2 = shape1_2(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.8;
    p.y = abs(p.y)-0.58;
    p*=1.3;
    d2 = shape2(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.38;
    p.y = abs(p.y)-0.57;
    p*=Rot(radians(-8.));
    p.x*=-1.;
    p.y*=1.5;
    d2 = drawGlitchStripe(p);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.27;
    p.y = abs(p.y)-0.46;
    d2 = ring(p,1.5);
    d = min(d,d2);
    
    p = prevP;
    p.x = abs(p.x)-0.57;
    p.y = abs(p.y)-0.26;
    d2 = ring(p,-1.2);
    d = min(d,d2);    
        
    p = prevP;
    p.x = abs(p.x)-0.62;
    p.y = abs(p.y)-0.42;
    d2 = slider(p);
    d = min(d,d2);    
    
    p = prevP;
    p.x = abs(p.x)-0.08;
    p.y = abs(p.y)-0.54;
    p*=Rot(radians(-145.));
    d2 = arrows(p);
    d = min(d,d2);    
    
    return d;
}

float numbers(vec2 p, float dir){
    vec2 prevP = p;
    p*=SkewX(radians(-25.));
    p*=1.7;
    p.x+=iTime*0.1*dir;
    p.y+=1.;
    p*=1.5;
    p.x*=1.4;
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    
    float n = random(id)*10.;
    int num = int(mod(n+0.5*iTime*float(n),10.0));
    gr.x*=0.75;
    gr.x+=0.075;
    float d = drawFont(gr,num);
    
    p = prevP;
    d = max(abs(p.y)-0.25,d);
    
    p*=SkewX(radians(-25.));
    p*=1.7;
    p.x+=iTime*0.1*dir;
    p.y+=1.;
    p*=1.5;
    p.x*=1.4;
    gr = fract(p)-0.5;
    gr.x =abs(gr.x)-0.5;
    gr.y =abs(gr.y)-0.41;
    float d2 = B(gr,vec2(0.1,0.01));
    p = prevP;
    d2 = max(abs(p.y)-0.16,d2);
    d = min(d,d2);
    
    return d;
}

float bg(vec2 p){
    vec2 prevP = p;
    p.y-=iTime*0.1;
    p*=5.;
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    vec2 prevGr = gr;
    float n = random(id);
    float dir = (n<0.5)?-1.:1.;
    gr*=Rot(radians(45.)*dir);
    gr.y = abs(gr.y)-0.355;
    float d = B(gr,vec2(0.3,0.25));
    float d2 = B(gr,vec2(0.6,0.07));
    float thick = 0.005;
    d = min(abs(d)-thick,abs(d2)-thick);
    return d;
}

float drawNumbers(vec2 p){
    vec2 prevP = p;
    p*=Rot(radians(-90.));
    float d = numbers(p-vec2(0.0,0.8),1.0);
    p = prevP;
    p*=Rot(radians(90.));
    float d2 = numbers(p-vec2(0.,0.8),1.0);
    d = min(d,d2);
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (fragCoord-0.5*iResolution.xy)/iResolution.y;
    
    p*=1.25;
    vec2 prevP = p;

    vec3 col = vec3(0.0);
    float d = bg(p);
    col = mix(col,vec3(0.5),S(d,0.0));
    d = drawNumbers(p);
    col = mix(col,vec3(1.),S(d,0.0));
    d = mainGraphic(p);
    col = mix(col,vec3(1.),S(d,0.0));
    
    fragColor = vec4(col,1.0);
}
