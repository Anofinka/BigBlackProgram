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
    public int damage;
    public int armor;

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

        name = item.name;
        damage = item.damage;
        armor = item.armor;

        // Dodaj skrypt HoverTip do obiektu
        HoverTip hoverTip = gameObject.AddComponent<HoverTip>();

        // Ustaw warto�� tipToShow w HoverTip na nazw� obiektu
        hoverTip.tipToShow = name + "\n";

        if (damage > 0)
            hoverTip.tipToShow += "Damage: " + damage.ToString() + "\n";

        if (armor > 0)
            hoverTip.tipToShow += "Armor: " + armor.ToString() + "\n";

    }

    public void OnPointerClick(PointerEventData eventData)
    {
        if (eventData.button == PointerEventData.InputButton.Left)
        {
            Inventory.Singleton.SetCarriedItem(this);
        }
    }
}
