package com.xintend.local.clipboard  {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public interface IClipboard{
		
		/**
		 * 获取数据
		 * @param	type				指定获取的类型，如果未指定或者不包含 则返回 null 或 String 类型。
		 * @param	transferMode		指定在访问应用程序定义的数据格式时是返回一个引用还是返回序列化副本。
		 * @return
		 */
		function getData(format: String = "text",transferMode:String="originalPreferred"): * ;
		/**
		 * 设置数据。注意，这个并不直接写入粘贴板。需要捕获用户输入后执行 execute();
		 * @param	data				任何数据。当然需要粘贴板支持。
		 * @param	format				粘贴数据的格式。当然，目前仅支持 纯文本 text 和  HTML。
		 * @param	serializable		为可以序列化（和反序列化）的对象指定 true。
		 */
		function setData(data:*, format: String = "text",serializable:Boolean = true): void;
		/**
		 * 删除指定格式的数据表示形式。
		 * @param	format				如果没有值则从此 Clipboard 对象中删除所有数据表示形式。 		
		 */
		function clearData(format:String=null): void;
		/**
		 * 检查指定格式的数据在此 Clipboard 对象中是否存在。 
		 * @param	format				要检查的格式类型. 
		 * @return
		 */
		function hasFormat(format: String): Boolean;
		/**
		 * 添加对某个处理函数的引用，该函数根据需要生成指定格式的数据。
		 * @param	format				数据的格式
		 * @param	handler				调用时可返回要传输的数据的函数。
		 * @param	serializable		如果由 handler 返回的对象可以序列化（和反序列化），则指定 true
		 * @return
		 */
		function setDataHandler(format: String, handler: Function, serializable: Boolean = true): Boolean;
		/**
		 * 将数据写入或者从中删除。由捕获的用户事件激发。
		 */
		function execute(): void;
		
	}

}