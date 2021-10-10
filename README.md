## Installation Instructions

### MySQL

Although you haven't strictly been told to explicitly use MySQL, it is highly recommended. To install and run MySQL on a Docker container, follow the [instructions we sent previously](https://rvk7895.notion.site/rvk7895/Instructions-to-install-MySQL-in-Docker-b91ff88693544d639abcd30844a2ff86).

### PyMySQL

Again, although you weren't explicitly told to use PyMySQL it is recommended that you do. That being said, you CANNOT use Pandas or any other Python library for the project. PyMySQL is an interface for connection to the MySQL server from Python.

To install PyMySQL, you can use one of the two routes  

### Pip

``` bash
pip install PyMySQL
```

### Conda

``` bash
conda install -c anaconda pymysql
```

## Boilerplate

We have provided a boilerplate piece of code just to get you started. The only reason this boiler plate is being shared is to show you what an acceptable UI looks like. You can decide to not use the boilerplate if you feel that you have already implemented a similar flow for your application.

### To Run

To run the boilerplate code, you will need to login with your MySQL username and password (the boilerplate code has the username, password, and port hardcoded to work with the Docker installation instructions).

``` bash
python3 boilerPlate.py
```

This will prompt for you to enter your username and password.

### UI Interface

Due to the timeline, you are not expected to implement a graphical UI (although you aren't disallowed either). A CLI (Command Line Interface) will suffice for the sake of the project.

You can also have different interfaces depending on which kind of user logged in to your software.Taking here the example of the EMPLOYEE Database, under the assumption that someone from adminstration logged into, the UI will look something like this.

```
1. Hire a new employee
2. Fire an employee
3. Promote an employee
4. Employee Statistics
5. Logout

Enter Choice > 
```

The boiler plate has a similar interface. Only one function has been implemented in the code provided. But it's enough to give you an idea about what you have to do.

### Error Handling

Although in this code, error handling hasn't explicitly been handled, you have to handle errors appropriately.  

For example, if you try to delete a department, you can only do so after you've reassigned all the employess to another department. Or if you want to fire the manager of a department, you can only do so after assigning the department a new manager (where again, yes, the manager has to satisfy the foreign key constrain i.e. should be an employee himself)

Instead of handling all the errors yourself, you can make use of error messages which MySQL returns. [You might find this useful to implement when you want to debug as well](https://stackoverflow.com/questions/25026244/how-to-get-the-mysql-type-of-error-with-pymysql).

``` python
try:
    do_stuff()
except Exception as e:
    print (e)
```

## Creating Dump File For MySQL

If you plan to use MySQL. The database dump file can be created using

``` bash
mysqldump -u username -p databasename > filename.sql
```


## Resources

* https://www.python.org/dev/peps/pep-0249/
* https://dev.mysql.com/doc/connector-python/en/
* http://zetcode.com/python/pymysql/
* https://www.tutorialspoint.com/python3/python_database_access.htm
* https://o7planning.org/en/11463/connecting-mysql-database-in-python-using-pymysql
* https://www.journaldev.com/15539/python-mysql-example-tutorial
