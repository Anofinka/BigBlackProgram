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
    public List<DropItem> dropItems; // Lista przedmiotów, które mogą być upuszczane wraz z ich szansą na upuszczenie
    public float dropRadius = 2f; // Promień, w jakim mogą być rozmieszczone upuszczone przedmioty
    public float dropHeight = 0.5f; // Wysokość nad podłożem, na której będą spawnowane przedmioty

    public int expReward = 100; // Nagroda za doświadczenie, którą gracz otrzyma po zabiciu wroga
    [Header("Sounds")]
    /*public RandomAudioMonster randomAudioMonster;*/

    private CharacterStats playerStats; // Referencja do skryptu CharacterStats gracza
    private MusicChanger musicChanger;
    //private EnemyController EnemyController;
    //private GameObject SavedStopObstacle;
    

    public float GetHP() { return currentHealth; }
    public string GetName() { return enemyName; }
    public int GetLevel() {if (EnemyLevel < 1) EnemyLevel = 1;    return EnemyLevel;}

    void Start()
    {
        musicChanger = GameObject.FindGameObjectWithTag("Player").GetComponentInChildren<MusicChanger>();
        currentHealth = maxHealth = (maxHealth * (1 + EnemyLevel / 8));
        playerStats = FindObjectOfType<CharacterStats>(); // Znajdujemy CharacterStats na obiekcie gracza za pomocą FindObjectOfType
        //EnemyController = GetComponentInChildren<EnemyController>();
        /*if (GetComponentInChildren<EnemyController>() != null )*/
/*        {
        SavedStopObstacle = GetComponentInChildren<EnemyController>().gameObject; //pozniej zfixuje
        }*/
        //Debug.Log();
    }
    

    public void TakeDamage(float damage)
    {
        currentHealth -= damage;
        Debug.Log("Zadal damage");

        RandomAudioMonster.Instance.PlayRandomDamageClip();

        if (currentHealth <= 0)
        {
            Die();
         
        }
    }

    void Die()
    {
        //Destroy(SavedStopObstacle);
        Destroy(gameObject);

        musicChanger.MusicEnemyGone();
       //Debug.Log(musicChanger.enemyCount);

        //EnemyController.DestroyStopObstacle();
        // Lista przechowująca już wygenerowane pozycje przedmiotów
        List<Vector3> occupiedPositions = new List<Vector3>();

        // Sprawdź czy upuścił przedmiot
        foreach (DropItem dropItem in dropItems)
        {
            if (Random.Range(0f, 100f) <= dropItem.dropChance)
            {
                // Generuj prefabrykat przedmiotu z losową pozycją w promieniu dropRadius
                Vector3 randomPosition = GetRandomPosition(transform.position, occupiedPositions);
                Instantiate(dropItem.itemPrefab, randomPosition, Quaternion.identity);
            }
        }

        // Dodaj doświadczenie graczowi
        if (playerStats != null)
        {
            playerStats.AddExperience(expReward); // Dodaj doświadczenie do skryptu CharacterStats gracza
            playerStats.UpdateStats(); // Zaktualizuj statystyki gracza
        }
        else
        {
            Debug.LogWarning("PlayerStats component not found!");
        }
    }

/*    int CalculateExpReward()
    {
        // Tutaj możesz zaimplementować własną logikę obliczania nagrody za doświadczenie
        // Na przykład, możesz zwrócić stałą wartość, lub obliczyć ją na podstawie poziomu wroga, etc.
        return expReward; // Zwracamy zmienną expReward jako nagrodę za doświadczenie
    }*/

    Vector3 GetRandomPosition(Vector3 center, List<Vector3> occupiedPositions)
    {
        Vector3 randomPosition = center + Random.insideUnitSphere * dropRadius;
        randomPosition.y = dropHeight; // Ustawienie wysokości na dropHeight

        // Sprawdź czy wygenerowana pozycja nie nachodzi na inną już zajętą pozycję
        while (occupiedPositions.Exists(pos => Vector3.Distance(pos, randomPosition) < 1f))
        {
            randomPosition = center + Random.insideUnitSphere * dropRadius;
            randomPosition.y = dropHeight;
        }

        // Dodaj wygenerowaną pozycję do listy zajętych pozycji
        occupiedPositions.Add(randomPosition);

        return randomPosition;
    }

    public float GetBarValue()
    {
        return (currentHealth / maxHealth);
    }
}
