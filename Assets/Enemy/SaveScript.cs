using UnityEngine;
public class SaveScript : MonoBehaviour
{
    public static int pchar = 0;
    public static string pname = "player";
    public static GameObject spawnPoint;
    public static GameObject theTarget;
    public static float manaAmt = 1.0f;
    public static float staminaAmt = 1.0f;
    public static bool invisible = false;
    public static float strengthAmt = 0.1f;
    public static float manaPowerAmt = 0.1f;
    public static float staminaPowerAmt = 0.1f;
    public static int killAmt = 0;
    public static int weaponChoice = 0;
    public static bool weaponChange = false;
    public static bool carryingWeapon = false;
    public static int armor = 0;
    public static bool changeArmor = false;
    public static float playerHealth = 1f;
    public static float enemyHealth = 1f;
    // Start is called before the first frame update
    void Start()
    {
        DontDestroyOnLoad(this);
    }
    // Update is called once per frame
    void Update()
    {
        if (manaAmt < 1.0)
        {
            manaAmt += 0.04f * Time.deltaTime;
        }
        if (manaAmt <= 0)
        {
            manaAmt = 0;
        }
        if (manaAmt < 0.03)
        {
            invisible = false;
        }
        if (staminaAmt < 1.0)
        {
            staminaAmt += 0.04f * Time.deltaTime;
        }
        if (staminaAmt <= 0)
        {
            staminaAmt = 0;
        }
    }
}