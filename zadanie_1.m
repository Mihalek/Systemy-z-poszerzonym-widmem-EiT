clc;
wielomian = [1 0 1 0 0 1];      
stan_poczatkowy = [1 0 0 0 0];
l_bitow_wygenerowanych = 31;

rejestr = stan_poczatkowy;
rejestr_poprzedni = zeros(1:length(rejestr));
sekwencja = zeros(1,length(l_bitow_wygenerowanych));

for i=1:l_bitow_wygenerowanych
    disp(rejestr_poprzedni);
    sekwencja(i) = rejestr(length(rejestr));
    rejestr_poprzedni = rejestr;
    for j = 1:length(stan_poczatkowy)
        if(j == 1)
            rejestr(j) = mod(rejestr_poprzedni(length(rejestr_poprzedni)) + rejestr(2),2);
        else 
            rejestr(j) = rejestr_poprzedni(j-1);
        end
    end
end

zamiana=sekwencja;

for i=1:l_bitow_wygenerowanych
    if (zamiana(i) == 0)
        zamiana(i)=-1;
    end
end

autokorelacja=zeros(1,l_bitow_wygenerowanych);
for i=1:l_bitow_wygenerowanych
    wynik=0
    for j=1:l_bitow_wygenerowanych
       k=mod(j-i,31)+1;
       wynik=wynik + (zamiana(j)*zamiana(k));
    end
    autokorelacja(i)=wynik;
end

%wynik=fft(zamiana);
%wynik2=abs(wynik);
%wynik = ifft(wynik2);
%autokorelacja = real(wynik);

plot(autokorelacja);