function mpstartup()
%MPSTARTUP Set default settings for Multiprecision Computing Toolbox.
%
%   Loads every time on toolbox startup before any other routine runs.
% 
%   Configures toolbox with default settings. 
%   Can be modified to change default precision, guard digits and other options.
% 
%   Don't need to be called explicitly by the user.         
%
%   See also mp.Init

%   Copyright (c) 2006 - 2015 Advanpix.com    

    % Intialize Multiprecision Computing Toolbox's core engine
    mp.Init();

    % Set up quadruple precision by default
    mp.Digits(34);
    
    % Set up guard digits, 'mp' uses mp.Digits() + mp.GuardDigits() decimal digits in all calculations.
    mp.GuardDigits(0);
    
    % Auto-extend accuracy of built-in 'double' precision constants (pi, exp)
    mp.ExtendConstAccuracy(false);

    % Display all digits of precision by default 
    % Change to 'true' to follow MATLAB's numeric format preferences.
    mp.FollowMatlabNumericFormat(false);
    
end

