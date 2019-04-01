x = [1,2,3,4,5,6,7,8,9,1,1,1];
tic
for i = 1:length(x)
    for i = 1:length(x)
        for i = 1:length(x)
            for i = 1:length(x)
                mean(x(i)*4);
            end
        end
    end
end
toc