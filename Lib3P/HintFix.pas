unit HintFix;

interface

uses Controls, Messages, Types, Windows, Forms;

type
  TMyHintwindow = class(THintWindow)
  private
    FActivating: Boolean;
    FLastActive: Cardinal; 
    procedure CMTextChanged(var Message: TMessage); message CM_TEXTCHANGED;
  public 
    procedure ActivateHint(Rect: TRect; const AHint: String); override;
  end;

implementation

procedure TMyHintwindow.CMTextChanged(var Message: TMessage);
begin
  if not FActivating then
    inherited;
end;

procedure TMyHintwindow.ActivateHint(Rect: TRect; const AHint: string);
type
  TAnimationStyle = (atSlideNeg, atSlidePos, atBlend);
const
  AnimationStyle: array[TAnimationStyle] of Integer = (AW_VER_NEGATIVE,
    AW_VER_POSITIVE, AW_BLEND);
var
  Animate: BOOL;
  Style: TAnimationStyle;
begin
  FActivating := True;
  try
    Caption := AHint;
    Inc(Rect.Bottom, 4);
    UpdateBoundsRect(Rect);
    if Rect.Top + Height > Screen.DesktopHeight then
      Rect.Top := Screen.DesktopHeight - Height;
    if Rect.Left + Width > Screen.DesktopWidth then
      Rect.Left := Screen.DesktopWidth - Width;
    if Rect.Left < Screen.DesktopLeft then Rect.Left := Screen.DesktopLeft;
    if Rect.Bottom < Screen.DesktopTop then Rect.Bottom := Screen.DesktopTop;
    SetWindowPos(Handle, HWND_TOPMOST, Rect.Left, Rect.Top, Width, Height,
      SWP_NOACTIVATE);
    if (GetTickCount - FLastActive > 250) and (Length(AHint) < 100) and
       Assigned(AnimateWindowProc) then
    begin
      SystemParametersInfo(SPI_GETTOOLTIPANIMATION, 0, @Animate, 0);
      if Animate then
      begin
        SystemParametersInfo(SPI_GETTOOLTIPFADE, 0, @Animate, 0);
        if Animate then
          Style := atBlend
        else
          if Mouse.CursorPos.Y > Rect.Top then
            Style := atSlideNeg
          else
            Style := atSlidePos;
        AnimateWindowProc(Handle, 100, AnimationStyle[Style] or AW_SLIDE);
      end;
    end;
    ParentWindow:=0;
{    if Assigned(Screen.Activeform) then
      ParentWindow := Screen.Activeform.Handle
    else
      ParentWindow := Application.Handle;}
    ShowWindow(Handle, SW_SHOWNOACTIVATE);
    Invalidate;
  finally
    FLastActive := GetTickCount;
    FActivating := False;
  end;
end;

initialization 
  Hintwindowclass := TMYHintwindow; 
end.