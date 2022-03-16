package com.brockw.stickwar.campaign.controllers
{
          import com.brockw.stickwar.GameScreen;
          import com.brockw.stickwar.campaign.Campaign;
          import com.brockw.stickwar.campaign.CampaignGameScreen;
          import com.brockw.stickwar.campaign.InGameMessage;
          import com.brockw.stickwar.engine.Ai.MinerAi;
          import com.brockw.stickwar.engine.Ai.command.StandCommand;
          import com.brockw.stickwar.engine.Ai.command.UnitCommand;
          import com.brockw.stickwar.engine.Hill;
          import com.brockw.stickwar.engine.StickWar;
          import com.brockw.stickwar.engine.Team.Team;
          import com.brockw.stickwar.engine.Team.Tech;
          import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
          import com.brockw.stickwar.engine.units.Miner;
          import com.brockw.stickwar.engine.units.Spearton;
          import com.brockw.stickwar.engine.units.Swordwrath;
          import com.brockw.stickwar.engine.units.Unit;
          import flash.events.Event;
          import flash.events.MouseEvent;
          
          public class CampaignTutorial extends CampaignController
          {
                    
                    private static const S_SET_UP:int = -1;
                    
                    private static const S_BOX_UNITS:int = 0;
                    
                    private static const S_MOVE_UNITS:int = 1;
                    
                    private static const S_MOVE_SCREEN:int = 2;
                    
                    private static const S_ATTACK_UNITS:int = 3;
                    
                    private static const S_MOVE_TO_BASE:int = 4;
                    
                    private static const S_SELECT_MINER:int = 5;
                    
                    private static const S_START_MINING:int = 6;
                    
                    private static const S_SELECT_SECOND_MINER:int = 7;
                    
                    private static const S_PRAY:int = 8;
                    
                    private static const S_BUILD_UNIT:int = 9;
                    
                    private static const S_SHOW_ENEMY:int = 10;
                    
                    private static const S_SPEARTON_ATTACKING:int = 11;
                    
                    private static const S_GARRISON:int = 12;
                    
                    private static const S_CLICK_ON_ARCHERY_RANGE:int = 13;
                    
                    private static const S_UPGRADE_CASTLE_ARCHER:int = 14;
                    
                    private static const S_SEND_IN_SPEARTON:int = 15;
                    
                    private static const S_HIT_DEFEND:int = 16;
                    
                    private static const S_KILL_SPEARTON:int = 17;
                    
                    private static const S_GOOD_LUCK:int = 19;
                    
                    private static const S_GOOD_LUCK_2:int = 21;
                    
                    private static const S_ALL_DONE:int = 20;
                    
                    private static const S_TALK_ABOUT_BUILDINGS:int = 22;
                    
                    private static const S_SELECT_MINER_2:int = 23;
                    
                    private static const S_PRAY_INFO:int = 23;
                    
                    private static const S_GOLD_INFO:int = 24;
                    
                    private static const S_PRESS_ATTACK_WAIT:int = 25;
                    
                    private static const S_PRESS_ATTACK:int = 26;
                    
                    private static const S_LAG_WAIT:int = 27;
                    
                    private static const S_LAG:int = 28;
                     
                    
                    private var state:int;
                    
                    private var s1:Swordwrath;
                    
                    private var s2:Swordwrath;
                    
                    private var o1:Swordwrath;
                    
                    private var m1:Miner;
                    
                    private var m2:Miner;
                    
                    private var spearton1:Spearton;
                    
                    var popBefore:int;
                    
                    private var counter:int;
                    
                    private var message:InGameMessage;
                    
                    private var miniMessage:InGameMessage;
                    
                    private var arrow:tutorialArrow;
                    
                    private var spawnSpeartonCounter:int;
                    
                    private var skipTutorialButton:skipTutorial;
                    
                    private var _gameScreen:GameScreen;
                    
                    private var hasShownhillTip:Boolean;
                    
                    private var frameShownHillTip:int;
                    
                    private var hasShownBuildSwordwrath:Boolean;
                    
                    private var hasSpawnedSpearton:Boolean;
                    
                    public function CampaignTutorial(gameScreen:GameScreen)
                    {
                              super(gameScreen);
                              this.hasShownBuildSwordwrath = false;
                              this._gameScreen = gameScreen;
                              this.state = S_SET_UP;
                              this.spawnSpeartonCounter = -1;
                              this.skipTutorialButton = new skipTutorial();
                              this.frameShownHillTip = 0;
                              this.hasShownhillTip = false;
                              this.skipTutorialButton.addEventListener(MouseEvent.CLICK,this.skipTutorialClick,false,0,true);
                              this.miniMessage = null;
                              this.message = null;
                              this.hasSpawnedSpearton = false;
                    }
                    
                    private function skipTutorialClick(e:Event) : void
                    {
                              this.state = S_ALL_DONE;
                              var game:StickWar = this._gameScreen.game;
                              game.team.unitsAvailable[Unit.U_SWORDWRATH] = 1;
                              game.team.unitsAvailable[Unit.U_MINER] = 1;
                              game.team.spawnUnitGroup([Unit.U_MINER,Unit.U_MINER,Unit.U_SWORDWRATH]);
                              if(this._gameScreen.game.main.campaign.difficultyLevel == Campaign.D_NORMAL)
                              {
                                        game.team.enemyTeam.spawnUnitGroup([Unit.U_MINER,Unit.U_MINER,Unit.U_MINER]);
                              }
                              else
                              {
                                        game.team.enemyTeam.spawnUnitGroup([Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_MINER,Unit.U_SPEARTON]);
                              }
                              game.team.defend(true);
                              this.skipTutorialButton.removeEventListener(MouseEvent.CLICK,this.skipTutorialClick);
                              this.message.visible = false;
                              if(this._gameScreen.contains(this.skipTutorialButton))
                              {
                                        this._gameScreen.removeChild(this.skipTutorialButton);
                              }
                              if(this._gameScreen.contains(this.arrow))
                              {
                                        this._gameScreen.removeChild(this.arrow);
                              }
                              this._gameScreen.team.gold = 500;
                              this._gameScreen.team.enemyTeam.gold = 150;
                              this._gameScreen.userInterface.isSlowCamera = false;
                              CampaignGameScreen(this._gameScreen).doAiUpdates = true;
                              this._gameScreen.userInterface.isGlobalsEnabled = true;
                              this._gameScreen.team.tech.isResearchedMap[Tech.CASTLE_ARCHER_1] = 1;
                    }
                    
                    override public function update(param1:GameScreen) : void
                    {
                              var _loc2_:Hill = null;
                              var _loc3_:StickWar = null;
                              var _loc4_:Swordwrath = null;
                              var _loc5_:Swordwrath = null;
                              var _loc6_:Unit = null;
                              var _loc7_:UnitMove = null;
                              var _loc8_:Unit = null;
                              var _loc9_:UnitMove = null;
                              var _loc10_:Spearton = null;
                              var _loc11_:Boolean = false;
                              var _loc12_:Boolean = false;
                              super.update(param1);
                              if(param1.game.showGameOverAnimation)
                              {
                                        return;
                              }
                              if(param1.game.map.hills.length != 0)
                              {
                                        _loc2_ = param1.game.map.hills.pop();
                                        _loc2_.parent.removeChild(_loc2_);
                              }
                              if(this.message)
                              {
                                        this.message.update();
                              }
                              if(this.miniMessage)
                              {
                                        this.miniMessage.update();
                              }
                              if(this.state == S_ALL_DONE || this.state > S_LAG)
                              {
                                        param1.game.team.enemyTeam.attack(true);
                              }
                              if(this.state == S_ALL_DONE)
                              {
                                        if(param1.team.enemyTeam.attackingForcePopulation * 2 > param1.team.attackingForcePopulation)
                                        {
                                                  param1.team.enemyTeam.mana = 0;
                                        }
                                        param1.userInterface.hud.hud.fastForward.visible = true;
                              }
                              else
                              {
                                        param1.isFastForward = false;
                                        param1.userInterface.hud.hud.fastForward.visible = false;
                              }
                              if(this.arrow != null)
                              {
                                        if(this.arrow.currentFrame == this.arrow.totalFrames)
                                        {
                                                  this.arrow.gotoAndPlay(1);
                                        }
                                        else
                                        {
                                                  this.arrow.nextFrame();
                                        }
                              }
                              param1.userInterface.isSlowCamera = false;
                              if(this.state == S_SET_UP)
                              {
                                        CampaignGameScreen(param1).doAiUpdates = false;
                                        param1.userInterface.isGlobalsEnabled = false;
                                        param1.team.gold = 0;
                                        param1.team.mana = 0;
                                        param1.team.enemyTeam.gold = 0;
                                        _loc3_ = param1.game;
                                        _loc4_ = Swordwrath(_loc3_.unitFactory.getUnit(Unit.U_SWORDWRATH));
                                        _loc5_ = Swordwrath(_loc3_.unitFactory.getUnit(Unit.U_SWORDWRATH));
                                        param1.team.spawn(_loc4_,_loc3_);
                                        param1.team.spawn(_loc5_,_loc3_);
                                        _loc4_.px = param1.team.homeX + 2000 * param1.team.direction;
                                        _loc5_.px = param1.team.homeX + 2000 * param1.team.direction;
                                        _loc4_.py = _loc3_.map.height / 3;
                                        _loc5_.py = _loc3_.map.height / 3 * 2;
                                        _loc4_.ai.setCommand(_loc3_,new StandCommand(_loc3_));
                                        _loc5_.ai.setCommand(_loc3_,new StandCommand(_loc3_));
                                        ++param1.team.population;
                                        ++param1.team.population;
                                        delete _loc3_.team.unitsAvailable[Unit.U_SWORDWRATH];
                                        delete _loc3_.team.unitsAvailable[Unit.U_MINER];
                                        this.s1 = _loc4_;
                                        this.s2 = _loc5_;
                                        this.message = new InGameMessage("",param1.game);
                                        this.message.x = _loc3_.stage.stageWidth / 2;
                                        this.message.y = _loc3_.stage.stageHeight / 4 - 75;
                                        this.message.scaleX *= 1.3;
                                        this.message.scaleY *= 1.3;
                                        param1.addChild(this.message);
                                        this.arrow = new tutorialArrow();
                                        param1.addChild(this.arrow);
                                        this.m1 = Miner(_loc3_.unitFactory.getUnit(Unit.U_MINER));
                                        param1.team.spawn(this.m1,_loc3_);
                                        this.m1.px = param1.team.homeX + 400;
                                        this.m1.py = _loc3_.map.height / 2;
                                        this.m1.ai.setCommand(_loc3_,new StandCommand(_loc3_));
                                        param1.team.population += 2;
                              }
                              else if(this.state == S_BOX_UNITS)
                              {
                                        param1.game.screenX = 2200;
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = 2200;
                                        this.arrow.x = this.s1.x + param1.game.battlefield.x;
                                        this.arrow.y = this.s1.y - this.s1.pheight * 0.8 + param1.game.battlefield.y;
                                        this.message.setMessage("Left click and drag a box over units to select them.","Step #1",0,"voiceTutorial1",true);
                                        if(!param1.contains(this.skipTutorialButton) && (param1.main.campaign.difficultyLevel != Campaign.D_NORMAL || param1.main.campaign.getCurrentLevel().retries > 0))
                                        {
                                                  param1.addChild(this.skipTutorialButton);
                                                  this.skipTutorialButton.x = param1.game.map.screenWidth / 2 + 17;
                                                  this.skipTutorialButton.y = this.message.y + this.message.height - 140;
                                        }
                              }
                              else if(this.state == S_MOVE_UNITS)
                              {
                                        if(param1.contains(this.skipTutorialButton))
                                        {
                                                  param1.removeChild(this.skipTutorialButton);
                                        }
                                        this.message.setMessage("Press TAB to user control a selected unit. Move that unit with WASD or the arrow keys.","Step #2",0,"voiceTutorial2");
                                        param1.game.screenX = 2200;
                                        param1.game.targetScreenX = 2200;
                                        this.arrow.visible = true;
                                        this.arrow.x = 2350 + param1.game.battlefield.x;
                                        this.arrow.y = 100 + param1.game.battlefield.y;
                              }
                              else if(this.state == S_MOVE_SCREEN)
                              {
                                        this.message.setMessage("Press R while in user control to unlock the camera.","Step #3",0,"voiceTutorial3");
                                        this.arrow.visible = true;
                                        if(param1.game.targetScreenX > 2900)
                                        {
                                                  param1.game.targetScreenX = 2900;
                                        }
                                        if(param1.game.targetScreenX < 1800)
                                        {
                                                  param1.game.targetScreenX = 1800;
                                        }
                                        if(param1.game.targetScreenX > 2850)
                                        {
                                                  this.arrow.visible = false;
                                        }
                                        if(this.s1.selected == false)
                                        {
                                                  param1.userInterface.selectedUnits.add(this.s1);
                                                  param1.userInterface.selectedUnits.add(this.s2);
                                                  this.s1.selected = true;
                                                  this.s2.selected = true;
                                        }
                                        this.arrow.x = param1.game.stage.stageWidth - 50;
                                        this.arrow.y = param1.game.stage.stageHeight / 4;
                                        this.arrow.rotation = -90;
                              }
                              else if(this.state == S_ATTACK_UNITS)
                              {
                                        if(this.s1.selected == false)
                                        {
                                                  param1.userInterface.selectedUnits.add(this.s1);
                                                  param1.userInterface.selectedUnits.add(this.s2);
                                                  this.s1.selected = true;
                                                  this.s2.selected = true;
                                        }
                                        for each(_loc6_ in param1.team.units)
                                        {
                                                  _loc6_.health = _loc6_.maxHealth;
                                        }
                                        this.message.setMessage("Press R once more to re-lock the camera. Press SPACE to attack a nearby unit with user control.","Step #4",0,"",true);
                                        this.arrow.visible = true;
                                        this.arrow.x = this.o1.x + param1.game.battlefield.x;
                                        this.arrow.y = this.o1.y - this.o1.pheight * 0.8 + param1.game.battlefield.y;
                                        this.arrow.rotation = 0;
                              }
                              else if(this.state == S_MOVE_TO_BASE)
                              {
                                        if(this.s1.selected == true)
                                        {
                                                  param1.userInterface.selectedUnits.clear();
                                                  this.s1.selected = false;
                                                  this.s2.selected = false;
                                        }
                                        this.message.setMessage("Click down here on the mini map to quickly navigate back to your castle.","Step #5",0,"voiceTutorial5",true);
                                        this.arrow.visible = true;
                                        this.arrow.x = param1.game.stage.stageWidth / 2 - 90;
                                        this.arrow.y = param1.game.stage.stageHeight - 115;
                                        _loc7_ = new UnitMove();
                                        _loc7_.owner = param1.game.team.id;
                                        _loc7_.moveType = UnitCommand.HOLD;
                                        _loc7_.arg0 = param1.game.team.homeX + 1000;
                                        _loc7_.arg1 = param1.game.map.height / 2;
                                        _loc7_.units.push(this.s1.id);
                                        _loc7_.units.push(this.s2.id);
                                        _loc7_.execute(param1.game);
                              }
                              else if(this.state == S_SELECT_MINER)
                              {
                                        if(this.s1.selected == true)
                                        {
                                                  param1.userInterface.selectedUnits.clear();
                                                  this.s1.selected = false;
                                                  this.s2.selected = false;
                                        }
                                        this.message.setMessage("Click on this miner.","Step #6",0,"voiceTutorial6");
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = param1.team.homeX;
                                        this.arrow.visible = true;
                                        this.arrow.x = this.m1.x + param1.game.battlefield.x;
                                        this.arrow.y = this.m1.y - this.m1.pheight * 0.8 + param1.game.battlefield.y;
                                        _loc7_ = new UnitMove();
                                        _loc7_.owner = param1.game.team.id;
                                        _loc7_.moveType = UnitCommand.MOVE;
                                        _loc7_.arg0 = param1.game.team.homeX + 1000;
                                        _loc7_.arg1 = param1.game.map.height / 2;
                                        _loc7_.units.push(this.s1.id);
                                        _loc7_.units.push(this.s2.id);
                                        _loc7_.execute(param1.game);
                              }
                              else if(this.state == S_PRAY)
                              {
                                        if(this.s1.selected == true)
                                        {
                                                  param1.userInterface.selectedUnits.clear();
                                                  this.s1.selected = false;
                                                  this.s2.selected = false;
                                        }
                                        this.message.setMessage("Right click the statue to begin praying.","Step #7",0,"voiceTutorial8");
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = param1.team.homeX;
                                        this.arrow.visible = true;
                                        this.arrow.x = param1.game.team.statue.x + param1.game.battlefield.x;
                                        this.arrow.y = param1.game.team.statue.y - param1.game.team.statue.height / 2 + param1.game.battlefield.y;
                                        param1.userInterface.selectedUnits.add(this.m1);
                                        this.m1.selected = true;
                              }
                              else if(this.state == S_PRAY_INFO)
                              {
                                        if(this.s1.selected == true)
                                        {
                                                  param1.userInterface.selectedUnits.clear();
                                                  this.s1.selected = false;
                                                  this.s2.selected = false;
                                        }
                                        this.arrow.visible = false;
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = param1.team.homeX;
                                        this.message.setMessage("Praying gathers mana, which is used to build more advanced units, research technologies and use abilities.","",0,"voiceTutorial7");
                              }
                              else if(this.state == S_START_MINING)
                              {
                                        if(this.s1.selected == true)
                                        {
                                                  param1.userInterface.selectedUnits.clear();
                                                  this.s1.selected = false;
                                                  this.s2.selected = false;
                                        }
                                        this.arrow.visible = true;
                                        this.message.setMessage("Right click on a gold mine to gather gold.","Step #8",0,"voiceTutorial9",true);
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = param1.team.homeX;
                                        this.arrow.x = param1.game.map.gold[3].x + param1.game.battlefield.x;
                                        this.arrow.y = param1.game.map.gold[3].y - 60 * 0.8 + param1.game.battlefield.y;
                                        param1.userInterface.selectedUnits.add(this.m1);
                                        this.m1.selected = true;
                              }
                              else if(this.state == S_GOLD_INFO)
                              {
                                        if(this.s1.selected == true)
                                        {
                                                  param1.userInterface.selectedUnits.clear();
                                                  this.s1.selected = false;
                                                  this.s2.selected = false;
                                        }
                                        this.message.setMessage("Your gold, mana and population are shown here.","",75,"voiceTutorial10");
                                        this.arrow.x = 675;
                                        this.arrow.y = 40;
                                        this.arrow.visible = true;
                              }
                              else if(this.state == S_BUILD_UNIT)
                              {
                                        if(this.s1.selected == true)
                                        {
                                                  param1.userInterface.selectedUnits.clear();
                                                  this.s1.selected = false;
                                                  this.s2.selected = false;
                                        }
                                        this.arrow.visible = true;
                                        if(param1.team.buttonInfoMap[Unit.U_SWORDWRATH][3] != 0)
                                        {
                                                  this.message.setMessage("The Swordwrath is a basic infantry unit. Once finished training, he will appear from the castle gates.","",0,"voiceTutorial12");
                                                  this.arrow.visible = false;
                                        }
                                        else if(!this.hasShownBuildSwordwrath)
                                        {
                                                  this.message.setMessage("Click the icon below to build a Swordwrath unit.","Step #9",0,"voiceTutorial11",true);
                                                  this.arrow.x = 95;
                                                  this.hasShownBuildSwordwrath = true;
                                                  this.arrow.y = param1.game.stage.stageHeight - 100;
                                                  this.arrow.visible = true;
                                        }
                              }
                              else if(this.state == S_SHOW_ENEMY)
                              {
                                        if(this.s1.selected == true)
                                        {
                                                  param1.userInterface.selectedUnits.clear();
                                                  this.s1.selected = false;
                                                  this.s2.selected = false;
                                        }
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = this.spearton1.px - param1.game.map.screenWidth / 2;
                                        param1.game.fogOfWar.isFogOn = false;
                                        this.message.setMessage("A Spearton is attacking!","",0,"voiceTutorial13");
                                        this.arrow.visible = false;
                              }
                              else if(this.state == S_SPEARTON_ATTACKING)
                              {
                                        param1.game.fogOfWar.isFogOn = true;
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = param1.team.forwardUnit.px - param1.game.map.screenWidth / 2;
                                        param1.userInterface.isGlobalsEnabled = true;
                                        for each(_loc8_ in param1.team.units)
                                        {
                                                  _loc8_.selected = false;
                                        }
                                        this.message.setMessage("Click here to garrison your units inside the castle.","Step #10",0,"voiceTutorial14",true);
                                        this.arrow.x = param1.game.stage.stageWidth / 2 - 90;
                                        this.arrow.y = param1.game.stage.stageHeight - 75;
                                        this.arrow.visible = true;
                                        if(param1.game.team.currentAttackState == Team.G_ATTACK)
                                        {
                                                  param1.game.team.defend(true);
                                        }
                              }
                              else if(this.state == S_GARRISON)
                              {
                                        this.message.setMessage("Your units will now run to the safety of your castle walls.","",0,"voiceTutorial15");
                                        this.arrow.visible = false;
                                        param1.userInterface.isGlobalsEnabled = false;
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = param1.team.forwardUnit.px - param1.game.map.screenWidth / 2;
                                        for each(_loc8_ in param1.team.units)
                                        {
                                                  _loc8_.selected = false;
                                        }
                              }
                              else if(this.state == S_CLICK_ON_ARCHERY_RANGE)
                              {
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = 0;
                                        this.message.setMessage("Click on the Archery Range building.","Step #11",250,"voiceTutorial16");
                                        param1.team.gold = 400;
                                        this.arrow.x = 532 + param1.game.battlefield.x;
                                        this.arrow.y = param1.game.battlefield.y - 150;
                                        this.arrow.visible = true;
                              }
                              else if(this.state == S_UPGRADE_CASTLE_ARCHER)
                              {
                                        this.message.y = param1.game.stage.stageHeight / 4 - 75;
                                        this.message.setMessage("Click the icon below to build a Castle Archer.","Step #12",0,"voiceTutorial17",true);
                                        param1.game.targetScreenX = 0;
                                        param1.userInterface.selectedUnits.add(Unit(param1.team.buildings["ArcheryBuilding"]));
                                        Unit(param1.team.buildings["ArcheryBuilding"]).selected = true;
                                        this.arrow.x = param1.game.stage.stageWidth - 170;
                                        this.arrow.y = param1.game.stage.stageHeight - 100;
                                        this.arrow.visible = true;
                              }
                              else if(this.state == S_TALK_ABOUT_BUILDINGS)
                              {
                                        this.message.setMessage("Each building contains different technologies and upgrades which must be researched to enable them.","",0,"voiceTutorial18");
                              }
                              else if(this.state == S_SEND_IN_SPEARTON)
                              {
                                        param1.userInterface.isGlobalsEnabled = true;
                                        param1.userInterface.isSlowCamera = true;
                                        param1.game.targetScreenX = this.spearton1.px - param1.game.map.screenWidth / 2;
                                        _loc9_ = new UnitMove();
                                        _loc9_.moveType = UnitCommand.ATTACK_MOVE;
                                        _loc9_.units.push(this.spearton1);
                                        _loc9_.owner = param1.team.id;
                                        _loc9_.arg0 = param1.team.homeX;
                                        _loc9_.arg1 = param1.team.game.map.height / 2;
                                        _loc9_.execute(param1.team.game);
                                        this.message.setMessage("Hit the defend button below to send out your units.","Step #13",0,"voiceTutorial19",true);
                                        this.message.visible = true;
                                        this.arrow.visible = true;
                                        this.arrow.x = param1.game.stage.stageWidth / 2;
                                        this.arrow.y = param1.game.stage.stageHeight - 75;
                                        if(this.spearton1.health < 50)
                                        {
                                                  this.spearton1.health = 50;
                                        }
                              }
                              else if(this.state == S_HIT_DEFEND)
                              {
                                        param1.userInterface.isGlobalsEnabled = false;
                                        this.message.setMessage("Use your forces to defend against the invading Spearton.","Step #14",0,"voiceTutorial20");
                                        this.message.visible = true;
                                        this.arrow.visible = true;
                                        this.arrow.x = this.spearton1.x + param1.game.battlefield.x;
                                        this.arrow.y = this.spearton1.y - this.spearton1.pheight * 0.8 + param1.game.battlefield.y;
                                        _loc9_ = new UnitMove();
                                        _loc9_.moveType = UnitCommand.ATTACK_MOVE;
                                        _loc9_.units.push(this.spearton1);
                                        _loc9_.owner = param1.team.id;
                                        _loc9_.arg0 = param1.team.homeX;
                                        _loc9_.arg1 = param1.team.game.map.height / 2;
                                        _loc9_.execute(param1.team.game);
                              }
                              else if(this.state == S_KILL_SPEARTON)
                              {
                                        this.arrow.x = this.spearton1.x + param1.game.battlefield.x;
                                        this.arrow.y = this.spearton1.y - this.spearton1.pheight * 0.8 + param1.game.battlefield.y;
                                        this.arrow.visible = true;
                              }
                              else if(this.state == S_GOOD_LUCK)
                              {
                                        this.message.setMessage("User controlled units have bonus damage, speed, and regen!","",0,"");
                                        this.arrow.visible = false;
                                        CampaignGameScreen(param1).doAiUpdates = true;
                              }
                              else if(this.state == S_GOOD_LUCK_2)
                              {
                                        this.message.setMessage("Your objective is to destroy the enemy statue before they destroy yours. Good luck.","",0,"voiceTutorial22");
                                        this.arrow.visible = false;
                                        CampaignGameScreen(param1).doAiUpdates = true;
                                        param1.userInterface.isGlobalsEnabled = true;
                                        this.spawnSpeartonCounter = 30 * 60 * 2;
                              }
                              if(this.state < S_CLICK_ON_ARCHERY_RANGE)
                              {
                                        param1.team.enemyTeam.gold = 0;
                              }
                              if(!this.hasSpawnedSpearton && param1.game.team.enemyTeam.statue.health / param1.game.team.enemyTeam.statue.maxHealth < 0.75)
                              {
                                        _loc10_ = Spearton(param1.game.unitFactory.getUnit(Unit.U_SPEARTON));
                                        param1.team.enemyTeam.spawn(_loc10_,param1.game);
                                        param1.team.enemyTeam.population += 3;
                                        _loc10_.x = _loc10_.px = _loc10_.team.homeX;
                                        _loc10_.y = _loc10_.py = param1.game.map.height / 2;
                                        this.hasSpawnedSpearton = true;
                              }
                              if(this.state != S_ALL_DONE)
                              {
                              }
                              if(this.o1 != null)
                              {
                                        this.o1.ai.setCommand(_loc3_,new StandCommand(_loc3_));
                              }
                              if(this.state == S_SET_UP)
                              {
                                        this.state = S_BOX_UNITS;
                              }
                              else if(this.state == S_BOX_UNITS)
                              {
                                        if(this.message.hasFinishedPlayingSound() && this.s1.selected == true && this.s2.selected == true)
                                        {
                                                  this.state = S_MOVE_UNITS;
                                        }
                              }
                              else if(this.state == S_MOVE_UNITS)
                              {
                                        if(this.s1.isUC || this.s2.isUC)
                                        {
                                                  _loc7_ = new UnitMove();
                                                  _loc7_.owner = param1.game.team.id;
                                                  _loc7_.arg0 = 2350 + param1.game.battlefield.x;
                                                  _loc7_.arg1 = 100 + param1.game.battlefield.y;
                                                  if(this.s1.px < 2375 && !this.s1.isUC || this.s2.px < 2375 && !this.s2.isUC)
                                                  {
                                                            _loc7_.moveType = UnitCommand.HOLD;
                                                  }
                                                  else
                                                  {
                                                            _loc7_.moveType = UnitCommand.MOVE;
                                                  }
                                                  if(this.s1.isUC)
                                                  {
                                                            _loc7_.units.push(this.s2.id);
                                                  }
                                                  else if(this.s2.isUC)
                                                  {
                                                            _loc7_.units.push(this.s1.id);
                                                  }
                                                  _loc7_.execute(param1.game);
                                        }
                                        else if(!this.s1.isUC && !this.s2.isUC)
                                        {
                                                  _loc7_ = new UnitMove();
                                                  _loc7_.owner = param1.game.team.id;
                                                  _loc7_.arg0 = 2350 + param1.game.battlefield.x;
                                                  _loc7_.arg1 = 100 + param1.game.battlefield.y;
                                                  _loc7_.moveType = UnitCommand.HOLD;
                                                  _loc7_.units.push(this.s2.id);
                                                  _loc7_.units.push(this.s1.id);
                                                  _loc7_.execute(param1.game);
                                        }
                                        if(this.message.hasFinishedPlayingSound() && (this.s1.isUC && this.s1.px < 2500 && this.s2.px < 2500 || this.s2.isUC && this.s1.px < 2500 && this.s2.px < 2500))
                                        {
                                                  _loc7_ = new UnitMove();
                                                  _loc7_.owner = param1.game.team.id;
                                                  _loc7_.arg0 = 2350 + param1.game.battlefield.x;
                                                  _loc7_.arg1 = 100 + param1.game.battlefield.y;
                                                  _loc7_.moveType = UnitCommand.HOLD;
                                                  _loc7_.units.push(this.s2.id);
                                                  _loc7_.units.push(this.s1.id);
                                                  _loc7_.execute(param1.game);
                                                  this.state = S_MOVE_SCREEN;
                                                  this.o1 = Swordwrath(param1.game.unitFactory.getUnit(Unit.U_SWORDWRATH));
                                                  param1.team.enemyTeam.spawn(this.o1,param1.game);
                                                  this.o1.x = this.o1.px = 3350;
                                                  this.o1.y = this.o1.py = param1.game.map.height / 2;
                                                  ++param1.team.enemyTeam.population;
                                        }
                              }
                              else if(this.state == S_MOVE_SCREEN)
                              {
                                        if(this.message.hasFinishedPlayingSound() && param1.game.screenX > 2800)
                                        {
                                                  this.state = S_ATTACK_UNITS;
                                        }
                              }
                              else if(this.state == S_ATTACK_UNITS)
                              {
                                        if(this.message.hasFinishedPlayingSound() && this.o1.isDead == true)
                                        {
                                                  this.o1 = null;
                                                  this.state = S_MOVE_TO_BASE;
                                        }
                              }
                              else if(this.state == S_MOVE_TO_BASE)
                              {
                                        if(this.message.hasFinishedPlayingSound() && param1.game.screenX < param1.team.homeX + 300)
                                        {
                                                  this.state = S_SELECT_MINER;
                                        }
                              }
                              else if(this.state == S_SELECT_MINER)
                              {
                                        if(this.message.hasFinishedPlayingSound() && this.m1.selected == true)
                                        {
                                                  this.state = S_PRAY;
                                        }
                              }
                              else if(this.state == S_PRAY)
                              {
                                        if(this.message.hasFinishedPlayingSound() && MinerAi(this.m1.ai).targetOre == param1.game.team.statue)
                                        {
                                                  this.state = CampaignTutorial.S_PRAY_INFO;
                                                  this.counter = 0;
                                        }
                              }
                              else if(this.state == S_PRAY_INFO)
                              {
                                        if(this.message.hasFinishedPlayingSound() && param1.game.team.mana > 10)
                                        {
                                                  this.state = CampaignTutorial.S_START_MINING;
                                        }
                              }
                              else if(this.state == S_SELECT_MINER_2)
                              {
                                        if(this.message.hasFinishedPlayingSound() && MinerAi(this.m1.ai).targetOre != null && MinerAi(this.m1.ai).targetOre != param1.game.team.statue)
                                        {
                                                  this.state = CampaignTutorial.S_START_MINING;
                                        }
                              }
                              else if(this.state == S_START_MINING)
                              {
                                        if(this.message.hasFinishedPlayingSound() && MinerAi(this.m1.ai).targetOre != null && MinerAi(this.m1.ai).targetOre != param1.game.team.statue)
                                        {
                                                  this.state = S_GOLD_INFO;
                                                  param1.team.gold = 150;
                                                  this.popBefore = param1.team.units.length;
                                                  param1.team.defend(true);
                                                  param1.team.unitsAvailable[Unit.U_SWORDWRATH] = 1;
                                                  this.counter = 0;
                                                  this.arrow.scaleY *= -1;
                                        }
                              }
                              else if(this.state == S_GOLD_INFO)
                              {
                                        ++this.counter;
                                        if(this.message.hasFinishedPlayingSound() && this.counter > 150)
                                        {
                                                  this.state = S_BUILD_UNIT;
                                                  this.arrow.visible = true;
                                                  this.arrow.scaleY *= -1;
                                        }
                              }
                              else if(this.state == S_BUILD_UNIT)
                              {
                                        if(this.message.hasFinishedPlayingSound() && param1.team.units.length > this.popBefore)
                                        {
                                                  this.arrow.visible = false;
                                                  ++this.counter;
                                                  delete param1.team.unitsAvailable[Unit.U_SWORDWRATH];
                                                  if(this.counter > 150)
                                                  {
                                                            this.arrow.visible = false;
                                                            this.state = S_SHOW_ENEMY;
                                                            param1.userInterface.isGlobalsEnabled = true;
                                                            this.spearton1 = Spearton(param1.game.unitFactory.getUnit(Unit.U_SPEARTON));
                                                            param1.team.enemyTeam.spawn(this.spearton1,param1.game);
                                                            param1.team.enemyTeam.population += 3;
                                                            this.spearton1.x = this.spearton1.px = this.spearton1.team.homeX - 200;
                                                            this.spearton1.y = this.spearton1.py = param1.game.map.height / 2;
                                                  }
                                        }
                              }
                              else if(this.state == S_SHOW_ENEMY)
                              {
                                        if(this.message.hasFinishedPlayingSound() && this.spearton1.px < param1.team.enemyTeam.homeX - 900)
                                        {
                                                  this.state = S_SPEARTON_ATTACKING;
                                        }
                              }
                              else if(this.state == S_SPEARTON_ATTACKING)
                              {
                                        _loc11_ = false;
                                        for each(_loc8_ in param1.team.units)
                                        {
                                                  if(!_loc8_.isGarrisoned)
                                                  {
                                                            _loc11_ = true;
                                                  }
                                        }
                                        if(!_loc11_)
                                        {
                                                  this.state = S_GARRISON;
                                        }
                              }
                              else if(this.state == S_GARRISON)
                              {
                                        if(this.message.hasFinishedPlayingSound() && param1.game.team.forwardUnit.px < param1.team.homeX + 200)
                                        {
                                                  this.state = S_CLICK_ON_ARCHERY_RANGE;
                                        }
                              }
                              else if(this.state == S_CLICK_ON_ARCHERY_RANGE)
                              {
                                        if(this.message.hasFinishedPlayingSound() && Unit(param1.team.buildings["ArcheryBuilding"]).selected)
                                        {
                                                  this.state = S_UPGRADE_CASTLE_ARCHER;
                                        }
                              }
                              else if(this.state == S_UPGRADE_CASTLE_ARCHER)
                              {
                                        if(this.message.hasFinishedPlayingSound() && param1.team.tech.isResearching(Tech.CASTLE_ARCHER_1))
                                        {
                                                  this.state = S_TALK_ABOUT_BUILDINGS;
                                        }
                              }
                              else if(this.state == CampaignTutorial.S_TALK_ABOUT_BUILDINGS)
                              {
                                        if(this.message.hasFinishedPlayingSound() && param1.team.tech.isResearched(Tech.CASTLE_ARCHER_1))
                                        {
                                                  this.spearton1.px = param1.team.homeX + 700;
                                                  this.spearton1.py = param1.game.map.height * 3 / 4;
                                                  this.state = S_SEND_IN_SPEARTON;
                                        }
                              }
                              else if(this.state == S_SEND_IN_SPEARTON)
                              {
                                        _loc12_ = false;
                                        for each(_loc8_ in param1.team.units)
                                        {
                                                  if(_loc8_.isGarrisoned)
                                                  {
                                                            _loc12_ = true;
                                                  }
                                        }
                                        if(!_loc12_)
                                        {
                                                  this.state = S_HIT_DEFEND;
                                        }
                              }
                              else if(this.state == S_HIT_DEFEND)
                              {
                                        if(this.message.hasFinishedPlayingSound() && param1.team.currentAttackState == Team.G_DEFEND)
                                        {
                                                  this.state = S_KILL_SPEARTON;
                                        }
                              }
                              else if(this.state == S_KILL_SPEARTON)
                              {
                                        if(this.message.hasFinishedPlayingSound() && this.spearton1.isDead)
                                        {
                                                  this.state = S_GOOD_LUCK;
                                                  this.popBefore = param1.team.population;
                                                  param1.team.gold = 150;
                                                  param1.team.game.team.unitsAvailable[Unit.U_MINER] = 1;
                                                  _loc3_ = param1.game;
                                                  _loc3_.team.spawnUnitGroup([Unit.U_MINER,Unit.U_MINER]);
                                                  _loc3_.team.enemyTeam.spawnUnitGroup([Unit.U_MINER,Unit.U_MINER,Unit.U_SPEARTON]);
                                                  _loc3_.team.gold = 500;
                                                  _loc3_.team.defend(true);
                                        }
                              }
                              else if(this.state == S_GOOD_LUCK)
                              {
                                        ++this.counter;
                                        param1.team.unitsAvailable[Unit.U_SWORDWRATH] = 1;
                                        if(this.counter > 300)
                                        {
                                                  this.state = S_GOOD_LUCK_2;
                                                  this.counter = 0;
                                        }
                              }
                              else if(this.state == S_GOOD_LUCK_2)
                              {
                                        ++this.counter;
                                        if(this.counter > 300)
                                        {
                                                  this.state = S_PRESS_ATTACK_WAIT;
                                                  this.message.visible = false;
                                                  this.counter = 0;
                                        }
                              }
                              else if(this.state == S_PRESS_ATTACK_WAIT)
                              {
                                        ++this.counter;
                                        this.arrow.visible = false;
                                        if(this.counter > 30 * 30)
                                        {
                                                  this.state = S_PRESS_ATTACK;
                                                  _loc3_ = param1.game;
                                                  this.miniMessage = new InGameMessage("",param1.game);
                                                  this.miniMessage.x = _loc3_.stage.stageWidth / 2;
                                                  this.miniMessage.y = _loc3_.stage.stageHeight / 4 - 75;
                                                  this.miniMessage.scaleX *= 0.8;
                                                  this.miniMessage.scaleY *= 0.8;
                                                  param1.addChild(this.miniMessage);
                                                  this.miniMessage.setMessage("When you\'re ready, click here to Attack the enemy!","",525);
                                                  this.miniMessage.visible = false;
                                                  this.arrow.x = param1.game.stage.stageWidth / 2 + 90;
                                                  this.arrow.y = param1.game.stage.stageHeight - 75;
                                                  this.arrow.visible = false;
                                                  this.counter = 0;
                                        }
                              }
                              else if(this.state == S_PRESS_ATTACK)
                              {
                                        ++this.counter;
                                        if(this.miniMessage.isShowingNewMessage())
                                        {
                                                  this.miniMessage.visible = true;
                                                  if(this.miniMessage.isMessageShowing())
                                                  {
                                                            this.arrow.visible = true;
                                                  }
                                        }
                                        if(this.counter > 30 * 7)
                                        {
                                                  this.state = S_LAG_WAIT;
                                                  this.miniMessage.visible = false;
                                                  this.arrow.visible = false;
                                                  this.counter = 0;
                                        }
                              }
                              else if(this.state == S_LAG_WAIT)
                              {
                                        ++this.counter;
                                        this.miniMessage.visible = false;
                                        this.arrow.visible = false;
                                        if(this.counter > 30 * 5)
                                        {
                                                  this.state = S_LAG;
                                                  this.miniMessage.setMessage("Click here to toggle the graphics quality if the game is running slow for you.","",525);
                                                  this.counter = 0;
                                        }
                              }
                              else if(this.state == S_LAG)
                              {
                                        ++this.counter;
                                        if(this.miniMessage.isShowingNewMessage())
                                        {
                                                  this.miniMessage.visible = true;
                                                  if(this.miniMessage.isMessageShowing())
                                                  {
                                                            this.arrow.visible = true;
                                                            this.arrow.x = param1.game.stage.stageWidth / 2 - 90;
                                                            this.arrow.y = param1.game.stage.stageHeight - 20;
                                                  }
                                        }
                                        if(this.counter > 30 * 7)
                                        {
                                                  this.state = S_ALL_DONE;
                                                  this.miniMessage.visible = false;
                                                  this.arrow.visible = false;
                                        }
                              }
                              if(this.message)
                              {
                                        if(!this.message.isMessageShowing() || this.miniMessage && !this.miniMessage.isMessageShowing())
                                        {
                                                  if(this.arrow)
                                                  {
                                                            this.arrow.visible = false;
                                                  }
                                        }
                              }
                    }
          }
}
