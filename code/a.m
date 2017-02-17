ab = [66.0709   49.9914;
   66.0709   49.9914;
   53.3573   32.8569;
   33.6362   62.1286;
   33.6362   37.8543;
   53.3573   67.1259;
   43.9312   49.9914]

s = []; %seperation between individual agents
for i = 1:7
   m = zeros(1,2);
   for k = 1:7
       d = ab(i,:)-ab(k,:);
       if d~=0
           m = m + d/(norm(d)^2);
       end
   end
   s(i,:) = m;
end
s