unit u_extfilecomp;

{$IFDEF FPC}
{$mode Delphi}
{$ENDIF}

{$I ..\DLCompilers.inc}
{$I ..\extends.inc}


interface

uses
  Classes,
  {$IFDEF VERSIONS}
  fonctions_version,
  {$ENDIF}
  SysUtils,
  DB,
  u_framework_dbcomponents;

{$IFDEF VERSIONS}
  const
    gVer_extfilecomp : T_Version = ( Component : 'Composant visibles de fichiers' ;
                                     FileUnit : 'u_extfilecomp' ;
                                     Owner : 'Matthieu Giroux' ;
                                     Comment : 'Gestion de fichiers dans le dossier d''un ordinateur.' ;
                                     BugsStory : '0.9.9.9 : Testing.';
                                               + '0.9.0.0 : TExtDBFileEdit.';
                                     UnitType : 3 ;
                                     Major : 0 ; Minor : 9 ; Release : 9 ; Build : 9 );

{$ENDIF}


type

  { TExtDBFileEdit }

   TExtDBFileEdit = class ( TFWDBFileEdit )
     private
        FLocalDir:String;
        FFilesDir:String;
        procedure SetFilesDir ( const Avalue : String );
        procedure SetFileField ( const Avalue : String );
        procedure VerifyField;
     protected
        procedure BeforeDelete(ADataset: TDataset); override;
        procedure DeleteFile; virtual;
        procedure SetDataSource(AValue: TDataSource); override;
        procedure SetDataField(const AValue: string); override;
        procedure UpdateData(Sender: TObject); override;
      public
        property LocalDir: string read FLocalDir write SetFileField;
      published
        property FilesDir: string read FFilesDir write SetFilesDir;
    End;


implementation

uses Controls,
     FileUtil,
     {$IFDEF FPC}
     unite_messages,
     LazFileUtils,
     lazutf8,
     {$ELSE}
     unite_messages_delphi,
     {$ENDIF}
     fonctions_system,
     fonctions_file,
     fonctions_filepath,
     fonctions_dialogs;

{ TExtDBFileEdit }

procedure TExtDBFileEdit.SetFilesDir(const Avalue: String);
begin
  FFilesDir:=IncludeTrailingPathDelimiter(Avalue);
end;

procedure TExtDBFileEdit.SetFileField(const Avalue: String);
begin
  FLocalDir:=fs_GetFileField (Avalue);
end;

procedure TExtDBFileEdit.SetDataField(const AValue: string);
begin
  inherited SetDataField(AValue);
  VerifyField;
end;

procedure TExtDBFileEdit.VerifyField;
begin
  p_VerifyField ( Field );
end;

procedure TExtDBFileEdit.BeforeDelete(ADataset: TDataset);
begin
  DeleteFile;
end;

procedure TExtDBFileEdit.SetDataSource(AValue: TDataSource);
begin
  inherited SetDataSource(AValue);
  VerifyField;
end;

procedure TExtDBFileEdit.DeleteFile;
Begin
  p_DeleteFile ( FFilesDir, Text );
end;

procedure TExtDBFileEdit.UpdateData(Sender: TObject);
var AText : String;
begin
  AText := Text;
  if FileExistsUTF8(FFilesDir+AText) Then
    Refresh
   Else
     try
      FLocalDir:=ExtractFileDir(AText);
      {$IFDEF WINDOWS}
      if (length(AText) > 2)
      and (AText [2] = ':' ) Then
      {$ELSE}
      if (AText > '')
      and (AText [1] = DirectorySeparator ) Then
      {$ENDIF}
       with Field do
       Begin
        DataSet.Edit;
        AsString:=fs_SaveFile(ExtractFileDir(AText),FFilesDir,ExtractFileName(AText),AsString);
        Text:=AsString;
       end;
     finally
     end;
end;

{$IFDEF VERSIONS}
initialization
  p_ConcatVersion ( gVer_extfilecomp );
{$ENDIF}
end.

