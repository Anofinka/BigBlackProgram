using UnityEngine;

public class StatuShow : MonoBehaviour
{
    public GameObject inventoryUI; // Referencja do obiektu UI, który ma byæ prze³¹czany

    // Metoda wywo³ywana po klikniêciu przycisku prze³¹czania stanu
    public void Togglestat()
    {
        if (inventoryUI != null)
        {
            if (inventoryUI.transform.localScale == Vector3.zero)
            {
                // Jeœli localScale jest (0, 0, 0), ustaw na (1, 1, 1) aby pokazaæ obiekt
                inventoryUI.transform.localScale = Vector3.one;
            }
            else
            {
                // W przeciwnym razie ustaw na (0, 0, 0) aby ukryæ obiekt
                inventoryUI.transform.localScale = Vector3.zero;
            }
        }
        else
        {
            Debug.LogWarning("InventoryUI reference is null! Make sure to assign it in the inspector.");
        }
    }
}
