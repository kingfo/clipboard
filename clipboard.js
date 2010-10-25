/**
 * @author kingfo  oicuicu@gmail.com
 */
AJBridge.add('clipboard', function(A) {

    var S = KISSY;

    /**
     * @constructor
     * @param {String} id                                    需要注册的SWF应用ID
     * @param {Object} config                                配置项
     * @param {String} config.data                           配置数据.仅在 copy | cut 两种模式下有效
     * @param {Boolean} config.format                        数据格式. 当且仅当是富粘贴板时有效，即初始化后获得 richClipboard 事件时有效。
     * @param {Boolean} config.btn                           启用按钮模式，默认 false
     * @param {Boolean} config.hand                          显示手型，默认 false
     */
    function Clipboard(id, config) {
        config = config || { };
        var flashvars = { };

        S.each(['data', 'format', 'btn', 'hand'], function(key) {
            if(key in config) flashvars[key] = config[key];
        });

        config.params = config.params || { };
        config.params.flashvars = S.merge(config.params.flashvars, flashvars);

        Clipboard.superclass.constructor.call(this, id, config);
    }

    S.extend(Clipboard, A);

    A.augment(Clipboard,
        [
			/**
			 * 获取数据
			 * @param	type:String				指定获取的类型，如果未指定或者不包含 则返回 null 或 String 类型。
			 * @param	transferMode:String		指定在访问应用程序定义的数据格式时是返回一个引用还是返回序列化副本。
			 * @return
			 */
            'getData',
			/**
			 * 删除指定格式的数据表示形式。
			 * @param	format:String			如果没有值则从此 Clipboard 对象中删除所有数据表示形式。 		
			 */   
            'clearData',
            /**
			 * 设置数据。注意，这个并不直接写入粘贴板。需要捕获用户输入后执行 execute();
			 * @param	data					任何数据。当然需要粘贴板支持。
			 * @param	format:String			粘贴数据的格式。当然，目前仅支持 纯文本 text 和  HTML。
			 * @param	serializable:Boolean	为可以序列化（和反序列化）的对象指定 true。
			 */
            'setData'
        ]
        );

    Clipboard.version = '1.0.0';
    A.Clipboard = Clipboard;
});
