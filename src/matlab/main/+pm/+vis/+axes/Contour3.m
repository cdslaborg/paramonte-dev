classdef Contour3 < pm.vis.axes.BaseDF
    %
    %   This is the Contour3 class for generating
    %   instances of 3-dimensional Contour3 plots
    %   based on the relevant MATLAB
    %   intrinsic functions.
    %
    %   Parameters
    %   ----------
    %
    %       dfref
    %
    %           See the documentation of the corresponding input
    %           argument of the parent class ``pm.vis.axes.BaseDF``.
    %
    %   Attributes
    %   ----------
    %
    %       See the documentation of the attributes
    %       of the parent class ``pm.vis.axes.BaseDF``.
    %
    %   Returns
    %   -------
    %
    %       An object of ``pm.vis.axes.Contour3`` class.
    %
    %   Interface
    %   ---------
    %
    %       p = pm.vis.axes.Contour3(dfref);
    %       p = pm.vis.axes.Contour3(dfref, []);
    %       p = pm.vis.axes.Contour3(dfref);
    %
    %   LICENSE
    %   -------
    %
    %       https://github.com/cdslaborg/paramonte/blob/main/LICENSE.md
    %
    methods (Access = public)
        function self = Contour3(dfref)
            if nargin < 1
                dfref = [];
            end
            self = self@pm.vis.axes.BaseDF("Contour3", dfref);
        end
    end
end