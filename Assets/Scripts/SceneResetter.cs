using System.Collections;
using UnityEngine;
using UnityEngine.SceneManagement;

public class NewBehaviourScript : MonoBehaviour
{
    // Dodajemy op�nienie, aby upewni� si�, �e reset jest wykonywany poprawnie
    public float resetDelay = 0.5f; // op�nienie w sekundach

    // Metoda do resetowania sceny
    public void ResetScene()
    {
        // Opcjonalnie: je�li masz logik� resetowania sceny, dodaj j� tutaj
        Debug.Log("ResetScene called.");
    }

    // Metoda do resetowania poziomu
    public void ResetLevel()
    {
        Debug.Log("ResetLevel called.");
        StartCoroutine(ResetLevelCoroutine());
    }

    // Coroutine do resetowania poziomu z op�nieniem
    private IEnumerator ResetLevelCoroutine()
    {
        yield return new WaitForSeconds(resetDelay);

        // Pobieramy nazw� aktywnej sceny
        string currentSceneName = SceneManager.GetActiveScene().name;

        Debug.Log("Loading scene: " + currentSceneName);
        SceneManager.LoadScene(currentSceneName);
    }
}
