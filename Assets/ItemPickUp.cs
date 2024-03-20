using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemPickUp : MonoBehaviour
{
    public Item item;
    void Pickup()
    {
        InvetorManager.Instance.Add(item);
        InvetorManager.Instance.ListItems();
        InvetorManager.Instance.Add(item);
        Destroy(gameObject);
    }
    private void OnMouseDown()
    {
        Pickup();
    }


}
