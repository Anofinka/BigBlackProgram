using UnityEngine;

public class ToggleCanvas : MonoBehaviour
{
    public GameObject canvas; // Referencja do Canvas
    private bool isCanvasActive = false; // Przechowuje stan Canvasu

    void Start()
    {
        if (canvas != null)
        {
            canvas.SetActive(false); // Na pocz�tku ukrywa Canvas
        }
    }

    void Update()
    {
        // Sprawdza, czy klawisz Esc zosta� naci�ni�ty
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            ToggleCanvasState();
        }
    }

    // Funkcja prze��czaj�ca stan Canvas i zarz�dzaj�ca czasem gry
    public void ToggleCanvasState()
    {
        if (canvas != null)
        {
            isCanvasActive = !isCanvasActive; // Prze��cza stan
            canvas.SetActive(isCanvasActive); // Ustawia stan aktywno�ci Canvas

        }
    
        else
        {
            Debug.LogWarning("Canvas not assigned!");
        }
    }


    // Funkcja do przycisku, aby ukrywa� Canvas i wznawia� gr�
    public void ResumeAndHideCanvas()
    {
        if (canvas != null)
        {
            canvas.SetActive(false);
            isCanvasActive = false;
           
        }
        else
        {
            Debug.LogWarning("Canvas not assigned!");
        }
    }
}
