function [out_samp, out_coeff] = fadchan (in_samp, snr, p_coeff, p_delay)
% FADCHAN Fading channel
%
% [out_samp out_coeff] = fadchan (in_samp, snr, p_coeff, p_delay)
% models Rayleigh fading channel, p_coeff & p_delay defines
% attenuation and delay (relative) for each path, snr
% denotes signal-to-noise ratio, in_samp and out_samp denotes
% input and output of the channel, out_coeff contains samples
% of the Rayleigh process for each path

[m, n] = size (in_samp);
if (m ~= 1)
   error ('Input must be a row vector')
end

c = length (p_coeff); % number of paths
d = length (p_delay);
if (c ~= d)
   error ('p_coeff & p_delay must be of equal size')
end

out_samp = zeros (1, n);
out_coeff = zeros (c, n);

for j = 1 : c % for every path
   p_c = p_coeff (j); % path attenuation
   p_d = p_delay (j); % path delay (samples)
   r = crayleigh(n-p_d) .* p_c; % generate Rayleigh process
   out_samp((p_d+1):n) = out_samp((p_d+1):n) + in_samp(1:(n-p_d)) .* r;
   out_coeff (j,(p_d+1):n) = r;
end

pow_in = mean ((abs (in_samp)).^2); %estimate signal power
sigma = sqrt (pow_in * 10^(-snr / 10));
awgn = sigma .* (randn (1, n) + sqrt (-1) .* randn (1, n));

out_samp = out_samp + awgn; % add noise samples 
%pow_out = mean ((abs (out_samp)).^2);
%disp (pow_in);
%disp (pow_out);
