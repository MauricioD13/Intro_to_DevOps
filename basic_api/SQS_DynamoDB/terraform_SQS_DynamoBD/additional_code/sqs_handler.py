import json
import boto3

def lambda_handler(event, context):
    # Inicializar clientes
    dynamodb = boto3.resource('dynamodb')
    table = dynamodb.Table('recipes_table')
    
    # Procesar cada registro del evento SQS
    for record in event['Records']:
        # Obtener el cuerpo del mensaje
        message = json.loads(record['body'])
        
        # Escribir en DynamoDB
        table.put_item(Item=message)
    
    return {
        'statusCode': 200,
        'body': json.dumps('Procesamiento completado')
    }