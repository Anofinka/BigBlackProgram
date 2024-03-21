using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.AI;
using static UnityEngine.GraphicsBuffer;
using System.Net.NetworkInformation;
using Unity.VisualScripting;
using UnityEngine.EventSystems;

public class PlayerController : MonoBehaviour
{
    const string IDLE = "Idle";
    const string WALK = "Walk";

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
    {
        input.Main.Move.performed += ctx => ClickToMove();
    }

    void ClickToMove()
    {
        RaycastHit hit;
        if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100, clickableLayers))
        {


            if (EventSystem.current.IsPointerOverGameObject())
            {
                Debug.Log("Klikniêto na elemencie UI!");
                return;
            }

            agent.destination = hit.point;
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
        if (agent.velocity == Vector3.zero)
        { animator.Play(IDLE); }
        else
        { animator.Play(WALK); }
    }
}