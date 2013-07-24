function [Ereal,Eimag]=gprmaxde(edc,einf,t,fstart,fstop,fstep);

% GPRMAXDE  Compute real and imaginary parts of permittivity with the
%           Debye dormula used in 'GprMax2D/3D' simulators for ground probing radar.
%
%           [Ereal Eimag] = gprmaxde( Er_dc , Er_inf , fstart , fstop , fstep )
%           Er_dc is the relative static permittivity
%           Er_inf is the relative permittivity at light frequencies
%           t is the relaxation time in seconds
%           fstart is the starting frequency for the calculation
%           fstop  is the last frequency for the calculation
%	    fstep  is the frequency step.
%
%           Ereal is a vector which contains the real part of the
%           relative permittivity
%           Eimag is a vector which contains the imaginary part of the
%           relative permittivity
%
%	    Copyright: Antonis Giannopoulos, 2002 This file can be distributed freely.

j=sqrt(-1);

if(nargin < 4)
error('GPRMAXDE requires at least five arguments ');
end;

if(nargin==5)
omega=linspace(2*pi*fstart,2*pi*fstop,1000);
end;

if(edc<einf)
error('E_DC should be greater than E_inf');
end;

if(t == 0)
error('Relaxation time is zero !');
end;

if(nargin==6)
nsteps=((fstop-fstart)/fstep) + 1;
omega=linspace(2*pi*fstart,2*pi*fstop,nsteps);
end;

E=einf + (edc-einf)./(1 + j.*omega.*t);

Ereal=real(conj(E));
Eimag=imag(conj(E));


