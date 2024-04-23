using UnityEngine;

public class EquipItemsOnClick : MonoBehaviour
{
    // Referencje do postaci i przedmiotów
    public GameObject character;
    public GameObject[] itemsToEquip; // Tablica przedmiotów do za³o¿enia

    private void Start()
    {
        // Dodajemy obs³ugê zdarzenia klikniêcia na ka¿dy przedmiot
        foreach (GameObject item in itemsToEquip)
        {
            if (item != null)
            {
                // Dodajemy komponent do obs³ugi klikniêcia
                var clickableItem = item.AddComponent<ClickableItem>();
                clickableItem.equipItemsOnClick = this;
            }
        }
    }

    // Metoda wywo³ywana po klikniêciu na przedmiot
    public void EquipItem(GameObject item)
    {
        // Sprawdzenie, czy mamy postaæ i przedmiot
        if (character != null && item != null)
        {
            // Przy³¹cz przedmiot do postaci
            AttachItemToCharacter(item);
        }
        else
        {
            Debug.LogWarning("Brak postaci lub przedmiotu do za³o¿enia");
        }
    }

    // Metoda przy³¹czaj¹ca przedmiot do postaci
    private void AttachItemToCharacter(GameObject item)
    {
        // Przy³¹cz przedmiot do postaci
        item.transform.parent = character.transform;
        item.transform.localPosition = Vector3.zero; // Ustawienie pozycji przedmiotu na postaci
        item.transform.localRotation = Quaternion.identity; // Ustawienie rotacji przedmiotu na postaci

        // Spróbuj umieœciæ przedmiot na odpowiedniej czêœci cia³a na podstawie tagu
        ClickableItem clickableItem = item.GetComponent<ClickableItem>();
        if (clickableItem != null)
        {
            clickableItem.PlaceItemOnBodyPart(GameObject.FindGameObjectWithTag(item.tag));
        }
    }
}

// Klasa obs³uguj¹ca klikniêcie na przedmiot
public class ClickableItem : MonoBehaviour
{
    public EquipItemsOnClick equipItemsOnClick; // Referencja do skryptu obs³uguj¹cego zak³adanie przedmiotów

    private void OnMouseDown()
    {
        // Po klikniêciu na przedmiot wywo³ujemy metodê EquipItem
        if (equipItemsOnClick != null)
        {
            equipItemsOnClick.EquipItem(gameObject);
        }
    }

    // Metoda umieszczaj¹ca przedmiot na odpowiedniej czêœci cia³a
    public void PlaceItemOnBodyPart(GameObject bodyPart)
    {
        // SprawdŸ, czy czêœæ cia³a istnieje
        if (bodyPart != null)
        {
            // Umieœæ przedmiot na czêœci cia³a
            transform.parent = bodyPart.transform;
            transform.localPosition = Vector3.zero; // Ustawienie pozycji przedmiotu na czêœci cia³a
            transform.localRotation = Quaternion.identity; // Ustawienie rotacji przedmiotu na czêœci cia³a
        }
        else
        {
            Debug.LogWarning("Nie mo¿na umieœciæ przedmiotu na czêœci cia³a, brak czêœci cia³a.");
        }
    }
}
