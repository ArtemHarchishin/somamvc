package com.somaprotest.core.model {		import com.somaprotest.core.control.SomaProtestController;		import com.soma.Soma;	
	/**	 * <b>Author:</b> Romuald Quantin - <a href="http://www.soundstep.com/" target="_blank">www.soundstep.com</a><br />	 * <b>Company:</b> Less Rain - <a href="http://www.lessrain.com/" target="_blank">www.lessrain.com</a><br />	 * <b>Class version:</b> 1.0<br />	 * <b>Actionscript version:</b> 3.0<br />	 * <b>Copyright:</b> 	 * <br />	 * <b>Date:</b> 7 Dec 2008<br />	 * <b>Usage:</b>	 * @example	 * <listing version="3.0"></listing>	 */		public class SomaExtended extends Soma {		//------------------------------------		// private, protected properties		//------------------------------------				private static var _instance:SomaExtended = new SomaExtended();		//------------------------------------		// public properties		//------------------------------------				public static const STATE_ALERT:String = "stateAlert";		public static const STATE_SITE:String = "stateSite";				public var state:String;				//------------------------------------		// constructor		//------------------------------------				public function SomaExtended() {			if (_instance != null) throw new Error("SomaExtended is Singleton, use SomaExtended.getInstance()");		}				//		// PRIVATE, PROTECTED		//________________________________________________________________________________________________				override protected function init():void {			state = STATE_SITE;			super.init();		}				override protected function initController():void {			super.initController();			SomaProtestController.init();		}
		// PUBLIC		//________________________________________________________________________________________________				public static function getInstance():SomaExtended {			Soma.getInstance().updateInstance(_instance);			return _instance;		}			}}