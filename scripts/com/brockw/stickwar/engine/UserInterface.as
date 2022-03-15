package com.brockw.stickwar.engine
{
          import com.brockw.game.KeyboardState;
          import com.brockw.game.MouseState;
          import com.brockw.game.Screen;
          import com.brockw.game.Util;
          import com.brockw.stickwar.BaseMain;
          import com.brockw.stickwar.GameScreen;
          import com.brockw.stickwar.engine.Ai.command.StandCommand;
          import com.brockw.stickwar.engine.Ai.command.UnitCommand;
          import com.brockw.stickwar.engine.Team.Building;
          import com.brockw.stickwar.engine.Team.Chaos.ChaosHud;
          import com.brockw.stickwar.engine.Team.Hud;
          import com.brockw.stickwar.engine.Team.Order.GoodHud;
          import com.brockw.stickwar.engine.Team.Team;
          import com.brockw.stickwar.engine.multiplayer.MultiplayerGameScreen;
          import com.brockw.stickwar.engine.multiplayer.moves.ForfeitMove;
          import com.brockw.stickwar.engine.multiplayer.moves.GlobalMove;
          import com.brockw.stickwar.engine.multiplayer.moves.PauseMove;
          import com.brockw.stickwar.engine.multiplayer.moves.ScreenPositionUpdateMove;
          import com.brockw.stickwar.engine.multiplayer.moves.UnitMove;
          import com.brockw.stickwar.engine.units.Statue;
          import com.brockw.stickwar.engine.units.Unit;
          import com.brockw.stickwar.engine.units.Wall;
          import flash.display.MovieClip;
          import flash.display.SimpleButton;
          import flash.display.Sprite;
          import flash.events.Event;
          import flash.events.MouseEvent;
          import flash.geom.Point;
          import flash.ui.Keyboard;
          import flash.utils.Timer;
          import flash.utils.getTimer;
          
          public class UserInterface extends Screen
          {
                    
                    public static const FRAME_RATE:int = 30;
                     
                    
                    public var keyBoardState:KeyboardState;
                    
                    public var mouseState:MouseState;
                    
                    private var _main:BaseMain;
                    
                    private var _box:Box;
                    
                    private var SCROLL_SPEED:Number = 100;
                    
                    private var SCROLL_GAIN:Number = 20;
                    
                    private var _team:Team;
                    
                    private var _selectedUnits:SelectedUnits;
                    
                    private var _pauseMenu:PauseMenu;
                    
                    private var _hud:Hud;
                    
                    private var _actionInterface:ActionInterface;
                    
                    private var _chat:Chat;
                    
                    private var _isSlowCamera:Boolean;
                    
                    private var timeOfLastUpdate:Number;
                    
                    private var _period:Number = 33.333333333333336;
                    
                    private var _beforeTime:int = 0;
                    
                    private var _afterTime:int = 0;
                    
                    private var _timeDiff:int = 0;
                    
                    private var _sleepTime:int = 0;
                    
                    private var _overSleepTime:int = 0;
                    
                    private var _excess:int = 0;
                    
                    private var gameTimer:Timer;
                    
                    private var spacePressTimer:int;
                    
                    private var replayData:Array;
                    
                    private var _gameScreen:GameScreen;
                    
                    public var lastSentScreenPosition:int;
                    
                    public var isGlobalsEnabled:Boolean = true;
                    
                    private var isUnitCreationEnabled:Boolean = true;
                    
                    private var _helpMessage:HelpMessage;
                    
                    private var _isMusic:Boolean;
                    
                    private var mouseOverFrames:int;
                    
                    private var lastButton:SimpleButton;
                    
                    var UCunit:Unit;
                    
                    var UCmoveX:int;
                    
                    var UCmoveY:int;
                    
                    var goingLeft:Boolean;
                    
                    var goingRight:Boolean;
                    
                    var goingUp:Boolean;
                    
                    public var goingDown:Boolean;
                    
                    var attacking:Boolean;
                    
                    private var arrow:tutorialArrow;
                    
                    var leaveUCTimer:int;
                    
                    var UCCameraTimer:int;
                    
                    var attackTimer:int;
                    
                    var UCcamera:Boolean;
                    
                    var inRange:Unit;
                    
                    public function UserInterface(main:BaseMain, gameScreen:GameScreen)
                    {
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              this._period = 33.333333333333336;
                              ++main.loadingFraction;
                              this.lastButton = null;
                              this.main = main;
                              this.gameScreen = gameScreen;
                              super();
                              ++main.loadingFraction;
                              this.mouseOverFrames = 0;
                    }
                    
                    public function init(team:Team) : void
                    {
                              this.team = team;
                              this.isMusic = this.main.soundManager.isMusic;
                              this.lastSentScreenPosition = 0;
                              this.spacePressTimer = getTimer();
                              this.box = new Box();
                              this.selectedUnits = new SelectedUnits(this.gameScreen);
                              ++this.main.loadingFraction;
                              if(this.gameScreen is MultiplayerGameScreen)
                              {
                                        this.pauseMenu = new MultiplayerPauseMenu(this.gameScreen);
                              }
                              else
                              {
                                        this.pauseMenu = new CampaignPauseMenu(this.gameScreen);
                              }
                              ++this.main.loadingFraction;
                              this.SCROLL_SPEED = this.gameScreen.game.xml.xml.screenScrollSpeed;
                              this.SCROLL_GAIN = this.gameScreen.game.xml.xml.screenScrollGain;
                              this.isSlowCamera = false;
                              if(team.type == Team.T_GOOD)
                              {
                                        this._hud = new GoodHud();
                              }
                              else
                              {
                                        this._hud = new ChaosHud();
                              }
                              this.actionInterface = new ActionInterface(this);
                              ++this.main.loadingFraction;
                              addChild(this._actionInterface);
                              this._actionInterface.mouseEnabled = false;
                              this._actionInterface.mouseChildren = false;
                              addChild(this._hud);
                              this._chat = new Chat(this.gameScreen);
                              ++this.main.loadingFraction;
                              addChild(this._chat);
                              this.gameScreen.addChild(this.pauseMenu);
                              this.helpMessage = new HelpMessage(this.gameScreen.game);
                              ++this.main.loadingFraction;
                              addChild(this.helpMessage);
                              this._chat.mouseEnabled = false;
                              this._chat.mouseChildren = false;
                              this.mouseEnabled = false;
                              this.keyBoardState = new KeyboardState(stage);
                              this.mouseState = new MouseState(stage);
                              this.gameScreen.game.screenX = team.homeX;
                              if(this.gameScreen.game.team == this.gameScreen.game.teamB)
                              {
                                        this.gameScreen.game.screenX -= this.gameScreen.game.map.screenWidth;
                              }
                              this.gameScreen.game.targetScreenX = this.gameScreen.game.screenX;
                              this.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownEvent);
                              this.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpEvent);
                              this.stage.addEventListener(Event.MOUSE_LEAVE,this.mouseUpEvent);
                              this.hud.hud.defendButton.addEventListener(MouseEvent.CLICK,this.defendButton);
                              if(team == this.gameScreen.game.teamA)
                              {
                                        this.hud.hud.garrisonButton.addEventListener(MouseEvent.CLICK,this.garrisonButton);
                                        this.hud.hud.attackButton.addEventListener(MouseEvent.CLICK,this.attackButton);
                                        this.hud.hud.leftMinerButton.addEventListener(MouseEvent.CLICK,this.garrisonMinerButton);
                                        this.hud.hud.rightMinerButton.addEventListener(MouseEvent.CLICK,this.unGarrisonMinerButton);
                              }
                              else
                              {
                                        this.hud.hud.attackButton.addEventListener(MouseEvent.CLICK,this.garrisonButton);
                                        this.hud.hud.garrisonButton.addEventListener(MouseEvent.CLICK,this.attackButton);
                                        this.hud.hud.leftMinerButton.addEventListener(MouseEvent.CLICK,this.unGarrisonMinerButton);
                                        this.hud.hud.rightMinerButton.addEventListener(MouseEvent.CLICK,this.garrisonMinerButton);
                              }
                              this.hud.hud.menuButton.addEventListener(MouseEvent.CLICK,this.openMenu);
                              ++this.main.loadingFraction;
                              this.gameScreen.team.initTeamButtons(this.gameScreen);
                              ++this.main.loadingFraction;
                              if(team.type == Team.T_GOOD)
                              {
                                        this.gameScreen.game.soundManager.playSoundInBackground("orderInGame");
                              }
                              else
                              {
                                        this.gameScreen.game.soundManager.playSoundInBackground("chaosInGame");
                              }
                              this.addChild(this.gameScreen.game.cursorSprite);
                              this.hud.hud.lowButton.addEventListener(MouseEvent.CLICK,this.lowButton);
                              this.hud.hud.medButton.addEventListener(MouseEvent.CLICK,this.medButton);
                              this.hud.hud.highButton.addEventListener(MouseEvent.CLICK,this.highButton);
                              if(this.hud.hud.fastForward)
                              {
                                        if(!(this.gameScreen is MultiplayerGameScreen))
                                        {
                                                  this.hud.hud.fastForward.visible = true;
                                                  this.hud.hud.fastForward.addEventListener(MouseEvent.CLICK,this.clickFastForward,true);
                                                  MovieClip(this.hud.hud.fastForward).buttonMode = true;
                                        }
                                        else
                                        {
                                                  this.hud.hud.fastForward.visible = false;
                                        }
                              }
                    }
                    
                    private function exitButton(evt:Event) : void
                    {
                              trace("hit the quit");
                              trace("QUIT GAME");
                              this.gameScreen.doMove(new ForfeitMove(),this.team.id);
                    }
                    
                    private function pauseButton(evt:Event) : void
                    {
                              trace("PAUSE GAME");
                              this.gameScreen.doMove(new PauseMove(),this.team.id);
                    }
                    
                    private function openMenu(e:Event) : void
                    {
                              this.pauseMenu.showMenu();
                    }
                    
                    private function lowButton(e:Event) : void
                    {
                              this.gameScreen.quality = GameScreen.S_HIGH_QUALITY;
                    }
                    
                    private function medButton(e:Event) : void
                    {
                              this.gameScreen.quality = GameScreen.S_LOW_QUALITY;
                    }
                    
                    private function highButton(e:Event) : void
                    {
                              this.gameScreen.quality = GameScreen.S_MEDIUM_QUALITY;
                    }
                    
                    public function cleanUp() : void
                    {
                              if(this.hud.hud.fastForward)
                              {
                                        if(!(this.gameScreen is MultiplayerGameScreen))
                                        {
                                                  this.hud.hud.fastForward.removeEventListener(MouseEvent.CLICK,this.clickFastForward);
                                        }
                              }
                              this.pauseMenu.cleanUp();
                              this.pauseMenu = null;
                              removeChild(this._hud);
                              this.keyBoardState.cleanUp();
                              this.mouseState.cleanUp();
                              this.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownEvent);
                              this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpEvent);
                              this.stage.removeEventListener(Event.MOUSE_LEAVE,this.mouseUpEvent);
                              if(this.team == this.gameScreen.game.teamA)
                              {
                                        this.hud.hud.garrisonButton.removeEventListener(MouseEvent.CLICK,this.garrisonButton);
                                        this.hud.hud.attackButton.removeEventListener(MouseEvent.CLICK,this.attackButton);
                              }
                              else
                              {
                                        this.hud.hud.attackButton.removeEventListener(MouseEvent.CLICK,this.garrisonButton);
                                        this.hud.hud.garrisonButton.removeEventListener(MouseEvent.CLICK,this.attackButton);
                              }
                              this.hud.hud.defendButton.removeEventListener(MouseEvent.CLICK,this.defendButton);
                              this.hud.hud.menuButton.removeEventListener(MouseEvent.CLICK,this.openMenu);
                              this.hud.hud.lowButton.removeEventListener(MouseEvent.CLICK,this.lowButton);
                              this.hud.hud.medButton.removeEventListener(MouseEvent.CLICK,this.medButton);
                              this.hud.hud.highButton.removeEventListener(MouseEvent.CLICK,this.highButton);
                              this.hud.hud.leftMinerButton.removeEventListener(MouseEvent.CLICK,this.unGarrisonMinerButton);
                              this.hud.hud.rightMinerButton.removeEventListener(MouseEvent.CLICK,this.garrisonMinerButton);
                              this._hud = null;
                              Util.recursiveRemoval(Sprite(this));
                    }
                    
                    private function economyButton(evt:MouseEvent) : void
                    {
                    }
                    
                    private function battlefieldButton(evt:MouseEvent) : void
                    {
                    }
                    
                    public function garrisonMinerButton(evt:MouseEvent) : void
                    {
                              if(!this.isGlobalsEnabled)
                              {
                                        return;
                              }
                              var m:GlobalMove = new GlobalMove();
                              m.globalMoveType = Team.G_GARRISON_MINER;
                              this.gameScreen.doMove(m,this.team.id);
                              if(this.team.type == Team.T_GOOD)
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("manthefortSoundOrder");
                              }
                              else
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("manthefortSoundChaos");
                              }
                    }
                    
                    public function unGarrisonMinerButton(evt:MouseEvent) : void
                    {
                              if(!this.isGlobalsEnabled)
                              {
                                        return;
                              }
                              var m:GlobalMove = new GlobalMove();
                              m.globalMoveType = Team.G_UNGARRISON_MINER;
                              this.gameScreen.doMove(m,this.team.id);
                              if(this.team.type == Team.T_GOOD)
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("defendSoundOrder");
                              }
                              else
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("defendSoundChaos");
                              }
                    }
                    
                    public function garrisonButton(evt:MouseEvent) : void
                    {
                              if(!this.isGlobalsEnabled)
                              {
                                        return;
                              }
                              var m:GlobalMove = new GlobalMove();
                              m.globalMoveType = Team.G_GARRISON;
                              this.gameScreen.doMove(m,this.team.id);
                              if(this.team.type == Team.T_GOOD)
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("manthefortSoundOrder");
                              }
                              else
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("manthefortSoundChaos");
                              }
                    }
                    
                    public function defendButton(evt:MouseEvent) : void
                    {
                              if(!this.isGlobalsEnabled)
                              {
                                        return;
                              }
                              var m:GlobalMove = new GlobalMove();
                              m.globalMoveType = Team.G_DEFEND;
                              this.gameScreen.doMove(m,this.team.id);
                              if(this.team.type == Team.T_GOOD)
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("defendSoundOrder");
                              }
                              else
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("defendSoundChaos");
                              }
                    }
                    
                    public function attackButton(evt:MouseEvent) : void
                    {
                              if(!this.isGlobalsEnabled)
                              {
                                        return;
                              }
                              var m:GlobalMove = new GlobalMove();
                              m.globalMoveType = Team.G_ATTACK;
                              this.gameScreen.doMove(m,this.team.id);
                              if(this.team.type == Team.T_GOOD)
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("attackSoundOrder");
                              }
                              else
                              {
                                        this.gameScreen.game.soundManager.playSoundFullVolume("attackSoundChaos");
                              }
                    }
                    
                    private function tryToSelectABuilding() : void
                    {
                              var i:* = null;
                              var b:Building = null;
                              for(i in this.team.buildings)
                              {
                                        b = Building(this.team.buildings[i]);
                                        if(b.hitAreaMovieClip.hitTestPoint(stage.mouseX,stage.mouseY,true))
                                        {
                                                  if(this.mouseState.clicked)
                                                  {
                                                            this.mouseState.mouseDown = false;
                                                            this.mouseState.oldMouseDown = false;
                                                            this.mouseState.clicked = false;
                                                            b.selected = true;
                                                            this.selectedUnits.add(Unit(b));
                                                            this.mouseState.clicked = false;
                                                            if(b.button.currentFrame != 3)
                                                            {
                                                                      b.button.gotoAndStop(3);
                                                                      Util.animateToNeutral(MovieClip(b.button),-1);
                                                            }
                                                            b.button.gotoAndStop(3);
                                                  }
                                                  else
                                                  {
                                                            if(b.button.currentFrame != 2)
                                                            {
                                                                      b.button.gotoAndStop(2);
                                                                      Util.animateToNeutral(MovieClip(b.button),-1);
                                                            }
                                                            b.button.gotoAndStop(2);
                                                  }
                                        }
                                        else
                                        {
                                                  if(b.button.currentFrame != 1)
                                                  {
                                                            b.button.gotoAndStop(1);
                                                            Util.animateToNeutral(MovieClip(b.button),-1);
                                                  }
                                                  b.button.gotoAndStop(1);
                                        }
                                        Util.animateMovieClip(MovieClip(b.button),0,-1);
                              }
                    }
                    
                    private function clickFastForward(evt:Event) : void
                    {
                              this.gameScreen.isFastForward = !this.gameScreen.isFastForward;
                              this.mouseState.mouseDown = false;
                    }
                    
                    public function update(param1:Event, param2:Number) : void
                    {
                              var _loc21_:int = 0;
                              var _loc5_:Unit = null;
                              var _loc6_:Team = null;
                              var _loc7_:ScreenPositionUpdateMove = null;
                              var _loc8_:int = 0;
                              var _loc9_:Number = NaN;
                              var _loc10_:Number = NaN;
                              var _loc11_:Point = null;
                              var _loc12_:Number = NaN;
                              var _loc13_:Number = NaN;
                              var _loc14_:Wall = null;
                              var _loc15_:Entity = null;
                              var _loc16_:int = 0;
                              var _loc17_:* = null;
                              var _loc18_:int = 0;
                              var _loc19_:int = 0;
                              var _loc20_:UnitMove = null;
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
                              if(this.leaveUCTimer > 0)
                              {
                                        --this.leaveUCTimer;
                              }
                              if(this.attackTimer > 0)
                              {
                                        --this.attackTimer;
                              }
                              if(this.UCCameraTimer > 0)
                              {
                                        --this.UCCameraTimer;
                              }
                              if(this.keyBoardState.isDown(9) || this.UCunit && (this.UCunit.isDead || this.UCunit.health <= 0))
                              {
                                        if(this.leaveUCTimer <= 0)
                                        {
                                                  if(this.UCunit)
                                                  {
                                                            this.UCunit.isUC = false;
                                                            if((this.UCunit.isDead || this.UCunit.health <= 0) && this.keyBoardState.isDown(9))
                                                            {
                                                                      this.UCcamera = true;
                                                                      for each(_loc5_ in this.team.units)
                                                                      {
                                                                                if(!_loc5_.isDead && !_loc5_.health <= 0)
                                                                                {
                                                                                          this.UCunit = _loc5_;
                                                                                          break;
                                                                                }
                                                                      }
                                                                      this.gameScreen.game.soundManager.playSoundFullVolume("TowerCapture");
                                                            }
                                                            else
                                                            {
                                                                      this.UCcamera = false;
                                                                      if(this.selectedUnits.selected[0])
                                                                      {
                                                                                if(!this.selectedUnits.selected[0].isUC)
                                                                                {
                                                                                          this.UCunit.ai.currentCommand = this.selectedUnits.selected[0].ai.currentCommand;
                                                                                }
                                                                                else if(this.selectedUnits.selected[1])
                                                                                {
                                                                                          this.UCunit.ai.currentCommand = this.selectedUnits.selected[1].ai.currentCommand;
                                                                                }
                                                                      }
                                                                      this.UCunit.ai.mayMoveToAttack = true;
                                                                      this.UCunit.ai.mayAttack = true;
                                                                      this.UCunit = null;
                                                                      this.gameScreen.game.soundManager.playSoundFullVolume("Hellfistout3");
                                                            }
                                                            if(this.gameScreen.contains(this.arrow))
                                                            {
                                                                      this.gameScreen.removeChild(this.arrow);
                                                            }
                                                            this.leaveUCTimer = 15;
                                                  }
                                                  else if(this.UCunit == null)
                                                  {
                                                            this.UCunit = this.selectedUnits.selected[0];
                                                            this.UCcamera = true;
                                                            this.arrow = new tutorialArrow();
                                                            this.gameScreen.addChild(this.arrow);
                                                            trace("BRUH");
                                                            this.leaveUCTimer = 30;
                                                            this.gameScreen.game.soundManager.playSoundFullVolume("TowerCapture");
                                                  }
                                        }
                              }
                              if(this.UCunit)
                              {
                                        this.arrow.x = this.UCunit.x + this.gameScreen.game.battlefield.x;
                                        this.arrow.y = this.UCunit.y - this.UCunit.pheight * 0.8 + this.gameScreen.game.battlefield.y;
                                        if(this.UCcamera)
                                        {
                                                  this.gameScreen.game.targetScreenX = this.UCunit.px - this.gameScreen.game.map.screenWidth / 2;
                                        }
                                        if(this.keyBoardState.isDown(82) && this.UCCameraTimer <= 0)
                                        {
                                                  if(this.UCcamera)
                                                  {
                                                            this.UCcamera = false;
                                                  }
                                                  else
                                                  {
                                                            this.UCcamera = true;
                                                  }
                                                  this.UCCameraTimer = 15;
                                        }
                                        this.UCunit.isUC = true;
                                        if(this.keyBoardState.isDown(32))
                                        {
                                                  if(this.UCunit.type == Unit.U_MONK)
                                                  {
                                                            for each(_loc5_ in this.team.poisonedUnits)
                                                            {
                                                                      if(this.UCunit.cureSpell(_loc5_))
                                                                      {
                                                                                _loc5_.cure();
                                                                                break;
                                                                      }
                                                            }
                                                            _loc5_ = null;
                                                            for each(_loc5_ in this.team.units)
                                                            {
                                                                      if(_loc5_.health != _loc5_.maxHealth && Math.abs(this.UCunit.px - _loc5_.px) < 300)
                                                                      {
                                                                                if(this.inRange == null)
                                                                                {
                                                                                          this.inRange = _loc5_;
                                                                                }
                                                                                else if(_loc5_.health < this.inRange.health)
                                                                                {
                                                                                          this.inRange = _loc5_;
                                                                                }
                                                                      }
                                                            }
                                                            if(this.UCunit.healSpell(this.inRange))
                                                            {
                                                                      this.inRange.heal(25,1);
                                                                      this.UCunit.heal(5,2);
                                                            }
                                                            else if(this.UCunit.healSpell(this.UCunit))
                                                            {
                                                                      this.UCunit.heal(30,1);
                                                            }
                                                            _loc21_ = 0;
                                                  }
                                                  else if(Math.abs(this.UCunit.px - this.UCunit.ai.getClosestUnitTarget().px) > 600 && this.UCunit.type == Unit.U_ENSLAVED_GIANT)
                                                  {
                                                            this.UCunit.ai.mayMoveToAttack = false;
                                                            this.attacking = false;
                                                  }
                                                  else if(Math.abs(this.UCunit.px - this.UCunit.ai.getClosestUnitTarget().px) > 750 && (this.UCunit.type == Unit.U_ARCHER || this.UCunit.type == Unit.U_FLYING_CROSSBOWMAN))
                                                  {
                                                            this.UCunit.ai.mayMoveToAttack = false;
                                                            this.attacking = false;
                                                  }
                                                  else if(Math.abs(this.UCunit.px - this.UCunit.ai.getClosestUnitTarget().px) > 400 && !(this.UCunit.type == Unit.U_ARCHER || this.UCunit.type == Unit.U_FLYING_CROSSBOWMAN))
                                                  {
                                                            this.UCunit.ai.mayMoveToAttack = false;
                                                            this.attacking = false;
                                                  }
                                                  else
                                                  {
                                                            this.UCunit.ai.mayMoveToAttack = true;
                                                            this.attacking = true;
                                                  }
                                                  this.UCunit.ai.setCommand(this.gameScreen.game,new StandCommand(this.gameScreen.game));
                                                  this.UCunit.ai.mayAttack = true;
                                        }
                                        if(this.keyBoardState.isDown(39) || this.keyBoardState.isDown(68))
                                        {
                                                  this.goingRight = true;
                                                  this.UCmoveX = 400 * this.UCunit.scale;
                                        }
                                        else
                                        {
                                                  this.goingRight = false;
                                        }
                                        if(this.keyBoardState.isDown(37) || this.keyBoardState.isDown(65))
                                        {
                                                  this.goingLeft = true;
                                                  this.UCmoveX = -400 * this.UCunit.scale;
                                        }
                                        else
                                        {
                                                  this.goingLeft = false;
                                        }
                                        if(this.keyBoardState.isDown(38) || this.keyBoardState.isDown(87))
                                        {
                                                  this.goingUp = true;
                                                  this.UCmoveY = -200 * this.UCunit.scale;
                                        }
                                        else
                                        {
                                                  this.goingUp = false;
                                        }
                                        if(this.keyBoardState.isDown(40) || this.keyBoardState.isDown(83))
                                        {
                                                  this.goingDown = true;
                                                  this.UCmoveY = 200 * this.UCunit.scale;
                                                  if(!this.goingRight && !this.goingLeft)
                                                  {
                                                            this.goingRight = true;
                                                            this.UCmoveX = this.UCmoveY / 10 + 5;
                                                  }
                                        }
                                        else
                                        {
                                                  this.goingDown = false;
                                        }
                                        if(!this.goingLeft && !this.goingRight)
                                        {
                                                  this.UCmoveX = 0;
                                        }
                                        if(!this.goingUp && !this.goingDown)
                                        {
                                                  this.UCmoveY = 0;
                                        }
                                        trace("X: " + this.UCmoveX + ", Y: " + this.UCmoveY);
                                        if(!this.attacking)
                                        {
                                                  if(this.UCmoveX == 0 && this.UCmoveY == 0)
                                                  {
                                                            this.UCunit.ai.setCommand(this.gameScreen.game,new StandCommand(this.gameScreen.game));
                                                            this.UCunit.ai.mayMoveToAttack = false;
                                                            this.UCunit.ai.mayAttack = false;
                                                  }
                                                  else
                                                  {
                                                            _loc20_ = new UnitMove();
                                                            _loc20_.owner = this.gameScreen.game.team.id;
                                                            _loc20_.moveType = UnitCommand.MOVE;
                                                            _loc20_.arg0 = this.UCunit.px + this.UCmoveX;
                                                            _loc20_.arg1 = this.UCunit.py + this.UCmoveY;
                                                            _loc20_.units.push(this.UCunit.id);
                                                            _loc20_.execute(this.gameScreen.game);
                                                  }
                                        }
                                        this.attacking = false;
                              }
                              if(this.UCunit && this.UCunit.isDead)
                              {
                                        this.UCunit.isUC = false;
                                        this.UCcamera = false;
                                        this.UCunit = null;
                                        if(this.gameScreen.contains(this.arrow))
                                        {
                                                  this.gameScreen.removeChild(this.arrow);
                                        }
                              }
                              if(!(this.gameScreen is MultiplayerGameScreen))
                              {
                                        if(this.hud.hud.fastForward)
                                        {
                                                  if(this.gameScreen.isFastForward)
                                                  {
                                                            this.hud.hud.fastForward.gotoAndStop(2);
                                                  }
                                                  else
                                                  {
                                                            this.hud.hud.fastForward.gotoAndStop(1);
                                                  }
                                        }
                              }
                              var _loc3_:int = 23;
                              if(this.hud.hud.attackButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
                              {
                                        if(this.lastButton != this.hud.hud.attackButton && !this.gameScreen.isFastForwardFrame)
                                        {
                                                  this.mouseOverFrames = 0;
                                        }
                                        ++this.mouseOverFrames;
                                        if(this.mouseOverFrames > _loc3_)
                                        {
                                                  if(this.gameScreen.team == this.gameScreen.game.teamB)
                                                  {
                                                            this.gameScreen.game.tipBox.displayTip("Garrison","Command all units to garrison inside the castle.",0,0,0,0,true);
                                                  }
                                                  else
                                                  {
                                                            this.gameScreen.game.tipBox.displayTip("Attack","Command all units to attack the enemy.",0,0,0,0,true);
                                                  }
                                        }
                                        this.lastButton = this.hud.hud.attackButton;
                              }
                              else if(this.hud.hud.defendButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
                              {
                                        if(this.lastButton != this.hud.hud.defendButton && !this.gameScreen.isFastForwardFrame)
                                        {
                                                  this.mouseOverFrames = 0;
                                        }
                                        ++this.mouseOverFrames;
                                        if(this.mouseOverFrames > _loc3_)
                                        {
                                                  this.gameScreen.game.tipBox.displayTip("Defend","Command all units to defend the statue.",0,0,0,0,true);
                                        }
                                        this.lastButton = this.hud.hud.defendButton;
                              }
                              else if(this.hud.hud.garrisonButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
                              {
                                        if(this.lastButton != this.hud.hud.garrisonButton && !this.gameScreen.isFastForwardFrame)
                                        {
                                                  this.mouseOverFrames = 0;
                                        }
                                        ++this.mouseOverFrames;
                                        if(this.mouseOverFrames > _loc3_)
                                        {
                                                  if(this.gameScreen.team == this.gameScreen.game.teamA)
                                                  {
                                                            this.gameScreen.game.tipBox.displayTip("Garrison","Command all units to garrison inside the castle.",0,0,0,0,true);
                                                  }
                                                  else
                                                  {
                                                            this.gameScreen.game.tipBox.displayTip("Attack","Command all units to attack the enemy.",0,0,0,0,true);
                                                  }
                                        }
                                        this.lastButton = this.hud.hud.garrisonButton;
                              }
                              else if(this.hud.hud.rightMinerButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
                              {
                                        if(this.lastButton != this.hud.hud.rightMinerButton && !this.gameScreen.isFastForwardFrame)
                                        {
                                                  this.mouseOverFrames = 0;
                                        }
                                        ++this.mouseOverFrames;
                                        if(this.mouseOverFrames > _loc3_)
                                        {
                                                  if(this.gameScreen.team == this.gameScreen.game.teamB)
                                                  {
                                                            this.gameScreen.game.tipBox.displayTip("Garrison Miners","Command all miners to garrison within the castle.",0,0,0,0,true);
                                                  }
                                                  else
                                                  {
                                                            this.gameScreen.game.tipBox.displayTip("Resume Mining","Command all miners to resume mining.",0,0,0,0,true);
                                                  }
                                        }
                                        this.lastButton = this.hud.hud.rightMinerButton;
                              }
                              else if(this.hud.hud.leftMinerButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
                              {
                                        if(this.lastButton != this.hud.hud.leftMinerButton && !this.gameScreen.isFastForwardFrame)
                                        {
                                                  this.mouseOverFrames = 0;
                                        }
                                        ++this.mouseOverFrames;
                                        if(this.mouseOverFrames > _loc3_)
                                        {
                                                  if(this.gameScreen.team == this.gameScreen.game.teamA)
                                                  {
                                                            this.gameScreen.game.tipBox.displayTip("Garrison Miners","Command all miners to garrison within the castle.",0,0,0,0,true);
                                                  }
                                                  else
                                                  {
                                                            this.gameScreen.game.tipBox.displayTip("Resume Mining","Command all miners to resume mining.",0,0,0,0,true);
                                                  }
                                        }
                                        this.lastButton = this.hud.hud.leftMinerButton;
                              }
                              else if(this.hud.hud.lowButton.hitTestPoint(stage.mouseX,stage.mouseY,true))
                              {
                                        if(this.lastButton != this.hud.hud.lowButton && !this.gameScreen.isFastForwardFrame)
                                        {
                                                  this.mouseOverFrames = 0;
                                        }
                                        ++this.mouseOverFrames;
                                        if(this.mouseOverFrames > _loc3_)
                                        {
                                                  this.gameScreen.game.tipBox.displayTip("Toggle Quality","Toggles graphics quality to improve performance for slower computers.",0,0,0,0,true);
                                        }
                                        this.lastButton = this.hud.hud.lowButton;
                              }
                              else
                              {
                                        if(!this.gameScreen.isFastForwardFrame)
                                        {
                                                  this.mouseOverFrames = 0;
                                        }
                                        this.lastButton = null;
                              }
                              this.helpMessage.update(this.gameScreen.game);
                              this.pauseMenu.update();
                              this.selectedUnits.update(this.gameScreen.game);
                              this.gameScreen.team.checkUnitCreateMouseOver(this.gameScreen);
                              this.mouseState.update();
                              this.selectedUnits.refresh();
                              this.actionInterface.update(this.gameScreen);
                              this.selectedUnits.hasChanged = false;
                              this._chat.update();
                              this.keyBoardState.isDisabled = this.chat.isInput;
                              if(this.keyBoardState.isPressed(80) || this.keyBoardState.isPressed(Keyboard.ESCAPE))
                              {
                                        this.pauseMenu.toggleMenu();
                              }
                              this.gameScreen.game.soundManager.setPosition(this.gameScreen.game.screenX,0);
                              if(this.gameScreen.isPaused)
                              {
                                        return;
                              }
                              if(!this.UCunit && this.keyBoardState.isPressed(32) || this.keyBoardState.isPressed(32) && this.UCunit && Math.abs(this.UCunit.px - this.UCunit.ai.getClosestUnitTarget().px) > 400)
                              {
                                        this.selectedUnits.clear();
                                        for each(_loc5_ in this.team.units)
                                        {
                                                  if(!_loc5_.isTowerSpawned && _loc5_.type != Unit.U_MINER && _loc5_.type != Unit.U_CHAOS_MINER && !_loc5_.isDead && _loc5_.isGarrisoned == false && _loc5_.type != Unit.U_CHAOS_TOWER)
                                                  {
                                                            this.selectedUnits.add(_loc5_);
                                                            _loc5_.selected = true;
                                                  }
                                        }
                                        if(getTimer() - this.spacePressTimer < 400 && this.team.forwardUnitNotSpawn != null)
                                        {
                                                  this.gameScreen.game.targetScreenX = this.team.forwardUnitNotSpawn.px - this.gameScreen.game.map.screenWidth / 2;
                                                  this.isSlowCamera = false;
                                        }
                                        this.spacePressTimer = getTimer();
                              }
                              if(this.keyBoardState.isDown(39) && !this.UCunit)
                              {
                                        this.gameScreen.game.targetScreenX += this.SCROLL_SPEED * 1;
                                        this.isSlowCamera = false;
                              }
                              if(this.keyBoardState.isDown(37) && !this.UCunit)
                              {
                                        this.gameScreen.game.targetScreenX -= this.SCROLL_SPEED * 1;
                                        this.isSlowCamera = false;
                              }
                              if(this.gameScreen.game.showGameOverAnimation)
                              {
                                        this.gameScreen.game.fogOfWar.isFogOn = false;
                                        _loc6_ = this.gameScreen.game.teamA;
                                        if(this.gameScreen.game.teamA == this.gameScreen.game.winner)
                                        {
                                                  _loc6_ = this.gameScreen.game.teamB;
                                        }
                                        this.gameScreen.game.targetScreenX += (_loc6_.statue.px - this.gameScreen.game.map.screenWidth / 2 - this.gameScreen.game.targetScreenX) * 0.3;
                                        _loc6_.statue.mc.nextFrame();
                                        Util.animateMovieClip(_loc6_.statue.mc,0);
                                        if(_loc6_.statue.mc.currentFrame == _loc6_.statue.mc.totalFrames)
                                        {
                                                  this.gameScreen.game.gameOver = true;
                                        }
                                        _loc6_.updateStatue();
                              }
                              var _loc4_:int = (this.gameScreen.game.targetScreenX - this.gameScreen.game.screenX) * this.SCROLL_GAIN * 1;
                              if(this.isSlowCamera)
                              {
                                        _loc4_ = (this.gameScreen.game.targetScreenX - this.gameScreen.game.screenX) * 0.05 * 1;
                              }
                              this.gameScreen.game.screenX += _loc4_;
                              if(this.gameScreen.game.screenX > this.gameScreen.game.background.maxScreenX())
                              {
                                        this.gameScreen.game.screenX = this.gameScreen.game.targetScreenX = this.gameScreen.game.background.maxScreenX();
                              }
                              if(this.gameScreen.game.screenX < this.gameScreen.game.background.minScreenX())
                              {
                                        this.gameScreen.game.screenX = this.gameScreen.game.targetScreenX = this.gameScreen.game.background.minScreenX();
                              }
                              if(this.gameScreen.game.inEconomy)
                              {
                                        this.gameScreen.game.screenX = this.gameScreen.team.homeX - this.gameScreen.team.direction * this.gameScreen.game.map.screenWidth;
                              }
                              this.gameScreen.game.battlefield.x = -this.gameScreen.game.screenX;
                              this.gameScreen.game.fogOfWar.update(this.gameScreen.game);
                              this.gameScreen.game.cursorSprite.x = -this.gameScreen.game.screenX;
                              this.gameScreen.game.fogOfWar.x = -this.gameScreen.game.screenX;
                              this.gameScreen.game.bloodManager.x = -this.gameScreen.game.screenX;
                              this.gameScreen.game.background.update(this.gameScreen.game);
                              if(Math.abs(this.lastSentScreenPosition - this.gameScreen.game.screenX) > 100)
                              {
                                        _loc7_ = new ScreenPositionUpdateMove();
                                        this.lastSentScreenPosition = _loc7_.pos = this.gameScreen.game.screenX;
                                        this.gameScreen.doMove(_loc7_,this.team.id);
                              }
                              if(this.keyBoardState.isShift)
                              {
                                        this.team.enemyTeam.detectedUserInput(this);
                              }
                              else
                              {
                                        this.team.detectedUserInput(this);
                              }
                              if(!this.keyBoardState.isPressed(71))
                              {
                              }
                              if(this.mouseState.mouseIn && this.stage.mouseY < this.gameScreen.game.battlefield.y + 240)
                              {
                                        _loc8_ = 120;
                                        if(this.stage.mouseX < _loc8_)
                                        {
                                                  this.gameScreen.game.targetScreenX -= this.SCROLL_SPEED * (_loc8_ - stage.mouseX) / _loc8_;
                                                  this.isSlowCamera = false;
                                        }
                                        if(this.stage.mouseX > this.gameScreen.game.map.screenWidth - _loc8_)
                                        {
                                                  this.gameScreen.game.targetScreenX -= this.SCROLL_SPEED * (this.gameScreen.game.map.screenWidth - _loc8_ - stage.mouseX) / _loc8_;
                                                  this.isSlowCamera = false;
                                        }
                              }
                              if(this.mouseState.mouseDown)
                              {
                                        _loc9_ = this.hud.hud.map.mouseX / this.hud.hud.map.width;
                                        _loc10_ = this.hud.hud.map.mouseY / this.hud.hud.map.height;
                                        _loc11_ = this.hud.hud.map.globalToLocal(new Point(this.mouseState.mouseDownX,this.mouseState.mouseDownY));
                                        _loc12_ = _loc11_.x / this.hud.hud.map.width;
                                        _loc13_ = _loc11_.y / this.hud.hud.map.height;
                                        if(_loc9_ >= 0 && _loc9_ <= 1 && _loc10_ >= 0 && _loc10_ <= 1 && _loc12_ >= 0 && _loc12_ <= 1 && _loc13_ >= 0 && _loc13_ <= 1 && !(_loc12_ > 0.95 && _loc13_ < 0.54))
                                        {
                                                  this.gameScreen.game.targetScreenX = _loc9_ * this.gameScreen.game.map.width - this.gameScreen.game.map.screenWidth / 2;
                                                  this.isSlowCamera = false;
                                        }
                              }
                              if(!this.actionInterface.isInCommand() && this.stage.mouseY <= 700 - 125)
                              {
                                        this.tryToSelectABuilding();
                                        if(this.mouseState.clicked)
                                        {
                                                  if(!this.keyBoardState.isShift)
                                                  {
                                                            this.selectedUnits.clear();
                                                  }
                                                  for each(_loc14_ in this.team.walls)
                                                  {
                                                            if(_loc14_.checkForHitPoint3(new Point(stage.mouseX,stage.mouseY)))
                                                            {
                                                                      this.selectedUnits.add(Unit(_loc14_));
                                                                      Unit(_loc14_).selected = true;
                                                            }
                                                            else
                                                            {
                                                                      Unit(_loc14_).selected = false;
                                                            }
                                                  }
                                                  _loc15_ = this.gameScreen.game.mouseOverUnit;
                                                  if(_loc15_ != null && _loc15_ is Unit && Unit(_loc15_).team == this.team && !(_loc15_ is Statue))
                                                  {
                                                            if(this.keyBoardState.isShift)
                                                            {
                                                                      Unit(_loc15_).selected = true;
                                                            }
                                                            else
                                                            {
                                                                      Unit(_loc15_).selected = true;
                                                            }
                                                            this.selectedUnits.add(Unit(_loc15_));
                                                  }
                                        }
                                        if(this.mouseState.doubleClicked)
                                        {
                                                  if(!this.keyBoardState.isShift)
                                                  {
                                                            this.selectedUnits.clear();
                                                  }
                                                  _loc16_ = -1;
                                                  if(this.gameScreen.game.mouseOverUnit != null && this.gameScreen.game.mouseOverUnit is Unit && Unit(this.gameScreen.game.mouseOverUnit).team == this.team)
                                                  {
                                                            _loc16_ = this.gameScreen.game.mouseOverUnit.type;
                                                  }
                                                  for(_loc17_ in this.team.units)
                                                  {
                                                            _loc18_ = this.team.units[_loc17_].x - this.gameScreen.game.screenX;
                                                            _loc19_ = this.team.units[_loc17_].y + this.gameScreen.game.battlefield.y;
                                                            if(Unit(this.team.units[_loc17_]).type == _loc16_ || Unit(this.team.units[_loc17_]).selected && this.keyBoardState.isShift)
                                                            {
                                                                      Unit(this.team.units[_loc17_]).selected = true;
                                                            }
                                                            else
                                                            {
                                                                      Unit(this.team.units[_loc17_]).selected = false;
                                                            }
                                                            if(Unit(this.team.units[_loc17_]).selected)
                                                            {
                                                                      this.selectedUnits.add(Unit(this.team.units[_loc17_]));
                                                            }
                                                  }
                                        }
                              }
                              this.box.update(this.gameScreen.game.battlefield.mouseX,this.gameScreen.game.battlefield.mouseY);
                              if(this.box.isOn)
                              {
                                        for(_loc17_ in this.team.units)
                                        {
                                                  if(this.team.units[_loc17_].isAlive())
                                                  {
                                                            if(!(Unit(this.team.units[_loc17_]).interactsWith & Unit.I_IS_BUILDING))
                                                            {
                                                                      _loc18_ = this.team.units[_loc17_].x;
                                                                      _loc19_ = this.team.units[_loc17_].y;
                                                                      if(this.keyBoardState.isShift)
                                                                      {
                                                                                Unit(this.team.units[_loc17_]).selected = this.box.isInside(_loc18_,_loc19_,this.team.units[_loc17_].mc.height / 2,20) || Unit(this.team.units[_loc17_]).selected || this.gameScreen.game.mouseOverUnit == this.team.units[_loc17_];
                                                                      }
                                                                      else
                                                                      {
                                                                                Unit(this.team.units[_loc17_]).selected = this.box.isInside(_loc18_,_loc19_,this.team.units[_loc17_].mc.height / 2,20) || this.gameScreen.game.mouseOverUnit == this.team.units[_loc17_];
                                                                      }
                                                                      if(Unit(this.team.units[_loc17_]).selected)
                                                                      {
                                                                                this.selectedUnits.add(Unit(this.team.units[_loc17_]));
                                                                      }
                                                            }
                                                  }
                                        }
                              }
                              this._hud.update(this.gameScreen.game,this.team);
                              this.hud.hud.lowButton.visible = false;
                              this.hud.hud.medButton.visible = false;
                              this.hud.hud.highButton.visible = false;
                              if(this.gameScreen.quality == GameScreen.S_LOW_QUALITY)
                              {
                                        this.hud.hud.lowButton.visible = true;
                              }
                              else if(this.gameScreen.quality == GameScreen.S_MEDIUM_QUALITY)
                              {
                                        this.hud.hud.medButton.visible = true;
                              }
                              else if(this.gameScreen.quality == GameScreen.S_HIGH_QUALITY)
                              {
                                        this.hud.hud.highButton.visible = true;
                              }
                              this.actionInterface.updateActionAlpha(this.gameScreen);
                    }
                    
                    public function mouseUpEvent(evt:Event) : void
                    {
                              if(this.gameScreen.game != null && this.gameScreen.game.cusorSprite.contains(this.box))
                              {
                                        this.gameScreen.game.cusorSprite.removeChild(this.box);
                                        this.box.end();
                                        this.selectedUnits.hasFinishedSelecting = true;
                                        if(this.selectedUnits.selected.length == 0)
                                        {
                                                  this.mouseState.clicked = true;
                                                  this.tryToSelectABuilding();
                                        }
                              }
                    }
                    
                    public function mouseDownEvent(evt:MouseEvent) : void
                    {
                              if(!this.actionInterface.isInCommand() && evt.stageY <= 700 - 125)
                              {
                                        this.box.start(this.gameScreen.game.battlefield.mouseX,this.gameScreen.game.battlefield.mouseY);
                                        this.gameScreen.game.cusorSprite.addChild(this.box);
                                        if(!this.keyBoardState.isShift)
                                        {
                                                  this.selectedUnits.clear();
                                        }
                                        this.selectedUnits.hasFinishedSelecting = false;
                              }
                    }
                    
                    public function get hud() : Hud
                    {
                              return this._hud;
                    }
                    
                    public function set hud(value:Hud) : void
                    {
                              this._hud = value;
                    }
                    
                    public function get actionInterface() : ActionInterface
                    {
                              return this._actionInterface;
                    }
                    
                    public function set actionInterface(value:ActionInterface) : void
                    {
                              this._actionInterface = value;
                    }
                    
                    public function get team() : Team
                    {
                              return this._team;
                    }
                    
                    public function set team(value:Team) : void
                    {
                              this._team = value;
                    }
                    
                    public function get selectedUnits() : SelectedUnits
                    {
                              return this._selectedUnits;
                    }
                    
                    public function set selectedUnits(value:SelectedUnits) : void
                    {
                              this._selectedUnits = value;
                    }
                    
                    public function get main() : BaseMain
                    {
                              return this._main;
                    }
                    
                    public function set main(value:BaseMain) : void
                    {
                              this._main = value;
                    }
                    
                    public function get chat() : Chat
                    {
                              return this._chat;
                    }
                    
                    public function set chat(value:Chat) : void
                    {
                              this._chat = value;
                    }
                    
                    public function get gameScreen() : GameScreen
                    {
                              return this._gameScreen;
                    }
                    
                    public function set gameScreen(value:GameScreen) : void
                    {
                              this._gameScreen = value;
                    }
                    
                    public function get box() : Box
                    {
                              return this._box;
                    }
                    
                    public function set box(value:Box) : void
                    {
                              this._box = value;
                    }
                    
                    public function get isSlowCamera() : Boolean
                    {
                              return this._isSlowCamera;
                    }
                    
                    public function set isSlowCamera(value:Boolean) : void
                    {
                              this._isSlowCamera = value;
                    }
                    
                    public function get helpMessage() : HelpMessage
                    {
                              return this._helpMessage;
                    }
                    
                    public function set helpMessage(value:HelpMessage) : void
                    {
                              this._helpMessage = value;
                    }
                    
                    public function get isMusic() : Boolean
                    {
                              return this._isMusic;
                    }
                    
                    public function set isMusic(value:Boolean) : void
                    {
                              this.gameScreen.game.soundManager.isMusic = value;
                              this._isMusic = value;
                    }
                    
                    public function get pauseMenu() : PauseMenu
                    {
                              return this._pauseMenu;
                    }
                    
                    public function set pauseMenu(value:PauseMenu) : void
                    {
                              this._pauseMenu = value;
                    }
          }
}
