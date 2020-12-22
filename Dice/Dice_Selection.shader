shader_type spatial;

void fragment(){
	vec2 map = abs(UV - 0.5);
	float weight = 0.4f;
	if(map.x < weight && map.y < weight)
	{
		ALPHA = 0.f;
	}
	
	ALBEDO = vec3(0, 130, 0);
}