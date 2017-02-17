%%Position function
%Returns random position on regular polygon position
%Usage: rand - random position assignment
%       poly_reg - agents at vertices of regular polygon
%       poly_center - agents @ vertices of N-1 regular polygon & 1 @ center
%       manual - agents at manually set locations

function pos = position(str)
global N Ngrid centerX centerY;
if strcmp(str,'rand')
    pos = 5*Ngrid*rand(N,2); %Random positions for N agents
end

if strcmp( str,'poly_reg')
    pos = poly_gen(N); %see poly_gen function for details
end

if strcmp(str,'poly_center')
    pos = poly_gen(N-1);
    pos = [pos ; centerX,centerY]; 
end

if strcmp( str,'manual')
    pos = [ 50.1 50.1;
   50.2 50.2;
  50.3 50.3;
   50.4 50.4
   50.5 50.5;
   50.6 50.6;
  50.7 50.7;
   50.8 50.8;
   50.9 50.9;
   51 51;
  51.1 51.1;
   51.2 51.2];
end