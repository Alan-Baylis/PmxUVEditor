﻿using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using PEPlugin;
using PEPlugin.Pmx;
using PMXImporter;
using PluginDummyStarter;
using MyUVEditor;

namespace Starter
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        public void Run()
        {
            IPXPmx miku = new PMXImporter.PMX.ImpPmx();
            miku.FromFile(
@"C:\Documents and Settings\User\My Documents\MMD\MikuMikuDance_v707\UserFile\Model\あにまさもでる\初音ミクVer2.pmx");
            IPERunArgs runArgs = new DummyIPERunArgs();
            runArgs.Host.Connector.Pmx.Update(miku);

            MyPlugin plugin = new MyPlugin();
            plugin.Run(runArgs);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            openFileDialog1.ShowDialog();
        }

        private void openFileDialog1_FileOk(object sender, CancelEventArgs e)
        {
            IPXPmx pmx = new PMXImporter.PMX.ImpPmx();
            pmx.FromFile(((OpenFileDialog)sender).FileName);
            IPERunArgs runArgs = new DummyIPERunArgs();
            runArgs.Host.Connector.Pmx.Update(pmx);
            MyPlugin plugin = new MyPlugin();
            plugin.Run(runArgs);
        }
    }
}
