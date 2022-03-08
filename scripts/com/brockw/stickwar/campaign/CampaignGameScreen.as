package com.brockw.stickwar.campaign
{
          import com.brockw.simulationSync.EndOfTurnMove;
          import com.brockw.simulationSync.Move;
          import com.brockw.simulationSync.SimulationSyncronizer;
          import com.brockw.stickwar.BaseMain;
          import com.brockw.stickwar.GameScreen;
          import com.brockw.stickwar.campaign.controllers.CampaignController;
          import com.brockw.stickwar.engine.StickWar;
          import com.brockw.stickwar.engine.Team.Team;
          import com.brockw.stickwar.engine.Team.Tech;
          import com.brockw.stickwar.engine.UserInterface;
          import com.brockw.stickwar.engine.multiplayer.PostGameScreen;
          import com.brockw.stickwar.engine.multiplayer.moves.EndOfGameMove;
          import com.brockw.stickwar.engine.units.ChaosTower;
          import com.brockw.stickwar.engine.units.Unit;
          import com.brockw.stickwar.engine.units.Wall;
          import com.brockw.stickwar.singleplayer.EnemyChaosTeamAi;
          import com.brockw.stickwar.singleplayer.EnemyGoodTeamAi;
          import com.brockw.stickwar.singleplayer.EnemyTeamAi;
          import com.brockw.stickwar.stickwar2;
          import com.smartfoxserver.v2.requests.ExtensionRequest;
          import flash.events.Event;
          import flash.events.TimerEvent;
          
          public class CampaignGameScreen extends GameScreen
          {
                     
                    
                    private var enemyTeamAi:EnemyTeamAi;
                    
                    private var controller:CampaignController;
                    
                    public var doAiUpdates:Boolean;
                    
                    public function CampaignGameScreen(main:BaseMain)
                    {
                              super(main);
                    }
                    
                    override public function enter() : void
                    {
                              var _loc3_:int = 0;
                              var _loc4_:int = 0;
                              var _loc9_:CampaignUpgrade = null;
                              var _loc10_:Wall = null;
                              var _loc11_:ChaosTower = null;
                              if(main is stickwar2 && main.tracker != null)
                              {
                                        main.tracker.trackEvent(main.campaign.getLevelDescription(),"start");
                              }
                              var _loc1_:Level = main.campaign.getCurrentLevel();
                              var _loc2_:Class = _loc1_.controller;
                              if(_loc2_ != null)
                              {
                                        this.controller = new _loc2_(this);
                              }
                              else
                              {
                                        this.controller = null;
                              }
                              if(!main.stickWar)
                              {
                                        main.stickWar = new StickWar(main,this);
                              }
                              game = main.stickWar;
                              simulation = new SimulationSyncronizer(game,main,this.endTurn,this.endGame);
                              simulation.init(0);
                              this.addChild(game);
                              game.initGame(main,this,_loc1_.mapName);
                              userInterface = new UserInterface(main,this);
                              addChild(userInterface);
                              _loc3_ = 0;
                              _loc4_ = 1;
                              var _loc5_:Number = _loc1_.normalModifier;
                              if(main.campaign.difficultyLevel == Campaign.D_HARD)
                              {
                                        _loc5_ = _loc1_.hardModifier;
                              }
                              else if(main.campaign.difficultyLevel == Campaign.D_INSANE)
                              {
                                        _loc5_ = _loc1_.insaneModifier;
                              }
                              var _loc6_:Number = 1;
                              if(main.campaign.difficultyLevel == 1)
                              {
                                        _loc6_ = _loc1_.normalHealthScale;
                              }
                              var _loc7_:Number = 1;
                              if(main.campaign.difficultyLevel == Campaign.D_NORMAL)
                              {
                                        _loc7_ = _loc1_.normalDamageModifier;
                              }
                              if(_loc1_.player.unitsAvailable[Unit.U_NINJA])
                              {
                                        _loc9_ = CampaignUpgrade(main.campaign.upgradeMap["Cloak_BASIC"]);
                                        _loc9_.upgraded = true;
                                        main.campaign.techAllowed[Tech.CLOAK] = 1;
                              }
                              game.initTeams(Team.getIdFromRaceName(_loc1_.player.race),Team.getIdFromRaceName(_loc1_.oponent.race),_loc1_.player.statueHealth,_loc1_.oponent.statueHealth,main.campaign.techAllowed,null,1,_loc1_.insaneModifier,1,_loc6_,1,_loc7_);
                              team = game.teamA;
                              game.team = team;
                              game.teamA.id = _loc3_;
                              game.teamB.id = _loc4_;
                              game.teamA.unitsAvailable = _loc1_.player.unitsAvailable;
                              game.teamB.unitsAvailable = _loc1_.oponent.unitsAvailable;
                              game.teamA.name = _loc3_;
                              game.teamB.name = _loc4_;
                              this.team.enemyTeam.isEnemy = true;
                              this.team.enemyTeam.isAi = true;
                              team.realName = "Player";
                              team.enemyTeam.realName = "Computer";
                              game.teamA.statueType = _loc1_.player.statue;
                              game.teamB.statueType = _loc1_.oponent.statue;
                              game.teamA.gold = _loc1_.player.gold;
                              game.teamA.mana = _loc1_.player.mana;
                              game.teamB.gold = _loc1_.oponent.gold;
                              game.teamB.mana = _loc1_.oponent.mana;
                              if(main.campaign.difficultyLevel == Campaign.D_NORMAL)
                              {
                                        game.teamA.gold += 200;
                                        game.teamA.mana += 200;
                              }
                              var _loc8_:Array = _loc1_.player.startingUnits.slice(0,_loc1_.player.startingUnits.length);
                              if(main.campaign.getCurrentLevel().hasInsaneWall && main.campaign.difficultyLevel == Campaign.D_INSANE)
                              {
                                        if(game.teamB.type == Team.T_GOOD)
                                        {
                                                  _loc10_ = team.enemyTeam.addWall(team.enemyTeam.homeX - 900);
                                                  _loc10_.setConstructionAmount(1);
                                        }
                                        else
                                        {
                                                  _loc11_ = ChaosTower(game.unitFactory.getUnit(int(Unit.U_CHAOS_TOWER)));
                                                  team.enemyTeam.spawn(_loc11_,game);
                                                  _loc11_.scaleX *= team.enemyTeam.direction * -1;
                                                  _loc11_.px = team.enemyTeam.homeX - 900;
                                                  _loc11_.py = game.map.height / 2;
                                                  _loc11_.setConstructionAmount(1);
                                        }
                              }
                              if(main.campaign.currentLevel != 0)
                              {
                                        if(main.campaign.difficultyLevel == Campaign.D_HARD)
                                        {
                                                  _loc8_.push(game.team.getMinerType());
                                        }
                                        else if(main.campaign.difficultyLevel == Campaign.D_NORMAL)
                                        {
                                                  _loc8_.push([game.team.getMinerType()]);
                                                  _loc10_ = team.addWall(team.homeX + 1200);
                                                  _loc10_.setConstructionAmount(1);
                                        }
                              }
                              else
                              {
                                        game.teamB.gold = 0;
                              }
                              game.teamA.spawnUnitGroup(_loc1_.player.startingUnits);
                              game.teamB.spawnUnitGroup(_loc1_.oponent.startingUnits);
                              if(main.campaign.difficultyLevel > Campaign.D_NORMAL || Team.getIdFromRaceName(main.campaign.getCurrentLevel().oponent.race) == Team.T_CHAOS)
                              {
                                        if(_loc1_.oponent.castleArcherLevel >= 1)
                                        {
                                                  game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_1] = 1;
                                        }
                                        if(_loc1_.oponent.castleArcherLevel >= 2)
                                        {
                                                  game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_2] = 1;
                                        }
                                        if(_loc1_.oponent.castleArcherLevel >= 3)
                                        {
                                                  game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_3] = 1;
                                        }
                                        if(_loc1_.oponent.castleArcherLevel >= 4)
                                        {
                                                  game.teamB.tech.isResearchedMap[Tech.CASTLE_ARCHER_4] = 1;
                                        }
                              }
                              if(_loc1_.player.castleArcherLevel >= 1)
                              {
                                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_1] = 1;
                              }
                              if(_loc1_.player.castleArcherLevel >= 2)
                              {
                                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_2] = 1;
                              }
                              if(_loc1_.player.castleArcherLevel >= 3)
                              {
                                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_3] = 1;
                              }
                              if(_loc1_.player.castleArcherLevel >= 4)
                              {
                                        game.teamA.tech.isResearchedMap[Tech.CASTLE_ARCHER_4] = 1;
                              }
                              userInterface.init(game.team);
                              if(team.enemyTeam.type == Team.T_GOOD)
                              {
                                        this.enemyTeamAi = new EnemyGoodTeamAi(team.enemyTeam,main,game);
                              }
                              else
                              {
                                        this.enemyTeamAi = new EnemyChaosTeamAi(team.enemyTeam,main,game);
                              }
                              game.init(0);
                              game.postInit();
                              simulation.hasStarted = true;
                              super.enter();
                              this.doAiUpdates = true;
                              if(game.teamB.type == Team.T_CHAOS)
                              {
                                        game.soundManager.playSoundInBackground("chaosInGame");
                              }
                              if(Team.getIdFromRaceName(this.main.campaign.getCurrentLevel().oponent.race) == Team.T_GOOD)
                              {
                                        game.soundManager.playSoundInBackground("orderInGame");
                              }
                              else
                              {
                                        game.soundManager.playSoundInBackground("chaosInGame");
                              }
                    }
                    
                    override public function update(evt:Event, timeDiff:Number) : void
                    {
                              if(!main.isKongregate && main.isCampaignDebug && userInterface.keyBoardState.isDown(78) && userInterface.keyBoardState.isShift)
                              {
                                        game.teamB.statue.damage(0,100000000,null);
                              }
                              if(this.doAiUpdates)
                              {
                                        this.enemyTeamAi.update(game);
                              }
                              if(this.controller != null)
                              {
                                        this.controller.update(this);
                              }
                              super.update(evt,timeDiff);
                    }
                    
                    override public function leave() : void
                    {
                              this.cleanUp();
                    }
                    
                    override public function endTurn() : void
                    {
                              simulation.endOfTurnMove = new EndOfTurnMove();
                              simulation.endOfTurnMove.expectedNumberOfMoves = this.simulation.movesInTurn;
                              simulation.endOfTurnMove.frameRate = simulation.frameRate;
                              simulation.endOfTurnMove.turnSize = 5;
                              simulation.endOfTurnMove.turn = simulation.turn;
                              simulation.processMove(simulation.endOfTurnMove);
                              simulation.movesInTurn = 0;
                    }
                    
                    override public function endGame() : void
                    {
                              var u:int = 0;
                              gameTimer.removeEventListener(TimerEvent.TIMER,updateGameLoop);
                              gameTimer.stop();
                              var e:EndOfGameMove = new EndOfGameMove();
                              e.winner = game.winner.id;
                              e.turn = simulation.turn;
                              simulation.processMove(e);
                              trace("UPDATE TIME");
                              main.campaign.getCurrentLevel().updateTime(game.frame / 30);
                              if(main is stickwar2 && main.tracker != null)
                              {
                                        if(e.winner == team.id)
                                        {
                                                  main.tracker.trackEvent(main.campaign.getLevelDescription(),"finish","win",game.economyRecords.length);
                                        }
                                        else
                                        {
                                                  main.tracker.trackEvent(main.campaign.getLevelDescription(),"finish","lose",game.economyRecords.length);
                                        }
                              }
                              main.postGameScreen.setWinner(e.winner,team.type,main.campaign.getCurrentLevel().player.raceName,main.campaign.getCurrentLevel().oponent.raceName,team.id);
                              main.postGameScreen.setRecords(game.economyRecords,game.militaryRecords);
                              if(e.winner == team.id)
                              {
                                        main.campaign.campaignPoints += main.campaign.getCurrentLevel().points;
                                        ++main.campaign.currentLevel;
                              }
                              if(!main.campaign.isGameFinished() && e.winner == team.id)
                              {
                                        for each(u in main.campaign.getCurrentLevel().unlocks)
                                        {
                                                  main.postGameScreen.appendUnitUnlocked(u,game);
                                        }
                              }
                              if(e.winner == team.id)
                              {
                                        main.postGameScreen.showNextUnitUnlocked();
                              }
                              main.postGameScreen.setMode(PostGameScreen.M_CAMPAIGN);
                              if(e.winner == team.id)
                              {
                                        main.postGameScreen.setTipText("");
                              }
                              else
                              {
                                        main.postGameScreen.setTipText(main.campaign.getCurrentLevel().tip);
                              }
                              if(main.campaign.justTutorial)
                              {
                                        if(e.winner == team.id)
                                        {
                                                  main.sfs.send(new ExtensionRequest("SetDoneTutorialHandler",null));
                                        }
                                        main.showScreen("lobby");
                              }
                              else
                              {
                                        main.showScreen("postGame",false,true);
                              }
                    }
                    
                    override public function doMove(move:Move, id:int) : void
                    {
                              move.init(id,simulation.frame,simulation.turn);
                              simulation.processMove(move);
                              ++simulation.movesInTurn;
                    }
                    
                    override public function cleanUp() : void
                    {
                              trace("Do the cleanup");
                              super.cleanUp();
                    }
                    
                    override public function maySwitchOnDisconnect() : Boolean
                    {
                              return false;
                    }
          }
}
