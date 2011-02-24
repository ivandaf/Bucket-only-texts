unit sqlGenerate;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ArrayS, ToolWin, ComCtrls, XPMan, ActnMan,
  ActnCtrls, ActnMenus, Menus, Grids, ValEdit, DB, ZAbstractRODataset,
  ZAbstractDataset, ZDataset, ZConnection, DBGrids;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Classes: TGroupBox;
    CheckCar: TCheckBox;
    CheckCarForSale: TCheckBox;
    CheckUsedCar: TCheckBox;
    CheckNewCar: TCheckBox;
    CheckMotorcycle: TCheckBox;
    ListBox1: TListBox;
    TestMemo: TMemo;
    Label6: TLabel;
    StatusBar1: TStatusBar;
    GlobalPageControl: TPageControl;
    WorkTab: TTabSheet;
    SettingsTab: TTabSheet;
    WorkPageControl: TPageControl;
    SQLTab: TTabSheet;
    ClearButton: TButton;
    GeneratedQuery: TMemo;
    Attribs: TGroupBox;
    CheckAll: TCheckBox;
    GenerateButton: TButton;
    Restrictions: TGroupBox;
    YearCaption: TLabel;
    PriceCaption: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Restriction1min: TComboBox;
    Restriction2min: TComboBox;
    Restriction1max: TComboBox;
    Restriction2max: TComboBox;
    SetRestrictionsToAny: TButton;
    RestrictionInc1max: TCheckBox;
    RestrictionInc2max: TCheckBox;
    RestrictionInc1min: TCheckBox;
    RestrictionInc2min: TCheckBox;
    CreateBucket: TButton;
    ClassList: TCheckListBox;
    BucketTab: TTabSheet;
    SettingsPageControl: TPageControl;
    SourcesTab: TTabSheet;
    QueryPlanTab: TTabSheet;
    ResultsTab: TTabSheet;
    CapabilitiesTab: TTabSheet;
    ClassesTab: TTabSheet;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    N1: TMenuItem;
    PrintSetup1: TMenuItem;
    Print1: TMenuItem;
    N2: TMenuItem;
    SaveAs1: TMenuItem;
    Save1: TMenuItem;
    Open1: TMenuItem;
    New1: TMenuItem;
    Window1: TMenuItem;
    Show1: TMenuItem;
    Hide1: TMenuItem;
    N3: TMenuItem;
    ArrangeAll1: TMenuItem;
    Cascade1: TMenuItem;
    ile1: TMenuItem;
    NewWindow1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    HowtoUseHelp1: TMenuItem;
    SearchforHelpOn1: TMenuItem;
    Contents1: TMenuItem;
    ClearLog: TButton;
    TestMemo2: TMemo;
    ReCreateBucket: TButton;
    SourceCapabilitiesList: TCheckListBox;
    SearchQueryList: TValueListEditor;
    ClassesLabel: TLabel;
    CapabilitiesLabel: TLabel;
    SearchQueriesLabel: TLabel;
    ClassesMatrix: TStringGrid;
    AddRowCol: TButton;
    AddNewClass: TButton;
    NewClassName: TEdit;
    NewClassNameLabel: TLabel;
    DBGrid1: TDBGrid;
    ZConnection1: TZConnection;
    ZQuery1: TZQuery;
    DataSource1: TDataSource;
    qlist: TListBox;
    connecttodb: TButton;
    doQuery: TButton;
//    procedure ListBox1Click(Sender: TObject);
    procedure QuitClick(Sender: TObject);
    procedure CheckCarClick(Sender: TObject);
    procedure GenerateButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
//    procedure SearchModelEnter(Sender: TObject);
//    procedure SearchModelExit(Sender: TObject);
//    procedure SearchCategoryEnter(Sender: TObject);
//    procedure SearchCategoryExit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
//    procedure ModelClick(Sender: TObject);
//    procedure CategoryClick(Sender: TObject);
    procedure CheckAllClick(Sender: TObject);
    procedure CheckCarForSaleClick(Sender: TObject);
    procedure CheckUsedCarClick(Sender: TObject);
    procedure CheckNewCarClick(Sender: TObject);
    procedure SetRestrictionsToAnyClick(Sender: TObject);
    procedure CreateBucketClick(Sender: TObject);
    procedure ClearLogClick(Sender: TObject);
    procedure AddNewClassClick(Sender: TObject);
    procedure AddRowColClick(Sender: TObject);
    procedure connecttodbClick(Sender: TObject);
    procedure doQueryClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  GeneratedQueryString: AnsiString;
  NewQueryString: AnsiString;
  QueryCount: integer;

  StartMemory: integer;

  i,q,c,count: integer;

  ArrSourceCapabilities: array [1..10] of AnsiString;  // ����: ����������� ����������
  ArrQueryWhat: array [1..10] of AnsiString; // ��� ����� �������� - ����� ���� � �������� ����������
  StrQueryWhat: AnsiString;  // ��������� �������� ����� ��� SQL-�������
  ArrSourceClass: array [1..20] of AnsiString; // ����: ������ �������� �������, ��������� � ����������
  ArrQueryClass: array [1..10] of AnsiString; // ����� �������� ������
  StrQueryClass: AnsiString;  // ��������� �������� ������� ��� SQL-�������
  ArrQueryRestrictions: array [1..10] of AnsiString; // ���������������� ����������� ��� �������
  StrQueryRestrictions: AnsiString;  // ��������� �������� ����������� ��� SQL-�������
  ArrQuerySearches: array [1..10] of AnsiString;  // ���������������� ����������� ��� ��������� ����� - ��������� ����� ��� �������
  StrQuerySearches: AnsiString;  // ��������� �������� ������ ��� SQL-�������

 // ArrDisjointClasses: array [1..6,1..6] of integer; // ������� ��������� ������� - �������� ������ � ���������
  ArrDisjointClasses: array of array of integer ; // ��� �� ����� ����������� ��������� ������ � ����� ������ ������������   (������)
  ArrDisjointClassesMatrix: IMltArray; // ������������� ������ �������� ���������, ������� �� ������� ��������� ������� � ������ �������� �������
                                       // ������ ArrDisjointClassesMatrix[classname1][classname2] = DjointOrNot{0,1}


  IntArr: IIntArray;
  StrArr: IStrArray;
  VarArr: IVarArray;
  MltArr: IMltArray;

  
  Source1: IMltArray; // �������� ����������
  Source2: IMltArray; // ������ Source#['inclass'][i] = ArrSourceClass[j]; // = Motorcycle;
  Source3: IMltArray; // ������ Source#['capability'][i] = ArrSourceCapabilities[j]; // = SellerContact;
  Source4: IMltArray; // ������ (������������ ��������) Source#['name'][0] = 'Motorcycles for sale'; // SOURCE NAME
  Source5: IMltArray;
  SourceClassesCapabilities: IMltArray; // �������� �������.
                                        // ������ SourceClassesCapabilities[ArrSourceClass[j]][i] =  ArrSourceCapabilities[k]; //= Model;


  Sources: array [1..100] of IMltArray; // ������ ���� ���������� - ��� ������

  Bucket: array [1..100] of Integer;  // ����� � �������� ����������. ���������, ���������� ��� �������� �������
                                      // ������ Bucket[i] = Source_number , ��� Source_number = k �� Sources[k]
//SourceBucketRating: array [1..100] of integer; // ������ ���������� ��� ���������� � ���������� � ������� ��������� ��������
                                                 // ��������� �� �������� � ������������, �� ���������� ���������� ����� � ������� � ���������


  SourceRestrictions: IMltArray; // ����: ����������� � ����������
                                 // ������ SourceRestrictions[Source#['name'][0]][ArrSourceCapabilities[j]][<,>,=,>=,<=] = IntValue // = 20000, = 1950

  ArrQueryRestrictionsMatrix:  IMltArray; // ����������� � ������� � ���� �������������� ������� - ��� ��������� � �����
                                          // ������ ArrQueryRestrictionsMatrix[ArrQueryRestrictions[i]]['>,<,=,>=,<='] = IntValue // = 2000, = 1960

  kon : integer;  // ������ ����� ���������� ��������� ��-�� � ������� ArrSourceClasses
  najal : integer; // ����� ��� ���������� ��������� ���������� �������
  najal2raza : integer; // ��� �� ������ ���� �������� ��� ����� �������

implementation

{$R *.dfm}

{procedure TForm1.ListBox1Click(Sender: TObject);
begin
  Edit1.Text:=ListBox1.Items[ListBox1.ItemIndex];
end; }

procedure TForm1.QuitClick(Sender: TObject);
begin
close;
end;

procedure TForm1.CheckCarClick(Sender: TObject);
begin
      // ���� ���������� Car, ���������� ��� ��������� ������
      if CheckCar.Checked = true
      then
        begin
        CheckCarForSale.Checked := true;
        CheckUsedCar.checked := true;
        CheckNewCar.Checked := true;
        end;
      
end;

procedure TForm1.GenerateButtonClick(Sender: TObject);
var CanEquals: String;
CurrentMemory,kick: integer;
begin
      // ������� �������� �� ��������� (��������)
      // if SearchCategory.Text = '<Category>'
      // then SearchCategory.Clear;
      // if SearchModel.Text = '<Name of Model>'
      // then SearchModel.Clear;

       StrQueryRestrictions := '';
       StrQueryClass := '';
       StrQuerySearches := '';

      // �������� ��������� � ���������� ���� �����������
       for i:=1 to high(ArrQueryRestrictions) do
       begin
          if (((FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text = 'any') OR ((FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text = 'any'))
          then break
          else begin
            if ((FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text > (FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text) then
            begin
            // ���� ������������ ������ ����. ��������, ��� ��� ���� ������ 100, �� ������ 10
            Application.MessageBox ('Maximum of restriction > restriction minimum', 'Restriction Error', mb_Ok + mb_IconExclamation);
            exit;
            end;
          end;
       end;



      // ���������� ������ ���������������� �������
      NewQueryString :=  '------ WroldView SQL Query #' + IntToStr(QueryCount) + ' ------';
      GeneratedQuery.Lines.Add(NewQueryString);

// ������������� SQL �������
   // ---������ ����� ������� ����� ArrQueryWhat[]---
      c := 0; // ������� ��� ������� ArrQueryWhat[]
      // ����������, ��� ����������� ������. ���� - �� ������� ArrSourceCapabilities, ����� ��������� ������ ��������� � ������ � �������
      for q:=1 to high(ArrSourceCapabilities) do
      begin
        if (ArrSourceCapabilities[q]<>'') then
        begin
          // ��� ������ ���������� if (FindComponent(ArrSourceCapabilities[q]) as TCheckBox).Checked = true
          if (SourceCapabilitiesList.Checked[q-1] = true)
          then begin
          c := c + 1;
          // ��������� ��������� ���������� ���� � ������ ArrQueryWhat[]
          ArrQueryWhat[c] := ArrSourceCapabilities[q];
          end;
        end;
        if (c = 0) then ArrQueryWhat[1] := '*';
      end;
      q:=0; c:=0;

      i:=0;


      // ���������� ���������� �������� ��������� � �������
      count := 0;
      for i:=1 to high(ArrQueryWhat) do if ArrQueryWhat[i]<>'' then count := count + 1;

      // �������� ����, ������� ���� ����� ������� - select WHAT from ...
      for i:=1 to count do
        begin
          if (ArrQueryWhat[i]<>'') then StrQueryWhat := StrQueryWhat + ArrQueryWhat[i];
          if (ArrQueryWhat[i+1]<>'') then StrQueryWhat := StrQueryWhat + ', ';
        end;
        // TestMemo.Lines.Add(StrQueryWhat);
   // ---����� ����� ������� ����� StrQueryWhat---





   // ---������ ����� ����������� (RESTRICTIONS) ArrQueryRestrictions[]---
      //ArrQueryRestrictions[1] := 'Year';
      //ArrQueryRestrictions[2] := 'Price';

      ArrQueryRestrictionsMatrix := CreateArray; // ������� ����������� ������������ ArrQueryRestrictionsMatrix[restrictionname][<>=]=value

      // ���������� ���������� �������� ��������� � �������
      count := 0;
      for i:=1 to high(ArrQueryRestrictions) do if ArrQueryRestrictions[i]<>'' then count := count + 1;

      // ����������� � SQL
      CanEquals:='';
      kick:=0;
      for i:=1 to count do
      begin
      if ((FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text = 'any') AND ((FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text = 'any')
          then
            begin
            kick := kick +1;
            if (kick = count) then StrQueryRestrictions := '';  // ���� ����� ����� any
            end
          else begin
              if ((FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text = 'any')
              then begin
              if (StrQueryRestrictions <> '') then begin StrQueryRestrictions := StrQueryRestrictions + ' AND ';  end;
              if ((FindComponent('RestrictionInc' + IntToStr(i) + 'max') as TCheckBox).Checked = true) then CanEquals:= '=';
              StrQueryRestrictions := StrQueryRestrictions +  ' ' + ArrQueryRestrictions[i] + '<' + CanEquals + (FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text;

              // ��������� ����������� � ������� ��� ���������� ��������� � �����
              ArrQueryRestrictionsMatrix[ArrQueryRestrictions[i]]['<'+ CanEquals].AsString := (FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text;
              // ����� � ��� � ���, ��� ��������� �����������
              TestMemo2.Lines.Add('Restriction added: [' + ArrQueryRestrictions[i] + '][<' + CanEquals + '] = ' + (FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text);

              CanEquals:='';
              end;

              if ((FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text = 'any')
              then begin
              if (StrQueryRestrictions <> '') then begin StrQueryRestrictions := StrQueryRestrictions + ' AND '; end;
              if ((FindComponent('RestrictionInc' + IntToStr(i) + 'min') as TCheckBox).Checked = true) then begin CanEquals := '='; end;
              StrQueryRestrictions := StrQueryRestrictions + ' ' + ArrQueryRestrictions[i] + '>' + CanEquals + (FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text;

              // ��������� ����������� � ������� ��� ���������� ��������� � �����
              ArrQueryRestrictionsMatrix[ArrQueryRestrictions[i]]['>'+ CanEquals].AsString := (FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text;   //max -> min ivandaf
              // ����� � ��� � ���, ��� ��������� �����������
              TestMemo2.Lines.Add('Restriction added: [' + ArrQueryRestrictions[i] + '][>' + CanEquals + '] = ' + (FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text);

              CanEquals:='';
              end;

              if ((FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text <> 'any') AND ((FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text <> 'any')
              then begin
              if (StrQueryRestrictions <> '') then begin StrQueryRestrictions := StrQueryRestrictions + ' AND ';  end;
              if ((FindComponent('RestrictionInc' + IntToStr(i) + 'max') as TCheckBox).Checked = true) AND ((FindComponent('RestrictionInc' + IntToStr(i) + 'min') as TCheckBox).Checked = true) then begin CanEquals := '='; end;
              StrQueryRestrictions := StrQueryRestrictions + ArrQueryRestrictions[i] + '>' + CanEquals + (FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text + ' AND ' + ArrQueryRestrictions[i] + '<' + CanEquals + (FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text;

              // ��������� ����������� � ������� ��� ���������� ��������� � �����
              ArrQueryRestrictionsMatrix[ArrQueryRestrictions[i]]['>'+ CanEquals].AsString := (FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text;
              ArrQueryRestrictionsMatrix[ArrQueryRestrictions[i]]['<'+ CanEquals].AsString := (FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text;
              // ����� � ��� � ���, ��� ��������� �����������
              TestMemo2.Lines.Add('Restriction added: [' + ArrQueryRestrictions[i] + '][>' + CanEquals + '] = ' + (FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text);
              TestMemo2.Lines.Add('Restriction added: [' + ArrQueryRestrictions[i] + '][<' + CanEquals + '] = ' + (FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text);

              CanEquals:='';
              end;
          end;
      end;
   // ---����� ����� ����������� (RESTRICTIONS) StrQueryRestrictions---


   // ---������ ������ StrQuerySearches---


      // ���������� ���������� �������� ��������� � �������
      count := 0;
      for i:=0 to high(ArrQuerySearches) do begin if ArrQuerySearches[i]<>'' then count := count + 1; end;

      // ���� ��������� �����������, ��������� � ��������� ��������
      for i:=1 to count do begin
        // ��� ������ ���������� ���� if ((FindComponent('Search' + ArrQuerySearches[i]) as TEdit).Text <> '') AND ((FindComponent(ArrQuerySearches[i]) as TCheckBox).Checked = true)
              if (SearchQueryList.Values[ArrQuerySearches[i]] <> '')
              then begin
                  if (StrQueryRestrictions <> '') OR (StrQuerySearches <> '') then StrQuerySearches := StrQuerySearches + ' AND ';
                  StrQuerySearches := StrQuerySearches + ArrQuerySearches[i] + ' LIKE ' + '''%' + SearchQueryList.Values[ArrQuerySearches[i]] + '%'' ';
                  //if (ArrQuerySearches[i+1] <> '') then StrQuerySearches := StrQuerySearches + ' AND ';

              end;
      end;
    //  TestMemo.Lines.Add(StrQuerySearches);
   // ---����� ������ StrQuerySearches---


      // ---������ ����� ������� ������� (�����) ArrQueryClass[]---

      ClassList.MultiSelect := true; // ��� ���������� ���������
      // ���������� ���������� �������� ��������� � �������
      q := 0;
      count := 0;
      for i:=1 to high(ArrSourceClass) do begin if ArrSourceClass[i]<>'' then count := count + 1; end;

      for i:=0 to (ClassList.Items.Count-1) do begin
         if (ClassList.Checked[i] = true) then
         begin
         q := q + 1;
         ArrQueryClass[q] := ArrSourceClass[i+1];
         //TestMemo.Lines.Add(ArrSourceClass[i+1] + ' checked');
         end;
      end;

      // ����������� � SQL
      if (ClassList.SelCount >= 0) then
      begin
          for i:=1 to q do begin
              if ((StrQueryClass = '') AND ((StrQueryRestrictions <> '') OR (StrQuerySearches <> ''))) then
              begin
              StrQueryClass := StrQueryClass + ' AND ';
              end;

              if (StrQueryClass <> '') AND (StrQueryClass <> ' AND ') then
              begin
              StrQueryClass := StrQueryClass + ' OR ';
              end;

              StrQueryClass := StrQueryClass + 'type = ''' + ArrQueryClass[i] + ''' ';
          end;
      end;

     // TestMemo.Lines.Add(StrQueryClass);


   // ---����� ����� ������� ������� (�����) StrQueryClass---





      // �������� ������� SQL ������
      GeneratedQueryString := 'SELECT ' + StrQueryWhat + ' FROM WorldView';
      if ((StrQueryRestrictions <> '') OR (StrQueryClass <> '') OR (StrQuerySearches <> '')) then GeneratedQueryString := GeneratedQueryString + ' WHERE ';
          // ��������� �����������
      if (StrQueryRestrictions <> '') then GeneratedQueryString := GeneratedQueryString + StrQueryRestrictions;
          // ��������� ��������� ������
      if (StrQuerySearches <> '') then GeneratedQueryString := GeneratedQueryString + StrQuerySearches;
          // ��������� ������
      if (StrQueryClass <> '') then GeneratedQueryString := GeneratedQueryString + StrQueryClass;

      // ������� ������� SQL ������
      GeneratedQuery.Lines.Add(GeneratedQueryString);

      // ��������� ����� ������� (������ ��� ����������� � ���������)
      QueryCount:=QueryCount+1;

      // ��������� ������ � ������ �� ������ ������ ��� ��������� ��������
      for i:=1 to length(ArrQueryWhat) do
      begin
          ArrQueryWhat[i] := '';
      end;
      StrQueryWhat := '';

      // �������� ������� ��������, ���� ������������ ��� ������ � �� ������
     (* if SearchCategory.Text = ''
       then SearchCategory.Text := '<Category>';
      if SearchModel.Text = ''
       then SearchModel.Text := '<Name of Model>'; *)


CurrentMemory := AllocMemSize - StartMemory;
StatusBar1.SimpleText := 'Memory leak after Generating SQL: ' + IntToStr(CurrentMemory) + ' bytes';

end;

procedure TForm1.ClearButtonClick(Sender: TObject);
begin
GeneratedQuery.Clear;
end;

(*procedure TForm1.SearchModelEnter(Sender: TObject);
begin
       if SearchModel.Text = '<Name of Model>'
       then SearchModel.Clear;
end; *)

(*procedure TForm1.SearchModelExit(Sender: TObject);
begin
       if SearchModel.Text = ''
       then SearchModel.Text:='<Name of Model>';
end;

procedure TForm1.SearchCategoryEnter(Sender: TObject);
begin
         if SearchCategory.Text = '<Category>'
       then SearchCategory.Clear;
end;

procedure TForm1.SearchCategoryExit(Sender: TObject);
begin
            if SearchCategory.Text = ''
       then SearchCategory.Text:='<Category>';
end;*)

procedure TForm1.FormCreate(Sender: TObject);
var
  CurrentMemory,EndMemory,j,k,indmas: integer;
  coltabl,rowtabl,tablstr : string;
  MatrixDimensionFile : TextFile; // ���������� �������� � ����� � ������� ��������� - ����
  MatrixDimensionFileLocation : String; // ���, ����� �����
  ClassNameFile : TextFile;  // �������� �������
  ClassNameFileLocation : String;  // ���, ����� �����
  DisjointMatrixFile : TextFile; // ������� ��������� - ����
  DisjointMatrixFileLocation : String; // ���, ����� �����
begin
 najal:=0;
 najal2raza:=0;
 ////////////////////////////// ## DUMIN ## //////////////////////////////
  qlist.Items.LoadFromFile('queries.txt');
  qlist.ItemIndex:=0;
   ////////////////////////////// ## DUMIN ## //////////////////////////////




 /////////////////////////// ## ABRAMOV ## ////////////////////////////////
 // ��������� ��� ����� ���
 MatrixDimensionFileLocation :=  'Colrow.txt';
 DisjointMatrixFileLocation := 'Savetabl.txt';
 ClassNameFileLocation := 'Classname.txt';


 // �������� ������
 StartMemory := AllocMemSize;
 StatusBar1.SimpleText := 'Memory allocated at start: ' + IntToStr(StartMemory) + ' bytes';

(* ������ ��������� if Category.Checked = false
 then SearchCategory.Enabled := false;

 if Model.Checked = false
 then SearchModel.Enabled := false;
 *)

// ����: �������� ������� ������
      // ������ �� ����� ���������� ������ ����������, ��� ����������� ����������
      ArrSourceCapabilities[1] := 'Model';
      ArrSourceCapabilities[2] := 'Category';
      ArrSourceCapabilities[3] := 'Year';
      ArrSourceCapabilities[4] := 'Price';
      ArrSourceCapabilities[5] := 'SellerContact';
      ArrSourceCapabilities[6] := 'ProductReview';

      // ��������� � �����������
      SourceCapabilitiesList.MultiSelect := true;
      for i := 1 to length(ArrSourceCapabilities) do begin
         if (ArrSourceCapabilities[i] <> '') then
            SourceCapabilitiesList.Items.Add(ArrSourceCapabilities[i])
         else break;
      end;

      // ������ �� ����� ���������� �������� � ����������
      {ArrSourceClass[1] := 'Car';
      ArrSourceClass[2] := 'CarForSale';
      ArrSourceClass[3] := 'UsedCar';
      ArrSourceClass[4] := 'NewCar';
      ArrSourceClass[5] := 'Motorcycle';
      ArrSourceClass[6] := 'Product'; }        // ������ ��������� �� �����


     /////////////////////////// ## ABRAMOV ## ////////////////////////////////
      AssignFile(ClassNameFile,ClassNameFileLocation);    // ������ �������� ��������� ����� �� �����    ������ ������ ������������
      Reset(ClassNameFile);  // ����� ������� - ������
      indmas:=1;
      While not Eof(ClassNameFile) do begin
        ReadLn(ClassNameFile,ArrSourceClass[indmas]);
        Inc(indmas);
      end;
      CloseFile(ClassNameFile);

          // ��������� ������  � ListBox
          for i:=0 to (high(ArrSourceClass))-1 do begin
              if (ArrSourceClass[i+1] <> '') then             // ������� �������� ������ ��� ���������� ���� � ����
               ClassList.Items.Add('(' + IntToStr(i+1) + ') ' + ArrSourceClass[i+1]);
          end;

      // Djoint and Disjoint classes

    {  ArrDisjointClasses[1,1]:= 1;
      ArrDisjointClasses[1,2]:= 1;
      ArrDisjointClasses[1,3]:= 1;
      ArrDisjointClasses[1,4]:= 1;
      ArrDisjointClasses[1,5]:= 0;
      ArrDisjointClasses[1,6]:= 1;
      ArrDisjointClasses[2,1]:= 1;
      ArrDisjointClasses[2,2]:= 1;
      ArrDisjointClasses[2,3]:= 1;
      ArrDisjointClasses[2,4]:= 1;
      ArrDisjointClasses[2,5]:= 0;
      ArrDisjointClasses[2,6]:= 1;
      ArrDisjointClasses[3,1]:= 1;
      ArrDisjointClasses[3,2]:= 1;
      ArrDisjointClasses[3,3]:= 1;
      ArrDisjointClasses[3,4]:= 0;
      ArrDisjointClasses[3,5]:= 0;
      ArrDisjointClasses[3,6]:= 0;
      ArrDisjointClasses[4,1]:= 1;
      ArrDisjointClasses[4,2]:= 1;
      ArrDisjointClasses[4,3]:= 0;
      ArrDisjointClasses[4,4]:= 1;
      ArrDisjointClasses[4,5]:= 0;
      ArrDisjointClasses[4,6]:= 1;
      ArrDisjointClasses[5,1]:= 0;
      ArrDisjointClasses[5,2]:= 0;
      ArrDisjointClasses[5,3]:= 0;
      ArrDisjointClasses[5,4]:= 0;
      ArrDisjointClasses[5,5]:= 1;
      ArrDisjointClasses[6,1]:= 1;
      ArrDisjointClasses[6,2]:= 1;
      ArrDisjointClasses[6,3]:= 1;
      ArrDisjointClasses[6,4]:= 1;
      ArrDisjointClasses[6,5]:= 1;
      ArrDisjointClasses[6,6]:= 1; }     // ������ ��������� �� �����

/////////////////////////// ## ABRAMOV ## ////////////////////////////////
  AssignFile(MatrixDimensionFile,MatrixDimensionFileLocation);
  Reset(MatrixDimensionFile);
  ReadLn (MatrixDimensionFile , coltabl);
  ReadLn (MatrixDimensionFile , rowtabl);
  CloseFile(MatrixDimensionFile);

 SetLength( ArrDisjointClasses , (StrToInt(coltabl))-1 , (StrToInt(rowtabl))-1 );

 ClassesMatrix.RowCount:= StrToInt(rowtabl);
 ClassesMatrix.ColCount:= StrToInt(coltabl);

      tablstr:='';
      AssignFile(DisjointMatrixFile,DisjointMatrixFileLocation);
      Reset(DisjointMatrixFile);
      While not Eof(DisjointMatrixFile) do begin
        for i:=0 to High(ArrDisjointClasses) do begin  // ������ ���������� � 0
           ReadLn(DisjointMatrixFile,tablstr);
           for j:=0 to (Length(tablstr))-1 do begin
               ArrDisjointClasses[i,j] := StrToInt(tablstr[j+1]);   // ������ ���������� � 0
               ClassesMatrix.Cells[j+1,i+1] := tablstr[j+1];         // ������ ���������� � 1
           end;
           tablstr:='';
        end;
      end;
      CloseFile(DisjointMatrixFile);

      // ������ �� ����� ���������� ������������� � �������
      ArrQueryRestrictions[1] := 'Year';
      ArrQueryRestrictions[2] := 'Price';

      // ������ � ������, ������� ������ ���������� ���������
      ArrQuerySearches[1] := 'Model';
      ArrQuerySearches[2] := 'Category';
      ArrQuerySearches[3] := 'ProductReview';

      // ��������� � SearchQueryList
      for i := 1 to length(ArrQuerySearches) do begin
         if (ArrQuerySearches[i] <> '') then
            SearchQueryList.InsertRow(ArrQuerySearches[i], '', true)
         else break;
      end;






      // �������������� ������ ������� ��������� ������� - � ������������� �������.
      ArrDisjointClassesMatrix := CreateArray;
    {  for j:=1 to high (ArrSourceClass) do
      begin                                       // ����� ��� ����� � ������� �����  ����   (������)
         if (ArrSourceClass[j] <> '') then
         begin
            for k:=1 to high (ArrSourceClass) do
            begin
                 if (ArrSourceClass[k] <> '') then
                 begin
                      ArrDisjointClassesMatrix[ArrSourceClass[j]][ArrSourceClass[k]].AsInteger := ArrDisjointClasses[j,k];
                      TestMemo2.Lines.Add('[' + ArrSourceClass[j] + '][' + ArrSourceClass[k] + '] = ' + IntToStr(ArrDisjointClassesMatrix[ArrSourceClass[j]][ArrSourceClass[k]].AsInteger));
                 end
                 else break;
            end;
          end
          else break;
      end;     }
      /////////////////////////// ## ABRAMOV ## ////////////////////////////////
      kon:=0;  // ��� �� ���?
      for i:=1 to High(ArrSourceClass) do begin
        if ArrSourceClass[i]<>'' then kon:=kon+1
        else Break;
      end;

      for j:=0 to kon-1 do begin
          for k:=0 to kon-1 do begin
             ArrDisjointClassesMatrix[ArrSourceClass[j+1]][ArrSourceClass[k+1]].AsInteger := ArrDisjointClasses[j,k];
             TestMemo2.Lines.Add('[' + ArrSourceClass[j+1] + '][' + ArrSourceClass[k+1] + '] = ' + IntToStr(ArrDisjointClassesMatrix[ArrSourceClass[j+1]][ArrSourceClass[k+1]].AsInteger));
          end;
       end;

// �������� ����������
      Source1 := CreateArray;
      Source2 := CreateArray;
      Source3 := CreateArray;
      Source4 := CreateArray;
      Source5 := CreateArray;
      SourceRestrictions := CreateArray;

      Sources[1] := Source1;
      Sources[2] := Source2;
      Sources[3] := Source3;
      Sources[4] := Source4;
      Sources[5] := Source5;

      Source1.Clear;
      Source1['inclass'][1].AsString := ArrSourceClass[2]; // = CarForSale;
      Source1['inclass'][2].AsString := ArrSourceClass[3]; // = UsedCar;
      Source1['name'][0].AsString := 'Used cars for sale'; // SOURCE NAME

      Source2.Clear;
      Source2['inclass'][1].AsString := ArrSourceClass[2]; // = CarForSale;
      Source2['name'][0].AsString := 'Lux cars for sale'; // SOURCE NAME

      Source3.Clear;
      Source3['inclass'][1].AsString := ArrSourceClass[2]; // = CarForSale;
      Source3['name'][0].AsString := 'Vintage cars for sale'; // SOURCE NAME

      Source4.Clear;
      Source4['inclass'][1].AsString := ArrSourceClass[5]; // = Motorcycle;
      Source4['capability'][1].AsString := ArrSourceCapabilities[5]; // = SellerContact;
      Source4['capability'][2].AsString := ArrSourceCapabilities[4]; // = Price;
      Source4['name'][0].AsString := 'Motorcycles for sale'; // SOURCE NAME

      Source5.Clear;
      Source5['inclass'][1].AsString := ArrSourceClass[6]; // = Product;
      Source5['capability'][3].AsString := ArrSourceCapabilities[6]; // = ProductReview;
      Source5['name'][0].AsString := 'Car reviews'; // SOURCE NAME

        // ����������� ���������� ������ SourceRestrictions[source][capability][<,>,=,>=,<=] = value
        SourceRestrictions[Source2['name'][0].AsString][ArrSourceCapabilities[4]]['>='].AsInteger := 20000;  // = Price;
        SourceRestrictions[Source3['name'][0].AsString][ArrSourceCapabilities[3]]['<='].AsInteger := 1950;  // = Year;

// �������� ������� SourceClassesCapabilities[classname][i] = capability
      SourceClassesCapabilities := CreateArray;

      // Class CAR
      SourceClassesCapabilities[ArrSourceClass[1]][1].AsString :=  ArrSourceCapabilities[1]; //= Model;
      SourceClassesCapabilities[ArrSourceClass[1]][2].AsString :=  ArrSourceCapabilities[3]; //= Year;
      SourceClassesCapabilities[ArrSourceClass[1]][3].AsString :=  ArrSourceCapabilities[2]; //= Category;

      // Class CarForSale
      SourceClassesCapabilities[ArrSourceClass[2]][1].AsString :=  ArrSourceCapabilities[1]; //= Model;
      SourceClassesCapabilities[ArrSourceClass[2]][2].AsString :=  ArrSourceCapabilities[3]; //= Year;
      SourceClassesCapabilities[ArrSourceClass[2]][3].AsString :=  ArrSourceCapabilities[2]; //= Category;
      SourceClassesCapabilities[ArrSourceClass[2]][4].AsString :=  ArrSourceCapabilities[5]; //= SellerContact;
      SourceClassesCapabilities[ArrSourceClass[2]][5].AsString :=  ArrSourceCapabilities[4]; //= Price;

      // Class UsedCar
      SourceClassesCapabilities[ArrSourceClass[3]][1].AsString :=  ArrSourceCapabilities[1]; //= Model;
      SourceClassesCapabilities[ArrSourceClass[3]][2].AsString :=  ArrSourceCapabilities[3]; //= Year;
      SourceClassesCapabilities[ArrSourceClass[3]][3].AsString :=  ArrSourceCapabilities[2]; //= Category;

      // Class NewCar
      SourceClassesCapabilities[ArrSourceClass[4]][1].AsString :=  ArrSourceCapabilities[1]; //= Model;
      SourceClassesCapabilities[ArrSourceClass[4]][2].AsString :=  ArrSourceCapabilities[3]; //= Year;
      SourceClassesCapabilities[ArrSourceClass[4]][3].AsString :=  ArrSourceCapabilities[2]; //= Category;

      // Class Motorcycle
      SourceClassesCapabilities[ArrSourceClass[5]][1].AsString :=  ArrSourceCapabilities[1]; //= Model;
      SourceClassesCapabilities[ArrSourceClass[5]][2].AsString :=  ArrSourceCapabilities[3]; //= Year;

      // Class Product
      SourceClassesCapabilities[ArrSourceClass[6]][1].AsString :=  ArrSourceCapabilities[1]; //= Model;
      SourceClassesCapabilities[ArrSourceClass[6]][2].AsString :=  ArrSourceCapabilities[3]; //= Year;



  for i:=1 to (ClassesMatrix.RowCount - 1) do begin
    if ArrSourceClass[i]<>'' then
      ClassesMatrix.Cells[0,i]:= ArrSourceClass[i]
    else Break;
  end;

  for i:=1 to (ClassesMatrix.ColCount - 1) do begin
    if ArrSourceClass[i]<>'' then
      ClassesMatrix.Cells[i,0]:= ArrSourceClass[i]
    else Break;
  end;


end;    // ����� ��������� �������� �����

(*procedure TForm1.ModelClick(Sender: TObject);
begin
  // ���� �� �������� �������, �� ���� ���������
 if Model.Checked = true
 then SearchModel.Enabled := true;
  if Model.Checked = false
 then SearchModel.Enabled := false;
end; *)


(*procedure TForm1.CategoryClick(Sender: TObject);
begin
 // ���� �� �������� �������, �� ���� ���������
 if Category.Checked = true
 then SearchCategory.Enabled := true;
  if Category.Checked = false
 then SearchCategory.Enabled := false;
end; *)



procedure TForm1.CheckAllClick(Sender: TObject);
begin
    if CheckAll.Checked = true      // ������� Show All - �������� ��� ����
    then
    begin
        for i:=1 to length(ArrSourceCapabilities)-1  do
        begin
              if (ArrSourceCapabilities[i] <> '') then
                  SourceCapabilitiesList.Checked[i-1] := true;

        end;

       // Model.Checked := true;
       // Category.Checked := true;
       // Year.Checked := true;
       // Price.Checked := true;
       // ProductReview.Checked := true;
       // SellerContact.Checked := true;

    end;
end;

procedure TForm1.CheckCarForSaleClick(Sender: TObject);
begin
// ������� ������� � Car, ���� ������ ������ �� ��������.
if ((CheckCarForSale.Checked = false) AND (CheckUsedCar.Checked = false) AND (CheckNewCar.Checked = false))
then begin
    if (CheckCar.Checked = true) then CheckCar.Checked := false;
end;
// �������� Car, ���� ��� ������ ���������
if ((CheckCarForSale.Checked = true) AND (CheckUsedCar.Checked = true) AND (CheckNewCar.Checked = true))
then begin
    if (CheckCar.Checked = false) then CheckCar.Checked := true;
end;
end;

procedure TForm1.CheckUsedCarClick(Sender: TObject);
begin
// ������� ������� � Car, ���� ������ ������ �� ��������.
if ((CheckUsedCar.Checked = false) AND (CheckCarForSale.Checked = false) AND (CheckNewCar.Checked = false))
then begin
    if (CheckCar.Checked = true) then CheckCar.Checked := false;
end;
// �������� Car, ���� ��� ������ ���������
if ((CheckCarForSale.Checked = true) AND (CheckUsedCar.Checked = true) AND (CheckNewCar.Checked = true))
then begin
    if (CheckCar.Checked = false) then CheckCar.Checked := true;
end;
end;

procedure TForm1.CheckNewCarClick(Sender: TObject);
begin
// ������� ������� � Car, ���� ������ ������ �� ��������.
if ((CheckNewCar.Checked = false) AND (CheckUsedCar.Checked = false) AND (CheckCarForSale.Checked = false))
then begin
    if (CheckCar.Checked = true) then CheckCar.Checked := false;
end;
// �������� Car, ���� ��� ������ ��������
if ((CheckCarForSale.Checked = true) AND (CheckUsedCar.Checked = true) AND (CheckNewCar.Checked = true))
then begin
    if (CheckCar.Checked = false) then CheckCar.Checked := true;
end;
end;

procedure TForm1.SetRestrictionsToAnyClick(Sender: TObject);
begin
      // ���������� ���������� �������� ��������� � �������
      count := 0;
      for i:=0 to high(ArrQueryRestrictions) do if ArrQueryRestrictions[i]<>'' then count := count + 1;

      // ����������� � SQL
      for i:=1 to count do
      begin
      (FindComponent('Restriction' + IntToStr(i) + 'min') as TComboBox).Text := 'any';
      (FindComponent('Restriction' + IntToStr(i) + 'max') as TComboBox).Text := 'any';
      end;
end;

procedure TForm1.CreateBucketClick(Sender: TObject);
var
CurrentMemory,srs,j,k,classtest,x,test,SrsCount, d: integer;  // ������ ��������
CurrentSrc: String; // ������� �������� - ��� ��������� ����������� � �����
ComparsionMarkSource: String; // ���� ��������� � ������������ ��������� =, <, >
ComparsionMarkQuery: String;  // ���� ��������� � ������������ ������� =, <, >
DjointOrNot: array [1..100] of integer; // ��������� ������� �� ������� ��������� �������
RestrictOrNot: array [1..100] of integer;  // �������� �� �������� �� ������������
begin

if GeneratedQueryString = '' then  // ������������ ������������ ��� ������ ������� ������, � ����� ��� �����
begin
Application.MessageBox ('Make sure SQL Query generated before', 'Generate SQL before creating bucket', mb_Ok + mb_IconExclamation);
exit;
end;
WorkPageControl.ActivePage := BucketTab;
// �������� �����
      TestMemo2.Lines.Add('---BUCKET TEST---');

      // ��������� ������ - ��������, �����
      // TestMemo2.Lines.Add('---selected classes for bucket---');
      for i:=1 to high(ArrQueryClass) do
      begin
        if (ArrQueryClass[i]<>'') then TestMemo2.Lines.Add(ArrQueryClass[i] + ' class found in Query')
        else break;
      end;

// ��������� ��������� �� ������-��������
      count := 0;
      x := 1;


                          // 0. ��������� ������������� � ����� �������� �������, ������� ��� ������������ � �������
                          classtest := 0;
                          for j:=1 to high(ArrQueryClass) do   // �� ���� ������� � �������
                          begin
                               if (ArrQueryClass[j] <> '') then   // ���� ������� ������� �� ������
                               begin
                                    for k:=1 to high(ArrSourceClass) do  // �� ���� ������� � ��������
                                    begin
                                       if (ArrSourceClass[k] <> '') then
                                       begin
                                          // �� ����, ���� ������ ������ ��� � ��������, �� ���� 0
                                          if (ArrQueryClass[j]=ArrSourceClass[k]) then classtest := classtest + 1;
                                       end
                                       else break;
                                    end;
                               end
                               else break;
                          end;
                          // ����� ������������ ��������! ����� ���� ������� Exit; - ������ ��������� �������.
                          if (classtest = 0) then Application.MessageBox ('Class in your Query was not found in our Sources', 'No such class found', mb_Ok + mb_IconExclamation);
                          TestMemo2.Lines.Add('Test for Class existence: ' + IntToStr(classtest));


    // ��������� ��������� ������� � ������� (ArrQueryClass) � � ���������� SourceN[inclass][i]
    for d:=0 to length(DjointOrNot) do
    begin
           DjointOrNot[d] := 0; // ����� �����! �����!
    end;

    srs := 1;
    Sources[srs].First;
    for srs:=1 to high(Sources) do     // ������� �� ���� ����������
    begin
         if (Sources[srs] <> nil) then   // ���� �������� ���������� � ������� ����������, � �� ������ �������
         begin
              Sources[srs].First;
              //TestMemo2.Lines.Add(IntToStr(srs) + ' �������� �������� (1 ����)');
              while not Sources[srs].Eof do   // �������� ��� �������� ���������
              begin
                   // TestMemo2.Lines.Add(IntToStr(srs) + ' �������� �������� (2 ����)');
                    Sources[srs].CurrentValue.First;
                    while Sources[srs].CurrentKey = 'inclass' do  // ���� � �������� ��������� ������ inclass
                    begin
                       // TestMemo2.Lines.Add(IntToStr(srs) + ' �������� �������� (����-inclass ����)');
                        while not Sources[srs].CurrentValue.Eof do
                        begin

                          // 1. ��������� ��������� ������� � ������� � � ���������� �� ������� ������-���������
                          for j:=1 to high(ArrQueryClass) do   // �� ���� ������� � �������
                          begin
                               if (ArrQueryClass[j] <> '') then   // ���� ������� ������� �� ������
                               begin
                                    TestMemo2.Lines.Add('DjointOrNot[' + ArrQueryClass[j] + '][' + Sources[srs].CurrentValue.CurrentValue.AsString + ']: ' + IntToStr(ArrDisjointClassesMatrix[ArrQueryClass[j]][Sources[srs].CurrentValue.CurrentValue.AsString].AsInteger));

                                    // �������� � �������� � ������� ��������� ��������� �������� ���������
                                    DjointOrNot[srs] := DjointOrNot[srs] + ArrDisjointClassesMatrix[ArrQueryClass[j]][Sources[srs].CurrentValue.CurrentValue.AsString].AsInteger;
                                    //TestMemo2.Lines.Add('DjointOrNot[' + IntToStr(srs) + '] = ' + IntToStr(DjointOrNot[srs]));
                               end
                               else break;

                          end;



                          // 2. ��������� � �������� ��������� �� ���������-������������ (Restrictions)
                          CurrentSrc:= Sources[srs]['name'][0].AsString; // ��� �������� ��������� - ����� �� ������ ��� ����������� ������
                          ArrQueryRestrictionsMatrix.First;

                          // ��� �� ��-��������� ��� ��������� �������� �� ������������, � �����, ���� ��������� �����������, ����� ���������!
                          RestrictOrNot[srs] := 1;

                          while not ArrQueryRestrictionsMatrix.Eof do // ��� ����������� � ������� ������������
                          begin
                                SourceRestrictions.First;
                                while not SourceRestrictions.Eof do
                                begin

                                      if (SourceRestrictions.CurrentKey = CurrentSrc) then
                                      begin
                                            //TestMemo2.Lines.Add('sources worked, current: ' + CurrentSrc);
                                            SourceRestrictions.CurrentValue.First;
                                            while not SourceRestrictions.CurrentValue.Eof do
                                            begin
                                                  if (ArrQueryRestrictionsMatrix.CurrentKey = SourceRestrictions.CurrentValue.CurrentKey) then
                                                  begin
                                                        //TestMemo2.Lines.Add('restrictions worked, current: ' + ArrQueryRestrictionsMatrix.CurrentKey);
                                                        ArrQueryRestrictionsMatrix.CurrentValue.First;
                                                        while not ArrQueryRestrictionsMatrix.CurrentValue.Eof do
                                                        begin
                                                              //TestMemo2.Lines.Add('while ARQM worked, current: ' + ArrQueryRestrictionsMatrix.CurrentValue.CurrentKey);
                                                              SourceRestrictions.CurrentValue.CurrentValue.First;
                                                              while not SourceRestrictions.CurrentValue.CurrentValue.Eof do
                                                              begin
                                                                    ComparsionMarkQuery := ArrQueryRestrictionsMatrix.CurrentValue.CurrentKey;
                                                                    ComparsionMarkSource := SourceRestrictions.CurrentValue.CurrentValue.CurrentKey;
                                                                  // TestMemo2.Lines.Add(ComparsionMarkSource[1] + '= mark in Source, in Query is: ' + IntToStr(srs) + ' ' + ComparsionMarkQuery[1]);
                                                                  //  if (ComparsionMarkSource[1] = ComparsionMarkQuery[1]) then
                                                                   // begin
                                                                          //TestMemo2.Lines.Add('Source restricted by: ' + SourceRestrictions.CurrentValue.CurrentKey);

                                                                          if ((ComparsionMarkQuery = '>') AND (ComparsionMarkSource[1] = '<') AND (ArrQueryRestrictionsMatrix.CurrentValue.CurrentValue.AsInteger >= SourceRestrictions.CurrentValue.CurrentValue.CurrentValue.AsInteger))
                                                                          OR ((ComparsionMarkQuery = '<') AND (ComparsionMarkSource[1] = '>') AND (ArrQueryRestrictionsMatrix.CurrentValue.CurrentValue.AsInteger <= SourceRestrictions.CurrentValue.CurrentValue.CurrentValue.AsInteger))
                                                                          OR ((ComparsionMarkQuery = '>=') AND (ComparsionMarkSource = '<=') AND (ArrQueryRestrictionsMatrix.CurrentValue.CurrentValue.AsInteger > SourceRestrictions.CurrentValue.CurrentValue.CurrentValue.AsInteger))
                                                                          OR ((ComparsionMarkQuery = '<=') AND (ComparsionMarkSource = '>=') AND (ArrQueryRestrictionsMatrix.CurrentValue.CurrentValue.AsInteger < SourceRestrictions.CurrentValue.CurrentValue.CurrentValue.AsInteger)) then
                                                                          begin
                                                                          RestrictOrNot[srs] := 0;
                                                                          TestMemo2.Lines.Add('Restriction "' + ArrQueryRestrictionsMatrix.CurrentKey + ComparsionMarkQuery + IntToStr(ArrQueryRestrictionsMatrix.CurrentValue.CurrentValue.AsInteger) + '" excluded Source #' + IntToStr(srs));
                                                                        //  end
                                                                        //  else begin


                                                                          end;
                                                                 //   end;
                                                                    // PROFIT  ��������� �����, ������� ���������, �������������� ����������

                                                                    SourceRestrictions.CurrentValue.CurrentValue.Next;
                                                              end;
                                                              ArrQueryRestrictionsMatrix.CurrentValue.Next;
                                                        end; // while ARQM.CV.Eof
                                                        
                                                  end; // if ARQM.CK = SR.CV.CK
                                                  SourceRestrictions.CurrentValue.Next;
                                            end; // while SR.CV.Eof
                                      end; // If SR.CK = CurrSRC
                                      SourceRestrictions.Next
                                end; // while SR.Eof
                                ArrQueryRestrictionsMatrix.Next;
                          end; // while ARQM.Eof

                        //  ArrQueryRestrictionsMatrix[ArrQueryRestrictions[i]]['>'+ CanEquals].AsString
                        //  SourceRestrictions[Sources[2].AsString][ArrSourceCapabilities[4]]['>='].AsInteger := 20000;  // = Price;



                     // SourceRestrictions[Sources[2].AsString][ArrSourceCapabilities[4]]['>='].AsInteger := 20000;  // = Price;

                          // 3. ��������� ����������� ���������� ������ ��������� ������� � ��������� �� ���������� ��������� ������������ �������� �����- ArrQueryWhat & SourceCapabilities

                          // ��� �� ������

                     //     ArrQueryClass
                     //     Sources[srs].CurrentValue.CurrentValue.AsString
                     //     ArrDisjointClassesMatrix[ArrSourceClass[j]][ArrSourceClass[k]].AsInteger
                     //     Bucket[]
                     //     DjointOrNot

                     //     TestMemo2.Lines.Add('In Source ' + IntToStr(srs) + ' found class: ' + Sources[srs].CurrentValue.CurrentValue.AsString);

                          // there was list dj-disj

                          Sources[srs].CurrentValue.Next;
                        end;
                        Sources[srs].Next;
                    end;
              Sources[srs].Next;
              end;
              Sources[srs].First;
         end
         else break;
    end;

// ����� ������ �������-����������, �������� �� ���������� �� �����������.
 SrsCount := 0;
 TestMemo2.Lines.Add('### Sources selected by disjoint matrix ###');
 for j:=1 to high(DjointOrNot) do   // �� ���� ������� � �������
 begin
      // ���� ���������� �������, � �� ������ 100 ���!
      if (DjointOrNot[j] > 0) then   // ���� ������� ������� �� ������
      begin
           TestMemo2.Lines.Add('Source #' + IntToStr(j) + ' is joint with selected classes');
           Bucket[j] := DjointOrNot[j] * RestrictOrNot[j];
           SrsCount := SrsCount + 1;
      end;
end;
TestMemo2.Lines.Add('>>> Sources in System: ' + IntToStr(srs-1) + ', djoint by classes: ' + IntToStr(SrsCount));

// ����� ������ ���������� ���������� � ����� �� ������ ��������� ������� � ����������� � ������� ������� �����
 SrsCount := 0;
 TestMemo2.Lines.Add('### Sources selected by user restrictions ###');
 for j:=1 to high(Bucket) do   // �� ���� ������� � �������
 begin
      // ���� ���������� �������, � �� ������ 100 ���!
      if (Bucket[j] > 0) then   // ���� ������� ������� �� ������
      begin
           TestMemo2.Lines.Add('Source #' + IntToStr(j) + ' is in Bucket now');
           SrsCount := SrsCount + 1;
      end;
end;
TestMemo2.Lines.Add('>>> Sources in System: ' + IntToStr(srs-1) + ', in Bucket now: ' + IntToStr(SrsCount));

CurrentMemory := AllocMemSize - StartMemory;
StatusBar1.SimpleText := 'Memory leak after Creating Bucket: ' + IntToStr(CurrentMemory) + ' bytes';
end;

procedure TForm1.ClearLogClick(Sender: TObject);
begin
TestMemo2.Clear;
end;

procedure TForm1.AddNewClassClick(Sender: TObject);
var
i,j :integer;
F : TextFile;
D : TextFile;
tablstr : string;
begin
  najal2raza:=najal2raza-1;
 if NewClassName.Text='' then begin
   Showmessage('������� ��� ������ ������');
   Exit;
 end;

 if najal=0 then begin
   Showmessage('�������� ����� ������ � �������');
   Exit;
 end;
 najal:=1;
 for i:=1 to (ClassesMatrix.ColCount)-2 do begin
    if ClassesMatrix.Cells[(ClassesMatrix.ColCount)-1,i]='' then begin
    Showmessage('������� ��������� �������');
    Exit;
    end;
 end;
 for i:=1 to High(ArrSourceClass) do begin
   if ArrSourceClass[i]='' then begin
     ArrSourceClass[i]:=Trim(NewClassName.Text);
     ClassesMatrix.Cells[ClassesMatrix.ColCount-1,0]:= ArrSourceClass[i];
     ClassesMatrix.Cells[0,ClassesMatrix.RowCount-1]:= ArrSourceClass[i];
     Break;
   end;
 end;

 AssignFile(F,'Classname.txt');
 Reset(F);
 Append(F);
 WriteLn(F,Trim(NewClassName.Text));
 CloseFile(F);

   for i:=1 to (ClassesMatrix.ColCount)-1 do begin
      ClassesMatrix.Cells[i,(ClassesMatrix.ColCount)-1]:=ClassesMatrix.Cells[(ClassesMatrix.ColCount)-1,i];
   end;
    ClassesMatrix.Cells[(ClassesMatrix.ColCount)-1,(ClassesMatrix.ColCount)-1]:='1';

 AssignFile(D,'SaveTabl.txt');
 Rewrite(D);
 tablstr:='';
 for i:= 1 to ClassesMatrix.RowCount-1 do begin
 tablstr:='';
   for j:=1 to ClassesMatrix.ColCount-1 do begin
      tablstr:=tablstr + ClassesMatrix.Cells[j,i];
      ArrDisjointClasses[i-1,j-1] :=StrToInt(ClassesMatrix.Cells[j,i]);
   end;
 WriteLn(D,tablstr);  
 end;
 CloseFile(D);

 Showmessage('����� ����� ������� ��������');


end;

procedure TForm1.AddRowColClick(Sender: TObject);
var
C : TextFile;
begin
 najal:=1;
 najal2raza:=najal2raza+1;
 if najal2raza>1 then Exit;
 ClassesMatrix.RowCount:= ClassesMatrix.RowCount + 1;
 ClassesMatrix.ColCount:= ClassesMatrix.ColCount + 1;

 AssignFile(C,'Colrow.txt');
  Rewrite(C);
  WriteLn (C , IntToStr(ClassesMatrix.RowCount));
  WriteLn (C , IntToStr(ClassesMatrix.ColCount));
 CloseFile(C);

SetLength( ArrDisjointClasses , ClassesMatrix.RowCount-1 , ClassesMatrix.ColCount-1 );



end;

procedure TForm1.connecttodbClick(Sender: TObject);
var cou: integer;
begin
ZConnection1.Connected:=true;
ZQuery1.Active:=true;
 //For cou:=1 to DBGrid1.FieldCount do
  DBGRid1.Fields[1].DisplayWidth:=15;

end;

procedure TForm1.doQueryClick(Sender: TObject);
var timequery: string;
var cou: integer;

begin
 ZQuery1.Active:=False;
 ZQuery1.SQL.Clear;
 timequery:=qlist.Items[qlist.ItemIndex] ;
 ZQuery1.SQL.Add(timequery);
 ZQuery1.Active:=True;
 DBGRid1.Fields[1].DisplayWidth:=15;
 end;





end.
