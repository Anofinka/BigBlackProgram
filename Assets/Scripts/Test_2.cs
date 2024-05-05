using UnityEngine;
using System.Collections;
using TMPro;
using UnityEngine.UI;

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
    private float cooldownDuration = 0.0f; // Dodaj zmienn¹ do przechowywania czasu odnowienia
    private Animator characterAnimator;
    // Dodaj zmienn¹ boolowsk¹ do okreœlenia, czy postaæ jest w trakcie animacji ataku
    private bool isAttacking = false;

    void Start()
    {
        if (CrushEffect != null)
        {
            TextCD.gameObject.SetActive(false);
            cooldown.fillAmount = 0.0f;
            CrushEffect.Stop();
            CrushEffect.gameObject.SetActive(false);
            characterAnimator = character.GetComponent<Animator>();
        }
    }

    void Update()
    {
        if (!isAttacking) // Dodaj warunek sprawdzaj¹cy, czy postaæ nie jest w trakcie animacji ataku
        {
            if (Input.GetKeyDown(KeyCode.R) || Input.GetKeyDown(KeyCode.T))
            {
                Vector3 direction = Input.mousePosition - new Vector3(Screen.width / 2, Screen.height / 2, 0);
                character.transform.LookAt(character.transform.position + new Vector3(direction.x, 0, direction.y));
            }

            if (Input.GetKeyDown(KeyCode.T) && !isCrushAttackActive)
            {
                // Rozpocznij animacjê ataku i zatrzymaj postaæ
                StartCrushAttack();
            }
            if (Input.GetKeyDown(KeyCode.Alpha1))
                {
                characterAnimator.SetTrigger("attack");
            }
            if (Input.GetKeyDown(KeyCode.Alpha2))
            {
                characterAnimator.SetTrigger("atack_2");
            }  
            if (Input.GetKeyDown(KeyCode.Alpha3))
            {
                characterAnimator.SetTrigger("atack_3");
            }
            if (Input.GetKeyDown(KeyCode.Alpha4))
            {
                characterAnimator.SetTrigger("atack_4");
            }

        }

        // Aktualizacja tekstu i wype³nienia obrazka cooldownu w czasie rzeczywistym
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
        cooldownDuration = CrushEffect.main.duration; // Ustaw czas odnowienia

        // Rozpocznij animacjê ataku
        StartCoroutine(CrushAttack());
    }

    void UpdateCooldown()
    {
        cooldownDuration -= Time.deltaTime;
        if (cooldownDuration < 0.0f)
        {
            TextCD.gameObject.SetActive(false);
            cooldown.fillAmount = 0.0f;
            isCrushAttackActive = false; // Zakoñcz atak, gdy czas odnowienia siê skoñczy
        }
        else
        {
            TextCD.gameObject.SetActive(true);
            TextCD.text = Mathf.Round(cooldownDuration).ToString();
            cooldown.fillAmount = 1.0f - (cooldownDuration / CrushEffect.main.duration); // Aktualizuj wype³nienie obrazka cooldownu
        }
    }

    IEnumerator AttackRoutine()
    {
        // Odtwórz animacjê ataku
        

        // Oczekuj na zakoñczenie animacji ataku
        yield return new WaitForSeconds(2f);

        // Po zakoñczeniu animacji ataku, przejdŸ do animacji idle
       // characterAnimator.SetTrigger("Idle");
    }
    IEnumerator CrushAttack()
    {
        // Ustaw flagê na true, aby wstrzymaæ ruch postaci podczas animacji ataku
        isAttacking = true;

        ParticleSystem effectInstance = Instantiate(CrushEffect, characterPosition, characterRotation);
        AudioSource.PlayClipAtPoint(CrushAudio, character.transform.position);
        effectInstance.Play();
        effectInstance.gameObject.SetActive(true);

        // Oczekuj na zakoñczenie animacji ataku
        yield return new WaitForSeconds(effectInstance.main.duration);

        effectInstance.Stop();
        effectInstance.gameObject.SetActive(false);
        Destroy(effectInstance.gameObject);

        // Po zakoñczeniu animacji ataku ustaw flagê na false, aby umo¿liwiæ ruch postaci
        isAttacking = false;
    }
}
