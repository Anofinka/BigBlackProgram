using UnityEngine;

public class InventoryOpener : MonoBehaviour
{
    public GameObject inventoryUI; // Referencja do interfejsu u¿ytkownika ekwipunku

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E)) // SprawdŸ, czy klawisz "E" zosta³ naciœniêty
        {
            ToggleInventory(); // Wywo³aj funkcjê do otwierania/ zamykania ekwipunku
        }
    }

    void ToggleInventory()
    {
        // Jeœli ekwipunek jest aktywny, wy³¹cz go; w przeciwnym razie w³¹cz
        inventoryUI.SetActive(!inventoryUI.activeSelf);
    }
}
