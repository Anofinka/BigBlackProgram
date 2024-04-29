using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;

public class EnemyMove : MonoBehaviour
{
    public GameObject thisEnemy;
    private bool outlineOn = false;
    private NavMeshAgent nav;
    private Animator anim;
    private AnimatorStateInfo enemyInfo;
    public float attackCooldown = 2f; // Opóźnienie między kolejnymi atakami
    private float lastAttackTime = 0f;

    private float x;
    private float z;
    private float velocitySpeed;
    public GameObject player;
    private float distance;
    private bool isAttacking = false;
    public float attackRange = 2.0f;
    public float runRange = 12.0f;
    public AudioSource attackSound;
    public float enemyHealth;
    private int maxHealth = 100;
    public Image healtBar;
    private float fillHealth;
    public GameObject mainCam;
    private WaitForSeconds lookTime = new WaitForSeconds(2);
    bool isAlive = true;


    Animator playerAnimator;
    public AudioClip[] deathClips;


    void Start()
    {
        thisEnemy.GetComponent<Outline>().enabled = false;
        nav = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();
        nav.avoidancePriority = Random.Range(5, 75);
        playerAnimator = GameObject.FindGameObjectWithTag("Player").GetComponent<Animator>();
    }

    void Update()
    {
        // Aktualizacja fillAmount na podstawie aktualnej ilości zdrowia wroga
        fillHealth = enemyHealth / maxHealth; // Obliczenie procentowego zdrowia
        healtBar.fillAmount = fillHealth; // Aktualizacja fillAmount na healthBar

        // Ustawienie paska zdrowia w stronę kamery
        healtBar.transform.LookAt(mainCam.transform.position);

        if (enemyHealth <= 0 && isAlive == true)
        {
            isAlive = false;
            nav.isStopped = true;
            anim.SetTrigger("die");
            nav.avoidancePriority = 1;
        }


        // Reszta kodu...

        if (outlineOn == false)
        {
            outlineOn = true;
            if (SaveScript.theTarget == thisEnemy)
            {
                thisEnemy.GetComponent<Outline>().enabled = false;
                outlineOn = false;
            }
        }
        if (player == null)
        {
            player = GameObject.FindGameObjectWithTag("Player");
        }
        x = nav.velocity.x;
        z = nav.velocity.z;
        velocitySpeed = x + z;
        if (velocitySpeed == 0)
        {
            anim.SetBool("running", false);
        }
        else
        {
            anim.SetBool("running", true);
            isAttacking = false;
        }
        enemyInfo = anim.GetCurrentAnimatorStateInfo(0);
        distance = Vector3.Distance(transform.position, player.transform.position);
        if (isAlive && player.GetComponent<PlayerController>().Life)
        {
            if (distance < attackRange || distance > runRange)
            {
                nav.isStopped = true;
                if (distance < attackRange && enemyInfo.IsTag("nonAttack"))
                {
                    if (!isAttacking && Time.time >= lastAttackTime + attackCooldown)
                    {
                        isAttacking = true;
                        lastAttackTime = Time.time; // Ustaw czas ostatniego ataku
                        anim.SetTrigger("attack");
                        transform.LookAt(player.transform);
                        StartCoroutine(LookAtPlayer());
                        Debug.Log("Straciles 10hp");
                        playerAnimator.SetTrigger("hit");

                        if (attackSound != null)
                        {
                            attackSound.Play();
                        }
                    }
                }
                if (distance < attackRange && enemyInfo.IsTag("attack"))
                {
                    if (isAttacking)
                    {
                        isAttacking = false; // Zakończ atak, ustawiając flagę na false
                    }
                }
            }
            else
            {
                nav.isStopped = false;
                nav.destination = player.transform.position;
            }
        }
        else
        {
            nav.isStopped = true; // Zatrzymaj przeciwnika, gdy jest martwy
        }
    }

    IEnumerator LookAtPlayer()
    {
        yield return lookTime;
        if (isAlive == true)
        {
            transform.LookAt(player.transform);
        }
    }

    public void TakeDamageFromPlayer(int damage)
    {
        if (enemyHealth > 0)
        {
            enemyHealth -= damage;
            if (enemyHealth <= 0 && isAlive)
            {

                isAlive = false;
                nav.isStopped = true;
                anim.SetTrigger("die");
                nav.avoidancePriority = 1;
                if (deathClips != null && deathClips.Length > 0)
                {
                    int randomIndex = Random.Range(0, deathClips.Length);
                    AudioSource.PlayClipAtPoint(deathClips[randomIndex], transform.position);
                }
            }
            else
            {
                anim.SetTrigger("hit"); // Uruchom animację obrażeń wroga
            }
        }
    }
    public void TakeDamageFromTrap(float damage)
    {
        if (isAlive)
        {
            enemyHealth -= damage;
            if (enemyHealth <= 0)
            {
                isAlive = false;
                // Tutaj możesz dodać dodatkowe działania w przypadku śmierci przeciwnika, np. odtwarzanie animacji śmierci
                Destroy(gameObject); // Możesz również usunąć obiekt przeciwnika, jeśli chcesz, żeby zniknął po śmierci
            }
        }
    }
}
