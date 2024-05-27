using System.Collections;
using System.Collections.Generic;
using TMPro;
using System;
using UnityEngine;

public class TipMenager : MonoBehaviour
{
    public TextMeshProUGUI tipText;
    public RectTransform tipWindow;
    public static Action<string, Vector2> OnMouseHover;
    public static Action OnMouseLoseFocus;

    // Padding values
    public Vector2 padding = new Vector2(10, 10);

    private void OnEnable()
    {
        OnMouseHover += ShowTip;
        OnMouseLoseFocus += HideTip;
    }

    private void OnDisable()
    {
        OnMouseHover -= ShowTip;
        OnMouseLoseFocus -= HideTip;
    }

    void Start()
    {
        HideTip();
    }

    private void ShowTip(string tip, Vector2 mousePos)
    {
        // Zmniejszenie rozmiaru czcionki
        tipText.fontSize = 14;

        tipText.text = tip;

        // Ustalenie rozmiaru tipWindow z paddingiem
        float width = tipText.preferredWidth + padding.x * 2;
        float height = tipText.preferredHeight + padding.y * 2;
        tipWindow.sizeDelta = new Vector2(width > 200 ? 200 : width, height);

        tipWindow.gameObject.SetActive(true);

        // Calculate desired position
        Vector2 newPosition = new Vector2(mousePos.x + tipWindow.sizeDelta.x + 50, mousePos.y);

        // Get screen bounds
        float screenWidth = Screen.width;
        float screenHeight = Screen.height;

        // Ensure the tooltip does not go off the right edge
        if (newPosition.x + tipWindow.sizeDelta.x > screenWidth)
        {
            newPosition.x = screenWidth - tipWindow.sizeDelta.x;
        }

        // Ensure the tooltip does not go off the left edge
        if (newPosition.x < 0)
        {
            newPosition.x = 0;
        }

        // Ensure the tooltip does not go off the top edge
        if (newPosition.y + tipWindow.sizeDelta.y > screenHeight)
        {
            newPosition.y = screenHeight - tipWindow.sizeDelta.y;
        }

        // Ensure the tooltip does not go off the bottom edge
        if (newPosition.y < 0)
        {
            newPosition.y = 0;
        }

        tipWindow.transform.position = newPosition;
    }

    private void HideTip()
    {
        tipText.text = default;
        tipWindow.gameObject.SetActive(false);
    }
}
