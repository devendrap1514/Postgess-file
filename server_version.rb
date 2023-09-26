require 'pg'

begin
	# this only valid if method is trust
	con = PG.connect :dbname => 'dev_db', :user => 'dev'
	puts(con.server_version)
rescue PG::Error => e
	puts(e.message)
ensure
	con.close if con
end