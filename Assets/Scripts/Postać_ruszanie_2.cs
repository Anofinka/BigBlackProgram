using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System.Collections;

public class Postać_ruszanie_2 : MonoBehaviour
{
    NavMeshAgent agent;
    Animator animator;
    Transform particletransform;

    [Header("Movement")]
    public GameObject clickEffectObj;
    [SerializeField] LayerMask clickableLayers;
    GameObject clickEffectInstance;
    Object swap;
    float lookRotationSpeed = 8f;
    RaycastHit hit;

    GameObject enemyobject;
    Outline enemyoutline;
    Outline lastHitOutline;

    public Image healthImage;

    float attackRange = 2f;
    float lastAttackTime = 0f;
    float attackCooldown = 1f;
    public int damage = 10;
    public bool Life = true;
    public int playerHealth = 10;
    private int maxHealth;

    //zmienna damagebuff
    bool damageBuffActive = false;
    public AudioClip buffAudioSource;
    bool isBuffCooldown = false;
    float buffCooldownTime = 8f;
    public AudioClip deathSound;
    public AudioClip healSound;

    [Header("Healing")]
    public float healingAmount = 0.2f;
    public float healingCooldown = 5f;
    private float lastHealTime = 0f;
    public ParticleSystem healEffect;
    public ParticleSystem buffEffect;
    public ParticleSystem DushEffect;



    public float gravityMultiplier = 2;
    [HideInInspector]
    public float gravityValue = -9.81f;


    [Header("Dush")]
    public float dushaRange = 10f; // maksymalny zasięg umiejętności "Dusha"
    public LineRenderer dushaRangeIndicator; // obiekt wizualizacji zasięgu umiejętności "Dusha"
    float lastDushaTime = 0f;

    bool isDushaCooldown = false;
    float dushaCooldownTime = 1f; // czas odliczania po użyciu umiejętności

    void Start()
    {
        if (healEffect != null)
        {
            healEffect.Stop();
        }
        if (buffEffect != null)
        {
            buffEffect.Stop();
        }
        if (DushEffect != null)
        {
            DushEffect.Stop();

        }
        gravityValue *= gravityMultiplier;
        // Inicjalizacja wizualizacji zasięgu umiejętności "Dusha"
        dushaRangeIndicator.positionCount = 2;
        dushaRangeIndicator.startWidth = 0.1f;
        dushaRangeIndicator.endWidth = 0.1f;
        dushaRangeIndicator.enabled = false; // wyłącz początkowo wizualizację
    }

    void Awake()
    {
        agent = GetComponent<NavMeshAgent>();
        animator = GetComponent<Animator>();
        particletransform = clickEffectObj.transform;
        lastHitOutline = null;
    }

    void Update()
    {
       

        if (Input.GetMouseButtonDown(0) && !EventSystem.current.IsPointerOverGameObject())
        {
            ClickToMove();
        }

        FaceTarget();
        SetAnimations();
       
    }

    void ClickToMove()
    {
        if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100, clickableLayers))
        {
            agent.destination = hit.point;

            if (clickEffectObj != null)
            {
                Destroy(clickEffectInstance);
                clickEffectInstance = Instantiate(clickEffectObj, hit.point + new Vector3(0, 0.1f, 0), particletransform.rotation);
            }
        }
    }

    void FaceTarget()
    {
        if (agent.destination == transform.position) return;

        Vector3 direction = (agent.destination - transform.position).normalized;
        Quaternion lookRotation = Quaternion.LookRotation(new Vector3(direction.x, 0, direction.z));
        transform.rotation = Quaternion.Slerp(transform.rotation, lookRotation, Time.deltaTime * lookRotationSpeed);
    }

    void SetAnimations()
    {
        if (agent.velocity != Vector3.zero)
        {
            animator.SetBool("walk", true);
        }
        else
        {
            animator.SetBool("walk", false);
        }
    }

   
 
    
}
