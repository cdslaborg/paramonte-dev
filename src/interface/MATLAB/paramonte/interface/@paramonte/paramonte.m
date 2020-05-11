%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  ParaMonte: plain powerful parallel Monte Carlo library.
%
%  Copyright (C) 2012-present, The Computational Data Science Lab
%
%  This file is part of ParaMonte library.
%
%  ParaMonte is free software: you can redistribute it and/or modify
%  it under the terms of the GNU Lesser General Public License as published by
%  the Free Software Foundation, version 3 of the License.
%
%  ParaMonte is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU Lesser General Public License for more details.
%
%  You should have received a copy of the GNU Lesser General Public License
%  along with ParaMonte.  If not, see <https://www.gnu.org/licenses/>.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   paramonte - This is the MATLAB interface to the ParaMonte: Plain Powerful Parallel Monte Carlo library.
%
%   What is ParaMonte?
%   ==================
%
%   ParaMonte is a serial/parallel library of Monte Carlo routines for sampling mathematical
%   objective functions of arbitrary-dimensions, in particular, the posterior distributions
%   of Bayesian models in data science, Machine Learning, and scientific inference, with the
%   design goal of unifying the
%
%       **automation** (of Monte Carlo simulations),
%       **user-friendliness** (of the library),
%       **accessibility** (from multiple programming environments),
%       **high-performance** (at runtime), and
%       **scalability** (across many parallel processors).
%
%   For more information on the installation, usage, and examples, visit:
%
%       https://www.cdslab.org/paramonte
%
%   The routines currently supported by the MATLAB interface of ParaMonte include:
%
%       ParaDRAM
%       ========
%
%           Parallel Delayed-Rejection Adaptive Metropolis-Hastings Markov Chain Monte Carlo Sampler.
%
%           EXAMPLE SERIAL USAGE
%           ====================
%
%           Copy and paste the following code enclosed between the
%           two comment lines in your MATLAB session:
%
%               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               pmlibRootDir = './'; % if needed, change this path to the ParaMonte library root directory
%               addpath(genpath(pmlibRootDir));
%               pm = paramonte();
%               pmpd = pm.ParaDRAM();
%               pmpd.runSampler ( 4                 ... number of dimensions of the objective function
%                               , @(x) -sum(x.^2)   ... the natural log of the objective function
%                               );
%               pmpd.readChain();
%               pmpd.chainList{1}.plot.grid.plot();
%               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           The mathematical objective function in the above example is a
%           is a multivariate Normal distribution centered at the origin,
%           whose natural logarithm is returned by the lambda (Anonymous)
%           function defined as a function handle input to the ParaDRAM
%           sampler.
%
%           EXAMPLE PARALLEL USAGE
%           ======================
%
%           First, make sure you have the required MPI libraries on your System:
%           (You can skip this step if you know that you already have 
%           a compatible MPI library installed on your system). 
%           On the MATLAB command line type the following, 
%
%               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               pmlibRootDir = './'; % if needed, change this path to the ParaMonte library root directory
%               addpath(genpath(pmlibRootDir));
%               pm = paramonte();
%               pm.verify();
%               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           This will verify the existence of a valid MPI library on your system and,
%           if missing, will install the MPI library on your system (with your permission).
%
%           Once the MPI installation is verified, 
%           copy and paste the following code enclosed 
%           between the two comment lines in your MATLAB session:
%           (You may want to restart your MATLAB session to ensure the MPI 
%           environmental variables have been loaded in your MATLAB session)
%
%               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               fid = fopen("main_mpi.m", "w")
%               sourceCode = ...
%               "pmlibRootDir = './'; % if needed, change this path to the ParaMonte library root directory" + newline + ...
%               "addpath(genpath(pmlibRootDir));" + newline + ...
%               "pm = paramonte();" + newline + ...
%               "pmpd = pm.ParaDRAM();" + newline + ...
%               "pmpd.mpiEnabled = true;" + newline + ...
%               "pmpd.runSampler ( 4                 ... number of dimensions of the objective function" + newline + ...
%               "                , @(x) -sum(x.^2)   ... the natural log of the objective function" + newline + ...
%               "                );"
%               fprintf( fid, "%s\n", sourceCode );
%               fclose(fid);
%               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%           This will generate a main_mpi.m MATLAB script file in the current
%           working directory of your MATLAB session. Now, you can execute
%           this MATLAB script file (main_mpi.m) in parallel in two ways:
%
%               1.  from inside MATLAB, on Windows:
%
%                   a.  On Windows: type the following,
%
%                       !mpiexec -localonly -n 3 matlab -batch main_mpi.m
%
%                   b.  On macOS/Linux: type the following,
%
%                       !mpiexec -n 3 matlab -batch main_mpi.m
%
%               2.  outside of MATLAB environment,
%
%                   a.  On Windows: from within a MATLAB-enabled command prompt, type the following,
%
%                       mpiexec -localonly -n 3 matlab -batch main_mpi.m
%
%                   b.  On macOS/Linux: from within a Bash terminal, type the following, 
%
%                       mpiexec -n 3 matlab -batch main_mpi.m
%
%               NOTE: In the above MPI launcher commands for Windows OS, 
%               NOTE: we assumed that you would be using the Intel MPI library, hence, 
%               NOTE: the reason for the extra flag -localonly. This flag runs the parallel 
%               NOTE: code only on one node, but in doing so, it avoids the use of Hydra service 
%               NOTE: and its registration. If you are not on a Windows cluster, (e.g., you are 
%               NOTE: using your personal device), then we recommend specifying this flag.
%
%               In both cases in the above, the script 'main_mpi.m' will run on 3 processors.
%               Feel free to change the number of processors to any number desired. But do not 
%               request more than the number of physical cores available on your system.
%
classdef paramonte %< dynamicprops

    properties (Access = public)
        website         = [];
        authors         = [];
        credits         = [];
        version         = [];
        ParaDRAM        = [];
    end

    properties (Access = protected, Hidden)
        Err = Err_class();
        verificationStatusFilePath
        buildInstructionNote
        objectName
    end

    properties (Access = public, Hidden)
        platform = [];
        prereqs
        names
        path
    end

    properties (Access = protected)
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    methods (Access = public)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function self = paramonte(varargin)

            self.path = struct();
            self.path.home = getHomePath();
            self.path.root = mfilename('fullpath');
            [self.path.root,~,~] = fileparts(self.path.root);
            self.path.root = string( getFullPath(fullfile(self.path.root,"..",".."),'lean') );
            addpath(genpath(self.path.root),'-begin');
            self.path.lib = string(fullfile(self.path.root, "lib"));
            self.path.auxil = string(fullfile(self.path.root, "auxil"));

            self.prereqs = struct();

            self.website = struct();
            self.website.home.url = "<a href=""https://www.cdslab.org/paramonte/"">https://www.cdslab.org/paramonte/</a>";
            self.website.github.issues.url = "<a href=""https://github.com/cdslaborg/paramonte/issues"">https://github.com/cdslaborg/paramonte/issues</a>";
            self.website.intel.mpi.home.url = "<a href=""https://software.intel.com/en-us/mpi-library"">https://software.intel.com/en-us/mpi-library</a>";
            self.website.intel.mpi.windows.url = "<a href=""https://software.intel.com/en-us/get-started-with-mpi-for-windows"">https://software.intel.com/en-us/get-started-with-mpi-for-windows</a>";
            self.website.openmpi.home.url = "<a href=""https://www.open-mpi.org/"">https://www.open-mpi.org/</a>";

            self.platform.isWin32 = ispc;
            self.platform.isMacOS = ismac;
            self.platform.isLinux = isunix;

            self.authors = "The Computational Data Science Lab @ The University of Texas";
            self.credits = "Peter O'Donnell Fellowship / Texas Advanced Computing Center";
            for versionType = ["interface","kernel"]
                self.version.(versionType) = Version_class(self.path.auxil,versionType);
            end

            self.verificationStatusFilePath = fullfile( self.path.auxil, ".verificationEnabled" );
            self.buildInstructionNote   = "If your platform is non-Windows and is compatible with GNU Compiler Collection (GCC)," + newline ...
                                        + "you can also build the required ParaMonte kernel's shared object files on your system" + newline ...
                                        + "by calling ParaMonte module's build() function from within your MATLAB enviroment, like:" + newline + newline ...
                                        + "    import paramonte as pm" + newline ...
                                        + "    pm.build()";

            self.names.paramonte = "ParaMonte";
            self.names.paradram = "ParaDRAM";
            self.names.paranest = "ParaNest";
            self.names.paratemp = "ParaTemp";

            self.Err.marginTop = 1;
            self.Err.marginBot = 1;
            self.Err.prefix = self.names.paramonte;
            self.Err.resetEnabled = false;

            % check interface type

            errorOccurred = false;
            matlabKernelEnabled = false;
            if nargin==1
                if isa(varargin{1},"char")
                    if strcmpi(varargin{1},"matlab")
                        matlabKernelEnabled = true;
                    else
                        errorOccurred = true;
                    end
                elseif isa(varargin{1},'string')
                    if strcmpi(varargin{1},"matlab")
                        matlabKernelEnabled = true;
                    else
                        errorOccurred = true;
                    end
                end
            elseif nargin~=0
                errorOccurred = true;
            end
            if errorOccurred
                self.Err.msg    = "The paramonte class constructor takes at most one argument of value ""matlab"". You have entered:" + newline + newline ...
                                + "    " + string(strrep(join(string(varargin)," "),'\','\\')) ...
                                + "Pass the input value ""matlab"" only if you know what it means. Otherwise, do not pass any input values. " ...
                                + "ParaMonte will properly set things up for you.";
                self.Err.abort()
            end

            if matlabKernelEnabled
                self.ParaDRAM = ParaDRAM_class;
            else
                self.ParaDRAM = ParaDRAM;
            end

            self.verify("reset",false)

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function verify(self,varargin)
        %    checks (or rechecks) the requirements of the installed ParaMonte library
        %
        %    Parameters
        %    ----------
        %        reset
        %            boolean whose default value is True. If True,
        %            a thorough verification of the existence of the required
        %            libraries will performed, as if it is the first ParaMonte
        %            module import.
        %
        %    Returns
        %    -------
        %        None

            self.objectName = inputname(1);

            invalidArgumentProvided = false;
            if nargin==1
                reset = true;
            elseif nargin==2
                if isa(varargin{1},"logical")
                    reset = varargin{1};
                else
                    invalidArgumentProvided = true;
                end
            elseif nargin==3
                if ( isa(varargin{1},"string") || isa(varargin{1},"char") ) && ( strcmpi(varargin{1},"reset") && isa(varargin{2},"logical") )
                    reset = varargin{2};
                else
                    invalidArgumentProvided = true;
                end
            end
            if invalidArgumentProvided
                fullMethodName = self.objectName + ".verify";
                error   ( newline ...
                        + "Invalid usage of " + fullMethodName + "() detected. Possible valid usages are:" + newline + newline ...
                        + "    " + fullMethodName + "()" + newline ...
                        + "    " + fullMethodName + "(true) % : the verification status in the ParaMonte cache will be reset to the default initial value." + newline ...
                        + "    " + fullMethodName + "('reset',true) % same as above." ...
                        );
            end

            % require MATLAB >2017a

            matlabVersion = version("-release");
            matlabVersion = str2double(matlabVersion(1:4));
            if matlabVersion < 2017
                error   ( newline ...
                        + "MATLAB R" + string(matlabVersion) + "a or newer is required for proper ParaMonte functionality. Please install a compatible version of MATLAB." ...
                        + newline ...
                        );
            end

            % ensure messages are printed only for the first-time import

            if reset; self.writeVerificationStatusFile("True"); end

            try
                fid = fopen(self.verificationStatusFilePath);
                verificationEnabledStr = fgetl(fid);
                fclose(fid);
            catch
                error   ( newline ...
                        + "Failed to read the ParaMonte verification status file. It looks like someone has messed up your ParaMonte library. Visit: " ...
                        + "    " + self.website.home.url + "to download a fresh version of the ParaMonte MATLAB library." ...
                        + newline ...
                        );
            end
            if verificationEnabledStr=="False"
                verificationEnabled = false;
            elseif verificationEnabledStr=="True"
                verificationEnabled = true;
            else
                error   ( newline ...
                        + "The internal settings of the ParaMonte library appears to have been messed up " ...
                        + "potentially by the operating system, MATLAB, or some third party applications. " ...
                        + "Please reinstall ParaMonte by typing the following commands " ...
                        + "on a MATLAB-aware command-line interface:" + newline + newline ...
                        + "    pip uninstall paramonte" + newline ...
                        + "    pip install paramonte" ...
                        + newline ...
                        );
            end

            if verificationEnabled

                % ensure 64-bit architecture

                if strcmpi(getArch(),"x64") && (self.platform.isWin32 || self.platform.isLinux || self.platform.isMacOS)

                    self.displayParaMonteBanner();

                    % library path

                    if ~self.platform.isWin32; self.setupUnixPath(); end

                    % search for the MPI library

                    mpiBinPath = self.findMPI();
                    if isempty(mpiBinPath)
                        self.Err.msg    = "The MPI runtime libraries for 64-bit architecture could not be detected on your system. " ...
                                        + "The MPI runtime libraries are required for the parallel ParaMonte simulations. " ...
                                        + "For Windows and Linux operating systems, you can download and install the Intel MPI runtime " ...
                                        + "libraries, free of charge, from Intel website (" + self.website.intel.mpi.home.url + "). " ...
                                        + "For macOS (Darwin operating system), you will have to download and install the Open-MPI library " ...
                                        + "(" + self.website.openmpi.home.url + ")." + newline + newline ...
                                        + "Alternatively, the ParaMonte library can automatically install these library for you now. " + newline + newline ...
                                        + "If you don't know how to download and install the correct MPI runtime library version, " ...
                                        + "we strongly recommend that you let the ParaMonte library to install this library for you. " ...
                                        + "If so, ParaMonte will need access to the World-Wide-Web to download the library " ...
                                        + "and will need your administrative permission to install it on your system. " ...
                                        + "Therefore, if you have any active firewall on your system such as ZoneAlarm, " ...
                                        + "please make sure your firewall allows ParaMonte to access the Internet.";
                        self.Err.warn();

                        isYes = self.getUserResponse( newline ...
                                                    + "    Do you wish to download and install the MPI runtime library" + newline ...
                                                    + "    for parallel simulations on your system now (y/n)? " ...
                                                    );
                        if isYes
                            self.installMPI();
                            self.writeVerificationStatusFile("True");
                        else
                            self.Err.msg    = "Skipping the MPI library installation... " + newline ...
                                            + "It is now the user's responsibility to install the " ...
                                            + "required libraries for parallel simulations. " ...
                                            + "If you ever wish to install MPI libraries via ParaMonte again, " ...
                                            + "please try:" + newline + newline ...
                                            + "    pm = paramonte();" + newline ...
                                            + "    pm.verify();" + newline + newline ...
                                            + "For more information visit:" + newline + newline ...
                                            + "    " + self.website.home.url;
                            self.Err.note();
                            self.writeVerificationStatusFile("False");
                        end

                    else

                        self.writeVerificationStatusFile("False");

                    end

                    self.dispFinalMessage();

                else

                    self.warnForUnsupportedPlatform();
                    self.build();

                end

            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function build(self,varargin)

            if nargin==1
                flags = "";
            elseif nargin==1
                flags = varargin{1};
            else
                error("invalid number of input arguments.");
            end

            self.Err.prefix = self.names.paramonte;
            self.Err.marginTop = 1;
            self.Err.marginBot = 1;

            if self.platform.isWin32

                self.Err.msg    = "The ParaMonte library build on Windows Operating Systems (OS) requires " + newline ...
                                + "the installation of the following software on your system:" + newline + newline ...
                                + "    -- Microsoft Visual Studio (MSVS) (Community Edition >2017)" + newline ...
                                + "    -- Intel Parallel Studio >2018, which is built on top of MSVS" + newline + newline ...
                                + "If you don't have these software already installed on your system, " + newline ...
                                + "please visit the following page for the installation instructions:" + newline + newline ...
                                + "    " + self.website.home.url + newline + newline ...
                                + "Follow the website's instructions to build the ParaMonte library on your system.";
                self.Err.abort();

            else

                self.Err.msg    = "You are requesting to build the ParaMonte kernel libraries on your system. " + newline ...
                                + "The kernel library build requires ParaMonte-compatible versions of the following " + newline ...
                                + "compilers and parallelism libraries to be installed on your system: " + newline + newline ...
                                + "    GNU compiler collection (GCC >8.3)" + newline ...
                                + "    MPI library (MPICH >3.2) on Linux OS or Open-MPI on Darwin OS" + newline ...
                                + "    OpenCoarrays >2.8" + newline + newline ...
                                + "The full installation of these software will require 4 to 5 Gb of free space " + newline ...
                                + "on your system (where the ParaMonte-MATLAB interface is already installed)." + newline ...
                                + "Note that the installation script is in Bash and therefore requires Bash shell." + newline ...
                                + "An existing recent installation of the GNU Compiler Collection (GCC) on your" + newline ...
                                + "system would be also highly desirable and will significantly cut the build time." + newline ...
                                + "Also, downloading the prerequisites requires access to the Internet." + newline ...
                                + "If you have an Internet firewall active on your system, please make sure to" + newline ...
                                + "turn it off before proceeding with the local installation of ParaMonte.";
                self.Err.note();

                buildEnabled = getUserResponse  ( newline + "    Do you wish to download and install the ParaMonte library" ...
                                                + newline + "    and its prerequisites on your system now (y/n)? " ...
                                                );

                if buildEnabled

                    if self.platform.isMacOS
                        self.buildParaMontePrereqsForMac();
                    end

                    pmGitTarPath = fullfile( self.path.lib, "master.tar.gz" );
                    pmGitTarPath = websave(pmGitTarPath,"https://github.com/cdslaborg/paramonte/archive/master.tar.gz");
                    pmGitRootDir = fullfile(self.path.lib, "paramonte-master");

                    try
                        untar(pmGitTarPath,self.path.lib);
                        pmGitInstallScriptPath = fullfile(pmGitRootDir, "install.sh");
                        if ~isfile(pmGitInstallScriptPath)
                            self.Err.msg    = "Internal error occurred." + newline ...
                                            + "Failed to detect the ParaMonte installation Bash script." + newline ...
                                            + "Please report this issue at " + newline + newline ...
                                            + "    " + self.website.github.issues.url + newline + newline ...
                                            + "Visit, " ...
                                            + "    " + self.website.home.url + newline + newline ...
                                            + "for instructions to build ParaMonte library on your system.";
                            self.Err.abort();
                        end
                    catch
                        self.Err.msg    = "Unzipping of the ParaMonte tarball failed." + newline ...
                                        + "Make sure you have tar software installed on your system and try again.";
                        self.Err.abort();
                    end

                    [errorOccurred, ~] = system("chmod +x " + string(strrep(pmGitInstallScriptPath,'\','\\')));
                    if errorOccurred
                        self.Err.msg    = "The following action failed:" + newline + newline ...
                                        + "chmod +x " + string(strrep(pmGitInstallScriptPath,'\','\\')) + newline + newline ...
                                        + "skipping...";
                        self.Err.warn();
                    end

                    originalDir = cd(pmGitRootDir);

                    [errorOccurred1, ~] = system( ['find ', pmGitRootDir, ' -type f -iname \"*.sh\" -exec chmod +x {} \;'] );
                    [errorOccurred2, ~] = system( pmGitInstallScriptPath + " --lang matlab --test_enabled true --exam_enabled false --yes-to-all " + flags );
                    if errorOccurred1 || errorOccurred2
                        self.Err.msg    = "Local installation of ParaMonte failed." + newline ...
                                        + "Please report this issue at " + newline + newline ...
                                        + "    " + self.website.github.issues.url;
                        self.Err.abort();
                    end

                    cd(originalDir);

                    % copy files to the library folder

                    matlabBinDir = fullfile( pmGitRootDir , "bin" , "MATLAB" , "paramonte" );
                    fileList = dir( fullfile( matlabBinDir , "libparamonte_*" ) );

                    if isempty(fileList)

                        self.Err.msg    = "ParaMonte kernel libraries build and installation appears to have failed. " + newline ...
                                        + "You can check this path:" + newline + newline ...
                                        + string(strrep(matlabBinDir,'\','\\')) + newline + newline ...
                                        + "to find out if any shared objects with the prefix 'libparamonte_' have been generated or not." + newline ...
                                        + "Please report this issue at " + newline + newline ...
                                        + "    " + self.website.github.issues.url;
                        self.Err.abort();

                    else

                        self.Err.msg    = "ParaMonte kernel libraries build appears to have succeeded. " + newline ...
                                        + "copying the kernel files to the paramonte MATLAB module directory...";
                        self.Err.note();

                        for file = string({fileList(:).name})
                            self.Err.msg = "file: " + string(strrep(file,'\','\\'));
                            self.Err.marginTop = 0;
                            self.Err.marginBot = 0;
                            self.Err.note();
                            shutil.copy(file, self.path.lib);
                        end

                        self.Err.msg = "ParaMonte kernel libraries should be now usable on your system.";
                        self.Err.marginTop = 1;
                        self.Err.marginBot = 1;
                        self.Err.note();

                        setupFilePath = fullfile( pmGitRootDir , "build", "prerequisites", "prerequisites", "installations", "opencoarrays", "2.8.0", "setup.sh" );

                        if isfile(setupFilePath)
                            bashrcContents = getBashrcContents();
                            setupFilePathCmd = "source " + setupFilePath;
                            if ~contains(bashrcContents,setupFilePathCmd)
                                [~, ~] = system( "chmod 777 ~/.bashrc");
                                [~, ~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                                [~, ~] = system( "chmod 777 ~/.bashrc && echo '# >>> ParaMonte library local installation setup >>>' >> ~/.bashrc" );
                                [~, ~] = system( "chmod 777 ~/.bashrc && echo '" + setupFilePathCmd + "' >>  ~/.bashrc" );
                                [~, ~] = system( "chmod 777 ~/.bashrc && echo '# <<< ParaMonte library local installation setup <<<' >> ~/.bashrc" );
                                [~, ~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                                [~, ~] = system( "chmod 777 ~/.bashrc && sh ~/.bashrc" );
                            end
                            self.Err.msg    = "Whenever you intend to use ParaMonte in the future, before opening your MATLAB session, " + newline ...
                                            + "please execute the following command in your Bash shell to ensure all required paths " + newline ...
                                            + "are properly defined in your environment:" + newline + newline ...
                                            + "    " + string(strrep(setupFilePathCmd,'\','\\')) + newline + newline ...
                                            + "mission accomplished.";
                            self.Err.warn();
                        end

                    end

                    self.writeVerificationStatusFile("True");

                else

                    self.Err.msg = "Aborting the ParaMonte-for-MATLAB local build on your system.";
                    self.Err.warn();

                end

            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end % methods (dynamic)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    methods (Access=public, Hidden)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function warnForUnsupportedPlatform(self)
            self.Err.msg    = "The ParaMonte sampler kernel is currently exclusively available " ...
                            + "on AMD64 (64-bit) architecture for Windows/Linux/Darwin Operating Systems (OS). " ...
                            + "Your system appears to be of a different architecture or OS. As a result, " ...
                            + "the core sampler routines of ParaMonte will not be available on your system. However, " ...
                            + "the generic MATLAB interface of ParaMonte will is available on your system, which can " ...
                            + "be used for post-processing and visualization of the output files from " ...
                            + "already-performed ParaMonte simulations or other similar Monte Carlo simulations. " ...
                            + "There are ongoing efforts, right now as you read this message, to further increase the " ...
                            + "availability of ParaMonte library on a wider-variety of platforms and architectures. " ...
                            + "Stay tuned for updates by visiting " + newline + newline ...
                            + "    " + self.website.home.url + newline + newline ...
                            + "That said," + newline + newline ...
                            + "if your platform is non-Windows and is compatible with GNU Compiler Collection (GCC)," + newline + newline ...
                            + "you can also build the required ParaMonte kernel's shared object files on your system " ...
                            + "by calling ParaMonte module's build() function from within your MATLAB environment.";
            self.Err.marginTop = 1;
            self.Err.marginBot = 1;
            self.Err.prefix = self.names.paramonte;
            self.Err.warn();
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function setupUnixPath(self)

            bashrcContents = getBashrcContents();
            dlibcmd = "export LD_LIBRARY_PATH=" + self.path.lib + ":$LD_LIBRARY_PATH";
            if ~contains(bashrcContents,dlibcmd)
                [~,~] = system( "chmod 777 ~/.bashrc");
                [~,~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                [~,~] = system( "chmod 777 ~/.bashrc && echo '# >>> ParaMonte shared library setup >>>' >> ~/.bashrc" );
                [~,~] = system( "chmod 777 ~/.bashrc && echo 'if [ -z ${LD_LIBRARY_PATH+x} ]; then' >> ~/.bashrc" );
                [~,~] = system( "chmod 777 ~/.bashrc && echo '    export LD_LIBRARY_PATH=.' >> ~/.bashrc" );
                [~,~] = system( "chmod 777 ~/.bashrc && echo 'fi' >> ~/.bashrc" );
                [~,~] = system( "chmod 777 ~/.bashrc && echo '" + dlibcmd + "' >>  ~/.bashrc" );
                [~,~] = system( "chmod 777 ~/.bashrc && echo '# <<< ParaMonte shared library setup <<<' >> ~/.bashrc" );
                [~,~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                [~,~] = system( "chmod 777 ~/.bashrc && sh ~/.bashrc" );
            end

            localInstallDir = getLocalInstallDir();
            if ~isempty(localInstallDir.root)

                pathcmd = [];
                dlibcmd = [];
                if ~isempty(localInstallDir.gnu.bin); pathcmd = "export PATH=" + localInstallDir.gnu.bin + ":$PATH"; end
                if ~isempty(localInstallDir.gnu.lib); dlibcmd = "export LD_LIBRARY_PATH=" + localInstallDir.gnu.lib + ":$LD_LIBRARY_PATH"; end
                pathcmdIsNotEmpty = ~isempty(pathcmd);
                dlibcmdIsNotEmpty = ~isempty(dlibcmd);
                pathcmdNotInBashrcContents = ~contains(bashrcContents,pathcmd);
                dlibcmdNotInBashrcContents = ~contains(bashrcContents,dlibcmd);
                if pathcmdIsNotEmpty || dlibcmdIsNotEmpty
                    if pathcmdNotInBashrcContents || dlibcmdNotInBashrcContents
                        [~,~] = system( "chmod 777 ~/.bashrc");
                        [~,~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                        [~,~] = system( "chmod 777 ~/.bashrc && echo '# >>> ParaMonte local GNU installation setup >>>' >> ~/.bashrc" );
                        if pathcmdIsNotEmpty
                            if pathcmdNotInBashrcContents
                                [~,~] = system( "chmod 777 ~/.bashrc && echo 'if [ -z ${PATH+x} ]; then' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '    export PATH=.' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo 'fi' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '" + pathcmd + "' >>  ~/.bashrc" );
                            end
                        end
                        if dlibcmdIsNotEmpty
                            if dlibcmdNotInBashrcContents
                                [~,~] = system( "chmod 777 ~/.bashrc && echo 'if [ -z ${LD_LIBRARY_PATH+x} ]; then' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '    export LD_LIBRARY_PATH=.' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo 'fi' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '" + dlibcmd + "' >>  ~/.bashrc" );
                            end
                        end
                    end
                    if pathcmdNotInBashrcContents || dlibcmdNotInBashrcContents
                        [~,~] = system( "chmod 777 ~/.bashrc && echo '# <<< ParaMonte local GNU installation setup <<<' >> ~/.bashrc" );
                        [~,~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                        [~,~] = system( "chmod 777 ~/.bashrc && sh ~/.bashrc" );
                    end
                end

                pathcmd = [];
                dlibcmd = [];
                if ~isempty(localInstallDir.mpi.bin); pathcmd = "export PATH=" + localInstallDir.mpi.bin + ":$PATH"; end
                if ~isempty(localInstallDir.mpi.lib); dlibcmd = "export LD_LIBRARY_PATH=" + localInstallDir.mpi.lib + ":$LD_LIBRARY_PATH"; end
                pathcmdIsNotEmpty = ~isempty(pathcmd);
                dlibcmdIsNotEmpty = ~isempty(dlibcmd);
                pathcmdNotInBashrcContents = ~contains(bashrcContents,pathcmd);
                dlibcmdNotInBashrcContents = ~contains(bashrcContents,dlibcmd);
                if pathcmdIsNotEmpty || dlibcmdIsNotEmpty
                    if pathcmdNotInBashrcContents || dlibcmdNotInBashrcContents
                        [~,~] = system( "chmod 777 ~/.bashrc");
                        [~,~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                        [~,~] = system( "chmod 777 ~/.bashrc && echo '# >>> ParaMonte local MPI installation setup >>>' >> ~/.bashrc" );
                        if pathcmdIsNotEmpty
                            if pathcmdNotInBashrcContents
                                [~,~] = system( "chmod 777 ~/.bashrc && echo 'if [ -z ${PATH+x} ]; then' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '    export PATH=.' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo 'fi' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '" + pathcmd + "' >>  ~/.bashrc" );
                            end
                        end
                        if dlibcmdIsNotEmpty
                            if dlibcmdNotInBashrcContents
                                [~,~] = system( "chmod 777 ~/.bashrc && echo 'if [ -z ${LD_LIBRARY_PATH+x} ]; then' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '    export LD_LIBRARY_PATH=.' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo 'fi' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '" + dlibcmd + "' >>  ~/.bashrc" );
                            end
                        end
                    end
                    if pathcmdNotInBashrcContents || dlibcmdNotInBashrcContents
                        [~,~] = system( "chmod 777 ~/.bashrc && echo '# <<< ParaMonte local MPI installation setup <<<' >> ~/.bashrc" );
                        [~,~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                        [~,~] = system( "chmod 777 ~/.bashrc && sh ~/.bashrc" );
                    end
                end
            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function localInstallDir = getLocalInstallDir(self)

            localInstallDir = struct();
            localInstallDir.root = [];

            localInstallDir.mpi = struct();
            localInstallDir.mpi.root = [];
            localInstallDir.mpi.bin = [];
            localInstallDir.mpi.lib = [];

            localInstallDir.gnu = struct();
            localInstallDir.gnu.root = [];
            localInstallDir.gnu.bin = [];
            localInstallDir.gnu.lib = [];

            localInstallDir.caf = struct();
            localInstallDir.caf.root = [];
            localInstallDir.caf.bin = [];
            localInstallDir.caf.lib = [];

            pmGitRootDir = fullfile( self.path.lib , "paramonte-master" );

            if isfolder(pmGitRootDir)

                localInstallDir.root = pmGitRootDir;

                % mpi

                temp = fullfile( localInstallDir.root, "build", "prerequisites", "prerequisites", "installations", "mpich", "3.2" );
                if isfolder(temp)
                    localInstallDir.mpi.root = temp;
                    temp = fullfile(localInstallDir.mpi.root, "bin");
                    if isfolder(temp); localInstallDir.mpi.bin = temp; end
                    temp = fullfile(localInstallDir.mpi.root, "lib");
                    if isfolder(temp); localInstallDir.mpi.lib = temp; end
                end

                % gnu

                temp = fullfile( localInstallDir.root, "build", "prerequisites", "prerequisites", "installations", "gnu", "8.3.0" );
                if isfolder(temp)
                    localInstallDir.gnu.root = temp;
                    temp = fullfile(localInstallDir.gnu.root, "bin");
                    if isfolder(temp); localInstallDir.gnu.bin = temp; end
                    temp = fullfile(localInstallDir.gnu.root, "lib64");
                    if isfolder(temp); localInstallDir.gnu.lib = temp; end
                end

                % caf

                temp = fullfile( localInstallDir.root, "build", "prerequisites", "prerequisites", "installations", "opencoarrays", "2.8.0" );
                if isfolder(temp)
                    localInstallDir.caf.root = temp;
                    temp = fullfile(localInstallDir.caf.root, "bin");
                    if isfolder(temp); localInstallDir.caf.bin = temp; end
                    temp = fullfile(localInstallDir.caf.root, "lib64");
                    if isfolder(temp); localInstallDir.caf.lib = temp; end
                end

            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function mpiBinPath = findMPI(self)
            % Returns the MPI bin directory if it exists, otherwise empty.

            mpiBinPath = [];

            if self.platform.isWin32

                pathList = getenv("PATH");
                pathList = string(strsplit(pathList,';'));
                for thisPath = pathList
                    pathLower = lower(thisPath);
                    pathLower = string(strrep(pathLower,'\',''));
                    if contains(pathLower,"mpiintel64bin")
                        mpivarsFilePath = fullfile( thisPath, "mpivars.bat" );
                        if isfile(mpivarsFilePath)
                            mpivarsCommand = '"' + mpivarsFilePath + '"';
                            self.Err.msg    = "Intel MPI library for 64-bit architecture detected at: " + newline + newline ...
                                            + "    " + string(strrep(thisPath,'\','\\')) + newline + newline ...
                                            + "To perform ParaMonte simulations in parallel on a single node, run the " + newline ...
                                            + "following two commands, in the form and order specified, on a MATLAB-aware, " + newline ...
                                            + "mpiexec-aware command-line interface such as the Intel Parallel Studio's command-prompt:" + newline + newline ...
                                            + "    " + string(strrep(mpivarsCommand,'\','\\')) + newline + newline ...
                                            + "    mpiexec -localonly -n NUM_PROCESSES MATLAB -batch 'main'" + newline + newline ...
                                            + "where, " + newline + newline ...
                                            + "    0.   the first command defines the essential environment variables and, " + newline ...
                                            + "         the second command runs in the simulation in parallel, in which, " + newline ...
                                            + "    1.   you should replace NUM_PROCESSES with the number of processors you " + newline ...
                                            + "         wish to assign to your simulation task, " + newline ...
                                            + "    2.   -localonly indicates a parallel simulation on only a single node (this " + newline ...
                                            + "         flag will obviate the need for MPI library credentials registration). " + newline ...
                                            + "         For more information, visit: " + newline + newline ...
                                            + "             " + self.website.intel.mpi.windows.url + newline + newline ...
                                            + "    3.   main.m is the MATLAB file which serves as the entry point to " + newline ...
                                            + "         your simulation, where you call ParaMonte sampler routines. " + newline + newline ...
                                            + "Note that the above two commands must be executed on a command-line that recognizes " + newline ...
                                            + "both MATLAB and mpiexec applications, such as the Intel Parallel Studio's command-prompt. " + newline ...
                                            + "For more information, in particular, on how to register to run Hydra services " + newline ...
                                            + "for multi-node simulations on Windows servers, visit: " + newline + newline ...
                                            + "    " + self.website.home.url;
                            self.Err.marginTop = 1;
                            self.Err.marginBot = 1;
                            self.Err.prefix = self.names.paramonte;
                            self.Err.note();

                            setupFilePath = fullfile(self.path.lib, "setup.bat");
                            fid = fopen(setupFilePath,"w");
                            fprintf(fid,"@echo off\n");
                            fprintf(fid,"cd " + string(strrep(thisPath, '\', '\\')) + " && mpivars.bat quiet\n");
                            fprintf(fid,"cd " + string(strrep(self.path.lib, '\', '\\')) + "\n");
                            fprintf(fid,"@echo on\n");
                            fclose(fid);

                            mpiBinPath = thisPath;
                            return
                        end
                    end
                end

            elseif self.platform.isLinux

                pathList = getenv("PATH");
                pathList = string(strsplit(pathList,":"));
                for thisPath = pathList
                    pathLower = lower(thisPath);
                    pathLower = strrep(pathLower,"/","");
                    if contains(pathLower, "linuxmpiintel64")
                        mpivarsFilePath = fullfile(thisPath, "mpivars.sh");
                        if isfile(mpivarsFilePath)
                            mpivarsCommand = """" + mpivarsFilePath + """";
                            self.Err.msg    = "Intel MPI library for 64-bit architecture detected at: " + newline + newline ...
                                            + "    " + string(strrep(thisPath,'\','\\')) + newline + newline ...
                                            + "To perform ParaMonte simulations in parallel on a single node, run the " + newline ...
                                            + "following two commands, in the form and order specified, in a Bash shell, " + newline + newline ...
                                            + "    source " + string(strrep(mpivarsCommand,'\','\\')) + newline + newline ...
                                            + "    mpiexec -n NUM_PROCESSES MATLAB -batch 'main'" + newline + newline ...
                                            + "where, " + newline + newline ...
                                            + "    0.   the first command defines the essential environment variables and, " + newline ...
                                            + "         the second command runs in the simulation in parallel, in which, " + newline ...
                                            + "    1.   you should replace NUM_PROCESSES with the number of processors you " + newline ...
                                            + "         wish to assign to your simulation task, " + newline ...
                                            + "    2.   main.m is the MATLAB file which serves as the entry point to " + newline ...
                                            + "         your simulation, where you call ParaMonte sampler routines. " + newline + newline ...
                                            + "For more information on how to install and use and run parallel ParaMonte " + newline ...
                                            + "simulations on Linux systems, visit:" + newline + newline ...
                                            + "    " + self.website.home.url;
                            self.Err.msgmarginTop = 1;
                            self.Err.msgmarginBot = 1;
                            self.Err.msgmethodName = self.names.paramonte;
                            self.Err.note();

                            setupFilePath = fullfile(self.path.lib, "setup.sh");
                            fid = fopen(setupFilePath,"w");
                            fprintf(fid,"source " + string(strrep(mpivarsCommand, '\', '\\')));
                            fclose(fid);

                            mpiBinPath = thisPath;
                            return
                        end
                    end
                end

            elseif self.platform.isMacOS

                gfortranPath = [];
                try
                    [~,gfortranVersion] = system("gfortran --version");
                    if contains(string(gfortranVersion), "GCC 9.")
                        [~,gfortranPath] = system("command -v gfortran");
                    end
                catch
                    warning("failed to capture gfortran version");
                end

                mpiexecPath = [];
                try
                    [~,mpiexecVersion] = system("mpiexec --version");
                    if contains(string(mpiexecVersion), "open-mpi")
                        [~,mpiexecPath] = system("command -v mpiexec");
                    end
                catch
                    warning("failed to capture mpiexec version");
                end

                if ~isempty(mpiexecPath) && ~isempty(gfortranPath)
                    [thisPath,~,~] = fileparts(mpiexecPath);
                    self.Err.msg    = "MPI runtime libraries detected at: " + newline + newline ...
                                    + "    " + string(strrep(thisPath,'\','\\')) + newline + newline ...
                                    + "To perform ParaMonte simulations in parallel on a single node, run the " + newline ...
                                    + "following command, in the form and order specified, in a Bash shell, " + newline + newline ...
                                    + "    mpiexec -n NUM_PROCESSES MATLAB -batch 'main'" + newline + newline ...
                                    + "where, " + newline + newline ...
                                    + "    0.   the first command defines the essential environment variables and, " + newline ...
                                    + "         the second command runs in the simulation in parallel, in which, " + newline ...
                                    + "    1.   you should replace NUM_PROCESSES with the number of processors you " + newline ...
                                    + "         wish to assign to your simulation task, " + newline ...
                                    + "    2.   main.m is the MATLAB file which serves as the entry point to " + newline ...
                                    + "         your simulation, where you call ParaMonte sampler routines. " + newline + newline ...
                                    + "For more information on how to install and use and run parallel ParaMonte " + newline ...
                                    + "simulations on Darwin operating systems, visit:" + newline + newline ...
                                    + "    " + self.website.home.url;
                    self.Err.marginTop = 1;
                    self.Err.marginBot = 1;
                    self.Err.prefix = self.names.paramonte;
                    self.Err.note();
                    mpiBinPath = thisPath;
                    return
                end

            else

                LocalInstallDir = getLocalInstallDir();
                if ~isempty(LocalInstallDir.mpi.bin) && ~isempty(LocalInstallDir.mpi.lib)
                    mpiBinPath = LocalInstallDir.mpi.bin;
                    return
                end

            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function dependencyList = getDependencyList(self)
            fileName = ".dependencies_";
            if self.platform.isWin32; fileName = fileName + "windows"; end
            if self.platform.isMacOS; fileName = fileName + "macos"; end
            if self.platform.isLinux; fileName = fileName + "linux"; end
            text = fileread(fullfile(self.path.auxil,fileName));
            dependencyList = [string(strsplit(text,newline))];
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function installMPI(self)

            self.Err.prefix = self.names.paramonte;
            self.Err.marginTop = 1;
            self.Err.marginBot = 1;

            if self.platform.isWin32 || self.platform.isLinux

                self.Err.msg    = "Downloading the Intel MPI runtime libraries for 64-bit architecture..." + newline ...
                                + "Please make sure your firewall allows access to the Internet.";
                self.Err.note();

                self.prereqs.list = self.getDependencyList();
                for dependency = self.prereqs.list
                    fullFilePath = fullfile( self.path.lib, dependency );
                    fullFilePath = websave(fullFilePath, "https://github.com/cdslaborg/paramonte/releases/download/" + self.version.dump("kernel") + "/" + dependency);
                    if self.platform.isWin32; intelMpiFilePrefix = "w_mpi-rt_p_"; intelMpiFileSuffix = ".exe"; end
                    if self.platform.isLinux; intelMpiFilePrefix = "l_mpi-rt_"; intelMpiFileSuffix = ".tgz"; end
                    if contains(dependency,intelMpiFilePrefix) && contains(dependency,intelMpiFileSuffix)
                        self.prereqs.mpi.intel.fullFileName = string( dependency );
                        self.prereqs.mpi.intel.fullFilePath = string( fullFilePath );
                        self.prereqs.mpi.intel.version = string( dependency{1}(length(intelMpiFilePrefix)+1,end-length(intelMpiFileSuffix)+1) );
                    end
                end

                self.Err.msg    = "Installing the Intel MPI library for 64-bit architecture..." + newline ...
                                + "file location: " + string(strrep(self.prereqs.mpi.intel.fullFilePath,'\','\\'));
                self.Err.note();

                self.Err.msg    = "Please do not change the default installation location of the MPI library suggested by the installer." + newline ...
                                + "If you do change the default path, the onus will be on you to ensure the path to the " + newline ...
                                + "MPI runtime libraries exist in the environmental PATH variable of your session.";
                self.Err.warn();

                if self.platform.isWin32
                    [errorOccurred, output] = system(self.prereqs.mpi.intel.fullFilePath);
                    if errorOccurred
                        self.Err.msg    = "Intel MPI library installation might have failed. Exit flag: " + string(errorOccurred) + "." ...
                                        + "mpiexec command output: " + string(output);
                        self.Err.warn();
                    else
                        self.writeVerificationStatusFile("True");
                        self.Err.msg    = "Intel MPI library installation appears to have succeeded. " + newline ...
                                        + "Now close your MATLAB environment and the command-line interface " + newline ...
                                        + "and reopen a new fresh (Anaconda) command prompt.";
                        self.Err.note();
                    end
                end

                if self.platform.isLinux

                    try

                        untar(self.prereqs.mpi.intel.fullFilePath,self.path.lib);
                        mpiExtractDir = fullfile(self.path.lib, mpiFileName);

                        self.Err.msg    = "If needed, use the following serial number when asked by the installer:" + newline + newline ...
                                        + "    C44K-74BR9CFG" + newline + newline ...
                                        + "If this is your personal computer, choose " + newline + newline ...
                                        + "    'install as root'" + newline + newline ...
                                        + "in the graphical user interface that appears in your session. " + newline + newline ...
                                        + "Otherwise, if you are using ParaMonte on a public server, " + newline ...
                                        + "for example, on a supercomputer, choose the third option:" + newline + newline ...
                                        + "   'install as current user'";
                        self.Err.note();

                        mpiInstallScriptPath = fullfile( mpiExtractDir, "install_GUI.sh");
                        if ~isfile(mpiInstallScriptPath)
                            self.Err. msg   = "Internal error occurred." + newline ...
                                            + "Failed to detect the Intel MPI installation Bash script." + newline ...
                                            + "Please report this issue at " + newline + newline ...
                                            + "    " + self.website.github.issues.url + newline + newline ...
                                            + "Visit, " ...
                                            + "    " + self.website.home.url + newline + newline ...
                                            + "for instructions to build the ParaMonte library on your system.";
                            self.Err.abort();
                        end

                    catch

                        self.Err.msg    = "Unzipping of Intel MPI runtime library tarball failed." + newline ...
                                        + "Make sure you have tar software installed on your system and try again.";
                        self.Err.abort();

                    end

                    [errorOccurred, ~] = system("chmod +x " + mpiInstallScriptPath);
                    if errorOccurred
                        self.Err.msg    = "The following action failed:" + newline + newline ...
                                        + "chmod +x " + string(strrep(mpiInstallScriptPath,'\','\\')) + newline + newline ...
                                        + "skipping...";
                        self.Err.warn();
                    end

                    originalDir = cd(mpiExtractDir);

                    [errorOccurred, ~] = system(mpiInstallScriptPath);
                    if errorOccurred
                        self.Err.msg    = "Intel MPI runtime libraries installation for " + newline ...
                                        + "64-bit architecture appears to have failed." + newline ...
                                        + "Please report this error at:" + newline + newline ...
                                        + "    " + self.website.github.issues.url + newline + newline ...
                                        + "Visit, " ...
                                        + "    " + self.website.home.url + newline + newline ...
                                        + "for instructions to build the ParaMonte library on your system.";
                        self.Err.abort();
                    end

                    self.Err.msg    = "Intel MPI runtime libraries installation for " + newline ...
                                    + "64-bit architecture appears to have succeeded." + newline ...
                                    + "Searching for the MPI runtime environment setup file...";
                    self.Err.note();

                    cd(originalDir);

                    setupFilePath = fullfile( self.path.lib, "setup.sh" );

                    mpiRootDirNotFound = true;
                    installationRootDirList = [ "/opt", self.path.home ];
                    mpiRootDir = [];
                    mpivarsFilePathDefault = [];
                    while mpiRootDirNotFound
                        for installationRootDir = installationRootDirList
                            mpiTrunkDir = fullfile("intel", "compilers_and_libraries_" + mpiVersion, "linux", "mpi", "intel64");
                            mpiRootDir = [ mpiRootDir, string(fullfile(installationRootDir, mpiTrunkDir)) ];
                            mpivarsFilePathDefault = [ mpivarsFilePathDefault , fullfile(mpiRootDir,"bin","mpivars.sh") ];
                            if isfolder(mpiRootDir(end))
                                mpiRootDirNotFound = false;
                                break
                            end
                        end
                        if mpiRootDirNotFound
                            self.Err.msg    = "Failed to detect the installation root path for Intel MPI runtime libraries " + newline ...
                                            + "for 64-bit architecture on your system. If you specified a different installation " + newline ...
                                            + "root path at the time installation, please copy and paste it below. " + newline ...
                                            + "Note that the installation root path is part of the path that replaces: " + newline + newline ...
                                            + "    " + "opt" + newline + newline ...
                                            + "in the following path: " + newline + newline ...
                                            + "    " + string(strrep(fullfile("opt", mpiTrunkDir),'\','\\'));
                            self.Err.warn();
                            answer = input  ( newline + "    Please type the root path of MPI installation below and press ENTER." ...
                                            + newline + "    If you don't know the root path, simply press ENTER to quit:" ...
                                            + newline , "s" );
                            if getVecLen(strtrim(answer))
                                installationRootDirList = string(answer);
                                continue;
                            else
                                self.Err.msg = "Skipping the MPI runtime library environmental path setup...";
                                self.Err.warn();
                                break;
                            end
                        end
                    end

                    if mpiRootDirNotFound

                        self.Err.msg    = "Failed to find the MPI runtime environment setup file on your system." + newline ...
                                        + "This is highly unusual. Normally, Intel MPI libraries must be installed" + newline ...
                                        + "in the following directory:" + newline + newline ...
                                        + "    " + string(strrep(mpiRootDir(1),'\','\\')) + newline + newline ...
                                        + "or," + newline + newline ...
                                        + "    " + string(strrep(mpiRootDir(2),'\','\\')) + newline + newline ...
                                        + "If you cannot manually find the Intel MPI installation directory," + newline ...
                                        + "it is likely that the installation might have somehow failed." + newline ...
                                        + "If you do find the installation directory, try to locate the" + newline ...
                                        + "'mpivars.sh' file which is normally installed in the following path:" + newline + newline ...
                                        + "    " + string(strrep(mpivarsFilePathDefault(1),'\','\\')) + newline + newline ...
                                        + "or," + newline + newline ...
                                        + "    " + string(strrep(mpivarsFilePathDefault(2),'\','\\')) + newline + newline ...
                                        + "Before attempting to run any parallel ParaMonte simulation, " + newline ...
                                        + "make sure you source this file, like the following:" + newline + newline ...
                                        + "    source " + string(strrep(mpivarsFilePathDefault(1),'\','\\')) + newline + newline ...
                                        + "or," + newline + newline ...
                                        + "    source " + string(strrep(mpivarsFilePathDefault(2),'\','\\')) + newline + newline ...
                                        + "where you will have to replace the path in the above with the " + newline ...
                                        + "correct path that you find on your system.";
                        self.Err.warn();

                    else

                        mpiBinDir = fullfile(mpiRootDir(end), "bin");
                        mpiLibDir = fullfile(mpiRootDir(end), "lib");
                        mpivarsFilePath = fullfile(mpiBinDir, "mpivars.sh");
                        if isfile(mpivarsFilePath)

                            fid = fopen(setupFilePath,"w");
                            fprintf(fid,string(strrep(mpiBinDir,'\','\\'))+"\n");
                            fprintf(fid,string(strrep(mpiLibDir,'\','\\'))+"\n");
                            fprintf(fid,"source "+string(strrep(mpivarsFilePath,'\','\\')));
                            fclose(fid);

                            self.Err.msg    = "To ensure all MPI routine environmental variables " + newline ...
                                            + "are properly load, source the following Bash script " + newline ...
                                            + "in your Bash environment before calling mpiexec, like:" + newline + newline ...
                                            + "    source " + string(strrep(mpivarsFilePath,'\','\\')) + newline + newline ...
                                            + "Alternatively, ParaMonte can also automatically add" + newline ...
                                            + "the required script to your '.bashrc' file, so that" + newline ...
                                            + "all required MPI environmental variables are loaded" + newline ...
                                            + "automatically before any ParaMonte usage from any" + newline ...
                                            + "Bash command line on your system.";
                            self.Err.note();

                            bashrcContents = getBashrcContents();
                            mpivarsFileCommand = "source " + mpivarsFilePath;
                            if ~contains(bashrcContents,mpivarsFileCommand)

                                [~,~] = system( "chmod 777 ~/.bashrc");
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '# >>> ParaMonte MPI runtime library initialization >>>' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '" + string(strrep(mpivarsFileCommand,'\','\\')) + "' >>  ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '# <<< ParaMonte MPI runtime library initialization <<<' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && echo '' >> ~/.bashrc" );
                                [~,~] = system( "chmod 777 ~/.bashrc && sh ~/.bashrc" );

                                self.Err.msg    = "If you intend to run parallel simulations right now," + newline ...
                                                + "we highly recommned you to close your current shell environment" + newline ...
                                                + "and open a new Bash shell environment. This is to ensure that all MPI" + newline ...
                                                + "library environmental variables are properly set in your shell environment.";
                                self.Err.note();

                            end

                        else

                            self.Err.msg    = "ParaMonte was able to detect an MPI library path on your system, however," + newline ...
                                            + "the MPI installation appears to be corrupted. The required mpivars.sh " + newline ...
                                            + "does not exist:" + newline + newline ...
                                            + string(strrep(mpivarsFilePath,'\','\\'));
                            self.Err.abort();

                        end

                    end

                end

            elseif self.platform.isMacOS

                self.Err.msg    = "To use the ParaMonte kernel routines in parallel on macOS, " + newline ...
                                + "the Open-MPI library will have to be installed on your system. " + newline ...
                                + "Building the ParaMonte library prerequisites on your system...";
                self.Err.warn();
                self.buildParaMontePrereqsForMac();

            else

                self.Err.msg    = "To use ParaMonte in parallel on this unknown Operating System, " + newline ...
                                + "ParaMonte needs to be built from scratch on your system. " + newline ...
                                + "Building ParaMonte library prerequisites on your system...";
                self.Err.warn();
                self.build();

            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function buildParaMontePrereqsForMac(self)

            self.Err.prefix = self.names.paramonte;
            self.Err.marginTop = 1;
            self.Err.marginBot = 1;

            self.Err.msg = "Checking if Homebrew exists on your system...";
            self.Err.note();

            [~,brewPath] = system("command -v brew");
            if ~isfile(brewPath)

                self.Err.msg = "Failed to detect Homebrew on your system. Installing Homebrew...";
                self.Err.note();

                [errorOccurred1, ~] = system('xcode-select --install');
                [errorOccurred2, ~] = system('/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"');
                [errorOccurred3, ~] = system('brew --version');
                if errorOccurred1 || errorOccurred2 || errorOccurred3
                    self.Err.msg    = "Failed to install Homebrew on your system." + newline ...
                                    + "Homebrew is required to install and build ParaMonte components and prerequisites." + newline ...
                                    + "Please install Homebrew manually on your system and retry the ParaMonte installation process." + newline ...
                                    + "skipping...";
                    self.Err.abort();
                end

            end

            % cmake

            cmakeInstallationNeeded = false;
            [~,cmakePath] = system("command -v cmake");
            if ~isfile(cmakePath)

                cmakeInstallationNeeded = true;
                self.Err.msg = "cmake installation is missing on your system.";
                self.Err.note();

            else

                self.Err.msg = "cmake installation detected at: " + string(strrep(cmakePath,'\','\\')) + "\n" + "Checking cmake version...";
                self.Err.marginTop  = 0;
                self.Err.marginBot  = 0;
                self.Err.note();

                [errorOccurred,cmakeVersion] = system("cmake --version");
                if errorOccurred

                    cmakeInstallationNeeded = true;
                    self.Err.msg = "Failed to detect the current cmake installation version. skipping...";
                    self.Err.note();

                else

                    cmakeVersion = strsplit(cmakeVersion," "); cmakeVersion = strsplit(cmakeVersion{3},"-"); cmakeVersion = string(cmakeVersion{1});
                    cmakeVersionList = string(strsplit(cmakeVersion,"."));

                    self.Err.msg = "current cmake version: " + cmakeVersion;
                    self.Err.note();

                    if str2double(cmakeVersionList{1})>=3 && str2double(cmakeVersionList{2})>=14
                        self.Err.msg = "cmake version is ParaMonte-compatible!";
                        self.Err.note();
                    else
                        cmakeInstallationNeeded = true;
                        self.Err.msg = "cmake version is NOT ParaMonte-compatible.";
                        self.Err.note();
                    end

                end

            end

            if cmakeInstallationNeeded

                self.Err.msg = "Installing cmake...";
                self.Err.note();

                [errorOccurred1,~] = system("brew install cmake");
                [errorOccurred2,~] = system("brew link --overwrite cmake");
                if errorOccurred1 || errorOccurred2
                    self.Err.msg = "cmake installation or linking failed.";
                    self.Err.marginTop = 1;
                    self.Err.marginBot = 1;
                    self.Err.abort();
                end

                [~,cmakeVersion] = system("cmake --version");
                cmakeVersion = strsplit(cmakeVersion," "); cmakeVersion = strsplit(cmakeVersion{3},"-"); cmakeVersion = string(cmakeVersion{1});
                cmakeVersionList = string(strsplit(cmakeVersion,"."));

                self.Err.marginTop = 1;
                self.Err.marginBot = 1;
                if str2double(cmakeVersionList{1})>=3 && str2double(cmakeVersionList{2})>=14
                    self.Err.msg = "cmake installation succeeded.";
                    self.Err.note();
                else
                    self.Err.msg    = "Failed to install and link cmake on your system." + newline ...
                                    + "cmake is required to install and build" + newline ...
                                    + "ParaMonte components and prerequisites." + newline ...
                                    + "Please install the cmake manually on your system and " + newline ...
                                    + "retry the ParaMonte installation process if it fails." + newline ...
                                    + "skipping...";
                    self.Err.warn();
                end

            end

            % gnu

            self.Err.msg = "Installing GNU Compiler Collection...";
            self.Err.note();

            [errorOccurred1,~] = system("brew install gcc@9");
            [errorOccurred2,~] = system("brew link gcc@9");

            if errorOccurred1 || errorOccurred2
                self.Err.msg    = "Failed to install and link GNU Compiler Collection on your system." + newline ...
                                + "The GNU Compiler Collection is required to install" + newline ...
                                + "and build ParaMonte components and prerequisites." + newline ...
                                + "Please install the GNU Compiler Collection manually on your" + newline ...
                                + "system and retry the ParaMonte installation process if it fails." + newline ...
                                + "skipping...";
                self.Err.warn();
            end

            % open-mpi

            self.Err.msg = "Installing Open-MPI...";
            self.Err.note();

            [errorOccurred1,~] = system("brew install open-mpi");
            [errorOccurred2,~] = system("brew link open-mpi");

            if errorOccurred1 || errorOccurred2
                self.Err.msg    = "Failed to install and link Open-MPI on your system." + newline ...
                                + "Open-MPI is required to install and build" + newline ...
                                + "ParaMonte components and prerequisites." + newline ...
                                + "Please install the Open-MPI manually on your" + newline ...
                                + "system and retry the ParaMonte installation process if it fails." + newline ...
                                + "skipping...";
                self.Err.warn();
            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function writeVerificationStatusFile(self,verificationEnabled)
            fid = fopen(self.verificationStatusFilePath, "w");
            fprintf(fid,verificationEnabled);
            fclose(fid);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function dispFinalMessage(self)
            self.Err.msg    = "To check for the MPI library installation status or display the above messages " + newline ...
                            + "in the future, use the following commands on the MATLAB command-line: " + newline + newline ...
                            + "    import paramonte as pm" + newline ...
                            + "    pm.verify()";
            self.Err.prefix = self.names.paramonte;
            self.Err.marginTop = 1;
            self.Err.marginBot = 1;
            self.Err.note();
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function displayParaMonteBanner(self)
            bannerFilePath = fullfile( self.path.auxil, ".ParaMonteBanner");
            versionLen = self.version.interface.dump();
            versionLen = length(versionLen{1});
            offset = fix( (versionLen - 4) / 2 );
            fprintf(1,"\n");
            text = fileread(bannerFilePath);
            lineList = string(strsplit(text,newline));
            for lineElement = lineList
                if contains(lineElement,"Version")
                    line = strrep(lineElement, string(repmat(' ',1,offset))+"Version 0.0.0", "Version "+self.version.interface.dump);
                else
                    line = lineElement;
                end
                fprintf(1,line);
            end
            fprintf(1,"\n");
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end % methods

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    methods (Static)

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function result = helpme()
            result = help(paramonte);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    end % methods (Static)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end