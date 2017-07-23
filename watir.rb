require 'watir'
browser = Watir::Browser.new()
browser.goto 'google.com'
search_bar = browser.text_field(class: 'gsfi')
search_bar.set("Hello World!")

# méthode de la barre d'entrée
search_bar.send_keys(:enter)

# autre méthode pour lancer la recherche : clic bouton envoyer
# submit_button = browser.button(type:"submit")
# submit_button.click

browser.driver.manage.timeouts.implicit_wait = 3

search_result_divs = browser.divs(class:"rc")
search_result_divs.each { |div| p div.h3.text }

# ou bien plus élégant :
# search_result_h3s = browser.h3(class:"r") 

p "Méfait accompli, fermeture du browser"
browser.close
