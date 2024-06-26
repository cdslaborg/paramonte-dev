function vmat = verbose(cmat, dim, weight)
    %
    %   Return a MATLAB double, cell, or table matrix whose rows or
    %   columns are unrolled according to a prespecified ``weight``.
    %
    %   Parameters
    %   ----------
    %
    %       cmat
    %
    %           The input compact MATLAB double, cell, or table
    %           matrix that is to be unrolled along an axis.
    %
    %       dim
    %
    %           The input scalar MATLAB integer
    %           that can be either ``1`` or ``2``
    %           representing the axis along with the
    %           array must be unrolled.
    %           An input value of ``1`` implies unrolling
    %           along the columns of the input ``cmat``,
    %           that is, unrolling the ``cmat`` rows.
    %
    %       weight
    %
    %           The input MATLAB matrix of integer values
    %           of size ``size(cmat, dim)`` containing the
    %           set of weights to used for unrolling the
    %           input ``cmat``.
    %
    %           Negative weights lead to a runtime error.
    %           Any entry corresponding to a zero weight
    %           is ignored in the output ``vmat``.
    %
    %   Returns
    %   -------
    %
    %       vmat
    %
    %           The output MATLAB matrix of the same type and kind
    %           as the input ``cmat``, containing the ``cmat`` that
    %           is unrolled along the specified axis ``dim`` using
    %           the input weights.
    %
    %   Interface
    %   ---------
    %
    %       vmat = pm.array.verbose(cmat, dim, weight)
    %
    %   LICENSE
    %   -------
    %
    %       https://github.com/cdslaborg/paramonte/blob/main/LICENSE.md
    %
    if nargin < 3
        help("pm.array.verbose");
        error   ( newline ...
                + "At least three input arguments are required" + newline ...
                + "as described in the documentation above." + newline ...
                + newline ...
                );
    end
    if ~all(rem(weight, 1) == 0) || any(weight < 0)
        disp("weight = ");
        disp(weight);
        help("pm.array.verbose");
        error   ( newline ...
                + "The input ``weight`` argument displayed above" + newline ...
                + "must be all non-ngavtive whole-numbers." + newline ...
                + newline ...
                );
    end
    if ~any(dim == [1, 2])
        help("pm.array.verbose");
        disp("dim = ");
        disp(dim);
        error   ( newline ...
                + "The input ``dim`` argument displayed above" + newline ...
                + "must be either 1 or 2." + newline ...
                + newline ...
                );
    end
    if  length(weight) ~= size(cmat, dim)
        help("pm.array.verbose");
        error   ( newline ...
                + "The condition ``length(weight) == size(cmat, dim)``" + newline ...
                + "must hold for the corresponding input arguments." + newline ...
                + newline ...
                + pm.io.tab() + "length(weight) = " + string(length(weight)) + newline ...
                + pm.io.tab() + "size(cmat,dim) = " + string(size(cmat,dim)) + newline ...
                + newline ...
                );
    end
    cumsumwei = cumsum(weight);
    sumwei = cumsumwei(end);
    nrow = size(cmat, 1);
    ncol = size(cmat, 2);
    if dim == 1
        if isa(cmat, "cell")
            vmat = cell(sumwei, ncol);
        elseif isa(cmat, "double")
            vmat = zeros(sumwei, ncol);
        else
            vmat = cmat;
        end
        istart = 1;
        for ientry = 1 : nrow
            iend = cumsumwei(ientry);
            for iwei = istart : iend
                vmat(iwei, :) = cmat(ientry, :);
            end
            istart = iend + 1;
        end
    else
        if isa(cmat, "cell")
            vmat = cell(nrow, sumwei);
        elseif isa(cmat, "double")
            vmat = zeros(nrow, sumwei);
        else
            vmat = cmat;
        end
        istart = 1;
        for ientry = 1 : ncol
            iend = cumsumwei(ientry);
            for iwei = istart : iend
                vmat(:, iwei) = cmat(:, ientry);
            end
            istart = iend + 1;
        end
    end
end