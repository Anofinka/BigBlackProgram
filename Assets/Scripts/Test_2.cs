using UnityEngine;
using System.Collections;
using TMPro;
using UnityEngine.UI;
using UnityEngine.AI;
using System.Collections.Generic;

public class RotateTowardsMouse : MonoBehaviour
{
    public Image cooldown;
    public TMP_Text TextCD;
    public ParticleSystem CrushEffect;
    public AudioClip CrushAudio;
    public GameObject character;
    public bool isCrushAttackActive = false;
    private Vector3 characterPosition;
    private Quaternion characterRotation;
    private float cooldownDuration = 0.0f;
    private Animator characterAnimator;
    private bool isAttacking = false;
    private bool ismoving = false;
    private NavMeshAgent agent;
    Dictionary<string, Coroutine> activeCoroutines = new Dictionary<string, Coroutine>();

    void Start()
    {
        if (CrushEffect != null)
        {
            TextCD.gameObject.SetActive(false);
            cooldown.fillAmount = 0.0f;
            CrushEffect.Stop();
            CrushEffect.gameObject.SetActive(false);
            characterAnimator = character.GetComponent<Animator>();
            agent = character.GetComponent<NavMeshAgent>();
        }
    }

    void Update()
    {
        if (!isAttacking)
        {
            if (agent.velocity == Vector3.zero)
            {
                if (ismoving) ismoving = false;

                if (Input.GetKeyDown(KeyCode.T) && !isCrushAttackActive)
                {
                    odwrocsie();
                    StartCrushAttack();
                }
                if (Input.GetKeyDown(KeyCode.Alpha1))
                {
                    
                    StartOrRestartCoroutine("attack", 0.3f);
                }

                if (Input.GetKeyDown(KeyCode.Alpha2))
                {

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

        if (isCrushAttackActive)
        {
            UpdateCooldown();
        }
    }

    public void StartCrushAttack()
    {
        characterPosition = character.transform.position;
        characterRotation = character.transform.rotation;
        isCrushAttackActive = true;
        cooldownDuration = CrushEffect.main.duration;

        StartCoroutine(CrushAttack());
    }

    void UpdateCooldown()
    {
        cooldownDuration -= Time.deltaTime;
        if (cooldownDuration < 0.0f)
        {
            TextCD.gameObject.SetActive(false);
            cooldown.fillAmount = 0.0f;
            isCrushAttackActive = false;
        }
        else
        {
            TextCD.gameObject.SetActive(true);
            TextCD.text = Mathf.Round(cooldownDuration).ToString();
            cooldown.fillAmount = 1.0f - (cooldownDuration / CrushEffect.main.duration);
        }
    }

    IEnumerator AttackRoutine()
    {
        yield return new WaitForSeconds(2f);
    }
    IEnumerator CrushAttack()
    {
        isAttacking = true;

        ParticleSystem effectInstance = Instantiate(CrushEffect, characterPosition, characterRotation);
        AudioSource.PlayClipAtPoint(CrushAudio, character.transform.position);
        effectInstance.Play();
        effectInstance.gameObject.SetActive(true);

        yield return new WaitForSeconds(effectInstance.main.duration);

        effectInstance.Stop();
        effectInstance.gameObject.SetActive(false);
        Destroy(effectInstance.gameObject);

        isAttacking = false;
    }

    IEnumerator OnShotRoutine(string nameZ, float timeZ)
    {
        characterAnimator.SetBool(nameZ, true);
        odwrocsie();
        yield return new WaitForSeconds(timeZ);
        characterAnimator.SetBool(nameZ, false);

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

    void StartOrRestartCoroutine(string paramName, float duration)
    {
        if (activeCoroutines.ContainsKey(paramName))
        {
            StopCoroutine(activeCoroutines[paramName]);
            activeCoroutines.Remove(paramName);
        }

        Coroutine newCoroutine = StartCoroutine(OnShotRoutine(paramName, duration));
        activeCoroutines.Add(paramName, newCoroutine);
    }

}
