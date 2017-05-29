<?php

/**
 * swoole_http_request 转换为 Yaf_Request_Http
 * Created by PhpStorm.
 * User: linux
 * Date: 17/5/28
 * Time: 下午8:17
 */
namespace app\library;

class Swoole2Yaf {

    protected $swooleReq = null;
    protected $yafReq = null;

    private static $instance = null;

    protected function __construct()
    {
        $this->yafReq = $this->getYafReq();

    }

    public function setRequest(swoole\http\request $request) {
        $this->swooleReq = $request;
        return $this;
    }

    public static function getInstance() {
        if (is_null(self::$instance)) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public function __destruct()
    {
        //初始化
        foreach ($_SERVER as $key => $val) {
            if (strpos($key, 'HTTP_') === 0) {
                unset($_SERVER[$key]);
            }
        }
        $_COOKIE = array();
    }

    public function init()
    {
        $params = [];

        if (isset($this->swooleReq->get)) {
            $params = $this->swooleReq->get;
        }

        if (isset($this->swooleReq->post)) {
            $params = array_merge($params, $this->swooleReq->post);
        }

        var_dump($this->swooleReq);
        exit;
//        $request_uri = $this->swooleReq->server['request_uri'];
//
//        $this->_setRouter($request_uri)->_setUriParams($params);
//        $this->getYafReq()->method = $this->swooleReq->server['request_method'];
//        $this->_initHeader()->_initCookie();
//        $this->getYafReq()->setDispatched(true);
//        $this->getYafReq()->setRouted(true);
    }


    protected function _setRouter($baseUri) {
        $baseUriArr = explode('/', trim(strtolower($baseUri), '/'));
        if (empty(array_filter($baseUriArr))) {
            return true;
        }

        $this->getYafReq()->setModuleName($baseUriArr[0]);
        if (isset($baseUriArr[1])) {
            $this->getYafReq()->setControllerName($baseUriArr[1]);
        } else {
            $this->getYafReq()->setControllerName('index');
        }
        if (isset($baseUriArr[2])) {
            $this->getYafReq()->setActionName($baseUriArr[2]);
        } else {
            $this->getYafReq()->setActionName('index');
        }
        $this->getYafReq()->setRequestUri(
            strtolower(
                $this->getYafHttp()->getModuleName() . '/' . $this->getYafHttp()->getControllerName()
                . '/' . $this->getYafHttp()->getActionName() . '/'
            )
        );
        return $this;
    }


    protected function _setUriParams($params)
    {
        if (is_array($params) && $params) {
            foreach ($params as $key => $val) {
                $this->getYafHttp()->setParam($key, $val);
            }
        }
    }

    protected function _initHeader()
    {
        if (isset($this->swooleReq->header)) {
            foreach ($this->swooleReq->header as $key => $val) {
                $headerKey = 'HTTP_' . strtoupper(str_replace('-', '_', $key));
                if (!isset($_SERVER[$headerKey])) {
                    $_SERVER[$headerKey] = $val;
                }
            }
        }
        return $this;
    }

    protected function _initCookie()
    {
        if (isset($this->swooleReq->cookie)) {
            foreach ($this->swooleReq->cookie as $key => $val) {
                if (!isset($_COOKIE[$key])) {
                    $_COOKIE[$key] = $val;
                }
            }
        }
        return $this;
    }

    public function getYafReq() {
        if (null == $this->yafReq) {
            $this->yafReq = new \Yaf\Request\Http();
        }
        return $this->yafReq;
    }
}