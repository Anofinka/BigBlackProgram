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
    
    void Start()
    {
        thisEnemy.GetComponent<Outline>().enabled = false;
        nav = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();
        nav.avoidancePriority = Random.Range(5,75);
    }

    void Update()
    {
        // Aktualizacja fillAmount na podstawie aktualnej ilości zdrowia wroga
        fillHealth = enemyHealth / maxHealth; // Obliczenie procentowego zdrowia
        healtBar.fillAmount = fillHealth; // Aktualizacja fillAmount na healthBar

        // Ustawienie paska zdrowia w stronę kamery
        healtBar.transform.LookAt(mainCam.transform.position);

        if(enemyHealth <= 0 && isAlive ==true)
        {
            isAlive = false;
            nav.isStopped = true;
            anim.SetTrigger("die");
            nav.avoidancePriority = 1;
        }
        

        // Reszta kodu...
        
        if(outlineOn == false)
        {
            outlineOn = true;
            if(SaveScript.theTarget == thisEnemy)
            {
                thisEnemy.GetComponent<Outline>().enabled = false;
                outlineOn = false;
            }
        }
        if(player == null)
        {
            player = GameObject.FindGameObjectWithTag("Player");
        }
        x = nav.velocity.x;
        z = nav.velocity.z;
        velocitySpeed = x + z;
        if(velocitySpeed == 0)
        {
            anim.SetBool("running", false);
        }
        else
        {
           anim.SetBool("running", true); 
           isAttacking = false;
        }
        enemyInfo = anim.GetCurrentAnimatorStateInfo(0);
        distance = Vector3.Distance(transform.position,player.transform.position);
        
        if(isAlive)
        {
            if(distance < attackRange || distance > runRange)
            {
                nav.isStopped = true;
                if(distance < attackRange && enemyInfo.IsTag("nonAttack"))
                {
                    if(isAttacking == false)
                    {
                        isAttacking = true;
                        anim.SetTrigger("attack");
                        transform.LookAt(player.transform);
                        StartCoroutine(LookAtPlayer());
                        Debug.Log("Straciles 10hp");

                        if(attackSound != null) 
                        {
                            attackSound.Play(); 
                        }
                    }
                }
                if(distance < attackRange && enemyInfo.IsTag("attack"))
                {
                    if(isAttacking == true)
                    {
                        isAttacking = false;
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
        if(isAlive == true)
        {
            transform.LookAt(player.transform);
        }
    }
}
