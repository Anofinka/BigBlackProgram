using UnityEngine;
using UnityEngine.AI;

public class Enemy : MonoBehaviour
{
    [SerializeField] float health = 3;
    [SerializeField] GameObject hitVFX;
    [SerializeField] GameObject ragdoll;

    [Header("Combat")]
    [SerializeField] float attackCD;
    [SerializeField] float attackRange;
    [SerializeField] float aggroRange;

    GameObject player;
    NavMeshAgent agent;
    Animator animator;
    float timePassed;
    float newDestinationCD = 0.5f;


    //bool isAttacking = false; // Flaga okre�laj�ca, czy wrogowie wykonuj� atak
    float originalAgentSpeed; // Zmienna przechowuj�ca oryginaln� pr�dko�� agenta

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        
        player = GameObject.FindGameObjectWithTag("Player");
        animator = GetComponent<Animator>();
        // Zapisz oryginaln� pr�dko�� agenta
        originalAgentSpeed = agent.speed;
    }

    void Update()
    {
        agent.speed = originalAgentSpeed;
        if (player == null)
        {
            return;
        }

        if (timePassed >= attackCD)
        {
            if (Vector3.Distance(player.transform.position, transform.position) <= attackRange)
            {
                animator.SetTrigger("attack");
                //isAttacking = true; // Ustaw flag� ataku na true
                agent.speed = 0; // Zatrzymaj agenta podczas ataku
            }
        }
        timePassed += Time.deltaTime;

        if (newDestinationCD <= 0 && Vector3.Distance(player.transform.position, transform.position) <= aggroRange)
        {
            
            newDestinationCD = 0.5f;
            if (agent.isActiveAndEnabled)
                agent.SetDestination(player.transform.position);
        }
        newDestinationCD -= Time.deltaTime;
        transform.LookAt(player.transform);

        SetAnimations();
    }

    private void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("Player"))
        {
            print(true);
            player = collision.gameObject;
        }
    }

    void Die()
    {
        Instantiate(ragdoll, transform.position, transform.rotation);
        Destroy(this.gameObject);
    }

    public void TakeDamage(float damageAmount)
    {
        health -= damageAmount;
        animator.SetTrigger("damage");

        if (health <= 0)
        {
            Die();
        }
    }

    public void AttackAnimationEnd()
    {
        //isAttacking = false; // Po zako�czeniu animacji ataku ustaw flag� ataku na false
        agent.speed = originalAgentSpeed; // Przywr�� normaln� pr�dko�� agenta
        agent.velocity = Vector3.zero; // Zatrzymaj agenta po zako�czeniu animacji ataku
    }

    public void HitVFX(Vector3 hitPosition)
    {
        GameObject hit = Instantiate(hitVFX, hitPosition, Quaternion.identity);
        Destroy(hit, 3f);
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, attackRange);
        Gizmos.color = Color.yellow;
        Gizmos.DrawWireSphere(transform.position, aggroRange);
    }

    void SetAnimations()
    {
        if (agent.velocity != Vector3.zero)
        {
            animator.SetBool("walk", true);
        }
        else
        {
            animator.SetBool("walk", false);
        }
    }
}
