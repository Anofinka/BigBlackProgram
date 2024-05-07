using UnityEngine;

public class EnemyAttributes : MonoBehaviour
{
    public string enemyName;
    public int healthPoints = 100;

    // Mo¿esz dodaæ inne atrybuty przeciwnika tutaj

    void Start()
    {
        // Mo¿esz zainicjowaæ atrybuty przeciwnika na pocz¹tku
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
