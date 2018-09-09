<?
require __DIR__ . '/vendor/autoload.php';
use Aws\Ssm\SsmClient;

$parameters = "";
$path = "/";
try {
    $client = new SsmClient(["version" => "latest", "region" => "us-east-1"]);
    $results = $client->getParametersByPath(['Path' => $path, 'WithDecryption' => true]);
    foreach ($results['Parameters'] as $parameter) {
	$key = str_replace($path, "", $parameter['Name']);
        $this->parameters[$key] = $parameter['Value'];
    }
    $connection = new PDO("mysql:host=".$parameters['DB_URI'].";dbname=jez-workshop;charset=utf8", "workshop", $parameters['DB_PASSWORD']);
} catch (Exception $e) {
    http_response_code(500);
    error_log("Couldn't create database connection. Error: ".$e->getMessage());
}
?>
