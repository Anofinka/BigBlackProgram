using UnityEngine;

public class CameraFollow : MonoBehaviour
{
    public Transform player;
    public Vector3 cameraOffset = new Vector3(0f, 2f, -5f);

    void Update()
    {
        if (player != null)
        {
            // Ustaw pozycjê kamery na pozycjê gracza plus przesuniêcie (cameraOffset)
            transform.position = player.position + cameraOffset;

            // Opcjonalnie: Ustaw kamery w górê, jeœli zawsze chcesz, aby patrzy³a w dó³
            // transform.LookAt(player.position);
        }
        else
        {
            Debug.LogWarning("Gracz nie zosta³ przypisany do kamery!");
        }
    }
}
