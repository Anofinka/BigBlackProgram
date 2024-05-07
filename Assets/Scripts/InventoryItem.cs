using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using Unity.VisualScripting.Antlr3.Runtime.Misc;
using UnityEditor.UIElements;

public class InventoryItem : MonoBehaviour, IPointerClickHandler
{
    Image itemIcon;
    public CanvasGroup canvasGroup { get; private set; }

    public Item myItem { get; set; }
    public InventorySlot activeSlot { get; set; }
    public Mesh Mesh2;
    public string tipToShow;
    public string stats;
    public string hp;

    void Awake()
    {
        canvasGroup = GetComponent<CanvasGroup>();
        itemIcon = GetComponent<Image>();
    }

    public void Initialize(Item item, InventorySlot parent)
    {
        activeSlot = parent;
        activeSlot.myItem = this;
        myItem = item;
        itemIcon.sprite = item.sprite;
        Mesh2 = item.meshItem;
        name = item.Kame;
        stats = item.si³a;
        hp = item.hp;

        // Dodaj skrypt HoverTip do obiektu
        HoverTip hoverTip = gameObject.AddComponent<HoverTip>();

        // Ustaw wartoœæ tipToShow w HoverTip na nazwê obiektu
        hoverTip.tipToShow =
    "<size=20>" + name + "</size>" + "\n" +
    "Si³a: " + stats + "\n" +
    "¯ycie: " + hp;


    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (eventData.button == PointerEventData.InputButton.Left)
        {
            Inventory.Singleton.SetCarriedItem(this);
        }
    }
}
