package org.catais.geoig.ai;

import java.sql.SQLException;
import java.util.Date;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.DefaultParser;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import ch.ehi.ili2db.base.Ili2dbException;


public class App 
{
	static final Logger logger = LogManager.getLogger(App.class.getName());

    public static void main( String[] args )
    {
    	logger.info("Start: "+ new Date());
    	
    	try {
    		
	    	CliOptions cliOptions = new CliOptions();
	    	Options options = cliOptions.getOptions();
	    		    	
	    	CommandLineParser parser = new DefaultParser();
			CommandLine cl = parser.parse(options, args);
			
			if (cl.hasOption("initdb")) {
				logger.debug("initdb");
				// DatabaseUtils -> MOpublicExport?
				DatabaseUtils dbUtils = new DatabaseUtils();
				dbUtils.dropSchema();
				dbUtils.createSchema("MOpublic03_ili2_v13");
			}
			
			
			
			
			
			
			
		} catch (ParseException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		} catch (Ili2dbException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		} catch (SQLException e) {
			e.printStackTrace();
			logger.error(e.getMessage());
		}
    	
    	logger.info("Stop: "+ new Date());
    }
}
