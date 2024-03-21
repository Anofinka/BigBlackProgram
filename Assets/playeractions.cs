using UnityEngine;

public class playeractions : MonoBehaviour
{
    Animator anim;
 
    [Header("Narazie nie dziala vvv")]
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
        if (Input.GetKeyDown(KeyCode.E) && !anim.GetBool("walk"))
        {
            
            Debug.Log("attack");
            anim.SetTrigger("attack");

        }

/*        if (meleerangecolid.gameObject.CompareTag("enemy"))
        {
            Debug.Log("gotcha");
        }*/
    }

/*    private void OnTriggerStay(Collider other)
    {
        
    }*/

}
