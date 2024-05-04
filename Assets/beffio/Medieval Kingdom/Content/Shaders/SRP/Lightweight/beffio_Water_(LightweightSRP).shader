// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "beffio/Medieval_Kingdom/SRP/LW/Water"
{
    Properties
    {
		_Depth_Top_Color("Depth_Top_Color", Color) = (0.5019608,0.7215686,0.7019608,0)
		_Shorecolor("Shore color", Color) = (0.5019608,0.7215686,0.7019608,0)
		_Depth_bottom_color("Depth_bottom_color", Color) = (0.1394896,0.2357535,0.3161765,0)
		_Depth_multiply("Depth_multiply", Range( 0 , 1)) = 0.1
		_Top_mask_color_shift("Top_mask_color_shift", Color) = (1,1,1,0)
		_Watertopmasklevel("Water top mask level", Range( 0 , 1)) = 1
		_Smoothness_level("Smoothness_level", Range( 0 , 1)) = 0.92
		_Vertexdicplacementlevel("Vertex dicplacement level", Range( 0.001 , 2)) = 0.15
		_Underwater_Distortion("Underwater_Distortion", Range( 0 , 1)) = 0.2
		_Normal2_intensity("Normal2_intensity", Range( 0 , 2)) = 1
		_Normal_blend("Normal_blend", Range( 0 , 1)) = 0.5
		_Normal1_intensity("Normal1_intensity", Range( 0 , 2)) = 1
		[HideInInspector]_Normalmapinput("Normal map input", 2D) = "bump" {}
		_UV1_speed("UV1_speed", Vector) = (0.03,0,0,0)
		_UV2_speed("UV2_speed", Vector) = (0.015,0,0,0)
		_UV1_tiling("UV1_tiling", Range( 0.01 , 2)) = 1
		_UV2_tiling("UV2_tiling", Range( 0.01 , 2)) = 1
		_Edge_fade("Edge_fade", Range( 0 , 3)) = 1
		[HideInInspector]_water_caustic("water_caustic", 2D) = "white" {}
		_Caustic_intensity("Caustic_intensity", Range( 0 , 2)) = 1
		_Caustic_speed("Caustic_speed", Vector) = (-0.5,-0.15,0,0)
		_Caustic_parallax("Caustic_parallax", Range( 0 , 1)) = 1
		_caustic_tilling("caustic_tilling", Range( 1 , 50)) = 1
		[HideInInspector]_a710fa1f1165b699bccefec099930acf("a710fa1f1165b699bccefec099930acf", 2D) = "white" {}
		_Edge_Foam_Tiling("Edge_Foam_Tiling", Range( 0 , 50)) = 10
		_Foam_Amount("Foam_Amount", Range( 0 , 2)) = 0
		_Foam_contrast("Foam_contrast", Range( 0 , 1.4)) = 0
		_Foamcolor("Foam color", Color) = (0,0,0,0)
		_Depth_Intensity("Depth_Intensity", Range( 0 , 1)) = 0
		_Reflection_power("Reflection_power", Range( 0 , 1)) = 0.5
		[HideInInspector]_PerlinNoise6("PerlinNoise6", 2D) = "white" {}
		_Wavescolor("Waves color", Color) = (0,0,0,0)
		_Wavesintensity("Waves intensity", Range( 0 , 1)) = 0
		_Fakereflectionscolor("Fake reflections color", Color) = (0,0,0,0)
		_Wavesnoisecutout("Waves noise cutout", Range( 0 , 1)) = 0
		_Waveswidth("Waves width", Range( 0.001 , 0.1)) = 0.2
    }

    SubShader
    {
        Tags { "RenderPipeline"="LightweightPipeline" "RenderType"="Transparent" "Queue"="Transparent" }

		Cull Back
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

        	#define REQUIRE_OPAQUE_TEXTURE 1
        	#define _NORMALMAP 1


        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Lighting.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        	#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/UnityInstancing.hlsl"
        	#include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"

            CBUFFER_START(UnityPerMaterial)
			sampler2D _Normalmapinput;
			float _Normal1_intensity;
			float2 _UV1_speed;
			float _UV1_tiling;
			float _Normal2_intensity;
			float2 _UV2_speed;
			float _UV2_tiling;
			float _Normal_blend;
			float _Vertexdicplacementlevel;
			float4 _Shorecolor;
			float4 _Depth_Top_Color;
			float4 _Depth_bottom_color;
			uniform sampler2D _CameraDepthTexture;
			float _Depth_multiply;
			sampler2D _TextureSnap;
			float _Underwater_Distortion;
			float _Activated;
			float _Reflection_power;
			float _Depth_Intensity;
			float4 _Top_mask_color_shift;
			float _Watertopmasklevel;
			sampler2D _water_caustic;
			sampler2D _PerlinNoise6;
			float _caustic_tilling;
			float2 _Caustic_speed;
			float _Caustic_parallax;
			float _Caustic_intensity;
			float4 _Foamcolor;
			float _Foam_contrast;
			sampler2D _a710fa1f1165b699bccefec099930acf;
			float _Edge_Foam_Tiling;
			float _Foam_Amount;
			float4 _Wavescolor;
			float _Waveswidth;
			float _Wavesnoisecutout;
			float _Wavesintensity;
			float4 _Fakereflectionscolor;
			float _Smoothness_level;
			float _Edge_fade;
			CBUFFER_END
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

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
				float4 ase_texcoord8 : TEXCOORD8;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            	UNITY_VERTEX_OUTPUT_STEREO
            };


            GraphVertexOutput vert (GraphVertexInput v)
        	{
        		GraphVertexOutput o = (GraphVertexOutput)0;
                UNITY_SETUP_INSTANCE_ID(v);
            	UNITY_TRANSFER_INSTANCE_ID(v, o);
        		UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float2 appendResult579 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 _world_UV582 = ( appendResult579 / 1.0 );
				float2 panner565 = ( _Time.x * _UV1_speed + ( _world_UV582 * _UV1_tiling ));
				float2 UV1566 = panner565;
				float2 panner564 = ( _Time.y * _UV2_speed + ( _world_UV582 * _UV2_tiling ));
				float2 UV2567 = panner564;
				float3 lerpResult576 = lerp( UnpackNormalmapRGorAG( tex2Dlod( _Normalmapinput, float4( UV1566, 0, 0.0) ), _Normal1_intensity ) , UnpackNormalmapRGorAG( tex2Dlod( _Normalmapinput, float4( UV2567, 0, 0.0) ), _Normal2_intensity ) , _Normal_blend);
				float3 _Normal577 = lerpResult576;
				float4 transform514 = mul(unity_ObjectToWorld,float4( _Normal577 , 0.0 ));
				float _vector_displacement544 = ( transform514.y * _Vertexdicplacementlevel );
				float3 temp_cast_1 = (_vector_displacement544).xxx;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord7 = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord8.x = eyeDepth;
				
				o.ase_texcoord8.yz = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord8.w = 0;
				v.vertex.xyz += temp_cast_1;
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
    
				float4 screenPos = IN.ase_texcoord7;
				float eyeDepth496 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float4 temp_cast_0 = (abs( ( eyeDepth496 - ( screenPos.w * 1.0 ) ) )).xxxx;
				float4 blendOpSrc648 = float4(0.08235294,0.1647059,0.2117647,0);
				float4 blendOpDest648 = temp_cast_0;
				float4 lerpResult503 = lerp( _Depth_Top_Color , _Depth_bottom_color , ( ( saturate( 2.0f*blendOpDest648*blendOpSrc648 + blendOpDest648*blendOpDest648*(1.0f - 2.0f*blendOpSrc648) )) * _Depth_multiply ));
				float eyeDepth = IN.ase_texcoord8.x;
				float cameraDepthFade978 = (( eyeDepth -_ProjectionParams.y - 3.0 ) / 10.0);
				float clampResult981 = clamp( cameraDepthFade978 , 0.0 , 1.0 );
				float4 lerpResult979 = lerp( _Shorecolor , lerpResult503 , clampResult981);
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth983 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth983 = abs( ( screenDepth983 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
				float clampResult984 = clamp( distanceDepth983 , 0.9 , 1.0 );
				float4 lerpResult982 = lerp( _Shorecolor , lerpResult979 , clampResult984);
				float4 _depth635 = lerpResult982;
				float4 normalizeResult1071 = normalize( screenPos );
				float4 break1072 = normalizeResult1071;
				float2 appendResult660 = (float2(break1072.x , break1072.y));
				float2 appendResult579 = (float2(WorldSpacePosition.x , WorldSpacePosition.z));
				float2 _world_UV582 = ( appendResult579 / 1.0 );
				float2 panner565 = ( _Time.x * _UV1_speed + ( _world_UV582 * _UV1_tiling ));
				float2 UV1566 = panner565;
				float2 panner564 = ( _Time.y * _UV2_speed + ( _world_UV582 * _UV2_tiling ));
				float2 UV2567 = panner564;
				float3 lerpResult576 = lerp( UnpackNormalmapRGorAG( tex2D( _Normalmapinput, UV1566 ), _Normal1_intensity ) , UnpackNormalmapRGorAG( tex2D( _Normalmapinput, UV2567 ), _Normal2_intensity ) , _Normal_blend);
				float3 _Normal577 = lerpResult576;
				float3 temp_output_667_0 = ( float3( ( appendResult660 / break1072.w ) ,  0.0 ) + ( _Normal577 * _Underwater_Distortion ) );
				float4 lerpResult1048 = lerp( float4( 0,0,0,0 ) , tex2D( _TextureSnap, temp_output_667_0.xy ) , _Activated);
				float4 fetchOpaqueVal670 = SAMPLE_TEXTURE2D( _CameraOpaqueTexture, sampler_CameraOpaqueTexture, temp_output_667_0.xy);
				float4 lerpResult901 = lerp( lerpResult1048 , fetchOpaqueVal670 , WorldSpaceViewDirection.y);
				float4 lerpResult895 = lerp( lerpResult901 , lerpResult1048 , _Reflection_power);
				float screenDepth890 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth890 = abs( ( screenDepth890 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 7.0 ) );
				float4 lerpResult889 = lerp( lerpResult895 , float4( 0.1218642,0,0,0 ) , distanceDepth890);
				float4 lerpResult891 = lerp( lerpResult895 , lerpResult889 , _Depth_Intensity);
				float3 normalizeResult669 = normalize( ( _MainLightPosition.xyz + WorldSpaceViewDirection ) );
				float4 lerpResult677 = lerp( lerpResult891 , float4( normalizeResult669 , 0.0 ) , float4( 0,0,0,0 ));
				float4 lerpResult1073 = lerp( lerpResult677 , _MainLightColor , float4( 0.021,0.021,0.021,0 ));
				float4 _Underwater_distortion675 = lerpResult1073;
				float4 blendOpSrc507 = _depth635;
				float4 blendOpDest507 = _Underwater_distortion675;
				float4 lerpResult517 = lerp( ( saturate( 2.0f*blendOpDest507*blendOpSrc507 + blendOpDest507*blendOpDest507*(1.0f - 2.0f*blendOpSrc507) )) , 0 , float4( 0,0,0,0 ));
				float4 transform514 = mul(unity_ObjectToWorld,float4( _Normal577 , 0.0 ));
				float4 temp_cast_7 = (transform514.y).xxxx;
				float4 blendOpSrc598 = _Top_mask_color_shift;
				float4 blendOpDest598 = temp_cast_7;
				float4 temp_cast_8 = (transform514.y).xxxx;
				float4 blendOpSrc593 = temp_cast_8;
				float4 blendOpDest593 = float4(1,1,1,0);
				float4 blendOpSrc606 = ( saturate( 2.0f*blendOpDest598*blendOpSrc598 + blendOpDest598*blendOpDest598*(1.0f - 2.0f*blendOpSrc598) ));
				float4 blendOpDest606 = ( saturate( 2.0f*blendOpDest593*blendOpSrc593 + blendOpDest593*blendOpDest593*(1.0f - 2.0f*blendOpSrc593) ));
				float4 blendOpSrc607 = ( ( saturate( ( blendOpSrc606 + blendOpDest606 - 1.0 ) )) * _Watertopmasklevel );
				float4 blendOpDest607 = float4( 0,0,0,0 );
				float4 Water_top_mask621 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc607 ) * ( 1.0 - blendOpDest607 ) ) ));
				float4 blendOpSrc623 = lerpResult517;
				float4 blendOpDest623 = Water_top_mask621;
				float4 _Water_color_blend639 = ( saturate( ( blendOpSrc623 + blendOpDest623 ) ));
				float2 temp_cast_9 = (_caustic_tilling).xx;
				float2 uv1015 = IN.ase_texcoord8.yz * temp_cast_9 + float2( 0,0 );
				float2 panner1016 = ( 1.0 * _Time.y * float2( 0.1,0 ) + uv1015);
				float2 temp_cast_10 = (_caustic_tilling).xx;
				float2 uv733 = IN.ase_texcoord8.yz * temp_cast_10 + float2( 0,0 );
				float2 panner746 = ( _Time.x * _Caustic_speed + uv733);
				float screenDepth784 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth784 = abs( ( screenDepth784 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 2.0 ) );
				float4 lerpResult797 = lerp( float4(1,1,1,0) , float4( 0,0,0,0 ) , distanceDepth784);
				float3 hsvTorgb787 = HSVToRGB( float3(0.0,0.0,lerpResult797.r) );
				float3 tanToWorld0 = float3( WorldSpaceTangent.x, WorldSpaceBiTangent.x, WorldSpaceNormal.x );
				float3 tanToWorld1 = float3( WorldSpaceTangent.y, WorldSpaceBiTangent.y, WorldSpaceNormal.y );
				float3 tanToWorld2 = float3( WorldSpaceTangent.z, WorldSpaceBiTangent.z, WorldSpaceNormal.z );
				float3 ase_tanViewDir =  tanToWorld0 * WorldSpaceViewDirection.x + tanToWorld1 * WorldSpaceViewDirection.y  + tanToWorld2 * WorldSpaceViewDirection.z;
				ase_tanViewDir = normalize(ase_tanViewDir);
				float2 Offset725 = ( ( hsvTorgb787.x - 1 ) * ase_tanViewDir.xy * _Caustic_parallax ) + panner746;
				float grayscale753 = Luminance(tex2D( _water_caustic, ( UnpackNormalmapRGorAG( tex2D( _PerlinNoise6, panner1016 ), 0.05 ) + float3( Offset725 ,  0.0 ) ).xy ).rgb);
				float clampResult790 = clamp( pow( distanceDepth784 , 10.0 ) , 100.0 , 0.5 );
				float4 _caustic729 = ( ( grayscale753 * lerpResult982 ) * clampResult790 );
				float4 blendOpSrc730 = _Water_color_blend639;
				float4 blendOpDest730 = ( _caustic729 * _Caustic_intensity );
				float2 temp_cast_15 = (_Edge_Foam_Tiling).xx;
				float2 uv877 = IN.ase_texcoord8.yz * temp_cast_15 + float2( 0,0 );
				float screenDepth807 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth807 = abs( ( screenDepth807 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _Foam_Amount ) );
				float4 temp_cast_16 = (distanceDepth807).xxxx;
				float4 lerpResult853 = lerp( CalculateContrast(_Foam_contrast,tex2D( _a710fa1f1165b699bccefec099930acf, uv877 )) , float4( 0,0,0,0 ) , CalculateContrast(( _Foam_contrast * 2.0 ),temp_cast_16));
				float4 Waves866 = lerpResult853;
				float4 clampResult884 = clamp( Waves866 , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
				float4 lerpResult883 = lerp( ( saturate( max( blendOpSrc730, blendOpDest730 ) )) , _Foamcolor , clampResult884);
				float temp_output_1064_0 = ( ( 1.1 - _Waveswidth ) * 5.0 );
				float screenDepth902 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth902 = abs( ( screenDepth902 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( fmod( ( 0.0 - ( _Time.y / 3.0 ) ) , temp_output_1064_0 ) ) );
				float temp_output_1053_0 = ( 0.1 + _Waveswidth );
				float temp_output_1056_0 = ( temp_output_1053_0 + _Waveswidth );
				float temp_output_1057_0 = ( temp_output_1056_0 + _Waveswidth );
				float temp_output_1058_0 = ( temp_output_1057_0 + _Waveswidth );
				float temp_output_1059_0 = ( temp_output_1058_0 + _Waveswidth );
				float screenDepth933 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth933 = abs( ( screenDepth933 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( fmod( ( 0.0 - ( ( _Time.y + temp_output_1064_0 ) / 3.0 ) ) , temp_output_1064_0 ) ) );
				float screenDepth910 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth910 = abs( ( screenDepth910 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 0.6 ) );
				float screenDepth966 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth966 = abs( ( screenDepth966 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 0.4 ) );
				float smoothstepResult970 = smoothstep( 0.3 , 0.3 , distanceDepth966);
				float lerpResult967 = lerp( 0.0 , distanceDepth910 , smoothstepResult970);
				float lerpResult912 = lerp( ( ( ( step( distanceDepth902 , temp_output_1058_0 ) - step( distanceDepth902 , temp_output_1057_0 ) ) + ( step( distanceDepth902 , temp_output_1056_0 ) - step( distanceDepth902 , temp_output_1053_0 ) ) + ( step( distanceDepth902 , temp_output_1059_0 ) - step( distanceDepth902 , temp_output_1058_0 ) ) ) + ( ( step( distanceDepth933 , temp_output_1059_0 ) - step( distanceDepth933 , temp_output_1058_0 ) ) + ( step( distanceDepth933 , temp_output_1058_0 ) - step( distanceDepth933 , temp_output_1057_0 ) ) + ( step( distanceDepth933 , temp_output_1056_0 ) - step( distanceDepth933 , temp_output_1053_0 ) ) ) ) , 0.0 , lerpResult967);
				float2 uv953 = IN.ase_texcoord8.yz * float2( 5,5 ) + float2( 0,0 );
				float4 lerpResult1051 = lerp( step( tex2D( _PerlinNoise6, uv953 ) , float4( 0.191,0.191,0.191,0 ) ) , float4( 0,0,0,0 ) , _Wavesnoisecutout);
				float lerpResult956 = lerp( lerpResult912 , 0.0 , lerpResult1051.r);
				float clampResult963 = clamp( lerpResult956 , 0.0 , 1.0 );
				float Waves_pattern957 = clampResult963;
				float4 lerpResult960 = lerp( lerpResult883 , _Wavescolor , ( Waves_pattern957 * _Wavesintensity ));
				float2 uv1023 = IN.ase_texcoord8.yz * float2( 110,110 ) + float2( 0,0 );
				float4 tex2DNode1020 = tex2D( _PerlinNoise6, uv1023 );
				float dotResult1022 = dot( tex2DNode1020 , tex2DNode1020 );
				float dotResult1024 = dot( dotResult1022 , dotResult1022 );
				float dotResult1025 = dot( dotResult1024 , dotResult1024 );
				float dotResult1029 = dot( dotResult1025 , dotResult1025 );
				float dotResult1026 = dot( dotResult1029 , 0.01 );
				float2 uv1033 = IN.ase_texcoord8.yz * float2( 10,10 ) + float2( 0,0 );
				float4 clampResult1035 = clamp( tex2D( _PerlinNoise6, uv1033 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
				float dotResult1034 = dot( clampResult1035 , clampResult1035 );
				float dotResult1036 = dot( dotResult1034 , dotResult1034 );
				float lerpResult1032 = lerp( 0.0 , pow( dotResult1026 , 3.0 ) , pow( dotResult1036 , 3.0 ));
				float clampResult1028 = clamp( lerpResult1032 , 0.0 , 1.0 );
				float smoothstepResult1046 = smoothstep( 0.3 , 0.4 , WorldSpaceViewDirection.y);
				float lerpResult1039 = lerp( clampResult1028 , 0.0 , pow( smoothstepResult1046 , 1.0 ));
				float Fake_reflections1040 = lerpResult1039;
				float4 lerpResult1027 = lerp( lerpResult960 , _Fakereflectionscolor , Fake_reflections1040);
				
				float lerpResult1043 = lerp( 0.0 , 1.0 , Fake_reflections1040);
				float3 temp_cast_19 = (lerpResult1043).xxx;
				
				float screenDepth690 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth690 = abs( ( screenDepth690 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 0.5 ) );
				float clampResult691 = clamp( pow( distanceDepth690 , _Edge_fade ) , 0.0 , 1.0 );
				float _edgeFade695 = clampResult691;
				
				
		        float3 Albedo = lerpResult1027.rgb;
				float3 Normal = _Normal577;
				float3 Emission = temp_cast_19;
				float3 Specular = float3(0.5, 0.5, 0.5);
				float Metallic = 0;
				float Smoothness = _Smoothness_level;
				float Occlusion = 1;
				float Alpha = ( 0.4 * _edgeFade695 );
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
			sampler2D _Normalmapinput;
			float _Normal1_intensity;
			float2 _UV1_speed;
			float _UV1_tiling;
			float _Normal2_intensity;
			float2 _UV2_speed;
			float _UV2_tiling;
			float _Normal_blend;
			float _Vertexdicplacementlevel;
			uniform sampler2D _CameraDepthTexture;
			float _Edge_fade;
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

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float2 appendResult579 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 _world_UV582 = ( appendResult579 / 1.0 );
				float2 panner565 = ( _Time.x * _UV1_speed + ( _world_UV582 * _UV1_tiling ));
				float2 UV1566 = panner565;
				float2 panner564 = ( _Time.y * _UV2_speed + ( _world_UV582 * _UV2_tiling ));
				float2 UV2567 = panner564;
				float3 lerpResult576 = lerp( UnpackNormalmapRGorAG( tex2Dlod( _Normalmapinput, float4( UV1566, 0, 0.0) ), _Normal1_intensity ) , UnpackNormalmapRGorAG( tex2Dlod( _Normalmapinput, float4( UV2567, 0, 0.0) ), _Normal2_intensity ) , _Normal_blend);
				float3 _Normal577 = lerpResult576;
				float4 transform514 = mul(unity_ObjectToWorld,float4( _Normal577 , 0.0 ));
				float _vector_displacement544 = ( transform514.y * _Vertexdicplacementlevel );
				float3 temp_cast_1 = (_vector_displacement544).xxx;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord7 = screenPos;
				

				v.vertex.xyz += temp_cast_1;
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

               float4 screenPos = IN.ase_texcoord7;
               float4 ase_screenPosNorm = screenPos / screenPos.w;
               ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
               float screenDepth690 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
               float distanceDepth690 = abs( ( screenDepth690 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 0.5 ) );
               float clampResult691 = clamp( pow( distanceDepth690 , _Edge_fade ) , 0.0 , 1.0 );
               float _edgeFade695 = clampResult691;
               

				float Alpha = ( 0.4 * _edgeFade695 );
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
			sampler2D _Normalmapinput;
			float _Normal1_intensity;
			float2 _UV1_speed;
			float _UV1_tiling;
			float _Normal2_intensity;
			float2 _UV2_speed;
			float _UV2_tiling;
			float _Normal_blend;
			float _Vertexdicplacementlevel;
			uniform sampler2D _CameraDepthTexture;
			float _Edge_fade;
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

				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float2 appendResult579 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 _world_UV582 = ( appendResult579 / 1.0 );
				float2 panner565 = ( _Time.x * _UV1_speed + ( _world_UV582 * _UV1_tiling ));
				float2 UV1566 = panner565;
				float2 panner564 = ( _Time.y * _UV2_speed + ( _world_UV582 * _UV2_tiling ));
				float2 UV2567 = panner564;
				float3 lerpResult576 = lerp( UnpackNormalmapRGorAG( tex2Dlod( _Normalmapinput, float4( UV1566, 0, 0.0) ), _Normal1_intensity ) , UnpackNormalmapRGorAG( tex2Dlod( _Normalmapinput, float4( UV2567, 0, 0.0) ), _Normal2_intensity ) , _Normal_blend);
				float3 _Normal577 = lerpResult576;
				float4 transform514 = mul(unity_ObjectToWorld,float4( _Normal577 , 0.0 ));
				float _vector_displacement544 = ( transform514.y * _Vertexdicplacementlevel );
				float3 temp_cast_1 = (_vector_displacement544).xxx;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord = screenPos;
				

				v.vertex.xyz += temp_cast_1;
				v.ase_normal =  v.ase_normal ;

        	    o.clipPos = TransformObjectToHClip(v.vertex.xyz);
        	    return o;
            }

            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

				float4 screenPos = IN.ase_texcoord;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float screenDepth690 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
				float distanceDepth690 = abs( ( screenDepth690 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 0.5 ) );
				float clampResult691 = clamp( pow( distanceDepth690 , _Edge_fade ) , 0.0 , 1.0 );
				float _edgeFade695 = clampResult691;
				

				float Alpha = ( 0.4 * _edgeFade695 );
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


            #define REQUIRE_OPAQUE_TEXTURE 1


			uniform float4 _MainTex_ST;

            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/MetaInput.hlsl"
            #include "Packages/com.unity.render-pipelines.lightweight/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"

			CBUFFER_START(UnityPerMaterial)
			sampler2D _Normalmapinput;
			float _Normal1_intensity;
			float2 _UV1_speed;
			float _UV1_tiling;
			float _Normal2_intensity;
			float2 _UV2_speed;
			float _UV2_tiling;
			float _Normal_blend;
			float _Vertexdicplacementlevel;
			float4 _Shorecolor;
			float4 _Depth_Top_Color;
			float4 _Depth_bottom_color;
			uniform sampler2D _CameraDepthTexture;
			float _Depth_multiply;
			sampler2D _TextureSnap;
			float _Underwater_Distortion;
			float _Activated;
			float _Reflection_power;
			float _Depth_Intensity;
			float4 _Top_mask_color_shift;
			float _Watertopmasklevel;
			sampler2D _water_caustic;
			sampler2D _PerlinNoise6;
			float _caustic_tilling;
			float2 _Caustic_speed;
			float _Caustic_parallax;
			float _Caustic_intensity;
			float4 _Foamcolor;
			float _Foam_contrast;
			sampler2D _a710fa1f1165b699bccefec099930acf;
			float _Edge_Foam_Tiling;
			float _Foam_Amount;
			float4 _Wavescolor;
			float _Waveswidth;
			float _Wavesnoisecutout;
			float _Wavesintensity;
			float4 _Fakereflectionscolor;
			float _Edge_fade;
			CBUFFER_END
			
			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float4 CalculateContrast( float contrastValue, float4 colorTarget )
			{
				float t = 0.5 * ( 1.0 - contrastValue );
				return mul( float4x4( contrastValue,0,0,t, 0,contrastValue,0,t, 0,0,contrastValue,t, 0,0,0,1 ), colorTarget );
			}

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
                float4 ase_texcoord4 : TEXCOORD4;
                float4 ase_texcoord5 : TEXCOORD5;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
        	};

            VertexOutput vert(GraphVertexInput v)
            {
                VertexOutput o = (VertexOutput)0;
        	    UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				float3 ase_worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float2 appendResult579 = (float2(ase_worldPos.x , ase_worldPos.z));
				float2 _world_UV582 = ( appendResult579 / 1.0 );
				float2 panner565 = ( _Time.x * _UV1_speed + ( _world_UV582 * _UV1_tiling ));
				float2 UV1566 = panner565;
				float2 panner564 = ( _Time.y * _UV2_speed + ( _world_UV582 * _UV2_tiling ));
				float2 UV2567 = panner564;
				float3 lerpResult576 = lerp( UnpackNormalmapRGorAG( tex2Dlod( _Normalmapinput, float4( UV1566, 0, 0.0) ), _Normal1_intensity ) , UnpackNormalmapRGorAG( tex2Dlod( _Normalmapinput, float4( UV2567, 0, 0.0) ), _Normal2_intensity ) , _Normal_blend);
				float3 _Normal577 = lerpResult576;
				float4 transform514 = mul(unity_ObjectToWorld,float4( _Normal577 , 0.0 ));
				float _vector_displacement544 = ( transform514.y * _Vertexdicplacementlevel );
				float3 temp_cast_1 = (_vector_displacement544).xxx;
				
				float4 ase_clipPos = TransformObjectToHClip((v.vertex).xyz);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord = screenPos;
				float3 objectToViewPos = TransformWorldToView(TransformObjectToWorld(v.vertex.xyz));
				float eyeDepth = -objectToViewPos.z;
				o.ase_texcoord1.x = eyeDepth;
				o.ase_texcoord1.yzw = ase_worldPos;
				float3 ase_worldTangent = TransformObjectToWorldDir(v.ase_tangent.xyz);
				o.ase_texcoord3.xyz = ase_worldTangent;
				float3 ase_worldNormal = TransformObjectToWorldNormal(v.ase_normal);
				o.ase_texcoord4.xyz = ase_worldNormal;
				float ase_vertexTangentSign = v.ase_tangent.w * unity_WorldTransformParams.w;
				float3 ase_worldBitangent = cross( ase_worldNormal, ase_worldTangent ) * ase_vertexTangentSign;
				o.ase_texcoord5.xyz = ase_worldBitangent;
				
				o.ase_texcoord2.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord2.zw = 0;
				o.ase_texcoord3.w = 0;
				o.ase_texcoord4.w = 0;
				o.ase_texcoord5.w = 0;

				v.vertex.xyz += temp_cast_1;
				v.ase_normal =  v.ase_normal ;
				
                o.clipPos = MetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord1.xy, unity_LightmapST);
        	    return o;
            }

            half4 frag(VertexOutput IN) : SV_TARGET
            {
                UNITY_SETUP_INSTANCE_ID(IN);

           		float4 screenPos = IN.ase_texcoord;
           		float eyeDepth496 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float4 temp_cast_0 = (abs( ( eyeDepth496 - ( screenPos.w * 1.0 ) ) )).xxxx;
           		float4 blendOpSrc648 = float4(0.08235294,0.1647059,0.2117647,0);
           		float4 blendOpDest648 = temp_cast_0;
           		float4 lerpResult503 = lerp( _Depth_Top_Color , _Depth_bottom_color , ( ( saturate( 2.0f*blendOpDest648*blendOpSrc648 + blendOpDest648*blendOpDest648*(1.0f - 2.0f*blendOpSrc648) )) * _Depth_multiply ));
           		float eyeDepth = IN.ase_texcoord1.x;
           		float cameraDepthFade978 = (( eyeDepth -_ProjectionParams.y - 3.0 ) / 10.0);
           		float clampResult981 = clamp( cameraDepthFade978 , 0.0 , 1.0 );
           		float4 lerpResult979 = lerp( _Shorecolor , lerpResult503 , clampResult981);
           		float4 ase_screenPosNorm = screenPos / screenPos.w;
           		ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
           		float screenDepth983 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float distanceDepth983 = abs( ( screenDepth983 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 1.0 ) );
           		float clampResult984 = clamp( distanceDepth983 , 0.9 , 1.0 );
           		float4 lerpResult982 = lerp( _Shorecolor , lerpResult979 , clampResult984);
           		float4 _depth635 = lerpResult982;
           		float4 normalizeResult1071 = normalize( screenPos );
           		float4 break1072 = normalizeResult1071;
           		float2 appendResult660 = (float2(break1072.x , break1072.y));
           		float3 ase_worldPos = IN.ase_texcoord1.yzw;
           		float2 appendResult579 = (float2(ase_worldPos.x , ase_worldPos.z));
           		float2 _world_UV582 = ( appendResult579 / 1.0 );
           		float2 panner565 = ( _Time.x * _UV1_speed + ( _world_UV582 * _UV1_tiling ));
           		float2 UV1566 = panner565;
           		float2 panner564 = ( _Time.y * _UV2_speed + ( _world_UV582 * _UV2_tiling ));
           		float2 UV2567 = panner564;
           		float3 lerpResult576 = lerp( UnpackNormalmapRGorAG( tex2D( _Normalmapinput, UV1566 ), _Normal1_intensity ) , UnpackNormalmapRGorAG( tex2D( _Normalmapinput, UV2567 ), _Normal2_intensity ) , _Normal_blend);
           		float3 _Normal577 = lerpResult576;
           		float3 temp_output_667_0 = ( float3( ( appendResult660 / break1072.w ) ,  0.0 ) + ( _Normal577 * _Underwater_Distortion ) );
           		float4 lerpResult1048 = lerp( float4( 0,0,0,0 ) , tex2D( _TextureSnap, temp_output_667_0.xy ) , _Activated);
           		float4 fetchOpaqueVal670 = SAMPLE_TEXTURE2D( _CameraOpaqueTexture, sampler_CameraOpaqueTexture, temp_output_667_0.xy);
           		float3 ase_worldViewDir = ( _WorldSpaceCameraPos.xyz - ase_worldPos );
           		ase_worldViewDir = normalize(ase_worldViewDir);
           		float4 lerpResult901 = lerp( lerpResult1048 , fetchOpaqueVal670 , ase_worldViewDir.y);
           		float4 lerpResult895 = lerp( lerpResult901 , lerpResult1048 , _Reflection_power);
           		float screenDepth890 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float distanceDepth890 = abs( ( screenDepth890 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 7.0 ) );
           		float4 lerpResult889 = lerp( lerpResult895 , float4( 0.1218642,0,0,0 ) , distanceDepth890);
           		float4 lerpResult891 = lerp( lerpResult895 , lerpResult889 , _Depth_Intensity);
           		float3 normalizeResult669 = normalize( ( _MainLightPosition.xyz + ase_worldViewDir ) );
           		float4 lerpResult677 = lerp( lerpResult891 , float4( normalizeResult669 , 0.0 ) , float4( 0,0,0,0 ));
           		float4 lerpResult1073 = lerp( lerpResult677 , _MainLightColor , float4( 0.021,0.021,0.021,0 ));
           		float4 _Underwater_distortion675 = lerpResult1073;
           		float4 blendOpSrc507 = _depth635;
           		float4 blendOpDest507 = _Underwater_distortion675;
           		float4 lerpResult517 = lerp( ( saturate( 2.0f*blendOpDest507*blendOpSrc507 + blendOpDest507*blendOpDest507*(1.0f - 2.0f*blendOpSrc507) )) , 0 , float4( 0,0,0,0 ));
           		float4 transform514 = mul(unity_ObjectToWorld,float4( _Normal577 , 0.0 ));
           		float4 temp_cast_7 = (transform514.y).xxxx;
           		float4 blendOpSrc598 = _Top_mask_color_shift;
           		float4 blendOpDest598 = temp_cast_7;
           		float4 temp_cast_8 = (transform514.y).xxxx;
           		float4 blendOpSrc593 = temp_cast_8;
           		float4 blendOpDest593 = float4(1,1,1,0);
           		float4 blendOpSrc606 = ( saturate( 2.0f*blendOpDest598*blendOpSrc598 + blendOpDest598*blendOpDest598*(1.0f - 2.0f*blendOpSrc598) ));
           		float4 blendOpDest606 = ( saturate( 2.0f*blendOpDest593*blendOpSrc593 + blendOpDest593*blendOpDest593*(1.0f - 2.0f*blendOpSrc593) ));
           		float4 blendOpSrc607 = ( ( saturate( ( blendOpSrc606 + blendOpDest606 - 1.0 ) )) * _Watertopmasklevel );
           		float4 blendOpDest607 = float4( 0,0,0,0 );
           		float4 Water_top_mask621 = ( saturate( ( 1.0 - ( 1.0 - blendOpSrc607 ) * ( 1.0 - blendOpDest607 ) ) ));
           		float4 blendOpSrc623 = lerpResult517;
           		float4 blendOpDest623 = Water_top_mask621;
           		float4 _Water_color_blend639 = ( saturate( ( blendOpSrc623 + blendOpDest623 ) ));
           		float2 temp_cast_9 = (_caustic_tilling).xx;
           		float2 uv1015 = IN.ase_texcoord2.xy * temp_cast_9 + float2( 0,0 );
           		float2 panner1016 = ( 1.0 * _Time.y * float2( 0.1,0 ) + uv1015);
           		float2 temp_cast_10 = (_caustic_tilling).xx;
           		float2 uv733 = IN.ase_texcoord2.xy * temp_cast_10 + float2( 0,0 );
           		float2 panner746 = ( _Time.x * _Caustic_speed + uv733);
           		float screenDepth784 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float distanceDepth784 = abs( ( screenDepth784 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 2.0 ) );
           		float4 lerpResult797 = lerp( float4(1,1,1,0) , float4( 0,0,0,0 ) , distanceDepth784);
           		float3 hsvTorgb787 = HSVToRGB( float3(0.0,0.0,lerpResult797.r) );
           		float3 ase_worldTangent = IN.ase_texcoord3.xyz;
           		float3 ase_worldNormal = IN.ase_texcoord4.xyz;
           		float3 ase_worldBitangent = IN.ase_texcoord5.xyz;
           		float3 tanToWorld0 = float3( ase_worldTangent.x, ase_worldBitangent.x, ase_worldNormal.x );
           		float3 tanToWorld1 = float3( ase_worldTangent.y, ase_worldBitangent.y, ase_worldNormal.y );
           		float3 tanToWorld2 = float3( ase_worldTangent.z, ase_worldBitangent.z, ase_worldNormal.z );
           		float3 ase_tanViewDir =  tanToWorld0 * ase_worldViewDir.x + tanToWorld1 * ase_worldViewDir.y  + tanToWorld2 * ase_worldViewDir.z;
           		ase_tanViewDir = normalize(ase_tanViewDir);
           		float2 Offset725 = ( ( hsvTorgb787.x - 1 ) * ase_tanViewDir.xy * _Caustic_parallax ) + panner746;
           		float grayscale753 = Luminance(tex2D( _water_caustic, ( UnpackNormalmapRGorAG( tex2D( _PerlinNoise6, panner1016 ), 0.05 ) + float3( Offset725 ,  0.0 ) ).xy ).rgb);
           		float clampResult790 = clamp( pow( distanceDepth784 , 10.0 ) , 100.0 , 0.5 );
           		float4 _caustic729 = ( ( grayscale753 * lerpResult982 ) * clampResult790 );
           		float4 blendOpSrc730 = _Water_color_blend639;
           		float4 blendOpDest730 = ( _caustic729 * _Caustic_intensity );
           		float2 temp_cast_15 = (_Edge_Foam_Tiling).xx;
           		float2 uv877 = IN.ase_texcoord2.xy * temp_cast_15 + float2( 0,0 );
           		float screenDepth807 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float distanceDepth807 = abs( ( screenDepth807 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( _Foam_Amount ) );
           		float4 temp_cast_16 = (distanceDepth807).xxxx;
           		float4 lerpResult853 = lerp( CalculateContrast(_Foam_contrast,tex2D( _a710fa1f1165b699bccefec099930acf, uv877 )) , float4( 0,0,0,0 ) , CalculateContrast(( _Foam_contrast * 2.0 ),temp_cast_16));
           		float4 Waves866 = lerpResult853;
           		float4 clampResult884 = clamp( Waves866 , float4( 0,0,0,0 ) , float4( 1,0,0,0 ) );
           		float4 lerpResult883 = lerp( ( saturate( max( blendOpSrc730, blendOpDest730 ) )) , _Foamcolor , clampResult884);
           		float temp_output_1064_0 = ( ( 1.1 - _Waveswidth ) * 5.0 );
           		float screenDepth902 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float distanceDepth902 = abs( ( screenDepth902 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( fmod( ( 0.0 - ( _Time.y / 3.0 ) ) , temp_output_1064_0 ) ) );
           		float temp_output_1053_0 = ( 0.1 + _Waveswidth );
           		float temp_output_1056_0 = ( temp_output_1053_0 + _Waveswidth );
           		float temp_output_1057_0 = ( temp_output_1056_0 + _Waveswidth );
           		float temp_output_1058_0 = ( temp_output_1057_0 + _Waveswidth );
           		float temp_output_1059_0 = ( temp_output_1058_0 + _Waveswidth );
           		float screenDepth933 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float distanceDepth933 = abs( ( screenDepth933 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( fmod( ( 0.0 - ( ( _Time.y + temp_output_1064_0 ) / 3.0 ) ) , temp_output_1064_0 ) ) );
           		float screenDepth910 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float distanceDepth910 = abs( ( screenDepth910 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 0.6 ) );
           		float screenDepth966 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float distanceDepth966 = abs( ( screenDepth966 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 0.4 ) );
           		float smoothstepResult970 = smoothstep( 0.3 , 0.3 , distanceDepth966);
           		float lerpResult967 = lerp( 0.0 , distanceDepth910 , smoothstepResult970);
           		float lerpResult912 = lerp( ( ( ( step( distanceDepth902 , temp_output_1058_0 ) - step( distanceDepth902 , temp_output_1057_0 ) ) + ( step( distanceDepth902 , temp_output_1056_0 ) - step( distanceDepth902 , temp_output_1053_0 ) ) + ( step( distanceDepth902 , temp_output_1059_0 ) - step( distanceDepth902 , temp_output_1058_0 ) ) ) + ( ( step( distanceDepth933 , temp_output_1059_0 ) - step( distanceDepth933 , temp_output_1058_0 ) ) + ( step( distanceDepth933 , temp_output_1058_0 ) - step( distanceDepth933 , temp_output_1057_0 ) ) + ( step( distanceDepth933 , temp_output_1056_0 ) - step( distanceDepth933 , temp_output_1053_0 ) ) ) ) , 0.0 , lerpResult967);
           		float2 uv953 = IN.ase_texcoord2.xy * float2( 5,5 ) + float2( 0,0 );
           		float4 lerpResult1051 = lerp( step( tex2D( _PerlinNoise6, uv953 ) , float4( 0.191,0.191,0.191,0 ) ) , float4( 0,0,0,0 ) , _Wavesnoisecutout);
           		float lerpResult956 = lerp( lerpResult912 , 0.0 , lerpResult1051.r);
           		float clampResult963 = clamp( lerpResult956 , 0.0 , 1.0 );
           		float Waves_pattern957 = clampResult963;
           		float4 lerpResult960 = lerp( lerpResult883 , _Wavescolor , ( Waves_pattern957 * _Wavesintensity ));
           		float2 uv1023 = IN.ase_texcoord2.xy * float2( 110,110 ) + float2( 0,0 );
           		float4 tex2DNode1020 = tex2D( _PerlinNoise6, uv1023 );
           		float dotResult1022 = dot( tex2DNode1020 , tex2DNode1020 );
           		float dotResult1024 = dot( dotResult1022 , dotResult1022 );
           		float dotResult1025 = dot( dotResult1024 , dotResult1024 );
           		float dotResult1029 = dot( dotResult1025 , dotResult1025 );
           		float dotResult1026 = dot( dotResult1029 , 0.01 );
           		float2 uv1033 = IN.ase_texcoord2.xy * float2( 10,10 ) + float2( 0,0 );
           		float4 clampResult1035 = clamp( tex2D( _PerlinNoise6, uv1033 ) , float4( 0,0,0,0 ) , float4( 1,1,1,0 ) );
           		float dotResult1034 = dot( clampResult1035 , clampResult1035 );
           		float dotResult1036 = dot( dotResult1034 , dotResult1034 );
           		float lerpResult1032 = lerp( 0.0 , pow( dotResult1026 , 3.0 ) , pow( dotResult1036 , 3.0 ));
           		float clampResult1028 = clamp( lerpResult1032 , 0.0 , 1.0 );
           		float smoothstepResult1046 = smoothstep( 0.3 , 0.4 , ase_worldViewDir.y);
           		float lerpResult1039 = lerp( clampResult1028 , 0.0 , pow( smoothstepResult1046 , 1.0 ));
           		float Fake_reflections1040 = lerpResult1039;
           		float4 lerpResult1027 = lerp( lerpResult960 , _Fakereflectionscolor , Fake_reflections1040);
           		
           		float lerpResult1043 = lerp( 0.0 , 1.0 , Fake_reflections1040);
           		float3 temp_cast_19 = (lerpResult1043).xxx;
           		
           		float screenDepth690 = LinearEyeDepth(tex2Dproj( _CameraDepthTexture, screenPos ).r,_ZBufferParams);
           		float distanceDepth690 = abs( ( screenDepth690 - LinearEyeDepth( ase_screenPosNorm.z,_ZBufferParams ) ) / ( 0.5 ) );
           		float clampResult691 = clamp( pow( distanceDepth690 , _Edge_fade ) , 0.0 , 1.0 );
           		float _edgeFade695 = clampResult691;
           		
				
		        float3 Albedo = lerpResult1027.rgb;
				float3 Emission = temp_cast_19;
				float Alpha = ( 0.4 * _edgeFade695 );
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


//CHKSM=32A0F554CE49C7FFBE0F80E467FA18BFFDB2BC3A