using UnityEngine;
using System.Collections;
using UnityEngine.AI;
using System.Collections.Generic;
using System.Xml.Linq;
using Unity.VisualScripting;

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
                    
                    
                    StartOrRestartCoroutine("attack", 0.3f);
                }

                if (Input.GetKeyDown(KeyCode.Alpha2))
                {
                    //Debug.Log("pussy");
                    StartOrRestartCoroutine("attack_2", 0.3f);
                }
                if (Input.GetKeyDown(KeyCode.Alpha3))
                {
                    StartOrRestartCoroutine("attack_3", 0.3f);
                }
                if (Input.GetKeyDown(KeyCode.Alpha4))
                {
                    StartOrRestartCoroutine("attack_4", 0.3f);
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
        Mieczorcolid.enabled = true;
        characterAnimator.SetBool(nameZ, true);
        odwrocsie();
        yield return new WaitForSeconds(timeZ);
        characterAnimator.SetBool(nameZ, false);
        Mieczorcolid.enabled = false;

        // Po zakoñczeniu coroutine usuñ j¹ z listy
        if (activeCoroutines.ContainsKey(nameZ))
        {
            activeCoroutines.Remove(nameZ);
        }
    }
    IEnumerator AttackTimer(string nameZ)
    {
        Mieczorcolid.enabled = true;
        characterAnimator.SetBool(nameZ, true);
        odwrocsie();
        float CurAnimTime = characterAnimator.GetCurrentAnimatorStateInfo(0).length;
        
        
        Debug.Log(CurAnimTime);
        Debug.Log(characterAnimator.GetCurrentAnimatorClipInfo(0)[0].clip.ToString());
        yield return new WaitForSeconds(CurAnimTime);
        characterAnimator.SetBool(nameZ, false);
        Mieczorcolid.enabled = false;

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

    void StartOrRestartCoroutine(string paramName, float duration)
    {
        if (activeCoroutines.ContainsKey(paramName))
        {
            StopCoroutine(activeCoroutines[paramName]);
            activeCoroutines.Remove(paramName);
        }

        Coroutine newCoroutine = StartCoroutine(AttackTimer(paramName));
        //Coroutine newCoroutine = StartCoroutine(OnShotRoutine(paramName, duration));
        activeCoroutines.Add(paramName, newCoroutine);
    }

}
