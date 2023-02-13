Shader "SupGames/CartoonVertex" {
	Properties{
		_MainTex("Texture", 2D) = "white" {}
		_Outline("Outline Color", Color) = (0,0,0,0.5)
		_LitOutline("Lit Outline Width", Range(0,1)) = 0.1
		_UnlitOutline("Unlit Outline Width", Range(0,1))= 0.3
		_Specular("Specular Color", Color) = (1,1,1,1)
		_Brightness("Brightness", Float) = 10
	}
	SubShader{
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM

			#pragma vertex vert  
			#pragma fragment frag 
			#pragma fragmentoption ARB_precision_hint_fastest

			#include "UnityCG.cginc"
			uniform fixed4 _LightColor0;
			uniform fixed4 _Outline;
			uniform fixed _LitOutline;
			uniform fixed _UnlitOutline;
			uniform fixed4 _Specular;
			uniform float _Brightness;
			sampler2D _MainTex;
			fixed4 _MainTex_ST;

			struct appdata {
				fixed4 vertex : POSITION;
				fixed3 normal : NORMAL;
				fixed2 uv : TEXCOORD0;
			};
			struct v2f {
				fixed4 pos : SV_POSITION;
				fixed4 uv : TEXCOORD0;
				fixed uv1: TEXCOORD1;
			};

			v2f vert(appdata i)
			{
				v2f o;
				fixed4 posWorld = mul(unity_ObjectToWorld, i.vertex);
				fixed3 normalDir = normalize(mul(float4(i.normal, 0.0h), unity_WorldToObject).xyz);
				fixed temp=max(0.0h, dot(normalDir, _WorldSpaceLightPos0.xyz));
				fixed3 viewDir=normalize(_WorldSpaceCameraPos - posWorld.xyz);
				o.uv.xy = TRANSFORM_TEX(i.uv, _MainTex);
				o.uv.w=dot(viewDir, normalDir);
				o.uv.z=normalDir;
				o.uv1=pow(max(0.0h,dot(reflect(-_WorldSpaceLightPos0.xyz, normalDir), viewDir)), _Brightness);
				o.pos = UnityObjectToClipPos(i.vertex);
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 col = tex2D(_MainTex, i.uv.xy);
 
				if (i.uv.w < lerp(_UnlitOutline, _LitOutline,i.uv.z))
				{
					col.rgb = _LightColor0.rgb * _Outline.rgb;
				}

				if (i.uv1 > 0.5h)
				{
					col.rgb = _Specular.a  * _LightColor0.rgb * _Specular.rgb  + (1.0h - _Specular.a) * col.rgb;
				}
				return col;
			}
			ENDCG
		}
	}
	Fallback "Specular"
}