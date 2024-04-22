using UnityEngine;

public class PlayerActions : MonoBehaviour
{
    Animator anim;
    [SerializeField] private CapsuleCollider meleeRangeCollider;
    public int damage = 10; // Damage dealt per melee attack

    private void Awake()
    {
        meleeRangeCollider = GetComponent<CapsuleCollider>();
        anim = GetComponent<Animator>();
    }

    void Update()
    {
        AttackMelee();        
    }

    void AttackMelee()
    {
        if (Input.GetKeyDown(KeyCode.R) && !anim.GetBool("walk"))
        {
            anim.SetTrigger("attack");
        }
    }

    private void OnTriggerStay(Collider other)
    {
        if (Input.GetKeyDown(KeyCode.R) && !anim.GetBool("walk") && other.CompareTag("enemy"))
        {
            Debug.Log(other.name + " dostała buchę");
            TakeDamage(other.gameObject);
        }
    }

    void TakeDamage(GameObject enemy)
    {
        EnemyHealth enemyHealth = enemy.GetComponent<EnemyHealth>();
        if (enemyHealth != null)
        {
            enemyHealth.TakeDamage(damage);
        }
    }
}
