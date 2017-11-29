clc;

stan_poczatkowy = [1 0 0 0 0];
len = length(stan_poczatkowy);
P = 2^len - 1; 
%wielomian 1+x^3+x^5
wielomian = [0 0 1 0 1];
%wielomian 1+x^2+x^3+x^4+x^5
wielomian2 =[0 1 1 1 1];
sekwencje = zeros(1, P);
sekwencje2 = zeros(1, P);
sekwencje(1) = stan_poczatkowy(len); 
sekwencje2(1) = stan_poczatkowy(len); 
temp1 = stan_poczatkowy; 
for i=2:P
    temp2 = circshift(temp1,[0 1]) ; 
    temp2(1) = mod(sum(wielomian.*temp1), 2);
    temp1 = temp2;
    sekwencje(i) = temp1(len);
end

temp1 = stan_poczatkowy; 
for i=2:P
    temp2 = circshift(temp1,[0 1]) ; 
    temp2(1) = mod(sum(wielomian2.*temp1), 2);
    temp1 = temp2;
    sekwencje2(i) = temp1(len);
end



mseq1 = sekwencje;
mseq2 = sekwencje2;
mseq3 = circshift( sekwencje2', 1)';
mseq4 = circshift( sekwencje2', 2)';
mseq5 = circshift( sekwencje2', 3)';
seqgold1 = zeros(1,31);
seqgold2 = zeros(1,31);
seqgold3 = zeros(1,31);
seqgold4 = zeros(1,31);

%% sekwencje golda

for i=1:31
   seqgold1(i) = xor(mseq1(i),mseq2(i));
   seqgold2(i) = xor(mseq1(i),mseq3(i));
   seqgold3(i) = xor(mseq1(i),mseq4(i));
   seqgold4(i) = xor(mseq1(i),mseq5(i));
end

for i=1:31
    if (seqgold1(i) == 0)
         seqgold1(i)=-1;
    end
end

for i=1:31
    if (seqgold2(i) == 0)
         seqgold2(i)=-1;
    end
end

for i=1:31
    if (seqgold3(i) == 0)
         seqgold3(i)=-1;
    end
end

    

%% funkcja korelacji wzajemnej

korelacjawzajemna=zeros(1,31);

 for i=1:31
     wynik=0;
     for j=1:31
         k=mod(j-i,31)+1;
        wynik=wynik+(seqgold1(j)*seqgold3(k));
    end
    korelacjawzajemna(i)=wynik;
end

plot(korelacjawzajemna);
