using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform player;
    public Vector3 cameraOffset = new Vector3(0f, 2f, -5f);

    void Update()
    {
        if (player != null)
        {
            // Ustaw pozycj� kamery na pozycj� gracza plus przesuni�cie (cameraOffset)
            transform.position = player.position + cameraOffset;

            // Opcjonalnie: Ustaw kamery w g�r�, je�li zawsze chcesz, aby patrzy�a w d�
            // transform.LookAt(player.position);
        }
        else
        {
            Debug.LogWarning("Gracz nie zosta� przypisany do kamery!");
        }
    }
}
