using System.Collections;
using UnityEngine;

public class DamageOnCollision : MonoBehaviour
{
    public int baseDamage = 10; // Podstawowe obra�enia
    public float cooldownTime = 0.5f; // Czas odnowienia w sekundach
    private float armorReductionFactor = 0.02f; // Wsp�czynnik redukcji obra�e� na jednostk� pancerza
    private bool isCooldown = false; // Flaga okre�laj�ca aktywno�� odnowienia

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player") && !isCooldown)
        {
            CharacterStats playerStats = other.GetComponent<CharacterStats>();
            if (playerStats != null)
            {
                int finalDamage = CalculateDamage(baseDamage, playerStats.armor, armorReductionFactor);
                playerStats.currentHealth -= finalDamage;
                playerStats.UpdateSlider();
                Debug.Log($"Player received {finalDamage} damage.");
                StartCoroutine(Cooldown());
            }
        }
    }

    int CalculateDamage(int baseDamage, float armor, float reductionFactor)
    {
        // Obliczanie ostatecznych obra�e� z uwzgl�dnieniem pancerza i wsp�czynnika redukcji
        float damageAfterArmor = baseDamage - armor * reductionFactor;
        return Mathf.RoundToInt(damageAfterArmor);
    }

    IEnumerator Cooldown()
    {
        isCooldown = true;
        yield return new WaitForSeconds(cooldownTime);
        isCooldown = false;
    }
}
