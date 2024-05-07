﻿using TMPro;
using UnityEngine;

public class outliner : MonoBehaviour
{
    RaycastHit hit;

    GameObject enemyobject;
    Outline enemyoutline;
    Outline lastHitOutline;

    //private EnemyAttributes enemyAttributes;
    public GameObject EnemyStatsGUI;
    public GameObject HpTextObjekt;
    //private TextMeshPro HpText;

    void Awake()
    {
        EnemyStatsGUI.SetActive(false);
        lastHitOutline = null;
        //HpText = HpTextObjekt.GetComponent<TextMeshPro>();
    }

    private void Update()
    {
        mousepos();

/*            if (enemyAttributes != null)
            {
                // Odczytaj wartość hp z EnemyAttributes
                float hp = enemyAttributes.GetHP();

                // Możesz teraz wykorzystać wartość hp w tym skrypcie
                Debug.Log("Enemy HP: " + hp);
            }
            else
            {
                Debug.LogWarning("EnemyAttributes reference is null!");
            }*/
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
                // Odczytaj wartość hp z komponentu EnemyAttributes
                float hp = enemyAttributes.GetHP();
                Debug.Log("Enemy HP: " + hp);
                //HpText.text = enemyAttributes.GetName() + "\nHP: " + enemyAttributes.GetHP();
                TextMeshPro hptext = HpTextObjekt.GetComponent<TextMeshPro>();
                hptext.text = ("huj");

                
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