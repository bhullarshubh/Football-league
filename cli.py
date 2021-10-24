#!/usr/bin/env python3

from getpass import getpass
from shlex import quote
import pymysql
import pymysql.cursors
import subprocess as sp

def printrecords(records):
    """
    Take a list of matched records from a query, each of which is a dictionary,
    and print them out nicely.
    """
    for record in records:
        for key in record:
            print(key + ": " + str(record[key]))

def inputvalues(params_types: dict):
    """
    Take a dict with key-val pairs of (parameter, type)
    """
    params = {}
    for var in params_types:
        val = input(f'Please enter {var} ({params_types[var]}): ')
        params[var] = val
    return params

def insertintotable(params: dict, table):
    """
    Given the list of params to insert and the table to insert into,
    construct the required SQL query and execute it.
    """
    fields = list(params.keys())
    types = list(params.values())
    vals = list(inputvalues(params).values())

    for id, type in enumerate(types):
        if type == 'string':
            vals[id] = "'" + quote(vals[id]) + "'"

    query = f"INSERT INTO {table} ({', '.join(fields)}) VALUES ({', ' .join(vals)});"

    # TODO: Remove debug print()
    print("CONSTRUCTED QUERY: " + query)

    cur.execute(query)
    con.commit()

def insertStadium():
    params = {
        'ID': 'int',
        'Name': 'string',
        'Address': 'string',
        'City': 'string',
        'Country': 'string',
        'Capacity': 'int'
    }

    insertintotable(params, 'Stadium')

# Global - Main loop
while(1):
    # tmp = sp.call('clear', shell=True)
    # Can be skipped if you want to hardcode username and password

    username = input("Username: ")
    password = getpass(prompt="Password: ")
    port = int(input("Port: "))

    try:
        # Set db name accordingly which have been create by you
        # Set host to the server's address if you don't want to use local SQL server 
        con = pymysql.connect(host='localhost',
                              port=port,
                              user=username,
                              password=password,
                              db='game',
                              cursorclass=pymysql.cursors.DictCursor)
        # tmp = sp.call('clear', shell=True)

        if(con.open):
            print("Connected")
        else:
            print("Failed to connect")

        tmp = input("Enter any key to CONTINUE>")

        with con.cursor() as cur:
            while(1):
                # tmp = sp.call('clear', shell=True)

                # Here taking example of Employee Mini-world
                # TODO: Print set of choices

                choices = [ 'insertStadium' ]

                for id, choice in enumerate(choices):
                    print(id, choice)

                ch = int(input("Enter choice> "))
                # tmp = sp.call('clear', shell=True)

                eval(choices[ch])()
                tmp = input("Enter any key to CONTINUE>")

    except Exception as e:
        # tmp = sp.call('clear', shell=True)
        print(e)
        print("Connection Refused: Either username or password is incorrect "
              "or user doesn't have access to database")
        tmp = input("Enter any key to CONTINUE>")
