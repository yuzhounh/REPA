classdef repa < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure               matlab.ui.Figure
        RunButton              matlab.ui.control.Button
        FilterbandHzEditField  matlab.ui.control.EditField
        FilterbandHzEditFieldLabel  matlab.ui.control.Label
        FWHMmmEditField        matlab.ui.control.EditField
        FWHMmmEditFieldLabel   matlab.ui.control.Label
        VoxelsizemmEditField   matlab.ui.control.EditField
        VoxelsizemmEditFieldLabel  matlab.ui.control.Label
        TimepointsremovedEditField  matlab.ui.control.EditField
        TimepointsremovedEditFieldLabel  matlab.ui.control.Label
        StartingdirectoryDropDown  matlab.ui.control.DropDown
        StartingdirectoryDropDownLabel  matlab.ui.control.Label
        BrowseButton           matlab.ui.control.Button
        WorkingdirectoryEditField  matlab.ui.control.EditField
        WorkingdirectoryEditFieldLabel  matlab.ui.control.Label
        RestingStatefMRIPreprocessingToolboxLabel  matlab.ui.control.Label
    end

    methods (Access = private)

        % Button pushed function: BrowseButton
        function BrowseButtonPushed(app, event)
            folder_name = uigetdir('', 'Select Working Directory');
            if folder_name ~= 0
                app.WorkingdirectoryEditField.Value = folder_name;
                figure(app.UIFigure);
            end
        end

        % Button pushed function: RunButton
        function RunButtonPushed(app, event)
            % Get all parameters
            para.working_dir = app.WorkingdirectoryEditField.Value;
            para.time_points_removed = str2double(app.TimepointsremovedEditField.Value);
            para.voxel_size = str2num(app.VoxelsizemmEditField.Value);
            para.FWHM = str2num(app.FWHMmmEditField.Value);
            para.filter_band = str2num(app.FilterbandHzEditField.Value);

            % Run the main program
            working_path = 'repa_utilities/'; % customized scripts
            addpath(genpath(working_path),'-begin');
            repa_func(para);
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)
            % Create UIFigure
            app.UIFigure = uifigure;
            % Get screen size
            screen = get(0,'ScreenSize');
            % Calculate center position
            x = (screen(3)-640)/2;
            y = (screen(4)-360)/2;
            app.UIFigure.Position = [x y 640 350];
            app.UIFigure.Name = 'REPA';

            % Create RestingStatefMRIPreprocessingToolboxLabel
            app.RestingStatefMRIPreprocessingToolboxLabel = uilabel(app.UIFigure);
            app.RestingStatefMRIPreprocessingToolboxLabel.FontSize = 15;
            app.RestingStatefMRIPreprocessingToolboxLabel.FontWeight = 'bold';
            app.RestingStatefMRIPreprocessingToolboxLabel.Position = [141 291 359 22];
            app.RestingStatefMRIPreprocessingToolboxLabel.Text = 'Resting-State fMRI Preprocessing and Analysis';

            % Create WorkingdirectoryEditFieldLabel
            app.WorkingdirectoryEditFieldLabel = uilabel(app.UIFigure);
            app.WorkingdirectoryEditFieldLabel.HorizontalAlignment = 'right';
            app.WorkingdirectoryEditFieldLabel.Position = [31 234 118 22];
            app.WorkingdirectoryEditFieldLabel.Text = 'Working directory';

            % Create WorkingdirectoryEditField
            app.WorkingdirectoryEditField = uieditfield(app.UIFigure, 'text');
            app.WorkingdirectoryEditField.Position = [164 234 348 22];
            app.WorkingdirectoryEditField.Value = 'D:\Data\fMRI_Preprocess';

            % Create BrowseButton
            app.BrowseButton = uibutton(app.UIFigure, 'push');
            app.BrowseButton.ButtonPushedFcn = createCallbackFcn(app, @BrowseButtonPushed, true);
            app.BrowseButton.Position = [523 234 72 22];
            app.BrowseButton.Text = 'Browse';

            % Create TimepointsremovedEditFieldLabel
            app.TimepointsremovedEditFieldLabel = uilabel(app.UIFigure);
            app.TimepointsremovedEditFieldLabel.HorizontalAlignment = 'right';
            app.TimepointsremovedEditFieldLabel.Position = [31 184 119 22];
            app.TimepointsremovedEditFieldLabel.Text = 'Time points to remove';

            % Create TimepointsremovedEditField
            app.TimepointsremovedEditField = uieditfield(app.UIFigure, 'text');
            app.TimepointsremovedEditField.Position = [164 184 100 22];
            app.TimepointsremovedEditField.Value = '10';

            % Create VoxelsizemmEditFieldLabel
            app.VoxelsizemmEditFieldLabel = uilabel(app.UIFigure);
            app.VoxelsizemmEditFieldLabel.HorizontalAlignment = 'right';
            app.VoxelsizemmEditFieldLabel.Position = [350 184 102 22];
            app.VoxelsizemmEditFieldLabel.Text = 'Voxel size (mm)';

            % Create VoxelsizemmEditField
            app.VoxelsizemmEditField = uieditfield(app.UIFigure, 'text');
            app.VoxelsizemmEditField.Position = [470 184 100 22];
            app.VoxelsizemmEditField.Value = '[3, 3, 3]';

            % Create FWHMmmEditFieldLabel
            app.FWHMmmEditFieldLabel = uilabel(app.UIFigure);
            app.FWHMmmEditFieldLabel.HorizontalAlignment = 'right';
            app.FWHMmmEditFieldLabel.Position = [66 134 83 22];
            app.FWHMmmEditFieldLabel.Text = 'FWHM (mm)';

            % Create FWHMmmEditField
            app.FWHMmmEditField = uieditfield(app.UIFigure, 'text');
            app.FWHMmmEditField.Position = [164 134 100 22];
            app.FWHMmmEditField.Value = '[6, 6, 6]';

            % Create FilterbandHzEditFieldLabel
            app.FilterbandHzEditFieldLabel = uilabel(app.UIFigure);
            app.FilterbandHzEditFieldLabel.HorizontalAlignment = 'right';
            app.FilterbandHzEditFieldLabel.Position = [350 134 104 22];
            app.FilterbandHzEditFieldLabel.Text = 'Filter band (Hz)';

            % Create FilterbandHzEditField
            app.FilterbandHzEditField = uieditfield(app.UIFigure, 'text');
            app.FilterbandHzEditField.Position = [470 134 100 22];
            app.FilterbandHzEditField.Value = '[0.01, 0.1]';

            % Create RunButton
            app.RunButton = uibutton(app.UIFigure, 'push');
            app.RunButton.ButtonPushedFcn = createCallbackFcn(app, @RunButtonPushed, true);
            app.RunButton.FontWeight = 'bold';
            app.RunButton.Position = [284 53 100 22];
            app.RunButton.Text = 'RUN';
        end
    end

    methods (Access = public)

        % Construct app
        function app = repa

            % Create and configure components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Initial visibility of Time points removed
            app.TimepointsremovedEditField.Visible = 'on';
            app.TimepointsremovedEditFieldLabel.Visible = 'on';
        end
    end
end