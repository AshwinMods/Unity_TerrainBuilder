using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AshTerrainPainter : MonoBehaviour
{
	public Texture2D workingCopy;
	public GameObject target_Mesh;
	public Material target_Mat;
	public Texture2D brush;
	public Material matStroke;
	[System.Serializable]
	public class SpatialChannel
	{
		public string name;
		public Vector2 offset;
		public Vector2 tiling;
		public Texture2D tex;
		public Color col;
	}
	public SpatialChannel[] spatialChannels;
	public int spatialMap_Res = 128;
	public RenderTexture spatialMap;

	public void Init_SpatialMap()
	{
		if (spatialMap != null)
		{
			target_Mat.mainTexture = spatialMap;
			if (spatialMap.width == spatialMap_Res)
				return;
			spatialMap.Release();
		}
		spatialMap = new RenderTexture(spatialMap_Res, spatialMap_Res, 0, RenderTextureFormat.ARGB32);
		Set_SpatialMap(workingCopy);
		target_Mat.mainTexture = spatialMap;
	}

	public void ApplyStroke(Vector2 offset, Vector4 channelMul, float multiplier = 1, float scale = 1f)
	{
		var pass = multiplier < 0 ? 1 : 0;
		var l_offset = -offset * (spatialMap_Res/scale) + Vector2.one * 0.5f;
		var l_scale = Vector2.one * (spatialMap_Res / scale);
		matStroke.SetTextureOffset("_BrushTex", l_offset);
		matStroke.SetTextureScale("_BrushTex", l_scale);
		matStroke.SetTexture("_BrushTex", brush);

		var mul = channelMul * Mathf.Abs(multiplier);
		matStroke.SetVector("_Mul", mul);
		Graphics.Blit(brush, spatialMap, matStroke, pass);

		var inv = Vector4.zero; 
		if (mul.z > 0)
		{
			inv.w = mul.z;
		} else if (mul.y > 0)
		{
			inv.z = mul.y;
			inv.w = mul.y;
		}else if (mul.x > 0)
		{
			inv = Vector4.one * mul.x;
			inv.x = 0;
		}
		if (inv != Vector4.zero)
		{
			matStroke.SetVector("_Mul", inv);
			Graphics.Blit(brush, spatialMap, matStroke, 1);
		}
	}

	public bool Get_TexCoord_At_WorldPos(Vector3 wPos, out Vector3 tc)
	{
		var bounds = target_Mesh.GetComponent<Renderer>().bounds;
		tc = Vector3.Min(wPos, bounds.max);
		tc = Vector3.Max(tc, bounds.min);
		tc -= bounds.min;
		tc.x /= bounds.size.x;
		tc.y /= bounds.size.y;
		tc.z /= bounds.size.z;
		return true;
	}

	public Texture2D Get_SpatialMapTex()
	{
		Init_SpatialMap();
		Texture2D tex = new Texture2D(spatialMap.width, spatialMap.height, TextureFormat.RGBA32, false);
		RenderTexture.active = spatialMap;
		tex.ReadPixels(new Rect(0, 0, spatialMap.width, spatialMap.height), 0, 0);
		tex.Apply();
		return tex;
	}

	public void Set_SpatialMap(Texture2D tex)
	{
		Init_SpatialMap();
		Graphics.Blit(tex, spatialMap);
	}

	private void OnValidate()
	{
		for (int i = 0; i < spatialChannels.Length; i++)
		{
			target_Mat.SetTexture("_T" + (i + 1), spatialChannels[i].tex);
			target_Mat.SetTextureScale("_T" + (i + 1), spatialChannels[i].tiling);
			target_Mat.SetTextureOffset("_T" + (i + 1), spatialChannels[i].offset);
			target_Mat.mainTexture = spatialMap;
		}
	}
}
