package Scenes
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mc.Roles;
	
	import ui.button.Next;
	
	public class GameBase extends Sprite
	{
		private var roles:Vector.<Roles>;
		
		//第几夜晚
		private var nightIndex:int = 1;
		
		//进行到第几个玩家
		private var roleIndex:int = 0;
		
		//所有角色
		private var roleName:Array;
		
		//所有角色数量
		private var roleNumber:Array;
		
		private var currentRoleList:Dictionary;
		
		private var roleProgress:Dictionary;
		
		private var nextButton:Next;
		
		public function GameBase()
		{
			super();
			currentRoleList = new Dictionary();
			roleProgress   	= new Dictionary();
			roleName 		= ["wolf","seer","witch","guard","hunter","farmer","back"];
			roleNumber		= [4,1,1,1,1,4]
			for(var i:int = 0; i < roleName.length-1 ; i++){
				currentRoleList[roleName[i]] = new Array()
			}
			for(i = 0; i < roleName.length-1 ; i++){
				roleProgress[roleName[i]] = 0
			}
			init();
		}
		
		private function init(){
			roles = new Vector.<Roles>()
			for(var i:int = 0 ; i < 12 ; i++){
				var roleCard:Roles = new Roles();
				roleCard.setIdentity("back");
				this.addChild(roleCard);
				var rw:int = roleCard.width;
				var rh:int = roleCard.height;
				var scale:Number = Main.view.width / (rw * 6 + 30 * 7)
				roleCard.scaleX = scale;
				roleCard.scaleY = scale;				
				roleCard.x = (rw * scale + 30 * scale) * (i % 6) + rw * scale /2 + 30 * scale
				roleCard.y = (rh * scale + 30 * scale) * int(i / 6) + rh * scale /2
				roles.push(roleCard);
				roleCard.playerNumber = i + 1
				if(i >= 6 ){
					roleCard.playerNumber = 12 - (i - 6)
				}
				roleCard.displayNumber()
				
				
				roleCard.addEventListener(MouseEvent.CLICK , onClickCard);
			}
			
			nextButton = new Next();
			this.addChild(nextButton);
			nextButton.x = Main.view.width/2;
			nextButton.y = Main.view.height - nextButton.height - 50
			nextButton.addEventListener(MouseEvent.CLICK , onNext)
			nextButton.visible = false
		}
		
		private function onClickCard(e:MouseEvent):void{
			if(nightIndex == 1){
				var role:String = roleName[roleIndex];
				var target:Roles = e.currentTarget as Roles
				if(roleProgress[role] == 0){
					if(target.status == 0){
						var canPush:Boolean = this.markPlayerRole(role,target.playerNumber)						
						if(canPush)target.setIdentity(role)						
					}else{
						this.unMarkPlayerRole(target.identity , target.playerNumber)
						target.setIdentity("back")
					}
					//如果角色卡还处于认身份阶段，出现next按钮
					var index:int  = roleName.indexOf(role);
					var max:int    = roleNumber[index];
					if(currentRoleList[role].length == max ){
						nextButton.visible = true
					}
					//第一次击杀
				}else if(roleProgress[role] == 1){
					target.setIdentity("kill")
				}
				
				
			}
			
			
			for(var i:int = 0; i < roleName.length-1 ; i++){
				trace(currentRoleList[roleName[i]])
			}
			
		}
		
		private function onNext(e:MouseEvent):void{
			var role:String = roleName[roleIndex]
			var roleg:int = roleProgress[role]
			//如果角色还处于认身份阶段，不进行下一个角色
			if (roleg == 0){
				roleProgress[role] ++ ;
				nextButton.visible = false
				for(var i:int = 0 ; i < roles.length ; i++){
					roles[i].turnOff();
				}
					
			}else{
				
			}
		}
		
		//标记每个角色号码
		private function markPlayerRole(_role:String, _playerNumber:int):Boolean{
			var index:int  = roleName.indexOf(_role);
			var max:int    = roleNumber[index];
			if(currentRoleList[_role].length < max ){
				currentRoleList[_role].push(_playerNumber)
				return true
			}
			return false		
		}
		
		//取消标记角色
		private function unMarkPlayerRole(_role:String, _playerNumber:int):void{
			var deleteIndex:int = currentRoleList[_role].indexOf(_playerNumber);
			(currentRoleList[_role] as Array).splice(deleteIndex,1)
			
		}
	}
}