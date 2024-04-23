using UnityEngine;

public class EquipItemsOnClick : MonoBehaviour
{
    // Referencje do postaci i przedmiot�w
    public GameObject character;
    public GameObject[] itemsToEquip; // Tablica przedmiot�w do za�o�enia

    private void Start()
    {
        // Dodajemy obs�ug� zdarzenia klikni�cia na ka�dy przedmiot
        foreach (GameObject item in itemsToEquip)
        {
            if (item != null)
            {
                // Dodajemy komponent do obs�ugi klikni�cia
                var clickableItem = item.AddComponent<ClickableItem>();
                clickableItem.equipItemsOnClick = this;
            }
        }
    }

    // Metoda wywo�ywana po klikni�ciu na przedmiot
    public void EquipItem(GameObject item)
    {
        // Sprawdzenie, czy mamy posta� i przedmiot
        if (character != null && item != null)
        {
            // Przy��cz przedmiot do postaci
            AttachItemToCharacter(item);
        }
        else
        {
            Debug.LogWarning("Brak postaci lub przedmiotu do za�o�enia");
        }
    }

    // Metoda przy��czaj�ca przedmiot do postaci
    private void AttachItemToCharacter(GameObject item)
    {
        // Przy��cz przedmiot do postaci
        item.transform.parent = character.transform;
        item.transform.localPosition = Vector3.zero; // Ustawienie pozycji przedmiotu na postaci
        item.transform.localRotation = Quaternion.identity; // Ustawienie rotacji przedmiotu na postaci

        // Spr�buj umie�ci� przedmiot na odpowiedniej cz�ci cia�a na podstawie tagu
        ClickableItem clickableItem = item.GetComponent<ClickableItem>();
        if (clickableItem != null)
        {
            clickableItem.PlaceItemOnBodyPart(GameObject.FindGameObjectWithTag(item.tag));
        }
    }
}

// Klasa obs�uguj�ca klikni�cie na przedmiot
public class ClickableItem : MonoBehaviour
{
    public EquipItemsOnClick equipItemsOnClick; // Referencja do skryptu obs�uguj�cego zak�adanie przedmiot�w

    private void OnMouseDown()
    {
        // Po klikni�ciu na przedmiot wywo�ujemy metod� EquipItem
        if (equipItemsOnClick != null)
        {
            equipItemsOnClick.EquipItem(gameObject);
        }
    }

    // Metoda umieszczaj�ca przedmiot na odpowiedniej cz�ci cia�a
    public void PlaceItemOnBodyPart(GameObject bodyPart)
    {
        // Sprawd�, czy cz�� cia�a istnieje
        if (bodyPart != null)
        {
            // Umie�� przedmiot na cz�ci cia�a
            transform.parent = bodyPart.transform;
            transform.localPosition = Vector3.zero; // Ustawienie pozycji przedmiotu na cz�ci cia�a
            transform.localRotation = Quaternion.identity; // Ustawienie rotacji przedmiotu na cz�ci cia�a
        }
        else
        {
            Debug.LogWarning("Nie mo�na umie�ci� przedmiotu na cz�ci cia�a, brak cz�ci cia�a.");
        }
    }
}
