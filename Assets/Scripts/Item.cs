using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Scriptable Objects/Item")]
public class Item : ScriptableObject
{
    public Sprite sprite;
    public SlotTag itemTag;
    public Mesh meshItem;

    [Header("Statystyki zbroi")]
    public int armorMin;
    public int armor;
    public int armorMax;

    [Header("Statystyki broni")]
    public int damageMin;
    public int damage;
    public int damageMax;

    [Header("Wymagania")]
    public int requiredStrength;
    public int requiredDexterity;
    public int requiredLevel;

    [Header("If the item can be equipped")]
    public GameObject equipmentPrefab;

    public void GenerateRandomStats()
    {
        // Losowe generowanie statystyk dla przedmiotu
        if (itemTag == SlotTag.Head || itemTag == SlotTag.Chest || itemTag == SlotTag.Legs || itemTag == SlotTag.Boots || itemTag == SlotTag.Necklace || itemTag == SlotTag.Shoulders || itemTag == SlotTag.Ring || itemTag == SlotTag.Cape || itemTag == SlotTag.Gloves) 
        {
            armor = Random.Range(armorMin, armorMax + 1);
        }



        if (itemTag == SlotTag.Weapon)
        {
            damage = Random.Range(damageMin, damageMax + 1);
        }




    }

}
