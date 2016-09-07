package Scenes
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import flashx.textLayout.formats.TextAlign;
	
	import mc.Roles;
	
	import ui.button.Next;
	
	public class GameBase extends Sprite
	{
		private var roles:Vector.<Roles>;
		
		//第几夜晚
		private var nightIndex:int = 1;
		
		//进行到第几个角色
		private var roleIndex:int = 0;
		
		//所有角色
		private var roleName:Array;
		
		//所有角色数量
		private var roleNumber:Array;
		
		private var currentRoleList:Dictionary;
		
		//单个角色的进程
		private var roleProgress:Dictionary;
		
		private var nextButton:Next;
		
		private var dialogueTF:TextField;
		
		//狼人上一个击杀的对象
		private var lastWolfKill:Roles = null;
		
		//女巫上一个毒的对象
		private var lastWitchKill:Roles = null;
			
		//女巫上一个救的人
		private var lastWitchSave:Roles = null;
		
		public function GameBase()
		{
			super();
			currentRoleList = new Dictionary();
			roleProgress   	= new Dictionary();
			roleName 		= ["wolf","witch","seer","guard","hunter","farmer","back"];
			roleNumber		= [4,1,1,1,1,4]
			for(var i:int = 0; i < roleName.length-1 ; i++){
				currentRoleList[roleName[i]] = new Array()
			}
			for(i = 0; i < roleName.length-1 ; i++){
				roleProgress[roleName[i]] = 0
			}
			
			dialogueTF = new TextField();
			dialogueTF.defaultTextFormat = new TextFormat(null,30,0xffffff,null,null,null,null,null,TextAlign.CENTER)
//			dialogueTF.
			dialogueTF.width = Main.view.width
			this.addChild(dialogueTF);
			dialogueTF.x = 0;
			dialogueTF.y = Main.view.height - 50
			dialogueTF.text = "狼人睁眼，选择你们的号码"
			init();
		}
		
		private function init(){
			roles = new Vector.<Roles>()
			for(var i:int = 0 ; i < 12 ; i++){
				var roleCard:Roles = new Roles();
				roleCard.setIdentity(Roles.BACK);
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
//				if(role == Roles.WOLF){
				trace("role:",role , "roleProgress[role]",roleProgress[role])
					if(roleProgress[role] == 0){
						if(target.status == 0){
							var canPush:Boolean = this.markPlayerRole(role,target.playerNumber)						
							if(canPush)target.setIdentity(role)						
						}else{
							this.unMarkPlayerRole(target.identity , target.playerNumber)
							target.setIdentity(Roles.BACK)
						}
						//角色人数满了，出现next按钮
						if(checkRoleNumber(role)){
							nextButton.visible = true
						}else{
							nextButton.visible = false
						}
						//第一次击杀
					}else if(roleProgress[role] == 1){
						wolfKill(target)
					}
//				}
			}			
		}
		
		private function wolfKill(target:Roles):void{
			nextButton.visible = true
			if(lastWolfKill == target){
				lastWolfKill.setIdentity(Roles.BACK);
				lastWolfKill = null
			}else{
				if(lastWolfKill != null){
					lastWolfKill.setIdentity(Roles.BACK);
				}
				target.setIdentity(Roles.KILL)
				lastWolfKill = target;
			}
		}
		
		private function onNext(e:MouseEvent):void{
			var role:String = roleName[roleIndex]
			var roleg:int = roleProgress[role]
			//如果角色还处于认身份阶段，不进行下一个角色
			if (roleg == 0){
				if(role == Roles.WOLF){
					roleProgress[role] ++ ;
					nextButton.visible = false
					turnOffAllCards();
					setDialogue("狼人选择目标")
				}
			}else{
				
				if(role == Roles.WOLF){
					//狼人击杀结束后的
					roleProgress[role] ++ ;
					nextButton.visible = false
					turnOffAllCards();
					setDialogue("狼人闭眼，女巫睁眼，告诉我你的号码")
				}
				
				//每次一个角色行动完成后加1
				roleIndex ++ ;
			}
		}
		
		//翻过所有卡牌
		private function turnOffAllCards():void{
			for(var i:int = 0 ; i < roles.length ; i++){
				roles[i].turnOff();
			}
		}
		
		private function setDialogue(_str:String):void{
			dialogueTF.text = _str;
		}
		
		//标记每个角色号码
		private function markPlayerRole(_role:String, _playerNumber:int):Boolean{
			if(!checkRoleNumber(_role)){
				currentRoleList[_role].push(_playerNumber)
				return true
			}
			return false		
		}
		
		//查看当前这个角色是不是人数满了
		private function checkRoleNumber(_role:String):Boolean{
			var index:int  = roleName.indexOf(_role);
			var max:int    = roleNumber[index];
			if(currentRoleList[_role].length < max ){
				return false
			}
			return true
		}
		
		//取消标记角色
		private function unMarkPlayerRole(_role:String, _playerNumber:int):void{
			var deleteIndex:int = currentRoleList[_role].indexOf(_playerNumber);
			
			(currentRoleList[_role] as Array).splice(deleteIndex,1)
			
		}
	}
}