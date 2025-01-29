using UnityEngine;

public class PlayerBullet : MonoBehaviour
{
    float speed;

    void Start()
    {
        speed = 8f; // Set the speed of the bullet
    }

    void Update()
    {
        // Get the current position of the bullet
        Vector2 position = transform.position;

        // Update the position of the bullet to move upward
        position = new Vector2(position.x, position.y + speed * Time.deltaTime);

        // Apply the updated position to the transform
        transform.position = position;

        // Get the maximum Y position of the camera's viewport
        Vector2 max = Camera.main.ViewportToWorldPoint(new Vector2(1, 1));

        // Destroy the bullet if it goes out of the screen
        if (transform.position.y > max.y)
        {
            Destroy(gameObject);
        }
    }
    void OnTriggerEnter2D(Collider2D col)
    {
        if(col.tag == "EnemyShipTag")
        {
            Destroy(gameObject);
        }
    }
}
