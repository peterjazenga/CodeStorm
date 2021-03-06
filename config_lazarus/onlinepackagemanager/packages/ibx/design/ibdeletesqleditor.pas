(*
 *  IBX For Lazarus (Firebird Express)
 *
 *  The contents of this file are subject to the Initial Developer's
 *  Public License Version 1.0 (the "License"); you may not use this
 *  file except in compliance with the License. You may obtain a copy
 *  of the License here:
 *
 *    http://www.firebirdsql.org/index.php?op=doc&id=idpl
 *
 *  Software distributed under the License is distributed on an "AS
 *  IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
 *  implied. See the License for the specific language governing rights
 *  and limitations under the License.
 *
 *  The Initial Developer of the Original Code is Tony Whyman.
 *
 *  The Original Code is (C) 2011 Tony Whyman, MWA Software
 *  (http://www.mwasoftware.co.uk).
 *
 *  All Rights Reserved.
 *
 *  Contributor(s): ______________________________________.
 *
*)

unit ibdeletesqleditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ComCtrls, IBSystemTables, IBDatabase, IBCustomDataSet, IB;

type

  { TIBDeleteSQLEditorForm }

  TIBDeleteSQLEditorForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    ExecuteOnlyIndicator: TLabel;
    GenerateBtn: TButton;
    GenerateParams: TCheckBox;
    Label1: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label4: TLabel;
    PageControl: TPageControl;
    PrimaryKeyList: TListBox;
    ProcedureNames: TComboBox;
    ProcInputList: TListBox;
    ProcOutputList: TListBox;
    TableNamesCombo: TComboBox;
    DeletePage: TTabSheet;
    ExecutePage: TTabSheet;
    TestBtn: TButton;
    IBTransaction1: TIBTransaction;
    Label3: TLabel;
    QuoteFields: TCheckBox;
    SQLText: TMemo;
    procedure DeletePageShow(Sender: TObject);
    procedure ExecutePageShow(Sender: TObject);
    procedure GenerateBtnClick(Sender: TObject);
    procedure ProcedureNamesCloseUp(Sender: TObject);
    procedure TestBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PrimaryKeyListDblClick(Sender: TObject);
    procedure TableNamesComboCloseUp(Sender: TObject);
  private
    { private declarations }
    FIBSystemTables: TIBSystemTables;
  public
    { public declarations }
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetDatabase(Database: TIBDatabase);
  end; 

var
  IBDeleteSQLEditorForm: TIBDeleteSQLEditorForm;

function EditSQL(DataSet: TIBCustomDataSet; SelectSQL: TStrings): boolean;

implementation

uses IBSQL;

{$R *.lfm}

function EditSQL(DataSet: TIBCustomDataSet; SelectSQL: TStrings): boolean;
begin
  Result := false;
  if assigned(DataSet) and assigned(DataSet.Database) then
    try
      DataSet.Database.Connected := true;
    except on E: Exception do
      ShowMessage(E.Message)
    end;

  with TIBDeleteSQLEditorForm.Create(Application) do
  try
    if assigned(DataSet) then
    begin
        SetDatabase(DataSet.Database);
        GenerateParams.Checked := DataSet.GenerateParamNames;
    end;
    SQLText.Lines.Assign(SelectSQL);
    Result := ShowModal = mrOK;
    if Result then
    begin
     SelectSQL.Assign(SQLText.Lines);
     if assigned(DataSet) then
          DataSet.GenerateParamNames := GenerateParams.Checked
    end;
  finally
    Free
  end;
end;

{ TIBDeleteSQLEditorForm }

procedure TIBDeleteSQLEditorForm.FormShow(Sender: TObject);
var IsProcedureName: boolean;
    SQLType: TIBSQLStatementTypes;
begin
  GenerateBtn.Enabled := (IBTransaction1.DefaultDatabase <> nil) and IBTransaction1.DefaultDatabase.Connected;
  TestBtn.Enabled := (IBTransaction1.DefaultDatabase <> nil) and IBTransaction1.DefaultDatabase.Connected;
  if Trim(SQLText.Text) <> '' then
  begin
    try
      SQLType := FIBSystemTables.GetStatementType(SQLText.Text,IsProcedureName);
    except  end;
    if SQLType = SQLExecProcedure then
      PageControl.ActivePage := ExecutePage
    else
      PageControl.ActivePage := DeletePage;
  end
  else
    PageControl.ActivePage := DeletePage;
end;

procedure TIBDeleteSQLEditorForm.PrimaryKeyListDblClick(Sender: TObject);
begin
  SQLText.SelText := PrimaryKeyList.Items[PrimaryKeyList.ItemIndex];
  SQLText.SetFocus
end;

procedure TIBDeleteSQLEditorForm.GenerateBtnClick(Sender: TObject);
begin
  if PageControl.ActivePage = ExecutePage then
    FIBSystemTables.GenerateExecuteSQL(ProcedureNames.Text,QuoteFields.Checked,true,
          ProcInputList.Items,ProcOutputList.Items,SQLText.Lines)
  else
    FIBSystemTables.GenerateDeleteSQL(TableNamesCombo.Text,QuoteFields.Checked,SQLText.Lines)
end;

procedure TIBDeleteSQLEditorForm.ProcedureNamesCloseUp(Sender: TObject);
var ExecuteOnly: boolean;
begin
  FIBSystemTables.GetProcParams(ProcedureNames.Text,ExecuteOnly,ProcInputList.Items,ProcOutputList.Items);
  ExecuteOnlyIndicator.Visible := ExecuteOnly;
end;

procedure TIBDeleteSQLEditorForm.DeletePageShow(Sender: TObject);
var TableName: string;
begin
  TableNamesCombo.Items.Clear;
  try
  FIBSystemTables.GetTableNames(TableNamesCombo.Items);
  if TableNamesCombo.Items.Count > 0 then
  begin
    TableNamesCombo.ItemIndex := 0;
    if Trim(SQLText.Text) <> '' then
    begin
      FIBSystemTables.GetTableAndColumns(SQLText.Text,TableName,nil);
      TableNamesCombo.ItemIndex := TableNamesCombo.Items.IndexOf(TableName)
    end;
    FIBSystemTables.GetPrimaryKeys(TableNamesCombo.Text,PrimaryKeyList.Items);
  end;
  except {ignore} end;
end;

procedure TIBDeleteSQLEditorForm.ExecutePageShow(Sender: TObject);
var ProcName: string;
    IsProcedureName: boolean;
begin
  FIBSystemTables.GetProcedureNames(ProcedureNames.Items,false);
  if ProcedureNames.Items.Count > 0 then
  begin
    if (FIBSystemTables.GetStatementType(SQLText.Text,IsProcedureName) = SQLExecProcedure) or IsProcedureName then
    begin
      FIBSystemTables.GetTableAndColumns(SQLText.Text,ProcName,nil);
      ProcedureNames.ItemIndex := ProcedureNames.Items.IndexOf(ProcName)
    end
    else
      ProcedureNames.ItemIndex := 0;
  end;
  ProcedureNamesCloseUp(nil);
end;

procedure TIBDeleteSQLEditorForm.TestBtnClick(Sender: TObject);
begin
  FIBSystemTables.TestSQL(SQLText.Lines.Text,GenerateParams.Checked)
end;

procedure TIBDeleteSQLEditorForm.TableNamesComboCloseUp(Sender: TObject);
begin
  FIBSystemTables.GetPrimaryKeys(TableNamesCombo.Text,PrimaryKeyList.Items);
end;

constructor TIBDeleteSQLEditorForm.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FIBSystemTables := TIBSystemTables.Create;
end;

destructor TIBDeleteSQLEditorForm.Destroy;
begin
  if assigned(FIBSystemTables) then FIBSystemTables.Free;
  inherited Destroy;
end;

procedure TIBDeleteSQLEditorForm.SetDatabase(Database: TIBDatabase);
begin
  IBTransaction1.DefaultDatabase := Database;
  FIBSystemTables.SelectDatabase(Database,IBTransaction1)
end;

end.
