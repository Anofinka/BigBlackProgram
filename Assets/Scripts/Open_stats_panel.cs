using UnityEngine;

public class Stats_opener : MonoBehaviour
{
    public GameObject statsPanel; // Referencja do interfejsu u�ytkownika ekwipunku

    private void Awake()
    {
        nazero2();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R)) // Sprawd�, czy klawisz "R" zosta� naci�ni�ty
        {
            ToggleInventory2(); // Wywo�aj funkcj� do otwierania/ zamykania ekwipunku
        }
    }

    public void ToggleInventory2()
    {
        if (statsPanel.activeSelf)
        {
            nazero2();
        }
        else
        {
            statsPanel.SetActive(true);
        }
    }

    void nazero2()
    {
        statsPanel.SetActive(false);
    }
}
