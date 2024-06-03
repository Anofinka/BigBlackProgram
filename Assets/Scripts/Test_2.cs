using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class Test_2 : MonoBehaviour
{
    public GameObject character;
    private Animator characterAnimator;
    private NavMeshAgent agent;
    Dictionary<string, Coroutine> activeCoroutines = new Dictionary<string, Coroutine>();
    public CapsuleCollider Mieczorcolid;
    public float clickduration = 0.3f;
    [Header("Animacje atakow")]
    public AnimationClip Attack1;
    [HideInInspector]
    public bool IsSpellOver = true;

    void Start()
    {
        Mieczorcolid.enabled = false;
        characterAnimator = character.GetComponent<Animator>();
        agent = character.GetComponent<NavMeshAgent>();

    }

/*    void Update()
    {
        //AnimationAsk();
    }*/
    IEnumerator OnShotRoutine(string nameZ, float timeZ)
    {

        characterAnimator.SetBool(nameZ, true);
        //Debug.Log("on");
        yield return new WaitForSeconds(timeZ);
        characterAnimator.SetBool(nameZ, false);
        // Po zakoñczeniu coroutine usuñ j¹ z listy
        //Debug.Log("off");
        if (activeCoroutines.ContainsKey(nameZ))
        {
            activeCoroutines.Remove(nameZ);
        }

    }

    IEnumerator AttackTimer(string nameZ, AnimationClip anim)
    {
        float timeZ = anim.length + 0.1f;
        //Debug.Log(timeZ);
        odwrocsie();
        IsSpellOver = false;
        Mieczorcolid.enabled = true;
        yield return new WaitForSeconds(timeZ);
        Mieczorcolid.enabled = false;
        IsSpellOver = true;

        // Po zakoñczeniu coroutine usuñ j¹ z listy
        if (activeCoroutines.ContainsKey(nameZ))
        {
            activeCoroutines.Remove(nameZ);
        }
    }
    void odwrocsie()
    {
        if (IsSpellOver)
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
    }
    public void StartOrRestartCoroutine(string paramName, AnimationClip anim)
    {
        // Dodaj sufiks do kluczy dla ró¿nych coroutine
        string attackTimerCoroutineKey = paramName + "_AttackTimer";
        string onShotCoroutineKey = paramName + "_OnShot";

        // Jeœli coroutine dla danego klucza ju¿ istnieje, zatrzymaj j¹ i usuñ z listy

        if (activeCoroutines.ContainsKey(onShotCoroutineKey))
        {
            StopCoroutine(activeCoroutines[onShotCoroutineKey]);
            activeCoroutines.Remove(onShotCoroutineKey);
        }
        // Dodaj coroutine z odpowiednimi kluczami
        Coroutine onShotCoroutine = StartCoroutine(OnShotRoutine(paramName, clickduration));
        activeCoroutines.Add(onShotCoroutineKey, onShotCoroutine);

            if (activeCoroutines.ContainsKey(attackTimerCoroutineKey))
            {
                StopCoroutine(activeCoroutines[attackTimerCoroutineKey]);
                activeCoroutines.Remove(attackTimerCoroutineKey);
            }

            Coroutine attackTimerCoroutine = StartCoroutine(AttackTimer(paramName, anim));
            activeCoroutines.Add(attackTimerCoroutineKey, attackTimerCoroutine);
    }
    public void ClickRoutine(string name, AnimationClip anim)
    {
        StartOrRestartCoroutine(name, anim);
    }

    public bool isAgentNotMoving()
    {
        return agent.velocity == Vector3.zero;
    }

    public void AgentStop()
    { agent.ResetPath(); }
}
