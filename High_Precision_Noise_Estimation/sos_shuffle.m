function [g,ca] = sos_shuffle(sos, fname)

%  SOS_SHUFFLE(SOS,'FNAME') reorganize digital filter coeffs.  
%  [G, CA] = SOS_SHUFFLE(SOS,'FNAME') re-organizes the coefficients
%  of a cascaded, second order section IIR filter, from the
%  order produced by a Matlab sos command, to the order
%  used in real-time C realization (ala Embree). G is the
%  overall gain factor, and CA is a column vector containing
%  the filter coefficients in the order:
%
%        [a11 a21 b11 b21 a12 a22 b12 b22 ... ]
%
%  The b0i are all unity in this convention. If the optional
%  filename fname is included, the coefficients are written
%  to the file fname in the above order, delimited by commas,
%  with the gain factor in the first element, using 15 digits.
%
% $Id: sos_shuffle.m 125 2008-07-31 15:49:03Z seismic $


g = prod(sos(:,1));

b = [sos(:,2)./sos(:,1), sos(:,3)./sos(:,1)];
a = [sos(:,5), sos(:,6)];

ab = [a b];
abT = ab';

ca = abT(:);

if (nargin == 2)
   fid = fopen(fname,'w');
   fprintf(fid,'%15.14f',g);
   fprintf(fid,', %15.14f',ca);
   status = fclose(fid);
end
  