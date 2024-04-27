using UnityEngine;

public class EquipmentManager : MonoBehaviour
{
    public GameObject newItem;
    public GameObject targetObject; // Obiekt, którego mesh bêdzie zmieniany
    public SkinnedMeshRenderer targetMesh; // SkinnedMeshRenderer obiektu, którego mesh bêdzie zmieniany

    void Update()
    {
        // Sprawdzamy, czy zosta³ naciœniêty klawisz K
        if (Input.GetKeyDown(KeyCode.K))
        {
            ChangeEquipment();
        }
    }

    void ChangeEquipment()
    {
        if (newItem != null)
        {
            SkinnedMeshRenderer newItemMesh = newItem.GetComponent<SkinnedMeshRenderer>();
            if (newItemMesh != null)
            {
                if (targetMesh != null)
                {
                    // Assign the new mesh and bones to the SkinnedMeshRenderer of the target mesh
                    targetMesh.sharedMesh = newItemMesh.sharedMesh;
                    targetMesh.bones = newItemMesh.bones;
                    targetMesh.rootBone = newItemMesh.rootBone;
                }
                else
                {
                    Debug.LogError("Target mesh is not assigned.");
                }
            }
            else
            {
                Debug.LogError("New item does not have a SkinnedMeshRenderer component.");
            }
        }
        else
        {
            Debug.LogError("New item is not assigned.");
        }
    }


}
