[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# An Interior-Point-Inspired algorithm for Linear Programs arising in Discrete Optimal Transport

This archive is distributed in association with the [INFORMS Journal on
Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE).



## Cite

To cite the contents of this respository, please cite both the paper and this repo, using their respective DOIs.

https://doi.org/10.1287/ijoc.2022.0184

https://doi.org/10.1287/ijoc.2022.0184.cd

Below is the BibTex for citing this snapshot of the respoitory.

```
@article{IPMforOT,
  author =        {F. Zanetti and J. Gondzio},
  publisher =     {INFORMS Journal on Computing},
  title =         {An Interior-Point-Inspired algorithm for Linear Programs arising in Discrete Optimal Transport},
  year =          {2023},
  doi =           {10.1287/ijoc.2022.0184.cd},
  url =           {https://github.com/INFORMSJoC/2022.0184},
}  
```

## Description

This software is used to solve discrete optimal transport problems. For a description of the specialized interior point solver developed, see the paper ***An Interior-Point-Inspired algorithm for Linear programs arising in Discrete Optimal Transport***. The test problems come from the freely available collection [DOTmark](http://www.stochastik.math.uni-goettingen.de/index.php?id=215/). The corresponding images can be found in 
```
data/dotmark_images/
```

## Using the IPM solver

To run the interior point solver use the script ***run_dotmark.m*** (more details are in the README file in the folder ***scripts***). The results are saved, as a Matlab table, in the folder 
```
results/IPM_results/ 
```
The results obtained by the authors instead are reported in the folder
```
results/original_results/results_IPM/
```

## Using the Lemon solver

There is also a script to run the same problems using Lemon, a newtork optimization library freely available from [here](https://lemon.cs.elte.hu/trac/lemon/wiki/Downloads). The script ***generate_lemon_data.m*** generates the problems in a way that can be used by Lemon; choose the resolution and the problem in the script. The data is saved in
```
data/lemon_data/
```

The code to use to run Lemon is ***dotmark_lemon_code.cpp*** in ***src*** and has to be compiled using at least C++11 (more details are in the README file in the folder ***scripts***). The results are saved in the folder
```
results/lemon_results/
```
while the results obtained by the authors are reported in
```
results/original_results/results_lemon/
```

The script to run the problems with Cplex is not reported, due to copyright reasons. The results obtained with Cplex by the authors are reported in 
```
results/original_results/results_cplex/
```




## Replicating

In order to replicate the figures in the paper, run the scripts in
```
scripts/generate_figures/
```

- ***perf_profile_dotmark.m*** reproduces the performance profiles for a given resolution (Figure 4 in the paper).

- ***time_spread_128.m*** reproduces the plot of the computational time of each problem in each class, for a given cost function (Figure 5 in the paper).

- ***logplot_large_scale.m*** reproduces the logarithmic plot of the computational times with up to 4.3 billion variables, for a given cost function (Figure 6 in the paper).
























