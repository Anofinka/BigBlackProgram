using UnityEngine;

public class ExitGame : MonoBehaviour
{
    // Funkcja wy��czaj�ca gr�
    public void QuitGame()
    {
        // Wy��cza aplikacj�
        Application.Quit();

        // Je�li jeste�my w edytorze, zatrzymuje gr�
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
    }
}
