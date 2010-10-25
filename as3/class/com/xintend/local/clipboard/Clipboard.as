package com.xintend.local.clipboard {
	
	import com.xintend.events.RichEvent;
	import flash.events.EventDispatcher;
	import flash.system.System;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public class Clipboard extends EventDispatcher implements IClipboard {
		
		public static const CONTENT_READY: String = "contentReady";
		public static const CLIPBOARD_CLEAR: String = "clipboardClear";
		public static const CLIPBOARD_SET: String = "clipboardSet";
		
		
		
		public function get allowDesktopClipboardAccess():Boolean { return _allowDesktopClipboardAccess; }
		
		public function Clipboard() {
			init();
		}
		
		public function getData(format: String = "text", transferMode: String = "originalPreferred"):*{
			var fmt: String = matchFormat(format);
			if (_allowDesktopClipboardAccess) {
				return ClipboardClass.generalClipboard.getData(fmt,transferMode);
			}
			return data;
		}
		
		public function setData(data:*, format: String = "text", serializable:Boolean = true): void {
			this.data = data;
			var fmt: String = matchFormat(format);
			if (_allowDesktopClipboardAccess) {
				functionPool.push(new ExecuteItem(ExecuteItem.SET,ClipboardClass.generalClipboard,"setData", [fmt,data,serializable]));
				return;
			}
			functionPool.push(new ExecuteItem(ExecuteItem.SET, System, "setClipboard", [data]));
		}
		
		public function clearData(format: String = null): void {
			data = null;
			var fmt: String = matchFormat(format);
			if (_allowDesktopClipboardAccess) {
				if (format) {
					functionPool.push(new ExecuteItem(ExecuteItem.CLEAR,ClipboardClass.generalClipboard,"clearData",[data,fmt]));
				}else {
					functionPool.push(new ExecuteItem(ExecuteItem.CLEAR,ClipboardClass.generalClipboard,"clear"));
				}
				return;
			}
			functionPool.push(new ExecuteItem(ExecuteItem.CLEAR, System, "setClipboard", [""]));
		}
		
		public function hasFormat(format: String): Boolean {
			var fmt: String = matchFormat(format);
			if (_allowDesktopClipboardAccess) {
				return ClipboardClass.generalClipboard.hasFormat(fmt);
			}
			return false;
		}
		
		public function setDataHandler(format: String, handler: Function, serializable: Boolean = true): Boolean {
			var fmt: String = matchFormat(format);
			if (_allowDesktopClipboardAccess) {
				return ClipboardClass.generalClipboard.setDataHandler(fmt,handler,serializable);
			}
			return false;
		}
		
		public function execute(): void {
			var execi: ExecuteItem;
			trace("functionPool",functionPool.length)
			while (functionPool.length) {
				execi = functionPool.shift() as ExecuteItem
				switch(execi.tag) {
					case ExecuteItem.CLEAR:
						dispatchEvent(new RichEvent(CLIPBOARD_CLEAR));
					break;
					case ExecuteItem.SET:
						dispatchEvent(new RichEvent(CLIPBOARD_SET,false,true,{data:execi.args[0]}));
					break;
				}
				execi.execute();
			}
		}
		
		
		protected function init(): void {
			var type: String;
			try {
				ClipboardClass = getDefinitionByName("flash.desktop.Clipboard") as Class;
				type = ClipboardType.RICH_CLIPBOARD;
			}catch (e: Error) {
				_allowDesktopClipboardAccess = false;
				type = ClipboardType.SIMPLE_CLIPBOARD;
			}
			dispatchEvent(new RichEvent(CONTENT_READY,false,true,{type:type}));
		}
		
		protected function matchFormat(format: String): String {
			var fmt: String;
			switch(format) {
				case "html":
					fmt = ClipboardFormats.HTML_FORMAT;
				break;
				case "rtf":
					fmt = ClipboardFormats.RICH_TEXT_FORMAT;
				break;
				case "bitmap":
					fmt = ClipboardFormats.BITMAP_FORMAT;
				break;
				case "fileList":
					fmt = ClipboardFormats.FILE_LIST_FORMAT;
				break;
				case "filePromiseList":
					fmt = ClipboardFormats.FILE_PROMISE_LIST_FORMAT;
				break;
				case "url":
					fmt = ClipboardFormats.URL_FORMAT;
				break;
				default:
					fmt = ClipboardFormats.TEXT_FORMAT;
			}
			return fmt;
		}
		
		
		private var ClipboardClass: Class;
		// 方法池
		private var functionPool: Array = [];
		
		private var data:*;
		
		private var _allowDesktopClipboardAccess: Boolean = true;
		
	}

}


class ExecuteItem {
	
	public static const SET:String = "set"
	public static const CLEAR:String = "clear"
	public static const CHECK:String = "check"
	
	
	public var obj: *;
	public var func: String;
	public var args: Array;
	public var tag: String;
	public function ExecuteItem(tag: String,obj: *, func: String, args: Array = null) {
		this.obj = obj;
		this.func = func;
		this.args = args;
		this.tag = tag;
	}
	
	public function execute(): void {
		trace(obj,func,args);
		obj[func].apply(obj,args);
	}
}