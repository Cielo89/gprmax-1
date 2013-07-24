function [excitation]=gprmaxso(type,amp,freq,dt,total_time);

% GPRMAXSO  Computes the excitation function used in 'GprMax2D/3D'
%           simulators for ground probing radar.
%
%  [excitation] = gprmaxso('source_type',Amplitude,frequency,Time_step,Time_window)
%           source_type can be 'cont_sine', 'gaussian', 'ricker'
%           Amplitude is the amplitude of the source
%           frequency is the frequency of the source in Hz
%           Time_step is the time step in seconds
%           Time_window is the total simulated time in seconds
%
%           excitation is a vector which contains the excitation function.
%           If you type plot(excitation) Matlab will plot it.
%           You can use the signal processing capabilities of Matlab
%           to get a Spectrum etc.
%
%	    Copyright: Antonis Giannopoulos, 2002 This file can be distributed freely.

RAMPD=0.25;
if(nargin < 5)
error('GPRMAXSO requires all five arguments ');
end;

if(isstr(type)~=1)
error('First argument should be a source type');
end;
if(freq==0)
error(['Frequency is zero']);
end;
iter=total_time/dt;
time=0;


if(strcmp(type,'ricker')==1) 
rickth=2.0*pi*pi*freq*freq;
rickper=1.0/freq;
ricksc=sqrt(exp(1.0)/(2.0*rickth));
i=1;
while(time<=total_time)
 delay=(time-rickper);
 temp=exp(-rickth*delay*delay);
 excitation(i)=ricksc*temp*(-2.0)*rickth*delay;
 time=time+dt;
 i=i+1;
 end;
end;

if(strcmp(type,'gaussian')==1)  
rickper=1.0/freq;
rickth=2.0*pi*pi*freq*freq;
i=1;
while(time<=total_time)
 delay=(time-rickper);
 excitation(i)=exp((-rickth)*delay*delay);
 time=time+dt;
 i=i+1;
 end;
end;


if(strcmp(type,'cont_sine')==1)  
i=1;
while(time<=total_time)
 ramp=time*RAMPD*freq;
  if(ramp>1.0) 
   ramp=1.0;
   end;
 excitation(i)=ramp*sin(2.0*pi*freq*time);
 time=time+dt;
 i=i+1;
 end;
end;

if(strcmp(type,'sine')==1)  
i=1;
while(time<=total_time)
 excitation(i)=sin(2.0*pi*freq*time);
 if(time*freq>1.0) 
   excitation(i)=0.0;
   end;
 time=time+dt;
 i=i+1;
 end;
end;

excitation=excitation.*amp;









