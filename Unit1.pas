unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView,

  Unit2;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    Panel1: TPanel;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
begin
  GStore.Dispatch(neRefresh);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  GStore.Subscribe(
    procedure (State: INewsList)
    var News: TNews;
        NewItem: TListViewItem;
    begin
      ListView1.Items.Clear;
      for News in State do
      begin
        NewItem := ListView1.Items.Add;
        NewItem.Text := News.Title;
        NewItem.Detail := News.Text;
        NewItem.Bitmap.LoadFromFile(News.BitmapFile);
      end;
    end);
  GStore.Dispatch(neInit);
end;

end.
