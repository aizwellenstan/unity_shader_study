using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PostProcess1 : MonoBehaviour
{
    public Texture texture;

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        Material mat = new Material(Shader.Find("Unlit/Laplace"));
        mat.SetFloat("_Slider", 0.005f);
        mat.SetTexture("_MainTex1", texture);
        Graphics.Blit(texture, dst, mat);
    }
}
