from flask import render_template

from app import app
from app import cursor


@app.route('/')
def main_page():
    return render_template('index.html', title='Music Catalogue')


@app.route('/songs')
def songs_page():
    query = '''SELECT songs.id, songs.name, bands.name, albums.name, songs.price
    FROM songs 
    INNER JOIN bands ON songs.band_id = bands.id
    INNER JOIN albums ON songs.album_id = albums.id;
    '''
    cursor.execute(query)
    data = cursor.fetchall()
    return render_template('songs.html', title='songs', data=data)


@app.route('/bands')
def bands_page():
    query = '''SELECT bands.name, 
    bands.date_of_est, 
    bands.image, 
    bands.link_wiki, 
    genres.name, 
    countries.name 
    FROM bands
    INNER JOIN genres ON bands.genre_id = genres.id
    INNER JOIN countries ON bands.country_id = countries.id
    ORDER BY bands.id;
    '''
    cursor.execute(query)
    data = cursor.fetchall()
    return render_template('bands.html', title='Bands page', data=data)


@app.route('/author')
def about_page():
    query = 'SELECT * FROM author'
    cursor.execute(query)
    data = cursor.fetchall()
    return render_template('about.html', title='About me', data=data)


@app.route('/orders')
def orders_page():
    query = '''SELECT orders.created_at,
       customers.full_name, songs.name, songs.price
        FROM ordered_songs
        INNER JOIN songs ON ordered_songs.song_id = songs.id
        INNER JOIN orders ON ordered_songs.order_id = orders.id
        INNER JOIN customers ON orders.customer_id = customers.id
        ORDER BY orders.created_at DESC;'''
    cursor.execute(query)
    data = cursor.fetchall()
    return render_template('orders.html', title='Orders', data=data)
