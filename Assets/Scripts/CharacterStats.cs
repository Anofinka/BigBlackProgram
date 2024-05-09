using UnityEngine;

public class CharacterStats : MonoBehaviour
{
    public float maxHealth = 100f;
    private float currentHealth;
    public int PlayerLevel;

    public int GetPlayerLevel()
    {return PlayerLevel;}
}
