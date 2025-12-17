import requests

lenkeapi = "https://catfact.ninja/fact"
def FaktaOmKatter(): 
    try:
        henteapi = requests.get(lenkeapi)
        if henteapi.status_code==200:
            print ("All ok!")
        else:
            print ("Noe gikk galt.")
        innhold = henteapi.json()
        print (type(innhold))
        print (innhold)
    except:
        print ("Noe gikk galt.")
FaktaOmKatter()