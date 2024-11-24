from flask import Flask, render_template, request, redirect, url_for, session 
import psycopg2 

app = Flask(__name__) 
app.secret_key = 'so secret'
# Connect to the database 
conn = psycopg2.connect(database="financial_db", user="postgres", 
						password="1816", host="localhost", port="5432") 



cur = conn.cursor() 
conn.commit() 
  
cur.close() 
conn.close()


@app.route('/')
def index():
    return redirect(url_for('login'))
@app.route('/login', methods =['GET', 'POST']) 
def login(): 
    if request.method == 'POST':
        name = request.form['name']
        password = request.form['password']

        try:
            # Connect to the database
            conn = psycopg2.connect(database="financial_db", 
                            user="postgres", 
                            password="1816", 
                            host="localhost", port="5432")
            cur = conn.cursor()

            # Check if user exists
            cur.execute("SELECT user_id, password FROM users WHERE name = %s", (name,))
            user = cur.fetchone()
            if user:
                #TODO: verify password
                session['user_id'] = user[0]  # Save user ID in session
                return redirect(url_for('dashboard'))
            else:
                return "Invalid email or password!"

        except Exception as e:
            return f"An error occurred: {e}"

        finally:
            cur.close()
            conn.close()

    return render_template('index.html') 
@app.route('/dashboard')
def dashboard():
   
    return render_template('dashboard.html')

@app.route('/create_budget', methods=['POST'])
def create_budget():
    # Add a new budget
    user_id = session.get('user_id')
    budget_name = request.form['category']
    print(user_id)
    conn = psycopg2.connect(database="financial_db", user="postgres",
                            password="1816", host="localhost", port="5432")
    cur = conn.cursor()

    cur.execute("INSERT INTO budgets (user_id, budget_name) VALUES (%s, %s)", (user_id, budget_name, ))
    conn.commit()

    cur.close()
    conn.close()
    return redirect(url_for('dashboard'))
@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        # Handle the form submission
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        confirm_password = request.form['confirm_password']

        # Add your logic for saving user details to the database here
        # Example: Check if passwords match, validate email, and save data
        if password != confirm_password:
            return "Passwords do not match! Please try again."

        try:
            conn = psycopg2.connect(database="financial_db", 
                            user="postgres", 
                            password="1816", 
                            host="localhost", port="5432") 
            cur = conn.cursor()

            # Insert user details into the database
            cur.execute(
                "INSERT INTO users (name, email, password) VALUES (%s, %s, %s)",
                (username, email, password)
            )
            conn.commit()
            cur.close()
            conn.close()
        # If successful, redirect to the login page
            return redirect(url_for('login'))
        except Exception as e:
            return f"An error occurred: {e}"
    # Render the signup page for GET requests
    return render_template('signup.html')

if __name__ == '__main__': 
	app.run(debug=True, port=5000) 
