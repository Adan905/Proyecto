Shader "Custom/SDNormalMap"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _NormalTex("Normal Texture", 2D)= "bump" {}
    }

    Subshader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf Lambert

            sampler2D _MainTex;
            sampler2D _NormalTex;

            struct Input
            {
                float2 uv_MainTex;
                float2 uv_NormalTex;
            };

            void surf(Input IN, inout SurfaceOutput o)
            {
                fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = texColor.rgb;
                fixed4 normalColor = tex2D(_NormalTex,IN.uv_NormalTex);
                fixed3 normal = UnpackNormal(normalColor);
                o.Normal = normal;
            }
        ENDCG
    }
}