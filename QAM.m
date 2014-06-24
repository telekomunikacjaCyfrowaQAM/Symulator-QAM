function [signal,I,Q,mod,mappedSymbols,signalDemodulated, bitErrorRate] = QAM( constelationSize, messageLength, signalToNoiseRatio )


numberOfBits = messageLength;
M = constelationSize;
k = log2(M);
SNR = signalToNoiseRatio;
%Generowanie wiadomosci
generatedData = generatorWiadomosci(numberOfBits,M);

% Tworzenie konstelacji kwadratowej w kodzie graya
iValues = -(sqrt(M)-1):2:(sqrt(M)-1); % tworzy wektor wartosci dla konstelacji
qValues = -(sqrt(M)-1):2:(sqrt(M)-1);
ip = 0:M-1;
ipBin = dec2bin(ip.');
ipDecRe = bin2dec(ipBin(:,1:k/2));
ipGrayDecRe = bitxor(ipDecRe,floor(ipDecRe/2));
ipDecIm = bin2dec(ipBin(:,k/2+1:k));
ipGrayDecIm = bitxor(ipDecIm,floor(ipDecIm/2));
modRe = iValues(ipGrayDecRe+1);
modIm = qValues(ipGrayDecIm+1);

mod = modRe + 1i*modIm;

mappedSymbols = zeros(1, length(generatedData) / log2(M));

% Mapowanie bitów
for i = 1:log2(M):length(generatedData)
    
    symbolBits = generatedData(i:i+(log2(M)-1));
    switch(log2(M))
        case 2
            symbolIndex = 2^1*symbolBits(1)+ 2^0*symbolBits(2);
        case 4
            symbolIndex = 2^3 * symbolBits(1) + 2^2 * symbolBits(2)+ 2^1 *     symbolBits(3)+ 2^0 * symbolBits(4);
        case 6
            symbolIndex = 2^5 * symbolBits(1) + 2^4 * symbolBits(2) + 2^3 * symbolBits(3) + 2^2 * symbolBits(4)+ 2^1 * symbolBits(5)+ 2^0 * symbolBits(6);
        case 8
            symbolIndex = 2^7 * symbolBits(1) + 2^6 * symbolBits(2) + 2^5 * symbolBits(3) + 2^4 * symbolBits(4)+ 2^3 * symbolBits(5)+ 2^2 * symbolBits(6)+2^1 * symbolBits(7) +2^0 * symbolBits(8) ;
        case 10
            symbolIndex = 2^9*symbolBits(1) + 2^8*symbolBits(2)+ 2^7*symbolBits(3) +2^6*symbolBits(4) +2^5*symbolBits(5) +2^4*symbolBits(6) +2^3*symbolBits(7) +2^2*symbolBits(8) +2^1*symbolBits(9) +2^0*symbolBits(10);
        otherwise
            fprintf('ERROR' );
    end
    
    mappedSymbols((i - 1)/log2(M) + 1) = mod( symbolIndex + 1);
    
end


symbol=ones(1,(k*100));
signal= [];
for i= 1:1:length(mappedSymbols)
    signal=[signal symbol*mappedSymbols(i)];
end



t = 0:99;
fc = 10;
fs = 100;
f0= fc/fs;
s1 = [];
s2 = [];
for i= 1:length(mappedSymbols)
    
    s1 = [s1 real(mappedSymbols(i))*cos(2*pi*f0*t)];
    s2 = [s2 imag(mappedSymbols(i))*sin(2*pi*f0*t)];
    
end
qam = s1 -s2;



SNRdB = 10.^(SNR/10);


    

    Et =  sum((real(mappedSymbols)-imag(mappedSymbols)).^2)/k;
    Eb= Et/length(qam);
    n0 = Eb/10.^(SNR(j)/10);
    pn = n0*fs;
    noise = sqrt(pn)*randn(1,length(qam));
    qamAWGN = qam + noise;
    
    for i=1:1:length(mappedSymbols)    %dolno
        I((i-1)*100+t+1)=qamAWGN((i-1)*100+t+1).*cos(2*pi*f0*t);
        Q((i-1)*100+t+1)=qamAWGN((i-1)*100+t+1).*-sin(2*pi*f0*t);
    end
    
    [b,a] = butter(5,0.2);
    Idem = 2.*filter(b,a,I);
    Qdem = 2.*filter(b,a,Q);
    
    %wyliczanie wartosci I i Q do naniesienia na diagram konstelacji
    signalDemodulated=[];
    for m=100:100:length(Idem)
    signalFiltered = Idem(m) + Qdem(m)*1i;
    signalDemodulated = [signalDemodulated signalFiltered];
    end
    
     %Demapowanie dla konstelacji typu kwadratowego
    Idem = round((Idem-1)/2)*2+1;
    Qdem = round((Qdem-1)/2)*2+1;
    for p = 1:length(Idem)
        if(Idem(p)>sqrt(M)-1)
            Idem(p)= sqrt(M)-1;
        elseif (Idem(p)<(-sqrt(M)+1))
            Idem(p)= -sqrt(M)+1;
        end
        if(Qdem(p)>sqrt(M)-1)
            Qdem(p)= sqrt(M)-1;
        elseif (Qdem(p)<(-sqrt(M)+1))
            Qdem(p)= -sqrt(M)+1;
        end
    end
    
    demod = Idem + 1i*Qdem; % suma I i Q odzyskanego
    
    msgdem = [];
   
    %Odczytywanie bitów
    for p = 100:100:length(demod)
        value = demod(p); % tutaj przekazuje kolejne wartości np -1+3*1i
        index = find(mod == value,1); % wyszukuje odpowiedni indeks dla tej wiadomosci w mapie konstelacji
        bin = dec2bin(index-1,log2(M));
        msgdem = [msgdem bin];
    end
    msgdem = num2str(msgdem) - '0'; % zamieniam wartośc indeksu na liczbe binarna odpowiadającą danemu punktowi
        
    %Wyliczanie BER
    DATA = generatedData;
    RECEIVED_DATA = msgdem;
    numberOfErrors = sum(xor( DATA,RECEIVED_DATA));
    bitErrorRate = numberOfErrors/length(DATA);

end

