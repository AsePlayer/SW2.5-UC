package com.brockw.game
{
          import flash.display.Stage;
          import flash.events.*;
          
          public class KeyboardState
          {
                     
                    
                    private var keysVector:Vector.<Boolean>;
                    
                    private var pressedVector:Vector.<Boolean>;
                    
                    private var downVector:Vector.<Boolean>;
                    
                    private var _isShift:Boolean;
                    
                    private var _target:Stage;
                    
                    private var _isDisabled:Boolean;
                    
                    public function KeyboardState(target:Stage)
                    {
                              super();
                              this._isDisabled = false;
                              this._target = target;
                              this.keysVector = new Vector.<Boolean>(255,false);
                              this.pressedVector = new Vector.<Boolean>(255,false);
                              this.downVector = new Vector.<Boolean>(255,false);
                              for(var i:int = 0; i < 256; i++)
                              {
                                        this.keysVector[i] = this.pressedVector[i] = this.downVector[i] = false;
                              }
                              target.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDown);
                              target.addEventListener(KeyboardEvent.KEY_UP,this.keyUp);
                    }
                    
                    public function cleanUp() : void
                    {
                              this._target.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyDown);
                              this._target.removeEventListener(KeyboardEvent.KEY_UP,this.keyUp);
                    }
                    
                    public function isDown(key:int) : Boolean
                    {
                              return this.keysVector[key];
                    }
                    
                    public function isPressed(key:int) : Boolean
                    {
                              if(this._isDisabled)
                              {
                                        return false;
                              }
                              var b:Boolean = this.pressedVector[key];
                              this.pressedVector[key] = false;
                              return b;
                    }
                    
                    public function isDownForAction(key:int) : Boolean
                    {
                              if(this._isDisabled)
                              {
                                        return false;
                              }
                              if(this.downVector[key])
                              {
                                        this.downVector[key] = false;
                                        return true;
                              }
                              return false;
                    }
                    
                    private function keyUp(evt:KeyboardEvent) : void
                    {
                              this._isShift = evt.shiftKey;
                              this.keysVector[evt.keyCode] = false;
                              this.pressedVector[evt.keyCode] = false;
                              this.downVector[evt.keyCode] = false;
                    }
                    
                    private function keyDown(evt:KeyboardEvent) : void
                    {
                              if(this.keysVector[evt.keyCode] == false)
                              {
                                        this.pressedVector[evt.keyCode] = true;
                                        this.downVector[evt.keyCode] = true;
                              }
                              this._isShift = evt.shiftKey;
                              this.keysVector[evt.keyCode] = true;
                    }
                    
                    public function get isShift() : Boolean
                    {
                              return this._isShift;
                    }
                    
                    public function set isShift(value:Boolean) : void
                    {
                              this._isShift = value;
                    }
                    
                    public function get isDisabled() : Boolean
                    {
                              return this._isDisabled;
                    }
                    
                    public function set isDisabled(value:Boolean) : void
                    {
                              this._isDisabled = value;
                    }
          }
}
