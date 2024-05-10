using UnityEngine;
using System.Collections.Generic;

public class EnemyAttributes : MonoBehaviour
{
    [System.Serializable]
    public class DropItem
    {
        public GameObject itemPrefab; // Prefabrykat przedmiotu
        public float dropChance; // Szansa na upuszczenie przedmiotu w procentach
    }

    public string enemyName;
    public float maxHealth;
    private float currentHealth;
    public int EnemyLevel = 1;
    private float Strength;
    public List<DropItem> dropItems; // Lista przedmiotów, które mog¹ byæ upuszcane wraz z ich szans¹ na upuszczenie
    public float dropRadius = 2f; // Promieñ, w jakim mog¹ byæ rozmieszczone upuszczone przedmioty

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
        // Usuñ przeciwnika
        Destroy(gameObject);

        // Lista przechowuj¹ca ju¿ wygenerowane pozycje przedmiotów
        List<Vector3> occupiedPositions = new List<Vector3>();

        // SprawdŸ czy upuœciæ przedmiot
        foreach (DropItem dropItem in dropItems)
        {
            if (Random.Range(0f, 100f) <= dropItem.dropChance)
            {
                // Generuj prefabrykat przedmiotu z losow¹ pozycj¹ w promieniu dropRadius
                Vector3 randomPosition = GetRandomPosition(transform.position, occupiedPositions);
                Instantiate(dropItem.itemPrefab, randomPosition, Quaternion.identity);
            }
        }
    }

    Vector3 GetRandomPosition(Vector3 center, List<Vector3> occupiedPositions)
    {
        Vector3 randomPosition = center + Random.insideUnitSphere * dropRadius;
        randomPosition.y = 0f; // Upewnij siê, ¿e przedmiot jest rozmieszczony na p³askiej powierzchni

        // SprawdŸ czy wygenerowana pozycja nie nachodzi na inn¹ ju¿ zajêt¹ pozycjê
        while (occupiedPositions.Exists(pos => Vector3.Distance(pos, randomPosition) < 1f))
        {
            randomPosition = center + Random.insideUnitSphere * dropRadius;
            randomPosition.y = 0f;
        }

        // Dodaj wygenerowan¹ pozycjê do listy zajêtych pozycji
        occupiedPositions.Add(randomPosition);

        return randomPosition;
    }

    public float GetBarValue()
    {
        return (currentHealth / maxHealth);
    }
}
