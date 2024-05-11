using System.Drawing;
using UnityEngine;

public class ShowBimData : MonoBehaviour
{
    public Camera raycastCamera;
    public float textHeightOffset = 1.5f; // Dodatkowa wysokoœæ nad obiektem, na której bêdzie wyœwietlany napis
    public int fontSize = 14; // Rozmiar czcionki
    public FontStyle fontStyle = FontStyle.Normal; // Styl czcionki
    private GameObject _selectedObject;
    private string onGuiText = "";

    void Update()
    {
        Ray ray = raycastCamera.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        if (Physics.Raycast(ray, out hit, 1000))
        {
            _selectedObject = hit.transform.gameObject;

            // Sprawdzamy, czy obiekt posiada komponent PicItem_Rn
            PicItem_Rn itemScript = _selectedObject.GetComponent<PicItem_Rn>();
            if (itemScript != null && itemScript.item != null)
            {
                // Pobieramy pozycjê obiektu
                Vector3 objectPosition = _selectedObject.transform.position;

                // Ustawiamy wysokoœæ tekstu nad obiektem
                Vector3 textPosition = new Vector3(objectPosition.x, objectPosition.y + textHeightOffset, objectPosition.z);

                // Tworzymy tekst zawieraj¹cy nazwê przedmiotu z ró¿nymi rozmiarami czcionki
                string itemInfo = "<size=35>" + itemScript.item.name + "</size>" + "\n";
                itemInfo += "<size=20>HP: " + itemScript.item.hp + "</size>" + "\n";
                itemInfo += "<size=20>Si³a: " + itemScript.item.si³a + "</size>" + "\n";

                onGuiText = itemInfo;
            }
            else
            {
                onGuiText = "";
            }
        }
        else
        {
            _selectedObject = null;
            onGuiText = "";
        }
    }

    private void OnGUI()
    {
        if (!string.IsNullOrEmpty(onGuiText) && _selectedObject != null) // Dodaj warunek sprawdzaj¹cy czy _selectedObject nie jest nullem
        {
            // Pobierz pozycjê ekranu dla tekstu
            Vector3 screenPosition = raycastCamera.WorldToScreenPoint(_selectedObject.transform.position + Vector3.up * textHeightOffset);

            // Ustaw style tekstu
            GUIStyle style = new GUIStyle(GUI.skin.box);
            style.fontSize = fontSize;
            style.fontStyle = fontStyle;

            // Pobierz rozmiar tekstu
            GUIContent content = new GUIContent(onGuiText);
            Vector2 size = style.CalcSize(content);

            // Wyœwietl tekst w okreœlonej pozycji na ekranie
            GUI.Label(new Rect(screenPosition.x - size.x / 2, Screen.height - screenPosition.y, size.x, size.y), onGuiText, style);
        }
    }
}
