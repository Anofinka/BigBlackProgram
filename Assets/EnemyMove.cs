using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;


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


    
    void Start()
    {
        thisEnemy.GetComponent<Outline>().enabled = false;
        nav = GetComponent<NavMeshAgent>();
        anim = GetComponent<Animator>();
    }

    
    void Update()
    {
        if(outlineOn== false)
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
        if(distance < attackRange || distance > runRange)
        {
            nav.isStopped = true;
            if(distance < attackRange && enemyInfo.IsTag("nonAttack"))
            {
                if(isAttacking == false)
                {
                 isAttacking= true;
                 anim.SetTrigger("attack");
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
}
