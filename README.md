# myPhast
Make changes to PHAST (a phylogeny software, https://github.com/CshlSiepelLab/phast)

Try to add acceleration to DLESS: 
1. add leaf acc state (lambda, eta) (no eta estimation)
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
    - double bd_estimate_transitions():      // not done

Test:
1. robustness check

