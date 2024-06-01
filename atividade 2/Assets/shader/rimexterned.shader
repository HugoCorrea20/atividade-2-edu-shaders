Shader "Custom/rimexterned"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _RimColor("Rim color", Color) = (1.0,1.0,1.0,0.0)
       // _RimConcretation("Rim Concretation", range (0.5,5.0)) =0.9
        _RimStrength("Rim Strength", range ( 1.0,4.0)) =1.45
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

          sampler2D _NormalMap;

        sampler2D _MainTex;
        float4 _RimColor;
        float _RimConcretation;
        float _RimStrength;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_NormalMap;
            float viewDir;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            float lc = saturate (dot(normalize(IN.viewDir),o.Normal));
            half Rim =1.0 - lc;
            o.Albedo = c.rgb;
             o.Normal = UnpackNormal (tex2D (_NormalMap, IN.uv_NormalMap));
            // Metallic and smoothness come from slider variables
            //o.Emission = _RimColor.rgb * pow(Rim, _RimConcretation);
            o.Emission = _RimStrength * (_RimColor.rgb * smoothstep(0.2,0.6, Rim));
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
