using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace DigitalRubyShared
{
    public class DemoScriptLagTest : MonoBehaviour
    {
        private Vector2 offset;

        private void CheckOffset(Vector2 pos)
        {
            offset = pos - (Vector2)transform.position;
        }

        private void Update()
        {
            if (Input.mousePresent)
            {
                if (Input.GetMouseButtonDown(0))
                {
                    CheckOffset(Input.mousePosition);
                }
                else if (Input.GetMouseButton(0))
                {
                    transform.position = (Vector2)Input.mousePosition - offset;
                }
                else
                {
                    offset = Vector2.zero;
                }
            }
            else if (Input.touchCount > 0)
            {
                Touch touch = Input.GetTouch(0);
                if (touch.phase == UnityEngine.TouchPhase.Began)
                {
                    CheckOffset(touch.position);
                }
                transform.position = touch.position - offset;
            }
            else
            {
                offset = Vector2.zero;
            }
        }
    }
}
