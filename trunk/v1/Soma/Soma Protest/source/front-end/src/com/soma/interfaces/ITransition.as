package com.soma.interfaces {
	
	import com.soma.vo.TransitionVO;	
	
	/**
	 * <b>Author:</b> Romuald Quantin - <a href="http://www.soundstep.com/" target="_blank">www.soundstep.com</a><br />
	 * <b>Class version:</b> BETA 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 * <b>Copyright:</b>
	 * <br />
	 * <b>Date:</b> 05-2008<br />
	 * <b>Usage:</b>
	 * @example
	 * <listing version="3.0"></listing>
	 */

	public interface ITransition {
		
		function execute(item:Object, id:String = null, transition:TransitionVO = null):Object;
		function stop(item:Object):void;
		function stopAll():void;
		
	}

}