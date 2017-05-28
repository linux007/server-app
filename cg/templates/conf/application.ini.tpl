[common]
application.directory = APPLICATION_PATH  "/application"
application.modulesdirectory = APPLICATION_PATH  "/application/modules"
application.dispatcher.catchException = TRUE

;默认控制器
application.dispatcher.defaultModule = index
;application.view.ext	= phtml #默认phtml
application.modules		= index,Api,Admin

[product : common]
