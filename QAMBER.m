function [ bitErrorRate,SNR,theoryBer] = QAMBER( constelationSize, howManyBits )
%  Paremetry wejściowe:
% constelationSize - parametr okreslajacy wartosciowosc konstelacji ( 4 ,16, 64, 256, 1024)
% howManyBits - ilosc bitów do symulacji BER
% Wartości zwracane:
% bitErrorRate - wektor z wartoscią BER dla poszczególnych poziomów SNR
% SNR - wektor wartosci SNR potrzebny do wykreslenia wykresu
% theoryBer - przebieg krzywej teoretycznej do wykresu


numberOfBits = howManyBits;
M = constelationSize;
k = log2(M); %ilość bitów na symbol

% Generowanie wiadomosci
generatedData = generatorWiadomosci(numberOfBits,M);

% Tworzenie konstelacji kwadratowej w kodzie graya
iValues = -(sqrt(M)-1):2:(sqrt(M)-1); % tworzy wektor wartosci dla konstelacji
qValues = -(sqrt(M)-1):2:(sqrt(M)-1);
mapLength = 0:M-1;
binaryValues = dec2bin(mapLength.');
mapDecRe = bin2dec(binaryValues(:,1:k/2));
mapGrayDecRe = bitxor(mapDecRe,floor(mapDecRe/2));
mapDecIm = bin2dec(binaryValues(:,k/2+1:k));
mapGrayDecIm = bitxor(mapDecIm,floor(mapDecIm/2));
mapRe = iValues(mapGrayDecRe+1);
mapIm = qValues(mapGrayDecIm+1);

constelationMap = mapRe + 1i*mapIm; % mapa konstelacji w kodzie Graya

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
    
    mappedSymbols((i - 1)/log2(M) + 1) = constelationMap( symbolIndex + 1);
    
end

% Modulacja
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

qam = s1 - s2; % wektor sygnału QAM

% Symulacja transmisji w kanale AWGN
SNR = 0:15;
SNRdB = 10.^(SNR/10);
bitErrorRate = zeros(1,length(SNR)); % prealokacja wektora
for j = 1 : length(SNR)
    

    Et =  sum((real(mappedSymbols)-imag(mappedSymbols)).^2)/k;
    Eb= Et/length(qam);
    n0 = Eb/10.^(SNR(j)/10);
    pn = n0*fs;
    noise = sqrt(pn)*randn(1,length(qam));
    qamAWGN = qam + noise;
    
    % Demodulacja kohenrentna
    for i=1:1:length(mappedSymbols)   
        I((i-1)*100+t+1)=qamAWGN((i-1)*100+t+1).*cos(2*pi*f0*t);
        Q((i-1)*100+t+1)=qamAWGN((i-1)*100+t+1).*-sin(2*pi*f0*t);
    end
    
    % Filtr dolnoprzepustowy
    [b,a] = butter(5,0.2);
    Idem = 2.*filter(b,a,I);
    Qdem = 2.*filter(b,a,Q);
 
     % Demapowanie dla konstelacji typu kwadratowego
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
    
    msgDem = [];
    % Odczytywanie bitów
    for p = 100:100:length(demod)
        value = demod(p); % tutaj przekazuje kolejne wartości np -1+3*1i
        index = find(constelationMap == value,1); % wyszukuje odpowiedni indeks dla tej wiadomosci w mapie konstelacji
        bin = dec2bin(index-1,log2(M));
        msgDem = [msgDem bin];
    end
    msgDem = num2str(msgDem) - '0'; % zamieniam wartośc indeksu na liczbe binarna odpowiadającą danemu punktowi
        
    % Wyliczanie BER
    DATA = generatedData;
    RECEIVED_DATA = msgDem;
    numberOfErrors = sum(xor( DATA,RECEIVED_DATA));
    bitErrorRate(j)= numberOfErrors/length(DATA);
end

theoryBer = 2*(((sqrt(M))-1)/(sqrt(M)*k)).*erfc(sqrt(((3*k)/(2*(M-1)))*SNRdB)); %rysuje krzywą teoretyczną

end

