using UnityEngine;

public class Player : MonoBehaviour
{
    public GameObject playerBullet; // Bullet prefab
    public Transform bulletPosition01; // First bullet spawn point
    public Transform bulletPosition02; // Second bullet spawn point
    public MovementJoystick movementJoystick; // Reference to the joystick
    public float playerSpeed; // Player movement speed
    public GameObject Explosion;

    private Rigidbody2D rb; // Reference to Rigidbody2D

    void Start()
    {
        rb = GetComponent<Rigidbody2D>(); // Initialize Rigidbody2D
    }

    void Update()
    {
        
    }
    public void ShootButton()
    {
            // Instantiate the first bullet at bulletPosition01
            GameObject bullet01 = Instantiate(playerBullet);
            bullet01.transform.position = bulletPosition01.position;

            // Instantiate the second bullet at bulletPosition02
            GameObject bullet02 = Instantiate(playerBullet);
            bullet02.transform.position = bulletPosition02.position;
        }

    void FixedUpdate()
    {
        if (movementJoystick != null && movementJoystick.joystickVec != Vector2.zero)
        {
            // Apply velocity based on joystick vector and player speed
            rb.linearVelocity = new Vector2(
                movementJoystick.joystickVec.x * playerSpeed, 
                movementJoystick.joystickVec.y * playerSpeed
            );
        }
        else
        {
            // Stop the Rigidbody2D if joystick is idle
            rb.linearVelocity = Vector2.zero;
        }
    }
    void OnTriggerEnter2D(Collider2D col)
    {
        if((col.tag == "EnemyShipTag") || (col.tag == "EnemyBulletTag"))
        {
            Destroy(gameObject);
        }
    }
}
