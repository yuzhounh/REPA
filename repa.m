classdef repa < matlab.apps.AppBase

    properties (Access = public)
        UIFigure matlab.ui.Figure
        MainGrid matlab.ui.container.GridLayout
        HeaderPanel matlab.ui.container.Panel
        HeaderGrid matlab.ui.container.GridLayout
        LogoAxes matlab.ui.control.UIAxes
        TitleLabel matlab.ui.control.Label
        VersionLabel matlab.ui.control.Label
        ContentGrid matlab.ui.container.GridLayout
        DataPanel matlab.ui.container.Panel
        DataGrid matlab.ui.container.GridLayout
        WorkingdirectoryEditFieldLabel matlab.ui.control.Label
        WorkingdirectoryEditField matlab.ui.control.EditField
        BrowseButton matlab.ui.control.Button
        StartingdirectoryDropDownLabel matlab.ui.control.Label
        StartingdirectoryDropDown matlab.ui.control.DropDown
        RunGSRCheckBox matlab.ui.control.CheckBox
        ParamsPanel matlab.ui.container.Panel
        ParamsGrid matlab.ui.container.GridLayout
        TimepointsremovedEditFieldLabel matlab.ui.control.Label
        TimepointsremovedEditField matlab.ui.control.EditField
        VoxelsizemmEditFieldLabel matlab.ui.control.Label
        VoxelsizemmEditField matlab.ui.control.EditField
        FWHMmmEditFieldLabel matlab.ui.control.Label
        FWHMmmEditField matlab.ui.control.EditField
        FilterbandHzEditFieldLabel matlab.ui.control.Label
        FilterbandHzEditField matlab.ui.control.EditField
        LogPanel matlab.ui.container.Panel
        LogGrid matlab.ui.container.GridLayout
        LogLabel matlab.ui.control.Label
        LogTextArea matlab.ui.control.TextArea
        StatusLabel matlab.ui.control.Label
        ButtonGrid matlab.ui.container.GridLayout
        CheckDependenciesButton matlab.ui.control.Button
        RunButton matlab.ui.control.Button
    end

    properties (Access = private)
        ProgressTimer timer
        ProcessingFuture
        RepaRoot char = ''
        IsProcessing logical = false
    end

    methods (Access = private)

        function para = buildPara(app)
            para.working_dir = strtrim(app.WorkingdirectoryEditField.Value);
            para.time_points_removed = str2double(app.TimepointsremovedEditField.Value);
            para.voxel_size = str2num(app.VoxelsizemmEditField.Value); %#ok<ST2NM>
            para.FWHM = str2num(app.FWHMmmEditField.Value); %#ok<ST2NM>
            para.filter_band = str2num(app.FilterbandHzEditField.Value); %#ok<ST2NM>
            para.starting_dir = mapStartingDir(app.StartingdirectoryDropDown.Value);
            para.run_gsr = app.RunGSRCheckBox.Value;
            para.repa_root = app.RepaRoot;
        end

        function starting_dir = mapStartingDir(~, dropdownValue)
            switch dropdownValue
                case 'DICOM (FunRaw + T1Raw)'
                    starting_dir = 'FunRaw';
                case 'NIfTI (FunImg + T1Img)'
                    starting_dir = 'FunImg';
                otherwise
                    starting_dir = 'auto';
            end
        end

        function setControlsEnabled(app, enabled)
            app.RunButton.Enable = ternary(enabled, 'on', 'off');
            app.BrowseButton.Enable = ternary(enabled, 'on', 'off');
            app.CheckDependenciesButton.Enable = ternary(enabled, 'on', 'off');
            app.WorkingdirectoryEditField.Enable = ternary(enabled, 'on', 'off');
            app.StartingdirectoryDropDown.Enable = ternary(enabled, 'on', 'off');
            app.RunGSRCheckBox.Enable = ternary(enabled, 'on', 'off');
            app.TimepointsremovedEditField.Enable = ternary(enabled, 'on', 'off');
            app.VoxelsizemmEditField.Enable = ternary(enabled, 'on', 'off');
            app.FWHMmmEditField.Enable = ternary(enabled, 'on', 'off');
            app.FilterbandHzEditField.Enable = ternary(enabled, 'on', 'off');
        end

        function appendLog(app, message)
            current = app.LogTextArea.Value;
            if isempty(current)
                app.LogTextArea.Value = message;
            else
                app.LogTextArea.Value = [current; message];
            end
            drawnow limitrate;
        end

        function BrowseButtonPushed(app, ~)
            folder_name = uigetdir(app.WorkingdirectoryEditField.Value, 'Select Working Directory');
            if folder_name ~= 0
                app.WorkingdirectoryEditField.Value = folder_name;
            end
        end

        function CheckDependenciesButtonPushed(app, ~)
            app.ensureUtilitiesOnPath();
            status = repa_check_dependencies_status();
            app.LogTextArea.Value = status.lines';
            if status.ok
                app.StatusLabel.Text = 'Dependencies look ready.';
                uialert(app.UIFigure, strjoin(status.lines, newline), 'Dependencies', 'Icon', 'success');
            else
                app.StatusLabel.Text = 'Missing pinned dependencies.';
                uialert(app.UIFigure, strjoin(status.lines, newline), 'Dependencies', 'Icon', 'warning');
            end
        end

        function RunButtonPushed(app, ~)
            if app.IsProcessing
                return;
            end

            app.ensureUtilitiesOnPath();
            para = buildPara(app);
            [ok, message] = repa_validate_inputs(para);
            if ~ok
                uialert(app.UIFigure, message, 'Invalid Input', 'Icon', 'error');
                return;
            end

            app.IsProcessing = true;
            setControlsEnabled(app, false);
            app.StatusLabel.Text = 'Processing...';
            app.LogTextArea.Value = {'REPA started. Progress updates will appear here.'};

            try
                app.ProcessingFuture = parfeval(backgroundPool, @repa_func_wrapper, 0, para);
                afterEach(app.ProcessingFuture, @app.onProcessingComplete, 0, PassFuture, true);
                start(app.ProgressTimer);
            catch
                appendLog(app, 'Background pool unavailable; running synchronously.');
                try
                    repa_func_wrapper(para);
                    app.StatusLabel.Text = 'Processing completed.';
                    appendLog(app, 'REPA finished successfully.');
                    uialert(app.UIFigure, 'REPA processing finished.', 'Done', 'Icon', 'success');
                catch ME
                    app.StatusLabel.Text = 'Processing failed.';
                    appendLog(app, ME.message);
                    uialert(app.UIFigure, ME.message, 'Processing Error', 'Icon', 'error');
                end
                app.IsProcessing = false;
                setControlsEnabled(app, true);
            end
        end

        function onProcessingComplete(app, future)
            stop(app.ProgressTimer);
            app.IsProcessing = false;
            setControlsEnabled(app, true);

            try
                fetchOutputs(future);
                app.StatusLabel.Text = 'Processing completed.';
                appendLog(app, 'REPA finished successfully.');
                uialert(app.UIFigure, 'REPA processing finished.', 'Done', 'Icon', 'success');
            catch ME
                app.StatusLabel.Text = 'Processing failed.';
                appendLog(app, ME.message);
                uialert(app.UIFigure, ME.message, 'Processing Error', 'Icon', 'error');
            end
        end

        function updateProgressTimer(app, ~)
            if ~app.IsProcessing
                return;
            end

            status_file = fullfile(app.WorkingdirectoryEditField.Value, 'repa_gui_status.txt');
            if isfile(status_file)
                txt = fileread(status_file);
                lines = splitlines(string(strtrim(txt)));
                lines = lines(lines ~= "");
                if ~isempty(lines)
                    app.LogTextArea.Value = cellstr(lines);
                end
            end
        end

        function ensureUtilitiesOnPath(app)
            if ~isempty(app.RepaRoot)
                addpath(genpath(fullfile(app.RepaRoot, 'repa_utilities')), '-begin');
            end
        end

        function createComponents(app)
            screen = get(0, 'ScreenSize');
            figW = 820;
            figH = 560;
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [(screen(3)-figW)/2, (screen(4)-figH)/2, figW, figH];
            app.UIFigure.Name = 'REPA';
            app.UIFigure.Color = [0.97 0.98 0.99];

            app.MainGrid = uigridlayout(app.UIFigure, [4 1]);
            app.MainGrid.RowHeight = {88, '1x', 110, 44};
            app.MainGrid.Padding = [16 16 16 16];
            app.MainGrid.RowSpacing = 12;

            app.HeaderPanel = uipanel(app.MainGrid);
            app.HeaderPanel.Layout.Row = 1;
            app.HeaderPanel.BackgroundColor = [0.90 0.94 0.98];
            app.HeaderGrid = uigridlayout(app.HeaderPanel, [2 2]);
            app.HeaderGrid.ColumnWidth = {72, '1x'};
            app.HeaderGrid.RowHeight = {'1x', 20};
            app.HeaderGrid.Padding = [12 10 12 10];

            app.LogoAxes = uiaxes(app.HeaderGrid);
            app.LogoAxes.Layout.Row = [1 2];
            app.LogoAxes.Layout.Column = 1;
            app.LogoAxes.XTick = [];
            app.LogoAxes.YTick = [];
            app.LogoAxes.Box = 'off';
            logoPath = fullfile(app.RepaRoot, 'repa_utilities', 'repa_gui.png');
            if isfile(logoPath)
                logoImg = imread(logoPath);
                image(app.LogoAxes, logoImg);
                app.LogoAxes.XLim = [0.5 size(logoImg, 2)+0.5];
                app.LogoAxes.YLim = [0.5 size(logoImg, 1)+0.5];
            else
                text(app.LogoAxes, 0.5, 0.5, 'REPA', 'HorizontalAlignment', 'center');
            end

            app.TitleLabel = uilabel(app.HeaderGrid);
            app.TitleLabel.Layout.Row = 1;
            app.TitleLabel.Layout.Column = 2;
            app.TitleLabel.Text = 'Resting-State fMRI Preprocessing and Analysis';
            app.TitleLabel.FontSize = 18;
            app.TitleLabel.FontWeight = 'bold';

            app.VersionLabel = uilabel(app.HeaderGrid);
            app.VersionLabel.Layout.Row = 2;
            app.VersionLabel.Layout.Column = 2;
            app.VersionLabel.FontColor = [0.35 0.35 0.35];

            app.ContentGrid = uigridlayout(app.MainGrid, [1 2]);
            app.ContentGrid.Layout.Row = 2;
            app.ContentGrid.ColumnWidth = {'1x', '1.1x'};
            app.ContentGrid.ColumnSpacing = 12;

            app.DataPanel = uipanel(app.ContentGrid, 'Title', 'Data');
            app.DataPanel.Layout.Column = 1;
            app.DataGrid = uigridlayout(app.DataPanel, [3 3]);
            app.DataGrid.ColumnWidth = {120, '1x', 80};
            app.DataGrid.RowHeight = {28, 28, 28};
            app.DataGrid.Padding = [12 12 12 12];

            app.WorkingdirectoryEditFieldLabel = uilabel(app.DataGrid);
            app.WorkingdirectoryEditFieldLabel.Layout.Row = 1;
            app.WorkingdirectoryEditFieldLabel.Layout.Column = 1;
            app.WorkingdirectoryEditFieldLabel.Text = 'Working directory';
            app.WorkingdirectoryEditFieldLabel.HorizontalAlignment = 'right';

            app.WorkingdirectoryEditField = uieditfield(app.DataGrid, 'text');
            app.WorkingdirectoryEditField.Layout.Row = 1;
            app.WorkingdirectoryEditField.Layout.Column = 2;
            app.WorkingdirectoryEditField.Value = pwd;

            app.BrowseButton = uibutton(app.DataGrid, 'push');
            app.BrowseButton.Layout.Row = 1;
            app.BrowseButton.Layout.Column = 3;
            app.BrowseButton.Text = 'Browse';
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);

            app.StartingdirectoryDropDownLabel = uilabel(app.DataGrid);
            app.StartingdirectoryDropDownLabel.Layout.Row = 2;
            app.StartingdirectoryDropDownLabel.Layout.Column = 1;
            app.StartingdirectoryDropDownLabel.Text = 'Input format';
            app.StartingdirectoryDropDownLabel.HorizontalAlignment = 'right';

            app.StartingdirectoryDropDown = uidropdown(app.DataGrid);
            app.StartingdirectoryDropDown.Layout.Row = 2;
            app.StartingdirectoryDropDown.Layout.Column = [2 3];
            app.StartingdirectoryDropDown.Items = {'Auto detect', 'DICOM (FunRaw + T1Raw)', 'NIfTI (FunImg + T1Img)'};
            app.StartingdirectoryDropDown.Value = 'Auto detect';

            app.RunGSRCheckBox = uicheckbox(app.DataGrid);
            app.RunGSRCheckBox.Layout.Row = 3;
            app.RunGSRCheckBox.Layout.Column = [2 3];
            app.RunGSRCheckBox.Text = 'Run additional GSR pipeline pass';
            app.RunGSRCheckBox.Value = true;

            app.ParamsPanel = uipanel(app.ContentGrid, 'Title', 'Preprocessing Parameters');
            app.ParamsPanel.Layout.Column = 2;
            app.ParamsGrid = uigridlayout(app.ParamsPanel, [2 4]);
            app.ParamsGrid.ColumnWidth = {130, '1x', 110, '1x'};
            app.ParamsGrid.RowHeight = {28, 28};
            app.ParamsGrid.Padding = [12 12 12 12];

            app.TimepointsremovedEditFieldLabel = uilabel(app.ParamsGrid);
            app.TimepointsremovedEditFieldLabel.Layout.Row = 1;
            app.TimepointsremovedEditFieldLabel.Layout.Column = 1;
            app.TimepointsremovedEditFieldLabel.Text = 'Time points to remove';
            app.TimepointsremovedEditFieldLabel.HorizontalAlignment = 'right';
            app.TimepointsremovedEditField = uieditfield(app.ParamsGrid, 'text');
            app.TimepointsremovedEditField.Layout.Row = 1;
            app.TimepointsremovedEditField.Layout.Column = 2;
            app.TimepointsremovedEditField.Value = '10';

            app.VoxelsizemmEditFieldLabel = uilabel(app.ParamsGrid);
            app.VoxelsizemmEditFieldLabel.Layout.Row = 1;
            app.VoxelsizemmEditFieldLabel.Layout.Column = 3;
            app.VoxelsizemmEditFieldLabel.Text = 'Voxel size (mm)';
            app.VoxelsizemmEditFieldLabel.HorizontalAlignment = 'right';
            app.VoxelsizemmEditField = uieditfield(app.ParamsGrid, 'text');
            app.VoxelsizemmEditField.Layout.Row = 1;
            app.VoxelsizemmEditField.Layout.Column = 4;
            app.VoxelsizemmEditField.Value = '[3, 3, 3]';

            app.FWHMmmEditFieldLabel = uilabel(app.ParamsGrid);
            app.FWHMmmEditFieldLabel.Layout.Row = 2;
            app.FWHMmmEditFieldLabel.Layout.Column = 1;
            app.FWHMmmEditFieldLabel.Text = 'FWHM (mm)';
            app.FWHMmmEditFieldLabel.HorizontalAlignment = 'right';
            app.FWHMmmEditField = uieditfield(app.ParamsGrid, 'text');
            app.FWHMmmEditField.Layout.Row = 2;
            app.FWHMmmEditField.Layout.Column = 2;
            app.FWHMmmEditField.Value = '[6, 6, 6]';

            app.FilterbandHzEditFieldLabel = uilabel(app.ParamsGrid);
            app.FilterbandHzEditFieldLabel.Layout.Row = 2;
            app.FilterbandHzEditFieldLabel.Layout.Column = 3;
            app.FilterbandHzEditFieldLabel.Text = 'Filter band (Hz)';
            app.FilterbandHzEditFieldLabel.HorizontalAlignment = 'right';
            app.FilterbandHzEditField = uieditfield(app.ParamsGrid, 'text');
            app.FilterbandHzEditField.Layout.Row = 2;
            app.FilterbandHzEditField.Layout.Column = 4;
            app.FilterbandHzEditField.Value = '[0.01, 0.1]';

            app.LogPanel = uipanel(app.MainGrid, 'Title', 'Status / Progress');
            app.LogPanel.Layout.Row = 3;
            app.LogGrid = uigridlayout(app.LogPanel, [2 1]);
            app.LogGrid.RowHeight = {22, '1x'};
            app.LogGrid.Padding = [12 12 12 12];

            app.StatusLabel = uilabel(app.LogGrid);
            app.StatusLabel.Layout.Row = 1;
            app.StatusLabel.Text = 'Ready.';
            app.StatusLabel.FontWeight = 'bold';

            app.LogTextArea = uitextarea(app.LogGrid);
            app.LogTextArea.Layout.Row = 2;
            app.LogTextArea.Editable = 'off';
            app.LogTextArea.Value = {'Click "Check Dependencies" before the first run, then press RUN.'};

            app.ButtonGrid = uigridlayout(app.MainGrid, [1 2]);
            app.ButtonGrid.Layout.Row = 4;
            app.ButtonGrid.ColumnWidth = {'1x', 160};
            app.ButtonGrid.Padding = [0 0 0 0];

            app.CheckDependenciesButton = uibutton(app.ButtonGrid, 'push');
            app.CheckDependenciesButton.Layout.Column = 1;
            app.CheckDependenciesButton.HorizontalAlignment = 'left';
            app.CheckDependenciesButton.Text = 'Check Dependencies';
            app.CheckDependenciesButton.ButtonPushedFcn = createCallbackFcn(app, @CheckDependenciesButtonPushed, true);

            app.RunButton = uibutton(app.ButtonGrid, 'push');
            app.RunButton.Layout.Column = 2;
            app.RunButton.Text = 'RUN';
            app.RunButton.FontWeight = 'bold';
            app.RunButton.BackgroundColor = [0.20 0.45 0.75];
            app.RunButton.FontColor = [1 1 1];
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);

            app.UIFigure.Visible = 'on';
        end
    end

    methods (Access = public)
        function app = repa
            app.RepaRoot = fileparts(mfilename('fullpath'));
            createComponents(app)
            registerApp(app, app.UIFigure)
            runStartupFcn(app, @startupFcn)
            if nargout == 0
                clear app
            end
        end

        function delete(app)
            if ~isempty(app.ProgressTimer) && isvalid(app.ProgressTimer)
                stop(app.ProgressTimer);
                delete(app.ProgressTimer);
            end
            delete(app.UIFigure)
        end
    end

    methods (Access = private)
        function startupFcn(app)
            app.ensureUtilitiesOnPath();
            try
                deps = repa_pinned_dependencies();
                app.VersionLabel.Text = sprintf('Version %s | SPM12 + DPABI %s', deps.repa_version, deps.dpabi_version_token);
            catch
                app.VersionLabel.Text = 'Version information unavailable';
            end
            app.ProgressTimer = timer('ExecutionMode', 'fixedSpacing', 'Period', 1.0, ...
                'TimerFcn', @(~,~) updateProgressTimer(app));
        end
    end
end

function out = ternary(condition, trueValue, falseValue)
if condition
    out = trueValue;
else
    out = falseValue;
end
end
