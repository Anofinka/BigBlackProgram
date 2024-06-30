using UnityEngine;

public class SwordCollision : MonoBehaviour
{
    public float baseDamage = 2f; // Podstawowe obra�enia miecza
    public float scalingFactor = 0.05f; // Wsp�czynnik skalowania obra�e� w zale�no�ci od si�y

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("enemy"))
        {
            // Pobieramy komponent EnemyAttributes
            EnemyAttributes enemyAttributes = other.GetComponent<EnemyAttributes>();
            if (enemyAttributes != null)
            {
                // Pobieramy komponent CharacterStats z gracza (zak�adaj�c, �e skrypt jest przymocowany do miecza gracza)
                CharacterStats characterStats = GetComponentInParent<CharacterStats>();

                if (characterStats != null)
                {
                    // Obliczamy ostateczne obra�enia
                    int finalDamage = CalculateDamage(baseDamage, characterStats.strength, scalingFactor);

                    // Zadajemy obra�enia przeciwnikowi
                    enemyAttributes.TakeDamage(finalDamage);

                    Debug.Log($"Enemy {enemyAttributes.enemyName} took {finalDamage} damage.");
                }
                else
                {
                    Debug.Log("CharacterStats component not found on the parent.");
                }
            }
            else
            {
                Debug.Log("EnemyAttributes component not found on " + other.name);
            }
        }
    }

    private int CalculateDamage(float baseDamage, int strength, float scalingFactor)
    {
        // Obliczamy ostateczne obra�enia, uwzgl�dniaj�c podstawowe obra�enia, si�� i wsp�czynnik skalowania
        return (int)(baseDamage + (strength * scalingFactor));
    }
}
