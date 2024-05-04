// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "beffio/Medieval_Kingdom/SRP/LW/Stones"
{
    Properties
    {
		_Base_color("Base_color", Color) = (0.3919766,0.4150519,0.4264706,0)
		_Material_Smoothness_shift("Material_Smoothness_shift", Range( 0 , 2)) = 1
		_Edge_color("Edge_color", Color) = (1,1,1,0)
		_Edge_wear("Edge_wear", Range( 0 , 1)) = 0.9960846
		_Detail_1_level("Detail_1_level", Range( 0 , 2)) = 1
		_Detail_color("Detail_color", Color) = (1,1,1,0)
		_Top_Color("Top_Color", Color) = (0.6654717,0.6985294,0.07704367,0)
		_Top_mask_tiling("Top_mask_tiling", Range( 0 , 8)) = 4
		_Top_mask_smoothness_shift("Top_mask_smoothness_shift", Range( 0 , 1)) = 1
		_AO_shift("AO_shift", Range( 0 , 2)) = 1
		_Albedo_smoothness_map_input("Albedo_smoothness_map_input", 2D) = "white" {}
		_Normal_map_input("Normal_map_input", 2D) = "bump" {}
		_Ambient_Occlusion_map_input("Ambient_Occlusion_map_input", 2D) = "white" {}
		_Top_mask_texture("Top_mask_texture", 2D) = "white" {}
		_Top_mask_normal("Top_mask_normal", 2D) = "bump" {}
		_Edge_mask_map_input("Edge_mask_map_input", 2D) = "white" {}
		_Detail_mask_1_map_input("Detail_mask_1_map_input", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
    }

    SubShader
    {
        Tags { "RenderPipeline"="LightweightPipeline" "RenderType"="Opaque" "Queue"="Geometry" }

		Cull Back
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL
		
        Pass
        {
			
        	Tags { "LightMode"="LightweightForward" }

        	Name "Base"
			Blend One Zero
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


        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"

            CBUFFER_START(UnityPerMaterial)
			sampler2D _Albedo_smoothness_map_input;
			float4 _Albedo_smoothness_map_input_ST;
			float4 _Base_color;
			float4 _Detail_color;
			sampler2D _Detail_mask_1_map_input;
			float4 _Detail_mask_1_map_input_ST;
			float _Detail_1_level;
			sampler2D _Normal_map_input;
			float4 _Normal_map_input_ST;
			sampler2D _Ambient_Occlusion_map_input;
			float4 _Ambient_Occlusion_map_input_ST;
			float _AO_shift;
			float4 _Edge_color;
			sampler2D _Edge_mask_map_input;
			float4 _Edge_mask_map_input_ST;
			float _Edge_wear;
			float4 _Top_Color;
			sampler2D _Top_mask_texture;
			float _Top_mask_tiling;
			sampler2D _Top_mask_normal;
			float _Material_Smoothness_shift;
			float _Top_mask_smoothness_shift;
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

				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;
				v.vertex.xyz +=  float3( 0, 0, 0 ) ;
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
    
				float2 uv_Albedo_smoothness_map_input = IN.ase_texcoord7.xy * _Albedo_smoothness_map_input_ST.xy + _Albedo_smoothness_map_input_ST.zw;
				float4 tex2DNode11 = tex2D( _Albedo_smoothness_map_input, uv_Albedo_smoothness_map_input );
				float4 blendOpSrc12 = tex2DNode11;
				float4 blendOpDest12 = _Base_color;
				float4 temp_output_12_0 = ( saturate( (( blendOpDest12 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest12 - 0.5 ) ) * ( 1.0 - blendOpSrc12 ) ) : ( 2.0 * blendOpDest12 * blendOpSrc12 ) ) ));
				float2 uv_Detail_mask_1_map_input = IN.ase_texcoord7.xy * _Detail_mask_1_map_input_ST.xy + _Detail_mask_1_map_input_ST.zw;
				float4 lerpResult221 = lerp( temp_output_12_0 , _Detail_color , ( tex2D( _Detail_mask_1_map_input, uv_Detail_mask_1_map_input ) * _Detail_1_level ));
				float4 blendOpSrc222 = temp_output_12_0;
				float4 blendOpDest222 = lerpResult221;
				float4 temp_output_222_0 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc222 ) * ( 1.0 - blendOpDest222 ) ) ));
				float2 uv_Normal_map_input = IN.ase_texcoord7.xy * _Normal_map_input_ST.xy + _Normal_map_input_ST.zw;
				float3 tex2DNode8 = UnpackNormalmapRGorAG( tex2D( _Normal_map_input, uv_Normal_map_input ), 0.0 );
				float3 _normal265 = tex2DNode8;
				float grayscale237 = (_normal265.r + _normal265.g + _normal265.b) / 3;
				float4 lerpResult241 = lerp( temp_output_222_0 , float4(1,1,1,0) , ( grayscale237 * 1.0 ));
				float4 blendOpSrc242 = temp_output_222_0;
				float4 blendOpDest242 = lerpResult241;
				float4 temp_output_242_0 = ( saturate( (( blendOpDest242 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest242 - 0.5 ) ) * ( 1.0 - blendOpSrc242 ) ) : ( 2.0 * blendOpDest242 * blendOpSrc242 ) ) ));
				float2 uv_Ambient_Occlusion_map_input = IN.ase_texcoord7.xy * _Ambient_Occlusion_map_input_ST.xy + _Ambient_Occlusion_map_input_ST.zw;
				float4 _AO262 = tex2D( _Ambient_Occlusion_map_input, uv_Ambient_Occlusion_map_input );
				float4 blendOpSrc80 = float4(1,1,1,1);
				float4 blendOpDest80 = _AO262;
				float4 lerpResult78 = lerp( temp_output_242_0 , float4(0,0,0,0) , ( ( saturate( abs( blendOpSrc80 - blendOpDest80 ) )) * _AO_shift ));
				float4 blendOpSrc79 = temp_output_242_0;
				float4 blendOpDest79 = lerpResult78;
				float4 temp_output_79_0 = ( saturate( min( blendOpSrc79 , blendOpDest79 ) ));
				float2 uv_Edge_mask_map_input = IN.ase_texcoord7.xy * _Edge_mask_map_input_ST.xy + _Edge_mask_map_input_ST.zw;
				float4 lerpResult70 = lerp( temp_output_79_0 , _Edge_color , ( tex2D( _Edge_mask_map_input, uv_Edge_mask_map_input ) * _Edge_wear ));
				float4 blendOpSrc71 = temp_output_79_0;
				float4 blendOpDest71 = lerpResult70;
				float4 _base_stone_color270 = ( saturate( (( blendOpSrc71 > 0.5 ) ? max( blendOpDest71, 2.0 * ( blendOpSrc71 - 0.5 ) ) : min( blendOpDest71, 2.0 * blendOpSrc71 ) ) ));
				float2 temp_cast_0 = (_Top_mask_tiling).xx;
				float2 uv186 = IN.ase_texcoord7.xy * temp_cast_0 + float2( 0,0 );
				float2 _tiling256 = uv186;
				float4 tex2DNode161 = tex2D( _Top_mask_texture, _tiling256 );
				float4 lerpResult112 = lerp( _Top_Color , float4( 0,0,0,0 ) , tex2DNode161);
				float4 _top_color274 = lerpResult112;
				float3 tanToWorld0 = float3( WorldSpaceTangent.x, WorldSpaceBiTangent.x, WorldSpaceNormal.x );
				float3 tanToWorld1 = float3( WorldSpaceTangent.y, WorldSpaceBiTangent.y, WorldSpaceNormal.y );
				float3 tanToWorld2 = float3( WorldSpaceTangent.z, WorldSpaceBiTangent.z, WorldSpaceNormal.z );
				float3 tanNormal224 = _normal265;
				float3 worldNormal224 = float3(dot(tanToWorld0,tanNormal224), dot(tanToWorld1,tanNormal224), dot(tanToWorld2,tanNormal224));
				float4 temp_cast_1 = (saturate( ( pow( ( saturate( worldNormal224.y ) + 0.0 ) , (1.0 + (0.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0)) ) * 0.0 ) )).xxxx;
				float4 blendOpSrc235 = temp_cast_1;
				float4 blendOpDest235 = tex2DNode161;
				float4 _top_mask276 = ( saturate( (( blendOpSrc235 > 0.5 ) ? max( blendOpDest235, 2.0 * ( blendOpSrc235 - 0.5 ) ) : min( blendOpDest235, 2.0 * blendOpSrc235 ) ) ));
				float4 lerpResult113 = lerp( _base_stone_color270 , _top_color274 , _top_mask276);
				float4 blendOpSrc114 = _base_stone_color270;
				float4 blendOpDest114 = lerpResult113;
				float4 _albedo_top_blend282 = ( saturate( ( 0.5 - 2.0 * ( blendOpSrc114 - 0.5 ) * ( blendOpDest114 - 0.5 ) ) ));
				
				float3 lerpResult173 = lerp( tex2DNode8 , UnpackNormalmapRGorAG( tex2D( _Top_mask_normal, _tiling256 ), 0.0 ) , _top_mask276.rgb);
				float3 _normal_blend263 = lerpResult173;
				
				float lerpResult172 = lerp( ( tex2DNode11.a * _Material_Smoothness_shift ) , ( tex2DNode161.a * _Top_mask_smoothness_shift ) , _top_mask276.r);
				float _smoothness284 = lerpResult172;
				
				
		        float3 Albedo = _albedo_top_blend282.rgb;
				float3 Normal = _normal_blend263;
				float3 Emission = 0;
				float3 Specular = float3(0.5, 0.5, 0.5);
				float Metallic = 0;
				float Smoothness = _smoothness284;
				float Occlusion = _AO262.r;
				float Alpha = 1;
				float AlphaClipThreshold = 0;

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

            

            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

            CBUFFER_START(UnityPerMaterial)
						CBUFFER_END
			
			
            struct GraphVertexInput
            {
                float4 vertex : POSITION;
                float3 ase_normal : NORMAL;
				
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                
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

				

				v.vertex.xyz +=  float3(0,0,0) ;
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

               

				float Alpha = 1;
				float AlphaClipThreshold = AlphaClipThreshold;

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

            

            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			CBUFFER_START(UnityPerMaterial)
						CBUFFER_END
			
			
           
            struct GraphVertexInput
            {
                float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };


        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
        	};

            VertexOutput vert(GraphVertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				

				v.vertex.xyz +=  float3(0,0,0) ;
				v.ase_normal =  v.ase_normal ;

        	    o.clipPos = TransformObjectToHClip(v.vertex.xyz);
        	    return o;
            }

            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

				

				float Alpha = 1;
				float AlphaClipThreshold = AlphaClipThreshold;

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


            

			uniform float4 _MainTex_ST;

            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			CBUFFER_START(UnityPerMaterial)
			sampler2D _Albedo_smoothness_map_input;
			float4 _Albedo_smoothness_map_input_ST;
			float4 _Base_color;
			float4 _Detail_color;
			sampler2D _Detail_mask_1_map_input;
			float4 _Detail_mask_1_map_input_ST;
			float _Detail_1_level;
			sampler2D _Normal_map_input;
			float4 _Normal_map_input_ST;
			sampler2D _Ambient_Occlusion_map_input;
			float4 _Ambient_Occlusion_map_input_ST;
			float _AO_shift;
			float4 _Edge_color;
			sampler2D _Edge_mask_map_input;
			float4 _Edge_mask_map_input_ST;
			float _Edge_wear;
			float4 _Top_Color;
			sampler2D _Top_mask_texture;
			float _Top_mask_tiling;
			CBUFFER_END
			
			
            #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature EDITOR_VISUALIZATION


            struct GraphVertexInput
            {
                float4 vertex : POSITION;
				float3 ase_normal : NORMAL;
				float4 texcoord1 : TEXCOORD1;
				float4 ase_texcoord : TEXCOORD0;
				float4 ase_tangent : TANGENT;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

        	struct VertexOutput
        	{
        	    float4 clipPos      : SV_POSITION;
                float4 ase_texcoord : TEXCOORD0;
                float4 ase_texcoord1 : TEXCOORD1;
                float4 ase_texcoord2 : TEXCOORD2;
                float4 ase_texcoord3 : TEXCOORD3;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
        	};

            VertexOutput vert(GraphVertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord1.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord2.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord3.xyz = ase_worldBitangent;
				
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				o.ase_texcoord1.w = 0;
				o.ase_texcoord2.w = 0;
				o.ase_texcoord3.w = 0;

				v.vertex.xyz +=  float3(0,0,0) ;
				v.ase_normal =  v.ase_normal ;
				
                o.clipPos = MetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST);
        	    return o;
            }

            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

           		float2 uv_Albedo_smoothness_map_input = IN.ase_texcoord.xy * _Albedo_smoothness_map_input_ST.xy + _Albedo_smoothness_map_input_ST.zw;
           		float4 tex2DNode11 = tex2D( _Albedo_smoothness_map_input, uv_Albedo_smoothness_map_input );
           		float4 blendOpSrc12 = tex2DNode11;
           		float4 blendOpDest12 = _Base_color;
           		float4 temp_output_12_0 = ( saturate( (( blendOpDest12 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest12 - 0.5 ) ) * ( 1.0 - blendOpSrc12 ) ) : ( 2.0 * blendOpDest12 * blendOpSrc12 ) ) ));
           		float2 uv_Detail_mask_1_map_input = IN.ase_texcoord.xy * _Detail_mask_1_map_input_ST.xy + _Detail_mask_1_map_input_ST.zw;
           		float4 lerpResult221 = lerp( temp_output_12_0 , _Detail_color , ( tex2D( _Detail_mask_1_map_input, uv_Detail_mask_1_map_input ) * _Detail_1_level ));
           		float4 blendOpSrc222 = temp_output_12_0;
           		float4 blendOpDest222 = lerpResult221;
           		float4 temp_output_222_0 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc222 ) * ( 1.0 - blendOpDest222 ) ) ));
           		float2 uv_Normal_map_input = IN.ase_texcoord.xy * _Normal_map_input_ST.xy + _Normal_map_input_ST.zw;
           		float3 tex2DNode8 = UnpackNormalmapRGorAG( tex2D( _Normal_map_input, uv_Normal_map_input ), 0.0 );
           		float3 _normal265 = tex2DNode8;
           		float grayscale237 = (_normal265.r + _normal265.g + _normal265.b) / 3;
           		float4 lerpResult241 = lerp( temp_output_222_0 , float4(1,1,1,0) , ( grayscale237 * 1.0 ));
           		float4 blendOpSrc242 = temp_output_222_0;
           		float4 blendOpDest242 = lerpResult241;
           		float4 temp_output_242_0 = ( saturate( (( blendOpDest242 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest242 - 0.5 ) ) * ( 1.0 - blendOpSrc242 ) ) : ( 2.0 * blendOpDest242 * blendOpSrc242 ) ) ));
           		float2 uv_Ambient_Occlusion_map_input = IN.ase_texcoord.xy * _Ambient_Occlusion_map_input_ST.xy + _Ambient_Occlusion_map_input_ST.zw;
           		float4 _AO262 = tex2D( _Ambient_Occlusion_map_input, uv_Ambient_Occlusion_map_input );
           		float4 blendOpSrc80 = float4(1,1,1,1);
           		float4 blendOpDest80 = _AO262;
           		float4 lerpResult78 = lerp( temp_output_242_0 , float4(0,0,0,0) , ( ( saturate( abs( blendOpSrc80 - blendOpDest80 ) )) * _AO_shift ));
           		float4 blendOpSrc79 = temp_output_242_0;
           		float4 blendOpDest79 = lerpResult78;
           		float4 temp_output_79_0 = ( saturate( min( blendOpSrc79 , blendOpDest79 ) ));
           		float2 uv_Edge_mask_map_input = IN.ase_texcoord.xy * _Edge_mask_map_input_ST.xy + _Edge_mask_map_input_ST.zw;
           		float4 lerpResult70 = lerp( temp_output_79_0 , _Edge_color , ( tex2D( _Edge_mask_map_input, uv_Edge_mask_map_input ) * _Edge_wear ));
           		float4 blendOpSrc71 = temp_output_79_0;
           		float4 blendOpDest71 = lerpResult70;
           		float4 _base_stone_color270 = ( saturate( (( blendOpSrc71 > 0.5 ) ? max( blendOpDest71, 2.0 * ( blendOpSrc71 - 0.5 ) ) : min( blendOpDest71, 2.0 * blendOpSrc71 ) ) ));
           		float2 temp_cast_0 = (_Top_mask_tiling).xx;
           		float2 uv186 = IN.ase_texcoord.xy * temp_cast_0 + float2( 0,0 );
           		float2 _tiling256 = uv186;
           		float4 tex2DNode161 = tex2D( _Top_mask_texture, _tiling256 );
           		float4 lerpResult112 = lerp( _Top_Color , float4( 0,0,0,0 ) , tex2DNode161);
           		float4 _top_color274 = lerpResult112;
           		float3 ase_worldTangent = IN.ase_texcoord1.xyz;
           		float3 ase_worldNormal = IN.ase_texcoord2.xyz;
           		float3 ase_worldBitangent = IN.ase_texcoord3.xyz;
           		float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
           		float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
           		float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
           		float3 tanNormal224 = _normal265;
           		float3 worldNormal224 = float3(dot(tanToWorld0,tanNormal224), dot(tanToWorld1,tanNormal224), dot(tanToWorld2,tanNormal224));
           		float4 temp_cast_1 = (saturate( ( pow( ( saturate( worldNormal224.y ) + 0.0 ) , (1.0 + (0.0 - 0.0) * (20.0 - 1.0) / (1.0 - 0.0)) ) * 0.0 ) )).xxxx;
           		float4 blendOpSrc235 = temp_cast_1;
           		float4 blendOpDest235 = tex2DNode161;
           		float4 _top_mask276 = ( saturate( (( blendOpSrc235 > 0.5 ) ? max( blendOpDest235, 2.0 * ( blendOpSrc235 - 0.5 ) ) : min( blendOpDest235, 2.0 * blendOpSrc235 ) ) ));
           		float4 lerpResult113 = lerp( _base_stone_color270 , _top_color274 , _top_mask276);
           		float4 blendOpSrc114 = _base_stone_color270;
           		float4 blendOpDest114 = lerpResult113;
           		float4 _albedo_top_blend282 = ( saturate( ( 0.5 - 2.0 * ( blendOpSrc114 - 0.5 ) * ( blendOpDest114 - 0.5 ) ) ));
           		
				
		        float3 Albedo = _albedo_top_blend282.rgb;
				float3 Emission = 0;
				float Alpha = 1;
				float AlphaClipThreshold = 0;

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
7;1;3426;1370;5469.206;2058.126;1.138927;True;False
Node;AmplifyShaderEditor.CommentaryNode;258;-5192.303,-1397.621;Float;False;1205.53;543.2808;Normal_map_input_and_blending;9;265;286;168;263;173;163;269;174;8;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;168;-5127.303,-1141.621;Float;False;Constant;_Float0;Float 0;0;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;251;-6094.689,-2320.934;Float;False;804.868;385.1859;Detail_mask_1_map_input;6;222;221;220;219;217;218;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;252;-6609.689,-2327.934;Float;False;498.8076;432.2169;Albedo_smoothness_map_input;3;12;11;4;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;8;-4796.303,-1149.621;Float;True;Property;_Normal_map_input;Normal_map_input;11;0;Create;True;0;0;False;0;None;None;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;253;-5273.689,-2319.934;Float;False;904;393.9612;Detail_mask2;7;242;241;243;240;244;237;272;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;261;-6742.108,-1622.609;Float;False;627.7625;328.6404;Ambient_Occlusion_map_input;2;262;62;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SamplerNode;218;-6046.689,-2272.934;Float;True;Property;_Detail_mask_1_map_input;Detail_mask_1_map_input;16;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;265;-4436.305,-1031.621;Float;False;_normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;11;-6587.689,-2107.934;Float;True;Property;_Albedo_smoothness_map_input;Albedo_smoothness_map_input;10;0;Create;True;0;0;False;0;eb85a9f6ec8895a488b0a9fae9639feb;eb85a9f6ec8895a488b0a9fae9639feb;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;4;-6586.689,-2276.934;Float;False;Property;_Base_color;Base_color;0;0;Create;True;0;0;False;0;0.3919766,0.4150519,0.4264706,0;0.4274509,0.2274509,0.1372548,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;217;-6059.689,-2060.934;Float;False;Property;_Detail_1_level;Detail_1_level;4;0;Create;True;0;0;False;0;1;1;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;260;-6082.986,-1900.72;Float;False;1649.861;455.9243;Top_mask;13;276;230;226;229;225;235;233;232;231;228;227;264;224;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;272;-5252.689,-2187.934;Float;False;265;_normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.BlendOpsNode;12;-6323.689,-2273.934;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;219;-5746.689,-2267.934;Float;False;Property;_Detail_color;Detail_color;5;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;220;-5677.689,-2077.934;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;62;-6725.108,-1560.138;Float;True;Property;_Ambient_Occlusion_map_input;Ambient_Occlusion_map_input;12;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TFHCGrayscale;237;-5050.689,-2185.934;Float;False;2;1;0;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;254;-4342.766,-2367.913;Float;False;882.1279;439.7641;diff_AO_blend;8;79;78;77;76;74;80;271;81;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;240;-5250.689,-2078.934;Float;False;Constant;_Normal_Detail_level;Normal_Detail_level;13;0;Create;True;0;0;False;0;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;264;-6070.013,-1827.968;Float;False;265;_normal;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;221;-5517.689,-2258.934;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;262;-6311.108,-1536.609;Float;False;_AO;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;222;-5497.689,-2078.934;Float;False;Screen;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;271;-4292.963,-2132.388;Float;False;262;_AO;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;244;-4828.689,-2261.934;Float;False;Constant;_Detail_2_color;Detail_2_color;4;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;243;-4935.689,-2082.934;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;257;-7047.027,-1875.761;Float;False;932.7964;227.2341;Tiling;3;186;256;287;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;81;-4298.24,-2315.954;Float;False;Constant;_Color0;Color 0;17;0;Create;True;0;0;False;0;1,1,1,1;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldNormalVector;224;-5838.477,-1842.72;Float;False;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RangedFloatNode;226;-5831.796,-1600.472;Float;False;Constant;_Float1;Float 1;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;80;-4068.641,-2305.263;Float;False;Difference;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;225;-5836.668,-1687.55;Float;False;Constant;_Float2;Float 2;7;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;287;-6999.027,-1827.761;Float;False;Property;_Top_mask_tiling;Top_mask_tiling;7;0;Create;True;0;0;False;0;4;1;0;8;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;227;-5636.644,-1836.366;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-4283.756,-2034.748;Float;False;Property;_AO_shift;AO_shift;9;0;Create;True;0;0;False;0;1;0;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;241;-4765.689,-2066.934;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;76;-4002.872,-2185.023;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;77;-3850.952,-2294.061;Float;False;Constant;_Color4;Color 4;1;0;Create;True;0;0;False;0;0,0,0,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;186;-6663.027,-1811.761;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;242;-4586.689,-2068.934;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;228;-5474.278,-1840.403;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;229;-5517.668,-1728.549;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;255;-3407.615,-2442.051;Float;False;1038.109;501.1104;Edge_mask_map_input;6;71;70;69;67;124;68;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;256;-6359.027,-1795.761;Float;False;_tiling;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.LerpOp;78;-3626.631,-2288.685;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;230;-5524.865,-1550.318;Float;False;Constant;_Float3;Float 3;9;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;124;-3359.615,-2362.051;Float;True;Property;_Edge_mask_map_input;Edge_mask_map_input;15;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;67;-3311.615,-2138.051;Float;False;Property;_Edge_wear;Edge_wear;3;0;Create;True;0;0;False;0;0.9960846;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;231;-5345.656,-1842.037;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;259;-6078.384,-1412.659;Float;False;844.2686;465.2896;Top_mask_color;5;274;112;280;161;110;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ColorNode;68;-3007.615,-2378.051;Float;False;Property;_Edge_color;Edge_color;2;0;Create;True;0;0;False;0;1,1,1,0;1,1,1,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-2975.615,-2154.051;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;79;-3667.173,-2053.459;Float;False;Darken;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;280;-6031.908,-1195.652;Float;False;256;_tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;232;-5186.732,-1841.403;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;161;-5821.813,-1196.488;Float;True;Property;_Top_mask_texture;Top_mask_texture;13;0;Create;True;0;0;False;0;ddf6344e26e0f7e44a9a606e40d2f832;ddf6344e26e0f7e44a9a606e40d2f832;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SaturateNode;233;-5039.826,-1838.122;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;70;-2767.615,-2170.051;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;110;-6040.307,-1364.381;Float;False;Property;_Top_Color;Top_Color;6;0;Create;True;0;0;False;0;0.6654717,0.6985294,0.07704367,0;0.654902,0.7058823,0.1490187,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;112;-5597.958,-1354.816;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;71;-2607.615,-2074.051;Float;False;PinLight;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;235;-4891.584,-1839.067;Float;False;PinLight;True;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;270;-2319.615,-2074.051;Float;False;_base_stone_color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;274;-5465.781,-1086.372;Float;False;_top_color;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;276;-4652.612,-1840.73;Float;False;_top_mask;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;281;-3398.188,-1898.772;Float;False;836.6172;391.7167;Albedo_top_mask_blending;6;282;114;113;273;277;275;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;277;-3350.188,-1822.772;Float;False;276;_top_mask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;275;-3347.199,-1737.093;Float;False;274;_top_color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;273;-3356.188,-1654.772;Float;False;270;_base_stone_color;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;113;-3075.295,-1819.772;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;114;-3038.672,-1672.16;Float;False;Exclusion;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;267;-4399.145,-1879.132;Float;False;912.7186;354.2639;Smoothness;9;284;289;288;278;172;22;20;170;169;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;282;-2802.188,-1647.772;Float;False;_albedo_top_blend;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;284;-3712.061,-1804.62;Float;False;_smoothness;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;279;-3804.587,-1024.751;Float;False;262;_AO;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;283;-3868.587,-1312.751;Float;False;282;_albedo_top_blend;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;266;-3852.587,-1216.751;Float;False;263;_normal_blend;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;293;-3806.993,-928.0172;Float;False;Constant;_Float0;Float 0;20;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;263;-4225.306,-1184.621;Float;False;_normal_blend;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;172;-3879.142,-1804.132;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;173;-4428.305,-1213.621;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;285;-3836.587,-1120.751;Float;False;284;_smoothness;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;170;-4039.144,-1811.132;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;286;-4702.304,-953.6213;Float;False;276;_top_mask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;163;-4796.303,-1341.621;Float;True;Property;_Top_mask_normal;Top_mask_normal;14;0;Create;True;0;0;False;0;a10e98907b5cb784aa93e62c73c60b1a;a10e98907b5cb784aa93e62c73c60b1a;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-4047.144,-1687.132;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;174;-5148.303,-1229.621;Float;False;Constant;_Float4;Float 4;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;269;-5100.303,-1341.621;Float;False;256;_tiling;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-4344.145,-1718.132;Float;False;Property;_Material_Smoothness_shift;Material_Smoothness_shift;1;0;Create;True;0;0;False;0;1;0.568;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;169;-4363.145,-1821.132;Float;False;Property;_Top_mask_smoothness_shift;Top_mask_smoothness_shift;8;0;Create;True;0;0;False;0;1;0.283;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;289;-4040.213,-1597.612;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;278;-4254.145,-1631.132;Float;False;276;_top_mask;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;288;-3903.211,-1611.612;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;296;-3455.587,-1319.751;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;;0;0;Standard;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;297;-3455.587,-1319.751;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;;0;0;Standard;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;295;-3455.587,-1319.751;Float;False;True;2;Float;ASEMaterialInspector;0;2;beffio/Medieval_Kingdom/SRP/LW/Stones;1976390536c6c564abb90fe41f6ee334;0;0;Base;11;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;True;1;1;False;-1;0;False;-1;0;1;False;-1;0;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=LightweightForward;False;0;;0;0;Standard;1;_FinalColorxAlpha;0;11;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;9;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT3;0,0,0;False;10;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;298;-3455.587,-1319.751;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;0;3;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;;0;0;Standard;0;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;0
WireConnection;8;5;168;0
WireConnection;265;0;8;0
WireConnection;12;0;11;0
WireConnection;12;1;4;0
WireConnection;220;0;218;0
WireConnection;220;1;217;0
WireConnection;237;0;272;0
WireConnection;221;0;12;0
WireConnection;221;1;219;0
WireConnection;221;2;220;0
WireConnection;262;0;62;0
WireConnection;222;0;12;0
WireConnection;222;1;221;0
WireConnection;243;0;237;0
WireConnection;243;1;240;0
WireConnection;224;0;264;0
WireConnection;80;0;81;0
WireConnection;80;1;271;0
WireConnection;227;0;224;2
WireConnection;241;0;222;0
WireConnection;241;1;244;0
WireConnection;241;2;243;0
WireConnection;76;0;80;0
WireConnection;76;1;74;0
WireConnection;186;0;287;0
WireConnection;242;0;222;0
WireConnection;242;1;241;0
WireConnection;228;0;227;0
WireConnection;228;1;225;0
WireConnection;229;0;226;0
WireConnection;256;0;186;0
WireConnection;78;0;242;0
WireConnection;78;1;77;0
WireConnection;78;2;76;0
WireConnection;231;0;228;0
WireConnection;231;1;229;0
WireConnection;69;0;124;0
WireConnection;69;1;67;0
WireConnection;79;0;242;0
WireConnection;79;1;78;0
WireConnection;232;0;231;0
WireConnection;232;1;230;0
WireConnection;161;1;280;0
WireConnection;233;0;232;0
WireConnection;70;0;79;0
WireConnection;70;1;68;0
WireConnection;70;2;69;0
WireConnection;112;0;110;0
WireConnection;112;2;161;0
WireConnection;71;0;79;0
WireConnection;71;1;70;0
WireConnection;235;0;233;0
WireConnection;235;1;161;0
WireConnection;270;0;71;0
WireConnection;274;0;112;0
WireConnection;276;0;235;0
WireConnection;113;0;273;0
WireConnection;113;1;275;0
WireConnection;113;2;277;0
WireConnection;114;0;273;0
WireConnection;114;1;113;0
WireConnection;282;0;114;0
WireConnection;284;0;172;0
WireConnection;263;0;173;0
WireConnection;172;0;20;0
WireConnection;172;1;170;0
WireConnection;172;2;288;0
WireConnection;173;0;8;0
WireConnection;173;1;163;0
WireConnection;173;2;286;0
WireConnection;170;0;161;4
WireConnection;170;1;169;0
WireConnection;163;1;269;0
WireConnection;163;5;174;0
WireConnection;20;0;11;4
WireConnection;20;1;22;0
WireConnection;289;0;278;0
WireConnection;288;0;289;0
WireConnection;295;0;283;0
WireConnection;295;1;266;0
WireConnection;295;4;285;0
WireConnection;295;5;279;0
ASEEND*/
//CHKSM=106D836ECA63400FC590F67C62328AC70341C1A7