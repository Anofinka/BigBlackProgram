using UnityEngine;

public class RandomAudioMonster : MonoBehaviour
{
    public static RandomAudioMonster Instance { get; private set; } // Singleton instance

    public AudioClip[] DamageClips; // Array of audio clips to play
    public AudioSource audioSource; // Audio source


    void Awake()
    {
        // Ensure that there is only one instance of this class
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject); // Optionally make this persist across scenes
        }
        else
        {
            Destroy(gameObject); // Destroy any duplicate instances
        }
    }

    void Start()
    {
        audioSource = GetComponent<AudioSource>();
    }

    public void PlayRandomClip(AudioClip[] AttackClips)
    {
        if (AttackClips.Length > 0)
        {
            int randomIndex = Random.Range(0, AttackClips.Length);
            audioSource.clip = AttackClips[randomIndex];
            audioSource.Play();
            Debug.Log("Playing: " + audioSource.clip.name);
        }
    }

    // This method can be used to play a random damage clip
    public void PlayRandomDamageClip()
    {
        PlayRandomClip(DamageClips);
    }
}
