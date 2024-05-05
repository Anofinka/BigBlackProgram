using System.Collections;
using System.Collections.Generic;
using UnityEditor.Rendering.LookDev;
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


    bool isAttacking = false; // Flaga okreœlaj¹ca, czy wrogowie wykonuj¹ atak
    float originalAgentSpeed; // Zmienna przechowuj¹ca oryginaln¹ prêdkoœæ agenta

    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        
        player = GameObject.FindGameObjectWithTag("Player");

        // Zapisz oryginaln¹ prêdkoœæ agenta
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
                isAttacking = true; // Ustaw flagê ataku na true
                agent.speed = 0; // Zatrzymaj agenta podczas ataku
            }
        }
        timePassed += Time.deltaTime;

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
        isAttacking = false; // Po zakoñczeniu animacji ataku ustaw flagê ataku na false
        agent.speed = originalAgentSpeed; // Przywróæ normaln¹ prêdkoœæ agenta
        agent.velocity = Vector3.zero; // Zatrzymaj agenta po zakoñczeniu animacji ataku
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
