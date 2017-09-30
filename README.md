# myPhast
Make changes to [PHAST](https://github.com/CshlSiepelLab/phast) (a phylogeny software)

- Try to add acceleration states to DLESS
- Analyze adaptive substitution

## Versions
### V3
- put acc within conserve instead of neutral
	- change acc states from being a subtree within neutral states to being a subtree within conserve state. 
	- Reference: [Pollard, Katherine S., Sofie R. Salama, Nelle Lambert, Marie-Alexandra Lambot, Sandra Coppens, Jakob S. Pedersen, Sol Katzman et al. "An RNA gene expressed during cortical development evolved rapidly in humans." Nature 443, no. 7108 (2006): 167](https://www.nature.com/nature/journal/v443/n7108/pdf/nature05113.pdf)
	- `bd_phylo_hmm.c & .h` 
		- `BDPhyloHmm *bd_new()`
			- add conserve state above the acc subtree.


### All Changes
- add leaf acc states 
  - `dless.c`
     - add “lambda, eta, estim_eta”
  - `bd_phylo_hmm.c & .h` 
     - `BDPhyloHmm *bd_new()`
         - add “lambda, eta, estim_eta, branch_to_state_acc”
         - change “nstates”
         - add acc event to all leave nodes
         - add “*= lambda” models 
     - `void bd_set_transitions()`
         - change transition matrix (l204-l217)
- add acc states at bottom d levels of the tree 
  - `dless.c`
     - add “acc_height”
  - `bd_phylo_hmm.c & .h` 
     - `BDPhyloHmm *bd_new()`
         - add “acc_height”
         - add acc states if height < acc_height (leaf = 0)
  - `tree_model.c & .h`
     - add `int tm_acc_nstates()`: calculate the number of acc states (implemented in the most naive way)
- test v1 robustness  
  - `v1_robustness_2.R`: r package shiny
- adaptive substitution analysis
    - `v2_adaptive_substitution.Rmd`

### Commitment
- V0 
  - allow rho >= 1
- V1 
  - add leaf acc states
  - check robustness (shiny)
- V2 
  - add bottom h level acc states
  - adaptive substitution analysis
- V3
  - acc within conserve instead of neutral


### Furture Work
- eta estimation
  - `bd_phylo_hmm.c & .h` 
     - `double bd_estimate_transitions()`
- improve `int tm_acc_nstates()`





