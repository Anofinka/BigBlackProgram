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

    void Start()
    {
       
        
        if (CrushEffect != null)
        {
            TextCD.gameObject.SetActive(false);
            cooldown.fillAmount = 0.0f;
            CrushEffect.Stop();
            CrushEffect.gameObject.SetActive(false);
        }
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R) || Input.GetKeyDown(KeyCode.T))
        {
            Vector3 direction = Input.mousePosition - new Vector3(Screen.width / 2, Screen.height / 2, 0);
            character.transform.LookAt(character.transform.position + new Vector3(direction.x, 0, direction.y));
        }

        if (Input.GetKeyDown(KeyCode.T) && !isCrushAttackActive)
        {
            
            StartCrushAttack();
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

    IEnumerator CrushAttack()
    {
        
        ParticleSystem effectInstance = Instantiate(CrushEffect, characterPosition, characterRotation);
        AudioSource.PlayClipAtPoint(CrushAudio, character.transform.position);
        effectInstance.Play();
        effectInstance.gameObject.SetActive(true);

        yield return new WaitForSeconds(effectInstance.main.duration);

        effectInstance.Stop();
        effectInstance.gameObject.SetActive(false);
        Destroy(effectInstance.gameObject);
    }
}
