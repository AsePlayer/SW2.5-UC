package com.brockw.stickwar.engine.Ai
{
          import com.brockw.stickwar.engine.StickWar;
          import com.brockw.stickwar.engine.units.Wingidon;
          
          public class WingidonAi extends RangedAi
          {
                     
                    
                    public function WingidonAi(s:Wingidon)
                    {
                              super(s);
                              unit = s;
                    }
                    
                    override public function update(game:StickWar) : void
                    {
                              checkNextMove(game);
                              super.update(game);
                    }
          }
}
