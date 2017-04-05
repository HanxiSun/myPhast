# myPhast
Make changes to PHAST (a phylogeny software, https://github.com/CshlSiepelLab/phast)

Try to add acceleration to DLESS: 
1. change error conditions to allow rho>=1
  - dless.c: “rho = get_arg_dbl_bounds(optarg, 0, INFTY);”
  - bd_phylo_hmm.c: “if (rho <= 0)// || rho >= 1)”


