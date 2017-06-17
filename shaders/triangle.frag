uniform vec2 point1;
uniform vec2 point2;
uniform vec2 point3;

uniform vec4 color1;
uniform vec4 color2;
uniform vec4 color3;

uniform float iGlobalTime;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    float denom = (point2.y-point3.y)*(point1.x-point3.x)+(point3.x-point2.x)*(point1.y-point3.y);
    float Wv1 = ((point2.y-point3.y)*(screen_coords.x-point3.x)+(point3.x-point2.x)*(screen_coords.y-point3.y))/denom;
    float Wv2 = ((point3.y-point1.y)*(screen_coords.x-point3.x)+(point1.x-point3.x)*(screen_coords.y-point3.y))/denom;
    float Wv3 = 1 - Wv1 - Wv2;

    //vec4 texturecolor = Texel(texture, texture_coords);

    if (Wv1 < 0 || Wv2 < 0 || Wv3 < 0) {
        return vec4(0);
    }
    else {
        return color1*(Wv1+abs(cos(iGlobalTime))*Wv2) + color2*Wv2 + color3*Wv3;
    }
}
