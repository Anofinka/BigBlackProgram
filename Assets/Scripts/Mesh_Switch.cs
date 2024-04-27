using UnityEngine;

public class MeshSwitcher : MonoBehaviour
{
    public SkinnedMeshRenderer targetMesh; 
    public SkinnedMeshRenderer alternateMeshes; 

  

    void Start()
    {
        // Domy�lnie ustawiamy pierwszy mesh z alternatywnej listy
        
            
        
    }

    void Update()
    {
        // Je�li wci�ni�to klawisz "K"...
        if (Input.GetKeyDown(KeyCode.K))
        {
            // Zmieniamy na kolejny mesh z listy alternatywnych meshe�w
            
            SwitchMesh();
        }
    }

    // Funkcja zmieniaj�ca aktualny mesh
    void SwitchMesh()
    {
       
        targetMesh.bones = alternateMeshes.bones; // Zmieniamy ko�ci
        targetMesh.rootBone = alternateMeshes.rootBone; // Zmieniamy ko�� g��wn�
      
    }
}
