// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "beffio/Medieval_Kingdom/SRP/LW/Fabric"
{
    Properties
    {
		_Stripe_1_color("Stripe_1_color", Color) = (1,1,1,0)
		_Stripe_2_color("Stripe_2_color", Color) = (0.8901961,0.5607843,0.372549,0)
		_Stripe_3_color("Stripe_3_color", Color) = (0.8352942,0.3215686,0.282353,0)
		_Folds_AO_multiply("Folds_AO_multiply", Range( 0 , 2)) = 0.5
		_Stripes_tiling("Stripes_tiling", Range( 0 , 50)) = 1
		_Folds_tiling_shift("Folds_tiling_shift", Range( 1 , 10)) = 1
		_Smoothness_shift("Smoothness_shift", Range( 0 , 2)) = 1
		_Wind_level("Wind_level", Range( 0 , 0.2)) = 0
		_Wind_Speed("Wind_Speed", Range( 0 , 10)) = 2
		_Normal_level("Normal_level", Range( 0 , 2)) = 1
		_Holes_tiling("Holes_tiling", Range( 0.1 , 2)) = 1
		_Holes_amount("Holes_amount", Range( 0 , 1)) = 1
		_Stripe1("Stripe1", 2D) = "white" {}
		_Stripe2("Stripe2", 2D) = "white" {}
		_Stripe3("Stripe3", 2D) = "white" {}
		_Normalmapinput("Normal map input", 2D) = "bump" {}
		_fabric_metal_smooth("fabric_metal_smooth", 2D) = "white" {}
		_Fabric_holes("Fabric_holes", 2D) = "white" {}
		_Wind_noise("Wind_noise", 2D) = "white" {}
		_fabric_folds_AO("fabric_folds_AO", 2D) = "white" {}
    }

    SubShader
    {
        Tags { "RenderPipeline"="LightweightPipeline" "RenderType"="TransparentCutout" "Queue"="Transparent" }

		Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL
		
        Pass
        {
			
        	Tags { "LightMode"="LightweightForward" }

        	Name "Base"
			Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
			ZWrite On
			ZTest LEqual
			Offset 0 , 0
			ColorMask RGBA
            
        	HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            

        	// -------------------------------------
            // Lightweight Pipeline keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile _ _SHADOWS_SOFT
            #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
            
        	// -------------------------------------
            // Unity defined keywords
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile_fog

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex vert
        	#pragma fragment frag

        	#define _NORMALMAP 1
        	#define _AlphaClip 1


        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"

            CBUFFER_START(UnityPerMaterial)
			sampler2D _Wind_noise;
			float _Wind_Speed;
			float _Wind_level;
			float4 _Stripe_3_color;
			sampler2D _Stripe3;
			float _Stripes_tiling;
			float4 _Stripe_1_color;
			sampler2D _Stripe1;
			float4 _Stripe_2_color;
			sampler2D _Stripe2;
			sampler2D _fabric_folds_AO;
			float _Folds_tiling_shift;
			float _Folds_AO_multiply;
			float _Normal_level;
			sampler2D _Normalmapinput;
			sampler2D _fabric_metal_smooth;
			float _Smoothness_shift;
			sampler2D _Fabric_holes;
			float _Holes_tiling;
			float _Holes_amount;
			CBUFFER_END
			
			
            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 ase_normal : NORMAL;
                float4 ase_tangent : TANGENT;
                float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

        	struct GraphVertexOutput
            {
                float4 clipPos                : SV_POSITION;
                float4 lightmapUVOrVertexSH	  : TEXCOORD0;
        		half4 fogFactorAndVertexLight : TEXCOORD1; // x: fogFactor, yzw: vertex light
            	float4 shadowCoord            : TEXCOORD2;
				float4 tSpace0					: TEXCOORD3;
				float4 tSpace1					: TEXCOORD4;
				float4 tSpace2					: TEXCOORD5;
				float4 ase_texcoord7 : TEXCOORD7;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            	UNITY_VERTEX_OUTPUT_STEREO
            };


            GraphVertexOutput vert (GraphVertexInput v)
        	{
        		GraphVertexOutput o = (GraphVertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
            	UNITY_TRANSFER_INSTANCE_ID(v, o);
        		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 uv157 = v.ase_texcoord * float2( 1,1 ) + float2( 0,0 );
				float2 panner160 = ( ( _Time.x * _Wind_Speed ) * float2( 0.5,0.5 ) + uv157);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float4 lerpResult178 = lerp( ( tex2Dlod( _Wind_noise, float4( panner160, 0, 0.0) ) * _Wind_level ) , float4( 0,0,0,0 ) , saturate( ( pow( ( saturate( ase_worldNormal.y ) + 0.5941271 ) , (1.0 + (0.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0)) ) * 1.0 ) ));
				float4 _wind185 = lerpResult178;
				
				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				v.vertex.xyz += _wind185.rgb;
				v.ase_normal =  v.ase_normal ;

        		// Vertex shader outputs defined by graph
                float3 lwWNormal = TransformObjectToWorldNormal(v.ase_normal);
				float3 lwWorldPos = TransformObjectToWorld(v.vertex.xyz);
				float3 lwWTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				float3 lwWBinormal = normalize(cross(lwWNormal, lwWTangent) * v.ase_tangent.w);
				o.tSpace0 = float4(lwWTangent.x, lwWBinormal.x, lwWNormal.x, lwWorldPos.x);
				o.tSpace1 = float4(lwWTangent.y, lwWBinormal.y, lwWNormal.y, lwWorldPos.y);
				o.tSpace2 = float4(lwWTangent.z, lwWBinormal.z, lwWNormal.z, lwWorldPos.z);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(v.vertex.xyz);
                
         		// We either sample GI from lightmap or SH.
        	    // Lightmap UV and vertex SH coefficients use the same interpolator ("float2 lightmapUV" for lightmap or "half3 vertexSH" for SH)
                // see DECLARE_LIGHTMAP_OR_SH macro.
        	    // The following funcions initialize the correct variable with correct data
        	    OUTPUT_LIGHTMAP_UV(v.texcoord1, unity_LightmapST, o.lightmapUVOrVertexSH.xy);
        	    OUTPUT_SH(lwWNormal, o.lightmapUVOrVertexSH.xyz);

        	    half3 vertexLight = VertexLighting(vertexInput.positionWS, lwWNormal);
        	    half fogFactor = ComputeFogFactor(vertexInput.positionCS.z);
        	    o.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
        	    o.clipPos = vertexInput.positionCS;

        	#ifdef _MAIN_LIGHT_SHADOWS
        		o.shadowCoord = GetShadowCoord(vertexInput);
        	#endif
        		return o;
        	}

        	half4 frag (GraphVertexOutput IN ) : SV_Target
            {
            	UNITY_SETUP_INSTANCE_ID(IN);

        		float3 WorldSpaceNormal = normalize(float3(IN.tSpace0.z,IN.tSpace1.z,IN.tSpace2.z));
				float3 WorldSpaceTangent = float3(IN.tSpace0.x,IN.tSpace1.x,IN.tSpace2.x);
				float3 WorldSpaceBiTangent = float3(IN.tSpace0.y,IN.tSpace1.y,IN.tSpace2.y);
				float3 WorldSpacePosition = float3(IN.tSpace0.w,IN.tSpace1.w,IN.tSpace2.w);
				float3 WorldSpaceViewDirection = SafeNormalize( _WorldSpaceCameraPos.xyz  - WorldSpacePosition );
    
				float2 temp_cast_0 = (_Stripes_tiling).xx;
				float2 uv127 = IN.ase_texcoord7.xy * temp_cast_0 + float2( 0,0 );
				float4 lerpResult92 = lerp( float4( 0,0,0,0 ) , _Stripe_3_color , tex2D( _Stripe3, uv127 ));
				float4 lerpResult85 = lerp( float4( 0,0,0,0 ) , _Stripe_1_color , tex2D( _Stripe1, uv127 ));
				float4 lerpResult89 = lerp( float4( 0,0,0,0 ) , _Stripe_2_color , tex2D( _Stripe2, uv127 ));
				float4 blendOpSrc96 = lerpResult85;
				float4 blendOpDest96 = lerpResult89;
				float4 blendOpSrc97 = lerpResult92;
				float4 blendOpDest97 = ( saturate( ( 0.5 - 2.0 * ( blendOpSrc96 - 0.5 ) * ( blendOpDest96 - 0.5 ) ) ));
				float4 temp_output_97_0 = ( saturate( ( blendOpSrc97 + blendOpDest97 ) ));
				float2 temp_cast_1 = (_Folds_tiling_shift).xx;
				float2 uv135 = IN.ase_texcoord7.xy * temp_cast_1 + float2( 0,0 );
				float2 _pattern_tiling200 = uv135;
				float4 _AO189 = tex2D( _fabric_folds_AO, _pattern_tiling200 );
				float4 blendOpSrc103 = float4(1,1,1,0);
				float4 blendOpDest103 = _AO189;
				float4 lerpResult107 = lerp( temp_output_97_0 , float4(0,0,0,0) , ( ( saturate( abs( blendOpSrc103 - blendOpDest103 ) )) * _Folds_AO_multiply ));
				float4 blendOpSrc108 = temp_output_97_0;
				float4 blendOpDest108 = lerpResult107;
				float4 _albedo192 = ( saturate( min( blendOpSrc108 , blendOpDest108 ) ));
				
				float3 _normal194 = UnpackNormalmapRGorAG( tex2D( _Normalmapinput, _pattern_tiling200 ), _Normal_level );
				
				float4 _smoothness196 = ( tex2D( _fabric_metal_smooth, _pattern_tiling200 ) * _Smoothness_shift );
				
				float2 temp_cast_5 = (_Holes_tiling).xx;
				float2 uv154 = IN.ase_texcoord7.xy * temp_cast_5 + float2( 0,0 );
				float4 lerpResult150 = lerp( float4(1,1,1,0) , tex2D( _Fabric_holes, uv154 ) , _Holes_amount);
				float4 _holes187 = lerpResult150;
				
				
		        float3 Albedo = _albedo192.rgb;
				float3 Normal = _normal194;
				float3 Emission = 0;
				float3 Specular = float3(0.5, 0.5, 0.5);
				float Metallic = 0;
				float Smoothness = _smoothness196.r;
				float Occlusion = _AO189.r;
				float Alpha = _holes187.r;
				float AlphaClipThreshold = 0.5;

        		InputData inputData;
        		inputData.positionWS = WorldSpacePosition;

        #ifdef _NORMALMAP
        	    inputData.normalWS = normalize(TransformTangentToWorld(Normal, half3x3(WorldSpaceTangent, WorldSpaceBiTangent, WorldSpaceNormal)));
        #else
            #if !SHADER_HINT_NICE_QUALITY
                inputData.normalWS = WorldSpaceNormal;
            #else
        	    inputData.normalWS = normalize(WorldSpaceNormal);
            #endif
        #endif

        #if !SHADER_HINT_NICE_QUALITY
        	    // viewDirection should be normalized here, but we avoid doing it as it's close enough and we save some ALU.
        	    inputData.viewDirectionWS = WorldSpaceViewDirection;
        #else
        	    inputData.viewDirectionWS = normalize(WorldSpaceViewDirection);
        #endif

        	    inputData.shadowCoord = IN.shadowCoord;

        	    inputData.fogCoord = IN.fogFactorAndVertexLight.x;
        	    inputData.vertexLighting = IN.fogFactorAndVertexLight.yzw;
        	    inputData.bakedGI = SAMPLE_GI(IN.lightmapUVOrVertexSH.xy, IN.lightmapUVOrVertexSH.xyz, inputData.normalWS);

        		half4 color = LightweightFragmentPBR(
        			inputData, 
        			Albedo, 
        			Metallic, 
        			Specular, 
        			Smoothness, 
        			Occlusion, 
        			Emission, 
        			Alpha);

			#ifdef TERRAIN_SPLAT_ADDPASS
				color.rgb = MixFogColor(color.rgb, half3( 0, 0, 0 ), IN.fogFactorAndVertexLight.x );
			#else
				color.rgb = MixFog(color.rgb, IN.fogFactorAndVertexLight.x);
			#endif

        #if _AlphaClip
        		clip(Alpha - AlphaClipThreshold);
        #endif

		#if ASE_LW_FINAL_COLOR_ALPHA_MULTIPLY
				color.rgb *= color.a;
		#endif
        		return color;
            }

        	ENDHLSL
        }

		
        Pass
        {
			
        	Name "ShadowCaster"
            Tags { "LightMode"="ShadowCaster" }

			ZWrite On
			ZTest LEqual

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            #define _AlphaClip 1


            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

            CBUFFER_START(UnityPerMaterial)
			sampler2D _Wind_noise;
			float _Wind_Speed;
			float _Wind_level;
			sampler2D _Fabric_holes;
			float _Holes_tiling;
			float _Holes_amount;
			CBUFFER_END
			
			
            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                float4 ase_texcoord7 : TEXCOORD7;
                UNITY_VERTEX_INPUT_INSTANCE_ID
        	};

            // x: global clip space bias, y: normal world space bias
            float4 _ShadowBias;
            float3 _LightDirection;

            VertexOutput ShadowPassVertex(GraphVertexInput v)
        	{
        	    VertexOutput o;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);

				float2 uv157 = v.ase_texcoord * float2( 1,1 ) + float2( 0,0 );
				float2 panner160 = ( ( _Time.x * _Wind_Speed ) * float2( 0.5,0.5 ) + uv157);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float4 lerpResult178 = lerp( ( tex2Dlod( _Wind_noise, float4( panner160, 0, 0.0) ) * _Wind_level ) , float4( 0,0,0,0 ) , saturate( ( pow( ( saturate( ase_worldNormal.y ) + 0.5941271 ) , (1.0 + (0.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0)) ) * 1.0 ) ));
				float4 _wind185 = lerpResult178;
				
				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;

				v.vertex.xyz += _wind185.rgb;
				v.ase_normal =  v.ase_normal ;

        	    float3 positionWS = TransformObjectToWorld(v.vertex.xyz);
                float3 normalWS = TransformObjectToWorldDir(v.ase_normal);

                float invNdotL = 1.0 - saturate(dot(_LightDirection, normalWS));
                float scale = invNdotL * _ShadowBias.y;

                // normal bias is negative since we want to apply an inset normal offset
                positionWS = normalWS * scale.xxx + positionWS;
                float4 clipPos = TransformWorldToHClip(positionWS);

                // _ShadowBias.x sign depens on if platform has reversed z buffer
                clipPos.z += _ShadowBias.x;

        	#if UNITY_REVERSED_Z
        	    clipPos.z = min(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
        	#else
        	    clipPos.z = max(clipPos.z, clipPos.w * UNITY_NEAR_CLIP_VALUE);
        	#endif
                o.clipPos = clipPos;

        	    return o;
        	}

            half4 ShadowPassFragment(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

               float2 temp_cast_0 = (_Holes_tiling).xx;
               float2 uv154 = IN.ase_texcoord7.xy * temp_cast_0 + float2( 0,0 );
               float4 lerpResult150 = lerp( float4(1,1,1,0) , tex2D( _Fabric_holes, uv154 ) , _Holes_amount);
               float4 _holes187 = lerpResult150;
               

				float Alpha = _holes187.r;
				float AlphaClipThreshold = 0.5;

         #if _AlphaClip
        		clip(Alpha - AlphaClipThreshold);
        #endif
                return 0;
            }

            ENDHLSL
        }

		
        Pass
        {
			
        	Name "DepthOnly"
            Tags { "LightMode"="DepthOnly" }

            ZWrite On
			ColorMask 0

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x

            //--------------------------------------
            // GPU Instancing
            #pragma multi_compile_instancing

            #pragma vertex vert
            #pragma fragment frag

            #define _AlphaClip 1


            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			CBUFFER_START(UnityPerMaterial)
			sampler2D _Wind_noise;
			float _Wind_Speed;
			float _Wind_level;
			sampler2D _Fabric_holes;
			float _Holes_tiling;
			float _Holes_amount;
			CBUFFER_END
			
			
           
            struct GraphVertexInput
            {
                float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
        	};

            VertexOutput vert(GraphVertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float2 uv157 = v.ase_texcoord * float2( 1,1 ) + float2( 0,0 );
				float2 panner160 = ( ( _Time.x * _Wind_Speed ) * float2( 0.5,0.5 ) + uv157);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float4 lerpResult178 = lerp( ( tex2Dlod( _Wind_noise, float4( panner160, 0, 0.0) ) * _Wind_level ) , float4( 0,0,0,0 ) , saturate( ( pow( ( saturate( ase_worldNormal.y ) + 0.5941271 ) , (1.0 + (0.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0)) ) * 1.0 ) ));
				float4 _wind185 = lerpResult178;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;

				v.vertex.xyz += _wind185.rgb;
				v.ase_normal =  v.ase_normal ;

        	    o.clipPos = TransformObjectToHClip(v.vertex.xyz);
        	    return o;
            }

            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

				float2 temp_cast_0 = (_Holes_tiling).xx;
				float2 uv154 = IN.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
				float4 lerpResult150 = lerp( float4(1,1,1,0) , tex2D( _Fabric_holes, uv154 ) , _Holes_amount);
				float4 _holes187 = lerpResult150;
				

				float Alpha = _holes187.r;
				float AlphaClipThreshold = 0.5;

         #if _AlphaClip
        		clip(Alpha - AlphaClipThreshold);
        #endif
                return 0;
            }
            ENDHLSL
        }

        // This pass it not used during regular rendering, only for lightmap baking.
		
        Pass
        {
			
        	Name "Meta"
            Tags { "LightMode"="Meta" }

            Cull Off

            HLSLPROGRAM
            // Required to compile gles 2.0 with standard srp library
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            

            #pragma vertex vert
            #pragma fragment frag


            #define _AlphaClip 1


			uniform float4 _MainTex_ST;

            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			CBUFFER_START(UnityPerMaterial)
			sampler2D _Wind_noise;
			float _Wind_Speed;
			float _Wind_level;
			float4 _Stripe_3_color;
			sampler2D _Stripe3;
			float _Stripes_tiling;
			float4 _Stripe_1_color;
			sampler2D _Stripe1;
			float4 _Stripe_2_color;
			sampler2D _Stripe2;
			sampler2D _fabric_folds_AO;
			float _Folds_tiling_shift;
			float _Folds_AO_multiply;
			sampler2D _Fabric_holes;
			float _Holes_tiling;
			float _Holes_amount;
			CBUFFER_END
			
			
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature EDITOR_VISUALIZATION


            struct GraphVertexInput
            {
                float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                float4 ase_texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
        	};

            VertexOutput vert(GraphVertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float2 uv157 = v.ase_texcoord * float2( 1,1 ) + float2( 0,0 );
				float2 panner160 = ( ( _Time.x * _Wind_Speed ) * float2( 0.5,0.5 ) + uv157);
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				float4 lerpResult178 = lerp( ( tex2Dlod( _Wind_noise, float4( panner160, 0, 0.0) ) * _Wind_level ) , float4( 0,0,0,0 ) , saturate( ( pow( ( saturate( ase_worldNormal.y ) + 0.5941271 ) , (1.0 + (0.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0)) ) * 1.0 ) ));
				float4 _wind185 = lerpResult178;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;

				v.vertex.xyz += _wind185.rgb;
				v.ase_normal =  v.ase_normal ;
				
                o.clipPos = MetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST);
        	    return o;
            }

            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

           		float2 temp_cast_0 = (_Stripes_tiling).xx;
           		float2 uv127 = IN.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
           		float4 lerpResult92 = lerp( float4( 0,0,0,0 ) , _Stripe_3_color , tex2D( _Stripe3, uv127 ));
           		float4 lerpResult85 = lerp( float4( 0,0,0,0 ) , _Stripe_1_color , tex2D( _Stripe1, uv127 ));
           		float4 lerpResult89 = lerp( float4( 0,0,0,0 ) , _Stripe_2_color , tex2D( _Stripe2, uv127 ));
           		float4 blendOpSrc96 = lerpResult85;
           		float4 blendOpDest96 = lerpResult89;
           		float4 blendOpSrc97 = lerpResult92;
           		float4 blendOpDest97 = ( saturate( ( 0.5 - 2.0 * ( blendOpSrc96 - 0.5 ) * ( blendOpDest96 - 0.5 ) ) ));
           		float4 temp_output_97_0 = ( saturate( ( blendOpSrc97 + blendOpDest97 ) ));
           		float2 temp_cast_1 = (_Folds_tiling_shift).xx;
           		float2 uv135 = IN.ase_texcoord.xy * temp_cast_1 + float2( 0,0 );
           		float2 _pattern_tiling200 = uv135;
           		float4 _AO189 = tex2D( _fabric_folds_AO, _pattern_tiling200 );
           		float4 blendOpSrc103 = float4(1,1,1,0);
           		float4 blendOpDest103 = _AO189;
           		float4 lerpResult107 = lerp( temp_output_97_0 , float4(0,0,0,0) , ( ( saturate( abs( blendOpSrc103 - blendOpDest103 ) )) * _Folds_AO_multiply ));
           		float4 blendOpSrc108 = temp_output_97_0;
           		float4 blendOpDest108 = lerpResult107;
           		float4 _albedo192 = ( saturate( min( blendOpSrc108 , blendOpDest108 ) ));
           		
           		float2 temp_cast_3 = (_Holes_tiling).xx;
           		float2 uv154 = IN.ase_texcoord.xy * temp_cast_3 + float2( 0,0 );
           		float4 lerpResult150 = lerp( float4(1,1,1,0) , tex2D( _Fabric_holes, uv154 ) , _Holes_amount);
           		float4 _holes187 = lerpResult150;
           		
				
		        float3 Albedo = _albedo192.rgb;
				float3 Emission = 0;
				float Alpha = _holes187.r;
				float AlphaClipThreshold = 0.5;

         #if _AlphaClip
        		clip(Alpha - AlphaClipThreshold);
        #endif

                MetaInput metaInput = (MetaInput)0;
                metaInput.Albedo = Albedo;
                metaInput.Emission = Emission;
                
                return MetaFragment(metaInput);
            }
            ENDHLSL
        }
    }
    FallBack "Hidden/InternalErrorShader"
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16105
7;7;3426;1364;3880.042;2123.478;1.452841;True;False
Node;AmplifyShaderEditor.CommentaryNode;201;-4736,-1184;Float;False;891.1436;206;Pattern_tilling;3;134;135;200;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;134;-4672,-1120;Float;False;Property;_Folds_tiling_shift;Folds_tiling_shift;5;0;Create;True;0;0;False;0;1;1;1;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;135;-4368,-1136;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;205;-3184,-1184;Float;False;768.9148;241;Ambient_Occlusion_map_input;3;189;138;204;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;180;-4742.574,-2358.325;Float;False;1528.236;1148.619;Stripes_color_and_tiling;13;127;79;96;97;85;89;92;90;91;87;88;86;81;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;200;-4096,-1104;Float;False;_pattern_tiling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;184;-2128,-2352;Float;False;1602.362;875.103;Wind;21;173;172;171;170;168;166;165;169;167;164;185;163;178;162;161;160;159;157;158;156;155;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;204;-3168,-1120;Float;False;200;_pattern_tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;79;-4720,-1936;Float;False;Property;_Stripes_tiling;Stripes_tiling;4;0;Create;True;0;0;False;0;1;0;0;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;127;-4416,-1936;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;138;-2928,-1152;Float;True;Property;_fabric_folds_AO;fabric_folds_AO;19;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;164;-2096,-1824;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SaturateNode;167;-1888,-1824;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;88;-4096,-1952;Float;False;Property;_Stripe_2_color;Stripe_2_color;1;0;Create;True;0;0;False;0;0.8901961,0.5607843,0.372549,0;0.8901961,0.5607843,0.372549,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;165;-2096,-1664;Half;False;Constant;_Float0;Float 0;11;0;Create;True;0;0;False;0;0.5941271;0.3;-1;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;86;-4096,-2304;Float;False;Property;_Stripe_1_color;Stripe_1_color;0;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;166;-2096,-1600;Half;False;Constant;_Float1;Float 1;13;0;Create;True;0;0;False;0;0;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;189;-2624,-1136;Float;False;_AO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;156;-2096,-1904;Float;False;Property;_Wind_Speed;Wind_Speed;8;0;Create;True;0;0;False;0;2;2;0;10;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;87;-4096,-1792;Float;True;Property;_Stripe2;Stripe2;13;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TimeNode;155;-2032,-2064;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;181;-3175.906,-2354.684;Float;False;1001.745;463.8409;Stripes_AO_blend;9;192;108;107;106;105;191;104;102;103;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;81;-4097.6,-2144.071;Float;True;Property;_Stripe1;Stripe1;12;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;89;-3792,-1952;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;91;-4096,-1600;Float;False;Property;_Stripe_3_color;Stripe_3_color;2;0;Create;True;0;0;False;0;0.8352942,0.3215686,0.282353,0;0.8352942,0.3215686,0.282353,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;90;-4096,-1440;Float;True;Property;_Stripe3;Stripe3;14;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-1792,-2048;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;169;-1744,-1824;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;85;-3806.573,-2304;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;157;-1872,-2304;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;183;-2192,-1456;Float;False;1240.759;553.0247;Fabric_holes_mask_map_input;7;187;150;149;141;148;154;153;;1,1,1,1;0;0
Node;AmplifyShaderEditor.TFHCRemapNode;168;-1776,-1664;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;159;-1824,-2176;Float;False;Constant;_Vector0;Vector 0;10;0;Create;True;0;0;False;0;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ColorNode;102;-3108.054,-2297.169;Float;False;Constant;_Color0;Color 0;17;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;191;-3108.054,-2121.168;Float;False;189;_AO;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.PowerNode;170;-1584,-1824;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;160;-1600,-2160;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;171;-1600,-1696;Half;False;Constant;_Wind_top_masking;Wind_top_masking;12;0;Create;True;0;0;False;0;1;0;0;1.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;103;-2900.054,-2297.169;Float;False;Difference;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;92;-3776,-1600;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;153;-2160,-1328;Float;False;Property;_Holes_tiling;Holes_tiling;10;0;Create;True;0;0;False;0;1;1;0.1;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;96;-3568.53,-1735.243;Float;False;Exclusion;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-3124.054,-2025.168;Float;False;Property;_Folds_AO_multiply;Folds_AO_multiply;3;0;Create;True;0;0;False;0;0.5;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-1376,-1824;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;97;-3465.157,-1485.433;Float;False;LinearDodge;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-1376,-1936;Float;False;Property;_Wind_level;Wind_level;7;0;Create;True;0;0;False;0;0;0.15;0;0.2;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;105;-2676.054,-2297.169;Float;False;Constant;_Color1;Color 1;1;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;161;-1376,-2144;Float;True;Property;_Wind_noise;Wind_noise;18;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;106;-2836.054,-2153.169;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;154;-1888,-1216;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;148;-1696,-1008;Float;False;Property;_Holes_amount;Holes_amount;11;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;173;-1232,-1824;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;107;-2676.054,-2057.168;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;141;-1664,-1200;Float;True;Property;_Fabric_holes;Fabric_holes;17;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;163;-1040,-2080;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;149;-1648,-1376;Float;False;Constant;_Color2;Color 2;19;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;150;-1344,-1200;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;178;-896,-2080;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;108;-2451.054,-2294.169;Float;False;Darken;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;198;-3168,-1872;Float;False;857.0121;277.7874;Normal_map_input;4;194;133;132;202;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;199;-3168,-1568;Float;False;941.313;362.8423;Smoothness_map_input;5;196;20;21;140;203;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;187;-1184,-1200;Float;False;_holes;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;185;-736,-2080;Float;False;_wind;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;192;-2452.054,-2012.168;Float;False;_albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;196;-2448,-1520;Float;False;_smoothness;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;210;-827.7399,-996.7258;Float;False;Constant;_Float3;Float 3;21;0;Create;True;0;0;False;0;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;133;-2864,-1792;Float;True;Property;_Normalmapinput;Normal map input;15;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;209;-873.3572,-885.9037;Float;False;Constant;_Float2;Float 2;21;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;203;-3152,-1424;Float;False;200;_pattern_tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;186;-928,-1120;Float;False;185;_wind;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;190;-928,-1248;Float;False;189;_AO;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;-3152,-1696;Float;False;200;_pattern_tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-2608,-1520;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;193;-928,-1440;Float;False;192;_albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-2896,-1344;Float;False;Property;_Smoothness_shift;Smoothness_shift;6;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;132;-3152,-1792;Float;False;Property;_Normal_level;Normal_level;9;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;195;-928,-1376;Float;False;194;_normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;194;-2560,-1792;Float;False;_normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;197;-928,-1312;Float;False;196;_smoothness;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;140;-2912,-1520;Float;True;Property;_fabric_metal_smooth;fabric_metal_smooth;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;188;-928,-1184;Float;False;187;_holes;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;215;-599,-1440;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;0;3;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;;0;0;Standard;0;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;214;-599,-1440;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;;0;0;Standard;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;212;-599,-1440;Float;False;True;2;Float;ASEMaterialInspector;0;2;beffio/Medieval_Kingdom/SRP/LW/Fabric;1976390536c6c564abb90fe41f6ee334;0;0;Base;11;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=TransparentCutout=RenderType;Queue=Transparent=Queue=0;True;2;0;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=LightweightForward;False;0;;0;0;Standard;1;_FinalColorxAlpha;0;11;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;9;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT3;0,0,0;False;10;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;213;-599,-1440;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;;0;0;Standard;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;0
WireConnection;135;0;134;0
WireConnection;200;0;135;0
WireConnection;127;0;79;0
WireConnection;138;1;204;0
WireConnection;167;0;164;2
WireConnection;189;0;138;0
WireConnection;87;1;127;0
WireConnection;81;1;127;0
WireConnection;89;1;88;0
WireConnection;89;2;87;0
WireConnection;90;1;127;0
WireConnection;158;0;155;1
WireConnection;158;1;156;0
WireConnection;169;0;167;0
WireConnection;169;1;165;0
WireConnection;85;1;86;0
WireConnection;85;2;81;0
WireConnection;168;0;166;0
WireConnection;170;0;169;0
WireConnection;170;1;168;0
WireConnection;160;0;157;0
WireConnection;160;2;159;0
WireConnection;160;1;158;0
WireConnection;103;0;102;0
WireConnection;103;1;191;0
WireConnection;92;1;91;0
WireConnection;92;2;90;0
WireConnection;96;0;85;0
WireConnection;96;1;89;0
WireConnection;172;0;170;0
WireConnection;172;1;171;0
WireConnection;97;0;92;0
WireConnection;97;1;96;0
WireConnection;161;1;160;0
WireConnection;106;0;103;0
WireConnection;106;1;104;0
WireConnection;154;0;153;0
WireConnection;173;0;172;0
WireConnection;107;0;97;0
WireConnection;107;1;105;0
WireConnection;107;2;106;0
WireConnection;141;1;154;0
WireConnection;163;0;161;0
WireConnection;163;1;162;0
WireConnection;150;0;149;0
WireConnection;150;1;141;0
WireConnection;150;2;148;0
WireConnection;178;0;163;0
WireConnection;178;2;173;0
WireConnection;108;0;97;0
WireConnection;108;1;107;0
WireConnection;187;0;150;0
WireConnection;185;0;178;0
WireConnection;192;0;108;0
WireConnection;196;0;20;0
WireConnection;133;1;202;0
WireConnection;133;5;132;0
WireConnection;20;0;140;0
WireConnection;20;1;21;0
WireConnection;194;0;133;0
WireConnection;140;1;203;0
WireConnection;212;0;193;0
WireConnection;212;1;195;0
WireConnection;212;4;197;0
WireConnection;212;5;190;0
WireConnection;212;6;188;0
WireConnection;212;7;210;0
WireConnection;212;8;186;0
ASEEND*/
//CHKSM=DBE75B98C360FCCDD797F83894BB96CD3401B355