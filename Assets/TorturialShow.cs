using UnityEngine;

public class TorturialShow : MonoBehaviour
{
    public GameObject statsPanel3; // Referencja do interfejsu u�ytkownika ekwipunku

    private void Awake()
    {
        nazero23();
    }

    void Update()
    {
       // if (Input.GetKeyDown(KeyCode.R)) // Sprawd�, czy klawisz "R" zosta� naci�ni�ty
        //{
         //   ToggleInventory23(); // Wywo�aj funkcj� do otwierania/ zamykania ekwipunku
       // }
    }

    public void ToggleInventory23()
    {
        if (statsPanel3.activeSelf)
        {
            nazero23();
        }
        else
        {
            statsPanel3.SetActive(true);
        }
    }

    void nazero23()
    {
        statsPanel3.SetActive(false);
    }
}
