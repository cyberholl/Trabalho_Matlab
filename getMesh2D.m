function D=getMesh2D(object,Gap)

D=object-1; % creation of new black image but with the information of were was the object (object = 0)
for n=1:Gap:size(D,1) % read all rows
    for m=1:Gap:size(D,2) % read all columns
    D(n,m)=D(n,m)+1; % Increase one in all image in a predefined gap
    end
end
D(D < 1) = 0; % remove unwanted points


end