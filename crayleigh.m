function r = crayleigh(ns)
% CRAYLEIGH Rayleigh fading simulator
%
% crayleigh(ns)
% A Rayleigh fading simulator based on Clarke's Model
% Creates ns samples of a Rayleigh random process
% using the filter calculated in rfg_init and
% interpolater with interpolation ratio ir

global hn;
global hd;
global ir;
global fio;

N1 = ceil (ns/ir)+1;
XI = (1:(N1-1)/((N1-1)*ir):N1);
N = N1 + fio; %number of WGN samples to produce

I_input = randn(1,N);
Q_input = randn(1,N);

I_temp = filter (hn, hd, I_input);
Q_temp = filter (hn, hd, Q_input);

I_temp1 = I_temp (fio+1:N);
Q_temp1 = Q_temp (fio+1:N);

I_output = interp1 (1:N1, I_temp1, XI);
Q_output = interp1 (1:N1, Q_temp1, XI);

j = sqrt (-1);
r(1:ns) = I_output(1:ns) + j .* Q_output(1:ns);
