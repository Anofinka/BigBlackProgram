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
            volumeSlider.onValueChanged.AddListener(SetVolume); // Dodaje nas�uchiwanie na zmian� warto�ci Slidera
            volumeSlider.value = 1; // Ustawia domy�ln� warto�� na pe�n� g�o�no�� (1.0)
            Debug.Log("Slider assigned and default value set.");
        }
        else
        {
            Debug.LogWarning("Volume Slider not assigned!");
        }
    }

    // Funkcja ustawiaj�ca g�o�no�� na podstawie warto�ci Slidera
    public void SetVolume(float volume)
    {
        Debug.Log("Volume changed: " + volume);
        if (audioMixer != null)
        {
            audioMixer.SetFloat("MasterVolume", Mathf.Log10(volume) * 20); // Ustawia g�o�no�� na podstawie logarytmu z warto�ci Slidera
            Debug.Log("Volume set to: " + (Mathf.Log10(volume) * 20).ToString() + " dB");
        }
        else
        {
            Debug.LogWarning("AudioMixer not assigned!");
        }
    }
}
