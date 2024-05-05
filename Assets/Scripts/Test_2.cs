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
    private float cooldownDuration = 0.0f; // Dodaj zmienn� do przechowywania czasu odnowienia
    private Animator characterAnimator;
    // Dodaj zmienn� boolowsk� do okre�lenia, czy posta� jest w trakcie animacji ataku
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
        if (!isAttacking) // Dodaj warunek sprawdzaj�cy, czy posta� nie jest w trakcie animacji ataku
        {
            if (Input.GetKeyDown(KeyCode.R) || Input.GetKeyDown(KeyCode.T))
            {
                Vector3 direction = Input.mousePosition - new Vector3(Screen.width / 2, Screen.height / 2, 0);
                character.transform.LookAt(character.transform.position + new Vector3(direction.x, 0, direction.y));
            }

            if (Input.GetKeyDown(KeyCode.T) && !isCrushAttackActive)
            {
                // Rozpocznij animacj� ataku i zatrzymaj posta�
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

        // Aktualizacja tekstu i wype�nienia obrazka cooldownu w czasie rzeczywistym
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

        // Rozpocznij animacj� ataku
        StartCoroutine(CrushAttack());
    }

    void UpdateCooldown()
    {
        cooldownDuration -= Time.deltaTime;
        if (cooldownDuration < 0.0f)
        {
            TextCD.gameObject.SetActive(false);
            cooldown.fillAmount = 0.0f;
            isCrushAttackActive = false; // Zako�cz atak, gdy czas odnowienia si� sko�czy
        }
        else
        {
            TextCD.gameObject.SetActive(true);
            TextCD.text = Mathf.Round(cooldownDuration).ToString();
            cooldown.fillAmount = 1.0f - (cooldownDuration / CrushEffect.main.duration); // Aktualizuj wype�nienie obrazka cooldownu
        }
    }

    IEnumerator AttackRoutine()
    {
        // Odtw�rz animacj� ataku
        

        // Oczekuj na zako�czenie animacji ataku
        yield return new WaitForSeconds(2f);

        // Po zako�czeniu animacji ataku, przejd� do animacji idle
       // characterAnimator.SetTrigger("Idle");
    }
    IEnumerator CrushAttack()
    {
        // Ustaw flag� na true, aby wstrzyma� ruch postaci podczas animacji ataku
        isAttacking = true;

        ParticleSystem effectInstance = Instantiate(CrushEffect, characterPosition, characterRotation);
        AudioSource.PlayClipAtPoint(CrushAudio, character.transform.position);
        effectInstance.Play();
        effectInstance.gameObject.SetActive(true);

        // Oczekuj na zako�czenie animacji ataku
        yield return new WaitForSeconds(effectInstance.main.duration);

        effectInstance.Stop();
        effectInstance.gameObject.SetActive(false);
        Destroy(effectInstance.gameObject);

        // Po zako�czeniu animacji ataku ustaw flag� na false, aby umo�liwi� ruch postaci
        isAttacking = false;
    }
}
