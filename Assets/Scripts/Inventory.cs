using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Inventory : MonoBehaviour
{
    public static Inventory Singleton;
    public static InventoryItem carriedItem;
    [SerializeField] SkinnedMeshRenderer[] eqItems;
    [SerializeField] InventorySlot[] inventorySlots;
    [SerializeField] InventorySlot[] hotbarSlots;
    public CharacterStats characterStats;
    [SerializeField] InventorySlot[] equipmentSlots;
    [SerializeField] Transform draggablesTransform;
    [SerializeField] InventoryItem itemPrefab;

    [Header("Item List")]
    [SerializeField] Item[] items;

    [Header("Debug")]
    [SerializeField] Button giveItemBtn;

    // S這wnik przechowuj鉍y aktualnie za這穎ne przedmioty dla poszczeg鏊nych slot闚
    private Dictionary<SlotTag, InventoryItem> equippedItems = new Dictionary<SlotTag, InventoryItem>();

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
        {
            EquipEquipment(item.activeSlot.myTag, null);
        }

        carriedItem = item;
        carriedItem.canvasGroup.blocksRaycasts = false;
        item.transform.SetParent(draggablesTransform);
    }

    public void EquipEquipment(SlotTag tag, InventoryItem item = null)
    {
        // Funkcja aktualizuj鉍a statystyki na podstawie zdejmowania lub zak豉dania przedmiotu
        void UpdateStats(InventoryItem oldItem, InventoryItem newItem)
        {
            if (oldItem != null)
            {
                if (tag == SlotTag.Weapon)
                    characterStats.strength -= oldItem.damage;
                else
                    characterStats.armor -= oldItem.armor;
            }

            if (newItem != null)
            {
                if (tag == SlotTag.Weapon)
                    characterStats.strength += newItem.damage;
                else
                    characterStats.armor += newItem.armor;
            }
        }

        // Uzyskaj aktualnie za這穎ny przedmiot dla danego slotu
        equippedItems.TryGetValue(tag, out InventoryItem currentEquippedItem);

        if (item == null)
        {
            if (currentEquippedItem != null && currentEquippedItem.myItem != null)
            {
                UpdateStats(currentEquippedItem, null);
                Debug.Log($"Unequipped item from {tag}");
                equippedItems[tag] = null; // Aktualizacja obecnie za這穎nego przedmiotu na null
            }
            else
            {
                Debug.LogWarning($"No item equipped in the {tag} slot to unequip.");
            }
        }
        else
        {
            if (item.myItem != null)
            {
                UpdateStats(currentEquippedItem, item);
                Debug.Log($"Equipped item: {item.myItem.name} ({item.armor}) on {tag}");
                equippedItems[tag] = item; // Aktualizacja obecnie za這穎nego przedmiotu na nowy
            }
            else
            {
                Debug.LogWarning("The item to equip has no valid 'myItem' property.");
            }
        }
    }

    public void SpawnInventoryItem(Item item = null)
    {
        Item _item = item;
        if (_item == null)
        {
            _item = PickRandomItem();
        }

        for (int i = 0; i < inventorySlots.Length; i++)
        {
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
        if (item == null)
        {
            Debug.LogError("Picked up item does not contain Item component!");
            return;
        }

        for (int i = 0; i < inventorySlots.Length; i++)
        {
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
