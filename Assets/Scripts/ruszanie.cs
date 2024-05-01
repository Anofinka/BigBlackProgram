using UnityEngine;
using UnityEngine.AI;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System.Collections;

public class PlayerController : MonoBehaviour
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
        if (Input.GetKeyDown(KeyCode.Alpha4) && !isBuffCooldown)
        {
            ActivateDamageBuff();
            StartCoroutine(StartBuffCooldown());
        }

        if (SaveScript.playerHealth <= 0 && Life == true)
        {
            Life = false;
            agent.isStopped = true;
            animator.SetTrigger("die");
            AudioSource.PlayClipAtPoint(deathSound, transform.position);
            agent.avoidancePriority = 1;
        }

        if (Input.GetMouseButtonDown(0) && !EventSystem.current.IsPointerOverGameObject())
        {
            ClickToMove();
        }

        FaceTarget();
        SetAnimations();
        healthImage.fillAmount = SaveScript.playerHealth;
        mousepos();

        if (Input.GetMouseButtonDown(1))
        {
            Attack();
        }

        if (Input.GetKeyDown(KeyCode.Q))
        {
            Heal();
        }

        if (Input.GetKeyDown(KeyCode.Alpha5) && !isDushaCooldown)
        {
            if (!EventSystem.current.IsPointerOverGameObject())
            {
                ToggleDushaRangeIndicator(true);
                SelectDestination();
            }
        }
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

    void Attack()
    {
        if (lastHitOutline != null && lastHitOutline.gameObject.CompareTag("enemy"))
        {
            float distanceToEnemy = Vector3.Distance(transform.position, lastHitOutline.gameObject.transform.position);

            if (distanceToEnemy <= attackRange)
            {
                if (Time.time >= lastAttackTime + attackCooldown)
                {
                    if (!animator.GetCurrentAnimatorStateInfo(0).IsName("Attack"))
                    {
                        animator.SetTrigger("attack");
                        Debug.Log("Atakuję przeciwnika!");
                        int totalDamage = damage;
                        if (damageBuffActive)
                        {
                            Debug.Log("Uderzyłeś razy 2");
                            totalDamage *= 8; // Podwójne obrażenia, jeśli umiejętność jest aktywna
                        }
                        TakeDamage(lastHitOutline.gameObject, totalDamage);
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

    void TakeDamage(GameObject enemy, int damage)
    {
        EnemyMove enemyMove = enemy.GetComponent<EnemyMove>();
        if (enemyMove != null)
        {
            enemyMove.TakeDamageFromPlayer(damage);
        }
        else
        {
            // Jeśli nie można znaleźć skryptu EnemyMove na wrogu, po prostu odejmij zdrowie gracza
            SaveScript.playerHealth -= damage;
            // Wywołaj animację obrażeń gracza
            animator.SetTrigger("hit");
            Debug.Log("Wywołano animacje");
        }
    }

    void Heal()
    {
        if (Time.time >= lastHealTime + healingCooldown)
        {
            SaveScript.playerHealth += healingAmount;
            if (SaveScript.playerHealth > SaveScript.playerMaxHealth)
            {
                SaveScript.playerHealth = SaveScript.playerMaxHealth;
            }
            Debug.Log("Leczenie!");
            lastHealTime = Time.time;
            if (healEffect != null)
            {
                healEffect.Play();
                AudioSource.PlayClipAtPoint(healSound, transform.position);
                healEffect.gameObject.SetActive(true);
                Debug.Log("Wykonano participle");
                // Odczekaj pewien czas, zanim wyłączysz efekt
                StartCoroutine(StopHealEffect());
            }
        }
        else
        {
            Debug.Log("Czekam na odnowienie leczenia...");
        }
    }

    IEnumerator StopHealEffect()
    {
        //heal effect
        // Poczekaj, aż efekt zakończy się
        yield return new WaitForSeconds(2f);
        // Wyłącz efekt
        healEffect.Stop();
        healEffect.gameObject.SetActive(false);
    }
    //buff effect
    IEnumerator StopBuffEffect()
    {
        // Poczekaj, aż efekt zakończy się
        yield return new WaitForSeconds(5f);
        // Wyłącz efekt
        buffEffect.Stop();
        buffEffect.gameObject.SetActive(false);
    }
    //buff effect activate

    IEnumerator StopDushEffect()
    {
        //heal effect
        // Poczekaj, aż efekt zakończy się
        yield return new WaitForSeconds(1f);
        // Wyłącz efekt
        DushEffect.Stop();
        DushEffect.gameObject.SetActive(false);
    }
    void ActivateDamageBuff()
    {
        animator.SetTrigger("buff");
        buffEffect.Play();
        buffEffect.gameObject.SetActive(true);
        StartCoroutine(DamageBuffTimer());
    }


    IEnumerator DamageBuffTimer()
    {
        AudioSource.PlayClipAtPoint(buffAudioSource, transform.position);
        damageBuffActive = true;
        agent.isStopped = true;
        yield return new WaitForSeconds(1.5f);
        agent.isStopped = false;
        yield return new WaitForSeconds(5f);
        StartCoroutine(StopBuffEffect());
        damageBuffActive = false;
    }

    IEnumerator StartBuffCooldown()
    {
        isBuffCooldown = true;
        yield return new WaitForSeconds(buffCooldownTime);
        isBuffCooldown = false;
    }

    void ToggleDushaRangeIndicator(bool state)
    {
        // Włącz lub wyłącz wizualizację zasięgu umiejętności "Dusha"
        dushaRangeIndicator.enabled = state;
    }

    void UpdateDushaRangeIndicator(Vector3 mousePosition)
    {
        // Aktualizacja wizualizacji zasięgu umiejętności "Dusha" w miejscu, w którym znajduje się myszka
        Ray ray = Camera.main.ScreenPointToRay(mousePosition);
        if (Physics.Raycast(ray, out hit, 100))
        {
            Vector3 targetPosition = hit.point;
            dushaRangeIndicator.SetPosition(0, transform.position);
            dushaRangeIndicator.SetPosition(1, targetPosition);
        }
    }

    void LateUpdate()
    {
        // Aktualizacja wizualizacji zasięgu umiejętności "Dusha" w czasie rzeczywistym, gdy gracz przesuwa myszkę
        if (isDushaCooldown)
        {
            ToggleDushaRangeIndicator(false);
        }
        else if (Input.GetKey(KeyCode.Alpha5))
        {
            UpdateDushaRangeIndicator(Input.mousePosition);

        }
    }

    void SelectDestination()
    {
        Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
        if (Physics.Raycast(ray, out hit, 100, clickableLayers))
        {
            Vector3 targetPosition = hit.point;
            if (IsWithinDushaRange(targetPosition))
            {
                TeleportTo(targetPosition);
            }
            else
            {
                Debug.Log("Wybrane miejsce jest poza zasięgiem umiejętności Dusha.");
                ToggleDushaRangeIndicator(false); // Wyłącz wizualizację zasięgu umiejętności "Dusha"
            }
        }
    }


    bool IsWithinDushaRange(Vector3 destination)
    {
        // Oblicz odległość pomiędzy graczem a miejscem docelowym
        float distance = Vector3.Distance(transform.position, destination);
        // Sprawdź, czy odległość jest mniejsza niż maksymalny zasięg umiejętności "Dusha"
        return distance <= dushaRange;
    }

    void TeleportTo(Vector3 destination)
    {
        if (Time.time >= lastDushaTime + dushaCooldownTime)
        {
            lastDushaTime = Time.time; // Przesuń to tutaj, aby zaktualizować czas tylko wtedy, gdy umiejętność jest faktycznie używana
            agent.Warp(destination);
            isDushaCooldown = true;

            // Aktywacja efektu cząsteczkowego dla "Dush"
            DushEffect.Play();
            DushEffect.gameObject.SetActive(true);
            StartCoroutine(StartDushaCooldown());
        }
        else
        {
            Debug.Log("Umiejętność Dusha jest jeszcze niedostępna. Poczekaj na cooldown.");
        }
    }

    IEnumerator StartDushaCooldown()
    {
        // Aktywacja efektu cząsteczkowego dla "Dush"
        DushEffect.Play();
        DushEffect.gameObject.SetActive(true);

        // Odczekaj przez określony czas cooldownu
        yield return new WaitForSeconds(dushaCooldownTime);

        // Dezaktywuj efekt "Dusha"
        DushEffect.Stop();
        DushEffect.gameObject.SetActive(false);

        // Zresetuj flagę cooldownu
        isDushaCooldown = false;

        // Loguj, że umiejętność "Dusha" jest ponownie dostępna
        Debug.Log("Umiejętność Dusha jest ponownie dostępna.");
    }
}
