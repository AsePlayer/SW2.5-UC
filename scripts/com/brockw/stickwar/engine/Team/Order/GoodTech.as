package com.brockw.stickwar.engine.Team.Order
{
          import com.brockw.stickwar.engine.StickWar;
          import com.brockw.stickwar.engine.Team.Tech;
          import com.brockw.stickwar.engine.Team.TechItem;
          import flash.display.Bitmap;
          import flash.utils.Dictionary;
          
          public class GoodTech extends Tech
          {
                     
                    
                    private var game:StickWar;
                    
                    public function GoodTech(game:StickWar, team:TeamGood)
                    {
                              this.game = game;
                              this.team = team;
                              this.initTech(game);
                              this.initUpgrades(game,team);
                              super(game,team);
                    }
                    
                    public function initTech(game:StickWar) : void
                    {
                    }
                    
                    private function addNewUpgrade(updgradeType:int, upgrade:XMLList, button:Bitmap, hotKey:int) : void
                    {
                              upgrades[updgradeType] = new TechItem(upgrade,button);
                    }
                    
                    public function initUpgrades(game:StickWar, team:TeamGood) : void
                    {
                              researchingMap = new Object();
                              upgrades = new Dictionary();
                              this.addNewUpgrade(SWORDWRATH_RAGE,game.xml.xml.Order.Tech.rage,new Bitmap(new SwordwrathSacrifice()),69);
                              this.addNewUpgrade(BLOCK,game.xml.xml.Order.Tech.block,new Bitmap(new SpeartanShieldWall()),65);
                              this.addNewUpgrade(CLOAK,game.xml.xml.Order.Tech.cloak,new Bitmap(new NinjaCloak1()),90);
                              this.addNewUpgrade(CLOAK_II,game.xml.xml.Order.Tech.cloak2,new Bitmap(new NinjaCloak2()),90);
                              this.addNewUpgrade(ARCHIDON_FIRE,game.xml.xml.Order.Tech.archidonFire,new Bitmap(new ArchidonFire()),90);
                              this.addNewUpgrade(MAGIKILL_NUKE,game.xml.xml.Order.Tech.magikillNuke,new Bitmap(new MagikillFireballs()),81);
                              this.addNewUpgrade(MAGIKILL_WALL,game.xml.xml.Order.Tech.magikillWall,new Bitmap(new MagikillWall()),81);
                              this.addNewUpgrade(MAGIKILL_POISON,game.xml.xml.Order.Tech.magikillPoison,new Bitmap(new poisonSprayBitmap()),81);
                              this.addNewUpgrade(MONK_CURE,game.xml.xml.Order.Tech.cure,new Bitmap(new CureBitmap()),81);
                              this.addNewUpgrade(CASTLE_ARCHER_1,game.xml.xml.Order.Tech.castleArchers1,new Bitmap(new castleArcherLevel1Bitmap()),81);
                              this.addNewUpgrade(CASTLE_ARCHER_2,game.xml.xml.Order.Tech.castleArchers2,new Bitmap(new castleArcherLevel2Bitmap()),81);
                              this.addNewUpgrade(CASTLE_ARCHER_3,game.xml.xml.Order.Tech.castleArchers3,new Bitmap(new castleArcherLevel3Bitmap()),81);
                              this.addNewUpgrade(SHIELD_BASH,game.xml.xml.Order.Tech.speartonShieldBash,new Bitmap(new shieldHitBitmap()),81);
                              this.addNewUpgrade(STATUE_HEALTH,game.xml.xml.Order.Tech.statueHealth,new Bitmap(new statueHealthBitmap()),81);
                              this.addNewUpgrade(MINER_SPEED,game.xml.xml.Order.Tech.minerSpeed,new Bitmap(new minerBagBitmap()),81);
                              this.addNewUpgrade(BANK_PASSIVE_1,game.xml.xml.Order.Tech.passiveIncomeGold1,new Bitmap(new passiveIncomeBitmap()),89);
                              this.addNewUpgrade(BANK_PASSIVE_2,game.xml.xml.Order.Tech.passiveIncomeGold2,new Bitmap(new passiveIncomeBitmap()),89);
                              this.addNewUpgrade(BANK_PASSIVE_3,game.xml.xml.Order.Tech.passiveIncomeGold3,new Bitmap(new passiveIncomeBitmap()),89);
                              this.addNewUpgrade(GIANT_GROWTH_I,game.xml.xml.Order.Tech.giantSize1,new Bitmap(new GiantGrowth1Bitmap()),81);
                              this.addNewUpgrade(GIANT_GROWTH_II,game.xml.xml.Order.Tech.giantSize2,new Bitmap(new GiantGrowth2Bitmap()),87);
                              this.addNewUpgrade(MINER_WALL,game.xml.xml.Order.Tech.minerWall,new Bitmap(new OrderTowerBitmap()),87);
                              this.addNewUpgrade(Tech.CROSSBOW_FIRE,game.xml.xml.Order.Tech.crossbowFire,new Bitmap(new allbowtrossFireArrowUpgrade()),87);
                              this.addNewUpgrade(TOWER_SPAWN_I,game.xml.xml.Chaos.Tech.towerSpawnI,new Bitmap(new towerUpgradeI()),89);
                              this.addNewUpgrade(TOWER_SPAWN_II,game.xml.xml.Chaos.Tech.towerSpawnII,new Bitmap(new towerUpgradeII()),89);
                    }
                    
                    override public function update(game:StickWar) : void
                    {
                              super.update(game);
                    }
                    
                    override public function isResearching(type:int) : Boolean
                    {
                              return type in researchingMap;
                    }
                    
                    override public function getResearchCooldown(type:int) : Number
                    {
                              return researchingMap[type] / upgrades[type].researchTime;
                    }
          }
}
