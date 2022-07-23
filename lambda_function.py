import json
import boto3
import sys
import logging
import pymysql
import requests

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def get_secret_value(name, version=None):
    """
    Function to get the Secret Manager Value
    """

    try:
        secrets_client = boto3.client("secretsmanager")
        kwargs = {'SecretId': name}
        if version is not None:
            kwargs['VersionStage'] = version
        response = secrets_client.get_secret_value(**kwargs)
        secret_value = response["SecretString"]

        if secret_value:
            return secret_value
        else:
            raise Exception("secret value is Null")

    except Exception as e:
        raise Exception(f"Error while retrieving secret value {name} - {e}")
    
def call_api(parameter_url,api_key):
    """
    Function to call the API and get the result
    """

    try:
        api_url = f"https://sample/api/Product?items={parameter_url}"
        logger.info(f"Calling API - {api_url}")

        headers = {'apikey': api_key}
        logger.info(f"Headers - {headers}")
        response = requests.request("GET", api_url, headers=headers)
        data=json.loads(response.text)["data"]

        return data

    except Exception as e:
        logger.error(f"Error while calling API - {e}")

try:
    """
    To connect with DB
    """

    password = get_secret_value("rds-pass1")
    name = get_secret_value("rds-user1")
    rds_host = "Your rds"
    db_name = "db name"

    conn = pymysql.connect(host=rds_host, user=name, passwd=password, db=db_name, connect_timeout=5,autocommit=True)

except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()

logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")

def lambda_handler(event, context):
    
    items=[]
    api_key = get_secret_value("api-key1")

    #get item from DB
    with conn.cursor() as cur:
        cur.execute("select Product from gsddb_product")
        for row in cur:
            logger.info(row[0])
            items.append(row[0])
            
    for i in range(0, len(items), 10):
        parameter = (",".join(items[i:i+10]))

        #call API
        returned_data = call_api(parameter,api_key)

        for item in returned_data:
            logger.info(f"Available Order - {item['available_order']} and Item {item['item_id']}")
            
            #Store result in Mysql
            query=f"update gsddb_product set Stock={item['available_order']} where Product='{item['item_id']}'"
            with conn.cursor() as cur:
                cur.execute(query)
    
    logger.info("Done from with the cycle")