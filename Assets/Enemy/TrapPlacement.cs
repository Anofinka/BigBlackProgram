using UnityEngine;

public class Trap : MonoBehaviour
{
    public GameObject trapPrefab; // Prefabrykat pułapki
    public LayerMask groundLayer; // Warstwa mapy na której mogą być stawiane pułapki

    public float cooldownDuration = 5f; // Czas cooldownu w sekundach
    private float cooldownTimer = 0f; // Licznik czasu cooldownu

    public float trapLifetime = 3f; // Czas życia pułapki w sekundach

    bool isTrapPlacementActive = false; // Flaga wskazująca, czy aktywowano umiejętność stawiania pułapek

    void Update()
    {
        // Aktywowanie umiejętności po naciśnięciu przycisku 3
        if (Input.GetKeyDown(KeyCode.Alpha3))
        {
            if (!isTrapPlacementActive && cooldownTimer <= 0f) // Sprawdzenie czy umiejętność jest gotowa do użycia (poza cooldownem)
            {
                isTrapPlacementActive = true; // Aktywacja umiejętności
                Debug.Log("Trap placement activated");
            }
            else if (cooldownTimer > 0f)
            {
                Debug.Log("Cooldown in progress. Wait " + cooldownTimer.ToString("F1") + " seconds.");
            }
        }

        // Odliczanie czasu cooldownu
        if (cooldownTimer > 0f)
        {
            cooldownTimer -= Time.deltaTime; // Odliczanie czasu od ostatniej klatki

            if (cooldownTimer <= 0f)
            {
                isTrapPlacementActive = false; // Dezaktywacja umiejętności po zakończeniu cooldownu
            }
        }

        // Stawianie pułapki po aktywowaniu umiejętności i kliknięciu myszką
        if (isTrapPlacementActive && Input.GetMouseButtonDown(0))
        {
            // Tworzenie promienia od kamery w miejscu kliknięcia myszką
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            RaycastHit hit;

            // Sprawdzenie czy promień uderzył w podłoże
            if (Physics.Raycast(ray, out hit, Mathf.Infinity, groundLayer))
            {
                // Pobieranie pozycji kliknięcia myszką
                Vector3 trapPosition = hit.point;

                // Tworzenie pułapki na pozycji kliknięcia myszką
                GameObject trap = Instantiate(trapPrefab, trapPosition, Quaternion.identity);

                // Usunięcie pułapki po określonym czasie
                Destroy(trap, trapLifetime);

                // Dezaktywacja umiejętności po postawieniu pułapki
                isTrapPlacementActive = false;

                // Resetowanie licznika czasu cooldownu
                cooldownTimer = cooldownDuration;
            }
        }
    }
}
