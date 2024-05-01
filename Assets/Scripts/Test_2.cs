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
        // Sprawdzenie, czy klawisz "R" zosta� naci�ni�ty
        if (Input.GetKeyDown(KeyCode.R) || Input.GetKeyDown(KeyCode.T))
        {
            Vector3 direction = Input.mousePosition - new Vector3(Screen.width / 2, Screen.height / 2, 0);
            transform.LookAt(transform.position + new Vector3(direction.x, 0, direction.y));
        }
        // Sprawdzenie, czy klawisz "T" zosta� naci�ni�ty
        if (Input.GetKeyDown(KeyCode.T) && !isCrushAttackActive)
        {
            // Zapami�taj pozycj� i rotacj� postaci
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
        // W��cz efekt
        effectInstance.Play();
        effectInstance.gameObject.SetActive(true);

        
        yield return new WaitForSeconds(effectInstance.main.duration);

        effectInstance.Stop();
        effectInstance.gameObject.SetActive(false);
        Destroy(effectInstance.gameObject);

        isCrushAttackActive = false;
    }
}
