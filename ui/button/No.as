package ui.button
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	public class No extends SimpleButton
	{
		public function No(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
		}
	}
}