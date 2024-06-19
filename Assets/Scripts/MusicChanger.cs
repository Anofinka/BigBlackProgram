using System.Collections;
using UnityEngine;
using UnityEngine.AI;

public class MusicChanger : MonoBehaviour
{
    public AudioSource ThemeMid;
    public AudioSource ThemeHigh;
    public float enterTransitionTime = 2.0f;
    public float exitTransitionTime = 2.0f;
    public float WalkEnterTime = 0.2f;
    public float WalkExitTime = 0.2f;
    public AudioSource Footsteps;
    public NavMeshAgent agent;
    public float detectionRadius = 5.0f; // Radius to detect enemies

    private int enemyCount = 0;
    private Coroutine transitionCoroutine;
    private Coroutine footstepsCoroutine;

    void Start()
    {
        ThemeMid.volume = 1;
        ThemeHigh.volume = 0;
        ThemeMid.Play();
        ThemeHigh.Play();
        Footsteps.volume = 0; // Initial volume for footsteps
        Footsteps.Play();
    }

    void Update()
    {
        // Verify and ensure the enemy count is not negative
        if (enemyCount < 0)
        {
            enemyCount = 0;
        }

        // Check for enemies within detection radius
        CheckForEnemies();

        if (agent.velocity != Vector3.zero)
        {
            isWalking();
        }
        else
        {
            IsNotWalking();
        }
    }

    private void CheckForEnemies()
    {
        Collider[] hitColliders = Physics.OverlapSphere(transform.position, detectionRadius);
        int currentEnemyCount = 0;

        foreach (var hitCollider in hitColliders)
        {
            if (hitCollider.CompareTag("enemy"))
            {
                currentEnemyCount++;
            }
        }

        if (currentEnemyCount > enemyCount)
        {
            enemyCount = currentEnemyCount;
            UpdateMusic(true);
        }
        else if (currentEnemyCount < enemyCount)
        {
            enemyCount = currentEnemyCount;
            UpdateMusic(false);
        }
    }

    private void UpdateMusic(bool isEntering)
    {
        if (isEntering && enemyCount > 0)
        {
            if (transitionCoroutine != null)
            {
                StopCoroutine(transitionCoroutine);
            }
            transitionCoroutine = StartCoroutine(FadeMusic(ThemeMid, ThemeHigh, enterTransitionTime));
        }
        else if (!isEntering && enemyCount == 0)
        {
            if (transitionCoroutine != null)
            {
                StopCoroutine(transitionCoroutine);
            }
            transitionCoroutine = StartCoroutine(FadeMusic(ThemeHigh, ThemeMid, exitTransitionTime));
        }
    }

    private IEnumerator FadeMusic(AudioSource from, AudioSource to, float duration)
    {
        float time = 0;
        float startVolume1 = from.volume;
        float startVolume2 = to.volume;

        while (time < duration)
        {
            time += Time.deltaTime;
            from.volume = Mathf.Lerp(startVolume1, 0, time / duration);
            to.volume = Mathf.Lerp(startVolume2, 1, time / duration);
            yield return null;
        }

        from.volume = 0;
        to.volume = 1;
    }

    private IEnumerator FadeFootsteps(AudioSource audioSource, float targetVolume, float duration)
    {
        float time = 0;
        float startVolume = audioSource.volume;

        while (time < duration)
        {
            time += Time.deltaTime;
            audioSource.volume = Mathf.Lerp(startVolume, targetVolume, time / duration);
            yield return null;
        }

        audioSource.volume = targetVolume;
    }

    public void MusicEnemyGone()
    {
        UpdateMusic(false);
    }

    public void isWalking()
    {
        if (footstepsCoroutine != null)
        {
            StopCoroutine(footstepsCoroutine);
        }
        footstepsCoroutine = StartCoroutine(FadeFootsteps(Footsteps, 1, WalkEnterTime)); // Fade in footsteps
    }

    public void IsNotWalking()
    {
        if (footstepsCoroutine != null)
        {
            StopCoroutine(footstepsCoroutine);
        }
        footstepsCoroutine = StartCoroutine(FadeFootsteps(Footsteps, 0, WalkExitTime)); // Fade out footsteps
    }

    // Draw the detection radius in the editor
    private void OnDrawGizmosSelected()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, detectionRadius);
    }
}
