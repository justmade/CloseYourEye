package Scenes
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	
	import mc.Roles;
	
	import ui.SelecetionGroup;
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
		
		//女巫击杀的对象
		private var witchKill:Roles = null;
		
		//女巫上一个毒的对象
		private var lastWitchKill:Roles = null;
			
		//女巫上一个救的人
		private var lastWitchSave:Roles = null;
		
		//这个回合女巫是否救
		private var witchSaved:Boolean = false;
		
		//巫女毒人的阶段
		private var witchDragProgress:Boolean = false
		
		//女巫的毒药是否还存在
		private var witchHasBadDrug:Boolean = true;
		
		//女巫的解药是否存在
		private var witchHasGoodDrug:Boolean = true
		
		//这个回合预言家是否查看
		private var seerHasChecked:Boolean = false;
		
		
		
		//选择yes，no的按钮
		private var selectionGroup:SelecetionGroup;
		
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
			dialogueTF.defaultTextFormat = new TextFormat(null,30,0xffffff,null,null,null,null,null,"center")
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
				
			selectionGroup = new SelecetionGroup();
			this.addChild(selectionGroup)
			selectionGroup.x = Main.view.width/2 - selectionGroup.width/2;
			selectionGroup.y = Main.view.height - selectionGroup.height - 150;
			selectionGroup.visible = false;
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
						
					}else if(roleProgress[role] == 1){
						if(role ==  Roles.WOLF){
							//狼人第一次击杀
							lastWolfKill = wolfKill(target,lastWolfKill)
						}else if(role ==  Roles.WITCH) {
							//巫女救人阶段不能点击
							if(witchDragProgress == true){
								witchKill = wolfKill(target,witchKill)
							}
						}else if(role ==  Roles.SEER){
							if(seerHasChecked == false){
								seerCheck(target)
							}							
						}						
					}
//				}
			}			
		}
		
		//预言家查看的卡牌
		private function seerCheck(target:Roles):void{
			target.checkRole();
			seerHasChecked = true;
		}
		
		private function wolfKill(target:Roles,role:Roles):Roles{
			nextButton.visible = true
			if(role == target){
				role.setIdentity(Roles.BACK);
				role = null
			}else{
				if(role != null){
					role.setIdentity(Roles.BACK);
				}
				target.setIdentity(Roles.KILL)
				role = target;
			}
			return role
		}
		
		private function onNext(e:MouseEvent):void{
			var role:String = roleName[roleIndex]
			var roleg:int = roleProgress[role]
			trace(role,roleg)
			//如果角色还处于认身份阶段，不进行下一个角色
			if (roleg == 0){
				roleProgress[role] ++ ;
				nextButton.visible = false
				turnOffAllCards();
				if(role == Roles.WOLF){
					setDialogue("狼人选择目标")
				}else if(role == Roles.WITCH){
					setDialogue("昨天晚上"+lastWolfKill.playerNumber+"死了，你是否救？");
					selectionGroup.visible = true
					selectionGroup.setYesFun(setWitchDidSaver)
					selectionGroup.setNoFun(setWitchDidNotSaver)
				}else if(role == Roles.SEER){
					setDialogue("预言家选择你需要的查看玩家")
				}
			}else{
				
				if(role == Roles.WOLF){
					//狼人击杀结束后的
					roleProgress[role] ++ ;
					nextButton.visible = false
					turnOffAllCards();
					setDialogue("狼人闭眼，女巫睁眼，告诉我你的号码")
				}else if(role == Roles.WITCH){
					roleProgress[role] ++ ;
					nextButton.visible = false
					turnOffAllCards();
					setDialogue("女巫闭眼，预言家睁眼，告诉我你的号码")
				}
				
				//每次一个角色行动完成后加1
				roleIndex ++ ;
			}
		}
		
		//女巫救的人
		private function setWitchDidSaver():void{
			lastWitchSave = lastWolfKill
			witchSaved = true
			witchHasGoodDrug = false
				
			selectionGroup.visible = false
			setDialogue("告诉我你需要毒几号");
			nextButton.visible = true;	
			witchDragProgress = false;
		}
		
		//女巫不救人
		private function setWitchDidNotSaver():void{
			witchSaved = false
			
			selectionGroup.visible = false
			setDialogue("告诉我你需要毒几号");
			nextButton.visible = true;
			witchDragProgress = true
		}
		
		private function setWitchKill():void{
//			lastWitchKill = 
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