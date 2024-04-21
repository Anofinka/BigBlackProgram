using UnityEngine;

public class HealthBarController : MonoBehaviour
{
    public Renderer healthRenderer; // Referencja do renderera reprezentującego pasek zdrowia
    private float maxHealth = 100f; // Maksymalne zdrowie
    private float currentHealth; // Aktualne zdrowie

    // Metoda inicjalizująca pasek zdrowia
    public void InitializeHealthBar(float maxHealth)
    {
        this.maxHealth = maxHealth;
        currentHealth = maxHealth;
        UpdateHealthBar(); // Aktualizacja paska zdrowia przy inicjalizacji
    }

    // Metoda aktualizująca pasek zdrowia na podstawie aktualnego zdrowia
    public void UpdateHealthBar()
    {
        float healthPercent = currentHealth / maxHealth;
        healthRenderer.material.color = Color.Lerp(Color.red, Color.green, healthPercent); // Zmiana koloru wypełnienia
    }

    // Metoda odejmująca zdrowie
    public void TakeDamage(float damage)
    {
        currentHealth -= damage;
        if (currentHealth < 0)
            currentHealth = 0;
        UpdateHealthBar(); // Aktualizacja paska zdrowia po otrzymaniu obrażeń
    }

    // Metoda sprawdzająca, czy zdrowie spadło do zera
    public bool IsHealthZero()
    {
        return currentHealth <= 0;
    }
}
