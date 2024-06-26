using UnityEngine;
using UnityEngine.AI;

public class Enemy : MonoBehaviour
{
    [SerializeField] float health = 3;
    [SerializeField] GameObject hitVFX;
    [SerializeField] GameObject ragdoll;

    [Header("Combat")]
    [SerializeField] float attackCD = 1f; // Czas odnowienia ataku
    [SerializeField] float attackRange = 2f; // Zasięg ataku
    [SerializeField] float aggroRange = 10f; // Zasięg agro

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

        // Sprawdzamy, czy AnimatorController jest przypisany do Animatora
        if (animator.runtimeAnimatorController == null)
        {
            Debug.LogError("AnimatorController is not assigned to the Animator on " + gameObject.name);
        }

        // Debugowanie
        if (player == null)
        {
            Debug.LogError("Player not found. Make sure the player object has the tag 'Player'.");
        }
    }

    void Update()
    {
        if (player == null)
        {
            return;
        }

        float distanceToPlayer = Vector3.Distance(player.transform.position, transform.position);
        timePassed += Time.deltaTime;

        // Atakowanie gracza
        if (timePassed >= attackCD && distanceToPlayer <= attackRange)
        {
            if (animator != null && animator.runtimeAnimatorController != null)
            {
                animator.SetTrigger("attack");
                agent.speed = 0; // Zatrzymanie agenta podczas ataku
            }
            timePassed = 0;
        }
        else
        {
            // Podążanie za graczem, jeśli znajduje się w zasięgu agro
            if (distanceToPlayer <= aggroRange)
            {
                if (newDestinationCD <= 0)
                {
                    if (agent.isActiveAndEnabled)
                    {
                        agent.SetDestination(player.transform.position);
                    }
                    newDestinationCD = 0.5f;
                }

                newDestinationCD -= Time.deltaTime;
            }

            agent.speed = originalAgentSpeed;
        }

        // Obracanie w kierunku gracza
        if (distanceToPlayer <= aggroRange)
        {
            Vector3 directionToPlayer = (player.transform.position - transform.position).normalized;
            Quaternion lookRotation = Quaternion.LookRotation(new Vector3(directionToPlayer.x, 0, directionToPlayer.z));
            transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, Time.deltaTime * 5f);
        }

        SetAnimations();
    }

    void SetAnimations()
    {
        if (animator != null && animator.runtimeAnimatorController != null)
        {
            animator.SetBool("walk", agent.velocity.magnitude > 0.1f);
        }
    }

    public void TakeDamage(float damageAmount)
    {
        health -= damageAmount;
        if (animator != null && animator.runtimeAnimatorController != null)
        {
            animator.SetTrigger("damage");
        }

        if (health <= 0)
        {
            Die();
        }
    }

    void Die()
    {
        Instantiate(ragdoll, transform.position, transform.rotation);
        Destroy(gameObject);
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
}
