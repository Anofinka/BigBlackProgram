using UnityEngine;

public class PicItem_Rn : MonoBehaviour
{
    public Item item;
    public Inventory inv;

    public float pickUpRadius = 5f; // Promieñ, w jakim postaæ mo¿e podnosiæ przedmioty

    private void OnMouseDown()
    {
        if (IsInRange())
        {
            PickUp();
        }
    }

    private bool IsInRange()
    {
        // Sprawdzamy odleg³oœæ miêdzy graczem (tag "Player") a obiektem PicItem_Rn
        GameObject player = GameObject.FindGameObjectWithTag("Player");
        if (player != null)
        {
            float distance = Vector3.Distance(transform.position, player.transform.position);
            return distance <= pickUpRadius;
        }
        return false;
    }

    void PickUp()
    {
        inv.SpawnInventoryItem2(item);
        //Destroy(gameObject);
    }
}
