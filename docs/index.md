## Welcome

<img width="468" alt="image" src="https://user-images.githubusercontent.com/75865953/166865752-c4924ca0-913b-4bd9-9383-e20225a07192.png">

The Lab Upgrade Point Absorber (LUPA) is a state of the art open-sourced laboratory-scaled wave energy converter (WEC). The objective of the LUPA project is to develop a completely open source, fully validated, numerical and physical WEC model. 

Whats new?
Check out our new videos on dry testing in the O.H. Hinsdale Wave Research Laboratory!
Helpful Links
PMEC Overview
- https://www.pmec.us/testing
- Highlights LUPA among other testing capabilities supported by the Pacific Marine Energy Center
GitHub Repository
- https://github.com/PMEC-OSU/LUPA
- The GitHub repository is a place to view and download code related to the LUPA user interface, data acquisition, data processing, and WEC-Sim input files. It also includes contributions from collaborators utilizing LUPA.
CAD Models
- https://zenodo.org/
- The detailed CAD models and bill of materials for LUPA can be found on Zenodo.
Data
- https://mhkdr.openei.org/
- The Marine Hydrokinetic Data Repository hosts a collection of experimental data from LUPA.
Videos
- https://vimeo.com/user164791676
- Videos of LUPA tests are housed here on Vimeo.

Publications/Presentations
Publications

Presentations
- WPTO R&D Deep Dive on march 22nd, 2022
- https://youtu.be/gCcAu7H9lQI
FAQs
1.	How can I test with LUPA?
a.	LUPA is housed at the O.H. Hinsdale Wave Research Laboratory, contact the Director to coordinate availability. Funding to test with LUPA could be obtained through TEAMER funding.
2.	

Documentation
The Lab Upgrade Point Absorber (LUPA) is a state of the art open-sourced laboratory-scaled wave energy converter (WEC). The objective of the LUPA project is to develop a completely open source, fully validated, numerical and physical WEC model. LUPA provides a platform for validation of hydrodynamic models, control systems, power take-off (PTO) designs, mooring designs, and hull and heave plate geometries. As a modular WEC system, LUPA allows for incremental system dynamics complexity, rapid dissemination of R&D findings without IP concerns, and a well characterized and understood platform for consistent and accelerated R&D. LUPA can operate as a one-body, two-body (heave only), and a three-body 6 degrees of freedom system. The LUPA Repository is a place to view and download code related to the LUPA user interface, data acquisition, data processing, and WEC-Sim input files. It also includes contributions from collaborators utilizing LUPA.

Developers
LUPA was developed at Oregon State University through the Pacific Marine Energy Center. It is funded through the Department of Energy. Due to the open source nature of LUPA there are many external contributions. For more information refer to Acknowledgements.

Development Team:
- Bret Bosma
- Courtney Beringer
- Bryson Robertson
- Brian Jensen
- Darin Kempton
- Ben Russel
- Pedro Lomonaco
- Ted Brekken
- Solomon Yim
- Matt Leary


Introduction
Overview
LUPA is an open-source scaled WEC for experimental testing. It is fundamentally a two-body heaving point absorber, the two main bodies being the toroidal float and the central cylindrical spar. LUPA was designed for deployment in the Large Wave Flume at the O.H. Hinsdale Wave Research Laboratory at Oregon State University. It is a model scale based off of the water depths at PacWave North and South test sites located off the coast of Newport, Oregon, USA. Based on Froude scaling, the scale factors for North and South sites are 20 and 25, respectively.

The user interface and data acquisition are developed in MATLAB/SIMULINK. Open-source WEC-Sim numerical models of LUPA are provided in the GitHub repository and the data from these simulations are available on MHKDR. LUPA can operate as a one-body (heave only), two-body (heave only), and a two-body six degrees of freedom system. Physical specifications are shown in the table below.
