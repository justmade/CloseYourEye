package ui.button
{
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	
	public class Yes extends SimpleButton
	{
		public function Yes(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null)
		{
			super(upState, overState, downState, hitTestState);
		}
	}
}