using UnityEngine;

public class StatuShow : MonoBehaviour
{
    public GameObject inventoryUI; // Referencja do obiektu UI, kt�ry ma by� prze��czany

    // Metoda wywo�ywana po klikni�ciu przycisku prze��czania stanu
    public void Togglestat()
    {
        if (inventoryUI != null)
        {
            if (inventoryUI.transform.localScale == Vector3.zero)
            {
                // Je�li localScale jest (0, 0, 0), ustaw na (1, 1, 1) aby pokaza� obiekt
                inventoryUI.transform.localScale = Vector3.one;
            }
            else
            {
                // W przeciwnym razie ustaw na (0, 0, 0) aby ukry� obiekt
                inventoryUI.transform.localScale = Vector3.zero;
            }
        }
        else
        {
            Debug.LogWarning("InventoryUI reference is null! Make sure to assign it in the inspector.");
        }
    }
}
