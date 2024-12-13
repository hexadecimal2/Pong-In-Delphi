unit delphipong_u;

interface

uses
System.SysUtils,
Raylib,
Raymath;

type TBall = class(TObject)
public
x,y : real;
speed_x, speed_y : real;
radius : integer;

procedure draw();
procedure update();
procedure resetball();
end;

type TPaddle = class
  private
    procedure update;
protected
procedure limitmovement();

public
width, height : real;
x, y : real;
speed : integer;

procedure draw();
procedure updateplayer2();
end;

type TCPUPaddle = class(TPaddle)
public

procedure update(ball_y : integer);
end;


procedure main();

// declare global scope variables here (throughout the program)
var
ball : TBall;
player1, player2 : TPaddle;
cpu : TCPUPaddle;

player_score : integer = 0;
cpu_score : integer = 0;

green, dark_green, light_green, yellow : TColor;

choose_mode : boolean;
mode_select : integer;

const
ScreenWidth = 1280;
ScreenHeight = 720;

bounce = 'resources\bounce.mp3';
point = 'resources\point.mp3';
select = 'resources\select.mp3';
choose = 'resources\choose.mp3';
menu = 'resources\menu.mp3';

implementation

procedure main();    // main entry point of our program
 begin

  // initialize basic window stuff such as height, width and a name for our window
  InitWindow(ScreenWidth, ScreenHeight, 'Delphi Pong!');
  InitAudioDevice();
  SetTargetFPS(60);
  SetWindowState(FLAG_VSYNC_HINT);

  // set up / initilalize variables here

  choose_mode := true;
  mode_select := 0;

  ball := TBall.Create;

  ball.radius := 20;
  ball.x := (ScreenWidth / 2);
  ball.y := (ScreenHeight / 2);
  ball.speed_x := 300;
  ball.speed_y := 300;


  player1 := TPaddle.Create;

  player1.width := 25;
  player1.height := 120;
  player1.x := ScreenWidth - player1.width - 10;
  player1.y := ScreenHeight / 2 - player1.height / 2;
  player1.speed := 500;

  player2 := TPaddle.Create;

  player2.height := 120;
  player2.width := 25;
  player2.x := 10;
  player2.y := ScreenHeight / 2 - player2.height/2;
  player2.speed := 500;

  cpu := TCPUPaddle.Create;

  cpu.height := 120;
  cpu.width := 25;
  cpu.x := 10;
  cpu.y := ScreenHeight / 2 - cpu.height/2;
  cpu.speed := 500;

  green := TColor.Create(38,185,154,255);
  dark_green := TColor.Create(20,160,133, 255);
  light_green := TColor.Create(129,204,184, 255);
  yellow := TColor.Create(243,213,91, 255);


  var menusound : TSound := LoadSound(menu);
  var vol : single := 1;

  PlaySound(menusound);

 //main loop event



  while not WindowShouldClose do
  begin


    if choose_mode = false then
    begin

    if IsSoundPlaying(menusound) then
    begin
     SetSoundVolume(menusound, 0.2);
    end;



     if mode_select = 0 then
     begin
     // change variables here

     ball.update;
     player1.update;
     cpu.update(trunc(ball.y));


     if CheckCollisionCircleRec(TVector2.Create(ball.x, ball.y), ball.radius, TRectangle.Create(player1.x, player1.y, player1.width, player1.height)) then
      begin
      if ball.speed_x > 0 then
      begin
      ball.speed_x := (ball.speed_x * -1.1);
      ball.speed_y := (ball.y - player1.y) / (player1.height / 2) * -ball.speed_x;


      PlaySound(LoadSound(bounce));
      end;
      //ball.speed_x := (ball.speed_x * -1.1);

      end;

      if CheckCollisionCircleRec(TVector2.Create(ball.x, ball.y), ball.radius, TRectangle.Create(cpu.x, cpu.y, cpu.width, cpu.height)) then
      begin
      if ball.speed_x < 0 then
      begin
      ball.speed_x := (ball.speed_x * -1.1);
      ball.speed_y := (ball.y - cpu.y) / (cpu.height / 2) * -ball.speed_x;

      PlaySound(LoadSound(bounce));
      end;
     end;
     end
     else
     if mode_select = 1 then
     begin
           // change variables here

     ball.update();
     player1.update();
     player2.updateplayer2();


     if CheckCollisionCircleRec(TVector2.Create(ball.x, ball.y), ball.radius, TRectangle.Create(player1.x, player1.y, player1.width, player1.height)) then
      begin
      if ball.speed_x > 0 then
      begin
      ball.speed_x := (ball.speed_x * -1.1);
      ball.speed_y := (ball.y - player1.y) / (player1.height / 2) * -ball.speed_x;


      PlaySound(LoadSound(bounce));
      end;
      //ball.speed_x := (ball.speed_x * -1.1);

      end;

      if CheckCollisionCircleRec(TVector2.Create(ball.x, ball.y), ball.radius, TRectangle.Create(player2.x, player2.y, player2.width, player2.height)) then
      begin
      if ball.speed_x < 0 then
      begin
      ball.speed_x := (ball.speed_x * -1.1);
      ball.speed_y := (ball.y - player2.y) / (player2.height / 2) * -ball.speed_x;

      PlaySound(LoadSound(bounce));
      end;
     end;
     end;

    end;



   // draw objects here  IN ORDER OF RENDERING / LAYERS

    begin
    BeginDrawing;

    ClearBackground(dark_green);

    DrawRectangle(ScreenWidth div 2, 0, ScreenWidth div 2, ScreenHeight, green);
    DrawCircle(ScreenWidth div 2, ScreenHeight div 2, 150, light_green);
    DrawText(TextFormat('%i', cpu_score), (ScreenWidth div 4 - 20), 20, 80, WHITE);
    DrawText(TextFormat('%i', player_score), (3 * (ScreenWidth div 4) - 20), 20, 80, WHITE);
    DrawLine(ScreenWidth div 2, 0, ScreenWidth div 2, ScreenHeight, WHITE);

    if mode_select = 0 then
    begin

    ball.draw;
    player1.draw;
    cpu.draw;

    end
    else if mode_select = 1 then
         
    begin
    ball.draw;
    player1.draw;
    player2.draw;
    end;

    if choose_mode = true then
    begin
    var menutext : PAnsiChar := 'Choose a mode';
    var one_player : PAnsiChar := 'VS CPU';
    var two_player : PAnsiChar := 'VS Human';


    DrawText(menutext,(GetScreenWidth div 2) - (MeasureText(menutext, 60) div 2)  , GetScreenHeight div 2 - 180 , 60,  WHITE);
    DrawText(one_player,(GetScreenWidth div 2) - (MeasureText(one_player, 60) div 2)  , GetScreenHeight div 2 - 60 , 60,  WHITE);
    DrawText(two_player,(GetScreenWidth div 2) - (MeasureText(two_player, 60) div 2)  , GetScreenHeight div 2 + 30 , 60,  WHITE);



     if IsKeyPressed(KEY_DOWN) then
     begin
     mode_select := mode_select + 1;
     PlaySound(LoadSound(choose));
     end;
     if IsKeyPressed(KEY_UP) then
     begin
     mode_select := mode_select - 1;
     PlaySound(LoadSound(choose));
     end;

     if mode_select > 1 then
     begin
     mode_select := 0;
     end;

     if mode_select < 0 then
     begin
     mode_select := 1;
     end;

     case mode_select of
     0 : DrawCircle((GetScreenWidth div 2) - 200, GetScreenHeight div 2 - 35, 15, yellow);
     1 : DrawCircle((GetScreenWidth div 2) - 200, GetScreenHeight div 2 + 60, 15, yellow);
     end;

     if (IsKeyPressed(KEY_SPACE)) and (choose_mode = true) and (mode_select = 0) then
     begin
       choose_mode := false;
       PlaySound(LoadSound(select));
     end
     else if (IsKeyPressed(KEY_SPACE)) and (choose_mode = true) and (mode_select = 1) then
     begin
       choose_mode := false;
       PlaySound(LoadSound(select));
     end;




    end;



    EndDrawing;
    end;

    end;

   //Unload / Unreferance / Destroy stuff here!
   UnloadSound(LoadSound(bounce));
   UnloadSound(LoadSound(point));
   UnloadSound(LoadSound(choose));
   UnloadSound(LoadSound(select));

   ball.Free;
   player1.Free;
   player2.Free;
   cpu.Free;

   CloseAudioDevice();
   CloseWindow();



  end;

 { TBall }

procedure TBall.draw;
begin
DrawCircle(trunc(x), trunc(y), radius, yellow);
end;

procedure TBall.resetball;
const
speed_choices : array[1..2] of integer = (-300,300);
begin

x := GetScreenWidth()/2;
y := GetScreenHeight()/2;

speed_x := speed_choices[GetRandomValue(1,2)];
speed_y := speed_choices[GetRandomValue(1,2)];
end;

procedure TBall.update;
begin

 x := x + speed_x * GetFrameTime();
 y := y + speed_y * GetFrameTime();

 if (y + radius >= GetScreenHeight) or (y - radius <= 0) then
 begin
   speed_y := speed_y * -1;
 end;

  if (x + radius >= GetScreenWidth) then
 begin
  PlaySound(LoadSound(point));
  inc(cpu_score);
  resetball();
 end;

 if (x - radius <= 0) then
 begin
  PlaySound(LoadSound(point));
  inc(player_score);
  resetball();
 end;

 end;

{ TPaddle }

procedure TPaddle.draw;
begin
 DrawRectangleRounded(TRectangle.Create(x, y, width, height), 0.8, 0, WHITE);  // rounded paddles
 //DrawRectangle(trunc(x), trunc(y), trunc(width), trunc(height), WHITE);   //normal square paddles
end;

procedure TPaddle.limitmovement;
begin
 if y + height >= ScreenHeight then
 begin
   y := GetScreenHeight - height;
 end;

 if y <= 0 then
 begin
 y := 0;
 end;
end;


procedure TPaddle.update;
begin
  if IsKeyDown(KEY_UP) then
 begin
   y := y - speed * GetFrameTime();       // base update movement function
 end;

  if IsKeyDown(KEY_DOWN) then
 begin
   y := y + speed * GetFrameTime();
 end;

 limitmovement();
end;


procedure TPaddle.updateplayer2;
begin
  if IsKeyDown(KEY_W) then
 begin
   y := y - speed * GetFrameTime();
 end;

  if IsKeyDown(KEY_S) then
 begin
   y := y + speed * GetFrameTime();
 end;

 limitmovement();
end;

{ TCPUPaddle }

procedure TCPUPaddle.update(ball_y : integer);
begin
   if ((y + height/ 2) > (ball.y)) then
   begin
     y := y - speed * GetFrameTime();
   end;

    if ((y + height/ 2) <= (ball.y)) then
   begin
     y := y + speed * GetFrameTime();
   end;

   limitmovement();

end;

end.
