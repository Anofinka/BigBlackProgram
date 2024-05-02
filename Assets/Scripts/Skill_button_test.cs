using UnityEngine;
using UnityEngine.UI;

public class YourButtonScript : MonoBehaviour
{
    public RotateTowardsMouse rotationScript;
    private Button button;

    void Start()
    {
        button = GetComponent<Button>();
        button.onClick.AddListener(HandleButtonClick);
    }

    void Update()
    {
        // Sprawd�, czy klawisz T zosta� wci�ni�ty
        if (Input.GetKeyDown(KeyCode.T))
        {
            // Wywo�aj metod� obs�uguj�c� klikni�cie przycisku
            button.onClick.Invoke();
        }
    }

    void HandleButtonClick()
    {
        if (!rotationScript.isCrushAttackActive)
        {
            rotationScript.StartCrushAttack();
        }
    }
}
