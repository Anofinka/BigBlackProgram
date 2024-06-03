using UnityEngine;

public class MusicChanger : MonoBehaviour
{
    public static MusicChanger Instance { get; private set; }

    public AudioSource musicSource1;
    public AudioSource musicSource2;

    private int enemyCount = 0;

    private void Start()
    {
        musicSource1.Play();
        musicSource2.Play();
        musicSource1.volume = 1f;
        musicSource2.volume = 0f;
    }
    private void Update()
    {
        //Debug.Log(enemyCount);
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("enemy"))
        {
            //Debug.Log("+1");
            enemyCount++;
            UpdateMusic();
        }
    }

    void OnTriggerExit(Collider other)
    {
        if (other.CompareTag("enemy"))
        {
            //Debug.Log("-1");
            enemyCount--;
            UpdateMusic();
        }
    }
    /*    void OnCollisionEnter(Collision other)
        {
            Debug.Log("guwno");
            if (other.collider.CompareTag("enemy"))
            {
                Debug.Log("+1");
                enemyCount++;
                UpdateMusic();
            }
        }

        void OnCollisionExit(Collision other)
        {
            if (other.collider.CompareTag("enemy"))
            {
                Debug.Log("-1");
                enemyCount--;
                UpdateMusic();
            }
        }*/

    private void UpdateMusic()
    {
        if (enemyCount > 0)
        {
            musicSource1.volume = 0;
            musicSource2.volume = 1;
        }
        else
        {
/*            if (enemyCount < 0)
                enemyCount = 0;*/
            musicSource1.volume = 1;
            musicSource2.volume = 0;
        }
    }
/*    private void musichigh()
    { 
            musicSource1.volume = 0f;
            musicSource2.volume = 1f;
    }
    private void musicmid()
    {
        musicSource1.volume = 1f;
        musicSource2.volume = 0f;
    }*/

    public void MusicEnemyGone()
    {
/*        enemyCount--;
        if (enemyCount == 0)
        {
            if (transitionCoroutine != null)
            {
                StopCoroutine(transitionCoroutine);
            }
            transitionCoroutine = StartCoroutine(FadeMusic(musicSource1, musicSource2, transitionTime, false));
        }*/
    }
}
