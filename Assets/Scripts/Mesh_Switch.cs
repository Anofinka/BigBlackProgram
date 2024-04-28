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
        // Domyœlnie ustawiamy pierwszy mesh z alternatywnej listy
        
            
        
    }

    void Update()
    {
        // Jeœli wciœniêto klawisz "K"...
        if (Input.GetKeyDown(KeyCode.Space))
        {
            // Zmieniamy na kolejny mesh z listy alternatywnych mesheów
            
            SwitchMesh();
        }
    }

    // Funkcja zmieniaj¹ca aktualny mesh
    void SwitchMesh()
    {

        targetMesh.sharedMesh = alternateMeshes; // Zmieniamy koœci
        targetMesh2.sharedMesh = alternateMeshes2; // Zmieniamy koœci



    }
}
