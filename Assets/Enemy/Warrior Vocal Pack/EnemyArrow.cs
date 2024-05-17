using UnityEngine;
using UnityEngine.AI;

public class EnemyArcher : MonoBehaviour
{
    [SerializeField] float health = 3;
    [SerializeField] GameObject hitVFX;
    [SerializeField] GameObject ragdoll;
    [SerializeField] GameObject arrowPrefab;
    [SerializeField] Transform shootPoint;
    [SerializeField] float attackCD = 2f;
    [SerializeField] float attackRange = 10f;
    [SerializeField] float aggroRange = 20f;
    [SerializeField] string hitMessage = "Gracz został trafiony!";
    [SerializeField] float arrowSpeed = 20f;

    GameObject player;
    NavMeshAgent agent;
    Animator animator;
    float timePassed;
    float newDestinationCD = 0.5f;

    float originalAgentSpeed;

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        player = GameObject.FindGameObjectWithTag("Player");
        animator = GetComponent<Animator>();
        originalAgentSpeed = agent.speed;
    }

    void Update()
    {
        agent.speed = originalAgentSpeed;
        if (player == null)
        {
            return;
        }

        timePassed += Time.deltaTime;

        if (timePassed >= attackCD)
        {
            if (Vector3.Distance(player.transform.position, transform.position) <= attackRange)
            {
                animator.SetTrigger("attack");
                timePassed = 0; // Reset cooldown when starting the attack
            }
        }

        if (newDestinationCD <= 0 && Vector3.Distance(player.transform.position, transform.position) <= aggroRange)
        {
            newDestinationCD = 0.5f;
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
            Debug.Log(hitMessage);
            player = collision.gameObject;
        }
    }

    void Die()
    {
        Instantiate(ragdoll, transform.position, transform.rotation);
        Destroy(gameObject);
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
        agent.speed = originalAgentSpeed;
        agent.velocity = Vector3.zero;
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
        animator.SetBool("walk", agent.velocity != Vector3.zero);
    }

    public void ShootArrow()
    {
        if (arrowPrefab != null && player != null)
        {
            GameObject arrow = Instantiate(arrowPrefab, shootPoint.position, shootPoint.rotation);
            Rigidbody arrowRigidbody = arrow.GetComponent<Rigidbody>();
            arrow.transform.Rotate(0f, 90f, 0f);
            arrowRigidbody.velocity = shootPoint.forward * arrowSpeed;
        }
    }

    public void AttackEnd() // Metoda wywoływana po zakończeniu animacji ataku
    {
        timePassed = 0; // Resetowanie timePassed po zakończeniu animacji
    }
}
