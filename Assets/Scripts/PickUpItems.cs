using UnityEngine;

public class UsunObiektPoKliknieciu : MonoBehaviour
{
    public string tagDoUsuniecia = "Bron";
    public float promienUsuwanegoObszaru = 5f;
    public Transform postac;
    public Inventory inv;

    void Update()
    {
        if (Input.GetMouseButtonDown(0))
        { 
            PickUpItem();
        }

    }
    public void PickUpItem()
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
                        // Pobierz referencj� do podniesionego przedmiotu
                        GameObject pickedUpItem = hit.collider.gameObject;

                        // Zniszcz trafiony obiekt
                        Destroy(pickedUpItem);

                        // Wywo�aj metod� SpawnInventoryItem2 z instancji inv
                        //inv.SpawnInventoryItem2(pickedUpItem);
                    }
                }
            }
        
    }
}
        

