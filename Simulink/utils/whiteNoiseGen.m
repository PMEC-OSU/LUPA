function sig = whiteNoiseGen(fs,fmin,fmax,rLen)

rng(24); % set the seed for the random number generator so we get the same thing every time

initLength = 10;


N_ph = 100; % number of random phases to be generated

df = 1/rLen;
f_vec = fmin:df:fmax;

Amp = ones(size(f_vec)); % spectral shape

dt = 1/fs;
t_vec = 1:dt:rLen-dt;
w_vec = 2*pi*f_vec.';

exp_mat = exp(1i*w_vec*t_vec);
ph = 2*pi*(rand(N_ph,length(Amp))-0.5);

sig1 = [];
sig2 = [];
sig3 = [];

delta_0 = Inf;

for i = 1:N_ph

    fd_sig = Amp.*exp(1i*ph(i,:));
    sig_tmp = real(fd_sig*exp_mat);
    delta_amp = max(sig_tmp)- min(sig_tmp);
    if delta_amp < delta_0
        delta_0 = delta_amp;
        sig3 = sig2;
        sig2 = sig1;
        sig1 = sig_tmp/max(abs(sig_tmp));
    end

end

sig1n = [zeros(1,fs*initLength) sig1];
sig2n = [zeros(1,fs*initLength) sig2];
sig3n = [zeros(1,fs*initLength) sig3];
tnew = 0:dt:length(sig1n)*dt-dt;

sig.WN1 = timeseries(sig1n,tnew);
sig.WN2 = timeseries(sig2n,tnew);
sig.WN3 = timeseries(sig3n,tnew);

% plot(tnew,sig1n,tnew,sig2n,tnew,sig3n)

end