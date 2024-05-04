// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "beffio/Medieval_Kingdom/SRP/LW/Shafts"
{
    Properties
    {
		_Shaftcolor("Shaft color", Color) = (1,0.8068966,0,0)
		_Opacity_shift("Opacity_shift", Range( 0.01 , 1)) = 0.66
		_Frequency("Frequency", Range( 0 , 3)) = 0
		_Frequency_scale("Frequency_scale", Range( 0 , 0.5)) = 0.25
		[Toggle(_MASKOFFON_ON)] _Maskoffon("Mask off/on", Float) = 0
		_Emmisionlevel("Emmision level", Range( 0.01 , 50)) = 0.01
		_Texture2blend("Texture 2 blend", Range( 0 , 1)) = 0.5
		_Texture3blend("Texture 3 blend", Range( 0 , 1)) = 0.5
		_Noise_level("Noise_level", Range( 0 , 1)) = 0.5
		_Texture1tiling("Texture1 tiling", Vector) = (1,1,0,0)
		_Texture2tiling("Texture2 tiling", Vector) = (1,1,0,0)
		_Texture3tiling("Texture3 tiling", Vector) = (1,1,0,0)
		_Noise_tilling("Noise_tilling", Vector) = (3,3,0,0)
		_Texture1speed("Texture1 speed", Vector) = (0.08,0,0,0)
		_Texture2speed("Texture2 speed", Vector) = (0.1,0,0,0)
		_Texture3speed("Texture3 speed", Vector) = (-0.1,0,0,0)
		_Noise_speed("Noise_speed", Vector) = (-0.02,0.01,0,0)
		_Texture1("Texture1", 2D) = "white" {}
		_Texture2("Texture2", 2D) = "white" {}
		_Texture3("Texture3", 2D) = "white" {}
		_Texture4("Texture4", 2D) = "white" {}
		_Ray_mask("Ray_mask", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
    }

    SubShader
    {
        Tags { "RenderPipeline"="LightweightPipeline" "RenderType"="Transparent" "Queue"="Transparent" }

		Cull Off
		HLSLINCLUDE
		#pragma target 3.0
		ENDHLSL
		
        Pass
        {
			
        	Tags { "LightMode"="LightweightForward" }

        	Name "Base"
			Blend SrcAlpha OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
			ZWrite Off
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

        	#pragma shader_feature _MASKOFFON_ON


        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"

            CBUFFER_START(UnityPerMaterial)
			sampler2D _Texture1;
			float2 _Texture1speed;
			float2 _Texture1tiling;
			sampler2D _Texture2;
			float2 _Texture2speed;
			float2 _Texture2tiling;
			float _Texture2blend;
			sampler2D _Texture3;
			float2 _Texture3speed;
			float2 _Texture3tiling;
			float _Texture3blend;
			sampler2D _Ray_mask;
			float4 _Ray_mask_ST;
			sampler2D _Texture4;
			float2 _Noise_speed;
			float2 _Noise_tilling;
			float _Noise_level;
			float4 _Shaftcolor;
			float _Emmisionlevel;
			float _Frequency;
			float _Frequency_scale;
			float _Opacity_shift;
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
    
				float2 uv32 = IN.ase_texcoord7.xy * _Texture1tiling + float2( 0,0 );
				float2 panner35 = ( _Time.y * _Texture1speed + uv32);
				float2 uv41 = IN.ase_texcoord7.xy * _Texture2tiling + float2( 0,0 );
				float2 panner42 = ( _Time.y * _Texture2speed + uv41);
				float4 lerpResult93 = lerp( tex2D( _Texture1, panner35 ) , tex2D( _Texture2, panner42 ) , _Texture2blend);
				float2 uv46 = IN.ase_texcoord7.xy * _Texture3tiling + float2( 0,0 );
				float2 panner48 = ( _Time.y * _Texture3speed + uv46);
				float4 lerpResult94 = lerp( lerpResult93 , tex2D( _Texture3, panner48 ) , _Texture3blend);
				float2 uv_Ray_mask = IN.ase_texcoord7.xy * _Ray_mask_ST.xy + _Ray_mask_ST.zw;
				float4 blendOpSrc127 = lerpResult94;
				float4 blendOpDest127 = tex2D( _Ray_mask, uv_Ray_mask );
				#ifdef _MASKOFFON_ON
				float4 staticSwitch132 = ( saturate( (( blendOpSrc127 > 0.5 )? ( blendOpDest127 + 2.0 * blendOpSrc127 - 1.0 ) : ( blendOpDest127 + 2.0 * ( blendOpSrc127 - 0.5 ) ) ) ));
				#else
				float4 staticSwitch132 = lerpResult94;
				#endif
				float2 uv112 = IN.ase_texcoord7.xy * _Noise_tilling + float2( 0,0 );
				float2 panner114 = ( _Time.y * _Noise_speed + uv112);
				float4 lerpResult121 = lerp( float4( 0,0,0,0 ) , tex2D( _Texture4, panner114 ) , lerpResult94);
				float4 lerpResult120 = lerp( staticSwitch132 , lerpResult121 , _Noise_level);
				float4 blendOpSrc133 = staticSwitch132;
				float4 blendOpDest133 = lerpResult120;
				float4 _textures75 = ( saturate( 2.0f*blendOpDest133*blendOpSrc133 + blendOpDest133*blendOpDest133*(1.0f - 2.0f*blendOpSrc133) ));
				float4 blendOpSrc33 = _textures75;
				float4 blendOpDest33 = _Shaftcolor;
				float4 _shaft77 = ( saturate( ( blendOpSrc33 * blendOpDest33 ) ));
				
				float4 _emmision79 = ( _shaft77 * _Emmisionlevel );
				
				float _frequency71 = (sin( ( _Time.y * _Frequency ) )*_Frequency_scale + _Frequency_scale);
				float4 lerpResult72 = lerp( _textures75 , float4( 0,0,0,0 ) , _frequency71);
				float4 _opacity84 = ( lerpResult72 * _Opacity_shift );
				
				
		        float3 Albedo = _shaft77.rgb;
				float3 Normal = float3(0, 0, 1);
				float3 Emission = _emmision79.rgb;
				float3 Specular = float3(0.5, 0.5, 0.5);
				float Metallic = 0;
				float Smoothness = 0.5;
				float Occlusion = 1;
				float Alpha = _opacity84.r;
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

            #pragma shader_feature _MASKOFFON_ON


            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

            CBUFFER_START(UnityPerMaterial)
			sampler2D _Texture1;
			float2 _Texture1speed;
			float2 _Texture1tiling;
			sampler2D _Texture2;
			float2 _Texture2speed;
			float2 _Texture2tiling;
			float _Texture2blend;
			sampler2D _Texture3;
			float2 _Texture3speed;
			float2 _Texture3tiling;
			float _Texture3blend;
			sampler2D _Ray_mask;
			float4 _Ray_mask_ST;
			sampler2D _Texture4;
			float2 _Noise_speed;
			float2 _Noise_tilling;
			float _Noise_level;
			float _Frequency;
			float _Frequency_scale;
			float _Opacity_shift;
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

				o.ase_texcoord7.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord7.zw = 0;

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

               float2 uv32 = IN.ase_texcoord7.xy * _Texture1tiling + float2( 0,0 );
               float2 panner35 = ( _Time.y * _Texture1speed + uv32);
               float2 uv41 = IN.ase_texcoord7.xy * _Texture2tiling + float2( 0,0 );
               float2 panner42 = ( _Time.y * _Texture2speed + uv41);
               float4 lerpResult93 = lerp( tex2D( _Texture1, panner35 ) , tex2D( _Texture2, panner42 ) , _Texture2blend);
               float2 uv46 = IN.ase_texcoord7.xy * _Texture3tiling + float2( 0,0 );
               float2 panner48 = ( _Time.y * _Texture3speed + uv46);
               float4 lerpResult94 = lerp( lerpResult93 , tex2D( _Texture3, panner48 ) , _Texture3blend);
               float2 uv_Ray_mask = IN.ase_texcoord7.xy * _Ray_mask_ST.xy + _Ray_mask_ST.zw;
               float4 blendOpSrc127 = lerpResult94;
               float4 blendOpDest127 = tex2D( _Ray_mask, uv_Ray_mask );
               #ifdef _MASKOFFON_ON
               float4 staticSwitch132 = ( saturate( (( blendOpSrc127 > 0.5 )? ( blendOpDest127 + 2.0 * blendOpSrc127 - 1.0 ) : ( blendOpDest127 + 2.0 * ( blendOpSrc127 - 0.5 ) ) ) ));
               #else
               float4 staticSwitch132 = lerpResult94;
               #endif
               float2 uv112 = IN.ase_texcoord7.xy * _Noise_tilling + float2( 0,0 );
               float2 panner114 = ( _Time.y * _Noise_speed + uv112);
               float4 lerpResult121 = lerp( float4( 0,0,0,0 ) , tex2D( _Texture4, panner114 ) , lerpResult94);
               float4 lerpResult120 = lerp( staticSwitch132 , lerpResult121 , _Noise_level);
               float4 blendOpSrc133 = staticSwitch132;
               float4 blendOpDest133 = lerpResult120;
               float4 _textures75 = ( saturate( 2.0f*blendOpDest133*blendOpSrc133 + blendOpDest133*blendOpDest133*(1.0f - 2.0f*blendOpSrc133) ));
               float _frequency71 = (sin( ( _Time.y * _Frequency ) )*_Frequency_scale + _Frequency_scale);
               float4 lerpResult72 = lerp( _textures75 , float4( 0,0,0,0 ) , _frequency71);
               float4 _opacity84 = ( lerpResult72 * _Opacity_shift );
               

				float Alpha = _opacity84.r;
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

            #pragma shader_feature _MASKOFFON_ON


            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			CBUFFER_START(UnityPerMaterial)
			sampler2D _Texture1;
			float2 _Texture1speed;
			float2 _Texture1tiling;
			sampler2D _Texture2;
			float2 _Texture2speed;
			float2 _Texture2tiling;
			float _Texture2blend;
			sampler2D _Texture3;
			float2 _Texture3speed;
			float2 _Texture3tiling;
			float _Texture3blend;
			sampler2D _Ray_mask;
			float4 _Ray_mask_ST;
			sampler2D _Texture4;
			float2 _Noise_speed;
			float2 _Noise_tilling;
			float _Noise_level;
			float _Frequency;
			float _Frequency_scale;
			float _Opacity_shift;
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

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;

				v.vertex.xyz +=  float3(0,0,0) ;
				v.ase_normal =  v.ase_normal ;

        	    o.clipPos = TransformObjectToHClip(v.vertex.xyz);
        	    return o;
            }

            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

				float2 uv32 = IN.ase_texcoord.xy * _Texture1tiling + float2( 0,0 );
				float2 panner35 = ( _Time.y * _Texture1speed + uv32);
				float2 uv41 = IN.ase_texcoord.xy * _Texture2tiling + float2( 0,0 );
				float2 panner42 = ( _Time.y * _Texture2speed + uv41);
				float4 lerpResult93 = lerp( tex2D( _Texture1, panner35 ) , tex2D( _Texture2, panner42 ) , _Texture2blend);
				float2 uv46 = IN.ase_texcoord.xy * _Texture3tiling + float2( 0,0 );
				float2 panner48 = ( _Time.y * _Texture3speed + uv46);
				float4 lerpResult94 = lerp( lerpResult93 , tex2D( _Texture3, panner48 ) , _Texture3blend);
				float2 uv_Ray_mask = IN.ase_texcoord.xy * _Ray_mask_ST.xy + _Ray_mask_ST.zw;
				float4 blendOpSrc127 = lerpResult94;
				float4 blendOpDest127 = tex2D( _Ray_mask, uv_Ray_mask );
				#ifdef _MASKOFFON_ON
				float4 staticSwitch132 = ( saturate( (( blendOpSrc127 > 0.5 )? ( blendOpDest127 + 2.0 * blendOpSrc127 - 1.0 ) : ( blendOpDest127 + 2.0 * ( blendOpSrc127 - 0.5 ) ) ) ));
				#else
				float4 staticSwitch132 = lerpResult94;
				#endif
				float2 uv112 = IN.ase_texcoord.xy * _Noise_tilling + float2( 0,0 );
				float2 panner114 = ( _Time.y * _Noise_speed + uv112);
				float4 lerpResult121 = lerp( float4( 0,0,0,0 ) , tex2D( _Texture4, panner114 ) , lerpResult94);
				float4 lerpResult120 = lerp( staticSwitch132 , lerpResult121 , _Noise_level);
				float4 blendOpSrc133 = staticSwitch132;
				float4 blendOpDest133 = lerpResult120;
				float4 _textures75 = ( saturate( 2.0f*blendOpDest133*blendOpSrc133 + blendOpDest133*blendOpDest133*(1.0f - 2.0f*blendOpSrc133) ));
				float _frequency71 = (sin( ( _Time.y * _Frequency ) )*_Frequency_scale + _Frequency_scale);
				float4 lerpResult72 = lerp( _textures75 , float4( 0,0,0,0 ) , _frequency71);
				float4 _opacity84 = ( lerpResult72 * _Opacity_shift );
				

				float Alpha = _opacity84.r;
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


            #pragma shader_feature _MASKOFFON_ON


			uniform float4 _MainTex_ST;

            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			CBUFFER_START(UnityPerMaterial)
			sampler2D _Texture1;
			float2 _Texture1speed;
			float2 _Texture1tiling;
			sampler2D _Texture2;
			float2 _Texture2speed;
			float2 _Texture2tiling;
			float _Texture2blend;
			sampler2D _Texture3;
			float2 _Texture3speed;
			float2 _Texture3tiling;
			float _Texture3blend;
			sampler2D _Ray_mask;
			float4 _Ray_mask_ST;
			sampler2D _Texture4;
			float2 _Noise_speed;
			float2 _Noise_tilling;
			float _Noise_level;
			float4 _Shaftcolor;
			float _Emmisionlevel;
			float _Frequency;
			float _Frequency_scale;
			float _Opacity_shift;
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
				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;

				v.vertex.xyz +=  float3(0,0,0) ;
				v.ase_normal =  v.ase_normal ;
				
                o.clipPos = MetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST);
        	    return o;
            }

            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

           		float2 uv32 = IN.ase_texcoord.xy * _Texture1tiling + float2( 0,0 );
           		float2 panner35 = ( _Time.y * _Texture1speed + uv32);
           		float2 uv41 = IN.ase_texcoord.xy * _Texture2tiling + float2( 0,0 );
           		float2 panner42 = ( _Time.y * _Texture2speed + uv41);
           		float4 lerpResult93 = lerp( tex2D( _Texture1, panner35 ) , tex2D( _Texture2, panner42 ) , _Texture2blend);
           		float2 uv46 = IN.ase_texcoord.xy * _Texture3tiling + float2( 0,0 );
           		float2 panner48 = ( _Time.y * _Texture3speed + uv46);
           		float4 lerpResult94 = lerp( lerpResult93 , tex2D( _Texture3, panner48 ) , _Texture3blend);
           		float2 uv_Ray_mask = IN.ase_texcoord.xy * _Ray_mask_ST.xy + _Ray_mask_ST.zw;
           		float4 blendOpSrc127 = lerpResult94;
           		float4 blendOpDest127 = tex2D( _Ray_mask, uv_Ray_mask );
           		#ifdef _MASKOFFON_ON
           		float4 staticSwitch132 = ( saturate( (( blendOpSrc127 > 0.5 )? ( blendOpDest127 + 2.0 * blendOpSrc127 - 1.0 ) : ( blendOpDest127 + 2.0 * ( blendOpSrc127 - 0.5 ) ) ) ));
           		#else
           		float4 staticSwitch132 = lerpResult94;
           		#endif
           		float2 uv112 = IN.ase_texcoord.xy * _Noise_tilling + float2( 0,0 );
           		float2 panner114 = ( _Time.y * _Noise_speed + uv112);
           		float4 lerpResult121 = lerp( float4( 0,0,0,0 ) , tex2D( _Texture4, panner114 ) , lerpResult94);
           		float4 lerpResult120 = lerp( staticSwitch132 , lerpResult121 , _Noise_level);
           		float4 blendOpSrc133 = staticSwitch132;
           		float4 blendOpDest133 = lerpResult120;
           		float4 _textures75 = ( saturate( 2.0f*blendOpDest133*blendOpSrc133 + blendOpDest133*blendOpDest133*(1.0f - 2.0f*blendOpSrc133) ));
           		float4 blendOpSrc33 = _textures75;
           		float4 blendOpDest33 = _Shaftcolor;
           		float4 _shaft77 = ( saturate( ( blendOpSrc33 * blendOpDest33 ) ));
           		
           		float4 _emmision79 = ( _shaft77 * _Emmisionlevel );
           		
           		float _frequency71 = (sin( ( _Time.y * _Frequency ) )*_Frequency_scale + _Frequency_scale);
           		float4 lerpResult72 = lerp( _textures75 , float4( 0,0,0,0 ) , _frequency71);
           		float4 _opacity84 = ( lerpResult72 * _Opacity_shift );
           		
				
		        float3 Albedo = _shaft77.rgb;
				float3 Emission = _emmision79.rgb;
				float Alpha = _opacity84.r;
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
7;7;3426;1364;3024.667;95.30054;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;74;-4076.421,273.0932;Float;False;2111.358;1599.656;Textures and tiling;41;110;115;114;109;112;113;111;136;135;137;134;127;125;75;132;133;120;121;94;91;49;48;47;46;45;60;93;89;43;42;39;41;40;61;11;35;38;37;32;62;76;;1,1,1,1;0;0
Node;AmplifyShaderEditor.Vector2Node;61;-3994.881,657.0933;Float;False;Property;_Texture2tiling;Texture2 tiling;10;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;62;-3994.881,337.0932;Float;False;Property;_Texture1tiling;Texture1 tiling;9;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;32;-3770.882,337.0932;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;37;-3722.882,577.0932;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;39;-3722.882,881.0935;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;38;-3754.882,465.0934;Float;False;Property;_Texture1speed;Texture1 speed;13;0;Create;True;0;0;False;0;0.08,0;0.08,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;40;-3738.882,769.0934;Float;False;Property;_Texture2speed;Texture2 speed;14;0;Create;True;0;0;False;0;0.1,0;0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;60;-3978.881,961.0933;Float;False;Property;_Texture3tiling;Texture3 tiling;11;0;Create;True;0;0;False;0;1,1;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;41;-3786.882,657.0933;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;35;-3514.882,337.0932;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;46;-3770.882,961.0933;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;47;-3738.882,1073.093;Float;False;Property;_Texture3speed;Texture3 speed;15;0;Create;True;0;0;False;0;-0.1,0;-0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;42;-3530.882,657.0933;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;45;-3722.882,1185.093;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;48;-3514.882,961.0933;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;89;-3274.882,849.0934;Float;False;Property;_Texture2blend;Texture 2 blend;6;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-3322.882,337.0932;Float;True;Property;_Texture1;Texture1;17;0;Create;True;0;0;False;0;7fc46b1c5cc369044ac53a3db22654e2;7fc46b1c5cc369044ac53a3db22654e2;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;43;-3306.882,657.0933;Float;True;Property;_Texture2;Texture2;18;0;Create;True;0;0;False;0;6f69326335f7e8e41a551d0ce9c660a5;6f69326335f7e8e41a551d0ce9c660a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;91;-3306.882,1153.093;Float;False;Property;_Texture3blend;Texture 3 blend;7;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;93;-2990.6,340.7771;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;49;-3322.882,961.0933;Float;True;Property;_Texture3;Texture3;19;0;Create;True;0;0;False;0;b34708c8228e4464481c9671664722a3;6f69326335f7e8e41a551d0ce9c660a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;94;-2967.31,991.3071;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;136;-2844.253,1148.032;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;135;-3051.18,1233.539;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;111;-3962.881,1537.093;Float;False;Property;_Noise_tilling;Noise_tilling;12;0;Create;True;0;0;False;0;3,3;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;137;-3495.814,1243.799;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.Vector2Node;113;-3722.882,1649.093;Float;False;Property;_Noise_speed;Noise_speed;16;0;Create;True;0;0;False;0;-0.02,0.01;-0.1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TextureCoordinatesNode;112;-3754.882,1537.093;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;109;-3690.882,1761.093;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;125;-3914.882,1281.093;Float;True;Property;_Ray_mask;Ray_mask;21;0;Create;True;0;0;False;0;193236c54182d934580246f8033ed582;193236c54182d934580246f8033ed582;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;134;-3513.589,1279.525;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.PannerNode;114;-3482.882,1537.093;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;115;-3274.882,1537.093;Float;True;Property;_Texture4;Texture4;20;0;Create;True;0;0;False;0;384eca5df23515f4fa49ee5065513398;6f69326335f7e8e41a551d0ce9c660a5;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;127;-3434.882,1281.093;Float;False;LinearLight;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;64;-2698.078,1455.964;Float;False;1055.718;392.1562;Frequency;7;71;70;69;68;67;66;65;;1,1,1,1;0;0
Node;AmplifyShaderEditor.StaticSwitch;132;-2762.882,353.0932;Float;False;Property;_Maskoffon;Mask off/on;4;0;Create;True;0;0;False;0;0;0;0;True;;Toggle;2;Key0;Key1;9;1;COLOR;0,0,0,0;False;0;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;COLOR;0,0,0,0;False;4;COLOR;0,0,0,0;False;5;COLOR;0,0,0,0;False;6;COLOR;0,0,0,0;False;7;COLOR;0,0,0,0;False;8;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;110;-3274.882,1729.093;Float;False;Property;_Noise_level;Noise_level;8;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;121;-2729.882,609.0932;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.TimeNode;65;-2618.078,1551.964;Float;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;120;-2538.882,609.0932;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;66;-2666.078,1711.964;Float;False;Property;_Frequency;Frequency;2;0;Create;True;0;0;False;0;0;0;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;133;-2409.882,354.0932;Float;False;SoftLight;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;67;-2378.078,1551.964;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;68;-2234.078,1567.964;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;75;-2183.123,351.214;Float;False;_textures;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;69;-2362.078,1727.964;Float;False;Property;_Frequency_scale;Frequency_scale;3;0;Create;True;0;0;False;0;0.25;0.5;0;0.5;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;76;-2698.078,1087.964;Float;False;728.6025;324.8268;Color;4;77;33;86;34;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;86;-2650.078,1311.964;Float;False;75;_textures;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;70;-2074.08,1567.964;Float;False;3;0;FLOAT;0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;34;-2666.078,1135.964;Float;False;Property;_Shaftcolor;Shaft color;0;0;Create;True;0;0;False;0;1,0.8068966,0,0;0,0,0,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;71;-1850.08,1551.964;Float;False;_frequency;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;81;-1629.878,1532.11;Float;False;860.147;314.0981;Opacity;6;84;53;54;73;72;80;;1,1,1,1;0;0
Node;AmplifyShaderEditor.BlendOpsNode;33;-2426.078,1135.964;Float;False;Multiply;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;77;-2186.078,1263.964;Float;False;_shaft;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;78;-1937.695,1087.964;Float;False;616.2372;249.2833;Emmision;4;79;51;87;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.GetLocalVarNode;80;-1581.878,1580.11;Float;False;75;_textures;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;73;-1581.878,1660.11;Float;False;71;_frequency;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-1581.878,1740.11;Float;False;Property;_Opacity_shift;Opacity_shift;1;0;Create;True;0;0;False;0;0.66;1;0.01;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;72;-1325.878,1580.11;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;87;-1921.695,1151.964;Float;False;77;_shaft;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;52;-1921.695,1263.964;Float;False;Property;_Emmisionlevel;Emmision level;5;0;Create;True;0;0;False;0;0.01;0;0.01;50;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-1713.695,1151.964;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-1149.878,1580.11;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;84;-989.8768,1580.11;Float;False;_opacity;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;79;-1569.695,1247.964;Float;False;_emmision;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;142;-1573.761,171.5034;Float;False;Constant;_Float1;Float 1;22;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;82;-1562,367;Float;False;79;_emmision;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-1552,288;Float;False;77;_shaft;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;85;-1569,481;Float;False;84;_opacity;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;145;-1103,292;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;0;1;ShadowCaster;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;False;False;True;1;False;-1;True;3;False;-1;False;True;1;LightMode=ShadowCaster;False;0;;0;0;Standard;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;146;-1103,292;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;0;2;DepthOnly;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;False;True;False;False;False;False;0;False;-1;False;True;1;False;-1;False;False;True;1;LightMode=DepthOnly;False;0;;0;0;Standard;0;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;147;-1103,292;Float;False;False;2;Float;ASEMaterialInspector;0;1;Hidden/Templates/LightWeightSRPPBR;1976390536c6c564abb90fe41f6ee334;0;3;Meta;0;False;False;False;True;0;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Opaque=RenderType;Queue=Geometry=Queue=0;True;2;0;False;False;False;True;2;False;-1;False;False;False;False;False;True;1;LightMode=Meta;False;0;;0;0;Standard;0;6;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT3;0,0,0;False;5;FLOAT3;0,0,0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;144;-1103,292;Float;False;True;2;Float;ASEMaterialInspector;0;2;beffio/Medieval_Kingdom/SRP/LW/Shafts;1976390536c6c564abb90fe41f6ee334;0;0;Base;11;False;False;False;True;2;False;-1;False;False;False;False;False;True;3;RenderPipeline=LightweightPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;True;2;0;True;2;5;False;-1;10;False;-1;2;5;False;-1;10;False;-1;False;False;False;True;True;True;True;True;0;False;-1;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;2;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;LightMode=LightweightForward;False;0;;0;0;Standard;1;_FinalColorxAlpha;0;11;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;9;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;7;FLOAT;0;False;8;FLOAT3;0,0,0;False;10;FLOAT3;0,0,0;False;0
WireConnection;32;0;62;0
WireConnection;41;0;61;0
WireConnection;35;0;32;0
WireConnection;35;2;38;0
WireConnection;35;1;37;0
WireConnection;46;0;60;0
WireConnection;42;0;41;0
WireConnection;42;2;40;0
WireConnection;42;1;39;0
WireConnection;48;0;46;0
WireConnection;48;2;47;0
WireConnection;48;1;45;0
WireConnection;11;1;35;0
WireConnection;43;1;42;0
WireConnection;93;0;11;0
WireConnection;93;1;43;0
WireConnection;93;2;89;0
WireConnection;49;1;48;0
WireConnection;94;0;93;0
WireConnection;94;1;49;0
WireConnection;94;2;91;0
WireConnection;136;0;94;0
WireConnection;135;0;136;0
WireConnection;137;0;135;0
WireConnection;112;0;111;0
WireConnection;134;0;137;0
WireConnection;114;0;112;0
WireConnection;114;2;113;0
WireConnection;114;1;109;0
WireConnection;115;1;114;0
WireConnection;127;0;134;0
WireConnection;127;1;125;0
WireConnection;132;1;94;0
WireConnection;132;0;127;0
WireConnection;121;1;115;0
WireConnection;121;2;94;0
WireConnection;120;0;132;0
WireConnection;120;1;121;0
WireConnection;120;2;110;0
WireConnection;133;0;132;0
WireConnection;133;1;120;0
WireConnection;67;0;65;2
WireConnection;67;1;66;0
WireConnection;68;0;67;0
WireConnection;75;0;133;0
WireConnection;70;0;68;0
WireConnection;70;1;69;0
WireConnection;70;2;69;0
WireConnection;71;0;70;0
WireConnection;33;0;86;0
WireConnection;33;1;34;0
WireConnection;77;0;33;0
WireConnection;72;0;80;0
WireConnection;72;2;73;0
WireConnection;51;0;87;0
WireConnection;51;1;52;0
WireConnection;53;0;72;0
WireConnection;53;1;54;0
WireConnection;84;0;53;0
WireConnection;79;0;51;0
WireConnection;144;0;83;0
WireConnection;144;2;82;0
WireConnection;144;6;85;0
ASEEND*/
//CHKSM=F0EB2B9934DCC73B3509F0A85EF961744025BB82