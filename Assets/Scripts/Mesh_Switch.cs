using UnityEngine;

public class MeshSwitcher : MonoBehaviour
{
    public SkinnedMeshRenderer targetMesh; 
    public SkinnedMeshRenderer alternateMeshes; 

  

    void Start()
    {
        // Domyœlnie ustawiamy pierwszy mesh z alternatywnej listy
        
            
        
    }

    void Update()
    {
        // Jeœli wciœniêto klawisz "K"...
        if (Input.GetKeyDown(KeyCode.K))
        {
            // Zmieniamy na kolejny mesh z listy alternatywnych mesheów
            
            SwitchMesh();
        }
    }

    // Funkcja zmieniaj¹ca aktualny mesh
    void SwitchMesh()
    {
       
        targetMesh.bones = alternateMeshes.bones; // Zmieniamy koœci
        targetMesh.rootBone = alternateMeshes.rootBone; // Zmieniamy koœæ g³ówn¹
      
    }
}
