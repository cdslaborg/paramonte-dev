classdef Line < pm.vis.subplot.Subplot
    %
    %   This is the Line class for generating
    %   instances of 2-dimensional Line plots
    %   based on the relevant MATLAB
    %   intrinsic functions.
    %
    %   Parameters
    %   ----------
    %
    %       dfref
    %
    %           See the documentation of the corresponding input
    %           argument of the parent class ``pm.vis.subplot.Subplot``.
    %
    %   Attributes
    %   ----------
    %
    %       See the documentation of the attributes
    %       of the parent class ``pm.vis.subplot.Subplot``.
    %
    %   Returns
    %   -------
    %
    %       An object of ``pm.vis.axes.Line`` class.
    %
    %   Interface
    %   ---------
    %
    %       p = pm.vis.axes.Line(dfref);
    %       p = pm.vis.axes.Line(dfref, varargin);
    %
    %   LICENSE
    %   -------
    %
    %       https://github.com/cdslaborg/paramonte/blob/main/LICENSE.md
    %
    methods (Access = public)
        function self = Line(dfref, varargin)
            if nargin < 1
                dfref = [];
            end
            self = self@pm.vis.subplot.Subplot("Line", dfref, varargin{:});
        end
    end
end