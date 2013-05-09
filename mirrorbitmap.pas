unit MirrorBitmap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IntfGraphics, Graphics, FPimage, Interfaces, LCLIntf;

type
  TMirrorDirection = (mdVertical, mdHorizontal);

  function MirrorVertical(Bitmap: TBitmap): TBitmap;
  function MirrorHorizontal(Bitmap: TBitmap): TBitmap;
  function mirrorText(inputString: String; pen: TPen; font: TFont; direction: TMirrorDirection;): TBitmap;

implementation

function mirrorVertical(Bitmap: TBitmap): TBitmap;
var
  DestBitmap: TBitmap;
  x,y, DestY: Integer;
begin
  //Create our bitmap
  DestBitmap := TBitmap.create;

  //Set our Pixel Format (specifies what depth the image is, 8, 16, 32, etc.)
  DestBitmap.PixelFormat:= bitmap.PixelFormat;

  //Set the width and height of our destination to match the source
  DestBitmap.Width  := Bitmap.Width;
  DestBitmap.Height := Bitmap.Height;

  //Begin to copy
  x := 0;
  y := 0;
  //Copy each column
  while (x < DestBitmap.width) do
  begin
    //Copy each row
    //Reset Y
    y := 0;
     while (y < DestBitmap.height) do
     begin
        //Copy the pixels themselves
        DestY := DestBitmap.height - (y+1);
        DestBitmap.canvas.Pixels[x, DestY] := Bitmap.canvas.Pixels[x, y];

        y := y+1;
     end;
     x := x+1;
  end;

  Result := DestBitmap;
end;

function mirrorHorizontal(Bitmap: TBitmap): TBitmap;
var
  DestBitmap: TBitmap;
  x,y, DestX: Integer;
begin
  //Create our bitmap
  DestBitmap := TBitmap.create;

  //Set our Pixel Format (specifies what depth the image is, 8, 16, 32, etc.)
  DestBitmap.PixelFormat:= bitmap.PixelFormat;

  //Set the width and height of our destination to match the source
  DestBitmap.Width  := Bitmap.Width;
  DestBitmap.Height := Bitmap.Height;

  //Begin to copy
  x := 0;
  y := 0;
  //Copy each column
  while (x < DestBitmap.width) do
  begin
    //Copy each row
    //Reset Y
    y := 0;
     while (y < DestBitmap.height) do
     begin
        //Copy the pixels themselves
        DestX := DestBitmap.width - (x+1);
        DestBitmap.canvas.Pixels[DestX, y] := Bitmap.canvas.Pixels[x, y];

        y := y+1;
     end;
     x := x+1;
  end;

  Result := DestBitmap;
end;

function mirrorText(inputString: String; pen: TPen; font: TFont; direction: TMirrorDirection; screenDPI: Integer; printDPI: Integer): TBitmap;
var
  lineHeight:   Integer;
  charWidth:    Integer;
  neededWidth:  Integer;
  neededHeight: Integer;
  ratio:        extended;
  newPtSize:    Integer;
begin
  //Create our bitmap
  Result := TBitmap.create;

  //Copy our settings onto it
  Result.canvas.pen.color        := pen.color;
  Result.canvas.font.name        := font.name;
  Result.canvas.font.Orientation := font.Orientation;
  Result.canvas.font.color       := font.color;

  //Determine the needed dimensions
  //We use I here because it usually the tallest character
  lineHeight   := Round(1.2 * Abs(Result.canvas.TextHeight('I')));
  //We use W here because it is usually the widest character
  charWidth    := Round(1.2 * Abs(Result.canvas.TextWidth('W')));
  neededHeight := charWidth * length(inputString);
  neededWidth  := lineHeight;

  //Set the image dimensions
  Result.Width  := neededWidth;
  Result.Height := neededHeight;

  //Output our text
  Result.canvas.TextOut(0, neededHeight, inputString);

  //Mirror out bitmap
  if (direction = mdVertical) then
  begin
    Result := MirrorVertical(Result);
  end
  else
    Result := MirrorHorizontal(Result);

  //Return the mirrored copy
end;

end.

