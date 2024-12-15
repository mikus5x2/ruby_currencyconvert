# Wazne!

# Aby uruchomic program trzeba zainstalować dwie biblioteki do ruby.

# gem install httparty
# gem install rainbow
# json - standardowa biblioteka w ruby

# Aby program zadziałał trzeba w terminalu wpisac ruby main.rb 
# Po lepszy efekt warto włączyć fullscrena w terminalu.

require 'httparty'
require 'json'
require 'rainbow'

class KonwerterWalut
  Api_Url = 'https://api.exchangerate-api.com/v4/latest/'

  def dane
    @kursy = {}
    @waluta_bazowa = ''
  end

  def czysc_terminal
    system('clear') || system('cls')
  end

  def wyswietl_naglowek
    czysc_terminal
    puts <<~ASCII
    _______    __   __  _______  __   __    ___   _  _______  __    _  _     _  _______  ______    _______  _______  ______   
    |    _ |  |  | |  ||  _    ||  | |  |  |   | | ||       ||  |  | || | _ | ||       ||    _ |  |       ||       ||    _ |  
    |   | ||  |  | |  || |_|   ||  |_|  |  |   |_| ||   _   ||   |_| || || || ||    ___||   | ||  |_     _||    ___||   | ||  
    |   |_||_ |  |_|  ||       ||       |  |      _||  | |  ||       ||       ||   |___ |   |_||_   |   |  |   |___ |   |_||_ 
    |    __  ||       ||  _   | |_     _|  |     |_ |  |_|  ||  _    ||       ||    ___||    __  |  |   |  |    ___||    __  |
    |   |  | ||       || |_|   |  |   |    |    _  ||       || | |   ||   _   ||   |___ |   |  | |  |   |  |   |___ |   |  | |
    |___|  |_||_______||_______|  |___|    |___| |_||_______||_|  |__||__| |__||_______||___|  |_|  |___|  |_______||___|  |_|

    ASCII
    puts ""

    puts Rainbow("Aby wpisać liczby z częścią dziesiętną, użyj kropki zamiast przecinka, np. 3514.75.").color(:green).bright
    puts ""
    puts "Legenda:"
    puts "USD - Dolar amerykański (USD)"
    puts "EUR - Euro (EUR)"
    puts "GBP - Funt szterling (GBP)"
    puts "CHF - Frank szwajcarski (CHF)"
    puts "NOK - Korona norweska (NOK)"
    puts "SEK - Korona szwedzka (SEK)"
    puts "DKK - Korona duńska (DKK)"
    puts "PLN - Złoty (PLN)"
    puts "HUF - Forint węgierski (HUF)"
    puts "RON - Lej rumuński (RON)"
    puts ""
  end

  def pobierz_kursy_walut(waluta_bazowa)
  bardzoprostyinternetcheck = HTTParty.get("#{Api_Url}#{waluta_bazowa}")
    if bardzoprostyinternetcheck.code == 200
      dane = JSON.parse(bardzoprostyinternetcheck.body)
      @kursy = dane['rates']
      @waluta_bazowa = waluta_bazowa
      puts "Załadowano kursy dla #{waluta_bazowa}."
    else
      puts "Nie udało się pobrać danych. Prosze otworzyć program ponownie."
      exit
    end
  end

  def przelicz_walute(kwota, z_waluty, na_walute)
    if @kursy[na_walute]
      (kwota * @kursy[na_walute]).round(2)
    else
      puts "Nieznana waluta: #{na_walute}. Prosze otworzyć program ponownie."
      exit
    end
  end

  def poprawny_numer?(input)
    Float(input) rescue false
  end

  def uruchom
    wyswietl_naglowek

    print "Podaj walutę, którą posiadasz (PLN, USD, EUR, GBP, CHF, NOK, SEK, DKK, HUF, RON): "
    waluta_posiadana = gets.chomp.upcase
    pobierz_kursy_walut(waluta_posiadana)

    loop do
      wyswietl_naglowek

      kwota = nil
      loop do
        print "Podaj kwotę w #{waluta_posiadana}: "
        input = gets.chomp
        if poprawny_numer?(input)
          kwota = input.to_f
          break
        else
          puts "Proszę podawać tylko liczby."
        end
      end

      waluta_docelowa = ""
      loop do
        print "Podaj walutę, na którą chcesz wymienić (PLN, USD, EUR, GBP, CHF, NOK, SEK, DKK, HUF, RON): "
        waluta_docelowa = gets.chomp.upcase
        if waluta_docelowa == waluta_posiadana
          puts "Nie możesz wybrać tej samej waluty, którą posiadasz. Spróbuj ponownie."
        elsif !@kursy.key?(waluta_docelowa)
          puts "Nieznana waluta: #{waluta_docelowa}. Spróbuj ponownie."
        else
          break
        end
      end

      wynik = przelicz_walute(kwota, waluta_posiadana, waluta_docelowa)
      puts "#{kwota} #{waluta_posiadana} = #{wynik} #{waluta_docelowa}"

      print "Czy chcesz wykonać kolejną operację? (tak/nie): "
      if gets.chomp.downcase != 'tak'
        puts "Dziękujemy za skorzystanie z konwertera!"
        break
      end

      print "Podaj nową walutę, którą posiadasz (PLN, USD, EUR, GBP, CHF, NOK, SEK, DKK, HUF, RON): "
      waluta_posiadana = gets.chomp.upcase
      pobierz_kursy_walut(waluta_posiadana)
    end
  end
end

konwerter = KonwerterWalut.new
konwerter.uruchom
