classdef Heatmap < pm.vis.plot.Plot
    %
    %   This is the Heatmap class for generating
    %   instances of 2-dimensional Heatmap plots
    %   based on the relevant MATLAB
    %   intrinsic functions.
    %
    %   Parameters
    %   ----------
    %
    %       dfref
    %
    %           See the documentation of the corresponding input
    %           argument of the superclass ``pm.vis.plot.Plot``.
    %
    %   Attributes
    %   ----------
    %
    %       See the documentation of the attributes
    %       of the superclass ``pm.vis.plot.Plot``.
    %
    %   Returns
    %   -------
    %
    %       An object of ``pm.vis.subplot.Heatmap`` class.
    %
    %   Interface
    %   ---------
    %
    %       s = pm.vis.subplot.Heatmap(dfref);
    %       s = pm.vis.subplot.Heatmap(dfref, varargin);
    %
    %   LICENSE
    %   -------
    %
    %       https://github.com/cdslaborg/paramonte/blob/main/LICENSE.md
    %
    methods(Access = public)
        function self = Heatmap(dfref, varargin)
            if nargin < 1
                dfref = [];
            end
            self = self@pm.vis.plot.Plot(pm.vis.subplot.Heatmap(dfref), varargin{:});
        end
    end
end