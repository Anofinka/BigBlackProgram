using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TrapDamage : MonoBehaviour
{
    [SerializeField] float damageTrap = 2; // Wartość obrażeń pułapki

    private void OnCollisionEnter(Collision collision) // Funkcja wywoływana przy kolizji
    {
        // Pobierz komponent EnemyMove z obiektu, z którym nastąpiła kolizja
        EnemyMove enemy = collision.gameObject.GetComponent<EnemyMove>();

        // Sprawdź, czy obiekt kolizyjny posiada skrypt EnemyMove
        if (enemy != null)
        {
            // Zastosuj obrażenia do wroga
            enemy.TakeDamageFromTrap(damageTrap);
            Debug.Log("Weszło w obrażenia");
        }
    }
}
