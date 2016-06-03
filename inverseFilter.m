function b = inverseFilter(Hd, Fs,method, PLOT)

T = 0.15;
[F,w] = freqz(Hd,1,1000,Fs);

if (method==1)
    
    F2 = abs(F) + T;
    F3 = 1./F2;
    %F3 = F3 - min(abs(F3));
    %F3 = F3 ./ max(abs(F3));

    %F3(F3>0.50) = 1;
    %F3(F3<=0.50) = 0.00001;
else
    if (method==2)
        T = 0.050;
        F3(find(abs(F)>T))  = 1./F(find(abs(F)>T));
        F3(find(abs(F)<=T)) = 1./T;
        F3 = F3 - min(abs(F3));
        F3 = F3 ./ max(abs(F3)); 
        M = mean(abs(F3(abs(F3)>0.20)));
        F3 = F3 ./ M;
    
    
    else
        b = 1;
        a = Hd;
    end
    
end

if ((method==1) || (method==2))
    if (PLOT==1)
        figure;
        plot(w, abs(F));
        hold on;
        plot(w, abs(F3),'r');
    end
    [b,a] = invfreqz(F3, 2 * pi * w ./ 16000, length(Hd), 1);
end

if (PLOT==1)
    figure;
    freqz(b,a,1000,Fs);
end
