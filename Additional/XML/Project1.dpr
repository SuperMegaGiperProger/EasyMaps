program Project1;

{$APPTYPE CONSOLE}

uses ComObj, MSXML;

var
  xml: IXMLDOMDocument;
  node: IXMLDomNode;
  nodes_row, nodes_se: IXMLDomNodeList;
  i, j: Integer;
  url: string;
begin
  // put url or file name
  url := 'http://softez.pp.ua/gg.xml';

  xml := CreateOleObject('Microsoft.XMLDOM') as IXMLDOMDocument;
  xml.async := False;
  xml.load(url); // or use loadXML to load XML document using a supplied string
  //if xml.parseError.errorCode <> 0 then
    //raise Exception.Create('XML Load error:' + xml.parseError.reason);

  //Memo1.Clear;
  nodes_row := xml.selectNodes('/doc/data/row');
  for i := 0 to nodes_row.length - 1 do
  begin
    node := nodes_row.item[i];
    writeln('phrase=' + node.selectSingleNode('phrase').text);
    nodes_se := node.selectNodes('search_engines/search_engine/se_url');
    for j := 0 to nodes_se.length - 1 do
    begin
      node := nodes_se.item[j];
      writeln('url=' + node.text);
    end;
    writeln('--------------');
  end;
end.
