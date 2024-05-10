using System.Drawing;
using UnityEngine;

public class ShowBimData : MonoBehaviour
{
    public Camera raycastCamera;
    public float textHeightOffset = 1.5f; // Dodatkowa wysoko�� nad obiektem, na kt�rej b�dzie wy�wietlany napis
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
            if (itemScript != null)
            {
                // Pobieramy pozycj� obiektu
                Vector3 objectPosition = _selectedObject.transform.position;

                // Ustawiamy wysoko�� tekstu nad obiektem
                Vector3 textPosition = new Vector3(objectPosition.x, objectPosition.y + textHeightOffset, objectPosition.z);

                // Wy�wietlamy nazw� przedmiotu nad obiektem
                string itemInfo = "<size=35>" + itemScript.item.Kame + "</size>" + "\n";
                itemInfo += "Type of equipment: " + itemScript.item.itemTag + "\n";
                itemInfo += "HP: " + itemScript.item.hp + "\n";
                itemInfo += "Si�a: " + itemScript.item.si�a;
                onGuiText = itemInfo;
            }
            else
            {
                onGuiText = "";
            }
        }
        else
        {
            _selectedObject = null; // Ustaw _selectedObject na null, gdy nie trafimy na �aden obiekt
            onGuiText = "";
        }
    }

    private void OnGUI()
    {
        if (!string.IsNullOrEmpty(onGuiText) && _selectedObject != null) // Dodaj warunek sprawdzaj�cy czy _selectedObject nie jest nullem
        {
            // Pobierz pozycj� ekranu dla tekstu
            Vector3 screenPosition = raycastCamera.WorldToScreenPoint(_selectedObject.transform.position + Vector3.up * textHeightOffset);

            // Ustaw style tekstu
            GUIStyle style = new GUIStyle(GUI.skin.box);
            style.fontSize = fontSize;
            style.fontStyle = fontStyle;

            // Pobierz rozmiar tekstu
            GUIContent content = new GUIContent(onGuiText);
            Vector2 size = style.CalcSize(content);

            // Wy�wietl tekst w okre�lonej pozycji na ekranie
            GUI.Label(new Rect(screenPosition.x - size.x / 2, Screen.height - screenPosition.y, size.x, size.y), onGuiText, style);
        }
    }
}
