require 'pg'
require 'stringio'

class Library
	ID = 'id'
	TITLE = "title"
	AUTHOR = "author"
	GENRE = "genre"
	YEAR_PUBLISHED = "year_published"
	INSERT_QUERY = "insert into library 
	    	(#{TITLE}, #{AUTHOR}, #{GENRE}, #{YEAR_PUBLISHED}) 
	    	values($1, $2, $3, $4)"

	def initialize
		@con = nil
	end

	def start_program
		begin
			# this only valid if method is md5
			@con = PG.connect :dbname => 'dev_db', :user => 'dev', :password => '12345'

			puts("Database Start")
			result = @con.exec("create table if not exists library(id serial primary key, title varchar, author varchar, genre varchar, year_published integer)")
			loop do
		      begin
		        puts
		        puts('Main Menu:')

		        puts('1. Add a book', '2. Update a book', '3. Delete a book')
		        puts('4. Search by title', '5. Search by author', '6. Search by genre')
		        puts('7. Display catalog', '8. Export all books0', '9. Exit')
		        print('Please enter your choice: ')
		        choice = gets.chomp.to_i

		        if choice.between?(1, 8)
		          go_to_library(choice)
		        elsif choice == 9
		          break
		        else
		          puts("Invalid Choice \u{26A0}")
		        end

		      rescue Interrupt => e
		        puts('You cancel the process')
		      end
		    end

		rescue PG::Error => e
			puts(e.message)
		ensure
			@con.close if @con
			puts("Database Stop")
		end
	end

	def go_to_library(choice)
		case choice
	    when 1
	      add_book
	    when 2
	      # update_book
	    when 3
	      delete_row
	    when 4
	      # search_by_title
	    when 5
	      # search_by_author
	    when 6
	      # search_by_genre
	    when 7
	      display_catalog
	    when 8
	      # export_catalog
	    end
	end

	def add_book
	    title = prompt_and_get('Enter the title of the book: ')
	    return if title == false

	    author = prompt_and_get('Enter the author of the book: ')
	    return if author == false

	    genre = prompt_and_get('Enter the genre of the book: ')
	    return if genre == false

	    year_published = prompt_and_get_valid_year
	    return if year_published == false

	    if insert_into_table([title, author, genre, year_published])
		    puts("Book added successfully!  \u{263A}")
		else
			puts("Problem to add the book in the table")
		end
	end

	def display_catalog
		rs = @con.exec("select * from library")
		rs.each do |row|
	      puts "%s   %s   %s   %s   %s" % [ row['id'], row['title'], row['author'], row['genre'], row['year_published'] ]
	    end
	end

	def prompt_and_get(msg)
	    # run until empty string entered by user
	    count = 0
	    begin
	      puts
	      print(msg)
	      input = gets.chomp.strip
	      if input.empty?
	        puts('Enter valid input')
	        count += 1
	      end
	      if count == 4
	        puts('Limit Exceed')
	        return false
	      end
	    end while input.empty?
	    input.squeeze(' ')
  	end

  	def prompt_and_get_valid_year
	    # run until the correct year is not entered by user
	    count = 0
	    begin
	      year_published = prompt_and_get('Enter the year published: ').to_i
	      unless year_published.between?(1582, 2023)
	        puts('Enter valid Year')
	        count += 1
	      end
	      if count == 4
	        puts('Limit Exceed')
	        return false
	      end
	    end until(year_published.between?(1582, 2023))
	    year_published
	end

	def insert_into_table(arr)
  		@con.exec_params(INSERT_QUERY, arr)
	end

	def delete_row
		display_catalog
		id = prompt_and_get("Enter id of book: ")
		unless id
			return false
		end
		id = id.to_i
		@con.exec("delete from library where id = #{id}")
	end

	def delete_table()
		@con.exec("drop table if exists")
	end



end


library = Library.new
library.start_program