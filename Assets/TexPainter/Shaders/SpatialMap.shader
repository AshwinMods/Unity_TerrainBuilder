Shader "Ashwin Mods/SpatialMap"
{
    Properties
    {
        _MainTex("Spatial Map", 2D) = "black" {}
        _T1("Base Tex", 2D) = "white" {}
        _T2("Red Channel Tex", 2D) = "white" {}
        _T3("Green Channel Tex", 2D) = "white" {}
        _T4("Blue Channel Tex", 2D) = "white" {}
        _T5("Alpha Channel Tex", 2D) = "white" {}
    }
        SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv0 : TEXCOORD0;
                float2 uv1 : TEXCOORD1;
                float2 uv2 : TEXCOORD2;
                float2 uv3 : TEXCOORD3;
                float2 uv4 : TEXCOORD4;
                float2 uv5 : TEXCOORD5;
                float4 vertex : SV_POSITION;
            };

            float4 _T1_ST;
            float4 _T2_ST;
            float4 _T3_ST;
            float4 _T4_ST;
            float4 _T5_ST;
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv0 = v.uv;
                o.uv1 = TRANSFORM_TEX(v.uv, _T1);
                o.uv2 = TRANSFORM_TEX(v.uv, _T2);
                o.uv3 = TRANSFORM_TEX(v.uv, _T3);
                o.uv4 = TRANSFORM_TEX(v.uv, _T4);
                o.uv5 = TRANSFORM_TEX(v.uv, _T5);
                return o;
            }

            sampler2D _MainTex;
            sampler2D _T1;
            sampler2D _T2;
            sampler2D _T3;
            sampler2D _T4;
            sampler2D _T5;
            fixed4 frag(v2f i) : SV_Target
            {
                float4 map = tex2D(_MainTex, i.uv0);
                float4 res = tex2D(_T1, i.uv1);
                res = lerp(res, tex2D(_T2, i.uv2), map.r);
                res = lerp(res, tex2D(_T3, i.uv3), map.g);
                res = lerp(res, tex2D(_T4, i.uv4), map.b);
                res = lerp(res, tex2D(_T5, i.uv5), map.a);
                return res;
            }
            ENDCG
        }
    }
}