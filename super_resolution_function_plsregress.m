% ==========================================================================
% function  : super_resolution_function_plsregress
% --------------------------------------------------------------------------
% purpose   :   
% input     : x, y, n_pls_components, cv, mcreps
% output    : beta
% comment   :
% reference :   
% --------------------------------------------------------------------------
% 2017/10 - guillaume.madelin@nyulangone.org
% ==========================================================================

function [beta] = super_resolution_function_plsregress(x,y,n_pls_components,cv0,mcreps)

    if (cv0 == 1), cv = 'resubstitution';
    else
        cv = cv0;  % k_fold
    end

    [xl,yl,xs,ys,beta,pctvar,mse,stats] = plsregress(x,y,n_pls_components,'cv',cv,'mcreps',mcreps);  %#ok
    
end

