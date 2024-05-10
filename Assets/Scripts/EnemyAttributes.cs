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
    public List<DropItem> dropItems; // Lista przedmiot�w, kt�re mog� by� upuszcane wraz z ich szans� na upuszczenie
    public float dropRadius = 2f; // Promie�, w jakim mog� by� rozmieszczone upuszczone przedmioty

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
        // Usu� przeciwnika
        Destroy(gameObject);

        // Lista przechowuj�ca ju� wygenerowane pozycje przedmiot�w
        List<Vector3> occupiedPositions = new List<Vector3>();

        // Sprawd� czy upu�ci� przedmiot
        foreach (DropItem dropItem in dropItems)
        {
            if (Random.Range(0f, 100f) <= dropItem.dropChance)
            {
                // Generuj prefabrykat przedmiotu z losow� pozycj� w promieniu dropRadius
                Vector3 randomPosition = GetRandomPosition(transform.position, occupiedPositions);
                Instantiate(dropItem.itemPrefab, randomPosition, Quaternion.identity);
            }
        }
    }

    Vector3 GetRandomPosition(Vector3 center, List<Vector3> occupiedPositions)
    {
        Vector3 randomPosition = center + Random.insideUnitSphere * dropRadius;
        randomPosition.y = 0f; // Upewnij si�, �e przedmiot jest rozmieszczony na p�askiej powierzchni

        // Sprawd� czy wygenerowana pozycja nie nachodzi na inn� ju� zaj�t� pozycj�
        while (occupiedPositions.Exists(pos => Vector3.Distance(pos, randomPosition) < 1f))
        {
            randomPosition = center + Random.insideUnitSphere * dropRadius;
            randomPosition.y = 0f;
        }

        // Dodaj wygenerowan� pozycj� do listy zaj�tych pozycji
        occupiedPositions.Add(randomPosition);

        return randomPosition;
    }

    public float GetBarValue()
    {
        return (currentHealth / maxHealth);
    }
}
