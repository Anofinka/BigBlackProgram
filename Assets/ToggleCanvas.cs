using UnityEngine;

public class ToggleCanvas : MonoBehaviour
{
    public GameObject canvas; // Referencja do Canvas
    private bool isCanvasActive = false; // Przechowuje stan Canvasu

    void Start()
    {
        if (canvas != null)
        {
            canvas.SetActive(false); // Na pocz¹tku ukrywa Canvas
        }
    }

    void Update()
    {
        // Sprawdza, czy klawisz Esc zosta³ naciœniêty
        if (Input.GetKeyDown(KeyCode.Escape))
        {
            ToggleCanvasState();
        }
    }

    // Funkcja prze³¹czaj¹ca stan Canvas i zarz¹dzaj¹ca czasem gry
    public void ToggleCanvasState()
    {
        if (canvas != null)
        {
            isCanvasActive = !isCanvasActive; // Prze³¹cza stan
            canvas.SetActive(isCanvasActive); // Ustawia stan aktywnoœci Canvas

            if (isCanvasActive)
            {
                Time.timeScale = 0; // Zatrzymuje up³yw czasu
            }
            else
            {
                Time.timeScale = 1; // Wznawia up³yw czasu
            }
        }
        else
        {
            Debug.LogWarning("Canvas not assigned!");
        }
    }


    // Funkcja do przycisku, aby ukrywaæ Canvas i wznawiaæ grê
    public void ResumeAndHideCanvas()
    {
        if (canvas != null)
        {
            canvas.SetActive(false);
            isCanvasActive = false;
            Time.timeScale = 1;
        }
        else
        {
            Debug.LogWarning("Canvas not assigned!");
        }
    }
}
