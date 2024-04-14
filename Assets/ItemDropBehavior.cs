using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ItemDropBehavior : MonoBehaviour
{
    [SerializeField] private float _rotationSpeed = 20f;

    void Update()
    {
        // Rotate around the global Y axis at constant speed
        transform.Rotate(Vector3.up, _rotationSpeed * Time.deltaTime, Space.World);
    }
}
