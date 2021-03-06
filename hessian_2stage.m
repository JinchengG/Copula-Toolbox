function H = hessian_2stage(f,x,N,h,varargin)
% Usage:
%         H = hessian_2stage(func,x,N,varargin)
%
% Inputs:
%         f = function name, feval = func(x,varargin)
%         x = vector of parameters (n x 1)
%         N = the last N rows to be completed
%         h = the step-size. default =  eps.^(1/3)*max(abs(x),1e-2)
%         varargin = optional arguments passed to the function
% 
% Outputs:
%           H = the N last rows of the hessian
%           used to speed up dcc_garch


% Code modified from:
% COMPECON toolbox [www4.ncsu.edu/~pfackler]
% by James P. LeSage, Dept of Economics
% University of Toledo
% 2801 W. Bancroft St,
% Toledo, OH 43606
% jlesage@spatial-econometrics.com

%   Copyright (c) Kevin Sheppard.
%   $Revision: 1.0 $  $Date: 2001/04/19 $


n = size(x,1);
fx = feval(f,x,varargin{:});
 
if nargin<4 | isempty(h)
    % Compute the stepsize (h)
%    h = eps.^(1/3)*max(abs(x),1e-2);
%    h = eps.^(1/3)*max(abs(x),1e-4);
%    h = -eps.^(1/3)*max(abs(x),1e-4);
    h = -eps.^(1/3)*max(abs(x),1e-2);
end
xh = x+h;
h = xh-x;    
ee = sparse(1:n,1:n,h,n,n);
 
% Compute forward step 
g = zeros(n,1);
for i=1:n
  g(i) = feval(f,x+ee(:,i),varargin{:});
end
   
H=h*h';
% Compute "double" forward step 
for i=1:n
for j=(n-N+1):n
  if i<=j;
      H(i,j) = (feval(f,x+ee(:,i)+ee(:,j),varargin{:})-g(i)-g(j)+fx)/H(i,j);
      H(j,i) = H(i,j);
  end
end
end

newH=H((n-N+1):n,:);
H=newH;