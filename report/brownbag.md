% Missing Value Imputation for Spatio-Temporal Data Analysis: Case Study on Monthly Rainfall Data
% Lingbing Feng
% 2012/09/110




# Agenda

* Motivation
  - What is Spatio-Temporal & Imputation
	- Why it it important & difficult	
	- What is our aim?
* Related Literature
	- Literarure Review
    - Status
* Methods
    - SVD
    - CUTOFF
* Case Study in Australia
	- Data and EDA
	- Crossvalidation
	- Imputation Performance
	- Comparison and more
* Potential and Future Work
	- spatially
	- temporally
	- frequency
	
	 

# Spatio-Temporal Data


***Spatio-temproral data: data with spatial (geographic), temporal components, and attributes.***

* Where  ------ space

* when   ------ time

* what   ------ attributes

*You can think it as a set of multivariate time series that are geographically distributed*


*"space-time: the next frontier"* -- Noel Cressie & Christopher K. Wikle ( 2011 )

# Examples

* Climatic readings ( temperature, rainfall, riverflow, etc. ) for a number of nearby stations

* Satellite images of parts of the earth

* Election results for voting districts and a number of consecutive elections

* GPS tracks for people or animal possibly with additional sensor readings

* Desease outbreaks or volcano eruption

* …

# what is imputation and why?

* Filling Missing values, completing the incomplete data

* For data structure consistency, and ultimately for modelling 

* Model estimating procedure assumes faily completeness upon the data matrix

* If there were missing values in your data, sooner or later, you would have to face the problem.


# It is difficult when

* You take it seriously, rather than saying:*"Here we have chosen to ignore the missing values"*, or *"For the sake of convenience, we case-wise delete all the missing values"*

* You take it very seriously, and you want to impute the missing value by incorporating as much valuable information as possible. 

* You take it extremly seriously, and you want an algorithm which is intuitively simple, credible, and computational efficient.

# Our aim 

* To develope a simple, intuitive, credible method to impute spatio-temporal model

* which takes both spatial and temporal information into consideration

* and we hope it'd be faster than some universally accepted method

# What have we achieved

* Developed a method called **CUTOFF** that meets our aim

* Applied it to a monthly rainfall data

* Some visualization, simulation and cross-validation tools that are useful when analysing spatio-temporal data


# Related Literature (cont'd)

* Schneider (2001) proposes a parametric method that makes use of E-M algorithm and ridge regression to estimate the mean and covariance matrix of the data iteratively. (*spatially weak, and no package supported*)

* Kondrashov et al. (2006) developes an novel, iterative for of M-SSA( Multi-channel Singualr Spectrum Analysis) approach which utilizes temporal, as well as spatial correlations (as they claimed so) to fill in gaps.

* It raised a heat debate (Schneider (2006)'s interesting comment and Kondrashov et al.'s rejoinder)

# We found

* K's idea comes down to matrix decomposition and EM algorithm

* The cros-validation procedure used in their paper is vague and thus untenable

* Heavily relying on the MAR ( Missing At Random)assumption. MAR is, techinically, impossible.

# SVD imputation
* Fuentes et al.(2006), it is stable and reasonble 

* partly nonparametric, E-M like

* standard imputation method in the `SpatioTemporal` R pakage 

We consider it as the competetor 


# Methods: SVD 
* Assume a typical S-P data set comprises $x$ monitoring sites and each site has $t$ observations. This S-P process can be modelled as 
$$Z(s,t)=\mu(s,t)+\varepsilon(x,t)$$
and thus $$\mathbf{Z}=\mathbf{M}+\mathbf{E}$$
* $\mathbf{M}$ is the trend component and $\mathbf{E}$ is the resudual component. M can be modelled by using SVD. so $$\mathbf{M}=\mathbf{F\cdot B}$$
* $F=[f_{0}(t)\, f_{1}(t)\, \cdots\, f_{J}(t)]$ being a $T\times J$ matrix. [basis functions, $f_{0}(t)\varpropto\mathbf{1}$]. So matrix $\mathbf{b}$ is the matrix of trend coefs for the N sites.
* Dimensionality reducing by Taking $\mathbf{F}$ to be the first $J$ left singualr vectors of the singular value decompostion $\mathbf{Z=UDV^{'}}$
* SVD would fail if there is missing value, so Fuentes et al. suggestes...

# cont'd (the `SVD.miss()` does so)

* Specify a rank $J$, default to be 4
* $\mu_{1}$ is row means of $mathbf{Z}$, that is the mean values for non-missing values at each time point across all sites. Replace all NAs in $\mathbf{Z}$ with zeros. 
* Regression through each column of $\mathbf{Z}$ on the initial regressor $\mu_{1}$ and filling the missing values by the fitted values of the regression on that column. Assume $Z_{(i,j)}$ were missing, then it would be replaced by $\alpha_{j}\centerdot\mu_{1(i)}$, where $\alpha_{j}$ is the regression coef by regressing the $j^{th}$ column of $\mathbf{Z}$ on $\mu_{1}$.
* Compute the $J$ SVD approximation of the imputed matrix and do regression of each column of the new data matrix on the $J$ vectors of basis function. The originally missed values are then replaced by the fitted values of this new regression.
* Repeat the SVD and regression until convergence.

# anyway

* The SVD method involves a iterative process of matrix decompisition and regression.
* initializing -> reg(1) -> SVD -> reg -> SVD -> reg -> ...
* Works well when most of the sites share sonme similar temporal patterns
* Be watchful when obs have a substantial variation around the trend, the SVD approx might be a noisy representation of the real pattern
* I reckon the SVD method as being partly temporal imputation rather than spatio-temporally

# `CUTOFF` method




