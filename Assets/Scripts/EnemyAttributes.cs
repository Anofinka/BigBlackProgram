using UnityEngine;

public class EnemyAttributes : MonoBehaviour
{
    public string enemyName;
    public int healthPoints = 100;

    // Mo�esz doda� inne atrybuty przeciwnika tutaj

    void Start()
    {
        // Mo�esz zainicjowa� atrybuty przeciwnika na pocz�tku
    }

    public float GetHP() 
    {
        return healthPoints;
    }
    public string GetName()
    {
        return enemyName;
    }


}
