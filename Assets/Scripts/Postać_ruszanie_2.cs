using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class Postać_ruszanie_2 : MonoBehaviour
{
    NavMeshAgent agent;
    Animator animator;
    Transform particletransform;
    public Test_2 test;

    [Header("Movement")]
    public GameObject clickEffectObj;
    [SerializeField] LayerMask clickableLayers;
    GameObject clickEffectInstance;

    float lookRotationSpeed = 8f;
    RaycastHit hit;

    public Image healthImage;

    public int damage = 10;
    public bool Life = true;
    public int playerHealth = 10;

    public float gravityMultiplier = 2;
    [HideInInspector]
    public float gravityValue = -9.81f;

    void Start()
    {
        gravityValue *= gravityMultiplier;
        // Inicjalizacja wizualizacji zasięgu umiejętności "Dusha"
    }

    void Awake()
    {
        agent = GetComponent<NavMeshAgent>();
        animator = GetComponent<Animator>();
        particletransform = clickEffectObj.transform;
    }

    void Update()
    {
        if (!EventSystem.current.IsPointerOverGameObject() && test.IsSpellOver)
        {
            if (Input.GetMouseButton(0)) // Zamiast GetMouseButtonDown użyj GetMouseButton, aby kontynuować podczas trzymania przycisku.
            {
                ContinuousMove();
            }
        }

        FaceTarget();
        SetAnimations();
    }

    void ContinuousMove()
    {
        if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100, clickableLayers))
        {
            agent.destination = hit.point;

            if (clickEffectObj != null && (clickEffectInstance == null || clickEffectInstance.transform.position != hit.point))
            {
                Destroy(clickEffectInstance);
                clickEffectInstance = Instantiate(clickEffectObj, hit.point + new Vector3(0, 0.1f, 0), particletransform.rotation);
            }
        }
    }

    void FaceTarget()
    {
        if (agent.pathPending || agent.remainingDistance <= agent.stoppingDistance) return;

        Vector3 direction = (agent.destination - transform.position).normalized;
        Quaternion lookRotation = Quaternion.LookRotation(new Vector3(direction.x, 0, direction.z));
        transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, Time.deltaTime * lookRotationSpeed);
    }

    void SetAnimations()
    {
        if (agent.velocity.sqrMagnitude > 0.1f) // Użyj sqrMagnitude dla wydajności
        {
            animator.SetBool("walk", true);
        }
        else
        {
            animator.SetBool("walk", false);
        }
    }
}
