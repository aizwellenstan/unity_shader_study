Shader "Unlit/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainTex1 ("Texture1", 2D) = "white" {}
        _Color ("Color", Color) = (0,0,0,0)      
        _Slider ("Color", Range(0.0, 0.1)) = 0.0

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            sampler2D _MainTex1;
            float4 _MainTex_ST;
            fixed4 _Color;
            fixed  _Slider;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i, fixed facing : VFACE) : SV_Target
            {
                float3 offset = float3(_Slider, -_Slider, 0);
                fixed4 col = tex2D(_MainTex, i.uv + offset.yy);
                col += tex2D(_MainTex, i.uv + offset.zy)*2; 
                col += tex2D(_MainTex, i.uv + offset.xy); 
                col += tex2D(_MainTex, i.uv + offset.yz)*2;
                col += tex2D(_MainTex, i.uv)*4;
                col += tex2D(_MainTex, i.uv + offset.rb)*2;
                col += tex2D(_MainTex, i.uv + offset.yx);
                col += tex2D(_MainTex, i.uv + offset.zx)*2;
                col += tex2D(_MainTex, i.uv + offset.xx);

                return facing > 0 ? col / 16 : tex2D(_MainTex, i.uv);
            }
            ENDCG
        }
    }
}
