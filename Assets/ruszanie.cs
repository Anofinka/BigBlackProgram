using UnityEngine;
using UnityEngine.AI;

public class PoruszaniePostacia : MonoBehaviour
{
    private NavMeshAgent agent;

    void Start()
    {
        // Inicjalizacja komponentu NavMeshAgent
        agent = GetComponent<NavMeshAgent>();
    }

    void Update()
    {
        // Sprawdzenie czy u�ytkownik klikn�� prawym przyciskiem myszy
        if (Input.GetMouseButtonDown(0))
        {
            // Tworzenie promienia z pozycji myszy w �wiecie do p�aszczyzny gry
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            // Sprawdzenie, czy promie� przecina obiekt w grze
            if (Physics.Raycast(ray, out hit))
            {
                // Przesuni�cie postaci do pozycji klikni�cia
                PoruszDoPozycji(hit.point);
            }
        }
    }

    void PoruszDoPozycji(Vector3 pozycja)
    {
        // Przesuni�cie postaci do zadanej pozycji przy u�yciu NavMeshAgent
        agent.SetDestination(pozycja);
    }
}
