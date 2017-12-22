The code is based on Henning U. Voss's work.
Most ACE program use smoothing as a method to replace calculate conditional expectation.
But this ace_main_gas.m program compute the conditional expectation directly.
And it's useful to deal with some categorical variables.
-----------------
 Usage:
[psi, phi]=ace_main_gas(x,dim,canv)
  input:
x is a matrix contains all the data, x=[y x1 x2 x3]
dim is the number of terms on right hand side
canv is an int depending on how much variables you have. the canvs size, it has to be larger than squred-root of (dim+1)

  output:
psi means corrcoef between sum of transformed x1,x2,x3... and transformed y.
phi is transformed x,x=[y x1 x2 x3]

-----------------
 References:
%
% [1] L. Breiman and J.H. Friedman,
% Estimating optimal transformations for multiple regression and correlation,
% J. Am. Stat. Assoc. 80 (1985) 580-619.
%
% [2] W. Haerdle, Applied Nonparametric Regression,
% Cambridge Univ. Press, Cambridge, 1990.
%
% [3] H. Voss and J. Kurths,
% Reconstruction of nonlinear time delay models from data by the
% use of optimal transformations,
% Phys. Lett. A 234,  336-344 (1997).
%
% [4] H. Voss and J. Kurths,
% Reconstruction of nonlinear time delay models from optical data,
% Chaos, Solitons & Fractals 10, 805-809 (1999).
%
% [5] H.U. Voss, P. Kolodner, M. Abel, and J. Kurths,
% Amplitude equations from spatiotemporal binary-fluid convection data,
% Phys. Rev. Lett.  83, 3422-3425 (1999).