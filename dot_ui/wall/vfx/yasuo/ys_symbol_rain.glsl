#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.5),-antialiasing(1.5),d - b)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define DF(a,b) length(a) * cos( mod( atan(a.y,a.x)+6.28/(b*8.0), 6.28/((b*8.0)*0.5))+(b-1.)*6.28/(b*8.0) + vec2(0,11) )

float random (vec2 p) {
    return fract(sin(dot(p.xy, vec2(12.9898,78.233)))* 43758.5453123);
}

vec3 graphicItem0(vec2 p, vec3 col){
    vec2 prevP = p;
    float d = length(p-vec2(0.0,0.12))-0.06;
    float d2 = B(p,vec2(0.025,0.1));
    d = min(d,d2);
    d2 = length(p-vec2(0.0,-0.098))-0.0256;
    d = abs(min(d,d2))-0.007;
    
    d2 =  length(p-vec2(0.0,0.12))-0.02;
    d = min(d,d2);
    
    d2 =  length(p-vec2(0.0,0.24))-0.015;
    d = min(d,d2);    
    
    d2 = abs( length(p-vec2(0.0,0.24))-0.03)-0.002;
    d = min(d,d2);      
    
    col = mix(col,vec3(0.8),S(d,0.0));
    
    return col;
}

vec3 graphicItem0Group(vec2 p, vec3 col){
    vec2 prevP = p;
    col = graphicItem0(p,col);
    p.x = abs(p.x)-0.12;
    p.y-=0.1;
    col = graphicItem0(p,col);
    return col;
}

vec3 graphicItem0Layer(vec2 p, vec3 col){
    vec2 prevP = p;
    p.x = abs(p.x);
    p.y+=iTime*0.1;
    p*=2.5;
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    
    float n = random(id);
    gr.x+=sin(n*2.)*0.25;
    gr.y+=sin(n*2.)*0.3+mix(0.0,1.,step(0.9,n));
    gr*=clamp(n*1.5,0.85,1.5);
    col = graphicItem0Group(gr,col);
    
    return col;
}

vec3 graphicItem0Layer2(vec2 p, vec3 col){
    vec2 prevP = p;
    p.x = abs(p.x)-0.12;
    p.y+=iTime*0.12;
    p*=2.;
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    
    float n = random(id);
    gr.x+=sin(n*2.)*0.25;
    gr.y+=sin(n*2.)*0.3+mix(0.0,1.,step(0.9,n));
    gr*=clamp(n*1.5,0.6,1.5);
    col = graphicItem0(gr,col);
    
    return col;
}

float hexagon(vec2 p, float animate){
    p*=Rot(radians(-30.*iTime)*animate);
    float size = 0.1;
    float d = B(p,vec2(size-0.02,0.1));
    p.x = abs(p.x)-size;
    p.y = abs(p.y)-size*0.35;
    float a = radians(-120.);
    d = max(-dot(p,vec2(cos(a),sin(a))),d);
    return abs(d)-0.003;
}

vec3 graphicItem1(vec2 p, vec3 col){
    vec2 prevP = p;
    float d = hexagon(p,0.0);
    p.y = abs(p.y)-0.19;
    float d2 = hexagon(p,0.0);
    d = min(d,d2);
    p = prevP;
    p.x = abs(p.x)-0.16;
    p.y = abs(p.y)-0.09;
    d2 = hexagon(p,1.);
    d = min(d,d2);
    col = mix(col,vec3(0.7),S(d,0.0));
    return col;
}

vec3 graphicItem1Layer(vec2 p, vec3 col){
    vec2 prevP = p;
    p.x = abs(p.x)-0.3;
    p.y+=iTime*0.15;
    p.y+=0.2;
    p*=2.1;
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    
    float n = random(id);
    gr.x+=sin(n*10.)*0.1;
    gr.y+=sin(n*10.)*0.1+mix(0.0,1.,step(0.9,n));
    gr*=Rot(n*2.);
    gr*=clamp(n*2.5,0.85,2.5);
    col = graphicItem1(gr,col);
    
    return col;
}

vec3 graphicItem2(vec2 p, vec3 col){
    
    float d = 10.;
    for(float i = 0.; i<3.; i++){
        
        p = abs(p)-0.01;
        p*=Rot(radians(45.0+(30.0*iTime)));
        p.y+=0.05;
        p*=1.6;
        
        vec2 prevP = p;

        p.y+=0.2;
        p.x = abs(p.x);
        p.x-=0.22;
        p*=Rot(radians(30.0));
        d = length(p)-0.4;
        d = max(-(length(p-vec2(0.15,0.0))-0.31),d);

        p = prevP;
        p.y-=0.4;
        float d2 = length(p)-0.4;
        d2 = max(-(length(p-vec2(0.0,0.15))-0.31),d2);
        d = min(d,d2);

        p = prevP;
        p.y-=0.05;
        d2 = abs(length(p)-0.35)-0.05;
        d = abs(min(d,d2))-0.01;
    }
    
    col = mix(col,vec3(0.4),S(d,0.0));
     
    return col;
}

vec3 graphicItem2Layer(vec2 p, vec3 col){
    vec2 prevP = p;
    
    p*=0.9;
    
    p.x+=0.5;
    p.y+=iTime*0.2;
    p.y+=0.5;
    
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;
    
    float n = random(id);
    gr.y+=sin(n*50.)*0.2;
    gr*=clamp(n*1.,0.6,1.);
    col = graphicItem2(gr,col);
    
    return col;
}

float circleAnimation(vec2 p, float size, float lineWidth, float dir, float b){
    vec2 prevP = p;
    p*=Rot(radians(20.*iTime*dir));
    float d = abs(abs(length(p)-0.5)-size)-lineWidth;
    
    p = DF(p,b);
    p-=0.007;
    p*=Rot(radians(45.));
    float d2 = B(p,vec2(0.02,1.));
    
    d = max(-d2,d);
    return d;
}

float graphicItem3(vec2 p){
    float d = B(p,vec2(0.008,0.08));
    float d2 = B(p,vec2(0.08,0.008));
    d = min(d,d2);
    return d;
}

vec3 lineGraphicsLayer(vec2 p, vec3 col){
    vec2 prevP = p;
    p.x = abs(p.x);
    p.y+=iTime*0.08;
    p*=4.;
    
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;

    float n = random(id);
    gr*=Rot(radians(mix(0.0,90.,step(0.5,n))));
    
    float lineWidth = 0.008;
    vec3 lineColor = vec3(0.3);
    gr*=Rot(radians(45.));
    gr.x = abs(gr.x)-0.707;
    float d = circleAnimation(gr,0.14,lineWidth,-1.0,2.);
    col = mix(col,lineColor,S(d,-0.001));
    d = abs(abs(length(gr)-0.5)-0.09)-lineWidth;
    col = mix(col,lineColor,S(d,-0.001));
    d = circleAnimation(gr,0.03,lineWidth,1.0,2.);
    col = mix(col,lineColor,S(d,-0.001));
    d = abs(abs(length(gr)-0.5)-0.19)-lineWidth;
    col = mix(col,lineColor,S(d,-0.001));
    return col;
}

vec3 lineGraphicsLayer2(vec2 p, vec3 col){
    vec2 prevP = p;
    p.y+=iTime*0.08;
    p*=4.;
    p-=0.5;
    vec2 id = floor(p);
    vec2 gr = fract(p)-0.5;

    float n = random(id);
    
    float lineWidth = 0.008;
    vec3 lineColor = vec3(0.6);

    float d = mix(0.0,step(0.5,n),circleAnimation(gr,0.35,lineWidth,1.,1.5));
    float d2 = mix(0.0,step(0.5,n),circleAnimation(gr,0.3,lineWidth,-1.,1.5));
    d = min(d,d2);
    d2 = mix(step(0.5,n),1.0,graphicItem3(gr));
    d = min(d,d2);
    col = mix(col,lineColor,S(d,-0.002));

    return col;
}

vec3 drawGraphics(vec2 p, vec3 col){
    vec2 prevP = p;
    
    col = graphicItem2Layer(p,col);
    col = lineGraphicsLayer(p,col);
    col = lineGraphicsLayer2(p,col);
    col = graphicItem0Layer(p,col);
    col = graphicItem0Layer2(p,col);
    col = graphicItem1Layer(p,col);
    
    return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (fragCoord-0.5*iResolution.xy)/iResolution.y;

    vec3 col = vec3(0.0);
    col = drawGraphics(p,col);
    
    fragColor = vec4(col,1.0);
}
