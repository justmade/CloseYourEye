package Scenes
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import mc.Roles;
	
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
		
		public function GameBase()
		{
			super();
			currentRoleList = new Dictionary();
			roleName 		= ["wolf","seer","witch","guard","hunter","farmer","back"];
			roleNumber		= [4,1,1,1,1,4]
			for(var i:int = 0; i < roleName.length-1 ; i++){
				currentRoleList[roleName[i]] = new Array()
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
				
				
				roleCard.addEventListener(MouseEvent.CLICK , onClickCard)
			}
			
		}
		
		private function onClickCard(e:MouseEvent):void{
			if(nightIndex == 1){
				var role:String = roleName[roleIndex];
				var target:Roles = e.currentTarget as Roles
			
				if(target.status == 0){
					var canPush:Boolean = this.markPlayerRole(role,target.playerNumber)						
					if(canPush)target.setIdentity(role)						
				}else{
					this.unMarkPlayerRole(target.identity , target.playerNumber)
					target.setIdentity("back")
				}	
			}
			
			
			for(var i:int = 0; i < roleName.length-1 ; i++){
				trace(currentRoleList[roleName[i]])
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