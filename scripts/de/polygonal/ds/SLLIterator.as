package de.polygonal.ds
{
          import flash.Boot;
          
          public class SLLIterator implements Itr
          {
                     
                    
                    public var _walker:SLLNode;
                    
                    public var _f:SLL;
                    
                    public function SLLIterator(param1:SLL = undefined)
                    {
                              if(Boot.skip_constructor)
                              {
                                        return;
                              }
                              _f = param1;
                              _walker = _f.head;
                              this;
                    }
                    
                    public function reset() : Itr
                    {
                              _walker = _f.head;
                              return this;
                    }
                    
                    public function next() : Object
                    {
                              var _loc1_:Object = _walker.val;
                              _walker = _walker.next;
                              return _loc1_;
                    }
                    
                    public function hasNext() : Boolean
                    {
                              return _walker != null;
                    }
                    
                    public function __head(param1:Object) : SLLNode
                    {
                              return param1.head;
                    }
          }
}
