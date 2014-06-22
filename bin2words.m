function [msg] = bin2words(wordBits)
msg=[];
    for k=1:24:length(wordBits)
    msg = [msg char(bin2dec(wordBits(k:k+23)))];
    end
end
