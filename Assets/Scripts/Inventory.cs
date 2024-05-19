using UnityEngine;
using UnityEngine.UI;

public class Inventory : MonoBehaviour
{
    public static Inventory Singleton;
    public static InventoryItem carriedItem;
    [SerializeField] SkinnedMeshRenderer[] eqItems;
    // public Mesh originalMesh = null;
    [SerializeField] InventorySlot[] inventorySlots;
    [SerializeField] InventorySlot[] hotbarSlots;
    public CharacterStats characterStats;
    // 0=Head, 1=Chest, 2=Legs, 3=Feet
    [SerializeField] InventorySlot[] equipmentSlots;
    private InventoryItem currentEquippedItem;
    [SerializeField] Transform draggablesTransform;
    [SerializeField] InventoryItem itemPrefab;

    [Header("Item List")]
    [SerializeField] Item[] items;

    [Header("Debug")]
    [SerializeField] Button giveItemBtn;

    void Awake()
    {
        Singleton = this;
        giveItemBtn.onClick.AddListener(delegate { SpawnInventoryItem(); });
    }

    void Update()
    {
        if (carriedItem == null) return;

        carriedItem.transform.position = Input.mousePosition;

    }

    public void SetCarriedItem(InventoryItem item)
    {
        if (carriedItem != null)
        {
            if (item.activeSlot.myTag != SlotTag.None && item.activeSlot.myTag != carriedItem.myItem.itemTag) return;
            item.activeSlot.SetItem(carriedItem);
        }

        if (item.activeSlot.myTag != SlotTag.None)
        { EquipEquipment(item.activeSlot.myTag, null); }

        carriedItem = item;
        carriedItem.canvasGroup.blocksRaycasts = false;
        item.transform.SetParent(draggablesTransform);
    }

   // int damage;
   // int armor, armor0, armor1, armor2, armor3;


    public void EquipEquipment(SlotTag tag, InventoryItem item = null)
    {
        //SkinnedMeshRenderer originalMesh;
       
                 
        switch (tag)
        {
            case SlotTag.Head:
                if (item == null)
                {
                    if (currentEquippedItem != null && currentEquippedItem.myItem != null)
                    {
                        characterStats.armor -= currentEquippedItem.armor;
                        Debug.Log("Unequipped helmet on " + tag);
                        // UpdateMesh(eqItems[0], originalMesh);
                        currentEquippedItem = null; // Aktualizacja obecnie za³o¿onego przedmiotu na null
                    }
                    else
                    {
                        Debug.LogWarning("No item equipped in the head slot to unequip.");
                    }
                }
                else
                {
                    if (item.myItem != null)
                    {
                        characterStats.armor += item.armor;
                        Debug.Log("Equipped helmet: " + item.myItem.name + " on " + item.armor + " " +tag);
                        // UpdateMesh(eqItems[0], item.Mesh2);
                        currentEquippedItem = item; // Aktualizacja obecnie za³o¿onego przedmiotu na nowy
                    }
                    else
                    {
                        Debug.LogWarning("The item to equip has no valid 'myItem' property.");
                    }
                }
                break;
            case SlotTag.Legs:
                if (item == null)
                {
                    
                    // Zdejmowanie elementu z g³owy, przywrócenie oryginalnej siatki
                    Debug.Log("Unequipped helmet on " + tag);
                   // UpdateMesh(eqItems[2], originalMesh);
                }
                else
                {
                    
                    // Za³o¿enie nowego elementu na g³owê
                    Debug.Log("Equipped helmet: " + item.myItem.name + " on " + tag);
                   // UpdateMesh(eqItems[2], item.Mesh2);
                }
                break;
            case SlotTag.Boots:
                if (item == null)
                {
                   
                    // Zdejmowanie elementu z g³owy, przywrócenie oryginalnej siatki
                    Debug.Log("Unequipped helmet on " + tag);
                   // UpdateMesh(eqItems[3], originalMesh);
                }
                else
                {
                    
                    // Za³o¿enie nowego elementu na g³owê
                    Debug.Log("Equipped helmet: " + item.myItem.name + " on " + tag);
                  //  UpdateMesh(eqItems[3], item.Mesh2);
                }
                break;
            case SlotTag.Weapon:
                if (item == null)
                {

                    // Zdejmowanie elementu z g³owy, przywrócenie oryginalnej siatki
                    Debug.Log("Unequipped" + tag + " ");
                  //  UpdateMesh(eqItems[3], originalMesh);

                }
                else
                {
                  
                    // Za³o¿enie nowego elementu na g³owê
                    Debug.Log("Equipped: " + item.myItem.name + " on " + tag);
                   // UpdateMesh(eqItems[3], item.Mesh2);

                }
                break;
        }

        
    }

    public void SpawnInventoryItem(Item item = null)
    {
        Item _item = item;
        if (_item == null)
        { _item = PickRandomItem(); }

        for (int i = 0; i < inventorySlots.Length; i++)
        {
            // Check if the slot is empty
            if (inventorySlots[i].myItem == null)
            {
                Instantiate(itemPrefab, inventorySlots[i].transform).Initialize(_item, inventorySlots[i]);
                break;
            }
        }
    }

    Item PickRandomItem()
    {
        int random = Random.Range(0, items.Length);
        return items[random];
    }
    void AddItemToEquipment(InventoryItem item)
    {
        foreach (var slot in equipmentSlots)
        {
            if (slot.myTag == item.myItem.itemTag && slot.myItem == null)
            {
                Instantiate(itemPrefab, slot.transform).Initialize(item.myItem, slot);
                break;
            }
        }
    }
    public void SpawnInventoryItem2(Item item)
    {
        //Item item = pickedUpItem.GetComponent<Item>();

        if (item == null)
        {
            Debug.LogError("Picked up item does not contain Item component!");
            return;
        }
        //Debug.LogError("Picked up item ");
        for (int i = 0; i < inventorySlots.Length; i++)
        {
            // Check if the slot is empty
            if (inventorySlots[i].myItem == null)
            {
                Instantiate(itemPrefab, inventorySlots[i].transform).Initialize(item, inventorySlots[i]);
                break;
            }
        }
    }
    public void UpdateMesh(SkinnedMeshRenderer renderer, Mesh newMesh)
    {
        renderer.sharedMesh = newMesh;
    }

}
