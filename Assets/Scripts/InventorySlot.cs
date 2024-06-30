using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public enum SlotTag { None, Head, Chest, Legs, Boots, Ring, Necklace, Weapon, Cape, Shoulders, Gloves}

public class InventorySlot : MonoBehaviour, IPointerClickHandler
{
    public InventoryItem myItem { get; set; }

    public SlotTag myTag;

    public void OnPointerClick(PointerEventData eventData)
    {
        if(eventData.button == PointerEventData.InputButton.Left)
        {
            if(Inventory.carriedItem == null) return;
            if(myTag != SlotTag.None && Inventory.carriedItem.myItem.itemTag != myTag) return;
            SetItem(Inventory.carriedItem);
        }
        if (eventData.button == PointerEventData.InputButton.Right)
        {
            if (myItem != null)
            {
                Destroy(myItem.gameObject); // Usuwa przedmiot ze sceny
                myItem = null; // Resetuje referencję do przedmiotu w slocie
                Inventory.carriedItem = null; // Resetuje przenoszony przedmiot
            }
        }
    }   

    public void SetItem(InventoryItem item)
    {
        Inventory.carriedItem = null;

        // Reset old slot
        item.activeSlot.myItem = null;

        // Set current slot
        myItem = item;
        myItem.activeSlot = this;
        myItem.transform.SetParent(transform);
        myItem.canvasGroup.blocksRaycasts = true;

        if(myTag != SlotTag.None)
        { Inventory.Singleton.EquipEquipment(myTag, myItem); }
    }
}
