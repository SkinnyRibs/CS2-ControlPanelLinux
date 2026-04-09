using Avalonia;
using Avalonia.Controls.ApplicationLifetimes;
using Avalonia.Markup.Xaml;
using CS2AdminTool.Services;
using CS2AdminTool.ViewModels;

namespace CS2AdminTool;

public partial class App : Application
{
    public override void Initialize()
    {
        AvaloniaXamlLoader.Load(this);
    }

    public override void OnFrameworkInitializationCompleted()
    {
        AppDomain.CurrentDomain.UnhandledException += (_, e) => Console.WriteLine($"Fatal error: {e.ExceptionObject}");
        TaskScheduler.UnobservedTaskException += (_, e) =>
        {
            Console.WriteLine($"Background task error: {e.Exception}");
            e.SetObserved();
        };

        if (ApplicationLifetime is IClassicDesktopStyleApplicationLifetime desktop)
        {
            var rconService = new RconService();
            var jsonStorage = new JsonStorageService();
            var configLibraryService = new ConfigLibraryService(jsonStorage);
            var mapLibraryService = new MapLibraryService();
            var executionService = new CommandExecutionService(rconService);
            var configRunnerService = new ConfigRunnerService(executionService);
            var serverMonitorService = new ServerMonitorService(rconService);

            var viewModel = new MainViewModel(configLibraryService, mapLibraryService, configRunnerService, rconService, serverMonitorService);
            desktop.MainWindow = new MainWindow { DataContext = viewModel };
        }

        base.OnFrameworkInitializationCompleted();
    }
}
