package soporte;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import org.apache.log4j.FileAppender;
import org.apache.log4j.Layout;
import org.apache.log4j.helpers.CountingQuietWriter;
import org.apache.log4j.helpers.LogLog;
import org.apache.log4j.helpers.OptionConverter;
import org.apache.log4j.spi.LoggingEvent;

public class CompositeRollingFileAppender extends FileAppender {
	// The code assumes that the following constants are in a increasing
	// sequence.
	static final int				TOP_OF_TROUBLE	= -1;
	static final int				TOP_OF_MINUTE	= 0;
	static final int				TOP_OF_HOUR		= 1;
	static final int				HALF_DAY		= 2;
	static final int				TOP_OF_DAY		= 3;
	static final int				TOP_OF_WEEK		= 4;
	static final int				TOP_OF_MONTH	= 5;
	int								checkPeriod		= TOP_OF_TROUBLE;
	
	private static final TimeZone	gmtTimeZone		= TimeZone.getTimeZone("GMT");
	
	private static final int		BY_SIZE			= 0;
	
	private static final int		BY_DATE			= 1;
	
	protected long					maxFileSize		= Long.MAX_VALUE;
	
	protected int					maxBackupIndex	= Integer.MAX_VALUE;
	
	protected String				datePattern		= "'.'yyyy-MM-dd";
	
	protected String				scheduledFilename;
	
	protected long					nextCheck		= System.currentTimeMillis() - 1;
	
	private Date					now				= new Date();
	
	private SimpleDateFormat		sdf;
	
	private RollingCalendar			rc				= new RollingCalendar();
	
	/*----------------------------------------------------------------------------*/
	public CompositeRollingFileAppender() {
		super();
	}
	
	public CompositeRollingFileAppender(Layout layout, String filename, boolean append) throws IOException {
		super(layout, filename, append);
	}
	
	public CompositeRollingFileAppender(Layout layout, String filename) throws IOException {
		super(layout, filename);
	}
	
	public CompositeRollingFileAppender(Layout layout, String filename, String datePattern) throws IOException {
		super(layout, filename, true);
		this.datePattern = datePattern;
		activateOptions();
	}
	
	public CompositeRollingFileAppender(Layout layout, String filename, String datePattern, boolean append) throws IOException {
		super(layout, filename, append);
		this.datePattern = datePattern;
		activateOptions();
	}
	
	/*----------------------------------------------------------------------------*/
	
	public synchronized void setFile(String fileName, boolean append, boolean bufferedIO, int bufferSize) throws IOException {
		super.setFile(fileName, append, this.bufferedIO, this.bufferSize);
		if (append) {
			File f = new File(fileName);
			((CountingQuietWriter) qw).setCount(f.length());
		}
	}
	
	public void activateOptions() {
		super.activateOptions();
		if (datePattern != null && fileName != null) {
			now.setTime(System.currentTimeMillis());
			sdf = new SimpleDateFormat(datePattern);
			int type = computeCheckPeriod();
			printPeriodicity(type);
			rc.setType(type);
			File file = new File(fileName);
			scheduledFilename = fileName + sdf.format(new Date(file.lastModified()));
		} else {
			LogLog.error("Either File or DatePattern options are not set for appender [" + name + "].");
		}
	}
	
	void printPeriodicity(int type) {
		switch (type) {
			case TOP_OF_MINUTE :
				LogLog.debug("Appender [" + name + "] to be rolled every minute.");
				break;
			case TOP_OF_HOUR :
				LogLog.debug("Appender [" + name + "] to be rolled on top of every hour.");
				break;
			case HALF_DAY :
				LogLog.debug("Appender [" + name + "] to be rolled at midday and midnight.");
				break;
			case TOP_OF_DAY :
				LogLog.debug("Appender [" + name + "] to be rolled at midnight.");
				break;
			case TOP_OF_WEEK :
				LogLog.debug("Appender [" + name + "] to be rolled at start of week.");
				break;
			case TOP_OF_MONTH :
				LogLog.debug("Appender [" + name + "] to be rolled at start of every month.");
				break;
			default :
				LogLog.warn("Unknown periodicity for appender [" + name + "].");
		}
	}
	
	int computeCheckPeriod() {
		RollingCalendar rollingCalendar = new RollingCalendar(gmtTimeZone, Locale.ENGLISH);
		// set sate to 1970-01-01 00:00:00 GMT  
		Date epoch = new Date(0);
		if (datePattern != null) {
			for (int i = TOP_OF_MINUTE; i <= TOP_OF_MONTH; i++) {
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat(datePattern);
				simpleDateFormat.setTimeZone(gmtTimeZone); // do all date  
				// formatting in GMT  
				String r0 = simpleDateFormat.format(epoch);
				rollingCalendar.setType(i);
				Date next = new Date(rollingCalendar.getNextCheckMillis(epoch));
				String r1 = simpleDateFormat.format(next);
				if (r0 != null && r1 != null && !r0.equals(r1)) {
					return i;
				}
			}
		}
		return TOP_OF_TROUBLE; // Deliberately head for trouble...  
	}
	
	public void rollOverSize() {
		
		LogLog.debug("rolling over count=" + ((CountingQuietWriter) qw).getCount());
		LogLog.debug("maxBackupIndex=" + maxBackupIndex);
		
		if (maxBackupIndex > 0) {
			rotateLogFilesBy(BY_SIZE);
		}
		
		try {
			this.setFile(fileName, false, bufferedIO, bufferSize);
		} catch (IOException e) {
			LogLog.error("setFile(" + fileName + ", false) call failed.", e);
		}
	}
	
	public void rollOverTime() throws IOException {
		
		if (datePattern == null) {
			errorHandler.error("Missing DatePattern option in rollOver().");
			return;
		}
		
		String datedFilename = fileName + sdf.format(now);
		if (scheduledFilename.equals(datedFilename)) {
			return;
		}
		
		rotateLogFilesBy(BY_DATE);
		
		try {
			this.setFile(fileName, false, this.bufferedIO, this.bufferSize);
		} catch (IOException e) {
			errorHandler.error("setFile(" + fileName + ", false) call failed.");
		}
		scheduledFilename = datedFilename;
	}
	
	protected void subAppend(LoggingEvent event) {
		long n = System.currentTimeMillis();
		if (n >= nextCheck) {
			now.setTime(n);
			nextCheck = rc.getNextCheckMillis(now);
			try {
				rollOverTime();
			} catch (IOException ioe) {
				LogLog.error("rollOver() failed.", ioe);
			}
		}
		
		if ((fileName != null) && ((CountingQuietWriter) qw).getCount() >= maxFileSize) {
			rollOverSize();
		}
		
		super.subAppend(event);
	}
	
	private int getBackupLogFileNum() {
		File[] logs = getAllLogFiles();
		return logs.length - 1;
	}
	
	private File[] getAllLogFiles() {
		File outputPath = new File(fileName);
		String name = outputPath.getName();
		File logDir = outputPath.getParentFile();
		if (logDir == null) {
			logDir = new File(".");
		}
		return logDir.listFiles(new LogFileNameFilter(name));
	}
	
	private void deleteOldestFile() {
		File[] logs = getAllLogFiles();
		File oldest = null;
		long maxLastModified = 0;
		
		for (int i = 0; i < logs.length; i++) {
			long lastModified = logs[i].lastModified();
			if (oldest == null) {
				oldest = logs[i];
				maxLastModified = lastModified;
			} else {
				if (maxLastModified > lastModified) {
					oldest = logs[i];
					maxLastModified = lastModified;
				}
			}
		}
		
		if (oldest != null && oldest.exists()) {
			oldest.delete();
		}
	}
	
	private void rotateLogFilesBy(int mode) {
		List<File> notDailyLogs = new ArrayList<File>();
		File[] allLogs = getAllLogFiles();
		for (int i = 0; i < allLogs.length; i++) {
			if (!isDailyRotatedLog(allLogs[i])) {
				notDailyLogs.add(allLogs[i]);
			}
		}
		int notDailyLogNum = notDailyLogs.size();
		
		if (mode == BY_SIZE) {
			File file = null;
			File target = null;
			LogLog.debug(getBackupLogFileNum() + ">=" + maxBackupIndex);
			if (getBackupLogFileNum() >= maxBackupIndex) {
				deleteOldestFile();
			}
			
			for (int i = notDailyLogNum - 1; i >= 1; i--) {
				file = new File(fileName + "." + i);
				if (file.exists()) {
					target = new File(fileName + '.' + (i + 1));
					LogLog.debug("Renaming file " + file + " to " + target);
					file.renameTo(target);
				}
			}
			
			target = new File(fileName + "." + 1);
			
			this.closeFile();
			
			file = new File(fileName);
			LogLog.debug("Renaming file " + file + " to " + target);
			file.renameTo(target);
		} else if (mode == BY_DATE) {
			this.closeFile();
			
			if (getBackupLogFileNum() >= maxBackupIndex) {
				deleteOldestFile();
			}
			
			for (int i = 1; i <= notDailyLogNum - 1; i++) {
				String from = fileName + '.' + i;
				String to = scheduledFilename + '.' + i;
				renameFile(from, to);
			}
			
			renameFile(fileName, scheduledFilename);
		} else {
			LogLog.warn("invalid mode:" + mode);
		}
	}
	
	private boolean isDailyRotatedLog(File deletedFile) {
		String deletedName = deletedFile.getName();
		File outputPath = new File(fileName);
		String name = outputPath.getName();
		
		if (deletedName.equals(name)) {
			return false;
		} else {
			String ext = deletedName.substring(name.length() + 1);
			try {
				Integer.parseInt(ext);
			} catch (NumberFormatException ex) {
				return true;
			}
			return false;
		}
	}
	
	private void renameFile(String from, String to) {
		File toFile = new File(to);
		if (toFile.exists()) {
			toFile.delete();
		}
		
		File fromFile = new File(from);
		fromFile.renameTo(toFile);
	}
	
	/*----------------------------------------------------------------------------*/
	public int getMaxBackupIndex() {
		return maxBackupIndex;
	}
	
	public long getMaximumFileSize() {
		return maxFileSize;
	}
	
	public void setMaxBackupIndex(int maxBackups) {
		this.maxBackupIndex = maxBackups;
	}
	
	public void setMaximumFileSize(long maxFileSize) {
		this.maxFileSize = maxFileSize;
	}
	
	public void setMaxFileSize(String value) {
		maxFileSize = OptionConverter.toFileSize(value, maxFileSize + 1);
	}
	
	protected void setQWForFiles(Writer writer) {
		this.qw = new CountingQuietWriter(writer, errorHandler);
	}
	
	public void setDatePattern(String pattern) {
		datePattern = pattern;
	}
	
	public String getDatePattern() {
		return datePattern;
	}
	
	/*----------------------------------------------------------------------------*/
	
	static class LogFileNameFilter implements FilenameFilter {
		String	fileName;
		
		LogFileNameFilter(String name) {
			this.fileName = name;
		}
		
		public boolean accept(File dir, String name) {
			return name.startsWith(fileName);
		}
	}
	
}
class RollingCalendar extends GregorianCalendar {
	private static final long	serialVersionUID	= -3560331770601814177L;
	
	int							type				= CompositeRollingFileAppender.TOP_OF_TROUBLE;
	
	RollingCalendar() {
		super();
	}
	
	RollingCalendar(TimeZone tz, Locale locale) {
		super(tz, locale);
	}
	
	void setType(int type) {
		this.type = type;
	}
	
	public long getNextCheckMillis(Date now) {
		return getNextCheckDate(now).getTime();
	}
	
	public Date getNextCheckDate(Date now) {
		this.setTime(now);
		
		switch (type) {
			case CompositeRollingFileAppender.TOP_OF_MINUTE :
				this.set(Calendar.SECOND, 0);
				this.set(Calendar.MILLISECOND, 0);
				this.add(Calendar.MINUTE, 1);
				break;
			case CompositeRollingFileAppender.TOP_OF_HOUR :
				this.set(Calendar.MINUTE, 0);
				this.set(Calendar.SECOND, 0);
				this.set(Calendar.MILLISECOND, 0);
				this.add(Calendar.HOUR_OF_DAY, 1);
				break;
			case CompositeRollingFileAppender.HALF_DAY :
				this.set(Calendar.MINUTE, 0);
				this.set(Calendar.SECOND, 0);
				this.set(Calendar.MILLISECOND, 0);
				int hour = get(Calendar.HOUR_OF_DAY);
				if (hour < 12) {
					this.set(Calendar.HOUR_OF_DAY, 12);
				} else {
					this.set(Calendar.HOUR_OF_DAY, 0);
					this.add(Calendar.DAY_OF_MONTH, 1);
				}
				break;
			case CompositeRollingFileAppender.TOP_OF_DAY :
				this.set(Calendar.HOUR_OF_DAY, 0);
				this.set(Calendar.MINUTE, 0);
				this.set(Calendar.SECOND, 0);
				this.set(Calendar.MILLISECOND, 0);
				this.add(Calendar.DATE, 1);
				break;
			case CompositeRollingFileAppender.TOP_OF_WEEK :
				this.set(Calendar.DAY_OF_WEEK, getFirstDayOfWeek());
				this.set(Calendar.HOUR_OF_DAY, 0);
				this.set(Calendar.MINUTE, 0);
				this.set(Calendar.SECOND, 0);
				this.set(Calendar.MILLISECOND, 0);
				this.add(Calendar.WEEK_OF_YEAR, 1);
				break;
			case CompositeRollingFileAppender.TOP_OF_MONTH :
				this.set(Calendar.DATE, 1);
				this.set(Calendar.HOUR_OF_DAY, 0);
				this.set(Calendar.MINUTE, 0);
				this.set(Calendar.SECOND, 0);
				this.set(Calendar.MILLISECOND, 0);
				this.add(Calendar.MONTH, 1);
				break;
			default :
				throw new IllegalStateException("Unknown periodicity type.");
		}
		return getTime();
	}
	
}