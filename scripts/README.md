[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# Using the interior point solver

After downloading the DOTmark collection (using ***scripts/get_dotmark.sh***) run the interior point solver using the script 
```
run_dotmark.m
```
Inside the script, set the following parameters:
- *resolution*: 32, 64 or 128 pixels per side of the image (for 256, approximately 150 GB of memory are required).
- *Classid*: 1 to 10 (it can be an array of values), to select which classes of the DOTmark collection to run.
- *problem*: 1 to 45 (it can be an array of values), to select the problems to consider in the chosen class. Set this parameter to 0 to run all 45 problems.
- *distance*: 1, 2 or 3, to select the cost function given respectively by the 1-norm, 2-norm or $\infty$-norm.

Once the script is run, the results are saved in 
```
results/IPM_results/
```
and can be visualized using the scripts in 
```
scripts/generate_figures/
```

Have a look at the help for ***OT_IPM*** to set more parameters (IPM tolerance, maximum iterations, verbosity...), or open the script ***src/CheckInput.m*** for more advanced parameters.


# Using the Lemon solver

After having installed [Lemon](https://lemon.cs.elte.hu/trac/lemon/wiki/Downloads), run the script 
```
generate_lemon_data.m
```
with the same parameters described above, to generate the data that Lemon uses. This saves the data in the folder ***data/lemon_data***. Then, compile the script ***dotmark_lemon_code.cpp*** with the following command on a terminal
```
g++ -std=c++11 -O3 dotmark_lemon_code.cpp -o run_lemon
```

The executable file must be run with six parameters:
- resolution: 32, 64 or 128 (for 256, more than 400GB of memory are required).
- cost function: 1, 2 or 3.
- initial class: 1 to 10.
- final class: 1 to 10, larger than or equal to the initial class.
- initial problem: 1 to 45.
- final problem: 1 to 45, larger than or equal to the initial problem.

For example, the following command runs the Lemon solver with resolution 64, cost function given by the 2-norm, for all the problems in classes 1, 2 and 3
```
./run_lemon 64 2 1 3 1 45
```























