function rfg_init (fd, fs, dr, fior, ds_type)
% RFG_INIT Rayleigh fading generator initialization
%
% rfg_init (fd, fs, dr, fio, ds_type)
% computes the filter of order fio for filtering
% WGN according to Jake's fading spectrum
% and interpolation ratio ir for given doppler spread 
% fd (Hz),sampling frequency fs (samples per symbol)
% and data rate dr (bit/s)
% ds_type specifies Doppler spectrum
% Warning! fio must be a power of 2!

global hn;
global hd;
global ir;
global fio;

fio = fior;

fdn = 0.05686; %normalized fading frequency (fs = 1.0)
df = 1/fio;
ifd=round(fdn/df);

%transfer function of Clarke's model due to doppler shift

switch ds_type
	case 'classic'
		f = 0:df:(fio-1)*df;
		sf = zeros(fio,1);
		sf(1:ifd-1)=1./sqrt(1-(f(1:ifd-1)./fdn).^2);
		fd1=fdn-df;
		dsf=fd1/(pi*fdn.^3*sqrt(1-(fd1/fdn).^2));
		sf(ifd)=sf(ifd-1)+dsf*df;
		sf(fio-ifd+1:fio)=sf(ifd:-1:1);
      sf=sqrt(sf);
   case 'flat'
      sf = ones(fio,1);
   otherwise
      error ('Unsupported Doppler spectrum');
end;


%impulse response of the filter (nominator)
hn=zeros(fio,1);
isf=real(ifft(sf));

temp=isf(1:fio/2);
hn(1:fio/2)=isf(fio/2+1:fio);
hn(fio/2+1:fio)=isf(1:fio/2);

%normalize so that gain of filter = 1
nf = sqrt(2*sum(hn.*hn));
hn = hn./nf;
%nf1 = sqrt(sum(hn.*hn));

hd=0*hn; %(denominator)
hd(1)=1;

%[h,w] = freqz(hn,1,fio);
%plot(f,sf,w/(2*pi),abs(h));

ir = fdn * fs * dr / fd;
ir = round (ir);
%fd = fdn * fs * dr / ir;
