using UnityEngine;

public class EnemyAttributes : MonoBehaviour
{
    public string enemyName;
    public int healthPoints = 100;
    public float GetHP() 
    {return healthPoints;}
    public string GetName()
    { return enemyName; }


}
