Shader "Ashwin Mods/BrushStroke"
{
    Properties
    {
        _BrushTex("Brush Tex", 2D) = "Black" {}
        _Mul("Brush Mul", vector) = (0,0,0,0)
    }
    
    SubShader
    {
        Pass
        {
            Blend one one
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _BrushTex_ST;
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BrushTex);
                return o;
            }

            sampler2D _BrushTex;
            float4 _Mul;
            fixed4 frag(v2f i) : SV_Target
            {
                if (i.uv.x < 0 || i.uv.y < 0
                || i.uv.x > 1 || i.uv.y > 1)
                discard;
                return tex2D(_BrushTex, i.uv).r * _Mul;
            }
            ENDCG
        }

        Pass
        {
            BlendOp RevSub
            Blend one one
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
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            float4 _BrushTex_ST;
            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _BrushTex);
                return o;
            }

            sampler2D _BrushTex;
            float4 _Mul;
            fixed4 frag(v2f i) : SV_Target
            {
                if (i.uv.x < 0 || i.uv.y < 0
                || i.uv.x > 1 || i.uv.y > 1)
                discard;
                return tex2D(_BrushTex, i.uv).r * _Mul;
            }
            ENDCG
        }

    }
}