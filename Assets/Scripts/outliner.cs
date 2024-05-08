using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class outliner : MonoBehaviour
{
    RaycastHit hit;

    GameObject enemyobject;
    Outline enemyoutline;
    Outline lastHitOutline;

    //private EnemyAttributes enemyAttributes;
    [Header("(Outline enemy + stat enemy GUI)")]
    public GameObject EnemyStatsGUI;
    private CharacterStats characterStats;
    public TextMeshProUGUI NameText;
    public TextMeshProUGUI LvlText;
    public Slider HPslider;


    void Awake()
    {
        EnemyStatsGUI.SetActive(false);
        lastHitOutline = null;
        characterStats = GetComponent<CharacterStats>();
    }

    private void Update()
    {
        mousepos();
    }
        

    void mousepos()
    {
        if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100) && hit.collider.CompareTag("enemy"))
        {
            //outline awake
            enemyobject = hit.collider.gameObject;
            EnemyAttributes enemyAttributes = enemyobject.GetComponent<EnemyAttributes>();

            enemyoutline = enemyobject.GetComponent<Outline>();
            EnemyStatsGUI.SetActive(true);

            //jesli posiada atrybuty
            if (enemyAttributes != null)
            {
/*                if (characterStats.GetPlayerLevel() > enemyAttributes.GetLevel())
                    NameText.color = Color.green;
                else if (characterStats.GetPlayerLevel() == enemyAttributes.GetLevel())
                    NameText.color = Color.white;
                else NameText.color = Color.red;*/ //nieczytelne whuj

                NameText.text = "" + enemyAttributes.GetName();
                LvlText.text = "" + enemyAttributes.GetLevel();
                HPslider.value = enemyAttributes.GetBarValue();
            }
            else
            {
                NameText.text = ("nie dales atrybutow");
            }

            if (enemyoutline != null) //jesli enemy ma outline
            {
                // Wy��cz poprzedni kontur, je�li istnieje
                if (lastHitOutline != null && lastHitOutline != enemyoutline)
                {
                    lastHitOutline.enabled = false;
                }

                // W��cz kontur dla bie��cego obiektu
                enemyoutline.enabled = true;
                lastHitOutline = enemyoutline;
            }
        }
        else
        {
            EnemyStatsGUI.SetActive(false);
            // Wy��cz kontur, je�li kursor nie jest nad obiektem
            if (lastHitOutline != null)
            {
                lastHitOutline.enabled = false;
                lastHitOutline = null;
            }
        }


    }

}