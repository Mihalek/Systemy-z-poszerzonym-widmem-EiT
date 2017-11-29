clear;
clc;


%% generacja losowej sekwencji
wektor1 = zeros(1,100);
wektor2= zeros(1,100);
wektor3= zeros(1,100);
wektor4= zeros(1,100);
BER = zeros(1,10);
wykres=zeros(1,10);
SNR = -10;
for a=1:10
    suma=0;
    for d=1:2000 
        for i=1:100
         wektor1(i) =round(rand);
         wektor2(i) =round(rand);
         wektor3(i) =round(rand);
         wektor4(i) =round(rand);
        end
        wektor1= 1-2*wektor1;
        wektor2= 1-2*wektor2;
        wektor3= 1-2*wektor3;
        wektor4= 1-2*wektor4;
    %% generacja sekwencji golda

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
    mseq3 = circshift(sekwencje2', 1)';
    mseq4 = circshift(sekwencje2', 2)';
    mseq5 = circshift(sekwencje2',3)';
    seqgold1 = zeros(1,31);
    seqgold2= zeros(1,31);
    seqgold3=zeros(1,31);
    seqgold4=zeros(1,31);
 
    

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
        if (seqgold2(i) == 0)
            seqgold2(i)=-1;
        end
        if (seqgold3(i) == 0)
            seqgold3(i)=-1;
        end
        if (seqgold4(i) == 0)
            seqgold4(i)=-1;
        end
    end

%Rozproszenie sekwencji

    %for k=1:10
    przedkanalem=zeros(1,3100);
    przedkanalem1=zeros(1,3100);
    przedkanalem2=zeros(1,3100);
    przedkanalem3=zeros(1,3100);
    przedkanalem4=zeros(1,3100);
    licznik=1;
    for i = 1:100
        for j = 1:31
            przedkanalem1(licznik) = wektor1(i) * seqgold1(j);
            przedkanalem2(licznik) = wektor2(i) * seqgold2(j);
            przedkanalem3(licznik) = wektor3(i) * seqgold3(j);
            przedkanalem4(licznik) = wektor4(i) * seqgold4(j);
            licznik = licznik+1;
        end
    end
    przedkanalem=przedkanalem1+przedkanalem2+przedkanalem3+przedkanalem4;
    %wejscie do kana³u
    pokanale=awgn(przedkanalem,SNR);

    %skupienie sekwencji
    pokanale_odbiornik=zeros(1,3100);

    licznik = 1; 
    for i = 1:100
        for j = 1:31
        pokanale_odbiornik(licznik) = pokanale(licznik) * seqgold1(j);
        licznik = licznik+1;
        end
    end


    %zsumowanie bitów
    bity_zsumowane = zeros(1,100);
    for i = 1:100
        for j = 1:31
        bity_zsumowane(i) = bity_zsumowane(i) + pokanale_odbiornik((i-1)*31+j);
        end
    end
 
    %uk³ad decyzyjny
    bity_zdekodowane = zeros (1,100);
    for i = 1:100
        if (bity_zsumowane(i) < 0)
        bity_zdekodowane(i) = -1;
        else
        bity_zdekodowane(i) = 1;
        end
        if (bity_zdekodowane(i) ~= wektor1(i))
        suma = suma + 1;
        end
    end
    BER(a)=suma/200000;
    wykres(a)=SNR;
    end
    SNR=SNR +1.0;
end
    semilogy(wykres,BER);
    xlabel('SNR');
    ylabel('BER');
    grid on

    