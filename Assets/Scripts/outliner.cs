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
        RaycastHit[] hits = Physics.RaycastAll(Camera.main.ScreenPointToRay(Input.mousePosition), 100f);
        bool hitEnemy = false;

        foreach (RaycastHit hit in hits)
        {
            if (hit.collider.CompareTag("enemy"))
            {
                hitEnemy = true;
                enemyobject = hit.collider.gameObject;
                EnemyAttributes enemyAttributes = enemyobject.GetComponent<EnemyAttributes>();

                enemyoutline = enemyobject.GetComponent<Outline>();
                EnemyStatsGUI.SetActive(true);

                //jeśli posiada atrybuty
                if (enemyAttributes != null)
                {
                    NameText.text = "" + enemyAttributes.GetName();
                    LvlText.text = "" + enemyAttributes.GetLevel();
                    HPslider.value = enemyAttributes.GetBarValue();
                }
                else
                {
                    NameText.text = ("nie dales atrybutow");
                }

                if (enemyoutline != null) //jeśli enemy ma outline
                {
                    // Wyłącz poprzedni kontur, jeśli istnieje
                    if (lastHitOutline != null && lastHitOutline != enemyoutline)
                    {
                        lastHitOutline.enabled = false;
                    }

                    // Włącz kontur dla bieżącego obiektu
                    enemyoutline.enabled = true;
                    lastHitOutline = enemyoutline;
                }
            }
        }

        if (!hitEnemy)
        {
            EnemyStatsGUI.SetActive(false);
            // Wyłącz kontur, jeśli kursor nie jest nad obiektem
            if (lastHitOutline != null)
            {
                lastHitOutline.enabled = false;
                lastHitOutline = null;
            }
        }



    }

}