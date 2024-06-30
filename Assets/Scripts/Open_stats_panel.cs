using UnityEngine;

public class Stats_opener : MonoBehaviour
{
    public GameObject statsPanel; // Referencja do interfejsu u¿ytkownika ekwipunku

    private void Awake()
    {
        nazero2();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.R)) // SprawdŸ, czy klawisz "R" zosta³ naciœniêty
        {
            ToggleInventory2(); // Wywo³aj funkcjê do otwierania/ zamykania ekwipunku
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
