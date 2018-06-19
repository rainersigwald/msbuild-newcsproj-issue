# MSBuild issue for new csproj style

This shows msbuild failing to build a new style csproj that targets .NET Framework 4.6.2 (`net462`). This repo is very trivial - it's a solution with a single .NET Framework v4.6.2 dll as a 'new style' csproj (VS2017's human readable XML csproj).

## Reproduce issue (simple)

1. Clone this repo
2. Run `DemoProblem.ps1`

## Reproduce issue (manually)

If you want to manually reproduce this

1. Clone this repo
2. Open a Visual Studio Dev Command Prompt -> run `powershell`
3. cd to the root of this project
4. Delete bin,obj folders by `gci . -Recurse -Include bin,obj | % { ri -Recurse -Force $_.FullName }` .. especially needed if the solution is open in Visual Studio as it silently regenerates those folders
5. issue msbuild command by `msbuild .\ClassLibraryFw462NewProj\ClassLibraryFw462NewProj.csproj /p:SolutionDir=C:\temp\new-old-proj-mix-soln /p:Configuration=Debug /m /t:build`

Note that `dotnet build` works but that suffers from the issue that projects with EF6 cannot be built using `dotnet` CLI and the CLI [team won't address it](https://github.com/dotnet/cli/issues/8193#issuecomment-397672139)

## Error output

    C:\temp\new-old-proj-mix-soln
    λ  .\DemoProblem.ps1
    Visual Studio environment already setup
    Microsoft (R) Build Engine version 15.7.179.6572 for .NET Framework
    Copyright (C) Microsoft Corporation. All rights reserved.

    Build started 6/19/2018 4:17:03 PM.
        1>Project "C:\temp\new-old-proj-mix-soln\ClassLibraryFw462NewProj\ClassLibraryFw462NewProj.csproj" on node 1 (build target(s)).
        1>PrepareForBuild:
            Creating directory "bin\Debug\net462\".
            Creating directory "obj\Debug\net462\".
        1>C:\Program Files\dotnet\sdk\2.1.300\Sdks\Microsoft.NET.Sdk\targets\Microsoft.PackageDependencyResolution.targets(198,5): error : As
        sets file 'C:\temp\new-old-proj-mix-soln\ClassLibraryFw462NewProj\obj\project.assets.json' not found. Run a NuGet package restore t
        o generate this file. [C:\temp\new-old-proj-mix-soln\ClassLibraryFw462NewProj\ClassLibraryFw462NewProj.csproj]
        1>Done Building Project "C:\temp\new-old-proj-mix-soln\ClassLibraryFw462NewProj\ClassLibraryFw462NewProj.csproj" (build target(s)) --
            FAILED.

    Build FAILED.

        "C:\temp\new-old-proj-mix-soln\ClassLibraryFw462NewProj\ClassLibraryFw462NewProj.csproj" (build target) (1) ->
        (ResolvePackageAssets target) ->
            C:\Program Files\dotnet\sdk\2.1.300\Sdks\Microsoft.NET.Sdk\targets\Microsoft.PackageDependencyResolution.targets(198,5): error :
        Assets file 'C:\temp\new-old-proj-mix-soln\ClassLibraryFw462NewProj\obj\project.assets.json' not found. Run a NuGet package restore
            to generate this file. [C:\temp\new-old-proj-mix-soln\ClassLibraryFw462NewProj\ClassLibraryFw462NewProj.csproj]

        0 Warning(s)
        1 Error(s)

    Time Elapsed 00:00:00.34
    Microsoft (R) Build Engine version 15.7.179.6572 for .NET Framework
    Copyright (C) Microsoft Corporation. All rights reserved.

    15.7.179.6572
    C:\temp\new-old-proj-mix-soln
