using UnityEngine;
using System.Collections;

public class RotateTowardsMouse : MonoBehaviour
{
    public ParticleSystem CrushEffect;
    public AudioClip CrushAudio;
    private bool isCrushAttackActive = false;
    private Vector3 characterPosition;
    private Quaternion characterRotation;

    void Start()
    {
        // Sprawdzenie, czy efekt istnieje i zatrzymanie go na starcie
        if (CrushEffect != null)
        {
            CrushEffect.Stop();
            CrushEffect.gameObject.SetActive(false);
        }
    }

    void Update()
    {
        // Sprawdzenie, czy klawisz "R" zosta³ naciœniêty
        if (Input.GetKeyDown(KeyCode.R) || Input.GetKeyDown(KeyCode.T))
        {
            Vector3 direction = Input.mousePosition - new Vector3(Screen.width / 2, Screen.height / 2, 0);
            transform.LookAt(transform.position + new Vector3(direction.x, 0, direction.y));
        }
        // Sprawdzenie, czy klawisz "T" zosta³ naciœniêty
        if (Input.GetKeyDown(KeyCode.T) && !isCrushAttackActive)
        {
            // Zapamiêtaj pozycjê i rotacjê postaci
            characterPosition = transform.position;
            characterRotation = transform.rotation;
            StartCoroutine(CrushAttack());
        }
    }

    IEnumerator CrushAttack()
    {
        isCrushAttackActive = true;

        
        ParticleSystem effectInstance = Instantiate(CrushEffect, characterPosition, characterRotation);
        AudioSource.PlayClipAtPoint(CrushAudio, transform.position);
        // W³¹cz efekt
        effectInstance.Play();
        effectInstance.gameObject.SetActive(true);

        
        yield return new WaitForSeconds(effectInstance.main.duration);

        effectInstance.Stop();
        effectInstance.gameObject.SetActive(false);
        Destroy(effectInstance.gameObject);

        isCrushAttackActive = false;
    }
}
