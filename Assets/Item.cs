using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[CreateAssetMenu(fileName="New Item", menuName ="Item/Create new item")]
public class Item : ScriptableObject
{
    public int id;
    public new string name;
    public int value;
    public Sprite icon;

    public string ItemName { get; internal set; }
}
