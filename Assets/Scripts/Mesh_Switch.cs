using UnityEditor.Rendering;
using UnityEngine;

public class MeshSwitcher : MonoBehaviour
{
    public SkinnedMeshRenderer targetMesh;
    public SkinnedMeshRenderer targetMesh2;
    [SerializeField] Mesh alternateMeshes;
    [SerializeField] Mesh alternateMeshes2;

    private void Awake()
    {
        
    }

    void Start()
    {
        // Domy�lnie ustawiamy pierwszy mesh z alternatywnej listy
        
            
        
    }

    void Update()
    {
        // Je�li wci�ni�to klawisz "K"...
        if (Input.GetKeyDown(KeyCode.Space))
        {
            // Zmieniamy na kolejny mesh z listy alternatywnych meshe�w
            
            SwitchMesh();
        }
    }

    // Funkcja zmieniaj�ca aktualny mesh
    void SwitchMesh()
    {

        targetMesh.sharedMesh = alternateMeshes; // Zmieniamy ko�ci
        targetMesh2.sharedMesh = alternateMeshes2; // Zmieniamy ko�ci



    }
}
