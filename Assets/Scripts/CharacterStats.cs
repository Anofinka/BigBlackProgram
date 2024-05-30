using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class CharacterStats : MonoBehaviour
{
    [Header("Doświadczenie")]
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
    [Header("Stats")]
    public Text StatsText;
    public Text StatsText2;
    public Text StatsText3;
    public Text StatsText4;
    public Text StatsText5;
    public Text StatsText6;
    public Text StatsText7;
    public int strength = 10;
    public int dexterity = 10;
    public int armor;

    void Start()
    {
        currentHealth = maxHealth;
        currentMana = maxMana;
        UpdateStats();
    }

    void Update()
    {
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
        LvlText.text = $"{PlayerLevel}";

       /* StatsText.text = $"<b>Stats</b>\n" +
                         $"<color=#D9BA8C><b>Experience</b></color>\n" +
                         $"<color=#4FA833>{currentExperience} / {experienceToNextLevel}</color>\n" +
                         $"<color=#ff0000>Health: {currentHealth} / {maxHealth}</color>\n" +
                         $"<color=#0000ff>Mana: {currentMana} / {maxMana}</color>\n" +
                         $"<color=#D9BA8C><b>Attributes</b></color>\n" +
                         $"<color=#D9BA8C>Strength: {strength}</color>\n" +
                         $"<color=#D9BA8C>Dexterity: {dexterity}</color>\n" +
                         $"<color=#D9BA8C>Armor: {armor}</color>";
       */
        StatsText2.text = $"<color=#D9BA8C><b>Experience</b></color>\n";
        StatsText3.text = $"<color=#4FA833>{currentExperience} / {experienceToNextLevel}</color>\n";
        StatsText4.text = $"<color=#D9BA8C><b>Stats</b></color>\n";
        StatsText5.text = $"<color=#ff0000>Health: {currentHealth} / {maxHealth}</color>\n" +
                         $"<color=#0000ff>Mana: {currentMana} / {maxMana}</color>\n";
        StatsText6.text = $"<color=#D9BA8C><b>Attributes</b></color>\n";
        StatsText7.text = $"<color=#D9BA8C>Strength: {strength}</color>\n" +
                         $"<color=#D9BA8C>Dexterity: {dexterity}</color>\n" +
                         $"<color=#D9BA8C>Armor: {armor}</color>";

    }

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

    public void AddExperience(int amount)
    {
        currentExperience += amount;
        if (currentExperience >= experienceToNextLevel)
        {
            LevelUp();
        }
    }

    private void LevelUp()
    {
        PlayerLevel++;
        currentExperience -= experienceToNextLevel;
        experienceToNextLevel = Mathf.RoundToInt(experienceToNextLevel * 1.5f);

        maxHealth = 100 + (PlayerLevel * 10);
        maxMana = 50 + (PlayerLevel * 5);

        strength = 10 + (PlayerLevel * 2);
        dexterity = 10 + (PlayerLevel * 2);

        currentHealth = maxHealth;
        currentMana = maxMana;
        UpdateStats();
        UpdateSlider();
    }

    public void UpdateStats()
    {
        // Optional: Additional logic to update other stat-related UI elements
        UpdateSlider();
    }

    public void UpdateSlider()
    {
        HealthSlider.maxValue = maxHealth;
        HealthSlider.value = currentHealth;

        ManaSlider.maxValue = maxMana;
        ManaSlider.value = currentMana;

        ExperienceSlider.maxValue = experienceToNextLevel;
        ExperienceSlider.value = currentExperience;
    }
}
