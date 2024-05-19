using System.Collections;
using UnityEngine;

public class DamageOnCollision : MonoBehaviour
{
    //public CharacterStats CharacterStats;
    public int damage = 10;
    public float cooldownTime = 0.5f; // Cooldown time in seconds
    private bool isCooldown = false;  // To track if cooldown is active

    void OnTriggerEnter(Collider other)
    {
        {
            if (other.CompareTag("Player") && !isCooldown)
            {
                CharacterStats playerStats = other.GetComponent<CharacterStats>();
                if (playerStats != null)
                {
                    playerStats.currentHealth -= damage;
                    playerStats.UpdateSlider();

                    StartCoroutine(Cooldown());
                }
            }
        }
    }

    IEnumerator Cooldown()
    {
        isCooldown = true;  // Start cooldown
        yield return new WaitForSeconds(cooldownTime);  // Wait for the cooldown time
        isCooldown = false;  // End cooldown
    }
}
