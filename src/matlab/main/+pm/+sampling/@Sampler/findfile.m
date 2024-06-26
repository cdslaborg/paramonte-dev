function fileList = findfile(self, ftype, pattern)
    %
    %   Return a vector of MATLAB strings containing the
    %   fully-resolved paths matching the input ``pattern``.
    %
    %   Parameters
    %   ----------
    %
    %       ftype
    %
    %           The input scalar MATLAB string containing the sampler file type,
    %           which can be one of the following:
    %
    %               -   "chain"
    %               -   "sample"
    %               -   "report"
    %               -   "restart"
    %               -   "progress"
    %
    %       pattern
    %
    %           The input scalar MATLAB string containing either:
    %
    %               1.  a pattern to search for paths on the current system.
    %                   Wildcards may be used for basenames and for the directory parts.
    %                   If pattern contains directory parts, then these will
    %                   be included in the output ``fileList``.
    %
    %                   Following wildcards can be used within the specified ``pattern``:
    %
    %                       ``*``   :   match zero or more characters.
    %
    %               2.  a full weblink to download and save locally on the system temporary folder.
    %
    %           (**optional**, default = ``pwd()``)
    %
    %   Returns
    %   -------
    %
    %       fileList
    %
    %           The output vector of MATLAB strings containing the
    %           fully-resolved paths matching the input ``pattern``.
    %
    %   Interface
    %   ---------
    %
    %       sampler = pm.sampling.Sampler();
    %       fileList = sampler.findfile(ftype)
    %       fileList = sampler.findfile(ftype, [], [])
    %       fileList = sampler.findfile(ftype, [], silent)
    %       fileList = sampler.findfile(ftype, pattern, [])
    %       fileList = sampler.findfile(ftype, pattern, silent)
    %
    %   LICENSE
    %   -------
    %
    %       https://github.com/cdslaborg/paramonte/blob/main/LICENSE.md
    %
    if nargin < 3
        pattern = [];
    end
    ftype = string(ftype);
    suffix = ftype + ".txt";
    if isempty(pattern)
        if isempty(self.spec.outputFileName)
            if  pm.array.len(self.input) ~= 0
                % \todo
                % This extraction of ``outputFileName`` from the ``input`` file must be automated in future.
                error   ( newline ...
                        + "Apparently, you have set the ``input`` component of the sampler object." + newline ...
                        + "Extract the value of the simulation specification ``outputFileName`` from this ``input``." + newline ...
                        + "Then, assign it to the simulation specification ``spec.outputFileName``." + newline ...
                        + newline ...
                        );
            end
            %if ~self.silent
            %    warning ( newline ...
            %            + "The input simulation specification ``outputFileName`` is" + newline ...
            %            + "unset while the input argument ``pattern`` is missing." + newline ...
            %            + "Searching the current working directory:" + newline ...
            %            + newline ...
            %            + pm.io.tab + string(pwd) + newline ...
            %            + newline ...
            %            + "for potential ASCII " + ftype + " files..." + newline ...
            %            + newline ...
            %            );
            %end
            pattern = string(pwd());
        else
            pattern = self.spec.outputFileName;
        end
    end
    if isfile(pattern)
        % Check if the input path is a full path to a file.
        fileList = string(pattern);
        if ~self.silent && ~endsWith(pattern, suffix)
            warning ( newline ...
                    + "The identified " + ftype + " file:" + newline ...
                    + newline ...
                    + pm.io.tab + pattern + newline ...
                    + newline ...
                    + "does not end with the expected suffix """ + suffix + """." + newline ...
                    );
        end
    else
        % search for files matching the input pattern.
        if isfolder(pattern) && ~endsWith(pattern, filesep)
            % Ensure pattern is a directory with an explicit directory separator.
            pattern = pattern + filesep;
        end
        if endsWith(pattern, "*")
            dirList = dir(pattern);
        else
            dirList = dir(pattern + "*");
        end
        counter = 0;
        fileList = [];
        for ifile = 1 : length(dirList)
            if contains(dirList(ifile).name, suffix)
                counter = counter + 1;
                filePathModified = fullfile(string(dirList(ifile).folder), string(dirList(ifile).name));
                fileList = [fileList, filePathModified];
            end
        end
        if isempty(fileList)
            % check if the input path is a url.
            if pm.web.isurl(pattern)
                try
                    fileList = [string(websave(fullfile(tempdir, pm.web.basename(pattern)), pattern))];
                catch
                    warning ( newline ...
                            + "Failed to read data from the specified URL:" + newline ...
                            + pm.io.tab + newline ...
                            + newline ...
                            );
                end
            end
        end
        if  isempty(fileList)
            msg = newline ...
                + "Failed to detect any " + ftype + " files with the requested pattern:" + newline ...
                + newline ...
                + pm.io.tab + pattern + newline ...
                + newline ...
                + "Specify an input ``pattern`` that either" + newline ...
                + newline ...
                + pm.io.tab + "1.   points to one or more " + ftype + " files, or," + newline ...
                + pm.io.tab + "2.   represents the unique part of the names of a simulation." + newline ...
                + pm.io.tab + "     This unique-name is the common prefix in the names of" + newline ...
                + pm.io.tab + "     the output files of a given sampling simulation." + newline ...
                + newline ...
                + "Note that binary files ending with the suffix ""*.bin"" cannot be currently parsed." + newline ...
                ;
            if contains(ftype, "restart")
                msg = msg ...
                    + "For restart files, you can set the simulation specification ``restartFileFormat`` to" + newline ...
                    + newline ...
                    + pm.io.tab + "spec.restartFileFormat = ""ascii"";" + newline ...
                    + newline ...
                    + "to generate ASCII-format MATLAB-readable " + ftype + " files." ...
                    + newline ...
                    ;
            elseif contains(ftype, "chain")
                msg = msg ...
                    + "For chain files, you can set the simulation specification ``chainFileFormat`` to" + newline ...
                    + newline ...
                    + pm.io.tab + "spec.chainFileFormat = ""ascii"";" + newline ...
                    + newline ...
                    + "to generate ASCII-format MATLAB-readable " + ftype + " files." ...
                    + newline ...
                    ;
            end
            error(msg);
        end
    end
    if ~self.silent
        disp(string(length(fileList)) + " files were detected matching pattern: """ +  pattern + """");
    end
end