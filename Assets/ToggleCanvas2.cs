using UnityEngine;

public class ToggleCanvas2 : MonoBehaviour
{
    // Przypisz tu sw�j Canvas w edytorze Unity
    public GameObject targetCanvas;

    // Flaga, aby sprawdzi�, czy Canvas jest aktualnie widoczny
    private bool isCanvasVisible = false;

    // Metoda do wywo�ania na klikni�cie przycisku


/*    public void ToggleCanvasVisibility()
    {
        if (targetCanvas != null)
        {
            // Zmieniamy warto�� enabled Canvas i aktualizujemy flag�
            isCanvasVisible = !isCanvasVisible;
            targetCanvas.enabled = isCanvasVisible;
        }
    }*/

    private void Awake()
    {
        nazero3();
    }

/*    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R)) // Sprawd�, czy klawisz "R" zosta� naci�ni�ty
        {
            ToggleInventory3(); // Wywo�aj funkcj� do otwierania/ zamykania ekwipunku
        }
    }*/

    public void ToggleInventory3()
    {
        if (targetCanvas.activeSelf)
        {
            nazero3();
        }
        else
        {
            targetCanvas.SetActive(true);
        }
    }

    void nazero3()
    {
        targetCanvas.SetActive(false);
    }
}
