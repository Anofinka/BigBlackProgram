using UnityEngine;

public class RandomAudioPlayer : MonoBehaviour
{
    public AudioClip[] AttackClips; // Tablica klip�w audio do odtwarzania
    public AudioClip[] SpellClips; // Tablica klip�w audio do odtwarzania
    private AudioSource audioSource; // �r�d�o audio

    void Start()
    {
            audioSource = GetComponent<AudioSource>();
        //PlayRandomClip();
    }

    public void PlayRandomClip(AudioClip[] AttackClips)
    {
        if (AttackClips.Length > 0)
        {
            int randomIndex = Random.Range(0, AttackClips.Length);
            audioSource.clip = AttackClips[randomIndex];
            audioSource.Play();
            //Debug.Log("playin: " + audioSource.clip.name);
        }
        else
        {
            Debug.LogWarning("No audio clips assigned to the array.");
        }
    }
}
