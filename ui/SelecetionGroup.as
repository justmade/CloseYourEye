package ui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import ui.button.No;
	import ui.button.Yes;
	
	public class SelecetionGroup extends Sprite
	{
		
		private var btnYes:Yes;
		private var btnNo:No
		private var yesFun:Function;
		private var noFun:Function
		public function SelecetionGroup()
		{
			super();
			
			btnYes = new Yes()
			btnYes.x = btnYes.width/2
			this.addChild(btnYes)
			
			btnNo = new No()
			this.addChild(btnNo);
			btnNo.x = btnYes.x + btnYes.width + 100;
			
			btnYes.addEventListener(MouseEvent.CLICK , onClickYes);
			btnNo.addEventListener(MouseEvent.CLICK , onClickNo)
		}
		
		public function setYesFun(_fun:Function):void{
			yesFun = _fun;
		}
		
		public function setNoFun(_fun:Function):void{
			noFun = _fun;
		}
		
		private function onClickYes(e:MouseEvent):void{
			yesFun()
		}
		
		private function onClickNo(e:MouseEvent):void{
			noFun()
		}
		
		
	}
}