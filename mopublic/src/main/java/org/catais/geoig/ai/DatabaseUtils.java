package org.catais.geoig.ai;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import ch.ehi.ili2db.base.Ili2db;
import ch.ehi.ili2db.base.Ili2dbException;
import ch.ehi.ili2db.gui.Config;
import ch.ehi.ili2pg.converter.PostgisGeometryConverter;
import ch.ehi.sqlgen.generator_impl.jdbc.GeneratorPostgresql;

public class DatabaseUtils {
	static final Logger logger = LogManager.getLogger(DatabaseUtils.class.getName());

	private String dbhost = "localhost";
	private String dbport = "5432";
	private String dbdatabase = "xanadu2";
	private String dbusr = "stefan";
	private String dbpwd = "ziegler12";
	private String dbschema = "av_mopublic_export";
	
	public DatabaseUtils() {
		
	}
	
	public void createSchema(String modelName) throws Ili2dbException {
        Config config = new Config();
        config.setDbdatabase(dbdatabase);
        config.setDbhost(dbhost);
        config.setDbport(dbport);
        config.setDbusr(dbusr);
        config.setDbpwd(dbpwd);
        config.setDbschema(dbschema);
        config.setModels(modelName);
        config.setModeldir("http://models.geo.admin.ch/");
        
        config.setGeometryConverter(PostgisGeometryConverter.class.getName());
        config.setDdlGenerator(GeneratorPostgresql.class.getName());
        config.setJdbcDriver("org.postgresql.Driver");

        config.setNameOptimization("topic");
        config.setMaxSqlNameLength("60");
        
        config.setDefaultSrsAuthority("EPSG");
        config.setDefaultSrsCode("21781");
        
        String dburl = "jdbc:postgresql://" + config.getDbhost() + ":" + config.getDbport() + "/" + config.getDbdatabase();
        config.setDburl(dburl);
        
        Ili2db.runSchemaImport(config, "");
        
        //TODO: Check if there is really no exception thrown when .setModeldir() is missing. 
        // In this case it looks in the directory where the software is started (?) and
        // the model is not found.
        //
        // Exception works if schema already exists.
        logger.info("Empty database schema created: '" + dbschema +  "'.");
	}
	
	public void dropSchema() throws ClassNotFoundException, SQLException {
		Connection con = null;
		Statement st = null;
        
		String dburl = "jdbc:postgresql://" + dbhost + ":" + dbport + "/" + dbdatabase;
		
		Class.forName("org.postgresql.Driver");
		
		con = DriverManager.getConnection(dburl, dbusr, dbpwd);
        con.setAutoCommit(false);
        
        st = con.createStatement();
        st.execute("DROP SCHEMA IF EXISTS " + dbschema + " CASCADE;");

        con.commit();	
                
        try {
        	if (st != null) {
        		st.close();
        	}
        	if (con != null) {
        		con.close();
        	}
        } catch (SQLException e) {
        	e.printStackTrace();
        	logger.error(e.getMessage());
        }
        
        logger.info("Database schema dropped: '" + dbschema + "' (if existed).");
	}
	
	public void createFunctions() {
		
	}
	
	public void deleteTables() {
		
	}

}
