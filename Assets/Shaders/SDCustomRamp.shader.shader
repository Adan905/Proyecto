Shader "Custom/Ramp"
{
    Properties{
         _Albedo("Albedo Color", Color) = (1,1,1,1)
         _RampTex("Ramp Texture", 2D) ="white"{}
        [HDR] _RimColor("Rim Color", Color) = (1, 0, 0, 1)
         _RimPower("Rim Power",  Range(0, 5)) = 1.0

         _MainTex("Main Texture", 2D) = "White"{}
        _NormalTex("Normal Texture",2D)="bump"{}
        _NormalStrength("Normal Strength", Range(-5, 5)) = 1
    }

    SubShader{
        Tags
        {
            "Queue" = "Geometry"
            "RenderType" = "Opaque"
        }

        CGPROGRAM
            #pragma surface surf Ramp
            sampler2D _RampTex;
            half4 LightingRamp(SurfaceOutput s, half3 lightDir, half atten){
                half NdotL = dot (s.Normal, lightDir);
                half diff = NdotL * 0.5 + 0.5;
                float2 uv_RampTex = float2(diff,0);
                half3 rampColor = tex2D(_RampTex, uv_RampTex).rgb;
                half4 c;
                c.rgb = s.Albedo * _LightColor0.rgb * atten * rampColor;
                c.a = s.Alpha;
                return c;
            }
            sampler2D _MainTex;
            sampler2D _NormalTex;
            float _NormalStrength;
            half4 _Albedo; 
            half3 _RimColor;
            float _RimPower;

            struct Input{
                float2 uv_MainTex;
                float2 uv_NormalTex;
                float a;
                float3 viewDir;
            };
            void surf(Input IN, inout SurfaceOutput o){
                
                o.Albedo =  _Albedo.rgb;
                fixed4 texColor = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = texColor.rgb * _Albedo;
                fixed4 normalColor = tex2D(_NormalTex,IN.uv_MainTex);
                fixed3 normal = UnpackNormal(normalColor).rgb;
                normal.z = normal.z / _NormalStrength;
                o.Normal = normalize(normal);

                float3 nVD = normalize(IN.viewDir);
                float3 NdotV = dot(nVD, o.Normal);
                half rim = 1 - saturate(NdotV);
                o.Emission = _RimColor.rgb * pow(rim, _RimPower);
               
            }
        ENDCG
    }
}