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
        if (type == 'string' or type == 'YYYY-MM-DD') and vals[id] is not pymysql.NULL:
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
        cur.execute(f"SELECT ID FROM player WHERE TeamID IS NULL;")
        players = cur.fetchall()

        if len(players) < 11:
            print("Not enough players to make a new team")
            return

        # insert team
        insertintotable(params, list(inputdict.values()), 'team')
        teamid = cur.lastrowid # get teamid of the just inserted team
        
        # Assign eleven players to this team
        for i in range(11):
            cur.execute(f"UPDATE player SET TeamID = {teamid}, PlayingEleven = 1 WHERE ID = {players[i]['ID']}")
        
        con.commit()

    except Exception as e:
        print(f"Error: {e}")
        return

def removeTeam():
    id = input('Please enter Team ID: ')

    try:
        # Player TeamID set null on delete by our referential constraints 
        ret = cur.execute(f"DELETE FROM team WHERE ID = {id}")
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

def insertManager():
    params = {
        'FirstName': 'string',
        'MiddleName': 'string',
        'LastName': 'string',
        'DOB': 'YYYY-MM-DD',
        'Nationality': 'string'
    }

    insertintotable(params, list(inputvalues(params).values()), 'manager')

def removeManager():
    
    id = input('Please enter Manager ID: ')
    try:
        ret = cur.execute(f"DELETE FROM manager WHERE ID = {id}")
        con.commit()
        
        if ret:
            print("Manager removed successfully")
        else:
            print("No Manager found with that ID")

    except pymysql.Error as e:
        # manager mapped to some team
        # remove this manager only if we can allot another manager to the team
        cur.execute(f"SELECT ID FROM manager WHERE ID NOT IN (SELECT ManagerID FROM team);")
        managers = cur.fetchall()
        if len(managers) == 0:
            print("Manager mapped to a team; No free managers exist")
        else:
            try:
                cur.execute(f"UPDATE team SET ManagerID ={managers[0]['ID']} WHERE ManagerID = {id}")
                cur.execute(f"DELETE FROM manager WHERE ID = {id}")
                con.commit()
                print("Manager removed successfully")
            except Exception as e:
                print(f"Error: {e}")
    except Exception as e:
        print(f"Error: {e}")
        return

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

def getGoalscorers():
    try:
        query = """
        SELECT a.ID, CONCAT(FirstName, ' ', 
        (CASE
        WHEN MiddleName IS NULL THEN ''
        ELSE CONCAT(MiddleName, ' ')
        END),  LastName) 
        as PlayerName FROM (select distinct(PlayerID) as ID from goal) a, player b where a.ID = b.ID
        """

        ret = cur.execute(query)
        if ret:
            printrecords(cur.fetchall())
        else:
            print("No Goal Scorers")
    
    except Exception as e:
        print(f"Error: {e}")
        return

def getAvgGoalsScored():
    try:
        query = "select sum(HomeScore + AwayScore)/count(MatchID) as AvgGoalsScored from result"
        cur.execute(query)
        printrecords(cur.fetchall())
        
    except Exception as e:
        print(f"Error: {e}")
        return

def getPlayingEleven():
    id = input('Please enter Team ID: ')

    try:
        ret = cur.execute(f"SELECT * FROM player WHERE TeamID = {id} AND PlayingEleven = 1")
        
        if ret:
            printrecords(cur.fetchall())
        else:
            print("No Team found with that ID")

    except Exception as e:
        print(f"Error: {e}")
        return

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
                    'getPlayer',
                    'insertTeam',
                    'removeTeam',
                    'insertManager', 
                    'removeManager',  
                    'getGoalscorers',
                    'getAvgGoalsScored',
                    'getPlayingEleven',
                    
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
