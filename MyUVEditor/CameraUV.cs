﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SlimDX;
using System.Drawing;

namespace MyUVEditor
{
    class CameraUV:Camera
    {
        public override Matrix World
        {
            get
            {
                return new Matrix
                {
                    M11 = 1,
                    M22 = -1,
                    M33 = 1,
                    M41 = -0.5f,
                    M42 = 0.5f,
                    M44 = 1
                };
            }
        }
        public CameraUV(DXView client):base(client,-1)
        {
            Position = new Vector3(0, 0, -10);
            Target = new Vector3(0, 0, 0);
            UpDir = new Vector3(0, 1, 0);
            Client = client;
            ResetWVPMatrix();
        }

        protected override void CameraRotate(Point prev, Point tmp)
        {
            CameraMove(prev, tmp);
        }


    }
}