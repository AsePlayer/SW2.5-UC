package com.brockw.stickwar.campaign.controllers
{
          import com.brockw.stickwar.GameScreen;
          import com.brockw.stickwar.engine.Ai.command.HoldCommand;
          import com.brockw.stickwar.engine.Team.Tech;
          import com.brockw.stickwar.engine.units.Bomber;
          import com.brockw.stickwar.engine.units.Unit;
          
          public class CampaignBomber extends CampaignController
          {
                    
                    private static const MIN_NUM_BOMBERS:int = 2;
                    
                    public static const MAX_NUM_BOMBERS:int = 10;
                    
                    private static const FREQUENCY_SPAWN:int = 45;
                    
                    private static const FREQUENCY_INCREASE:int = 60;
                     
                    
                    private var numToSpawn:int = 0;
                    
                    public function CampaignBomber(gameScreen:GameScreen)
                    {
                              super(gameScreen);
                              this.numToSpawn = MIN_NUM_BOMBERS;
                    }
                    
                    override public function update(gameScreen:GameScreen) : void
                    {
                              var i:int = 0;
                              var u1:Unit = null;
                              if(gameScreen.game.frame % (30 * FREQUENCY_SPAWN) == 0)
                              {
                                        for(i = 0; i < this.numToSpawn; i++)
                                        {
                                                  u1 = Bomber(gameScreen.game.unitFactory.getUnit(Unit.U_BOMBER));
                                                  gameScreen.team.enemyTeam.spawn(u1,gameScreen.game);
                                                  u1.px = gameScreen.team.enemyTeam.statue.x;
                                                  u1.py = gameScreen.game.map.height / 2;
                                                  u1.ai.setCommand(gameScreen.game,new HoldCommand(gameScreen.game));
                                                  gameScreen.team.enemyTeam.population += 1;
                                        }
                              }
                              gameScreen.game.team.enemyTeam.tech.isResearchedMap[Tech.GIANT_GROWTH_I] = true;
                              gameScreen.game.team.enemyTeam.tech.isResearchedMap[Tech.GIANT_GROWTH_II] = true;
                              if(gameScreen.game.frame % (30 * FREQUENCY_INCREASE) == 0)
                              {
                                        ++this.numToSpawn;
                                        if(this.numToSpawn > MAX_NUM_BOMBERS)
                                        {
                                                  this.numToSpawn = MAX_NUM_BOMBERS;
                                        }
                              }
                              gameScreen.game.team.enemyTeam.attack(true);
                    }
          }
}
