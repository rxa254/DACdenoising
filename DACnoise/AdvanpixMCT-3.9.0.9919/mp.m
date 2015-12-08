classdef mp
%
%    Multiprecision floating-point numeric type. 
%    Allows computing with any required precision in MATLAB.
%    
%    Detailed User's Manual can be access through:
%    http://www.advanpix.com/documentation/users-manual/
%
%    Complete list of implemented functions:
%    http://www.advanpix.com/documentation/function-reference/
%
%
%    Below we present basic usage rules and examples. 
%
%    ***
%    I. Precision control are done by mp.Digits() function: 
%
%    mp.Digits(34);    % set default precision to 34 decimal digits (quadruple precision)
%    mp.Digits(100);   % set default precision to 100 decimal digits
%
%    ***
%    II. Multiprecision entities are created by using special 'constructor' function:
%
%    mp()    creates multiprecision number of default precision (with zero value).
%    mp(x)   creates multiprecision entity from numeric array, matrix, expression or other mp-object.
%    mp(x,d) creates multiprecision entity of prescribed precision (in decimal digits) 
% 
%    Examples:
%
%    mp.Digits(34);   % set default precision to 34 digits
%
%    a = mp(pi)       % creates 34-digits accurate 'pi' by conversion from built-in constant
%    a = 
%       3.141592653589793238462643383279503
% 
%    b = mp('pi')     % creates 34-digits accurate 'pi' by evaluating expression
%    b = 
%       3.141592653589793238462643383279503
%
%    c = mp('pi',300) % creates 300-digits accurate 'pi' using precision argument
%    c = 
%        3.1415926535897932384626433832795028841971693993751058209749445923
%    0781640628620899862803482534211706798214808651328230664709384460955058
%    2231725359408128481117450284102701938521105559644622948954930381964428
%    8109756659334461284756482337867831652712019091456485669234603486104543
%    2664821339360726024914128
%
%    A = mp(magic(5)); % converts magic square to floating-point matrix of 34-digits precision.
%    
%    B = mp.randn([3,3,3,3]) % creates 4D array of normally distributed pseudo-random numbers.
%
%    ***
%    II. Once created multiprecision objects can be used in calculations exactly the same way 
%    as built-in 'double' or 'single' precision entities:
%
%    [U,S,V] = svd(A);
%    norm(A-U*S*V',1)  
%    ans = 
%          6.08593862426366529565689029856837e-32        
%
%    [V,D] = eig(A);
%    norm(A*V - V*D,1)               
%    ans = 
%          5.238529448733281520312260003831002e-32
%
%    Please check our User's Manual for more examples and details:
%    http://www.advanpix.com/documentation/users-manual/

%    Copyright (c) 2006 - 2015 Advanpix LLC.

    properties (SetAccess = public)
        id
    end % properties
    
    methods(Static)
        
        %% Initialization
        function Init()
        %MP.INIT  Initializes Multiprecision Computing Toolbox.  
        %
        %    MP.INIT Loads and configures Multiprecision Computing Toolbox's core engine  
        %    Called automatically by mpstartup.
        % 
        %    Don't need to be called explicitly by user.         
        %
        %    See also MPSTARTUP
        
            if ispc, fs = '\';
            else     fs = '/';  end

            % Include 'lib' directory into MATLAB's search path
            mctpath = mfilename('fullpath');

            temp = strfind( mctpath, fs );
            mctpath( temp(end) : end ) = [];

            mctlibpath = [mctpath, fs ,'lib'];
            addpath(mctlibpath);
            
            % Initialize toolbox's core engine
            mpimpl(10000, [mctpath, fs]); 
        end
        
        %% Precision manipulation
        function varargout = Digits(varargin)
        %MP.DIGITS Controls default precision of computations.
        % 
        %   MP.DIGITS()  shows current default precision (in decimal digits).
        %   MP.DIGITS(X) shows precision of any multiprecision entity X.         
        %   MP.DIGITS(D) setups default precision to D decimal digits. 
        %   D should be an integer indicating number of decimal digits to
        %   be used in all multiple-precision calculations. 
        %
        %   Internally toolbox uses mp.Digits + mp.GuardDigits decimal digits in all computations.
        %
        %   See also MP.GUARDDIGITS        

            [varargout{1:nargout}] = mpimpl(1,varargin{:});
        end

        function varargout = GuardDigits(varargin)
        %MP.GUARDDIGITS Controls number of guard digits used in computations.
        %
        %   MP.GUARDDIGITS()  shows number of guard digits currently used.
        %   MP.GUARDDIGITS(D) setups number of guard digits to use. 
        %   D should be an integer indicating number of additional decimal digits to
        %   be used in all multiple-precision calculations. 
        % 
        %   Total precision of computations are mp.Digits + mp.GuardDigits
        %
        %   See also MP.DIGITS        
            
             [varargout{1:nargout}] = mpimpl(3,varargin{:});
        end
        
        function varargout = ExtendConstAccuracy(varargin)
        %MP.EXTENDCONSTACCURACY Controls accuracy auto-extension of MATLAB's built-in constants.
        %
        %   MP.EXTENDCONSTACCURACY(true) enables accuracy auto-extension for 'double' precision 
        %   constants (pi, eps, etc.) to match precision selected in the toolbox.
        %
        %   MP.EXTENDCONSTACCURACY(false) disables this feature. 
        % 
        %   Accepts 'true' (default) or 'false' as an argument. 
        %   Returns current settings if called without arguments 
        %
        %   See also MP.DIGITS        
            
             [varargout{1:nargout}] = mpimpl(5,varargin{:});
        end

        function varargout = FollowMatlabNumericFormat(varargin)
        %MP.FOLLOWMATLABNUMERICFORMAT Controls if toolbox follows numeric formatting
        %preferences in MATLAB
        %
        %   MP.FOLLOWMATLABNUMERICFORMAT(true) makes toolbox follow numeric
        %   formatting preferences in MATLAB. 
        % 
        %   MP.FOLLOWMATLABNUMERICFORMAT(false) disables this feature.
        %   Numbers are displayed with all digits of precision.
        % 
        %   Accepts 'true' (default) or 'false' as an argument. 
        %   Returns current settings if called without arguments 
        %
        %    >> format short
        %
        %    >> mp.Digits(50);
        %    >> mp.FollowMatlabNumericFormat(false); % Show all digits
        %    >> mp(pi)
        %
        %    ans = 
        %
        %        3.1415926535897932384626433832795028841971693993751
        %
        %    >> mp.FollowMatlabNumericFormat(true);  % 
        %    >> mp(pi)
        %     
        %    ans = 
        %
        %        3.1416
        % 
        %   See also MP.DIGITS, FORMAT        
            
             [varargout{1:nargout}] = mpimpl(6,varargin{:});
        end
        
        %% Toolbox Information & Unit tests
        function Info()
        %MP.INFO  Dispaly information about Multiprecision Computing Toolbox.  
        %        
        %    mp.Info shows version, build date, credits, license status and other 
        %    information about Multiprecision Computing Toolbox and its components.
        %
        %    See also MP.INIT, MP.TEST, MP.DIGITS, MP.GUARDDIGITS

            mpimpl(4);          
        end

        function Test()
        %MP.TEST Run test suite to check consistency of Multiprecision Computing Toolbox.  
        %
        %    mp.Test() runs comprehensive set of test routines to check functionality and
        %    correctness of the algorithms implemented in Multiprecision Computing Toolbox.
        %
        %    See also MP.INIT
        
            mp.Init(); % Make sure toolbox is loaded
            
            mptest();  % Run tests         
        end
        
        %% Machine epsilon & other precision related constants
        function r = eps( x )
        %MP.EPS Spacing of multiprecision floating point numbers (depends on precision).
        % 
        %    MP.EPS() returns the distance from 1.0 to the next larger floating-point number in current precision.
        %    MP.EPS(x) returns positive distance from abs(x) to the next larger in magnitude multiprecision 
        %    floating point number of the same precision as x.
        %
        %    Precision is controlled by mp.Digits.
        %
        %    Usage of MP.EPS is completely analogous to usage of built-in function EPS.
        %
        %    See also mp.Digits, eps, mp.realmax, mp.realmin
      
            if nargin == 0 || strcmpi('mp',x), r = mpimpl(2000  );          
            elseif isa(x,'mp'),                r = mpimpl(2000,x);        
            else   r = builtin('eps',x);       end 
        end
        
        function r = realmin(varargin)
        %MP.REALMIN Smallest positive floating-point number (depends on precision).
        %
        %     MP.REALMIN returns the smallest positive normalized floating point number for current precision.
        %    Precision is controlled by mp.Digits
        %    
        %    MP.REALMIN is 'safe' meaning 1 / MP.REALMIN does not overflow.
        %
        %    See also mp.Digits, mp.eps, mp.realmax
        
            r = mpimpl(2001);          
        end
        
        function r = realmax()
        %MP.REALMAX Largest finite floating-point number (depends on precision). 
        %
        %    MP.REALMAX returns the largest positive floating-point number for current precision.
        %    Precision is controlled by mp.Digits
        %    
        %    MP.REALMAX is 'safe' meaning 1 / MP.REALMAX does not underflow.        
        %
        %    See also mp.Digits, mp.eps, mp.realmin
        
            r = mpimpl(2002);          
        end
        
        %% Specialized Matrices - with non-mp arguments
        function varargout = hilb(varargin)
        %MP.HILB  Compute Hilbert matrix of required size with arbitrary precision.
        %
        %    Usage of MP.HILB is completely analogous to usage of built-in function HILB.
        %
        %    Precision is controlled by mp.Digits
        %
        %    See also mp.Digits, mp.invhilb, HILB, INVHILB 
        
            [varargout{1:nargout}] = mphilb(varargin{:});            
        end
         
        function varargout = invhilb(varargin)
        %MP.INVHILB  Compute inverse Hilbert matrix of required size with arbitrary precision.
        %
        %    Usage of MP.INVHILB is completely analogous to usage of built-in function INVHILB.
        %
        %    Precision is controlled by mp.Digits
        %
        %    See also mp.Digits, mp.hilb, HILB, INVHILB 
        
            [varargout{1:nargout}] = mpinvhilb(varargin{:});            
        end
        
        %% Gaussian Quadrature
        function [x,w] = GaussLegendre(order, a, b)
        %MP.GAUSSLEGENDRE Compute coefficients of Gauss-Legendre quadrature with arbitrary precision. 
        %
        %    [x,w] = mp.GaussLegendre(order, a, b) computes abscissae
        %    'x' and weights 'w' of Gauss-Legendre quadrature.
        %
        %    The Gauss-Legendre quadrature rule is used as follows:
        %
        %        Integral ( a <= x <= b ) f(x) dx
        %
        %    is to be approximated by
        %
        %        sum ( 1 <= i <= order ) w(i) * f(x(i))        
        %
        %    Parameters:
        %    'order' is the number of points in the quadrature rule.
        %    'a' is the left endpoint (default -1);
        %    'b' is the right endpoint(default +1);        
        %
        %    Precision is controlled by mp.Digits and by precision of the arguments
        %
        %    See also MP.GAUSSJACOBI, MP.GAUSSLAGUERRE, MP.GAUSSHERMITE, MP.GAUSSCHEBYSHEVTYPE1, MP.GAUSSCHEBYSHEVTYPE2, MP.GAUSSGEGENBAUER
        
            if nargin < 3,          b     = mp('+1');
                if nargin < 2,      a     = mp('-1');
                    if nargin < 1
                    error(  'MCT:GaussLegendre:NotEnoughInputs',...
                            'Not enough input arguments.' );
                    end  
                end
            end
            
            if ~ismp(a), a = mp(a); end;
            if ~ismp(b), b = mp(b); end;
        
            % Compute nodes & weights for default interval: [-1,1]
            [x0, w0] = mpimpl(5000, order);
            
            % Scale coefficients for arbitrary interval: [a,b]
            d = (b - a)/2;
            c = (b + a)/2;
            
            x = d * x0' + c;
            w = d * w0';
        end
        
        function [x,w] = GaussChebyshevType1(order, a, b)
        %MP.GAUSSCHEBYSHEVTYPE1 Compute coefficients of Gauss-Chebyshev Type 1 quadrature with arbitrary precision 
        %
        %    [x,w] = mp.GaussChebyshevType1(order, a, b) computes abscissas
        %    'x' and weights 'w' of Gauss-Chebyshev Type 1 quadrature.
        %
        %    The Gauss-Chebyshev Type 1 quadrature rule is used as follows:
        %
        %        Integral ( a <= x <= b ) f(x) / sqrt ( ( x - a ) * ( b - x ) ) dx
        %
        %    is to be approximated by
        %
        %        sum ( 1 <= i <= order ) w(i) * f(x(i))        
        %
        %    Parameters:
        %    'order' is the number of points in the quadrature rule.
        %    'a' is the left endpoint (default -1);
        %    'b' is the right endpoint(default +1);        
        %
        %    Precision is controlled by mp.Digits and by precision of the arguments
        %
        %    See also MP.GAUSSLEGENDRE, MP.GAUSSJACOBI, MP.GAUSSLAGUERRE, MP.GAUSSHERMITE, MP.GAUSSCHEBYSHEVTYPE2, MP.GAUSSGEGENBAUER
        
        %    References:
        %    J. Burkardt, Gauss-Chebyshev Type 1 Quadrature:
        %       http://people.sc.fsu.edu/~jburkardt/m_src/chebyshev1_rule/chebyshev1_rule.html
        
            if nargin < 3,          b     = mp('+1');
                if nargin < 2,      a     = mp('-1');
                    if nargin < 1
                    error(  'MCT:GaussChebyshevType1:NotEnoughInputs',...
                            'Not enough input arguments.' );
                    end  
                end
            end
            
            if ~ismp(a), a = mp(a); end;
            if ~ismp(b), b = mp(b); end;
        
            [x,w] = mpgaussrules(2, order, 0, 0, a, b);
        end

        function [x,w] = GaussGegenbauer(order, alpha, a, b)
        %MP.GAUSSGEGENBAUER Compute coefficients of Gauss-Gegenbauer quadrature with arbitrary precision
        %
        %    [x,w] = mp.GaussGegenbauer(order, alpha, a, b) computes abscissas
        %    'x' and weights 'w' of Gauss-Gegenbauer quadrature.
        %
        %    The Gauss-Gegenbauer quadrature rule is used as follows:
        %
        %        Integral ( a <= x <= b ) f(x) * ( ( x - a ) * ( b - x ) )^alpha dx
        %
        %    is to be approximated by
        %
        %        sum ( 1 <= i <= order ) w(i) * f(x(i))        
        %
        %    Parameters:
        %    'order' is the number of points in the quadrature rule.
        %    'alpha' is the exponent, which must be greater than -1 (default 1).
        %    'a' is the left endpoint (default -1);
        %    'b' is the right endpoint(default +1);        
        %
        %    Precision is controlled by mp.Digits and by precision of the arguments
        %
        %    See also MP.GAUSSLEGENDRE, MP.GAUSSJACOBI, MP.GAUSSLAGUERRE, MP.GAUSSHERMITE, MP.GAUSSCHEBYSHEVTYPE1, MP.GAUSSCHEBYSHEVTYPE2
        
        %    References:
        %    J. Burkardt, Gauss-Gegenbauer Quadrature:
        %       http://people.sc.fsu.edu/~jburkardt/m_src/gegenbauer_rule/gegenbauer_rule.html

            if nargin < 4,          b     = mp('+1');
                if nargin < 3,      a     = mp('-1');
                    if nargin < 2,  alpha = mp('1');                    
                        if nargin < 1
                        error(  'MCT:GaussGegenbauer:NotEnoughInputs',...
                                'Not enough input arguments.' );
                        end  
                    end
                end
            end
            
            if ~ismp(alpha), alpha = mp(alpha); end;
            if ~ismp(a), a = mp(a); end;
            if ~ismp(b), b = mp(b); end;
        
            [x,w] = mpgaussrules(3, order, alpha, 0, a, b);
        end
        
        function [x,w] = GaussJacobi(order, alpha, beta, a, b)
        %MP.GAUSSJACOBI Compute coefficients of Gauss-Jacobi quadrature with arbitrary precision
        %
        %    [x,w] = mp.GaussJacobi(order, alpha, beta, a, b) computes abscissas
        %    'x' and weights 'w' of Gauss-Jacobi quadrature.
        %
        %    The Gauss-Jacobi quadrature rule is used as follows:
        %
        %        Integral ( a <= x <= b ) (b-x)^alpha (x-a)^beta f(x) dx
        %
        %    is to be approximated by
        %
        %        sum ( 1 <= i <= order ) w(i) * f(x(i))        
        %
        %    Parameters:
        %    'order' is the number of points in the quadrature rule.
        %    'alpha' is the value of the exponent of (b-x), which must be greater than -1 (default 1).
        %    'beta' is the value of the exponent of (x-a), which must be greater than -1 (default 0).
        %    'a' is the left endpoint (default -1);
        %    'b' is the right endpoint(default +1);        
        %
        %    Precision is controlled by mp.Digits and by precision of the arguments
        %
        %    See also MP.GAUSSLEGENDRE, MP.GAUSSLAGUERRE, MP.GAUSSHERMITE, MP.GAUSSCHEBYSHEVTYPE1, MP.GAUSSCHEBYSHEVTYPE2, MP.GAUSSGEGENBAUER
        
        %    References:
        %    J. Burkardt, Gauss-Jacobi Quadrature:
        %       http://people.sc.fsu.edu/~jburkardt/m_src/jacobi_rule/jacobi_rule.html

            if nargin < 5,              b     = mp('+1');
                if nargin < 4,          a     = mp('-1');
                    if nargin < 3,      beta  = mp('0');                    
                        if nargin < 2,  alpha = mp('1');                    
                            if nargin < 1
                            error(  'MCT:GaussJacobi:NotEnoughInputs',...
                                    'Not enough input arguments.' );
                            end  
                        end
                    end
                end
            end
            
            if ~ismp(alpha), alpha = mp(alpha); end;
            if ~ismp(beta),  beta  = mp(beta); end;    
            if ~ismp(a), a = mp(a); end;
            if ~ismp(b), b = mp(b); end;
        
            [x,w] = mpgaussrules(4, order, alpha, beta, a, b);
        end
        
        function [x,w] = GaussLaguerre(order, alpha, a, b)
        %MP.GAUSSLAGUERRE Compute coefficients of Generalized Gauss-Laguerre quadrature with arbitrary precision
        %
        %    [x,w] = mp.GaussLaguerre(order, alpha, a, b) computes abscissas
        %    'x' and weights 'w' of Generalized Gauss-Laguerre quadrature.
        %
        %    The generalized Gauss Hermite quadrature rule is used as follows:
        %
        %        Integral ( a < x < +inf ) (x-a)^alpha * exp(-b*(x - a)) f(x) dx
        %      
        %    is to be approximated using 'x' and 'w' by
        %
        %         sum ( 1 <= i <= order ) w(i) * f(x(i))      
        %
        %    Parameters:
        %    'order' is the number of points in the quadrature rule.
        %    'alpha' is the exponent of |x| in the weight function. 
        %           The value of alpha may be any real value greater than -1.0. 
        %           Specifying alpha = 0.0 (default) results in the basic (non-generalized) rule.
        %    'a' is the left point (default 0);
        %    'b' is the scale factor in the exponential (default 1);        
        %
        %    Precision is controlled by mp.Digits and by precision of the arguments
        %
        %    See also MP.GAUSSLEGENDRE, MP.GAUSSJACOBI, MP.GAUSSHERMITE, MP.GAUSSCHEBYSHEVTYPE1, MP.GAUSSCHEBYSHEVTYPE2, MP.GAUSSGEGENBAUER       
        
        %    References:
        %    J. Burkardt, Generalized Gauss-Laguerre Quadrature Rules:
        %       http://people.sc.fsu.edu/~jburkardt/m_src/gen_laguerre_rule/gen_laguerre_rule.html
        
            if nargin < 4,          b     = mp('1');
                if nargin < 3,      a     = mp('0');
                    if nargin < 2,  alpha = mp('0');
                        if nargin < 1
                        error(  'MCT:GaussLaguerre:NotEnoughInputs',...
                                'Not enough input arguments.' );
                        end  
                    end
                end
            end
            
            if ~ismp(alpha), alpha = mp(alpha); end;
            if ~ismp(a), a = mp(a); end;
            if ~ismp(b), b = mp(b); end;
       
            [x,w] = mpgaussrules(5, order, alpha, 0, a, b);
        end
        
        function [x,w] = GaussHermite(order, alpha, a, b)
        %MP.GAUSSHERMITE Compute coefficients of Generalized Gauss-Hermite quadrature with arbitrary precision
        %
        %    [x,w] = mp.GaussHermite(order, alpha, a, b) computes abscissas
        %    'x' and weights 'w' of Generalized Gauss-Hermite quadrature.
        %
        %    The generalized Gauss Hermite quadrature rule is used as follows:
        %
        %        Integral ( -inf < x < +inf ) |x-a|^alpha * exp( - b * ( x - a)^2 ) f(x) dx
        %      
        %    is to be approximated using 'x' and 'w' by
        %
        %         sum ( 1 <= i <= order ) w(i) * f(x(i))      
        %
        %    Parameters:
        %    'order' is the number of points in the quadrature rule.
        %    'alpha' is the parameter for the generalized Gauss-Hermite quadrature rule. 
        %           The value of alpha may be any real value greater than -1.0. 
        %           Specifying alpha = 0.0 (default) results in the basic (non-generalized) rule.
        %    'a' is the center point (default 0);
        %    'b' is the scale factor (default 1);        
        %
        %    Precision is controlled by mp.Digits and by precision of the arguments
        %
        %    See also MP.GAUSSLEGENDRE, MP.GAUSSJACOBI, MP.GAUSSLAGUERRE, MP.GAUSSCHEBYSHEVTYPE1, MP.GAUSSCHEBYSHEVTYPE2, MP.GAUSSGEGENBAUER
        
        %    References:
        %    J. Burkardt, Generalized Gauss-Hermite Quadrature Rules:
        %       http://people.sc.fsu.edu/~jburkardt/m_src/gen_hermite_rule/gen_hermite_rule.html
        
            if nargin < 4,          b     = mp('1');
                if nargin < 3,      a     = mp('0');
                    if nargin < 2,  alpha = mp('0');
                        if nargin < 1
                        error(  'MCT:GaussHermite:NotEnoughInputs',...
                                'Not enough input arguments.' );
                        end  
                    end
                end
            end
            
            if ~ismp(alpha), alpha = mp(alpha); end;
            if ~ismp(a), a = mp(a); end;
            if ~ismp(b), b = mp(b); end;
       
            [x,w] = mpgaussrules(6, order, alpha, 0, a, b);
        end
        
        function [x,w] = GaussChebyshevType2(order, a, b)
        %MP.GAUSSCHEBYSHEVTYPE1 Compute coefficients of Gauss-Chebyshev Type 2 quadrature with arbitrary precision
        %
        %    [x,w] = mp.GaussChebyshevType2(order, a, b) computes abscissas
        %    'x' and weights 'w' of Gauss-Chebyshev Type 2 quadrature.
        %
        %    The Gauss-Chebyshev Type 2 quadrature rule is used as follows:
        %
        %        Integral ( a <= x <= b ) f(x) * sqrt ( ( x - a ) * ( b - x ) ) dx
        %
        %    is to be approximated by
        %
        %        sum ( 1 <= i <= order ) w(i) * f(x(i))        
        %
        %    Parameters:
        %    'order' is the number of points in the quadrature rule.
        %    'a' is the left endpoint (default -1);
        %    'b' is the right endpoint(default +1);        
        %
        %    Precision is controlled by mp.Digits and by precision of the arguments
        %
        %    See also MP.GAUSSLEGENDRE, MP.GAUSSJACOBI, MP.GAUSSLAGUERRE, MP.GAUSSHERMITE, MP.GAUSSCHEBYSHEVTYPE1, MP.GAUSSGEGENBAUER       
        
        %    References:
        %    J. Burkardt, Gauss-Chebyshev Type 2 Quadrature:
        %       http://people.sc.fsu.edu/~jburkardt/m_src/chebyshev1_rule/chebyshev2_rule.html
        
            if nargin < 3,          b     = mp('+1');
                if nargin < 2,      a     = mp('-1');
                    if nargin < 1
                    error(  'MCT:GaussChebyshevType2:NotEnoughInputs',...
                            'Not enough input arguments.' );
                    end  
                end
            end
            
            if ~ismp(a), a = mp(a); end;
            if ~ismp(b), b = mp(b); end;
        
            [x,w] = mpgaussrules(9, order, 0, 0, a, b);
        end
       
        function varargout = BernoulliNumber(n)
        %MP.BERNOULLINUMBER Compute Bernoulli numbers with arbitrary precision.   
        %
        %    B = mp.BernoulliNumber(n) computes n-th Bernoulli number(s) with
        %    any required accuracy. n can be a vector.
        %
        %    Precision is controlled by MP.DIGITS
        %
        %    See also MP.DIGITS        
        
            [varargout{1:nargout}] = mpimpl(417, n);
        end

        %% Formatted output (internal) functions
        function [matchstring, tokenname, splitstring] = parseSpecifiers(formatSpec)
        % PARSESPECIFIERS Parses format specifiers in the format string.
        %
        %    Parses only valid format specifiers (with valid types, etc.)
        % 
        %    Do not call it explicitely.
        %    Needed for implementation of full-featured SPRINTF/NUM2STR.
        %
        %    See also SPRINTF, NUM2STR.
        %
        %    I. DevNotes for the future:
        %    This regexp covers extended printf formatting including all the
        %    MATLAB's extensions like 'identifier', e.g. %1$*5$.*2$, etc.:
        %    
        %    (?<!%)(?:%%)*%(?!%)(?:(\d+)\$)?([\+-\s#]?)(?:(?:\*+(\d+)\$)|(\d*))?(\.)?(?:(?:\*+(\d+)\$)|(\d*))?([diuoxXfeEgGcs]|(?:bx|bX|bo|bu|tx|tX|to|tu))
        %     
        %    By fields:
        %    (?<!%)(?:%%)*%(?!%)
        %    (?:(\d+)\$)?
        %    ([\+-\s#]?)
        %    (?:(?:\*+(\d+)\$)|(\d*))?
        %    (\.)?
        %    (?:(?:\*+(\d+)\$)|(\d*))?
        %    ([diuoxXfeEgGcs]|(?:bx|bX|bo|bu|tx|tX|to|tu))
        %    
        %    Explanations on capturing groups:
        %    group 1 (id)      : (\d+)
        %    group 2 (flag)    : ([\+-\s#]?)
        %    group 3 (width_id): (\d+)
        %    group 4 (width)   : (\d*)
        %    group 5           : (\.)
        %    group 6 (prec_id) : (\d+)
        %    group 7 (prec)    : (\d*)
        %    group 8 (type)    : ([diuoxXfeEgGcs]|(?:bx|bX|bo|bu|tx|tX|to|tu))
        %     
        %    However MATLAB has handicapped regexp support. Nested groups (tokens) are not supported
        %    This makes impossible to use short and elagant regexps as above :(.
        %    Maybe we will implement this on C++ level in future.
        %
        %    II. Current Implementation
        %    Due to limitations of MATLAB, now we support only standard
        %    printf specification:
        %    %[flag][width][.precision]type
        %    flag: +, -, space, # 
        %    width, precision - numbers
        %    Example: %e, %.15f, etc
        %    (?<!%)(?:%%)*%(?!%)([\+-\s#]?)(\d*)(\.)?(\d*)([diuoxXfeEgGcs]|(?:bx|bX|bo|bu|tx|tX|to|tu))
        %    
        %    Explanations on capturing groups:            
        %    group 1 (flag) : ([\+-\s#]?)
        %    group 2 (width): (\d*)
        %    group 3        : (\.)
        %    group 4 (prec) : (\d*)
        %    group 5 (type) : ([diuoxXfeEgGcs]|(?:bx|bX|bo|bu|tx|tX|to|tu))
        
            regexp_start  = '(?<!%)(?:%%)*%(?!%)';  
            regexp_flag   = '(?<flag>[\+-\s#]?)';
            regexp_width  = '(?<width>\d*)';
            regexp_dot    = '(?<dot>\.?)';
            regexp_prec   = '(?<prec>\d*)';
            regexp_type   = '(?<type>[diuoxXfeEgGcs]|(?:bx|bX|bo|bu|tx|tX|to|tu|ld|li|lo|lu|lx|lX|hd|hi|ho|hu|hx|hX))';
            
            expr = [regexp_start, regexp_flag, regexp_width, regexp_dot, regexp_prec, regexp_type];
            [matchstring, tokenname, splitstring] = regexp(formatSpec, expr, 'match', 'names', 'split');
        end
        
        function varargout = sprintf_basic(varargin)
        % SPRINTF_BASIC Basic implementation of sprintf.
        %
        %    Do not call it explicitely.
        %    Needed for implementation of full-featured SPRINTF/NUM2STR.
        %
        %    See also SPRINTF, NUM2STR.
        
            [matchstring, tokenname, splitstring] = mp.parseSpecifiers(varargin{1});
         
            % Process every format, find corresponding argument, convert to
            % string if argument of 'mp' type. Replace corresponding format
            % to '%s'
            offs = 1;            
            varargin{offs} = '';  % New format string
            for i=1:min(size(matchstring, 2),nargin-1)
                    
                if isa(varargin{offs + i}, 'mp')
                    
                   % Process 'mp' objects separately
                   
                   % 1. Analyse [flag][width][precision]type fields in future
                   % using tokenname array of structures
                   
                   % 1.1 Use default format '%e' for unsupported specifiers
                   unsupported_types = '([diuoxXcs]|(?:bx|bX|bo|bu|tx|tX|to|tu|ld|li|lo|lu|lx|lX|hd|hi|ho|hu|hx|hX))';
                   
                   index = regexp(tokenname(i).type, unsupported_types);
                   if( size(index) ~= 0)
                       
                       % In case of %i or %d we use %e for numbers with fractional part
                       % Otherwise (if fractional part exists) we use %g which gives
                       % correct result for integers, as required.
                       x = varargin{offs + i};
                       if ~isequal(x, fix(x)), modifiedFormat = regexprep(matchstring{i},unsupported_types,'e');
                       else                    modifiedFormat = regexprep(matchstring{i},unsupported_types,'g'); end
                       
                       varargin{offs + i} = num2str(varargin{offs + i}, modifiedFormat);                       
                   else
                       varargin{offs + i} = num2str(varargin{offs + i}, matchstring{i});   
                   end
                  
                   % Use '%s' for converted 'mp' objects
                   varargin{offs} = [varargin{offs}, splitstring{i}, '%s'];
                else
                    
                   % Leave other arguments unchanged
                   varargin{offs} = [varargin{offs}, splitstring{i}, matchstring{i}];
                end
            end
            
            % Add last split & re-write format string to a new one
            varargin{offs} = [varargin{offs}, splitstring{end}];
            
            % Call standard fprintf
            [varargout{1:nargout}] = sprintf(varargin{:});
        end
        
    end  % Static
    
    % class operators and functions
    methods
        
        %% Constructor
        function this = mp(x, precision)
        %MP Create multiprecision floating-point entity (number, matrix, n-dim array) of required precision.
        %
        %    mp()    creates multiprecision number of default precision (with zero value).
        %    mp(x)   creates multiprecision entity from numeric array, matrix, expression or other mp-object.
        %    mp(x,d) creates multiprecision entity of prescribed precision (in decimal digits) 
        % 
        %    Examples:
        %
        %    mp.Digits(34);   % set default precision to 34 digits (quadruple precision)
        %
        %    a = mp(pi)       % creates 34-digits accurate 'pi' by conversion from built-in constant
        %    a = 
        %       3.141592653589793238462643383279503
        % 
        %    b = mp('pi')     % creates 34-digits accurate 'pi' by evaluating expression in default precision
        %    b = 
        %       3.141592653589793238462643383279503
        %
        %    c = mp('pi',300) % creates 300-digits accurate 'pi' using precision argument
        %    c = 
        %        3.1415926535897932384626433832795028841971693993751058209749445923
        %    0781640628620899862803482534211706798214808651328230664709384460955058
        %    2231725359408128481117450284102701938521105559644622948954930381964428
        %    8109756659334461284756482337867831652712019091456485669234603486104543
        %    2664821339360726024914128
        %
        %    A = mp(magic(5)); % converts magic square to floating-point matrix of 34-digits precision.
        %    
        %    B = mp.randn([3,3,3,3]) % creates 4D array of normally distributed pseudo-random numbers.
        %
        %    ***
        %    Once created multiprecision objects can be used in calculations exactly the same way 
        %    as built-in 'double' or 'single' precision entities:
        %
        %    [U,S,V] = svd(A);
        %    norm(A-U*S*V',1)  
        %    ans = 
        %          6.08593862426366529565689029856837e-32        
        %
        %    Please check our User's Manual for more examples and details:
        %    http://www.advanpix.com/documentation/users-manual/
        %
        %    See also MP.DIGITS        

           if nargin == 0,     this.id = mpimpl(0);             % create mp-entity of default precision
           elseif nargin == 1, this    = mpimpl(0,x);           % create mp-entity from numeric array, expression or other mp object.     
           else                this    = mpimpl(0,x,precision); % create mp-entity of prescribed precision
           end 
        end % constructor
        
        %% Indexing operations
        function ind = subsindex(this)
        %SUBSINDEX Subscript indexing with object
        % 
        %  Convert the mp-object a to double format to be used
        %  as an index in an indexing expressions.
        
           ind = double(this)-1;
        end        
    
        function varargout = subsref(varargin)
        %SUBSREF Subscripted reference, B = A(S), or B = subsref(A,S)
        %
        %    Usage is identical to built-in function SUBSREF.
        %
        %    See also SUBSREF.
        
             [varargout{1:nargout}] = mpimpl(170, varargin{:});               
        end

        function varargout = subsasgn(varargin)
        %SUBSASGN Subscripted assignment, A(S) = B, or A = subsasgn(A,S,B)
        %
        %    Usage is identical to built-in function SUBSASGN.
        %
        %    See also SUBSASGN.
        
             if ~isa(varargin{3}, 'mp'), varargin{3} = mp(varargin{3}); end;
             [varargout{1:nargout}] = mpimpl(171, varargin{:});
        end
         
        function varargout = size(varargin)
        %SIZE Array dimensions
        %
        %    Usage is identical to built-in function SIZE.
        %
        %    See also SIZE.

            [varargout{1:nargout}] = mpimpl(172, varargin{:});  
        end
        
        function out = length(obj)
        %LENGTH Length of vector or largest array dimension
        %
        %    Usage is identical to built-in function LENGTH.
        %
        %    See also LENGTH.
        
            out = max(size(obj));            
        end

        function varargout = end(varargin)
        %END Last index of array
        %
        %    Usage is identical to built-in function END.
        %
        %    See also END.

            [varargout{1:nargout}] = mpimpl(175, varargin{:});              
        end
        
        function varargout = numel(varargin)
        %NUMEL Number of array elements
        %
        %    Usage is identical to built-in function NUMEL.
        %
        %    See also NUMEL.
                        
            A = varargin{1};            
            if nargin > 1
                S = struct('type','()','subs',[]);
                S.subs = varargin(2:nargin);
                [varargout{1:nargout}] = mpimpl(173, A, S);                  
            else
                [varargout{1:nargout}] = mpimpl(173, A);                                  
            end    
        end
         
        function varargout = ndims(varargin)
        %NDIMS Number of array dimensions
        %
        %    Usage is identical to built-in function NDIMS.
        %
        %    See also NDIMS.
        
             [varargout{1:nargout}] = mpimpl(174, varargin{:});
        end

        function varargout = cat(varargin)
        %CAT Concatenate arrays along specified dimension
        %
        %    Usage is identical to built-in function CAT.
        %
        %    See also CAT.
        
            for i=2:nargin, if ~isa(varargin{i}, 'mp'), varargin{i} = mp(varargin{i}); end; end
            [varargout{1:nargout}] = mpimpl(177, varargin{:});
        end

        function varargout = reshape(varargin)
        %RESHAPE Reshape array
        %
        %    Usage is identical to built-in function RESHAPE.
        %
        %    See also RESHAPE.
        
            [varargout{1:nargout}] = mpimpl(178, varargin{:});
        end

        function varargout = vertcat(varargin)
        %VERTCAT Concatenate arrays vertically
        %
        %    Usage is identical to built-in function VERTCAT.
        %
        %    See also VERTCAT.
        
            [varargout{1:nargout}] = cat(1,varargin{:});
        end

        function varargout = horzcat(varargin)
        %HORZCAT Concatenate arrays horizontally
        %
        %    Usage is identical to built-in function HORZCAT.
        %
        %    See also HORZCAT.
       
            [varargout{1:nargout}] = cat(2,varargin{:});
        end
        
        function varargout = permute(varargin)
        %PERMUTE Rearrange dimensions of N-D array
        %
        %    Usage is identical to built-in function PERMUTE.
        %
        %    See also PERMUTE.
        
             [varargout{1:nargout}] = mpimpl(179, varargin{:});               
        end

        function a = ipermute(b,order)
        %IPERMUTE Inverse permute dimensions of N-D array
        %
        %    Usage is identical to built-in function IPERMUTE.
        %
        %    See also IPERMUTE.
        
            inverseorder(order) = 1:numel(order);
            a = permute(b,inverseorder);
        end
        
        function varargout = bsxfun(varargin)
        %BSXFUN  Binary Singleton Expansion Function
        %
        %    Usage is identical to built-in function BSXFUN.
        %
        %    See also BSXFUN.

            [varargout{1:nargout}] = mpbsxfun(varargin{:});            
        end
        
        function varargout = rot90(varargin)
        %ROT90 Rotate array 90 degrees.
        %
        %    Usage is identical to built-in function ROT90.
        %
        %    See also ROT90.
        
             [varargout{1:nargout}] = mprot90(varargin{:});               
        end
        
        function varargout = squeeze(varargin)
        %SQUEEZE Remove singleton dimensions.
        %
        %    Usage is identical to built-in function SQUEEZE.
        %
        %    See also SQUEEZE.
        
             [varargout{1:nargout}] = mpsqueeze(varargin{:});               
        end

        function varargout = shiftdim(varargin)
        %SHIFTDIM Shift dimensions.
        %
        %    Usage is identical to built-in function SHIFTDIM.
        %
        %    See also SQUEEZE.
        
             [varargout{1:nargout}] = mpshiftdim(varargin{:});               
        end

        function varargout = circshift(varargin)
        %CIRCSHIFT Shift array circularly.
        %
        %    Usage is identical to built-in function CIRCSHIFT.
        %
        %    See also FFTSHIFT, SHIFTDIM, PERMUTE.
        
             [varargout{1:nargout}] = mpcircshift(varargin{:});               
        end
        
        function varargout = blkdiag(varargin)
        %BLKDIAG Block diagonal concatenation of matrix input arguments.
        %
        %    Usage is identical to built-in function BLKDIAG.
        %
        %    See also BLKDIAG.
        
             [varargout{1:nargout}] = mpblkdiag(varargin{:});               
        end
        
        %% Basic Information
        function display(x)
        %DISPLAY Display multiprecision entity
        %
        %    Usage is identical to built-in function DISPLAY.
        %
        %    See also DISPLAY.
        
            disp(mpimpl(2,x,inputname(1)));
        end
        
        function disp(x)
        %DISP Display multiprecision entity        
        %
        %    Usage is identical to built-in function DISP.
        %
        %    See also DISP.
        
            disp(mpimpl(2,x,inputname(1)));
        end
        
        function r = isnan(x)
        %ISNAN Array elements that are NaN
        %
        %    Usage is identical to built-in function ISNAN.
        %
        %    See also ISNAN.
        
           r = mpimpl(800,x); 
        end
        
        function r = isinf(x)
        %ISINF Array elements that are INF        
        %
        %    Usage is identical to built-in function ISINF.
        %
        %    See also ISINF.
        
           r = mpimpl(801,x); 
        end
        
        function r = isfinite(x)
        %ISFINITE Array elements that are finite
        %
        %    Usage is identical to built-in function ISFINITE.
        %
        %    See also ISFINITE.
        
           r = mpimpl(802,x); 
        end
        
        function r = isnumeric(x)
        %ISNUMERIC Determine if input is numeric array
        %
        %    Usage is identical to built-in function ISNUMERIC.
        %
        %    See also ISNUMERIC.
        
           r = true; 
        end

        function r = isinteger(x)
        %ISINTEGER True for arrays of integer data type.
        %
        %    Usage is identical to built-in function ISINTEGER.
        %
        %    See also ISA, ISNUMERIC, ISFLOAT.
        
           r = false; 
        end
        
        function r = isfloat(x)
        %ISFLOAT Determine if input is floating-point array
        %
        %    Usage is identical to built-in function ISFLOAT.
        %
        %    See also ISFLOAT.
        
           r = true; 
        end
        
        function r = isempty(x)
        %ISEMPTY Determine whether array is empty
        %
        %    Usage is identical to built-in function ISEMPTY.
        %
        %    See also ISEMPTY.
        
           r = numel(x) == 0; 
        end
               
        %% Arithemtic operators        
        function r = minus(x,y)
        %MINUS Minus
        %
        %    Usage is identical to built-in function MINUS.
        %
        %    See also MINUS.
        
           r = mpimpl(10,x,y); 
        end
        
        function r = plus(x,y)
        %PLUS Plus
        %
        %    Usage is identical to built-in function PLUS.
        %
        %    See also PLUS.
        
           r = mpimpl(11,x,y); 
        end
        
        function r = uplus(x)
        %UPLUS Unary plus
        %
        %    Usage is identical to built-in function UPLUS.
        %
        %    See also UPLUS.
        
           r = mpimpl(150,x); 
        end
        
        function r = uminus(x)
        %UMINUS Unary minus
        %
        %    Usage is identical to built-in function UMINUS.
        %
        %    See also UMINUS.
        
           r = mpimpl(160,x); 
        end

        function r = times(x,y)
        %TIMES Array multiply
        %
        %    Usage is identical to built-in function TIMES.
        %
        %    See also TIMES.
        
           r = mpimpl(15,x,y);
        end
       
        function r = mtimes(x,y)
        %MTIMES Matrix multiplication
        %
        %    Usage is identical to built-in function MTIMES.
        %
        %    See also MTIMES.
        
           r = mpimpl(20,x,y); 
        end
        
        function r = rdivide(x,y)
        %RDIVIDE Right array division
        %
        %    Usage is identical to built-in function RDIVIDE.
        %
        %    See also RDIVIDE.
        
           r = mpimpl(25,x,y); 
        end
        
        function r = ldivide(x,y)
        %LDIVIDE Left array division
        %
        %    Usage is identical to built-in function LDIVIDE.
        %
        %    See also LDIVIDE.
        
           r = mpimpl(30,x,y); 
        end
        
        function r = mrdivide(x,y)
        %MRDIVIDE Solve systems of linear equations xA = B for x
        %
        %    Usage is identical to built-in function MRDIVIDE.
        %
        %    See also MRDIVIDE.
        
           r = mpimpl(35,x,y); 
        end
        
        function r = mldivide(x,y)
        %MLDIVIDE Solve systems of linear equations Ax = B for x
        %
        %    Usage is identical to built-in function MLDIVIDE.
        %
        %    See also MLDIVIDE.
        
           r = mpimpl(40,x,y); 
        end
        
        function r = mpower(x,y)
        %MPOWER Matrix power
        %
        %    Usage is identical to built-in function MPOWER.
        %
        %    See also MPOWER.
        
            if ~isscalar(x) && ~isscalar(y)
                error('MCT:mpower:IncorrectInputs',...
                           'Inputs must be a scalar and a square matrix.' );
                
            end
        
            if isscalar(x) && ~isscalar(y)
                 r = expm(log(x)*y);
            end
            
            if ~isscalar(x) && isscalar(y)
                if isreal(y) && y >= 0 && fix(y) == y
                    % use optimized binary squaring
                    r = mpimpl(45,x,y);
                else
                    r = expm(logm(x)*y);
                end
            end
            
            if isscalar(x) && isscalar(y)            
                r = mpimpl(310,x,y); 
            end
        end
        
        function r = ctranspose(x)
        %CTRANSPOSE Complex conjugate transpose
        %
        %    Usage is identical to built-in function CTRANSPOSE.
        %
        %    See also CTRANSPOSE.
        
           r = mpimpl(50,x); 
        end
        
        function r = transpose(x)
        %TRANSPOSE Transpose
        %
        %    Usage is identical to built-in function TRANSPOSE.
        %
        %    See also TRANSPOSE.
        
           r = mpimpl(55,x); 
        end

        function varargout = colon(varargin)
        %COLON Create vectors, array subscripting, and for-loop iterators
        %
        %    Usage is identical to built-in function COLON.
        %
        %    See also COLON.
        
             [varargout{1:nargout}] = mpimpl(400, varargin{:});               
        end
        
        %% Type Conversion
        function r = double(x)
        %DOUBLE Convert to double precision.
        %
        %    Usage is identical to built-in function DOUBLE.
        %
        %    See also DOUBLE.
        
           r = mpimpl(402,x); 
        end
        
        function r = single(x)
        %SINGLE Convert to single precision.
        %
        %    Usage is identical to built-in function SINGLE.
        %
        %    See also SINGLE.
        
           r =  mpimpl(9000,x); 
        end
        
        function r = int8(x)
        %INT8 Convert to signed 8-bit integer.
        %
        %    Usage is identical to built-in function INT8.
        %
        %    See also INT8.
        
           r =  mpimpl(9010,x);  
        end
        
        function r = uint8(x)
        %UINT8 Convert to unsigned 8-bit integer.
        %
        %    Usage is identical to built-in function UINT8.
        %
        %    See also UINT8.
        
           r = mpimpl(9015,x); 
        end
        
        function r = int16(x)
        %INT16 Convert to signed 16-bit integer.
        %
        %    Usage is identical to built-in function INT16.
        %
        %    See also INT16.
        
           r = mpimpl(9020,x); 
        end
        
        function r = uint16(x)
        %UINT16 Convert to unsigned 16-bit integer.
        %
        %    Usage is identical to built-in function UINT16.
        %
        %    See also UINT16.
        
           r = mpimpl(9025,x);  
        end
        
        function r = int32(x)
        %INT32 Convert to signed 32-bit integer.
        %
        %    Usage is identical to built-in function INT32.
        %
        %    See also INT32.
        
           r = mpimpl(9030,x);  
        end
        
        function r = uint32(x)
        %UINT32 Convert to unsigned 32-bit integer.
        %
        %    Usage is identical to built-in function UINT32.
        %
        %    See also UINT32.
        
           r = mpimpl(9035,x); 
        end
        
        function r = int64(x)
        %INT64 Convert to signed 64-bit integer.
        %
        %    Usage is identical to built-in function INT64.
        %
        %    See also INT64.
        
           r = mpimpl(9040,x);  
        end
        
        function r = uint64(x)
        %UINT64 Convert to unsigned 64-bit integer.
        %
        %    Usage is identical to built-in function UINT64.
        %
        %    See also UINT64.
        
           r = mpimpl(9045,x); 
        end
       
        %% Trigonometric Functions
        function r = sin(x) 
        %SIN Sine of argument in radians.
        %
        %    Usage is identical to built-in function SIN.
        %
        %    See also SIN.
        
            r = mpimpl(200,x); 
        end
        
        function r = cos(x)
        %COS Cosine of argument in radians.
        %
        %    Usage is identical to built-in function COS.
        %
        %    See also COS.
        
           r = mpimpl(201,x); 
        end
        
        function r = tan(x)
        %TAN Tangent of argument in radians.
        %
        %    Usage is identical to built-in function TAN.
        %
        %    See also TAN.
        
           r = mpimpl(202,x); 
        end
        
        function r = sec(x)
        %SEC Secant of argument in radians.
        %
        %    Usage is identical to built-in function SEC.
        %
        %    See also SEC.
        
           r = mpimpl(203,x); 
        end
        
        function r = csc(x)
        %CSC Cosecant of argument in radians.
        %
        %    Usage is identical to built-in function CSC.
        %
        %    See also CSC.
        
           r = mpimpl(204,x); 
        end
        
        function r = cot(x)
        %COT Cotangent of argument in radians.
        %
        %    Usage is identical to built-in function COT.
        %
        %    See also COT.
        
           r = mpimpl(205,x); 
        end
        
        function r = acos(x)
        %ACOS Inverse cosine, result in radians.
        %
        %    Usage is identical to built-in function ACOS.
        %
        %    See also ACOS.
        
           r = mpimpl(206,x); 
        end
        
        function r = asin(x)
        %ASIN Inverse sine, result in radians.
        %
        %    Usage is identical to built-in function ASIN.
        %
        %    See also ASIN.
        
           r = mpimpl(207,x); 
        end
        
        function r = atan(x)
        %ATAN Inverse tangent, result in radians.
        %
        %    Usage is identical to built-in function ATAN.
        %
        %    See also ATAN.
        
           r = mpimpl(208,x); 
        end
        
        function r = acot(x)
        %ACOT Inverse cotangent, result in radian.
        %
        %    Usage is identical to built-in function ACOT.
        %
        %    See also ACOT.
        
           r = mpimpl(220,x); 
        end
        
        function r = asec(x)
        %ASEC  Inverse secant, result in radians.
        %
        %    Usage is identical to built-in function ASEC.
        %
        %    See also ASEC.
        
           r = mpimpl(221,x); 
        end
        
        function r = acsc(x)
        %ACSC Inverse cosecant, result in radian.
        %
        %    Usage is identical to built-in function ACSC.
        %
        %    See also ACSC.
        
           r = mpimpl(222,x); 
        end
        
        function r = cosh(x)
        %COSH Hyperbolic cosine.
        %
        %    Usage is identical to built-in function COSH.
        %
        %    See also COSH.
        
           r = mpimpl(209,x); 
        end

        function r = sinh(x)
        %SINH Hyperbolic sine.
        %
        %    Usage is identical to built-in function SINH.
        %
        %    See also SINH.
        
           r = mpimpl(210,x); 
        end
       
        function r = tanh(x)
        %TANH Hyperbolic tangent.
        %
        %    Usage is identical to built-in function TANH.
        %
        %    See also TANH.
        
           r = mpimpl(211,x); 
        end
        
        function r = sech(x)
        %SECH Hyperbolic secant.
        %
        %    Usage is identical to built-in function SECH.
        %
        %    See also SECH.
        
           r = mpimpl(212,x); 
        end
        
        function r = csch(x)
        %CSCH Hyperbolic cosecant.
        %
        %    Usage is identical to built-in function CSCH.
        %
        %    See also CSCH.
        
           r = mpimpl(213,x); 
        end
        
        function r = coth(x)
        %COTH Hyperbolic cotangent.
        %
        %    Usage is identical to built-in function COTH.
        %
        %    See also COTH.
        
           r = mpimpl(214,x); 
        end
        
        function r = acosh(x)
        %ACOSH Inverse hyperbolic cosine.
        %
        %    Usage is identical to built-in function ACOSH.
        %
        %    See also ACOSH.
        
           r = mpimpl(215,x); 
        end
        
        function r = asinh(x)
        %ASINH Inverse hyperbolic sine.
        %
        %    Usage is identical to built-in function ASINH.
        %
        %    See also ASINH.
        
           r = mpimpl(216,x); 
        end
        
        function r = atanh(x)
        %ATANH Inverse hyperbolic tangent.
        %
        %    Usage is identical to built-in function ATANH.
        %
        %    See also ATANH.
        
           r = mpimpl(217,x); 
        end
        
        function r = acoth(x)
        %ACOTH Inverse hyperbolic cotangent.
        %
        %    Usage is identical to built-in function ACOTH.
        %
        %    See also ACOTH.
        
           r = mpimpl(223,x); 
        end
        
        function r = asech(x)
        %ASECH Inverse hyperbolic secant.
        %
        %    Usage is identical to built-in function ASECH.
        %
        %    See also ASECH.
        
           r = mpimpl(224,x); 
        end
        
        function r = acsch(x)
        %ACSCH Inverse hyperbolic cosecant.
        %
        %    Usage is identical to built-in function ACSCH.
        %
        %    See also ACSCH.

           r = mpimpl(225,x); 
        end
        
        function r = atan2(y,x)
        %ATAN2 Four quadrant inverse tangent.
        %
        %    Usage is identical to built-in function ATAN2.
        %
        %    See also ATAN2
        
           r = mpimpl(218,y,x); 
        end
        
        function r = hypot(x,y)
        %HYPOT Robust computation of the square root of the sum of squares.
        %
        %    Usage is identical to built-in function HYPOT.
        %
        %    See also HYPOT
            
           r = mpimpl(219,x,y); 
        end
        
        %% Matrix Functions
        function varargout = funm(varargin)
        %FUNM Evaluate general matrix function.
        %
        %    Usage is identical to built-in function FUNM.
        %
        %    See also FUNM
        
            [varargout{1:nargout}] = mpfunm(varargin{:});
        end
        
        function varargout = sqrtm(varargin)
        %SQRTM Matrix square root.
        %
        %    Usage is identical to built-in function SQRTM.
        %
        %    See also SQRTM
        
            [varargout{1:nargout}] = mpsqrtm(varargin{:});
        end

        function r = expm(x)
        %EXPM Matrix exponential.
        %
        %    Usage is identical to built-in function EXPM.
        %
        %    See also EXPM
        
           r = mpfunm(x,@exp);  %r = mpimpl(4000,x); 
        end
        
        function r = logm(x)
        %LOGM Matrix logarithm.
        %
        %    Usage is identical to built-in function LOGM.
        %
        %    See also LOGM
        
           r = mpfunm(x,@log);
        end
        
        function r = sinm(x)
        %SINM Matrix sine.
        %
        %    Usage is identical to built-in function SINM.
        %
        %    See also SINM
        
           r = mpfunm(x,@sin);  %r = mpimpl(4003,x);
        end
        
        function r = cosm(x)
        %COSM Matrix cosine.
        %
        %    Usage is identical to built-in function COSM.
        %
        %    See also COSM
        
           r = mpfunm(x,@cos);  %r = mpimpl(4004,x);
        end
        
        function r = sinhm(x)
        %SINHM Matrix hyperbolic sine.
        %
        %    Usage is identical to built-in function SINHM.
        %
        %    See also SINHM
        
           r = mpfunm(x,@sinh); %r = mpimpl(4005,x);        
        end
        
        function r = coshm(x)
        %COSHM Matrix hyperbolic cosine.
        %
        %    Usage is identical to built-in function COSHM.
        %
        %    See also COSHM
        
           r = mpfunm(x,@cosh); %r = mpimpl(4006,x);
        end
        
        %% Exponential Functions
        function r = exp(x)
        %EXP Exponential.
        %
        %    Usage is identical to built-in function EXP.
        %
        %    See also EXP
        
           r = mpimpl(300,x); 
        end
        
        function r = expm1(x)
        %EXPM1 Compute EXP(X)-1 accurately.
        %
        %    Usage is identical to built-in function EXPM1.
        %
        %    See also EXPM1
        
           r = mpimpl(301,x); 
        end
        
        function r = log(x)
        %LOG Natural logarithm.
        %
        %    Usage is identical to built-in function LOG.
        %
        %    See also LOG
        
           r = mpimpl(302,x); 
        end
        
        function r = log10(x)
        %LOG10 Common (base 10) logarithm.
        %
        %    Usage is identical to built-in function LOG10.
        %
        %    See also LOG10
        
           r = mpimpl(303,x); 
        end
        
        function r = log1p(x)
        %LOG1P Compute LOG(1+X) accurately.
        %
        %    Usage is identical to built-in function LOG1P.
        %
        %    See also LOG1P
        
           r = mpimpl(304,x); 
        end
        
        function r = log2(x)
        %LOG2 Base 2 logarithm and dissect floating point number.
        %
        %    Usage is identical to built-in function LOG2.
        %
        %    See also LOG2
        
           r = mpimpl(305,x); 
        end
        
        function r = nextpow2(x)
        %NEXTPOW2 Next higher power of 2.
        %
        %    Usage is identical to built-in function NEXTPOW2.
        %
        %    See also NEXTPOW2
        
           r = mpimpl(306,x); 
        end
        
        function r = nthroot(x,N)
        %NTHROOT Real n-th root of real numbers.
        %
        %    Usage is identical to built-in function NTHROOT.
        %
        %    See also NTHROOT
        
           r = mpimpl(307,x,N); 
        end
        
        function r = pow2(x,e)
        %POW2 Base 2 power and scale floating point number.
        %
        %    Usage is identical to built-in function POW2.
        %
        %    See also POW2
        
           if nargin == 1,     r = mpimpl(308,x); 
           elseif nargin == 2, r = mpimpl(309,x,e); end 
        end
        
        function r = power(x,y)
        %.^  Array power.
        %
        %    Usage is identical to built-in function POWER.
        %
        %    See also POWER

           r = mpimpl(310,x,y);
        end
        
        function r = reallog(x)
        %REALLOG Real logarithm.
        %
        %    Usage is identical to built-in function REALLOG.
        %
        %    See also REALLOG
        
           r = mpimpl(311,x); 
        end
        
        function r = realpow(x,y)
        %REALPOW Real power.
        %
        %    Usage is identical to built-in function REALPOW.
        %
        %    See also REALPOW
        
           r = mpimpl(312,x,y);
        end
        
        function r = realsqrt(x)
        %REALSQRT Real square root.
        %
        %    Usage is identical to built-in function REALSQRT.
        %
        %    See also REALSQRT
        
           r = mpimpl(313,x); 
        end
        
        function r = sqrt(x)
        %SQRT Square root.
        %
        %    Usage is identical to built-in function SQRT.
        %
        %    See also SQRT
        
           r = mpimpl(314,x); 
        end
        
        %% Error and related functions
        function r = erf(x)
           r = mpimpl(403,x); 
        end
        
        function r = erfc(x)
           r = mpimpl(404,x); 
        end

        function r = erfi(x)
           r = mpimpl(419,x); 
        end

        function r = FresnelS(x)
        %FRESNELS Computes the Fresnel integral S(z).        
           r = mpimpl(420,x); 
        end

        function r = FresnelC(x)
        %FRESNELC Computes the Fresnel integral C(z).
           r = mpimpl(421,x); 
        end
        
        %% Gamma and related functions
        function r = gamma(x)
           r = mpimpl(405,x); 
        end
        
        function r = gammaln(x)
           r = mpimpl(406,x); 
        end
        
        function r = psi(x)
           r = mpimpl(407,x); 
        end
        
        function varargout = gammainc(varargin)
            [varargout{1:nargout}] = mpimpl(418,varargin{:});
        end

        %% Bessel Functions
        function varargout = besselj(varargin)
        %BESSELJ Bessel function of the first kind.
        %
        %    Usage is identical to built-in function BESSELJ.
        %
        %    See also BESSELJ.
        
            [varargout{1:nargout}] = mpimpl(424, varargin{:});
        end

        function varargout = bessely(varargin)
        %BESSELY Bessel function of the second kind.
        %
        %    Usage is identical to built-in function BESSELY.
        %
        %    See also BESSELY
        
            [varargout{1:nargout}] = mpimpl(425, varargin{:});
        end

        function varargout = besseli(varargin)
        %BESSELI Modified Bessel function of the first kind.
        %
        %    Usage is identical to built-in function BESSELI.
        %
        %    See also BESSELI.
        
            [varargout{1:nargout}] = mpimpl(426, varargin{:});
        end

        function varargout = besselk(varargin)
        %BESSELK Modified Bessel function of the second kind.
        %
        %    Usage is identical to built-in function BESSELK.
        %
        %    See also BESSELK.
        
            [varargout{1:nargout}] = mpimpl(427, varargin{:});
        end

        function varargout = besselh(varargin)
        %BESSELH Inverse cosine, result in radians.
        %
        %    Usage is identical to built-in function BESSELH.
        %
        %    See also BESSELH.
        
            [varargout{1:nargout}] = mpimpl(428, varargin{:});
        end
        
        %% Zeta Functions
        function r = zeta(x)
           r = mpimpl(408,x); 
        end

        function r = LerchPhi(z, s, a)
        % LERCHPHI Lerch transcendent function
            r = mpimpl(429, z, s, a);
        end

        %% Integral Functions En(z), n = 1 by default.
        function r = expint(z, n)
            if nargin==1,  r = mpimpl(409, z);
            else           r = mpimpl(409, z, n);  end
        end

        % Exponential Integral Ei(x), x > 0
        % See expint(z,n) for general En(z)
        function r = eint(x)
            r = mpimpl(410, x);
        end
       
        % Cosine Integral
        function r = cosint(z)
            r = mpimpl(412, z);
        end

        % Sine Integral
        function r = sinint(z)
            r = mpimpl(413, z);
        end
        
        % Logarithmic Integral, li(x), x > 1        
        function r = logint(x)
            r = mpimpl(411, x);
        end
        
        % Hyperbolic Cosine integral Chi(z)
        function r = chint(z)
            r = mpimpl(414, z);
        end

        % Hyperbolic Sine integral Shi(z)
        function r = shint(z)
            r = mpimpl(415, z);
        end

        %% Hypergeometric functions
        function r = hypergeom(n, d, z)
            r = mpimpl(416, n, d, z);
        end

        function r = KummerM(n, d, z)
        %KUMMERM Computes Kummer's (confluent hypergeometric) function M(a,b,z).        
            r = mpimpl(422, n, d, z);
        end

        function r = KummerU(n, d, z)
        %KUMMERU Computes Tricomi's (confluent hypergeometric) function U(a;b;z).                
            r = mpimpl(423, n, d, z);
        end
        
        %% Lambert W function
        function w = lambertw(varargin)
        %LAMBERTW Lambert's W function.
        %        
        %     Accepts real arguments only.
        %     Otherwise indentical to built-in function.
        %     Based on simple script from here:
        %     http://blogs.mathworks.com/cleve/2013/09/02/the-lambert-w-function/
        % 
        %     w = lambertw(x)     Same as lambertw(0,x)
        %     w = lambertw(0, x)  Primary or upper branch, W_0(x)
        %     w = lambertw(-1,x)  Lower branch, W_{-1}(x)
            
            if nargin < 2 
                k = 0;                
                x = varargin{1}; 
            else
                k = varargin{1};                 
                x = varargin{2}; 
            end;
            
            if ~ismp(x), x = mp(x); end;
            
            % Effective starting guess
            if k ~= -1,  w =    mp(ones(size(x)));  % Start above -1
            else         w = -2*mp(ones(size(x)));  % Start below -1
            end
            v = mp('inf')*w;
            % Haley's method
            while any(abs(w - v)./abs(w) > mp.eps)
               v = w;
               e = exp(w);
               f = w.*e - x;  % Iterate to make this quantity zero
               w = w - f./((e.*(w+1) - (w+2).*f./(2*w+2)));
            end
        end
        
        %% Complex
        function r = abs(x)
        %ABS Absolute value.
        %
        %  Usage is identical to built-in function ABS
        %
        % See also abs
         
           r = mpimpl(500,x); 
        end
        
        function r = sign(x)
           r = mpimpl(501,x); 
        end
        
        function r = isreal(x)
           r = mpimpl(502,x); 
        end
        
        function r = conj(x)
           r = mpimpl(503,x); 
        end
        
        function r = angle(x)
        %ANGLE Phase angle.
        %
        %    Usage is identical to built-in function ANGLE.
        %
        %    See also angle
        
           r = mpimpl(504,x); 
        end
        
        function r = complex(x,y)
           if nargin == 1, r = mpimpl(505,x,0); 
           else            r = mpimpl(505,x,y); end 
        end
        
        function r = imag(x)
           r = mpimpl(506,x); 
        end
        
        function r = real(x)
           r = mpimpl(507,x); 
        end
       
        %% Rounding and Remainder        
        function r = ceil(x)
           r = mpimpl(600,x); 
        end
        
        function r = fix(x)
           r = mpimpl(601,x); 
        end
        
        function r = floor(x)
           r = mpimpl(602,x); 
        end
        
        function varargout = idivide(varargin)
            [varargout{1:nargout}] = mpimpl(603,varargin{:});            
        end
        
        function r = mod(x,y)
           r = mpimpl(604,x,y);
        end
        
        function r = rem(x,y)
           r = mpimpl(605,x,y);
        end
        
        function r = round(x)
           r = mpimpl(606,x); 
        end
        
        %% Discrete Math        
        function varargout = factorial(varargin)
        %FACTORIAL Factorial of input.
        %
        %    Usage is identical to built-in function FACTORIAL.
        %
        %    See also FACTORIAL

            [varargout{1:nargout}] = mpimpl(700,varargin{:});            
        end

        function varargout = isprime(varargin)
        %ISPRIME Determine which array elements are prime.
        %
        %    Usage is identical to built-in function ISPRIME.
        %
        %    See also ISPRIME

            [varargout{1:nargout}] = mpimpl(701,varargin{:});            
        end
        
        function varargout = primes(varargin)
        %PRIMES Prime numbers less than or equal to input value.
        %
        %    Usage is identical to built-in function PRIMES.
        %
        %    See also PRIMES

            [varargout{1:nargout}] = mpimpl(702,varargin{:});            
        end

        function varargout = factor(varargin)
        %FACTOR Prime factors.
        %
        %    Usage is identical to built-in function FACTOR.
        %
        %    See also FACTOR

            [varargout{1:nargout}] = mpfactor(varargin{:});            
        end

        function varargout = gcd(varargin)
        %GCD Greatest common divisor.
        %
        %    Usage is identical to built-in function GCD.
        %
        %    See also GCD

            [varargout{1:nargout}] = mpimpl(703,varargin{:});            
        end
        
        function varargout = nextprime(varargin)
        %NEXTPRIME Next prime greater than input value.
        %
        %    See also PREVPRIME, PRIMES.

            [varargout{1:nargout}] = mpimpl(704,varargin{:});            
        end
        
        function varargout = prevprime(varargin)
        %PREVPRIME Previous prime less than input value.
        %
        %    See also NEXTPRIME, PRIMES.

            [varargout{1:nargout}] = mpimpl(705,varargin{:});            
        end

        function varargout = lcm(varargin)
        %LCM Least common multiple.
        %
        %    Usage is identical to built-in function LCM.
        %
        %    See also LCM

            [varargout{1:nargout}] = mplcm(varargin{:});            
        end
        
        %% Logical Operations
        function r = islogical(x)
        %ISLOGICAL Determine if input is logical array.
        %
        %    Usage is identical to built-in function ISLOGICAL.
        %
        %    See also ISLOGICAL
            
            r = false;
        end
        
        function r = logical(x)
        %LOGICAL Convert numeric values to logical.
        %
        %    Usage is identical to built-in function LOGICAL.
        %
        %    See also LOGICAL
            
            r = logical(double(x));
        end
        
        function r = not(x)
        %NOT Find logical NOT.
        %
        %    Usage is identical to built-in function NOT.
        %
        %    See also NOT
            
            r = mpimpl(803,x);
        end
        
        function r = lt(x, y)
        %LT Less than.
        %
        %    Usage is identical to built-in function LT.
        %
        %    See also LT
            
            r = mpimpl(804,x,y);
        end
        
        function r = gt(x, y)
        %GT Greater than.
        %
        %    Usage is identical to built-in function GT.
        %
        %    See also GT
            
            r = mpimpl(805,x,y);
        end
        
        function r = le(x, y)
        %LE Less than or equal.
        %
        %    Usage is identical to built-in function LE.
        %
        %    See also LE
            
            r = mpimpl(806,x,y);
        end
        
        function r = ge(x, y)
        %GE Greater than or equal.
        %
        %    Usage is identical to built-in function GE.
        %
        %    See also GE
            
            r = mpimpl(807,x,y);
        end
        
        function r = ne(x, y)
        %NE Not equal.
        %
        %    Usage is identical to built-in function NE.
        %
        %    See also NE
            
            r = mpimpl(808,x,y);
        end
        
        function r = eq(x, y)
        %EQ Equal.
        %
        %    Usage is identical to built-in function EQ.
        %
        %    See also EQ
            
            r = mpimpl(809,x,y);
        end
        
        function r = and(x, y)
        %AND Logical and.
        %
        %    Usage is identical to built-in function AND.
        %
        %    See also and
        
            r = mpimpl(810,x,y);
        end
        
        function r = or(x, y)
        %OR Logical OR.
        %
        %    Usage is identical to built-in function OR.
        %
        %    See also OR.
            
            r = mpimpl(811,x,y);
        end

        function r = xor(x, y)
        %XOR Logical XOR.
        %
        %    Usage is identical to built-in function XOR.
        %
        %    See also XOR.
            
            r = mpimpl(812,x,y);
        end
        
        function varargout = isequal(varargin)
        %ISEQUAL Determine array equality.
        %
        %    Usage is identical to built-in function ISEQUAL.
        %
        %    See also ISEQUAL.
            
            [varargout{1:nargout}] = mpimpl(813, varargin{:});
        end
        
        function varargout = isequaln(varargin)
        %ISEQUALN Determine array equality, treating NaN values as equal.
        %
        %    Usage is identical to built-in function ISEQUALN.
        %
        %    See also ISEQUALN.
            
            [varargout{1:nargout}] = mpimpl(814, varargin{:});
        end

        function r = all(A, dim)
        %ALL True if all elements of a vector are nonzero.
        %
        %    Usage is identical to built-in function ALL.
        %
        %    See also all
        
            if nargin == 1,     r = all(A~=0);          
            elseif nargin == 2, r = all(A~=0, dim); end 
        end
        
        function r = any(A, dim)
        %ANY True if any element of a vector is a nonzero number or is logical 1 (TRUE).  
        %    ANY ignores entries that are NaN (Not a Number).
        %
        %    Usage is identical to built-in function ANY.
        %
        %    See also any
        
            if nargin == 1,     r = any(A~=0);          
            elseif nargin == 2, r = any(A~=0, dim); end 
        end
        
         %% Specialized Matrices - with 'mp' arguments
        function varargout = compan(varargin)
            [varargout{1:nargout}] = mpcompan(varargin{:});            
        end
        
        function varargout = hankel(varargin)
            [varargout{1:nargout}] = mphankel(varargin{:});            
        end
        
        function varargout = vander(varargin)
            [varargout{1:nargout}] = mpvander(varargin{:});            
        end
         
        function varargout = toeplitz(varargin)
            [varargout{1:nargout}] = mptoeplitz(varargin{:});            
        end
        
        %% Linear Algebra
        function varargout = lu(varargin)
        %LU LU factorization.
        %
        %    Usage syntax is identical to built-in function SVD.
        %
        %    See also CHOL, ILU, QR.
            
            [varargout{1:nargout}] = mpimpl(1000, varargin{:});
        end
       
        function varargout = svd(varargin)
        %SVD Singular value decomposition.
        %
        %    Usage syntax is identical to built-in function SVD.
        %
        %    See also SVDS, GSVD.
            
            [varargout{1:nargout}] = mpimpl(1001, varargin{:});
        end
        
        function varargout = qr(varargin)
        %QR  Orthogonal-triangular decomposition.
        %
        %    Usage syntax is identical to built-in function QR.
        %
        %    See also LU, NULL, ORTH, QRDELETE, QRINSERT, QRUPDATE.
            
            [varargout{1:nargout}] = mpimpl(1015, varargin{:});
        end
        
        function varargout = chol(varargin)
        %CHOL Cholesky factorization.
        %
        %    Usage syntax is identical to built-in function CHOL.
        %
        %    See also CHOLUPDATE, ICHOL, LDL, LU.
            
            [varargout{1:nargout}] = mpimpl(1017, varargin{:});
        end
        
        function varargout = eig(varargin)
        %EIG Eigenvalues and eigenvectors.
        %
        %    Usage syntax is identical to built-in function EIG.
        %
        %    See also CONDEIG, EIGS, ORDEIG.
            
            [varargout{1:nargout}] = mpimpl(1016, varargin{:});
        end
        
        function varargout = condeig(varargin)
        %CONDEIG Condition number with respect to eigenvalues.
        %
        %    Usage syntax is identical to built-in function CONDEIG.
        %
        %    See also COND, EIG, ORDEIG.
            
            [varargout{1:nargout}] = mpcondeig(varargin{:});
        end
        
        function varargout = qz(varargin)
        %QZ Factorization for generalized eigenvalues.
        %
        %    Usage syntax is identical to built-in function QZ.
        %
        %    See also ORDQZ, ORDEIG, EIG.
                    
            [varargout{1:nargout}] = mpimpl(1026, varargin{:});
        end

        function varargout = ordqz(varargin)
        %ORDQZ Reorder eigenvalues in QZ factorization.
        %
        %    Usage syntax is identical to built-in function ORDQZ.
        %
        %    See also QZ, ORDEIG, EIG.
                    
            [varargout{1:nargout}] = mpimpl(1027, varargin{:});
        end

        function varargout = ordeig(varargin)
        %ORDEIG Eigenvalues of quasi-triangular matrices.
        %
        %    Usage syntax is identical to built-in function ORDEIG.
        %
        %    See also QZ, ORDQZ, SCHUR, ORDSCHUR.
                    
            [varargout{1:nargout}] = mpimpl(1028, varargin{:});
        end
        
        function varargout = schur(varargin)
        %SCHUR Schur decomposition.
        %
        %    Usage syntax is identical to built-in function SCHUR.
        %
        %    See also ORDSCHUR, QZ, ORDEIG, ORDQZ, EIG.
            
            [varargout{1:nargout}] = mpimpl(1018, varargin{:});
        end
        
        function varargout = ordschur(varargin)
        %ORSCHUR Reorder eigenvalues in Schur factorization.
        %
        %    Usage syntax is identical to built-in function ORDSCHUR.
        %
        %    See also SCHUR, QZ, ORDEIG, ORDQZ, EIG.
            
            [varargout{1:nargout}] = mpimpl(1022, varargin{:});
        end
        
        function varargout = hess(varargin)
        %HESS Hessenberg form of matrix.
        %
        %    Usage syntax is identical to built-in function HESS.
        %
        %    See also EIG, QZ, SCHUR.
            
            [varargout{1:nargout}] = mpimpl(1021, varargin{:});
        end
        
        function varargout = trisylv(varargin)
        %TRISYLV Solve triangular Sylvester equation.
        %
        %   X = TRISYLV(A,B,C) solves the Sylvester equation
        %   A*X + X*B = C, where A and B are square upper triangular matrices.
            
            [varargout{1:nargout}] = mpimpl(1023, varargin{:});
        end
        
        function varargout = sort(varargin)
        %SORT Sort in ascending or descending order.
        %
        %    Usage syntax is identical to built-in function SORT.
        %
        %    See also ISSORTED, SORTROWS, MIN, MAX, MEAN, MEDIAN, UNIQUE.
            
            [varargout{1:nargout}] = mpimpl(1100, varargin{:});
        end

        function varargout = det(varargin)
        %DET Determinant.
        %
        %    Usage syntax is identical to built-in function DET.
        %
        %    See also COND.
            
            [varargout{1:nargout}] = mpimpl(1002,varargin{:});
        end
        
        function varargout = inv(varargin)
        %INV Matrix inverse.
        %
        %    Usage syntax is identical to built-in function INV.
        %
        %    See also SLASH, PINV, COND, CONDEST.
            
            [varargout{1:nargout}] = mpimpl(1003,varargin{:});
        end

        function varargout = issymmetric(varargin)
        %ISSYMMETRIC Determine whether a matrix is real or complex symmetric.
        %
        %    Usage syntax is identical to built-in function ISSYMMETRIC.
        %
        %    See also ISHERMITIAN.
            
            [varargout{1:nargout}] = mpimpl(1029,varargin{:});
        end

        function varargout = ishermitian(varargin)
        %ISHERMITIAN Determine whether a matrix is real symmetric or complex Hermitian.
        %
        %    Usage syntax is identical to built-in function ISHERMITIAN.
        %
        %    See also ISSYMMETRIC.
            
            [varargout{1:nargout}] = mpimpl(1030,varargin{:});
        end
        
        function varargout = istril(varargin)
        %ISTRIL Determine whether a matrix is lower triangular.
        %
        %    Usage syntax is identical to built-in function ISTRIL.
        %
        %    See also ISDIAG, ISTRIU, DIAG, TRIL, TRIU.
            
            [varargout{1:nargout}] = mpimpl(1031,varargin{:});
        end

        function varargout = istriu(varargin)
        %ISTRIU Determine whether a matrix is upper triangular.
        %
        %    Usage syntax is identical to built-in function ISTRIU.
        %
        %    See also ISDIAG, ISTRIL, DIAG, TRIL, TRIU.
            
            [varargout{1:nargout}] = mpimpl(1032,varargin{:});
        end

        function varargout = isdiag(varargin)
        %ISDIAG Determine whether a matrix is diagonal.
        %
        %    Usage syntax is identical to built-in function ISDIAG.
        %
        %    See also ISTRIL, ISTRIU, DIAG, TRIL, TRIU.
            
            [varargout{1:nargout}] = mpimpl(1033,varargin{:});
        end

        function varargout = pinv(varargin)
        %PINV Pseudoinverse.
        %
        %    Usage syntax is identical to built-in function PINV.
        %
        %    See also RANK.
            
            [varargout{1:nargout}] = mpimpl(1004,varargin{:});
        end
        
        function r = rank(A,tol)
        %RANK Matrix rank.
        %
        %    Usage syntax is identical to built-in function RANK.
        %
        %    See also SVD, COND.
            
            s = svd(A);
            if nargin==1, tol = max(size(A)) * mp.eps(max(s)); end
            r = sum(s > tol);
        end
        
        function varargout = trace(varargin)
        %TRACE Sum of diagonal elements.
        %
        %    Usage syntax is identical to built-in function TRACE.
        %
        %    See also RANK, COND.
        
            [varargout{1:nargout}] = mpimpl(1006,varargin{:});
        end
      
        function varargout = norm(varargin)
        %NORM Matrix or vector norm.
        %
        %    Usage syntax is identical to built-in function NORM.
        %
        %    See also COND, RCOND, CONDEST, NORMEST, HYPOT.
        
            [varargout{1:nargout}] = mpimpl(1007,varargin{:});
        end
        
        function c = cond(A, p)
        %COND Condition number with respect to inversion.  
        %
        %    Usage syntax is identical to built-in function COND.
        %
        %    See also RCOND, CONDEST, CONDEIG, NORM, NORMEST.
        
            if nargin < 2, p = 2; end;
            
            if issparse(A)
                % Use 'double' precision for sparse matrices, since:
                % (a) we do not have full-featured LU for sparse;
                % (b) 'double' precision is more than enough to estimate
                % magnitude of the condition number
                warning(message('MATLAB:cond:SparseNotSupported'))
                c = condest(double(A));
            else
                
                % Matrix must be square if p!=2
                [m, n] = size(A);
                if m~=n && ~isequal(p,2)
                    error(message('MATLAB:cond:normMismatchSizeA')); 
                end
                
                % Standard code for condition number estimation
                if p == 2
                    s = svd(A);
                    if any(s == 0)
                        c = mp('Inf');
                    else
                        c = max(s)./min(s);
                        if isempty(c)
                            c = mp('0');
                        end
                    end
                else
                    c = norm(A,p) * norm(inv(A),p);
                end
             end
        end
        
        function varargout = rcond(varargin)
        %RCOND Reciprocal condition number.
        %
        %    Usage is identical to built-in function RCOND.
        %
        %    See also COND, CONDEST, NORM, NORMEST, RANK, SVD.
            
            [varargout{1:nargout}] = mpimpl(1024,varargin{:});
        end
        
        function varargout = balance(varargin)
        %BALANCE Diagonal scaling to improve eigenvalue accuracy.
        %
        %    Usage is identical to built-in function BALANCE.
        %
        %    See also BALANCE
        
            [varargout{1:nargout}] = mpimpl(1025,varargin{:});
        end
        
        function varargout = null(varargin)
               [varargout{1:nargout}] = mpimpl(1020,varargin{:});
        end
        
        function varargout = diag(varargin)
               [varargout{1:nargout}] = mpimpl(1008,varargin{:});
        end
        
        function varargout = triu(varargin)
               [varargout{1:nargout}] = mpimpl(1009,varargin{:});
        end

        function varargout = tril(varargin)
               [varargout{1:nargout}] = mpimpl(1010,varargin{:});
        end
       
        function varargout = sum(varargin)
               [varargout{1:nargout}] = mpimpl(1011,varargin{:});
        end
       
        function varargout = prod(varargin)
               [varargout{1:nargout}] = mpimpl(1012,varargin{:});
        end

        function varargout = cumprod(varargin)
               [varargout{1:nargout}] = mpimpl(3000,varargin{:});
        end
        
        function varargout = cumsum(varargin)
               [varargout{1:nargout}] = mpimpl(3001,varargin{:});
        end
        
        function varargout = dot(varargin)
        %DOT Dot product
        %
        %    Usage is identical to built-in function DOT.
        %
        %    See also CROSS, SUM, KRON.
            
               [varargout{1:nargout}] = mpimpl(3002,varargin{:});
        end
   
        function varargout = cross(varargin)
        %CROSS Cross product
        %
        %    Usage is identical to built-in function CROSS.
        %
        %    See also DOT, KRON.
            
               [varargout{1:nargout}] = mpimpl(3003,varargin{:});
        end
        
        function varargout = kron(varargin)
        %KRON Kronecker tensor product
        %
        %    Usage is identical to built-in function KRON.
        %
        %    See also CROSS, DOT, HANKEL, TOEPLITZ.
            
               [varargout{1:nargout}] = mpimpl(3004,varargin{:});
        end
        
        %% Basic Statistics 
        function varargout = mean(varargin)
        %MEAN Average or mean value.
        %
        %    Usage is identical to built-in function MEAN.
        %
        %    See also MEDIAN, STD, MIN, MAX, VAR, COV, MODE.
        
               [varargout{1:nargout}] = mpimpl(2004,varargin{:});
        end
        
        function varargout = std(varargin)
        %STD Standard deviation.
        %
        %    Usage is identical to built-in function STD.
        %
        %    See also COV, MEAN, VAR, MEDIAN, CORRCOEF.
            
               [varargout{1:nargout}] = mpimpl(2005,varargin{:});
        end
        
        function varargout = max(varargin)
        %MAX Largest component.
        %
        %    Usage is identical to built-in function MAX.
        %
        %    See also MIN, CUMMIN, MEDIAN, MEAN, SORT.
            
               [varargout{1:nargout}] = mpimpl(1013,varargin{:});
        end
    
        function varargout = min(varargin)
        %MIN Smallest component.
        %
        %    Usage is identical to built-in function MIN.
        %
        %    See also MAX, CUMMIN, MEDIAN, MEAN, SORT.
            
               [varargout{1:nargout}] = mpimpl(1014,varargin{:});
        end

        function varargout = diff(varargin)
        %DIFF Difference and approximate derivative.
        %
        %    Usage is identical to built-in function DIFF.
        %
        %    See also GRADIENT, SUM, PROD.
        
               [varargout{1:nargout}] = mpdiff(varargin{:});
        end
        
        function varargout = gradient(varargin)
        %GRADIENT Approximate gradient.
        %
        %    Usage is identical to built-in function GRADIENT.
        %
        %    See also DIFF, DEL2.
        
               [varargout{1:nargout}] = mpgradient(varargin{:});
        end
        
        %% Sparse matrices
        function r = issparse(x)
        %ISSPARSE Determine whether input is sparse
        %
        %    Usage is identical to built-in function ISSPARSE.
        %
        %    See also ISSPARSE.
        
           r = mpimpl(8501, x); 
        end
        
        function r = nnz(x)
        %NNZ Number of nonzero matrix elements
        %
        %    Usage is identical to built-in function NNZ.
        %
        %    See also NNZ.
        
           r = mpimpl(8502, x); 
        end

        function r = nonzeros(x)
        %NONZEROS Nonzero matrix elements
        %
        %    Usage is identical to built-in function NONZEROS.
        %
        %    See also NONZEROS.
        
           r = mpimpl(8503, x); 
        end
        
        function r = nzmax(x)
        %NZMAX Amount of storage allocated for nonzero matrix elements
        %
        %    Usage is identical to built-in function NZMAX.
        %
        %    See also NZMAX.
           
           r = mpimpl(8504, x); 
        end
        
        function varargout = full(varargin)
        %FULL Convert sparse matrix to full matrix
        %
        %    Usage is identical to built-in function FULL.
        %
        %    See also FULL
            
            [varargout{1:nargout}] = mpimpl(8505, varargin{:});
        end
        
        function varargout = sparse(varargin)
        %SPARSE Create sparse matrix
        %
        %    Usage is identical to built-in function SPARSE.
        %
        %    See also SPARSE
            
            [varargout{1:nargout}] = mpimpl(8508, varargin{:});
        end

        function varargout = colamd(S,varargin)
        %COLAMD Column approximate minimum degree permutation.
        %
        %    Usage is identical to built-in function COLAMD.
        %
        %    See also COLAMD

            [row,col] = find(S);
            [varargout{1:nargout}] = colamd(sparse(row,col,1), varargin{:});
        end
        
        function varargout = amd(S,varargin)
        %AMD  Approximate minimum degree permutation.
        %
        %    Usage is identical to built-in function AMD.
        %
        %    See also AMD

            [row,col] = find(S);
            [varargout{1:nargout}] = amd(sparse(row,col,1), varargin{:});
        end

        function varargout = symamd(S,varargin)
        %SYMAMD Symmetric approximate minimum degree permutation.
        %
        %    Usage is identical to built-in function SYMAMD.
        %
        %    See also SYMAMD

            [row,col] = find(S);
            [varargout{1:nargout}] = symamd(sparse(row,col,1), varargin{:});
        end

        function varargout = symrcm(S,varargin)
        %SYMRCM Symmetric reverse Cuthill-McKee permutation.
        %
        %    Usage is identical to built-in function SYMRCM.
        %
        %    See also SYMRCM

            [row,col] = find(S);
            [varargout{1:nargout}] = symrcm(sparse(row,col,1), varargin{:});
        end
        
        function r = spones(x)
        %SPONES Replace nonzero sparse matrix elements with ones
        %
        %    Usage is identical to built-in function SPONES.
        %
        %    See also SPONES.
           
           r = mpimpl(8506, x); 
        end
        
        function r = spfun(fun, x)
        %SPFUN Apply function to nonzero sparse matrix elements
        %
        %    Usage is identical to built-in function SPFUN.
        %
        %    See also SPFUN.
           
           r = mpimpl(8507, fun, x); 
        end
        
        function varargout = find(varargin)
        %FIND Find indices and values of nonzero elements
        %
        %    Usage is identical to built-in function FIND.
        %
        %    See also FIND
            
            [varargout{1:nargout}] = mpimpl(8000, varargin{:});
        end
        
        function varargout = spdiags(varargin)
        %SPDIAGS Sparse matrix formed from diagonals.
        %
        %    Usage is identical to built-in function SPDIAGS.
        %
        %    See also SPDIAGS
            
            [varargout{1:nargout}] = mpspdiags(varargin{:});
        end
        
        %% System functions
        function  classname = superiorfloat(varargin)  
            classname = 'mp'; 
        end

        %% Numerical Integration
        function varargout = quad(varargin)
        %QUAD Numerically evaluate integral, adaptive Simpson quadrature
        %
        %    Usage is identical to built-in function QUAD.
        %
        %    See also QUAD
            
            [varargout{1:nargout}] = mpquad(varargin{:});
        end

        function varargout = dblquad(varargin)
        %DBLQUAD Numerically evaluate double integral over rectangle
        %
        %    Usage is identical to built-in function DBLQUAD.
        %
        %    See also DBLQUAD
            
            [varargout{1:nargout}] = mpdblquad(varargin{:});
        end

        function varargout = triplequad(varargin)
        %TRIPLEQUAD Numerically evaluate triple integral
        %
        %    Usage is identical to built-in function TRIPLEQUAD.
        %
        %    See also TRIPLEQUAD
            
            [varargout{1:nargout}] = mptriplequad(varargin{:});
        end
        
        function varargout = quadgk(varargin)
        %QUADGK Numerically evaluate integral, adaptive Gauss-Kronrod quadrature
        %
        %    Usage is identical to built-in function QUADGK.
        %
        %    See also QUADGK
            
            [varargout{1:nargout}] = mpquadgk(varargin{:});
        end
        
        function Q = quadgl(funfcn,a,b,n,varargin)
        %QUADGL  Numerically evaluate integral by fixed order Gauss-Legendre quadrature.   
        %   Q = QUADGL(FUN,A,B,N) tries to approximate the integral of scalar-valued
        %   function FUN from A to B by Gauss-Legendre quaradure of order N.
        %   FUN is a function handle. The function Y=FUN(X) should accept a vector 
        %    argument X and return a vector result Y, the integrand evaluated at each element of X.
        % 
        %   Intended to be used with multiple-precision numbers A, B. 
        %   FUN should be able to work with multiple-precision arguments. 

        % Copyright (c) 2006 - 2012 Advanpix, LLC. 
        % http://www.advanpix.com
        
            f = fcnchk(funfcn);
            
            if nargin < 4 || isempty(n), n = 16; end;
            if ~isscalar(a) || ~isscalar(b)
                error('MCT:quadgl:scalarLimits',...
                    'The limits of integration must be scalars.');
            end
            
            [x,w] = mp.GaussLegendre(n);
            d = (b-a)/2;
            c = (b+a)/2;
            Q = d*sum(w.*f(d.*x+c));
        end
        
        %% Numerical Optimization
        function varargout = fzero(varargin)
            [varargout{1:nargout}] = mpfzero(varargin{:});
        end

        function varargout = fminsearch(varargin)
            [varargout{1:nargout}] = mpfminsearch(varargin{:});
        end
        
        %% ODE
        function varargout = ode45(varargin)
            [varargout{1:nargout}] = mpode45(varargin{:});
        end
        
        function varargout = ode113(varargin)
            [varargout{1:nargout}] = mpode113(varargin{:});
        end
        
        function varargout = odearguments(varargin)
            [varargout{1:nargout}] = mpodearguments(varargin{:});
        end
        
        function varargout = odeevents(varargin)
            [varargout{1:nargout}] = mpodeevents(varargin{:});
        end
        
        function varargout = odemass(varargin)
            [varargout{1:nargout}] = mpodemass(varargin{:});
        end
        
        function varargout = ntrp45(varargin)
            [varargout{1:nargout}] = mpntrp45(varargin{:});
        end
        
        function varargout = ntrp113(varargin)
            [varargout{1:nargout}] = mpntrp113(varargin{:});
        end
        
        function varargout = odefinalize(varargin)
            [varargout{1:nargout}] = mpodefinalize(varargin{:});
        end
        
        function varargout = odezero(varargin)
            [varargout{1:nargout}] = mpodezero(varargin{:});
        end
       
        %% Fast Fourier Transform
        function varargout = fft(varargin)
        %FFT Discrete Fourier transform.     
        %
        %    Usage is identical to built-in function FFT
        %
        %    See also FFT2, FFTN, FFTSHIFT, FFTW, IFFT, IFFT2, IFFTN.
        
        % In case if dim > ndims(A) and there is n, then: 
        % B = A;
        % for i=1:(n-1), B = cat(dim,B,A);end;

            [varargout{1:nargout}] = mpimpl(7000,varargin{:});
        end
        
        function varargout = fft2(varargin)
        %FFT2 Two-dimensional discrete Fourier Transform.            
        %
        %    Usage is identical to built-in function FFT2
        %
        %   See also FFT, FFTN, FFTSHIFT, FFTW, IFFT, IFFT2, IFFTN.
        
            [varargout{1:nargout}] = mpfft2(varargin{:});
        end
        
        function varargout = ifft(varargin)
        %IFFT Inverse discrete Fourier transform.            
        %
        %    Usage is identical to built-in function FFT2
        %
        %   See also FFT, FFT2, FFTN, FFTSHIFT, FFTW, IFFT2, IFFTN.
        
            [varargout{1:nargout}] = mpimpl(7001,varargin{:});
        end
        
        function varargout = ifft2(varargin)
        %IFFT2 Two-dimensional inverse discrete Fourier transform.            
        %
        %    Usage is identical to built-in function FFT2
        %
        %   See also FFT, FFT2, FFTN, FFTSHIFT, FFTW, IFFT, IFFTN.
        
            [varargout{1:nargout}] = mpifft2(varargin{:});
        end
        
        
        %% Polynomial roots
        function varargout = roots(varargin)
        %ROOTS Polynomial roots.
        %
        %    Usage is identical to built-in function ROOTS
        %    
        %
        %    See also ROOTS.
            
            [varargout{1:nargout}] = mproots(varargin{:});
        end

        function varargout = poly(varargin)
        %PLOY Polynomial with specified roots.
        %
        %    Usage is identical to built-in function POLY
        %    
        %
        %    See also POLY, ROOTS, CONV.
            
            [varargout{1:nargout}] = mppoly(varargin{:});
        end
        
        function varargout = polyder(varargin)
        %POLYDER Differentiate polynomial.
        %
        %    Usage is identical to built-in function POLYDER
        %    
        %
        %    See also POLYINT, CONV, DECONV.
            
            [varargout{1:nargout}] = mppolyder(varargin{:});
        end
        
        function varargout = polyeig(varargin)
        %POLYEIG Polynomial eigenvalue problem.
        %
        %    Implemented in quadruple precision only.
        %
        %    Usage is identical to built-in function POLYEIG
        %    
        %
        %    See also EIG, COND, CONDEIG.
            
            [varargout{1:nargout}] = mppolyeig(varargin{:});
        end
        
        function varargout = polyval(varargin)
        %POLYVAL Evaluate polynomial.
        %
        %
        %    Usage is identical to built-in function POLYVAL
        %    
        %
        %    See also POLYFIT, POLYVALM.
            
            [varargout{1:nargout}] = mppolyval(varargin{:});
        end
        
        function varargout = polyvalm(varargin)
        %POLYVALM Evaluate polynomial with matrix argument.
        %
        %
        %    Usage is identical to built-in function POLYVALM
        %    
        %
        %    See also POLYVAL, POLYFIT.
            
            [varargout{1:nargout}] = mppolyvalm(varargin{:});
        end

        function varargout = polyfit(varargin)
        %POLYFIT Evaluate polynomial.
        %
        %
        %    Usage is identical to built-in function POLYFIT
        %    
        %
        %    See also POLY, POLYVAL, ROOTS.
            
            [varargout{1:nargout}] = mppolyfit(varargin{:});
        end

        function varargout = polyint(varargin)
        %POLYINT Integrate polynomial analytically.
        %
        %
        %    Usage is identical to built-in function POLYINT
        %    
        %
        %   See also POLYDER, POLYVAL, POLYVALM, POLYFIT.
            
            [varargout{1:nargout}] = mppolyint(varargin{:});
        end
        
        function varargout = residue(varargin)
        %RESIDUE Partial-fraction expansion (residues).
        %
        %
        %    Usage is identical to built-in function RESIDUE
        %    
        %
        %    See also POLY, ROOTS, DECONV.
            
            [varargout{1:nargout}] = mpresidue(varargin{:});
        end
        
        function varargout = mpoles(varargin)
        %MPOLES Identify repeated poles & their multiplicities.
        %
        %
        %    Usage is identical to built-in function MPOLES
        %    
        %
        %   See also RESIDUE.
            
            [varargout{1:nargout}] = mpmpoles(varargin{:});
        end
        
        function varargout = resi2(varargin)
        %RESI2  Residue of a repeated pole.
        %
        %
        %    Usage is identical to built-in function RESI2
        %    
        %
        %   See also RESIDUE.
            
            [varargout{1:nargout}] = mpresi2(varargin{:});
        end
        
        function varargout = conv(varargin)
        %CONV Convolution and polynomial multiplication.
        %
        %    Usage is identical to built-in function CONV
        %
        %    See also CONV.
            
            [varargout{1:nargout}] = mpimpl(7002, varargin{:});
        end
        
        function varargout = deconv(varargin)
        %DECONV Deconvolution and polynomial division.
        %
        %    Usage is identical to built-in function DECONV
        %
        %    See also DECONV.
            
            [varargout{1:nargout}] = mpdeconv(varargin{:});
        end
        
        %% Overaloads for functions accepting integer arguments.
        function r = ones(varargin)
        %ONES Create array of all ones.
        %
        %    Usage is identical to built-in function ONES.
        %    
        %    See also ONES.

           for i=1:nargin, if ismp(varargin{i}), varargin{i} = double(varargin{i}); end; end;                    
           r = mp(ones(varargin{:}));
        end

        function r = zeros(varargin)
        %ZEROS Create array of all zeros.
        %
        %    Usage is identical to built-in function ZEROS.
        %    
        %    See also ZEROS.
            
            for i=1:nargin, if ismp(varargin{i}), varargin{i} = double(varargin{i}); end; end;                    
            r = mp(zeros(varargin{:}));
        end

        function r = eye(varargin)
        %EYE Identity matrix.
        %
        %    Usage is identical to built-in function EYE.
        %    
        %    See also EYE.
            
            for i=1:nargin, if ismp(varargin{i}), varargin{i} = double(varargin{i}); end; end;                    
            r = mp(eye(varargin{:}));
        end

        function varargout = linspace(varargin)
        %LINSPACE Linearly spaced vector.
        %
        %    Usage is identical to built-in function LINSPACE.
        %
        %    See also LOGSPACE, COLON.
        
               [varargout{1:nargout}] = mplinspace(varargin{:});
        end

        function varargout = logspace(varargin)
        %LOGSPACE Logarithmically spaced vector.
        %
        %    Usage is identical to built-in function LOGSPACE.
        %
        %    See also LINSPACE, COLON.
        
               [varargout{1:nargout}] = mplogspace(varargin{:});
        end
        
        function varargout = meshgrid(varargin)
        %MESHGRID Cartesian grid in 2-D/3-D space
        %
        %    Usage is identical to built-in function MESHGRID.
        %
        %    See also SURF, SLICE, NDGRID.
        
               [varargout{1:nargout}] = mpmeshgrid(varargin{:});
        end

        function varargout = ndgrid(varargin)
        %NDGRID Rectangular grid in N-D space
        %
        %    Usage is identical to built-in function NDGRID.
        %
        %    See also MESHGRID, SLICE, INTERPN.
        
               [varargout{1:nargout}] = mpndgrid(varargin{:});
        end
        
        function r = rand(varargin)
        %RAND Uniformly distributed pseudorandom numbers.
        %
        %    Use mp.rand(...) for full precision random numbers.
        %
        %    Usage is identical to built-in function RAND.
        %    
        %    See also RAND.
            
            r = mprand(varargin{:});
        end

        function r = randn(varargin)
        %RANDN Normally distributed pseudorandom numbers.
        %
        %    Usage is identical to built-in function RANDN.
        %    
        %    See also RANDN.
            
            r = mprandn(varargin{:});
        end
        
        %% Formatted output
        function s = num2str(x, f)
        %NUM2STR Convert number to string.
        %
        %    Usage is identical to built-in function NUM2STR
        %
        %    See also SPRINTF.
        
        %
        %    TODO:
        %    1. Better handling of %i and %d specifiers when x is a matrix.
        %       See the sprintf_basic for more details. 
        %       Currently matrix conversion is implemented on C++ level with spacing, etc.
        %       Not sure what way is better: (a) to re-implement it in Matlab
        %       or (b) extend C++ version with %i, %d support.
        %
        %       Once this will be implemented - then we can simplify
        %       sprintf_basic (remove unsupported_types handling), since
        %       all the low-level stuff will happen here.
        %
        %    2. Add currently unsupported format specifiers - hex, etc.        
        %
        %    3. Complex values should be converted as in Matlab (imag part
        %       under real).
        %    4. Alignment and spaces. See source code for built-in num2str
        %       for more details.
        
            if isempty(x) ,  s = '';      return;  end
            if issparse(x),  x = full(x);          end
            
            if     nargin < 2  , s = mpimpl(6000,x);   return;
            elseif isnumeric(f), s = mpimpl(6000,x,f); return;
            elseif ischar(f)
                
                if isempty(strfind(f,'%')), error(message('MATLAB:num2str:fmtInvalid', f)); end;
                
                [match, tokenname, split] = mp.parseSpecifiers(f);
                argc = size(match, 2);
                
                if argc==0, error(message('MATLAB:num2str:fmtInvalid', f)); end;
                
                if argc==1
                       % Only one format specifier 
                       % x might be a matrix or scalar.
                       % all recursive calls from matrix-enabled routines,
                       % sprintf, num2str end here.
                       
                       unsupported_types = '([diuoxXcs]|(?:bx|bX|bo|bu|tx|tX|to|tu|ld|li|lo|lu|lx|lX|hd|hi|ho|hu|hx|hX))';
                       if regexp(tokenname(1).type, unsupported_types)
                           % Just use %g for all unsupported types for now
                           % Later we will need to add proper handling for
                           % integer types.
                           modifiedFormat = regexprep(match{1},unsupported_types,'g');                       
                           s = mpimpl(6000,x,[split{1} modifiedFormat split{2}]);
                       else
                           s = mpimpl(6000,x,f);
                       end
                       return;
                end;
                
                [rows,cols] = size(x);
                if cols > argc
                    fspec = '';
                    for k=1:floor(cols/argc), fspec = [fspec f]; end;
                    for k=1:mod  (cols,argc), fspec = [fspec split{k} match{k}]; end;
                else
                    fspec = f;
                end
                
                s = '';
                argv = cell(1,cols);                
                for k=1:rows 
                    for p=1:cols, argv{p} = subsref(x,substruct('()',{k,p})); end;
                    
                    if k<rows,  s = [s mp.sprintf_basic([fspec '\n'],argv{:})]; 
                    else        s = [s mp.sprintf_basic(fspec,       argv{:})]; end;
                end
            else
                error(message('MATLAB:num2str:invalidSecondArgument'))        
            end
        end
        
        function varargout = sprintf(varargin)
        % SPRINTF Write formatted data to string.      
        %
        %    Usage is identical to built-in function SPRINTF
        %
        %    See also NUM2STR.
               
            % Iterate over every argc input elements 
            % and call sprintf_basic for each assembly.
            [matchstring, tokenname, splitstring] = mp.parseSpecifiers(varargin{1});
            argc = size(matchstring, 2);
            
            if argc==0 
                % let the built-in to handle the singular cases                
                [varargout{1:nargout}] = builtin('sprintf',varargin{1});                
                return;                
            end;
                
            argv = cell(1,argc);
            
            s = '';
            n =  1;            
            for k=2:nargin
                object = varargin{k};
                if isnumeric(object)
                    object = real(object); 
                    for p=1:numel(object)
                        if ismp(object),  argv{n} = subsref(object,substruct('()',{p}));
                        else              argv{n} = object(p); end;

                        if n==argc
                            s = [s mp.sprintf_basic(varargin{1},argv{:})];
                            n = 1;
                        else
                            n = n+1;                        
                        end
                    end
                else
                    argv{n} = object;
                    
                    if n==argc
                        s = [s mp.sprintf_basic(varargin{1},argv{:})];
                        n = 1;
                    else
                        n = n+1;                        
                    end
                end
            end
            
            if n > 1
                partial = '';
                for k=1:n-1, partial = [partial splitstring{k} matchstring{k}]; end;
                s = [s mp.sprintf_basic(partial,argv{1:n-1})];
            end;
            
            varargout{1} = s;
            for k=2:nargout, varargout{k} = ''; end;
        end
        
        function fprintf(varargin)
        %FPRINTF Write formatted data to text file.        
        %
        %    Usage is identical to built-in function FPRINTF
        %
        %    See also SPRINTF, NUM2STR.
            if isnumeric(varargin{1}), fprintf(varargin{1}, sprintf(varargin{2:end}));                
            else                       fprintf(sprintf(varargin{1:end})); end
        end
        
    end % methods
   
end % classdef
