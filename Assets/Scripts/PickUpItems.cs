using UnityEngine;

public class UsunObiektPoKliknieciu : MonoBehaviour
{
    public string tagDoUsuniecia = "Bron";
    public float promienUsuwanegoObszaru = 5f;
    public Transform postac;

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            if (Physics.Raycast(ray, out hit))
            {
                // Sprawdzenie, czy trafiony obiekt ma okre�lony tag
                if (hit.collider.gameObject.CompareTag(tagDoUsuniecia))
                {
                    // Sprawdzenie, czy trafiony obiekt znajduje si� w okre�lonym promieniu od postaci
                    if (Vector3.Distance(hit.collider.transform.position, postac.position) <= promienUsuwanegoObszaru)
                    {
                        Destroy(hit.collider.gameObject);
                    }
                }
            }
        }
    }
}
