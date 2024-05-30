using System.Collections;
using UnityEngine;
using UnityEngine.AI;

public class EnemyController : MonoBehaviour
{
    private NavMeshAgent enemyAgent;
    public GameObject stopObstaclePrefab; // Prefab obiektu "stopObstacle"
    private float ExitFixValue = 0.1f;

    private bool isLeaving = false;
    private bool isAgentActive = true;
    private Vector3 initialPosition;
    private GameObject stopObstacleInstance; // Instancja obiektu "stopObstacle"

    // Ustawienie agenta z zewn¹trz
    public void SetNavMeshAgent(NavMeshAgent agent)
    {
        enemyAgent = agent;
    }

    void Start()
    {
        // Pobierz agenta z komponentu NavMeshAgent na obiekcie EnemyAttributes
        enemyAgent = GetComponentInParent<EnemyAttributes>().GetComponent<NavMeshAgent>();
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            //Debug.Log("Welcome");
            CreateStopObstacle(); // Tworzenie nowej instancji "stopObstacle"

            if (isAgentActive)
            {
                enemyAgent.enabled = false;
                isAgentActive = false;
            }
            // Zapisz początkową pozycję przeciwnika
            initialPosition = transform.position;
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            isLeaving = true;
            DestroyStopObstacle(); // Usuwanie instancji "stopObstacle"
            StartCoroutine(WaitForNavMeshRefresh());
        }
    }

    void CreateStopObstacle()
    {
        stopObstacleInstance = Instantiate(stopObstaclePrefab, transform.position, Quaternion.identity);
        stopObstacleInstance.SetActive(true);
    }

    public void DestroyStopObstacle()
    {
        if (stopObstacleInstance != null)
        {
            Debug.Log("stop obstacle");
            Destroy(stopObstacleInstance);
            stopObstacleInstance = null;
        }
        else
        {
            Debug.Log("Null stop obstacle");
        }
    }

    IEnumerator WaitForNavMeshRefresh()
    {
        // Poczekaj 0.5 sekundy, aby upewnić się, że NavMesh został zaktualizowany
        yield return new WaitForSeconds(ExitFixValue);

        if (isLeaving)
        {
            //Debug.Log("Goodbye");
            if (!isAgentActive)
            {
                // Przywróć przeciwnika do pierwotnej pozycji przed ponownym włączeniem
                transform.position = initialPosition;
                enemyAgent.enabled = true;
                isAgentActive = true;
            }
            isLeaving = false;
        }
    }
}
