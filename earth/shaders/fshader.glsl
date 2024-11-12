#version 150

uniform vec4 ambient;
uniform vec4 LightPosition;

in vec4 pos;
in vec4 N;
in vec2 texCoord;

uniform mat4 ModelViewLight;

uniform sampler2D textureEarth;
uniform sampler2D textureNight;
uniform sampler2D textureCloud;
uniform sampler2D texturePerlin;

uniform float animate_time;


out vec4 fragColor;

void main()
{
  float radius = 100.0f;  
  float speed = 200.0f; 

  float angle = animate_time * speed;
  vec4 animatedLightPosition = vec4(radius * cos(angle), 50.0f * sin(angle), radius * sin(angle), 1.0f);

  //vec4 L = normalize( (ModelViewLight*LightPosition) - pos );
  vec4 L = normalize(animatedLightPosition - pos); 

  //float Kd = 1.0;
  float Kd = max(dot(normalize(N.xyz), L.xyz), 0.0);
  
  vec4 diffuse_color = texture(textureEarth, texCoord );
  vec4 diffuse_colorC = texture(textureCloud, texCoord );
  vec4 diffuse_colorn = texture(textureNight, texCoord );
  vec4 diffuse_colorp = texture(texturePerlin, texCoord );
  
  diffuse_color = Kd*diffuse_color;
  diffuse_colorC = Kd*diffuse_colorC;
  diffuse_colorn = (1-Kd)*diffuse_colorn;
  diffuse_colorp = Kd*diffuse_colorp;
  
  
  fragColor = ambient + diffuse_color + diffuse_colorC+diffuse_colorn+diffuse_colorp;
  fragColor = clamp(fragColor, 0.0, 1.0);
  fragColor.a = 1.0;
}



