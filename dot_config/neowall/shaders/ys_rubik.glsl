// The box intersection code is based on the iq's. https://www.shadertoy.com/view/ld23DV
#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.5),b,d)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define SymdirY(p) mod(floor(p).y,2.)*2.-1.
#define BOX_NUM 27.

float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

float getTime(float t, float duration){
    return clamp(t,0.0,duration)/duration;
}

float getAnimatedRotValue(float delay){
    float frame = mod(iTime,9.0+delay)-delay;
    float time = frame;
    float duration = 0.7;
    float rotVal = 0.0;
    if(frame>=1. && frame<3.){
        time = getTime(time-1.,duration);
        rotVal = cubicInOut(time)*90.;
    } else if(frame>=3. && frame<5.){
        time = getTime(time-3.,duration);
        rotVal = 90.+cubicInOut(time)*90.;
    } else if(frame>=5. && frame<7.){
        time = getTime(time-5.,duration);
        rotVal = 180.+cubicInOut(time)*90.;
    } else if(frame>=7. && frame<9.){
        time = getTime(time-7.,duration);
        rotVal = 270.+cubicInOut(time)*90.;
    }
    
    return rotVal;
}

// https://iquilezles.org/articles/boxfunctions
vec4 iBox( in vec3 ro, in vec3 rd, in mat4 txx, in mat4 txi, in vec3 rad ) 
{
    // convert from ray to box space
	vec3 rdd = (txx*vec4(rd,0.0)).xyz;
	vec3 roo = (txx*vec4(ro,1.0)).xyz;

	// ray-box intersection in box space
    vec3 m = 1.0/rdd;
    vec3 n = m*roo;
    vec3 k = abs(m)*rad;
    vec3 t1 = -n - k;
    vec3 t2 = -n + k;
    float tN = max(max(t1.x,t1.y),t1.z);
    float tF = min(min(t2.x,t2.y),t2.z);
    
    // no intersection
	if( tN>tF || tF<0.0 ) return vec4(-1.0);

    vec4 res = vec4(tN, step(tN,t1) );
    
    // add sign to normal and convert to ray space
	res.yzw = (txi * vec4(-sign(rdd)*res.yzw,0.0)).xyz;

	return res;
}

mat4 rotationAxisAngle( vec3 v, float angle )
{
    float s = sin( angle );
    float c = cos( angle );
    float ic = 1.0 - c;

    return mat4( v.x*v.x*ic + c,     v.y*v.x*ic - s*v.z, v.z*v.x*ic + s*v.y, 0.0,
                 v.x*v.y*ic + s*v.z, v.y*v.y*ic + c,     v.z*v.y*ic - s*v.x, 0.0,
                 v.x*v.z*ic - s*v.y, v.y*v.z*ic + s*v.x, v.z*v.z*ic + c,     0.0,
			     0.0,                0.0,                0.0,                1.0 );
}

mat4 translate( float x, float y, float z )
{
    return mat4( 1.0, 0.0, 0.0, 0.0,
				 0.0, 1.0, 0.0, 0.0,
				 0.0, 0.0, 1.0, 0.0,
				 x,   y,   z,   1.0 );
}


float truchetGraphic(vec2 p, float dir){
    vec2 prevP = p;
    p.x*=dir;
    p*=Rot(radians(45.));
    p.x = abs(p.x)-0.212;
    
    p*=Rot(radians(45.));
    vec2 prevP2 = p;
    float a = radians(45.);
    float d = abs(max(-dot(p+vec2(0.095),vec2(cos(a),sin(a))),B(p,vec2(0.15))))-0.03;
    p+=vec2(0.085);
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.03,0.003)),d);
    
    p = prevP2;
    p+=vec2(0.105);
    
    p*=Rot(radians(45.));
    p.x = abs(p.x)-0.075;
    d = max(-B(p,vec2(0.007)),d);
    
    p = prevP;
    p = mod(p,0.03)-0.015;
    float d2 = length(p)-0.0005;
    d = min(d,d2);
    
    p = prevP;
    
    p.y*=dir;
    p*=Rot(radians(45.));
    float sdir = SymdirY(p);
    p.x*=1.7;
    p.y+=iTime*0.1*sdir;
    p.y = mod(p.y,0.08)-0.04;
    p.y*=sdir*-1.;
    d2 = Tri(p,vec2(0.015));
    d = min(d,d2);
    
    p = prevP;
    p.x*=dir;
    p*=Rot(radians(135.));
    p.y = abs(p.y)-0.17;
    p*=Rot(radians(45.));
    d2 = min(B(p,vec2(0.0005,0.01)),B(p,vec2(0.01,0.0005)));
    d = min(d,d2);
    
    return d;
}

float ui(vec2 p){
    vec2 prevP = p;
    p = mod(p,0.06)-0.03;
    float d = min(B(p,vec2(0.0001,0.006)),B(p,vec2(0.006,0.0001)));
    p = prevP;
    d = max(B(p,vec2(0.55,0.3)),d);
    
    p.x = abs(p.x)-0.7;
    vec2 prevP2 = p;
    float a = radians(-50.);
    p.y = abs(p.y)-0.2;
    float d2 = abs(max(-dot(p,vec2(cos(a),sin(a))),B(p,vec2(0.08,0.4))))-0.0001;
    p = prevP2;
    d2 = max(p.x-0.05,min(B(p-vec2(-0.08,0.0),vec2(0.003,0.03)),d2));
    d = min(d,d2);
    
    p = prevP2;
    p.y = abs(p.y)-0.35;
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.0001,0.15));
    d = min(d,min(B(p,vec2(0.003,0.05)),d2));
    
    p = prevP;
    p.x = abs(p.x)-0.56;
    p.y = abs(p.y)-0.42;
    p.x = abs(p.x)-0.012;
    d2 = abs(length(p)-0.008)-0.0003;
    d = min(d,d2);
    
    p = prevP;
    p.y = abs(p.y)-0.46;
    p.y*=-1.;
    d2 = abs(Tri(p,vec2(0.02)))-0.0005;
    d = min(d,max(-(p.y+0.016),d2));
    
    p = prevP;
    p.x = abs(p.x)-0.75;
    p.y = mod(p.y,0.018)-0.009;
    d2 = B(p,vec2(0.015,0.001));
    d2 = max(abs(prevP.y)-0.05,d2);
    d = min(d,d2);
    
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 p = (fragCoord-0.5*iResolution.xy) / iResolution.y;
    vec2 m =  iMouse.xy/iResolution.xy;
    
    // camera movement	
	float an = radians(90.);
	vec3 ro = vec3( 2.5*cos(an), 0., 2.5*sin(an) );
    
    if(iMouse.z>0.){
        ro.yz *= Rot(m.y*3.14+1.);
        ro.y = max(-0.9,ro.y);
        ro.xz *= Rot(-m.x*6.2831);
    } else {
        ro.yz *= Rot(radians(5.0));
        
        float delay = 2.5;
        float frame = mod(iTime,11.0+delay)-delay;
        float time = frame;
        
        float duration = 0.7;
        float rotVal = 0.0;
        if(frame>=1. && frame<3.){
            time = getTime(time-1.,duration);
            rotVal = cubicInOut(time)*90.;
        } else if(frame>=3. && frame<5.){
            time = getTime(time-3.,duration);
            rotVal = 90.+cubicInOut(time)*90.;
        } else if(frame>=5. && frame<7.){
            time = getTime(time-5.,duration);
            rotVal = 180.+cubicInOut(time)*90.;
        } else if(frame>=7. && frame<9.){
            time = getTime(time-7.,duration);
            rotVal = 270.+cubicInOut(time)*90.;
        } else if(frame>=9.){
            time = getTime(time-9.,duration+0.5);
            rotVal = 360.-cubicInOut(time)*360.;
        }
        
        ro.xz *= Rot(radians(-rotVal));
    }
    
    vec3 ta = vec3( 0.0, 0.,0.0 );
    
    // camera matrix
    vec3 ww = normalize( ta - ro );
    vec3 uu = normalize( cross(ww,vec3(0.0,1.0,0.0) ) );
    vec3 vv = normalize( cross(uu,ww));
    
	// create view ray
	vec3 rd = normalize( p.x*uu + p.y*vv + 1.8*ww );

    // raytrace
	float tmin = 10000.0;
	vec3 nor = vec3(0.0);
	vec3 pos = vec3(0.0);
	float oid = 0.0;
    mat4 txxRef = mat4(0.0);
    float dir = 0.0;
    
    float dist = .3;
    for(float i = 0.; i<BOX_NUM; i+=1.){
        int index = int(i);

        float x = dist-(float(mod(i,3.))*dist);
        float y = dist-(floor(mod(i,9.)/3.)*dist);
        float z = dist-(floor(i/9.)*dist);

        float rotVal = getAnimatedRotValue(i*0.15);
        mat4 rot = rotationAxisAngle( normalize(mod(i,2.) ==0.?vec3(1.0,0.0,0.0):vec3(0.0,1.0,0.0)), radians(rotVal) );
        
        mat4 tra = translate( x, y, z );
        mat4 txi = tra * rot; 
        mat4 txx = inverse( txi );
        
        vec4 res = iBox( ro, rd, txx, txi, vec3(0.15) );
        if( res.x>0.0 && res.x<tmin  ) { 
            tmin = res.x; 
            nor = res.yzw;
            oid = i;
            txxRef = txx;
            
            dir = 1.;
            if(mod(i,5.) == 0.)dir = -1.;
        }
    }

	vec3 col = vec3(0.) ;

	if( tmin<100.0 )
	{
		pos = ro + tmin*rd;
		
        // materials
		float occ = 1.0;
		vec3 mate = vec3(1.0);
        
        for(float i = 0.; i<BOX_NUM; i+=1.){
            int index = int(i);
            if(oid == i){
                vec3 opos = (txxRef*vec4(pos,1.0)).xyz;
                vec3 onor = (txxRef*vec4(nor,0.0)).xyz;

                vec3 colXZ = mix(col,vec3(1.),S(truchetGraphic(opos.xz,dir),0.0));
                vec3 colYZ = mix(col,vec3(1.),S(truchetGraphic(opos.yz,dir),0.0));
                vec3 colXY = mix(col,vec3(1.),S(truchetGraphic(opos.xy,dir),0.0));
                mate = colXZ*abs(onor.y)+colXY*abs(onor.z)+colYZ*abs(onor.x);
             }
        }
        
        // lighting
        vec3 lig = normalize(vec3(0.8,2.4,3.0));
        float dif = clamp( dot(nor,lig), 0.0, 1.0 );
        vec3 hal = normalize(lig-rd);
        
        float amb = 0.6 + 0.4*nor.y;
        float bou = clamp(0.3-0.7*nor.y,0.0,1.0);
        float spe = clamp(dot(nor,hal),0.0,1.0);
        col  = 4.0*vec3(1.00,0.80,0.60)*dif;
        col += 2.0*vec3(0.20,0.30,0.40)*amb;
        col += 2.0*vec3(0.30,0.20,0.10)*bou;
        col *= mate;                      
	} else {
        float d = ui(p);
        col = mix(col,vec3(0.7),S(d,0.0));
    }
	
    // gamma
    col = pow( col, vec3(0.45) );

	fragColor = vec4( col, 1.0 );
}





/* // The old shader to test. This one is the ray marching version.
#define MAX_STEPS 36
#define MAX_DIST 2.
#define SURF_DIST .003
#define Rot(a) mat2(cos(a),-sin(a),sin(a),cos(a))
#define antialiasing(n) n/min(iResolution.y,iResolution.x)
#define S(d,b) smoothstep(antialiasing(1.5),b,d)
#define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)
#define deg45 .707
#define R45(p) (( p + vec2(p.y,-p.x) ) *deg45)
#define Tri(p,s) max(R45(p).x,max(R45(p).y,B(p,s)))
#define SymdirY(p) mod(floor(p).y,2.)*2.-1.

vec3 positions[27] = vec3[](vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.),vec3(0.));
mat2 rots[27] = mat2[](mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.),mat2(0.));
float dirs[27] = float[](1.,-1.,1.,1.,1.,-1.,1.,-1.,1.,1.,-1.,1.,1.,1.,-1.,1.,-1.,1.,1.,-1.,1.,1.,1.,-1.,1.,-1.,1.);

float B3D(vec3 p, vec3 s) {
    p = abs(p)-s;
    return max(max(p.x,p.y),p.z);
}

float cubicInOut(float t) {
  return t < 0.5
    ? 4.0 * t * t * t
    : 0.5 * pow(2.0 * t - 2.0, 3.0) + 1.0;
}

float getTime(float t, float duration){
    return clamp(t,0.0,duration)/duration;
}

float getAnimatedRotValue(float delay){
    float frame = mod(iTime,9.0+delay)-delay;
    float time = frame;
    float duration = 0.7;
    float rotVal = 0.0;
    if(frame>=1. && frame<3.){
        time = getTime(time-1.,duration);
        rotVal = cubicInOut(time)*90.;
    } else if(frame>=3. && frame<5.){
        time = getTime(time-3.,duration);
        rotVal = 90.+cubicInOut(time)*90.;
    } else if(frame>=5. && frame<7.){
        time = getTime(time-5.,duration);
        rotVal = 180.+cubicInOut(time)*90.;
    } else if(frame>=7. && frame<9.){
        time = getTime(time-7.,duration);
        rotVal = 270.+cubicInOut(time)*90.;
    }
    
    return rotVal;
}

vec2 GetDist(vec3 p) {
    vec3 prevP = p;
    
    vec2 res = vec2(0.0);
    float dist = .3;
    float size = .15;
    
    float rotVal = getAnimatedRotValue(0.0);
    int index = 0;

    positions[index] = vec3(dist);
    rots[index] = Rot(radians(rotVal));
    p += positions[index];
    p.yz*= rots[index];
    float d = B3D(p,vec3(size));

    res = vec2(d,index);    
 
    float len = float(positions.length());
    for(float i = 1.; i<len; i+=1.){
        p = prevP;
        float rotVal = getAnimatedRotValue(i*0.15);
        index = int(i);
        
        float x = dist-(float(mod(i,3.))*dist);
        float y = dist-(floor(mod(i,9.)/3.)*dist);
        float z = dist-(floor(i/9.)*dist);
        positions[index] = vec3(x,y,z);
        rots[index] = Rot(radians(rotVal));
        p += positions[index];
        if(dirs[index] == 1.){
            p.yz*= rots[index];
        } else {
            p.xz*= rots[index];
        }
        
        float d = B3D(p,vec3(size));

        vec2 res2 = vec2(d,index);
        res = mix(res,res2,step(res2.x,res.x));
    }
    
    return res;
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

vec3 diffuseMaterial(vec3 n, vec3 rd, vec3 p, vec3 col) {
    vec3 diffCol = vec3(0.0);
    vec3 lightDir = normalize(vec3(1,10,-20));
    float diff = clamp(dot(n,lightDir),0.0,1.0);
    float skyDiff = clamp(0.5+0.5*dot(n,vec3(0,1,0)),0.0,1.0);
    float bounceDiff = clamp(0.5+0.5*dot(n,vec3(0,-1,0)),0.0,1.0);
    diffCol = col*vec3(-0.5)*diff;
    diffCol += col*vec3(1.0,1.0,0.9)*skyDiff;
    diffCol += col*vec3(0.5)*bounceDiff;
    diffCol += col*pow(max(dot(rd, reflect(lightDir, n)), 0.0), 60.); // spec
        
    return diffCol;
}

float truchetGraphic(vec2 p, float dir){
    vec2 prevP = p;
    p.x*=dir;
    p*=Rot(radians(45.));
    p.x = abs(p.x)-0.212;
    
    p*=Rot(radians(45.));
    vec2 prevP2 = p;
    float a = radians(45.);
    float d = abs(max(-dot(p+vec2(0.095),vec2(cos(a),sin(a))),B(p,vec2(0.15))))-0.03;
    p+=vec2(0.085);
    p*=Rot(radians(45.));
    d = max(-B(p,vec2(0.03,0.003)),d);
    
    p = prevP2;
    p+=vec2(0.105);
    
    p*=Rot(radians(45.));
    p.x = abs(p.x)-0.075;
    d = max(-B(p,vec2(0.007)),d);
    
    p = prevP;
    p = mod(p,0.03)-0.015;
    float d2 = length(p)-0.0005;
    d = min(d,d2);
    
    p = prevP;
    
    p.y*=dir;
    p*=Rot(radians(45.));
    float sdir = SymdirY(p);
    p.x*=1.7;
    p.y+=iTime*0.1*sdir;
    p.y = mod(p.y,0.08)-0.04;
    p.y*=sdir*-1.;
    d2 = Tri(p,vec2(0.015));
    d = min(d,d2);
    
    p = prevP;
    p.x*=dir;
    p*=Rot(radians(135.));
    p.y = abs(p.y)-0.17;
    p*=Rot(radians(45.));
    d2 = min(B(p,vec2(0.0005,0.01)),B(p,vec2(0.01,0.0005)));
    d = min(d,d2);
    
    return d;
}

vec3 materials(int mat, vec3 n, vec3 rd, vec3 p, vec3 col){
    vec3 n2 = n;
    p+=positions[mat];
    if(dirs[mat] == 1.){
        p.yz*= rots[mat];
        n2.yz*= rots[mat];
    } else {
        p.xz*= rots[mat];
        n2.xz*= rots[mat];
    }
    
    col = diffuseMaterial(n,rd,p,vec3(0.2));
    
    vec3 colXZ = mix(col,vec3(1.),S(truchetGraphic(p.xz,dirs[mat]),0.0));
    vec3 colYZ = mix(col,vec3(1.),S(truchetGraphic(p.yz,dirs[mat]),0.0));
    vec3 colXY = mix(col,vec3(1.),S(truchetGraphic(p.xy,dirs[mat]),0.0));

    return colXZ*n2.y+colXY*n2.z+colYZ*n2.x;
}

float ui(vec2 p){
    vec2 prevP = p;
    p = mod(p,0.06)-0.03;
    float d = min(B(p,vec2(0.0001,0.006)),B(p,vec2(0.006,0.0001)));
    p = prevP;
    d = max(B(p,vec2(0.55,0.3)),d);
    
    p.x = abs(p.x)-0.7;
    vec2 prevP2 = p;
    float a = radians(-50.);
    p.y = abs(p.y)-0.2;
    float d2 = abs(max(-dot(p,vec2(cos(a),sin(a))),B(p,vec2(0.08,0.4))))-0.0001;
    p = prevP2;
    d2 = max(p.x-0.05,min(B(p-vec2(-0.08,0.0),vec2(0.003,0.03)),d2));
    d = min(d,d2);
    
    p = prevP2;
    p.y = abs(p.y)-0.35;
    p*=Rot(radians(50.));
    d2 = B(p,vec2(0.0001,0.15));
    d = min(d,min(B(p,vec2(0.003,0.05)),d2));
    
    p = prevP;
    p.x = abs(p.x)-0.56;
    p.y = abs(p.y)-0.42;
    p.x = abs(p.x)-0.012;
    d2 = abs(length(p)-0.008)-0.0003;
    d = min(d,d2);
    
    p = prevP;
    p.y = abs(p.y)-0.46;
    p.y*=-1.;
    d2 = abs(Tri(p,vec2(0.02)))-0.0005;
    d = min(d,max(-(p.y+0.016),d2));
    
    p = prevP;
    p.x = abs(p.x)-0.75;
    p.y = mod(p.y,0.018)-0.009;
    d2 = B(p,vec2(0.015,0.001));
    d2 = max(abs(prevP.y)-0.05,d2);
    d = min(d,d2);
    
    return d;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y;
    vec2 prevUV = uv;
    vec2 m =  iMouse.xy/iResolution.xy;
    
    vec3 ro = vec3(0, 0, -1.57);
    if(iMouse.z>0.){
        ro.yz *= Rot(m.y*3.14+1.);
        ro.y = max(-0.9,ro.y);
        ro.xz *= Rot(-m.x*6.2831);
    } else {
        ro.yz *= Rot(radians(-5.0));
        
        float delay = 2.5;
        float frame = mod(iTime,11.0+delay)-delay;
        float time = frame;
        
        float duration = 0.7;
        float rotVal = 0.0;
        if(frame>=1. && frame<3.){
            time = getTime(time-1.,duration);
            rotVal = cubicInOut(time)*90.;
        } else if(frame>=3. && frame<5.){
            time = getTime(time-3.,duration);
            rotVal = 90.+cubicInOut(time)*90.;
        } else if(frame>=5. && frame<7.){
            time = getTime(time-5.,duration);
            rotVal = 180.+cubicInOut(time)*90.;
        } else if(frame>=7. && frame<9.){
            time = getTime(time-7.,duration);
            rotVal = 270.+cubicInOut(time)*90.;
        } else if(frame>=9.){
            time = getTime(time-9.,duration+0.5);
            rotVal = 360.-cubicInOut(time)*360.;
        }
        
        ro.xz *= Rot(radians(-rotVal));
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
        float ud = ui(uv);
        col = mix(col,vec3(0.7),S(ud,0.0));
    }
    
    col = pow( col, vec3(0.9545) );    
    
    fragColor = vec4(col,1.0);
}
*/
