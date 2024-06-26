using UnityEngine;

public class TorturialShow : MonoBehaviour
{
    public GameObject statsPanel3; // Referencja do interfejsu u¿ytkownika ekwipunku

    private void Awake()
    {
        nazero23();
    }

    void Update()
    {
       // if (Input.GetKeyDown(KeyCode.R)) // SprawdŸ, czy klawisz "R" zosta³ naciœniêty
        //{
         //   ToggleInventory23(); // Wywo³aj funkcjê do otwierania/ zamykania ekwipunku
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
