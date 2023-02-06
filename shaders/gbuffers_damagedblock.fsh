#version 120

// This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at https://mozilla.org/MPL/2.0/.

//Diffuse (color) texture.
uniform sampler2D texture;
//Lighting from day/night + shadows + light sources.
uniform sampler2D lightmap;

//0 = default, 1 = water, 2 = lava.
uniform int isEyeInWater;

//Diffuse and lightmap texture coordinates.
varying vec2 coord0;
varying vec2 coord1;

void main()
{
    //Sample texture
    vec4 col = texture2D(texture,coord0);

    //Calculate fog intensity in or out of water.
    float fog = (isEyeInWater>0) ? isEyeInWater.-exp(-gl_FogFragCoord * gl_Fog.density):
    clamp((gl_FogFragCoord-gl_Fog.start) * gl_Fog.scale, 0., 1.);

    //Apply the fog.
    col.rgb = mix(col.rgb, gl_Fog.color.rgb, fog);

    //Output the result.
    /*DRAWBUFFERS:0*/
    gl_FragData[0] = col;
}
