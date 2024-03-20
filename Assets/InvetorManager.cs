using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.UI;

public class InvetorManager : MonoBehaviour
{
    public static InvetorManager Instance;
    public List<Item> Items = new List<Item>();
    public Transform ItemContent;
    public GameObject InventoryItem;
 /*  private void Update()
   {
        // Automatyczne odœwie¿anie listy w ka¿dej klatce
      ListItems();
   }*/

    private void Awake()
    {
        Instance = this; 
    }
    public void Add(Item item)

    { 
        Items.Add(item);
    }
    public void Remove(Item item)
    {
        Items.Remove(item);
    }
    public void ListItems()
    {
        foreach (Transform item in ItemContent)
        {
            Destroy(item.gameObject);
        }
        foreach (var item in Items) 
        { 
            GameObject obj = Instantiate(InventoryItem, ItemContent);
            var ItemName = obj.transform.Find("ItemName").GetComponent<Text>();
            var ItemIcon = obj.transform.Find("ItemIcon").GetComponent<Image>();
            ItemName.text = item.ItemName;
            ItemIcon.sprite = item.icon;


        }
    }
}
