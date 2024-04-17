using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class PlayerController : MonoBehaviour
{
    CustomActions input;
    NavMeshAgent agent;
    Animator animator;
    Transform particletransform;

    [Header("Movement")]
    public GameObject clickEffectObj; // Zmiana typu na GameObject
    [SerializeField] LayerMask clickableLayers;
    GameObject clickEffectInstance; // Zmienna do przechowywania instancji efektu kliknięcia
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

    void Awake()
    {
        agent = GetComponent<NavMeshAgent>();
        animator = GetComponent<Animator>();
        // Pobierz komponent Transform bezpośrednio z clickEffectObj
        particletransform = clickEffectObj.transform;
        input = new CustomActions();
        AssignInputs();
        lastHitOutline = null;
    }

    void AssignInputs()
    {
        input.Main.Move.performed += ctx => ClickToMove();
    }

    void ClickToMove()
    {
        if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100) && hit.collider.CompareTag("enemy"))
        {
            enemyposition(hit);
        }
        else if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100, clickableLayers))
        {
            if (EventSystem.current.IsPointerOverGameObject())
            {
                Debug.Log("Kliknięto na elemencie UI!");
                return;
            }

            agent.destination = hit.point;

            if (clickEffectObj != null)
            {
                Destroy(clickEffectInstance);
                clickEffectInstance = Instantiate(clickEffectObj, hit.point + new Vector3(0, 0.1f, 0), particletransform.rotation);
            }
        }
    }

    void OnEnable()
    {
        input.Enable();
    }

    void OnDisable()
    {
        input.Disable();
    }

    void Update()
    {
        FaceTarget();
        SetAnimations();
        healthImage.fillAmount = SaveScript.playerHealth;
        mousepos();
        AttackEnemy();
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

    void enemyposition(RaycastHit hit)
    {
        agent.SetDestination(hit.point);
    }

    void AttackEnemy()
    {
        if (Input.GetKeyDown(KeyCode.R))
        {
            if (lastHitOutline != null && lastHitOutline.gameObject.CompareTag("enemy"))
            {
                float distanceToEnemy = Vector3.Distance(transform.position, lastHitOutline.gameObject.transform.position);

                if (distanceToEnemy <= attackRange)
                {
                    if (Time.time >= lastAttackTime + attackCooldown)
                    {
                        Debug.Log("Atakuję przeciwnika!");
                        // Tutaj możesz dodać kod ataku przeciwnika, np. odejmowanie punktów życia itp.
                       EnemyMove enemyMove = lastHitOutline.gameObject.GetComponent<EnemyMove>();
                   if (enemyMove != null) // Upewnij się, że komponent istnieje
                  {
                       enemyMove.enemyHealth -= damage;
                  }

                        lastAttackTime = Time.time;
                    }
                    else
                    {
                        Debug.Log("Czekam na odnowienie ataku...");
                    }
                }
                else
                {
                    Debug.Log("Jesteś zbyt daleko, aby zaatakować!");
                }
            }
            else
            {
                Debug.Log("Nie masz przeciwnika w zasięgu ataku!");
            }
        }
    }

    void mousepos()
    {
        if (Physics.Raycast(Camera.main.ScreenPointToRay(Input.mousePosition), out hit, 100) && hit.collider.CompareTag("enemy"))
        {
            enemyobject = hit.collider.gameObject;
            enemyoutline = enemyobject.GetComponent<Outline>();

            if (enemyoutline != null)
            {
                if (lastHitOutline != null && lastHitOutline != enemyoutline)
                {
                    lastHitOutline.enabled = false;
                }

                enemyoutline.enabled = true;
                lastHitOutline = enemyoutline;
            }
        }
        else
        {
            if (lastHitOutline != null)
            {
                lastHitOutline.enabled = false;
                lastHitOutline = null;
            }
        }
    }
}
