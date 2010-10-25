package {
	import com.xintend.local.clipboard.Clipboard;
	//import com.xintend.local.clipboard.ClipboardMode;
	import com.xintend.trine.ajbridge.AJBridge;
	import flash.display.ActionScriptVersion;
	import flash.display.Sprite;
	import flash.display.SWFVersion;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.getClassByAlias;
	import flash.system.Security;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class Main extends Sprite {
		
		public function Main(): void {
			
			Security.allowDomain("*");
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			var params: Object = stage.loaderInfo.parameters;
			var callbacks: Object = { };
			
			stage.scaleMode = "noScale";
			stage.align = "TL";
			
			// 1.获取外部配置
			AJBridge.init(stage);
			
			
			
			
			// 2.创建并配置实例
			clipboard = new Clipboard();
			clipboard.addEventListener(Clipboard.CONTENT_READY, clipboardEventHandler);
			clipboard.addEventListener(Clipboard.CLIPBOARD_CLEAR, clipboardEventHandler);
			clipboard.addEventListener(Clipboard.CLIPBOARD_SET, clipboardEventHandler);
			
			
			callbacks.getData =  clipboard.getData;
			callbacks.clearData =  clipboard.clearData;
			callbacks.setData =  clipboard.setData;
			//callbacks.switchTo = switchTo;
			
			
			data = params["data"];
			format = params["format"];
			
			hand = params["hand"] || false;
			btn = params["btn"] ||  false;
			
			//switchTo(params["mode"]);
			
			
			
			hotspot = new Sprite();
			hotspot.addEventListener(Event.RESIZE, hotspotResize);
			hotspot.buttonMode = btn;
			hotspotResize();
			hotspot.addEventListener(MouseEvent.CLICK, mouseHandler);
			
			addChild(hotspot);
			
			if (hand || btn) {
				useHand(hand);
				setBtnMode(btn);
			}
			
			AJBridge.addCallbacks(callbacks);
			AJBridge.ready();
			
			
		}
		
		private function hotspotResize(e:Event=null):void {
			hotspot.graphics.clear();
			hotspot.graphics.beginFill(0,0);
			hotspot.graphics.drawRect(0, 0, stage.stageWidth,stage.stageHeight);
			hotspot.graphics.endFill();
		}
		
		private function useHand(value:Boolean):void{
			hotspot.useHandCursor = value;
		}
		
		private function setBtnMode(value:Boolean):void{
			if (value) {
				hotspot.addEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
				hotspot.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				hotspot.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				hotspot.addEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			}else {
				hotspot.removeEventListener(MouseEvent.MOUSE_OVER, mouseHandler);
				hotspot.removeEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
				hotspot.removeEventListener(MouseEvent.MOUSE_UP, mouseHandler);
				hotspot.removeEventListener(MouseEvent.MOUSE_OUT, mouseHandler);
			}
		}
		
		//private function switchTo(mode:String):void{
			//switch(mode) {
				//case ClipboardMode.PASTE_MODE:
					//mode = ClipboardMode.PASTE_MODE;
				//break;
				//case ClipboardMode.CLEAR_MODE:
					//mode = ClipboardMode.CLEAR_MODE;
				//break;
				//case ClipboardMode.CUT_MODE:
					//mode = ClipboardMode.CUT_MODE;
				//break;
				//default:
					//mode = ClipboardMode.COPY_MODE;
			//}
		//}
		
		private function mouseHandler(e: MouseEvent): void {
			switch(e.type) {
				case MouseEvent.CLICK:
					clipboard.execute();
				break;
			}
			
			// 鼠标事件需要单独转换  
			// 否则会堆栈溢出
			// flash 自身 bug ?
			AJBridge.sendEvent({type:e.type});
		}
		
		private function clipboardEventHandler(e:Event):void {
			AJBridge.sendEvent(e);
		}
		
		
		private var clipboard: Clipboard;
		//private var mode: String;
		
		private var data:*;
		private var format:*;
		private var hotspot: Sprite;
		private var hand: Boolean;
		private var btn: Boolean;
	}
	
}