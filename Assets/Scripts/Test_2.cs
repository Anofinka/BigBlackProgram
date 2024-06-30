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
    public AnimationClip Attack2;
    [HideInInspector]
    public bool IsSpellOver = true;
    public RandomAudioPlayer RandomAudioPlayer;

    private bool isProcessing = false;

    void Start()
    {
        Mieczorcolid.enabled = false;
        characterAnimator = character.GetComponent<Animator>();
        agent = character.GetComponent<NavMeshAgent>();
    }

    IEnumerator OnShotRoutine(string nameZ, float timeZ)
    {
        characterAnimator.SetBool(nameZ, true);
        yield return new WaitForSeconds(timeZ);
        characterAnimator.SetBool(nameZ, false);
        if (activeCoroutines.ContainsKey(nameZ))
        {
            activeCoroutines.Remove(nameZ);
        }
    }

    IEnumerator AttackTimer(string nameZ, AnimationClip anim)
    {
        float timeZ = anim.length + 0.1f;
        odwrocsie();
        IsSpellOver = false;
        Mieczorcolid.enabled = true;
        yield return new WaitForSeconds(timeZ);
        Mieczorcolid.enabled = false;
        IsSpellOver = true;
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
            if (Physics.Raycast(ray, out hit))
            {
                NavMeshHit navHit;
                if (NavMesh.SamplePosition(hit.point, out navHit, 100f, NavMesh.AllAreas))
                {
                    Vector3 lookDirection = navHit.position - character.transform.position;
                    if (lookDirection != Vector3.zero)
                    {
                        character.transform.rotation = Quaternion.LookRotation(lookDirection);
                    }
                }
            }
        }
    }

    IEnumerator AnimationSequence(string paramName, AnimationClip anim)
    {
        //while (characterAnimator.GetBool(paramName))
        {

            if (characterAnimator.GetBool(paramName))
            {
                //Debug.Log("First Debug");
                RandomAudioPlayer.PlayRandomClip(RandomAudioPlayer.AttackClips);
                yield return new WaitForSeconds(Attack1.length);
            }

            if (characterAnimator.GetBool(paramName))
            {
                //Debug.Log("Second Debug");
                RandomAudioPlayer.PlayRandomClip(RandomAudioPlayer.AttackClips);
                yield return new WaitForSeconds(Attack2.length - 0.05f);
            }
        }

        isProcessing = false; // Reset flag after completion
    }

    public void StartOrRestartCoroutine(string paramName, AnimationClip anim, bool ignoreOn = false)
    {
        string attackTimerCoroutineKey = paramName + "_AttackTimer";
        string onShotCoroutineKey = paramName + "_OnShot";
        string animationSequenceKey = paramName + "_AnimationSequence";

        if (activeCoroutines.ContainsKey(onShotCoroutineKey))
        {
            StopCoroutine(activeCoroutines[onShotCoroutineKey]);
            activeCoroutines.Remove(onShotCoroutineKey);
        }

        Coroutine onShotCoroutine = StartCoroutine(OnShotRoutine(paramName, clickduration));
        activeCoroutines.Add(onShotCoroutineKey, onShotCoroutine);

        if (activeCoroutines.ContainsKey(attackTimerCoroutineKey))
        {
            StopCoroutine(activeCoroutines[attackTimerCoroutineKey]);
            activeCoroutines.Remove(attackTimerCoroutineKey);
        }

        Coroutine attackTimerCoroutine = StartCoroutine(AttackTimer(paramName, anim));
        activeCoroutines.Add(attackTimerCoroutineKey, attackTimerCoroutine);


        if (isProcessing)
            return;
        else if (ignoreOn)
        {
            isProcessing = true; // Set flag to true to prevent re-entry
            if (activeCoroutines.ContainsKey(animationSequenceKey))
            {
                StopCoroutine(activeCoroutines[animationSequenceKey]);
                activeCoroutines.Remove(animationSequenceKey);
            }

            Coroutine animationSequenceCoroutine = StartCoroutine(AnimationSequence(paramName, anim));
            activeCoroutines.Add(animationSequenceKey, animationSequenceCoroutine);
        }
    }

    public void ClickRoutine(string name, AnimationClip anim, bool ignoreOn = false)
    {
        StartOrRestartCoroutine(name, anim, ignoreOn);
    }

    public bool isAgentNotMoving()
    {
        return agent.velocity == Vector3.zero;
    }

    public void AgentStop()
    {
        agent.ResetPath();
    }
}
