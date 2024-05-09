using UnityEngine;

public class EnemyAttributes : MonoBehaviour
{
    public string enemyName;
    public float maxHealth;
    private float currentHealth;
    public int EnemyLevel = 1;
    private float Strength;

    public float GetHP() { return currentHealth; }
    public string GetName() { return enemyName; }
    public int GetLevel()
    {
        if (EnemyLevel < 1) EnemyLevel = 1;
        return EnemyLevel;
    }


    void Start()
    {
        currentHealth = maxHealth = (maxHealth * (1 + EnemyLevel / 8));
    }

    public void TakeDamage(float damage)
    {
        currentHealth -= damage;
        
        if (currentHealth <= 0)
        {
            Die();
        }
    }

    void Die()
    {
        // Dodaj kod obs³uguj¹cy dodatkowe dzia³ania po œmierci przeciwnika
        //Debug.Log("Enemy " + enemyName + " died.");
        Destroy(gameObject);
    }
    public float GetBarValue()
    {
        return (currentHealth / maxHealth);
    }
    
}