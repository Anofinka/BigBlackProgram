using System.Collections;
using UnityEngine;

public class PlayerAttack : MonoBehaviour
{
    public float damage = 0.1f;
    private WaitForSeconds delayTime = new WaitForSeconds(1);
    private bool canAttack = true;

    private void OnTriggerEnter(Collider other)
    {
        //if(other.CompareTag("enemy"));
        if(canAttack == true)
        {
           canAttack = false;
           SaveScript.enemyHealth -= damage;
           StartCoroutine(ResetDamage());
        }
    }

    IEnumerator ResetDamage()
    {
        yield return delayTime;
        canAttack = true;
    }
}
