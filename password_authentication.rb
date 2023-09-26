require 'pg'

begin
	# this only valid if method is md5
	con = PG.connect :dbname => 'dev_db', :user => 'dev', :password => '12345'
	puts(con.server_version)

	puts(con.user)
	puts(con.db)
	puts(con.pass)

rescue PG::Error => e
	puts(e.message)
ensure
	con.close if con
end