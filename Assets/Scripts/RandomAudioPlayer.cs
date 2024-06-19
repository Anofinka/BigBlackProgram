using UnityEngine;

public class RandomAudioPlayer : MonoBehaviour
{
    public AudioClip[] AttackClips; // Tablica klipÛw audio do odtwarzania
    public AudioClip[] SpellClips; // Tablica klipÛw audio do odtwarzania
    private AudioSource audioSource; // èrÛd≥o audio

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
