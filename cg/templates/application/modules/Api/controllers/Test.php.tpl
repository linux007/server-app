<?php
/**
 * @name IndexController
 * @author linux
 * @desc 默认控制器
 * @see http://www.php.net/manual/en/class.yaf-controller-abstract.php
 */
class TestController extends Yaf\Controller_Abstract {

	/** 
     * 默认动作
     * Yaf支持直接把Yaf\Request_Abstract::getParam()得到的同名参数作为Action的形参
     * 对于如下的例子, 当访问http://yourhost/app/index/index/index/name/linux 的时候, 你就会发现不同
     */
	public function indexAction($name = "Stranger") {
		//1. fetch query
		$get = $this->getRequest()->getQuery("get", "default value");

		//2. fetch model
		$model = new SampleModel();

		//3. assign
		$this->getView()->assign("content", $model->selectSample());
		$this->getView()->assign("name", $name);

		//4. render by Yaf, 如果这里返回FALSE, Yaf将不会调用自动视图引擎Render模板
        return TRUE;
	}

	public function testAction() {
		$queryFactory = new \Aura\SqlQuery\QueryFactory('mysql');
		$select = $queryFactory->newSelect();

		$select
			->cols([
			'id',                       // column name
			'name AS namecol',          // one way of aliasing
			'col_name' => 'col_alias',  // another way of aliasing
			'COUNT(foo) AS foo_count'   // embed calculations directly
			])
			->from('foo')
			->where('bar > ?', ['bar_val']);

		echo $select->getStatement();
	    echo 'hello modules' . PHP_EOL;
	    return false;
    }

	public function dbAction() {
		$config = new Yaf\Config\Ini(APPLICATION_PATH . '/conf/database.ini');
		$config = $config->toArray();

		$conn = base\component\database\DriverManager::getConnection('default', $config);

		$queryFactory = $conn->getQueryFactory();
		$select = $queryFactory->newSelect();

		$select
			->cols([
			'id',                       // column name
			'name AS namecol',          // one way of aliasing
			])
			->from('crontab')
			->where('id = :id')
			->bindValue('id', 7);

		//		echo $select->getStatement() . PHP_EOL;
		//
		//		print_r($select->getBindValues());
		//
		//		$result = $conn->fetchOne($select->getStatement(), $select->getBindValues());

		//		print_r($result);

		$insert = $queryFactory->newInsert();
		$insert->into('crontab')
		->cols([
		'name' => 'test2',
		'command' => '/bin/echo \test2\'',
		'schedule' => '* * * * * *',
		'hostname' => '192.168.56.5',
		'createAt' => time(),
		'updateAt' => time()
		]);

		echo $insert->getStatement();

		$affected = $conn->exec($insert->getStatement(), $insert->getBindValues());

		echo $affected;
		return false;
	}
}
