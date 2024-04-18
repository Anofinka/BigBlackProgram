using UnityEngine;

public class EnemyHealth : MonoBehaviour
{
    public float maxHealth = 100f; // Maksymalne zdrowie przeciwnika
    private float currentHealth; // Aktualne zdrowie przeciwnika

    void Start()
    {
        currentHealth = maxHealth; // Ustaw aktualne zdrowie na maksymalne zdrowie przy uruchomieniu
    }

    public void TakeDamage(float damage)
    {
        currentHealth -= damage; // Odejmij obrażenia od aktualnego zdrowia

        if (currentHealth <= 0)
        {
            Die(); // Jeśli zdrowie spadnie do zera lub poniżej, wywołaj metodę śmierci przeciwnika
        }
    }

    void Die()
    {
        // Tutaj możesz dodać kod, który ma być wykonany po śmierci przeciwnika, np. animacje, dźwięki itp.
        Destroy(gameObject); // Zniszcz obiekt przeciwnika
    }
}
