using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class NewBehaviourScript : MonoBehaviour
{
    // Dodajemy opóŸnienie, aby upewniæ siê, ¿e reset jest wykonywany poprawnie
    public float resetDelay = 0.5f; // opóŸnienie w sekundach

    // Metoda do resetowania sceny
    public void ResetScene()
    {
        // Opcjonalnie: jeœli masz logikê resetowania sceny, dodaj j¹ tutaj
        Debug.Log("ResetScene called.");
    }

    // Metoda do resetowania poziomu
    public void ResetLevel()
    {
        Debug.Log("ResetLevel called.");
        StartCoroutine(ResetLevelCoroutine());
    }

    // Coroutine do resetowania poziomu z opóŸnieniem
    private IEnumerator ResetLevelCoroutine()
    {
        yield return new WaitForSeconds(resetDelay);

        // Pobieramy nazwê aktywnej sceny
        string currentSceneName = SceneManager.GetActiveScene().name;

        Debug.Log("Loading scene: " + currentSceneName);
        SceneManager.LoadScene(currentSceneName);
    }
}
