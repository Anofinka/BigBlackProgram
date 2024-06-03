using System.Collections;
using UnityEngine;

public class MusicChanger : MonoBehaviour
{
    public AudioSource ThemeMid;
    public AudioSource ThemeHigh;
    public float enterTransitionTime = 2.0f;
    public float exitTransitionTime = 2.0f;

    private int enemyCount = 0;
    private Coroutine transitionCoroutine;


    void Start()
    {
        ThemeMid.volume = 1;
        ThemeHigh.volume = 0;
        ThemeMid.Play();
        ThemeHigh.Play();
    }

    void Update()
    {   
        // Weryfikacja i zapewnienie, ¿e liczba wrogów nie jest ujemna
        if (enemyCount < 0)
        {
            enemyCount = 0;
        }
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

/*    void OnTriggerStay(Collider other)
    {
        if (other.CompareTag("enemy"))
        {
            // Upewnij siê, ¿e liczba wrogów jest poprawna
            if (enemyCount == 0)
            {
                enemyCount = 1;
                UpdateMusic(true);
            }
        }
    }*/

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

    public void MusicEnemyGone()
    {
        enemyCount--;      
        UpdateMusic(false);
    }
}
