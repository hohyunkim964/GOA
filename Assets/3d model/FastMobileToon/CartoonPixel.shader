Shader "SupGames/CartoonPixel" {
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
				fixed2 uv : TEXCOORD0;
				fixed4 posWorld : TEXCOORD1;
				fixed4 normalDir : TEXCOORD2;
			};

			v2f vert(appdata i)
			{
				v2f o;
				o.posWorld = mul(unity_ObjectToWorld, i.vertex);
				o.normalDir.xyz = normalize(mul(float4(i.normal, 0.0), unity_WorldToObject).xyz);
				o.normalDir.w=max(0.0h, dot(o.normalDir, _WorldSpaceLightPos0.xyz));
				o.pos = UnityObjectToClipPos(i.vertex);
				o.uv = TRANSFORM_TEX(i.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				fixed3 viewDirection = normalize(_WorldSpaceCameraPos - i.posWorld.xyz);

				if (dot(viewDirection, i.normalDir.xyz) < lerp(_UnlitOutline, _LitOutline,i.normalDir.w))
				{
					col.rgb = _LightColor0.rgb * _Outline.rgb;
				}

				if (i.normalDir.w > 0.0h  && pow(max(0.0h,dot(reflect(-_WorldSpaceLightPos0.xyz, i.normalDir.xyz), viewDirection)), _Brightness) > 0.5h)
				{
					col.rgb = _Specular.a  * _LightColor0.rgb * _Specular.rgb  + (1.0 - _Specular.a) * col.rgb;
				}
				return col;
			}
			ENDCG
		}
	}
	Fallback "Specular"
}