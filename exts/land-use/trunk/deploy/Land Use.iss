#include GetEnv("LANDIS_SDK") + '\packaging\initialize.iss'

#define ExtInfoFile "Land Use.txt"

#include LandisSDK + '\packaging\read-ext-info.iss'
#include LandisSDK + '\packaging\Landis-vars.iss'

; The ExtensionName in the info file includes the major and minor version
; numbers (X.Y) to allow for multiple versions of the extension to be
; installed simultaneously.  That enables users to run tests comparing two
; versions (for example, was a bug fixed in the latest version?).
;
; The Setup directives expect the ExtensionName variable to NOT have any
; version numbers.  Therefore, we strip it out.
#define ExtensionName_X_Y ExtensionName
#define ExtensionName     Trim(StringChange(ExtensionName_X_Y, MajorMinor, ""))

[Setup]
#include LandisSDK + '\packaging\Setup-directives.iss'
LicenseFile=..\LICENSE.txt

[Files]
; The extension's assembly
Source: {#LandisBuildDir}\{#ExtensionAssembly}.dll; DestDir: {app}\bin\extensions

; Harvest libraries
#define ConfigOutDir "..\src\bin\Debug"
Source: {#ConfigOutDir}\Landis.Library.BiomassHarvest-v0.dll; DestDir: {app}\bin\extensions
Source: {#ConfigOutDir}\Landis.Library.SiteHarvest-v0.dll; DestDir: {app}\bin\extensions

; The user guide
#define UserGuideSrc ExtensionName + " vX.Y - User Guide.txt"
#define UserGuide    StringChange(UserGuideSrc, "X.Y", MajorMinor)
Source: docs\{#UserGuideSrc}; DestDir: {app}\docs; DestName: {#UserGuide}

; Sample input files
Source: examples\*; DestDir: {app}\examples\{#ExtensionName}; Flags: recursesubdirs

; The extension's info file
#define ExtensionInfo  ExtensionName + " " + MajorMinor + ".txt"
Source: {#ExtInfoFile}; DestDir: {#LandisExtInfoDir}; DestName: {#ExtensionInfo}


[Run]
Filename: {#ExtAdminTool}; Parameters: "remove ""{#ExtensionName}"" "; WorkingDir: {#LandisExtInfoDir}
Filename: {#ExtAdminTool}; Parameters: "add ""{#ExtensionInfo}"" "; WorkingDir: {#LandisExtInfoDir}

[UninstallRun]
Filename: {#ExtAdminTool}; Parameters: "remove ""{#ExtensionName}"" "; WorkingDir: {#LandisExtInfoDir}

[Code]
#include LandisSDK + '\packaging\Pascal-code.iss'

//-----------------------------------------------------------------------------

function InitializeSetup_FirstPhase(): Boolean;
begin
  Result := True
end;