using UnityEngine;

public class ClickHandler : MonoBehaviour
{
    private void Update()
    {
        // Sprawd�, czy u�ytkownik klikn�� myszk�
        if (Input.GetMouseButtonDown(0))
        {
            // Pobierz pozycj� klikni�cia
            Vector3 clickPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);

            // Wy�lij wiadomo�� o klikni�ciu do wszystkich obiekt�w w zasi�gu klikni�cia
            RaycastHit hit;
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit))
            {
                Debug.Log("Klikni�to na obiekt: " + hit.collider.gameObject.name);
            }
            else
            {
                Debug.Log("Klikni�to w przestrze� gry.");
            }
        }
    }
}