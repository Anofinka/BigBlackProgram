using UnityEngine;

public class InventoryOpener : MonoBehaviour
{
    public GameObject inventoryUI; // Referencja do interfejsu u�ytkownika ekwipunku

    private void Awake()
    {
        nazero();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            ToggleInventory();
        }
    }

    void ToggleInventory()
    {
        //inventoryUI.SetActive(!inventoryUI.activeSelf);

        if (inventoryUI.transform.localScale == new Vector3(0, 0, 0)) //hujowy ale fix B)
            inventoryUI.transform.localScale = new Vector3(1, 1, 1);
        else
            nazero();
    }

    void nazero()
    {
        inventoryUI.transform.localScale = new Vector3(0, 0, 0);
    }

}
