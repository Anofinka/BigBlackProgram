using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Audio;

public class VolumeControl : MonoBehaviour
{
    public Slider volumeSlider; // Referencja do Slidera
    public AudioMixer audioMixer; // Referencja do AudioMixer

    void Start()
    {
        if (volumeSlider != null)
        {
            volumeSlider.onValueChanged.AddListener(SetVolume); // Dodaje nas³uchiwanie na zmianê wartoœci Slidera
            volumeSlider.value = 1; // Ustawia domyœln¹ wartoœæ na pe³n¹ g³oœnoœæ (1.0)
            Debug.Log("Slider assigned and default value set.");
        }
        else
        {
            Debug.LogWarning("Volume Slider not assigned!");
        }
    }

    // Funkcja ustawiaj¹ca g³oœnoœæ na podstawie wartoœci Slidera
    public void SetVolume(float volume)
    {
        Debug.Log("Volume changed: " + volume);
        if (audioMixer != null)
        {
            audioMixer.SetFloat("MasterVolume", Mathf.Log10(volume) * 20); // Ustawia g³oœnoœæ na podstawie logarytmu z wartoœci Slidera
            Debug.Log("Volume set to: " + (Mathf.Log10(volume) * 20).ToString() + " dB");
        }
        else
        {
            Debug.LogWarning("AudioMixer not assigned!");
        }
    }
}
