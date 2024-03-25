using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;

public class PlayerController : MonoBehaviour
{
    //const string IDLE = "Idle";
    //const string WALK = "Walk";

    CustomActions input;
    UnityEngine.Object pint;
    NavMeshAgent agent;
    Animator animator;
    Transform particletransform;
    //ParticleSystem particlesystem;

    [Header("Movement")]
    //[SerializeField] ParticleSystem clickEffect;
    //[SerializeField] Transform transpart;
    public Object clickEffectObj;
    [SerializeField] LayerMask clickableLayers;
    Object swap;
    float lookRotationSpeed = 8f;
    RaycastHit hit;

    GameObject enemyobject;
    Outline enemyoutline;

    Outline lastHitOutline;   

    void Awake()
    {
        agent = GetComponent<NavMeshAgent>();
        animator = GetComponent<Animator>();
        particletransform = clickEffectObj.GetComponent<Transform>();
        //particlesystem = clickEffectObj.GetComponent<ParticleSystem>();
        input = new CustomActions();
        AssignInputs();
        
    }

    void AssignInputs()
    { input.Main.Move.performed += ctx => ClickToMove(); }

    void ClickToMove()
    {
        
        //ClickOnMonster
        if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100)
            && hit.collider.CompareTag("enemy"))
        {
            enemyposition(hit);
        }
        //ClickOnTerrain
        else if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100, clickableLayers))
        {
            if (EventSystem.current.IsPointerOverGameObject())
            {
                Debug.Log("Klikniêto na elemencie UI!"); //nie usuwac lmao (jestem zajebiscie madry, przez brak return przycisk inv nie dzialal)
                return;
            }

            agent.destination = hit.point;

            if (lastHitOutline != null) // jesli dodasz kolejne else to zrob z tego voida do ka¿dej
            {lastHitOutline.enabled = false; lastHitOutline = null;}

            if (clickEffectObj != null)
            {
                //Instantiate(clickEffect, hit.point + new Vector3(0, 0.1f, 0), clickEffect.transform.rotation); //old
                Destroy(swap);
                swap = Instantiate(clickEffectObj, hit.point + new Vector3(0, 0.1f, 0), particletransform.rotation);

                //particletransform.position = agent.destination;   //DELETE COMMS IF U WANT
                //transpart.transform.position = agent.destination;
                //clickEffect.Play();
            }
        }
    }

    void OnEnable()
    { input.Enable(); }

    void OnDisable()
    { input.Disable(); }

    void Update()
    {
        FaceTarget();
        SetAnimations();
    }

    void FaceTarget()
    {
        if (agent.destination == transform.position) return;
        Vector3 facing = Vector3.zero;
        facing = agent.destination;

        Vector3 direction = (facing - transform.position).normalized;
        Quaternion lookRotation = Quaternion.LookRotation(new Vector3(direction.x, 0, direction.z));
        transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, Time.deltaTime * lookRotationSpeed);
    }

    void SetAnimations()
    {
        if (agent.velocity != Vector3.zero)
        {animator.SetBool("walk", true);}
        else
        {animator.SetBool("walk", false);}
    }
    void enemyposition(RaycastHit hit)
    { //func to check monster or ground
        agent.SetDestination(hit.point);
        enemyobject = hit.collider.gameObject;
        enemyoutline = enemyobject.GetComponent<Outline>();

        if (enemyoutline != null)
        {
            if (lastHitOutline != null) lastHitOutline.enabled = false;
            enemyoutline.enabled = true; //enemyoutline.OutlineMode = Outline.Mode.OutlineVisible;
            lastHitOutline = enemyoutline;
        }
    }
/*    void cancelOutline()
    {
        if (lastHitOutline != null)
        { lastHitOutline.enabled = false; lastHitOutline = null; }
    }*/



}