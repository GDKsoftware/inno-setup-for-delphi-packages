#define MyAppName "MyAppName"
#define MyAppVersion "1.0"
#define MyAppPublisher "GDK Software"
#define MyAppURL "http://www.gdksoftware.co.uk/"

#define Package "MyPackage.bpl"
#define PackageProject "MyPackage.dproj"
#define PackageName "My package"


[Setup]
AppId={{D186C62B-0475-459B-B9FA-AA0632B0DF09}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={commondocs}\MyPackageFolder\
DefaultGroupName={#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=MyPackage-setup-1.0
Compression=lzma
SolidCompression=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Files]
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "CompileSource.bat"; DestDir: "{app}"; Flags: dontcopy
;Source: "MyPackage.dpk"; DestDir: "{app}\Sourcecode\Package\My Package\"; Flags: ignoreversion
;Source: "MyPackage.dproj"; DestDir: "{app}\Sourcecode\Package\My Package"; Flags: ignoreversion

[Icons]
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"

[Dirs]
Name: "{app}\BPL"

[Code]
type
  TDelphiVersion = (D7, D2005, D2007, D2009, D2010, DXE,
    DXE2, DXE3, DXE4, DXE5, DXE6, DXE7, DXE8, D10, D101,
    D102, D103);

var
  InstalledDelphiVersions: array of TDelphiVersion;  ChooseDelphiInstallationPage: TInputOptionWizardPage;

// Get the Delphi path from the registry
function GetDelphiRegKey(const DelphiVersion: TDelphiVersion): string;
var
  DelphiRegKey: string;
begin
  case DelphiVersion of
    D7    : DelphiRegKey := 'Software\Borland\Delphi\7.0';
    D2005 : DelphiRegKey := 'Software\Borland\BDS\3.0';
    D2007 : DelphiRegKey := 'Software\Borland\BDS\5.0';
    D2009 : DelphiRegKey := 'Software\CodeGear\BDS\6.0';
    D2010 : DelphiRegKey := 'Software\CodeGear\BDS\7.0';
    DXE   : DelphiRegKey := 'Software\Embarcadero\BDS\8.0';
    DXE2  : DelphiRegKey := 'Software\Embarcadero\BDS\9.0';
    DXE3  : DelphiRegKey := 'Software\Embarcadero\BDS\10.0';
    DXE4  : DelphiRegKey := 'Software\Embarcadero\BDS\11.0';
    DXE5  : DelphiRegKey := 'Software\Embarcadero\BDS\12.0';
    DXE6  : DelphiRegKey := 'Software\Embarcadero\BDS\14.0';
    DXE7  : DelphiRegKey := 'Software\Embarcadero\BDS\15.0';
    DXE8  : DelphiRegKey := 'Software\Embarcadero\BDS\16.0';
    D10   : DelphiRegKey := 'Software\Embarcadero\BDS\17.0';
    D101  : DelphiRegKey := 'Software\Embarcadero\BDS\18.0';
    D102  : DelphiRegKey := 'Software\Embarcadero\BDS\19.0';
    D103  : DelphiRegKey := 'Software\Embarcadero\BDS\20.0';
  end;

  Result := DelphiRegKey;
end;

function GetDelphiPath(const DelphiVersion: TDelphiVersion): string;
var
  RootDir, DelphiRegKey: string;
begin
  Result := '';

  DelphiRegKey := GetDelphiRegKey(DelphiVersion);

  if RegQueryStringValue(HKEY_CURRENT_USER, DelphiRegKey, 'RootDir', RootDir) then
    Result := RootDir;  
end;

// If the Delphi version is available, add it to the installed version list
procedure CheckAndAddInstall(const DelphiVersion: TDelphiVersion);var 
  DelphiPath: string;
begin
  DelphiPath := GetDelphiPath(DelphiVersion);

  if DirExists(DelphiPath) then
  begin
    SetArrayLength(InstalledDelphiVersions, GetArrayLength(InstalledDelphiVersions) + 1);
    InstalledDelphiVersions[GetArrayLength(InstalledDelphiVersions) - 1] := DelphiVersion;
  end;
end; 

function GetFriendlyName(const DelphiVersion: TDelphiVersion): string;
begin
  Result := '';

  case DelphiVersion of
    D7    : Result := 'Delphi 7';
    D2005 : Result := 'Delphi 2005';
    D2007 : Result := 'Delphi 2007';
    D2009 : Result := 'Delphi 2009';
    D2010 : Result := 'Delphi 2010';
    DXE   : Result := 'Delphi XE';
    DXE2  : Result := 'Delphi XE2';
    DXE3  : Result := 'Delphi XE3';
    DXE4  : Result := 'Delphi XE4';
    DXE5  : Result := 'Delphi XE5';
    DXE6  : Result := 'Delphi XE6';
    DXE7  : Result := 'Delphi XE7';
    DXE8  : Result := 'Delphi XE8';
    D10   : Result := 'Delphi 10 Seattle';
    D101  : Result := 'Delphi 10.1 Berlin';
    D102  : Result := 'Delphi 10.2 Tokyo';
    D103  : Result := 'Delphi 10.3 Rio';
  end;
end; 

function InitializeSetup(): Boolean;begin
  // Check Delphi versions   
  CheckAndAddInstall(D7);
  CheckAndAddInstall(D2005);
  CheckAndAddInstall(D2007);
  CheckAndAddInstall(D2009);
  CheckAndAddInstall(D2010);
  CheckAndAddInstall(DXE);
  CheckAndAddInstall(DXE2);
  CheckAndAddInstall(DXE3);
  CheckAndAddInstall(DXE4);
  CheckAndAddInstall(DXE5);
  CheckAndAddInstall(DXE6);
  CheckAndAddInstall(DXE7);
  CheckAndAddInstall(DXE8);
  CheckAndAddInstall(D10);
  CheckAndAddInstall(D101);
  CheckAndAddInstall(D102);
  CheckAndAddInstall(D103);

  Result := True;
end;                    

procedure InitializeWizard;
var
  DelphiText, DelphiPath: string;
  i: Integer;
begin
  ChooseDelphiInstallationPage := CreateInputOptionPage(wpWelcome,
      'Choose Delphi Installation', '',
      'Check the Delphi versions you want to install the component for and then click Next.',
      false, False);

  for i:=0 to GetArrayLength(InstalledDelphiVersions) - 1 do
  begin
    DelphiText := GetFriendlyName(InstalledDelphiVersions[i]);
    DelphiPath := GetDelphiPath(InstalledDelphiVersions[i]);
    ChooseDelphiInstallationPage.Add(DelphiText);
    ChooseDelphiInstallationPage.Values[i] := True;
  end;
end;       
function BuildCompileParams(const DelphiVersionText, DelphiPath: string): string;
var
  RunDir, Platform, BPLDir, DCUDir,
  Params: string;
begin
  RunDir := ExpandConstant('{app}') + '\Sourcecode\Package';
  Platform := 'Win32'; // For the moment only win32 installation

  // Basic params
  Params := '"' + RunDir + '"';
  Params := Params + ' "' + DelphiPath + 'bin\rsvars.bat" ';
  Params := Params + ' "' + ExpandConstant('{#PackageProject}') + '\" ' + Platform + ' '; 

  // BPL directory
  BPLDir := ExpandConstant('{app}') + '\Bpl\' + DelphiVersionText + '\' + Platform; 
  Params := Params + '"' + BPLDir + '"';
  DCUDir := RunDir + '\' + DelphiVersionText;
  Params := Params + ' "' + DCUDir + '"';
  Params := Params + ' ""'; // include dir
  Params := Params + ' "' + RunDir + '\' + ExpandConstant('{#PackageName}') + '\' + ExpandConstant('{#PackageProject}') + '"';

  Result := Params;
end;

// Register packages in Delphi
procedure RegisterPackage(const DelphiToInstall: TDelphiVersion);
var
  DelphiVersionText, DelphiPath, Platform, SearchPath, LibraryPath, PathLine: string;
begin
  DelphiVersionText := GetFriendlyName(DelphiToInstall);
  DelphiPath := GetDelphiPath(DelphiToInstall);
  Platform := 'Win32'; // For the moment only win32 installation

  RegWriteStringValue(HKEY_CURRENT_USER, GetDelphiRegKey(DelphiToInstall) + '\Known Packages',
    ExpandConstant('{app}') + '\Bpl\' + DelphiVersionText + '\Win32\' + ExpandConstant('{#Package}'), 
    ExpandConstant('{#PackageName}'));

  LibraryPath := GetDelphiRegKey(DelphiToInstall) + '\Library\' + Platform;

  if RegQueryStringValue(HKEY_CURRENT_USER, LibraryPath, 'Search Path', PathLine) then
  begin
    SearchPath := ExpandConstant('{app}')+'\Sourcecode\Package\' + DelphiVersionText + '\' + Platform + '\Release';
    if Pos(SearchPath, PathLine) = 0 then
    begin
      PathLine := PathLine + ';' + SearchPath; 
      RegWriteStringValue(HKEY_CURRENT_USER, LibraryPath, 'Search Path', PathLine);
    end;
  end;

  if RegQueryStringValue(HKEY_CURRENT_USER, LibraryPath, 'Browsing Path', PathLine) then
  begin
    SearchPath := ExpandConstant('{app}')+'\Sourcecode\Package\';
    
    if Pos(SearchPath, PathLine) = 0 then
    begin
      PathLine := PathLine + ';' + SearchPath; 
      RegWriteStringValue(HKEY_CURRENT_USER, LibraryPath, 'Browsing Path', PathLine); 
    end;
  end;

  if RegQueryStringValue(HKEY_CURRENT_USER, LibraryPath, 'Debug DCU Path', PathLine) then
  begin
    SearchPath := ExpandConstant('{app}')+'\Sourcecode\Package\' + DelphiVersionText + '\' + Platform + '\Debug';
    if Pos(SearchPath, PathLine) = 0 then
    begin
      PathLine := PathLine + ';' + SearchPath;
      RegWriteStringValue(HKEY_CURRENT_USER, LibraryPath, 'Debug DCU Path', PathLine);
    end;
  end;
end;  

procedure InstallPackageFor(const DelphiToInstall: TDelphiVersion);
var
  OldPackage, RunDir: string;
  DelphiVersionText, DelphiPath: string;
  ResultCode: Integer;
begin   
  DelphiVersionText := GetFriendlyName(DelphiToInstall);
  DelphiPath := GetDelphiPath(DelphiToInstall);
  WizardForm.StatusLabel.Caption:= 'Installing package for ' + DelphiVersionText;

  //Remove old BPL
  WizardForm.StatusLabel.Caption:= 'Removing old BPL files...';
  OldPackage := ExpandConstant('{app}') + '\Bpl\' + DelphiVersionText + '\'+ExpandConstant('{#Package}');

  if FileExists(OldPackage) then
    DeleteFile(OldPackage);

  // Build package
  Exec(ExpandConstant('{tmp}')+'\CompileSource.bat', BuildCompileParams(DelphiVersionText, DelphiPath),
     '', SW_SHOW, ewWaitUntilTerminated, ResultCode);
  
  if ResultCode <> 0 then 
    MsgBox('Error compiling for ' + DelphiVersionText, mbInformation, mb_OK)
  else
  begin
    RegisterPackage(DelphiToInstall);
  end;                 
end;  

procedure BuildPackages;
var
  DelphiToInstall: TDelphiVersion;
  i: Integer;
begin
  ExtractTemporaryFile('CompileSource.bat');

  for i:=0 to GetArrayLength(InstalledDelphiVersions) - 1 do
  begin
    DelphiToInstall := InstalledDelphiVersions[i];
    if ChooseDelphiInstallationPage.Values[i] then
    begin
      InstallPackageFor(DelphiToInstall);
    end;
  end;

  DeleteFile(ExpandConstant('{tmp}') + '\CompileSource.bat');   
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  DelphiText: string;
begin
  if (CurStep=ssPostInstall) then 
    BuildPackages;
end;                

//Uninstall 
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  i: Integer;
  DelphiToUnInstall: TDelphiVersion;
  DelphiVersionText: string;
begin                
  if (CurUninstallStep=usPostUninstall) then 
  begin      
    InitializeSetup;
    for i:=0 to GetArrayLength(InstalledDelphiVersions) - 1 do
    begin
      DelphiToUnInstall := InstalledDelphiVersions[i];
      DelphiVersionText := GetFriendlyName(DelphiToUnInstall);
       
      //Registry
      RegDeleteValue(HKEY_CURRENT_USER, GetDelphiRegKey(DelphiToUnInstall) + '\Known Packages',
        ExpandConstant('{app}') + '\Bpl\' + DelphiVersionText + '\Win32\' + ExpandConstant('{#Package}'));
    end;
  end;  
end;
