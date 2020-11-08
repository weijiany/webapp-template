using System;
using System.Data.SqlClient;
using System.Threading;
using FluentMigrator.Runner;
using Microsoft.Extensions.DependencyInjection;

namespace Migration
{
    class Program
    {
        // https://fluentmigrator.github.io/articles/quickstart.html?tabs=runner-in-process
        static void Main()
        {
            var serviceProvider = CreateServices();

            var times = 1;
            while (times++ <= 10)
            {
                try
                {
                    using var scope = serviceProvider.CreateScope();
                    UpdateDatabase(scope.ServiceProvider);
                }
                catch (SqlException e)
                {
                    Console.WriteLine($"fail times: [{times}], exception: {e}");
                    Thread.Sleep(TimeSpan.FromSeconds(5));
                }
            }
        }

        private static IServiceProvider CreateServices()
        {
            return new ServiceCollection()
                .AddFluentMigratorCore()
                .ConfigureRunner(rb => rb
                    .AddSqlServer2016()
                    .WithGlobalConnectionString(GenerateConnectionString())
                    .ScanIn(typeof(Program).Assembly).For.Migrations())
                .AddLogging(lb => lb.AddFluentMigratorConsole())
                .BuildServiceProvider(false);
        }

        private static string GenerateConnectionString()
        {
            var databaseServer = Environment.GetEnvironmentVariable("DATABASE_SERVER") ?? "localhost";
            var databaseName = Environment.GetEnvironmentVariable("DATABASE_NAME") ?? "WebApp";
            var saPassword = Environment.GetEnvironmentVariable("SA_PASSWORD") ?? "WJY@123456";
            var saUsername = Environment.GetEnvironmentVariable("DATABASE_USERNAME") ?? "sa";
            return $"Server={databaseServer};Database={databaseName};User Id={saUsername};Password={saPassword};";
        }

        private static void UpdateDatabase(IServiceProvider serviceProvider)
        {
            var runner = serviceProvider.GetRequiredService<IMigrationRunner>();

            runner.MigrateUp();
        }
    }
}
