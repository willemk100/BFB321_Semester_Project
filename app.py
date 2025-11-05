from flask import Flask, render_template
import sqlite3
## import pandas as pd ## Might need later for data manipulation

app = Flask(__name__)

# Database connection function
def get_db_connection():
    conn = sqlite3.connect('ordering.db')
    conn.row_factory = sqlite3.Row
    return conn

# Route to show all vendors - Used in customer-main.html
@app.route('/vendors')
def get_vendors():
    conn = get_db_connection()
    # Get all vendors from the vendor table
    vendors = conn.execute('SELECT * FROM vendor').fetchall()
    conn.close()
    return render_template('customer-main.html', vendors=vendors)



# Get menu for [vendor] used in menu.html
@app.route('/vendors/<int:vendor_id>/menu')
def vendor_menu(vendor_id):
    conn = get_db_connection()
    # Get vendor details - Keep name and info
    selected_vendor = conn.execute('SELECT * FROM vendor WHERE vendor_id = ?', (vendor_id,)).fetchone()
    # Get all menu items from this vendor
    menu_items = conn.execute('SELECT * FROM menuItem WHERE vendor_id = ?', (vendor_id,)).fetchall()
    # Get a list of all the catagories fron the selected vendor menu items
    catagories = list({item['catagory'] for item in menu_items})
    conn.close()
    return render_template('menu.html',selected_vendor = selected_vendor, menuItems= menu_items, catagories=catagories)




# Make '/' load the same page as '/customers'
# Will change this later to a landing page
@app.route('/')
def home():
    return get_vendors()


# Run the app
if __name__ == '__main__':
    app.run(debug=True)

    app.run(debug=True)
