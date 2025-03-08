# A Nonlinear Modeling of Fractional Order Based Variational Model in Optical Flow Estimation

**Authors:** Muzammil Khan\*, Pushpendra Kumar  

## 📄 [Read the Full Article](https://www.sciencedirect.com/science/article/pii/S0030402622004958)

## Abstract  
In this paper, a nonlinear fractional order variational (NFOV) model is introduced to estimate  
the optical flow. In particular, the presented model can be scaled to the existing integer  
order variational models. The proposed variational functional is designed by combining a  
non-quadratic Charbonnier norm-based data term and a Marchaud fractional derivative-based  
regularization term. This non-quadratic penalty is robust against outliers, whereas the nonlocal  
character of the Marchaud fractional derivative leads the model to deal with the discontinuous  
information about texture and edges, yielding a dense flow field.  

The numerical discretization of the Marchaud fractional derivative is carried out with the help of  
the Grünwald–Letnikov fractional derivative. The discretized nonlinear system is further reduced  
to a linear system of equations by employing an outer fixed-point iteration scheme and is finally  
solved with an efficient iterative technique. The experiments are performed over a variety of datasets.  

The performance of the model is tested using different error measures (AAE, AEE, AENG, WE)  
depending upon the availability of the ground truth (GT) flow. The robustness of the NFOV model  
is shown under different amounts of noise along with the variation of the smoothing parameter.  

A detailed comparison with recently published works is presented to demonstrate the efficiency  
and accuracy of the proposed model.

## Figure  
![Figure 1](figures/fig01.png)
**Figure 1:** Estimated optical flow fields corresponding to Grove2 and Tortoise datasets in terms of color maps and vector plots.
