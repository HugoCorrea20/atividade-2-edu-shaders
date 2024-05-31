Shader "Custom/wave"
{
      Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex (" Diffuse (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _Direction("Direction", Vector) = (1.0,0.0,0.0,1.0)
      _Steepness ("Steepness", Range(0.1, 1.0)) = 0.5
      _Freq ("Frequency", Range (1.0, 10.0)) = 1.0
    } 
SubShader
    {
        Tags { "RenderType"="Opaque" }
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows vertex:vert addshadow
 
        sampler2D _MainTex;
        
        sampler2D _NormalMap;
 
        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
           
        };
 
	 half _Glossiness;
     half _Metallic;
       fixed4 _Color;

    float _Steepness, _Freq; 
    float4 _Direction;
 
        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)
 
        void vert(inout appdata_full v){    
            float3 pos = v.vertex.xyz;
            float4 dir = normalize(_Direction);
             float defaultWavelength = 2 * UNITY_PI;
            float wL = defaultWavelength / _Freq;
            float phase = sqrt(9.8 / wL);

            float disp = wL * (dot(dir, pos) - (phase * _Time.y));

            float peak = _Steepness/wL;
            pos.x += dir.x * (peak * cos(disp));
            pos.y = peak * sin(disp);
            pos.z += dir.y * (peak * cos(disp));

            v.vertex.xyz = pos;
        }
 
        void surf (Input In, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, In.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal (tex2D (_NormalMap, In.uv_NormalMap));
     // Metallic and smoothness come from slider variables
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;   
        }
 
        ENDCG
    }
    FallBack "Diffuse"
}