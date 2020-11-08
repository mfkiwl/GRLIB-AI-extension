# NanoXPython script for synthesis,place,route and generation of bitstream
import os
import sys
from os import path
from nxmap import *
dir = os.path.dirname(os.path.realpath(__file__))
sys.path.append(dir)
project=createProject(dir)
project.load('leon3mp_native.nym')
if not project.synthesize():
    sys.exit(1)
project.save('leon3mp_synthesized.nym')

if not project.place():
    sys.exit(1)
project.save('leon3mp_placed.nym')

if not path.exists(dir + '/leon3mp_pads.py'):
    project.savePorts('leon3mp_generated_pads.py')

if not project.route():
    sys.exit(1)
project.save('leon3mp_routed.nym')

#Reports
project.reportInstances()

#Analyzer
analyzer = project.createAnalyzer()
analyzer.launch()

#Generate Bitstream
project.generateBitstream('leon3mp_bitfile.nxb')

project.destroy()
