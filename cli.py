#!/usr/bin/env python3

from getpass import getpass
from shlex import quote
import pymysql
import pymysql.cursors

def printrecords(records):
    """
    Take a list of matched records from a query, each of which is a dictionary,
    and print them out nicely.
    """
    print('---')
    for record in records:
        for key in record:
            print(key + ": " + str(record[key]))
        print('---')

def inputvalues(params_types: dict):
    """
    Take a dict with key-val pairs of (parameter, type)
    """
    params = {}
    for var in params_types:
        val = input(f'Please enter {var} ({params_types[var]}): ')
        # Handle NULL input
        if val == '':
            params[var] = pymysql.NULL
        else:
            params[var] = val
    return params

def insertintotable(params: dict, vals, table):
    """
    Given the list of params with values vals to insert, and the table to insert into,
    construct the required SQL query and execute it.
    """
    fields = list(params.keys())
    types = list(params.values())

    for id, type in enumerate(types):
        if type == 'string' and vals[id] is not pymysql.NULL:
            vals[id] = "'" + quote(vals[id]) + "'"

    try:
        query = f"INSERT INTO {table} ({', '.join(fields)}) VALUES ({', ' .join(vals)});"

        # TODO: Remove debug print()
        print("CONSTRUCTED QUERY: " + query)

        cur.execute(query)
        con.commit()
    except Exception as e:
        con.rollback()
        print(f"Error: {e}")

def insertTeam():
    params = {
        'Name': 'string',
        'Country': 'string',
        'StadiumID': 'int',
        'ManagerID': 'int'
    }

    inputdict = inputvalues(params)

    try:
        # Check if not already mapped to some other team
        query = f"SELECT * FROM team WHERE StadiumID = {inputdict['StadiumID']};"
        if cur.execute(query):
            print("Stadium already mapped to some other team")
            return

        query = f"SELECT * FROM team WHERE ManagerID = {inputdict['ManagerID']};"
        if cur.execute(query):
            print("Manager already mapped to some other team")
            return

        # Get players (not assigned to any team)
        cur.execute(f"SELECT ID FROM Player WHERE TeamID IS NULL;")
        players = cur.fetchall()

        if len(players) < 11:
            print("Not enough players to make a new team")
            return

        # insert team
        insertintotable(params, list(inputdict.values()), 'team')
        teamid = cur.lastrowid # get teamid of the just inserted team
        
        # Assign eleven players to this team
        for i in range(11):
            cur.execute(f"UPDATE Player SET TeamID = {teamid}, PlayingEleven = 1 WHERE ID = {players[i]['ID']}")
        
        con.commit()

    except Exception as e:
        print(f"Error: {e}")
        return

def removeTeam():
    id = input('Please enter Team ID: ')

    try:
        # Player TeamID set null on delete by our referential constraints 
        ret = cur.execute(f"DELETE FROM Team WHERE ID = {id}")
        con.commit()
        
        if ret:
            print("Team removed successfully")
        else:
            print("No Team found with that ID")

    except Exception as e:
        print(f"Error: {e}")
        return

def insertStadium():
    params = {
        'Name': 'string',
        'Address': 'string',
        'City': 'string',
        'Country': 'string',
        'Capacity': 'int'
    }

    insertintotable(params, list(inputvalues(params).values()), 'stadium')

def getPlayer():
    id = input('Please enter Player ID: ')
    try:
        query = f"SELECT * FROM player WHERE ID = {id}"

        ret = cur.execute(query)
        if ret:
            printrecords(cur.fetchall())
        else:
            print("No player found with that ID.")
    
    except Exception as e:
        print(f"Error: {e}")
        return

def searchPlayer():
    print("Please enter the search parameters. Any parameters not entered will not be considered in the search.")

    name = input("Name: ")
    nationality = input("Nationality: ")
    team = input("Team Name: ")

    query = "SELECT * from player LEFT join team on player.TeamID=team.ID"

    if any([name, nationality, team]):
        query += " WHERE "

        # Start with clauses empty by default, fill them if specified
        nameclause, nationalityclause, teamclause = "", "", ""

        if name:
            teamclause += f"CONCAT(FirstName,MiddleName,LastName) LIKE '%{name}%'"
        if nationality:
            nationalityclause += f"Nationality LIKE '%{nationality}%'"
        if team:
            teamclause += f"Name LIKE '%{team}%'"

        # Remove empty clauses if any
        conditions = list(filter(lambda x: x,[nameclause, nationalityclause, teamclause]))

        # Join non empty clauses into a single conditional
        query += " AND ".join(conditions)

        # TODO: remove debug print
        # print(f"CONSTRUCTED QUERY: {query}")

        try:
            if cur.execute(query):
                printrecords(cur.fetchall())

        except Exception as e:
            print(f"Error: {e}")

    else:
        print("You must enter at least one of the search parameters!")


def searchTeam():
    name = input("Name: ")

    query = f"SELECT * FROM team WHERE Name LIKE '%{name}%'"

    try:
        if cur.execute(query):
            printrecords(cur.fetchall())

    except Exception as e:
        print(f"Error: {e}")

def quit():
    exit()

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

                choices = [
                    'quit',
                    'insertStadium',
                    'searchPlayer',
                    'getPlayer',
                    'insertTeam',
                    'removeTeam'
                ]

                for id, choice in enumerate(choices):
                    print(str(id) + ") " + choice)

                ch = int(input("Enter choice> "))
                # tmp = sp.call('clear', shell=True)

                try:
                    eval(choices[ch])()
                except IndexError:
                    print("Invalid choice! Please enter the number corresponding to one of the given choices.")

    except Exception as e:
        # tmp = sp.call('clear', shell=True)
        print(e)
        print("Connection Refused: Either username or password is incorrect "
              "or user doesn't have access to database")
        tmp = input("Enter any key to CONTINUE>")
