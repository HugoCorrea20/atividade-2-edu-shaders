Shader "Custom/TransparentGlass" {
    Properties {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0
        _Normal ("Normal", 2D) = "bump" {}
        _EnvMap ("Environment Map", CUBE) = "" {}
        _Opacity ("Opacity", Range(0,1)) = 0.5
    }
    
    SubShader {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 200
        
        CGPROGRAM
        #pragma surface surf Standard fullforwardshadows alpha
        #pragma target 3.0
        
        sampler2D _MainTex;
        sampler2D _Normal;
        samplerCUBE _EnvMap;
        
        struct Input {
            float2 uv_MainTex;
            float2 uv_Normal;
            INTERNAL_DATA
            float3 worldRefl;
        };
        
        half _Glossiness;
        half _Metallic;
        half _Opacity;
        fixed4 _Color;
        
        UNITY_INSTANCING_BUFFER_START(Props)
        UNITY_INSTANCING_BUFFER_END(Props)
        
        void surf (Input IN, inout SurfaceOutputStandard o) {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * 0.5 * _Color;
            float3 n = tex2D(_Normal, IN.uv_Normal);
            o.Emission = texCUBE(_EnvMap, IN.worldRefl * n).rgb;
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a * _Opacity;
        }
        ENDCG
    }
    
    Fallback "Diffuse"
}
