using Godot;
using System;

public class SandSim : Node2D
{
    [Export] int brushSize = 2;
    const int BedRockID = 0;
    const int SandID = 1;
    const int WaterID = 2;
    const int LavaID = 3;

    int curInHand = 0;

    TileMap tileSet;




    public override void _Ready()
    {
        tileSet = GetTree().CurrentScene.GetNode("SandSim/World") as TileMap;
        loopTileSet();
    }

 

        public void loopTileSet() {
        var cells = tileSet.GetUsedCellsById(1) + tileSet.GetUsedCellsById(2) +  tileSet.GetUsedCellsById(3);
        cells.Shuffle();

        foreach (Vector2 cell in cells) {
            var cellindex = tileSet.GetCell((int)cell.x, (int)cell.y);

            var up = getCellType((int)cell.x, (int)cell.y - 1);
            var down = getCellType((int)cell.x, (int)cell.y + 1);
            var left = getCellType((int)cell.x -1 , (int)cell.y);
            var right = getCellType((int)cell.x + 1, (int)cell.y);
            var downLeft = getCellType((int)cell.x -1, (int)cell.y + 1);
            var downRight = getCellType((int)cell.x + 1, (int)cell.y + 1);

            switch (cellindex) {
                case SandID:
                    

                    if ((right == -1 && downRight == -1) && (downLeft == -1 && left == -1)) {
                        Random rand = new Random();
                        if (rand.Next() % 20 < 10) {
                            left = 0;
                            right = -1;
                        }
                    }

                    if (down == WaterID) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, WaterID);
                        tileSet.SetCell((int)cell.x, (int)cell.y + 1, SandID);
                    }

                    if (down == LavaID) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, LavaID);
                        tileSet.SetCell((int)cell.x, (int)cell.y + 1, SandID);
                    }

                    if (down == -1) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x, (int)cell.y + 1, SandID);
                    }
                    else if (left == -1 && downLeft == -1) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x - 1, (int)cell.y + 1, SandID);
                    }
                    else if (right == -1 && downRight == -1) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x + 1, (int)cell.y + 1, SandID);
                    }

                    break;
                
                case WaterID:
                    if (right == -1 && left == -1) {
                        Random rand = new Random();
                        if (rand.Next() % 20 < 10) {
                            left = 0;
                            right = -1;
                        }
                    }

                    if (down == -1) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x, (int)cell.y + 1, WaterID);
                    }
                    else if (left == -1) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x - 1, (int)cell.y, WaterID);
                    }
                    else if (right == -1) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x + 1, (int)cell.y, WaterID);
                    }

                    break;
                
                case LavaID:
                    if (right == -1 && left == -1) {
                        Random rand = new Random();
                        if (rand.Next() % 20 < 10) {
                            left = 0;
                            right = -1;
                        }
                    }

                    if (down == WaterID) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x, (int)cell.y + 1, BedRockID);
                    }
                    if (up == WaterID) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x, (int)cell.y - 1, BedRockID);
                    }
                    if (left == WaterID) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x - 1, (int)cell.y, BedRockID);
                    }

                    if (right == WaterID) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x + 1, (int)cell.y, BedRockID);
                    }

                    if (down == -1) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x, (int)cell.y + 1, LavaID);
                    }
                    else if (left == -1) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x - 1, (int)cell.y, LavaID);
                    }
                    else if (right == -1) {
                        tileSet.SetCell((int)cell.x, (int)cell.y, -1);
                        tileSet.SetCell((int)cell.x + 1, (int)cell.y, LavaID);
                    }
                    break;
            }
        }
    }

    public override void _PhysicsProcess(float delta)
    {
        loopTileSet();
    }

    public int getCellType(int x, int y) {
        return tileSet.GetCell(x,y);
    }

    public bool checkIfCellIsEmpty(int x, int y) {
        if (tileSet.GetCell(x,y) == -1) {
            return true;
        }
        return false;
    }


    public override void _Input(InputEvent @event)
    {
        if (Input.IsActionJustPressed("esc")) {
            GetTree().Quit();
        }
        if (Input.IsActionJustPressed("r")) {
            GetTree().ReloadCurrentScene();
        }

        if (Input.IsActionJustPressed("1")) {
            curInHand = 0;
        }
        if (Input.IsActionJustPressed("2")) {
            curInHand = 1;
        }
        if (Input.IsActionJustPressed("3")) {
            curInHand = 2;
        }
        if (Input.IsActionJustPressed("4")) {
            curInHand = 3;
        }

        if (Input.IsActionPressed("leftclick")) {
            for (int x = 0; x < brushSize; x++) {
                for (int y = 0; y < brushSize; y++) {
                    tileSet.SetCell((int)GetGlobalMousePosition().x - x, (int)GetGlobalMousePosition().y - y, curInHand);
                    tileSet.SetCell((int)GetGlobalMousePosition().x + x, (int)GetGlobalMousePosition().y - y, curInHand);
                    tileSet.SetCell((int)GetGlobalMousePosition().x - x, (int)GetGlobalMousePosition().y + y, curInHand);
                    tileSet.SetCell((int)GetGlobalMousePosition().x + x, (int)GetGlobalMousePosition().y + y, curInHand);
                }
                
            }
        }

        if (Input.IsActionPressed("rightClick")) {
            for (int x = 0; x < brushSize; x++) {
                for (int y = 0; y < brushSize; y++) {
                    tileSet.SetCell((int)GetGlobalMousePosition().x - x, (int)GetGlobalMousePosition().y - y, -1);
                    tileSet.SetCell((int)GetGlobalMousePosition().x + x, (int)GetGlobalMousePosition().y - y, -1);
                    tileSet.SetCell((int)GetGlobalMousePosition().x - x, (int)GetGlobalMousePosition().y + y, -1);
                    tileSet.SetCell((int)GetGlobalMousePosition().x + x, (int)GetGlobalMousePosition().y + y, -1);
                }
                
            }
        }
    }






}
