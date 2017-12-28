unit Unit2;

interface

uses Redux,
     Immutable,

     FMX.Graphics,

     System.SysUtils,
     System.Classes;

type
  TNewsEvent = (neRefresh, neInit);

  TNews = class(TInterfacedObject, IInterface)
    private
      FTitle: string;
      FText: string;
      FBitmapFile: string;
    public
      constructor Create(ATitle: string;AText: string; ABitmapFile: string);
      property Title: string read FTitle;
      property Text: string read FText;
      property BitmapFile: string read FBitmapFile;
  end;

  INewsList = IImmutableList<TNews>;
  TNewsList = TImmutableList<TNews>;

var GStore: IStore<INewsList,TNewsEvent>;

function InitializeEverything(): boolean;

implementation

constructor TNews.Create(ATitle: string; AText: string; ABitmapFile: string);
begin
  FTitle := ATitle;
  FText := AText;
  FBitmapFile := ABitmapFile;
end;

function InitializeEverything(): boolean;
var LReducer : TReducer<INewsList, TNewsEvent>;
    LInitialState: INewsList;
    LNews: TNews;
    LStrList: TStringList;
begin
 LReducer :=
  function (State: INewsList; Action: TNewsEvent): INewsList
  var LStringList: TStringList;
  begin
    if Action = neRefresh then
      begin
      LStringList := TStringList.Create;
      LStringList.LoadFromFile('newsdata\news2.txt');
      Result := State.Insert(0,TNews.Create(LStringList[0],LStringList[1],'newsdata\news2.jpg'));
      FreeAndNil(LStringList);
      end;
    if Action = neInit then
      Result := State;
  end;

  LStrList := TStringList.Create;
  LStrList.LoadFromFile('newsdata\news1.txt');

  LNews := TNews.Create(LStrList[0],LStrList[1],'newsdata\news1.jpg');
  LInitialState := TNewsList.Create;
  LInitialState := LInitialState.Insert(0,LNews);

  GStore := TStore<INewsList, TNewsEvent>.Create(LReducer,LInitialState);

  FreeAndNil(LStrList);
end;

initialization

InitializeEverything();

end.
