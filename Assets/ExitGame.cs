using UnityEngine;

public class ExitGame : MonoBehaviour
{
    // Funkcja wy³¹czaj¹ca grê
    public void QuitGame()
    {
        // Wy³¹cza aplikacjê
        Application.Quit();

        // Jeœli jesteœmy w edytorze, zatrzymuje grê
#if UNITY_EDITOR
        UnityEditor.EditorApplication.isPlaying = false;
#endif
    }
}
