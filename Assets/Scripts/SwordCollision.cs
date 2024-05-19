using UnityEngine;

public class SwordCollision : MonoBehaviour
{
    public int damage = 10;

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("enemy"))
        {

            //Debug.Log("Collision detected with: " + other.name);
            EnemyAttributes enemyAttributes = other.GetComponent<EnemyAttributes>();
            if (enemyAttributes != null)
            {
                enemyAttributes.TakeDamage(damage);
                //Debug.Log("Enemy " + enemyAttributes.enemyName + " took " + damage + " damage.");
            }
            else
            {
                Debug.Log("EnemyAttributes component not found on " + other.name);
            }
        }
    }
}
