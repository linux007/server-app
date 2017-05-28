<?php
/**
 * Created by PhpStorm.
 * User: linux
 * Date: 17/5/28
 * Time: 下午6:22
 */

namespace app\server;

require APPLICATION_PATH . '/vendor/autoload.php';

use app\library\Swoole2Yaf;
use base\server\WorkerHttp;
use Yaf\Application;
use Yaf\Loader;

class ServerHttp extends WorkerHttp {

    protected $application = null;

    public function onWorkerStart(\swoole\server $server, $wokerId)
    {
        ob_start();

        $this->_initApp();

        ob_end_clean();
    }

    public function onRequest(\swoole\http\request $request, \swoole\http\response $response)
    {
        // TODO: Implement onRequest() method.
//        $data = 'hello world';
//        $response->end($data);
        ob_start();

        $yafRequest = Swoole2Yaf::getInstance()->setRequest($request);
        $yafRequest->init();

        $this->application->getDispatcher()->dispatch($yafRequest->getYafReq());

        $result = ob_get_contents();
        ob_end_clean();

        $response->header('Content-Type', 'text/html; charset=UTF-8');

        foreach ($_COOKIE as $k => $val)
            $response->cookie($k, $val);
        // set status
        $response->end($result);
    }


    private function _initApp() {
        \Yaf\Loader::import(APPLICATION_PATH . '/application/library/Swoole2Yaf.php');

        if (null == $this->application) {
            $this->application = new Application(
                APPLICATION_PATH . '/conf/application.ini'
            );

            $this->application->getDispatcher()->catchException(true);
            $this->application->bootstrap();
        }

        return $this;
    }
}