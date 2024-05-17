using UnityEngine;

public class PicItem_Rn : MonoBehaviour
{
    public Item item;
    public CharacterStats characterStats;

    public float pickUpRadius = 5f; // Promie�, w jakim posta� mo�e podnosi� przedmioty

    private void OnMouseDown()
    {
        if (IsInRange())
        {
            PickUp();
        }
    }

    private bool IsInRange()
    {
        // Sprawdzamy odleg�o�� mi�dzy graczem (tag "Player") a obiektem PicItem_Rn
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
        Inventory inventory = FindObjectOfType<Inventory>();
        inventory.SpawnInventoryItem2(item);
        item.GenerateRandomStats();
        Destroy(gameObject);
    }
}
