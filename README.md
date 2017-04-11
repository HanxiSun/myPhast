# myPhast
Make changes to PHAST (a phylogeny software, https://github.com/CshlSiepelLab/phast)


V2:
1. add acc states at bottom d levels of the tree 
  - dless.c: 
    - add “acc_height”
  - bd_phylo_hmm.c & .h: 
    - BDPhyloHmm *bd_new():
      - add “acc_height”
      - add acc states if height < acc_height (leaf = 0)
  - tree_model.c & .h:
    - add “int tm_acc_nstates()” (calculate # of acc states) // most naive way 


PREVIOUS VERSIONS:
Try to add acceleration states to DLESS: 
1. add leaf acc states 
  - dless.c: 
    - add “lambda, eta, estim_eta”
  - bd_phylo_hmm.c & .h: 
    - BDPhyloHmm *bd_new():
      - add “lambda, eta, estim_eta, branch_to_state_acc”
      - change “nstates”
      - add acc event to all leave nodes
      - add “*= lambda” models 
    - void bd_set_transitions():
      - change transition matrix (l204-l217)


TESTS:
1. v1 - robustness checking (shiny): v1_rb_2.R


NEED FIXING:
1. eta estimation
  - bd_phylo_hmm.c & .h: 
    - double bd_estimate_transitions():


VERSIONS COMMIT TO GITHUB:
V0: allow rho >= 1
V1: add leaf acc states
    check robustness (shiny)
V2: add bottom h level acc states

cd GoogleDrive/Purdue/Research/Vinayak_Rao/17Spr_Genetic/Softwares/
