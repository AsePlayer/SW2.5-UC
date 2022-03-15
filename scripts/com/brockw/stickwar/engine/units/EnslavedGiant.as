package com.brockw.stickwar.engine.units
{
          import com.brockw.game.Util;
          import com.brockw.stickwar.engine.Ai.EnslavedGiantAi;
          import com.brockw.stickwar.engine.StickWar;
          import com.brockw.stickwar.engine.Team.Tech;
          import flash.display.MovieClip;
          import flash.geom.Point;
          
          public class EnslavedGiant extends RangedUnit
          {
                    
                    private static const WEAPON_REACH:int = 90;
                     
                    
                    private var target:Unit;
                    
                    private var scaleI:Number;
                    
                    private var scaleII:Number;
                    
                    private var hasGrowled:Boolean;
                    
                    public function EnslavedGiant(game:StickWar)
                    {
                              super(game);
                              _mc = new _giantMc();
                              this.init(game);
                              addChild(_mc);
                              ai = new EnslavedGiantAi(this);
                              initSync();
                              firstInit();
                    }
                    
                    public static function setItem(mc:MovieClip, weapon:String, armor:String, misc:String) : void
                    {
                              var m:_giantMc = _giantMc(mc);
                              if(m.mc.giantbag)
                              {
                                        if(weapon != "")
                                        {
                                                  m.mc.giantbag.gotoAndStop(weapon);
                                        }
                              }
                    }
                    
                    override public function applyVelocity(xf:Number, yf:Number = 0, zf:Number = 0) : void
                    {
                    }
                    
                    override public function init(game:StickWar) : void
                    {
                              initBase();
                              this.hasGrowled = false;
                              _maximumRange = game.xml.xml.Order.Units.giant.maximumRange;
                              population = game.xml.xml.Chaos.Units.giant.population;
                              maxHealth = health = game.xml.xml.Order.Units.giant.health;
                              this.createTime = game.xml.xml.Order.Units.giant.cooldown;
                              projectileVelocity = game.xml.xml.Order.Units.giant.projectileVelocity;
                              _mass = game.xml.xml.Order.Units.giant.mass;
                              _maxForce = game.xml.xml.Order.Units.giant.maxForce;
                              _dragForce = game.xml.xml.Order.Units.giant.dragForce;
                              _scale = game.xml.xml.Order.Units.giant.scale;
                              _maxVelocity = game.xml.xml.Order.Units.giant.maxVelocity;
                              this.scaleI = game.xml.xml.Order.Units.giant.growthIScale;
                              this.scaleII = game.xml.xml.Order.Units.giant.growthIIScale;
                              type = Unit.U_ENSLAVED_GIANT;
                              loadDamage(game.xml.xml.Order.Units.giant);
                              _mc.stop();
                              _mc.width *= _scale;
                              _mc.height *= _scale;
                              _state = S_RUN;
                              MovieClip(_mc.mc.gotoAndPlay(1));
                              MovieClip(_mc.gotoAndStop(1));
                              drawShadow();
                              this.healthBar.y = -mc.mc.height * 1.1;
                              aimXOffset = 50 * 2 - 35;
                              aimYOffset = -90 * 2 + 102;
                    }
                    
                    override public function setBuilding() : void
                    {
                              building = team.buildings["SiegeBuilding"];
                    }
                    
                    override public function update(param1:StickWar) : void
                    {
                              if(isUC)
                              {
                                        _maxVelocity = 3 * 1.25;
                                        _damageToNotArmour = (40 + 0) * 0.75 * Number(team.game.main.campaign.difficultyLevel);
                                        _damageToArmour = (40 + 30) * 0.75 * Number(team.game.main.campaign.difficultyLevel);
                              }
                              else if(!team.isEnemy)
                              {
                                        _maxVelocity = 3;
                                        _damageToNotArmour = 40 + 0;
                                        _damageToArmour = 40 + 30;
                              }
                              else if(team.isEnemy && !enemyBuffed)
                              {
                                        _damageToNotArmour = _damageToNotArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
                                        _damageToArmour = _damageToArmour / 2 * team.game.main.campaign.difficultyLevel + 1;
                                        health = health / 2.5 * (team.game.main.campaign.difficultyLevel + 1);
                                        maxHealth = health;
                                        maxHealth = maxHealth;
                                        healthBar.totalHealth = maxHealth;
                                        _scale = _scale + Number(team.game.main.campaign.difficultyLevel) * 0.05 - 0.05;
                                        enemyBuffed = true;
                              }
                              var _loc2_:Point = null;
                              var _loc3_:Number = NaN;
                              if(!this.hasGrowled)
                              {
                                        this.hasGrowled = true;
                                        team.game.soundManager.playSoundRandom("GiantGrowl",6,px,py);
                              }
                              stunTimeLeft = 0;
                              _dz = 0;
                              if(team.tech.isResearched(Tech.GIANT_GROWTH_II))
                              {
                                        if(_scale != this.scaleII)
                                        {
                                                  health = param1.xml.xml.Order.Units.giant.healthII - (maxHealth - health);
                                                  maxHealth = param1.xml.xml.Order.Units.giant.healthII;
                                                  healthBar.totalHealth = maxHealth;
                                        }
                                        this.pheight *= this.scaleII / this.scaleI;
                                        _scale = this.scaleII;
                              }
                              else if(team.tech.isResearched(Tech.GIANT_GROWTH_I))
                              {
                                        if(_scale != this.scaleI)
                                        {
                                                  health = param1.xml.xml.Order.Units.giant.healthI - (maxHealth - health);
                                                  maxHealth = param1.xml.xml.Order.Units.giant.healthI;
                                                  healthBar.totalHealth = maxHealth;
                                        }
                                        this.pheight *= this.scaleI / _scale;
                                        _scale = this.scaleI;
                              }
                              _loc2_ = _mc.localToGlobal(new Point(50,-90));
                              _loc2_ = this.globalToLocal(_loc2_);
                              aimXOffset = _loc2_.x;
                              aimYOffset = _loc2_.y + 25;
                              super.update(param1);
                              updateCommon(param1);
                              if(!isDieing)
                              {
                                        updateMotion(param1);
                                        if(_isDualing)
                                        {
                                                  _mc.gotoAndStop(_currentDual.attackLabel);
                                                  moveDualPartner(_dualPartner,_currentDual.xDiff);
                                                  if(MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                                                  {
                                                            _isDualing = false;
                                                            _state = S_RUN;
                                                            px += Util.sgn(mc.scaleX) * _currentDual.finalXOffset * this.scaleX * this._scale * _worldScaleX * this.perspectiveScale;
                                                            dx = 0;
                                                            dy = 0;
                                                  }
                                        }
                                        else if(_state == S_RUN)
                                        {
                                                  if(isFeetMoving())
                                                  {
                                                            _mc.gotoAndStop("run");
                                                  }
                                                  else
                                                  {
                                                            _mc.gotoAndStop("stand");
                                                  }
                                        }
                                        else if(_state == S_ATTACK)
                                        {
                                                  if(MovieClip(_mc.mc).currentFrame == 1)
                                                  {
                                                            team.game.soundManager.playSound("BoulderThrowSound",px,py);
                                                  }
                                                  if(MovieClip(_mc.mc).currentFrame == 33)
                                                  {
                                                            _loc2_ = _mc.localToGlobal(new Point(50,-90));
                                                            _loc2_ = param1.battlefield.globalToLocal(_loc2_);
                                                            _loc3_ = 0;
                                                            if(inRange(this.target))
                                                            {
                                                                      _loc3_ = angleToTargetW(this.target,projectileVelocity,angleToTarget(this.target));
                                                            }
                                                            if(isUC)
                                                            {
                                                                      this.damageToDeal = 1.5 * 150;
                                                            }
                                                            else
                                                            {
                                                                      this.damageToDeal = 150;
                                                            }
                                                            if(mc.scaleX < 0)
                                                            {
                                                                      param1.projectileManager.initBoulder(_loc2_.x,_loc2_.y,180 - bowAngle,projectileVelocity,0,_loc3_,this,damageToDeal,false);
                                                            }
                                                            else
                                                            {
                                                                      param1.projectileManager.initBoulder(_loc2_.x,_loc2_.y,bowAngle,projectileVelocity,0,_loc3_,this,damageToDeal,false);
                                                            }
                                                  }
                                                  if(MovieClip(_mc.mc).totalFrames == MovieClip(_mc.mc).currentFrame)
                                                  {
                                                            _state = S_RUN;
                                                  }
                                        }
                              }
                              else if(isDead == false)
                              {
                                        isDead = true;
                                        team.game.soundManager.playSoundRandom("GiantDeath",3,px,py);
                                        if(_isDualing)
                                        {
                                                  _mc.gotoAndStop(_currentDual.defendLabel);
                                        }
                                        else
                                        {
                                                  _mc.gotoAndStop(getDeathLabel(param1));
                                        }
                                        this.team.removeUnit(this,param1);
                              }
                              if(!isDead && MovieClip(_mc.mc).currentFrame == MovieClip(_mc.mc).totalFrames)
                              {
                                        MovieClip(_mc.mc).gotoAndStop(1);
                              }
                              MovieClip(_mc.mc).nextFrame();
                              _mc.mc.stop();
                              if(team.isEnemy)
                              {
                                        if(team.game.main.campaign.difficultyLevel == 3)
                                        {
                                                  setItem(mc,"Bones Bag","","");
                                        }
                                        else if(team.game.main.campaign.difficultyLevel == 2)
                                        {
                                                  setItem(mc,"Wooden Bag","","");
                                        }
                                        else if(team.game.main.campaign.difficultyLevel == 1)
                                        {
                                                  setItem(mc,"","","");
                                        }
                              }
                              else
                              {
                                        setItem(mc,"","","");
                              }
                    }
                    
                    override public function aim(target:Unit) : void
                    {
                              var a:Number = angleToTarget(target);
                              if(target != null && this._state == Unit.S_ATTACK && !inRange(target))
                              {
                                        return;
                              }
                              if(Math.abs(normalise(angleToBowSpace(a) - bowAngle)) < 10)
                              {
                                        bowAngle += normalise(angleToBowSpace(a) - bowAngle) * 1;
                              }
                              else
                              {
                                        bowAngle += normalise(angleToBowSpace(a) - bowAngle) * 1;
                              }
                    }
                    
                    override public function shoot(game:StickWar, target:Unit) : void
                    {
                              var id:int = 0;
                              if(_state != S_ATTACK)
                              {
                                        id = team.game.random.nextInt() % this._attackLabels.length;
                                        _mc.gotoAndStop("attack_" + this._attackLabels[id]);
                                        MovieClip(_mc.mc).gotoAndStop(1);
                                        _state = S_ATTACK;
                                        this.target = target;
                              }
                    }
                    
                    override public function stateFixForCutToWalk() : void
                    {
                              if(_state != S_ATTACK)
                              {
                                        super.stateFixForCutToWalk();
                              }
                    }
                    
                    override protected function isAbleToWalk() : Boolean
                    {
                              return _state == S_RUN;
                    }
          }
}
