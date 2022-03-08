package com.brockw.stickwar.campaign.controllers
{
          import com.brockw.stickwar.GameScreen;
          import com.brockw.stickwar.campaign.InGameMessage;
          import com.brockw.stickwar.engine.Ai.command.StandCommand;
          import com.brockw.stickwar.engine.units.Bomber;
          import com.brockw.stickwar.engine.units.Medusa;
          import com.brockw.stickwar.engine.units.Statue;
          import com.brockw.stickwar.engine.units.Unit;
          
          public class CampaignCutScene2 extends CampaignController
          {
                    
                    private static const S_BEFORE_CUTSCENE:int = -1;
                    
                    private static const S_ENTER_MEDUSA:int = 0;
                    
                    private static const S_MEDUSA_YOU_MUST_ALL_DIE:int = 1;
                    
                    private static const S_SCROLLING_STONE:int = 2;
                    
                    private static const S_DONE:int = 3;
                    
                    private static const S_WAIT_FOR_END:int = 4;
                     
                    
                    private var state:int;
                    
                    private var counter:int = 0;
                    
                    private var message:InGameMessage;
                    
                    private var scrollingStoneX:Number;
                    
                    private var gameScreen:GameScreen;
                    
                    private var medusa:Unit;
                    
                    private var spawnNumber:int;
                    
                    public function CampaignCutScene2(gameScreen:GameScreen)
                    {
                              super(gameScreen);
                              this.gameScreen = gameScreen;
                              this.state = S_BEFORE_CUTSCENE;
                              this.counter = 0;
                              this.medusa = null;
                              this.spawnNumber = 0;
                    }
                    
                    override public function update(param1:GameScreen) : void
                    {
                              var _loc2_:Unit = null;
                              var _loc3_:StandCommand = null;
                              var _loc4_:Number = NaN;
                              var _loc5_:Array = null;
                              var _loc6_:int = 0;
                              var _loc7_:int = 0;
                              if(this.message)
                              {
                                        this.message.update();
                              }
                              if(this.state != S_BEFORE_CUTSCENE)
                              {
                                        param1.team.enemyTeam.statue.health = 750;
                                        param1.team.enemyTeam.gold = 0;
                                        param1.team.enemyTeam.mana = 200;
                                        param1.userInterface.hud.hud.fastForward.visible = false;
                                        param1.isFastForward = false;
                              }
                              else
                              {
                                        param1.userInterface.hud.hud.fastForward.visible = true;
                              }
                              if(this.state == S_BEFORE_CUTSCENE)
                              {
                                        if(param1.team.enemyTeam.statue.health < 750)
                                        {
                                                  param1.game.targetScreenX = param1.game.team.enemyTeam.statue.x - 325;
                                                  param1.game.screenX = param1.game.team.enemyTeam.statue.x - 325;
                                                  param1.userInterface.isSlowCamera = true;
                                                  _loc2_ = Medusa(param1.game.unitFactory.getUnit(Unit.U_MEDUSA));
                                                  this.medusa = _loc2_;
                                                  param1.team.enemyTeam.spawn(_loc2_,param1.game);
                                                  Medusa(_loc2_).enableSuperMedusa();
                                                  _loc2_.pz = 0;
                                                  _loc2_.y = param1.game.map.height / 2;
                                                  _loc2_.px = param1.team.enemyTeam.homeX - 200;
                                                  _loc2_.x = _loc2_.px;
                                                  _loc3_ = new StandCommand(param1.game);
                                                  _loc2_.ai.setCommand(param1.game,_loc3_);
                                                  this.state = S_ENTER_MEDUSA;
                                                  this.counter = 0;
                                        }
                              }
                              else if(this.state == S_ENTER_MEDUSA)
                              {
                                        _loc3_ = new StandCommand(param1.game);
                                        this.medusa.ai.setCommand(param1.game,_loc3_);
                                        param1.game.fogOfWar.isFogOn = false;
                                        param1.game.targetScreenX = param1.game.team.enemyTeam.statue.x - 325;
                                        param1.game.screenX = param1.game.team.enemyTeam.statue.x - 325;
                                        if(this.counter++ > 20)
                                        {
                                                  this.state = S_MEDUSA_YOU_MUST_ALL_DIE;
                                                  this.counter = 0;
                                                  param1.game.soundManager.playSoundFullVolume("youMustAllDie");
                                        }
                              }
                              else if(this.state == S_MEDUSA_YOU_MUST_ALL_DIE)
                              {
                                        param1.game.targetScreenX = param1.game.team.enemyTeam.statue.x - 325;
                                        param1.game.screenX = param1.game.team.enemyTeam.statue.x - 325;
                                        if(this.counter == 75)
                                        {
                                                  Medusa(this.medusa).stone(null);
                                        }
                                        if(this.counter++ > 100)
                                        {
                                                  this.state = S_SCROLLING_STONE;
                                                  this.scrollingStoneX = param1.game.team.enemyTeam.statue.x - 325;
                                        }
                              }
                              else if(this.state == S_SCROLLING_STONE)
                              {
                                        param1.game.targetScreenX = this.scrollingStoneX;
                                        param1.game.screenX = this.scrollingStoneX;
                                        if(param1.game.targetScreenX < param1.game.team.statue.px - 300)
                                        {
                                                  param1.game.targetScreenX = param1.game.team.statue.px - 300;
                                        }
                                        this.scrollingStoneX -= 20;
                                        _loc4_ = this.scrollingStoneX + param1.game.map.screenWidth / 2;
                                        param1.game.spatialHash.mapInArea(_loc4_ - 100,0,_loc4_ + 100,param1.game.map.height,this.freezeUnit);
                                        if(_loc4_ < param1.team.homeX)
                                        {
                                                  this.state = S_DONE;
                                                  _loc5_ = [];
                                                  _loc5_.push(Unit.U_MINER);
                                                  _loc5_.push(Unit.U_MINER);
                                                  _loc5_.push(Unit.U_SPEARTON);
                                                  _loc5_.push(Unit.U_SPEARTON);
                                                  _loc5_.push(Unit.U_SPEARTON);
                                                  _loc5_.push(Unit.U_SPEARTON);
                                                  _loc5_.push(Unit.U_MAGIKILL);
                                                  _loc5_.push(Unit.U_MONK);
                                                  _loc5_.push(Unit.U_ENSLAVED_GIANT);
                                                  param1.team.spawnUnitGroup(_loc5_);
                                                  param1.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                                                  param1.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                                                  param1.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                                                  param1.game.soundManager.playSoundFullVolumeRandom("Rage",3);
                                        }
                              }
                              if(this.state == S_DONE)
                              {
                                        if(!this.medusa.isAlive())
                                        {
                                                  this.state = S_WAIT_FOR_END;
                                                  this.counter = 0;
                                        }
                                        else
                                        {
                                                  param1.game.team.enemyTeam.attack(true);
                                                  if(param1.game.frame % (30 * 10) == 0)
                                                  {
                                                            _loc6_ = Math.min(this.spawnNumber / 2,4);
                                                            for(_loc7_ = 0; _loc7_ < _loc6_; _loc7_++)
                                                            {
                                                                      _loc2_ = Bomber(param1.game.unitFactory.getUnit(Unit.U_BOMBER));
                                                                      param1.team.enemyTeam.spawn(_loc2_,param1.game);
                                                                      _loc2_.px = this.medusa.px + 100;
                                                                      _loc2_.py = param1.game.map.height / (_loc6_ * 2) + _loc7_ / _loc6_ * param1.game.map.height;
                                                                      _loc2_.ai.setCommand(param1.game,new StandCommand(param1.game));
                                                                      param1.team.enemyTeam.population += 1;
                                                                      param1.game.projectileManager.initTowerSpawn(this.medusa.px + 100,_loc2_.py,param1.game.team.enemyTeam,0.6);
                                                            }
                                                            ++this.spawnNumber;
                                                  }
                                        }
                              }
                              else if(this.state == S_WAIT_FOR_END)
                              {
                                        if(this.counter++ == 30 * 4)
                                        {
                                                  param1.team.enemyTeam.statue.health = 0;
                                        }
                              }
                              super.update(param1);
                    }
                    
                    private function freezeUnit(u:Unit) : void
                    {
                              if(u.team == this.gameScreen.team && !(u is Statue))
                              {
                                        u.stoneAttack(10000);
                              }
                    }
          }
}
