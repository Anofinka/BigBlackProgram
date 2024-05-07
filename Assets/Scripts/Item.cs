using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Scriptable Objects/Item")]
public class Item : ScriptableObject
{
    public Sprite sprite;
    public SlotTag itemTag;
    public Mesh meshItem;
    public string Kame;
    public string si³a;
    public string hp;
    [Header("If the item can be equipped")]
    public GameObject equipmentPrefab;
}
