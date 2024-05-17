using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class CharacterStats : MonoBehaviour
{

   

    [Header("Do�wiadczenie")]
    public int PlayerLevel = 1;
    public TextMeshProUGUI LvlText;
    public int currentExperience = 0;
    public int experienceToNextLevel = 100;
    public Slider ExperienceSlider;
    [Header("Health")]
    public TextMeshProUGUI HealthText;
    public int maxHealth = 100;
    public int currentHealth;
    public Slider HealthSlider;
    [Header("Mana")]
    public TextMeshProUGUI ManaText;
    public int maxMana = 50;
    public int currentMana;
    public Slider ManaSlider;
    [Header("")]
    public Text Stats;
    public int strength = 10;
    public int dexterity = 10;

    

    void Start()
    {
        currentHealth = maxHealth;
        currentMana = maxMana;
        UpdateStats();
    }

    void Update()
    {
        // Do test�w
        if (Input.GetKeyDown(KeyCode.Space))
        {
            AddExperience(20);
            UpdateSlider();
            UpdateStats();
        }
        if (Input.GetKeyDown(KeyCode.H))
        {
            Heal(50);
        }
        if (Input.GetKeyDown(KeyCode.J))
        {
            TakeDamage(10);
        }
        if (Input.GetKeyDown(KeyCode.Y))
        {
            HealMana(25);
        }
        if (Input.GetKeyDown(KeyCode.U))
        {
            TakeMana(5);
        }
    }
    //Do test�w
    public void Heal(int amount)
    {
        currentHealth += amount;
        currentHealth = Mathf.Clamp(currentHealth, 0, maxHealth);
        UpdateSlider();
        UpdateStats();
    }
    public void TakeDamage(int amount)
    {
        currentHealth -= amount;
        currentHealth = Mathf.Clamp(currentHealth, 0, maxHealth);
        UpdateSlider();
        UpdateStats();
    }
    public void HealMana(int amount)
    {
        currentMana += amount;
        currentMana = Mathf.Clamp(currentMana, 0, maxMana);
        UpdateSlider();
        UpdateStats();
    }
    public void TakeMana(int amount)
    {
        currentMana -= amount;
        currentMana = Mathf.Clamp(currentMana, 0, currentMana);
        UpdateSlider();
        UpdateStats();
    }


    // Dodaj do�wiadczenie
    public void AddExperience(int amount)
    {
        currentExperience += amount;
        if (currentExperience >= experienceToNextLevel)
        {
            LevelUp();
        }
    }

    // Awansowanie na wy�szy poziom
    private void LevelUp()
    {
        PlayerLevel++;
        currentExperience -= experienceToNextLevel;
        experienceToNextLevel = Mathf.RoundToInt(experienceToNextLevel * 1.5f);

        // Skalowanie zdrowia i many z poziomem gracza
        maxHealth = 100 + (PlayerLevel * 10);
        maxMana = 50 + (PlayerLevel * 5);

        // Skalowanie si�y i zr�czno�ci
        strength = 10 + (PlayerLevel * 2);
        dexterity = 10 + (PlayerLevel * 2);

        UpdateStats();
        currentHealth = maxHealth;
        currentMana = maxMana;
        UpdateSlider();
    }

    // Aktualizacja wy�wietlania statystyk
    public void UpdateStats()
    {
        LvlText.text = "" + PlayerLevel;

        Stats.text = "HP: " + currentHealth + " / " + maxHealth + "\n"
            + " MP: " + currentMana + " / " + maxMana + "\n"
            + "STR: " + strength + " DEX: " + dexterity +"\n"
            + "Level:" + PlayerLevel + " || " + currentExperience + " / " + experienceToNextLevel;

        UpdateSlider();
    }

    // Aktualizacja suwak�w
    private void UpdateSlider()
    {
        HealthSlider.maxValue = maxHealth;
        HealthSlider.value = currentHealth;

        ManaSlider.maxValue = maxMana;
        ManaSlider.value = currentMana;

        ExperienceSlider.maxValue = experienceToNextLevel;
        ExperienceSlider.value = currentExperience;
    }
}
