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
        // Sprawdzenie czy u¿ytkownik klikn¹³ prawym przyciskiem myszy
        if (Input.GetMouseButtonDown(0))
        {
            // Tworzenie promienia z pozycji myszy w œwiecie do p³aszczyzny gry
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            // Sprawdzenie, czy promieñ przecina obiekt w grze
            if (Physics.Raycast(ray, out hit))
            {
                // Przesuniêcie postaci do pozycji klikniêcia
                PoruszDoPozycji(hit.point);
            }
        }
    }

    void PoruszDoPozycji(Vector3 pozycja)
    {
        // Przesuniêcie postaci do zadanej pozycji przy u¿yciu NavMeshAgent
        agent.SetDestination(pozycja);
    }
}
