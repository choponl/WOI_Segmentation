# WOI_Segmentation
This repository accompanies the paper Ensemble Machine Learning Approach to Automated Segmentation of Widefield Optical Imaging Data Using Spectral and Temporal Information and provides the data, network files, and code used to develop and test the proposed automatic segmentation method.

## Abstract
Significance: Manual segmentation is a rate-limiting and variable step in the preprocessing of widefield optical imaging (WOI). Current machine learning techniques risk poor generalizability. A robust, minimally supervised method that leverages spectral and temporal components could reduce unintended variation.

Aim: After evaluating the external generalizability of existing pipelines, we developed and tested a novel model integrating multi-wavelength and temporal information to improve segmentation.

Approach: We assessed a single-image U-Net pipeline on a multi-institutional dataset, comparing automated outputs to a manual gold standard. We then designed an ensemble approach which utilizes: (1) independent models per illumination wavelength; (2) temporal dynamics and baseline intensity; (3) atlas-based registration; and (4) probabilistic consensus across wavelengths.

Results: External testing showed single-frame segmentation achieved reasonable but insufficient agreement for unsupervised preprocessing. In contrast, incorporating spectral diversity and temporal metrics substantially improved accuracy and robustness, consistently separating brain from non-brain. Gains were observed across institutions and hardware, requiring minimal end-user intervention and accommodating variable wavelength availability.

Conclusions: Integrating spectral and temporal features, coupled with atlas alignment, delivers high-accuracy, generalizable cortical segmentation for WOI. This approach outperforms single-image methods, reduces manual burden and practice variation, and provides a modular path toward standardized, reproducible preprocessing in the WOI community.

## Repository Contents

### Training and Testing Data
Training and testing images are provided as PNG files. The images can be read as matrices in MATLAB and are organized into folders according to the input data used:

- Wavelength only
- Local correlation only
- Standard deviation only
- Combined inputs
- The corresponding ground-truth masks used during training and testing are also included.

### Network Architecture
The network architecture files contain:
- The original U-Net architecture design
- Networks trained for this work
- Basic code for testing the included networks
- Basic code to train new networks

### Auto Segmentation Code
The Auto Segmentation Code folder contains the dependencies and code needed to test data using the proposed method. It includes an editable system parameters file to accommodate differences in data structure between labs.

The required input is a .mat file containing raw data with dimensions corresponding to [image_width, image_height, wavelength_num, time]
