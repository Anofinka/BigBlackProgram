using UnityEngine;

public class playeractions : MonoBehaviour
{
    Animator anim;
    [SerializeField] private CapsuleCollider meleerangecolid;

    private void Awake()
    {
        meleerangecolid = GetComponent<CapsuleCollider>();
        anim = GetComponent<Animator>();
    }
    void Update()
    {
        attackmelee();
    }
    void attackmelee()
    {
        if (Input.GetKeyDown(KeyCode.R) && !anim.GetBool("walk"))
        { //attack animation
            anim.SetTrigger("attack");
        }
    }
    private void OnTriggerStay(Collider other)
    {
        if (Input.GetKeyDown(KeyCode.R) && !anim.GetBool("walk") && other.CompareTag("enemy"))
        {
            Debug.Log(other.name + " dosta³a bu³e");
            // Tu zaimplementuj funkcje do ataku melee (odejmowanie hp przeciwnikom)
        }
    }
}
