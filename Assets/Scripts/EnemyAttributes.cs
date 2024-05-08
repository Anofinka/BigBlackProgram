using UnityEngine;

public class EnemyAttributes : MonoBehaviour
{
    public string enemyName;
    public int healthPoints = 100;
    public float EnemyLevel = 1;
    private float Strength;

    public float GetHP()    {return healthPoints;}
    public string GetName() {return enemyName;}
    public float GetLevel()
    {
        if (EnemyLevel < 1) EnemyLevel = 1;
        return EnemyLevel;
    }
    public float GetHPByLvl()
    {
        return (healthPoints * (1 + EnemyLevel/8));
    }


}
