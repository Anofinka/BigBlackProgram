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

        if (agent.velocity != Vector3.zero)
        {
            isWalking();
        }
        else
            IsNotWalking();

    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("enemy"))
        {
            enemyCount++;
            UpdateMusic(true);
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("enemy"))
        {
            MusicEnemyGone();
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
        enemyCount--;
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
}
