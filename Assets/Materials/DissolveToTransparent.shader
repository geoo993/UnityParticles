// clips materials, using an image as guidance.
// use clouds or random noise as the slice guide for best results.
 Shader ".ShaderExample/DissolveToTransparent" 
 {

  		Properties {

	     	_MainTex ("Texture (RGB)", 2D) = "white" {}
	     	_DissolveTex ("Dissolve Text (RGB)", 2D) = "white" {}
	      	_DissolveAmount ("Dissolve Amount", Range(-0.4, 1.0)) = 0.5

	      	_BurnSize ("Burn Size", Range(0.0, 1.0)) = 0.15
 			_BurnRamp ("Burn Ramp (RGB)", 2D) = "white" {}
    	}
    	SubShader {
	     	Tags { "RenderType" = "Opaque" }
	      	Cull Off
	      	CGPROGRAM
	      	//if you're not planning on using shadows, remove "addshadow" for better performance
	     	 #pragma surface surf Lambert addshadow

	     	struct Input {
	          	float2 uv_MainTex;
	          	float2 uv_DissolveTex;
	          	float _DissolveAmount;
	     	};

	     	sampler2D _MainTex, _DissolveTex, _BurnRamp;
	      	float _DissolveAmount, _BurnSize;
	      	float4 _Color;

		     void surf (Input IN, inout SurfaceOutput OUT) 
		     {

		         clip(tex2D (_DissolveTex, IN.uv_DissolveTex).rgb - _DissolveAmount);
		         OUT.Albedo = tex2D (_MainTex, IN.uv_MainTex).rgb;
			 
				 half test = tex2D (_DissolveTex, IN.uv_MainTex).rgb - _DissolveAmount;

				 if(test < _BurnSize && _DissolveAmount > 0 && _DissolveAmount < 1)
				 {
				    OUT.Emission = tex2D(_BurnRamp, float2(test *(1/_BurnSize), 0));
					OUT.Albedo *= OUT.Emission;
				 }
			}

	      ENDCG
	} 
	Fallback "Diffuse"
 }