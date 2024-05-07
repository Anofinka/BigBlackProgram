using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;

public class outliner : MonoBehaviour
{

    //const string IDLE = "Idle";
    //const string WALK = "Walk";

 /*   CustomActions input;
    UnityEngine.Object pint;*/
   // NavMeshAgent agent;
    //Animator animator;
    //Transform particletransform;
    //ParticleSystem particlesystem;

    [Header("Movement")]
    //[SerializeField] ParticleSystem clickEffect;
    //[SerializeField] Transform transpart;
/*    public Object clickEffectObj;
    [SerializeField] LayerMask clickableLayers;*/
    //Object swap;
    RaycastHit hit;

    GameObject enemyobject;
    Outline enemyoutline;

    Outline lastHitOutline;

    //private Vector3 lastMousePosition;

    void Awake()
    {
       // agent = GetComponent<NavMeshAgent>();
        lastHitOutline = null;

    }

    void Update()
    {
        mousepos();
    }


    void mousepos()
    {
        if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100) && hit.collider.CompareTag("enemy"))
        {
            Debug.Log(hit.point);
            //outline awake
            enemyobject = hit.collider.gameObject;
            enemyoutline = enemyobject.GetComponent<Outline>();

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
            // Wy��cz kontur, je�li kursor nie jest nad obiektem
            if (lastHitOutline != null)
            {
                lastHitOutline.enabled = false;
                lastHitOutline = null;
            }
        }


    }

}