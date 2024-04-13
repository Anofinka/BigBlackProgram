using UnityEngine;

public class ClickHandler : MonoBehaviour
{
    private void Update()
    {
        // SprawdŸ, czy u¿ytkownik klikn¹³ myszk¹
        if (Input.GetMouseButtonDown(0))
        {
            // Pobierz pozycjê klikniêcia
            Vector3 clickPosition = Camera.main.ScreenToWorldPoint(Input.mousePosition);

            // Wyœlij wiadomoœæ o klikniêciu do wszystkich obiektów w zasiêgu klikniêcia
            RaycastHit hit;
            if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit))
            {
                Debug.Log("Klikniêto na obiekt: " + hit.collider.gameObject.name);
            }
            else
            {
                Debug.Log("Klikniêto w przestrzeñ gry.");
            }
        }
    }
}