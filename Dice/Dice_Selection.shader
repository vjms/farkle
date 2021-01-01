shader_type spatial;

uniform vec3 color;

void fragment(){
	vec2 map = abs(UV - 0.5);
	vec2 zero = vec2(0.0, 0.0);
	vec3 col = color;
	float dist = distance(map, zero);
	float weight = 0.5f;
	float alpha = dist + weight;
	alpha = pow(alpha, 20);
	if( dist > weight)
	{
		alpha = 0.0;
	}
	ALPHA = alpha;
	ALBEDO = col;
	EMISSION = col * 2.5;
		
}