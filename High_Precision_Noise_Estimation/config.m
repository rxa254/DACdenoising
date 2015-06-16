function params = config()
    % Function returns structure with parameters needed by the script

    % Interferometer name and site
    params.IFO = getenv('IFO');
    params.ifo = getenv('ifo');
    params.site = getenv('site');
    
    % NDS server name and host
    base_host = getenv('LIGONDSIP');
    params.host = [base_host ':8088'];
    
    % Directory with Foton files
    params.chans = ['/opt/rtcds/' params.site '/' params.ifo '/chans/'];
    
    % User apps directory
    params.uapps =  ['/opt/rtcds/' params.site '/' params.ifo '/userapps/release/'];
end