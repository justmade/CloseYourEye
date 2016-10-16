package mc {		import flash.display.MovieClip;		public class Roles extends MovieClip {				public static var WOLF:String 	= "wolf";		public static var SEER:String 	= "seer";		public static var WITCH:String 	= "witch";		public static var GUARD:String 	= "guard";		public static var HUNTER:String = "hunter";		public static var FARMER:String = "farmer";		public static var BACK:String 	= "back";		public static var KILL:String	= "kill"				//0:back 1:front		public var status:int = 0				public var identity:String = "back";					public var playerNumber:int = -1;					public function Roles() {			// constructor code		}				public function displayNumber():void{			this.txtNumber.text = playerNumber.toString();			this.txtNumber_2.text = playerNumber.toString();		}				public function setIdentity(_name:String):void{			if(_name == Roles.KILL || _name == Roles.BACK){								status = 0			}else{				status = 1
				identity = _name;			}					this.gotoAndStop(_name)		}
		
		public function checkRole():void{
			trace("identity",identity)
			if(identity != Roles.WOLF){
				this.gotoAndStop(Roles.FARMER)
			}else{
				this.gotoAndStop(Roles.WOLF)
			}
			status = 1;
		}				/**		 *翻过卡牌		 * 		 */				public function turnOff():void{			this.gotoAndStop("back")		}	}	}