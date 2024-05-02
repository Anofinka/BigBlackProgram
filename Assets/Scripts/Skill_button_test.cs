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
        // SprawdŸ, czy klawisz T zosta³ wciœniêty
        if (Input.GetKeyDown(KeyCode.T))
        {
            // Wywo³aj metodê obs³uguj¹c¹ klikniêcie przycisku
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
