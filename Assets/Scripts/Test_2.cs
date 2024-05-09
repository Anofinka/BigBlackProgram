using UnityEngine;
using System.Collections;
using UnityEngine.AI;
using System.Collections.Generic;
using System.Xml.Linq;
using Unity.VisualScripting;
using System.Linq;
using System;

public class RotateTowardsMouse : MonoBehaviour
{
   // public Image cooldown;
   // public TMP_Text TextCD;
   // public ParticleSystem CrushEffect;
   // public AudioClip CrushAudio;
    public GameObject character;
  //  public bool isCrushAttackActive = false;
    private Vector3 characterPosition;
    private Quaternion characterRotation;
   // private float cooldownDuration = 0.0f;
    private Animator characterAnimator;
    private bool isAttacking = false;
    private bool ismoving = false;
    private NavMeshAgent agent;
    Dictionary<string, Coroutine> activeCoroutines = new Dictionary<string, Coroutine>();
    public CapsuleCollider Mieczorcolid;
    public float clickduration = 0.3f;
    private bool isatac = false;

    void Start()
    {
       Mieczorcolid.enabled = false;
        
           // TextCD.gameObject.SetActive(false);
          //  cooldown.fillAmount = 0.0f;
          //  CrushEffect.Stop();
          //  CrushEffect.gameObject.SetActive(false);
            characterAnimator = character.GetComponent<Animator>();
            agent = character.GetComponent<NavMeshAgent>();
        
    }

    void Update()
    {
        if (!isAttacking)
        {
            if (agent.velocity == Vector3.zero)
            {
                if (ismoving) ismoving = false;

                if (Input.GetKeyDown(KeyCode.T))
                {
                    odwrocsie();
                    
                  //  StartCrushAttack();
                }
                if (Input.GetKeyDown(KeyCode.Alpha1))
                {
                    //Debug.Log(characterAnimator.GetCurrentAnimatorStateInfo(0).length);
                    
                    //nie chce mi sie na combo
                    StartOrRestartCoroutine("attack", "Glory_01_Atk_01");
                }

                if (Input.GetKeyDown(KeyCode.Alpha2))
                {
                    //Debug.Log("pussy");
                    StartOrRestartCoroutine("attack_2", "Glory_01_Skl_SpinAtk_01");
                }
                if (Input.GetKeyDown(KeyCode.Alpha3))
                {
                   StartOrRestartCoroutine("attack_3", "Glory_01_Leap_01");
                }
                if (Input.GetKeyDown(KeyCode.Alpha4))
                {
                    StartOrRestartCoroutine("attack_4", "Glory_01_Berserker_01");
                }
            }
            else if (!ismoving)
            {
                ismoving = true;
                foreach (var parameter in characterAnimator.parameters)
                {
                    characterAnimator.ResetTrigger(parameter.name);
                }
            }
        }
    }

    IEnumerator AttackRoutine()
    {
        yield return new WaitForSeconds(2f);
    }
    IEnumerator OnShotRoutine(string nameZ, float timeZ)
    {

        characterAnimator.SetBool(nameZ, true);
        yield return new WaitForSeconds(timeZ);
        characterAnimator.SetBool(nameZ, false);
        // Po zakoñczeniu coroutine usuñ j¹ z listy
        if (activeCoroutines.ContainsKey(nameZ))
        {
            activeCoroutines.Remove(nameZ);
        }
    }
    IEnumerator AttackTimer(string nameZ, string clipname)
    {
            
            float timeZ = characterAnimator.runtimeAnimatorController.animationClips.FirstOrDefault(clip => clip.name == clipname).length;
            Debug.Log(timeZ);

            Mieczorcolid.enabled = true;
            odwrocsie();
            yield return new WaitForSeconds(timeZ);
            Mieczorcolid.enabled = false;
            isatac = false;
        
            // Po zakoñczeniu coroutine usuñ j¹ z listy
            if (activeCoroutines.ContainsKey(nameZ))
            {
                activeCoroutines.Remove(nameZ);
            }
    }


    void odwrocsie()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        RaycastHit hit;

        // SprawdŸ, czy promieñ z myszy trafia w NavMesh
        if (Physics.Raycast(ray, out hit))
        {
            // Pobierz pozycjê na NavMeshu najbli¿sz¹ punktowi trafienia
            NavMeshHit navHit;
            if (NavMesh.SamplePosition(hit.point, out navHit, 100f, NavMesh.AllAreas))
            {
                // Obróæ postaæ w kierunku punktu na NavMeshu
                Vector3 lookDirection = navHit.position - character.transform.position;
                if (lookDirection != Vector3.zero)
                {
                    character.transform.rotation = Quaternion.LookRotation(lookDirection);
                }
            }
        }
    }

    void StartOrRestartCoroutine(string paramName, string clipname)
    {
        // Dodaj sufiks do kluczy dla ró¿nych coroutine
        string onShotCoroutineKey = paramName + "_OnShot";
        string attackTimerCoroutineKey = paramName + "_AttackTimer";


        // Jeœli coroutine dla danego klucza ju¿ istnieje, zatrzymaj j¹ i usuñ z listy



            if (activeCoroutines.ContainsKey(onShotCoroutineKey))
        {
            StopCoroutine(activeCoroutines[onShotCoroutineKey]);
            activeCoroutines.Remove(onShotCoroutineKey);
        }

        // Dodaj coroutine z odpowiednimi kluczami
        Coroutine onShotCoroutine = StartCoroutine(OnShotRoutine(paramName, clickduration));
        activeCoroutines.Add(onShotCoroutineKey, onShotCoroutine);

        if (!isatac)
        {
            isatac = true;

            if (activeCoroutines.ContainsKey(attackTimerCoroutineKey))
            {
                StopCoroutine(activeCoroutines[attackTimerCoroutineKey]);
                activeCoroutines.Remove(attackTimerCoroutineKey);
            }


            Coroutine attackTimerCoroutine = StartCoroutine(AttackTimer(paramName, clipname));
            activeCoroutines.Add(attackTimerCoroutineKey, attackTimerCoroutine);
        }



        
    }

}
