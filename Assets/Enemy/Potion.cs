using UnityEngine;
using TMPro;
using UnityEngine.UI;

public class PotionManager : MonoBehaviour
{
    public int potionCount = 5; // Początkowa ilość potek
    public int healAmount = 20; // Ilość HP przywracana przez jedną potkę
    public TextMeshProUGUI potionCountText; // Referencja do tekstu wyświetlającego ilość potek
    public CharacterStats characterStats; // Referencja do skryptu zdrowia gracza
    public Image potionImage; // Referencja do obrazka potki

    private Color normalColor;
    private Color grayedOutColor = new Color(1, 1, 1, 0.5f); // Półprzezroczysty biały

    void Start()
    {
        normalColor = potionImage.color;
        UpdatePotionCountUI();
    }

    void UpdatePotionCountUI()
    {
        potionCountText.text = "" + potionCount.ToString();
        if (potionCount > 0)
        {
            potionImage.color = normalColor;
        }
        else
        {
            potionImage.color = grayedOutColor;
        }
    }

    public void UsePotion()
    {
        if (potionCount > 0)
        {
            potionCount--;
            characterStats.Heal(healAmount);
            UpdatePotionCountUI();
        }
        else
        {
            Debug.Log("No potions left!");
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P)) // Przykładowo klawisz 'P' używa potki
        {
            UsePotion();
        }
    }
}
