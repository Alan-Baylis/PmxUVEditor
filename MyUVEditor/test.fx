// ���@�ϊ��s��
float4x4 WorldViewProjMatrix      : WORLDVIEWPROJECTION;
float4x4 WorldMatrix              : WORLD;
float4x4 LightWorldViewProjMatrix : WORLDVIEWPROJECTION < string Object = "Light"; >;

float3   LightDirection    : DIRECTION < string Object = "Light"; >;
float3   CameraPosition    : POSITION  < string Object = "Camera"; >;

// �}�e���A���F
float4   MaterialDiffuse   : DIFFUSE  < string Object = "Geometry"; >;
float3   MaterialAmbient   : AMBIENT  < string Object = "Geometry"; >;
float3   MaterialEmmisive  : EMISSIVE < string Object = "Geometry"; >;
float3   MaterialSpecular  : SPECULAR < string Object = "Geometry"; >;
float    SpecularPower : SPECULARPOWER < string Object = "Geometry"; >;
float3   MaterialToon      : TOONCOLOR;
// ���C�g�F
float3   LightDiffuse      : DIFFUSE   < string Object = "Light"; >;
float3   LightAmbient      : AMBIENT   < string Object = "Light"; >;
float3   LightSpecular     : SPECULAR  < string Object = "Light"; >;
static float4 DiffuseColor = MaterialDiffuse  * float4(LightDiffuse, 1.0f);
static float3 AmbientColor = MaterialAmbient  * LightAmbient + MaterialEmmisive;
static float3 SpecularColor = MaterialSpecular * LightSpecular;


struct VS_OUTPUT
{
	float4 Pos        : POSITION;    // �ˉe�ϊ����W
	float2 Tex        : TEXCOORD1;   // �e�N�X�`��
	float3 Normal     : TEXCOORD2;   // �@��
	float3 Eye        : TEXCOORD3;   // �J�����Ƃ̑��Έʒu
	float4 Color      : COLOR0;      // �f�B�t���[�Y�F
	float3 Specular   : COLOR1;      // �X�y�L�����F
};

// ���_�V�F�[�_
VS_OUTPUT Basic_VS(float4 Pos : POSITION, float3 Normal : NORMAL, float2 Tex : TEXCOORD0)
{
	VS_OUTPUT Out = (VS_OUTPUT)0;

	// �J�������_�̃��[���h�r���[�ˉe�ϊ�
	Out.Pos = mul(Pos, WorldViewProjMatrix);

	// �J�����Ƃ̑��Έʒu
	Out.Eye = CameraPosition - mul(Pos, WorldMatrix);
	// ���_�@��
	Out.Normal = normalize(mul(Normal, (float3x3)WorldMatrix));

	// �f�B�t���[�Y�F�{�A���r�G���g�F �v�Z
	Out.Color.rgb = saturate(max(0, dot(Out.Normal, -LightDirection)) * DiffuseColor.rgb + AmbientColor);
	Out.Color.a = DiffuseColor.a;

	// �e�N�X�`�����W
	Out.Tex = Tex;

	// �X�y�L�����F�v�Z
	float3 HalfVector = normalize(normalize(Out.Eye) + -LightDirection);
		Out.Specular = pow(max(0, dot(HalfVector, Out.Normal)), SpecularPower) * SpecularColor;

	return Out;
}


// �s�N�Z���V�F�[�_
float4 Basic_PS(VS_OUTPUT IN) : COLOR0
{
	float4 Color = IN.Color;

	// �X�y�L�����K�p
	Color.rgb += IN.Specular;

	return Color;
}

// �I�u�W�F�N�g�`��p�e�N�j�b�N
technique MainTec < string MMDPass = "object"; > {
	pass DrawObject
	{
		VertexShader = compile vs_2_0 Basic_VS();
		PixelShader = compile ps_2_0 Basic_PS();
	}
}

float3 UV_VS(float2 Tex : TEXCOORD0) : POSITION
{
	return float3(Tex.X, Tex.Y, 0);
}

float4 UV_VS() : COLOR0
{
	return float4(1, 1, 1, 1);
}

technique UVTec{
	pass DrawUV{
		VertexShader = compile vs_2_0 UV_VS();
		PixelShader = compile ps_2_0 UV_PS();
	}
}