﻿package mc {		import flash.display.MovieClip;			public class Roles extends MovieClip {				//0:back 1:front		public var status:int = 0				public var identity:String = "back";					public var playerNumber:int = -1;					public function Roles() {			// constructor code		}				public function displayNumber():void{			this.txtNumber.text = playerNumber.toString();			this.txtNumber_2.text = playerNumber.toString();		}				public function setIdentity(_name:String):void{			if(_name == "back"){								status = 0			}else{				status = 1			}			identity = _name;			this.gotoAndStop(identity)		}				/**		 *翻过卡牌		 * 		 */				public function turnOff():void{			this.gotoAndStop("back")		}	}	}