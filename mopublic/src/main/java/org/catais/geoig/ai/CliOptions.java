package org.catais.geoig.ai;

import org.apache.commons.cli.Options;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

public class CliOptions {
	static final Logger logger = LogManager.getLogger(CliOptions.class.getName());

	private Options options;
	
	public CliOptions() {
		init();
	}
	
	private void init() {
		options = new Options();

        options.addOption("help", false, "Print help for this application.");
        options.addOption("initdb", false, "Create empty database schema.");
	}
	
	public Options getOptions() {
		return options;
	}
}
