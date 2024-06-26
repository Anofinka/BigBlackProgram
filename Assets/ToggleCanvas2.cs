using UnityEngine;

public class ToggleCanvas2 : MonoBehaviour
{
    // Przypisz tu swój Canvas w edytorze Unity
    public GameObject targetCanvas;

    // Flaga, aby sprawdziæ, czy Canvas jest aktualnie widoczny
    private bool isCanvasVisible = false;

    // Metoda do wywo³ania na klikniêcie przycisku


/*    public void ToggleCanvasVisibility()
    {
        if (targetCanvas != null)
        {
            // Zmieniamy wartoœæ enabled Canvas i aktualizujemy flagê
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
        if (Input.GetKeyDown(KeyCode.R)) // SprawdŸ, czy klawisz "R" zosta³ naciœniêty
        {
            ToggleInventory3(); // Wywo³aj funkcjê do otwierania/ zamykania ekwipunku
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
