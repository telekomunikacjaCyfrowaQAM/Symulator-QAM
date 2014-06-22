function [msg] = word2bin(word)

wordBits = dec2bin(char(word),24) ;
[s b]=size(wordBits);
msg=[];
for i=1:s
    msg=[msg wordBits(i,:)];
end

end
