using UnityEngine;

public class Arrow : MonoBehaviour
{
    public float speed = 20f; // Prędkość strzały

    private void Start()
    {
        Rigidbody rb = GetComponent<Rigidbody>();
        if (rb != null)
        {
            rb.useGravity = false; // Wyłączenie grawitacji
        }
        Invoke("DestroyArrow", 10); // Zniszczenie strzały po 10 sekundach
    }

    void Update()
    {
        // Przemieszczanie strzały w jej lokalnym kierunku do przodu
        transform.Translate(Vector3.forward * speed * Time.deltaTime);
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("Player"))
        {
            Debug.Log("Strzała trafiła gracza!"); // Informacja o trafieniu gracza
            Destroy(gameObject);
        }
        else if (other.CompareTag("Ground") || other.CompareTag("Untagged"))
        {
            Destroy(gameObject); // Zniszczenie strzały po trafieniu w ziemię lub obiekt bez tagu
        }
    }

    void DestroyArrow()
    {
        Destroy(gameObject);
    }
}
