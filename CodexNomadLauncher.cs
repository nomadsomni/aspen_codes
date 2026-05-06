using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;

internal static class CodexNomadLauncher
{
    private const string Root = @"C:\Users\Surface\OneDrive\SIRENSSD";
    private const string Title = "codex @ nomad";
    private const string WtProfile = "{4c84b3b3-f26e-4d77-b7cb-6ea7a8f74ad5}";

    [STAThread]
    private static void Main()
    {
        try
        {
            if (TryStartWindowsTerminal())
            {
                return;
            }

            if (TryStartPwsh())
            {
                return;
            }

            if (TryStartWindowsPowerShell())
            {
                return;
            }

            MessageBox.Show(
                "Could not start Windows Terminal, PowerShell 7, or Windows PowerShell.",
                "Codex @ Nomad",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
        }
        catch (Exception ex)
        {
            MessageBox.Show(
                ex.Message,
                "Codex @ Nomad",
                MessageBoxButtons.OK,
                MessageBoxIcon.Error);
        }
    }

    private static bool TryStartWindowsTerminal()
    {
        return TryStart(
            "wt.exe",
            "-w new -p \"" + WtProfile + "\"");
    }

    private static bool TryStartPwsh()
    {
        var command = "$host.UI.RawUI.WindowTitle = '" + Title + "'; " +
                      "Set-Location '" + Root + "'; " +
                      "if (Get-Command codex -ErrorAction SilentlyContinue) { codex } " +
                      "else { Write-Host 'codex command not found on PATH.' -ForegroundColor Red }";

        return TryStart(
            "pwsh.exe",
            "-NoExit -Command \"" + command.Replace("\"", "\\\"") + "\"");
    }

    private static bool TryStartWindowsPowerShell()
    {
        var command = "$host.UI.RawUI.WindowTitle = '" + Title + "'; " +
                      "Set-Location '" + Root + "'; " +
                      "if (Get-Command codex -ErrorAction SilentlyContinue) { codex } " +
                      "else { Write-Host 'codex command not found on PATH.' -ForegroundColor Red }";

        return TryStart(
            "powershell.exe",
            "-NoExit -Command \"" + command.Replace("\"", "\\\"") + "\"");
    }

    private static bool TryStart(string fileName, string arguments)
    {
        try
        {
            var psi = new ProcessStartInfo
            {
                FileName = fileName,
                Arguments = arguments,
                WorkingDirectory = Directory.Exists(Root) ? Root : Environment.GetFolderPath(Environment.SpecialFolder.UserProfile),
                UseShellExecute = true
            };

            Process.Start(psi);
            return true;
        }
        catch
        {
            return false;
        }
    }
}
