package soporte;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Level;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.RollingFileAppender;

public class Log4jInitServlet extends HttpServlet {
	
	private static final long	serialVersionUID	= 1L;
	Logger						loggerSAFI			= Logger.getLogger("SAFI");
	Logger						loggerPDM			= Logger.getLogger("PDM");
	Logger						loggerVent			= Logger.getLogger("Vent");
	Logger						loggerISOTRX		= Logger.getLogger("ISOTRX");
	static String				patronFechaLog		= "'.'yyyy-MM-dd";
	static String				defaultMaxSize		= "20000KB";
	
	public void init() {
		try {
			//Carga en la Aplicacion los Properties
			PropiedadesSAFIBean.cargaPropiedadesSAFI();
			PropiedadesSAFIBean.cargaPropiedadesLOG();
			String nivelLog = PropiedadesSAFIBean.configuracionLOGS.getProperty("NivelLog");
			String rutaSAFILOG = PropiedadesSAFIBean.configuracionLOGS.getProperty("RutaSAFILOG");
			String rutaVENTLOG = PropiedadesSAFIBean.configuracionLOGS.getProperty("RutaVENTLOG");
			String rutaTARJETAWSLOG = PropiedadesSAFIBean.configuracionLOGS.getProperty("RutaISOTRXLOG");

			String nombreSAFILog = PropiedadesSAFIBean.configuracionLOGS.getProperty("NombreSAFILog");
			String nombreVentLog = PropiedadesSAFIBean.configuracionLOGS.getProperty("NombreVentLog");
			String nombreTarjetaWSLOG = PropiedadesSAFIBean.configuracionLOGS.getProperty("NombreISOTRXLOG");

			String maxSizeSAFI = PropiedadesSAFIBean.configuracionLOGS.getProperty("MaxSizeSAFI");
			String maxSizeVENT = PropiedadesSAFIBean.configuracionLOGS.getProperty("MaxSizeVENT");
			String maxSizeTARJETAWSLOG = PropiedadesSAFIBean.configuracionLOGS.getProperty("MaxSizeISOTRXLOG");

			maxSizeSAFI = maxSizeSAFI==null || maxSizeSAFI.isEmpty() ?defaultMaxSize:maxSizeSAFI;
			maxSizeVENT = maxSizeVENT==null || maxSizeVENT.isEmpty() ?defaultMaxSize:maxSizeVENT;
			maxSizeTARJETAWSLOG = maxSizeTARJETAWSLOG==null || maxSizeTARJETAWSLOG.isEmpty() ?defaultMaxSize:maxSizeTARJETAWSLOG;

			String nombreArchivoLogPDM = PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreArchivoLogPDM");
			//FIN Carga en la Aplicacion los Properties
			PatternLayout layoutSAFI = new PatternLayout("%d %p %C.%M - %m%n");
			
			/*Se establece el nivel de log*/
			if (nivelLog.equalsIgnoreCase("DEBUG")) {
				loggerSAFI.setLevel(Level.DEBUG);
				loggerPDM.setLevel(Level.DEBUG);
				loggerVent.setLevel(Level.DEBUG);
				loggerISOTRX.setLevel(Level.DEBUG);
			} else if (nivelLog.equalsIgnoreCase("INFO")) {
				loggerSAFI.setLevel(Level.INFO);
				loggerPDM.setLevel(Level.INFO);
				loggerVent.setLevel(Level.INFO);
				loggerISOTRX.setLevel(Level.INFO);
			} else if (nivelLog.equalsIgnoreCase("ERROR")) {
				loggerSAFI.setLevel(Level.ERROR);
				loggerPDM.setLevel(Level.ERROR);
				loggerVent.setLevel(Level.ERROR);
				loggerISOTRX.setLevel(Level.ERROR);
			} else if (nivelLog.equalsIgnoreCase("WARN")) {
				loggerSAFI.setLevel(Level.WARN);
				loggerPDM.setLevel(Level.WARN);
				loggerVent.setLevel(Level.WARN);
				loggerISOTRX.setLevel(Level.WARN);
			} else {
				loggerSAFI.setLevel(Level.DEBUG);
				loggerPDM.setLevel(Level.DEBUG);
				loggerVent.setLevel(Level.DEBUG);
				loggerISOTRX.setLevel(Level.DEBUG);
			}
			
			CompositeRollingFileAppender apenderSAFI = new CompositeRollingFileAppender();
			CompositeRollingFileAppender apenderVENT = new CompositeRollingFileAppender();
			CompositeRollingFileAppender apenderTarjetaWS = new CompositeRollingFileAppender();
			RollingFileAppender apenderPDM = new RollingFileAppender(layoutSAFI, nombreArchivoLogPDM);
			/*Configuracion de los logs*/
			apenderSAFI.setFile(rutaSAFILOG + nombreSAFILog);
			apenderSAFI.setDatePattern(patronFechaLog);
			apenderSAFI.setLayout(layoutSAFI);
			apenderSAFI.activateOptions();
			apenderSAFI.setMaxFileSize(maxSizeSAFI);
			apenderVENT.setFile(rutaVENTLOG + nombreVentLog);
			apenderVENT.setDatePattern(patronFechaLog);
			apenderVENT.setLayout(layoutSAFI);
			apenderVENT.activateOptions();
			apenderVENT.setMaxFileSize(maxSizeVENT);
			apenderTarjetaWS.setFile(rutaTARJETAWSLOG + nombreTarjetaWSLOG);
			apenderTarjetaWS.setDatePattern(patronFechaLog);
			apenderTarjetaWS.setLayout(layoutSAFI);
			apenderTarjetaWS.activateOptions();
			apenderTarjetaWS.setMaxFileSize(maxSizeTARJETAWSLOG);
			apenderPDM.setMaxFileSize("20000KB");
			apenderPDM.setMaxBackupIndex(10);
			
			loggerSAFI.addAppender(apenderSAFI);
			loggerSAFI.setAdditivity(false);
			
			loggerVent.addAppender(apenderVENT);
			loggerVent.setAdditivity(false);
			
			loggerISOTRX.addAppender(apenderTarjetaWS);
			loggerISOTRX.setAdditivity(false);
			
			loggerPDM.addAppender(apenderPDM);
			loggerPDM.setAdditivity(false);
			/*FIN Configuracion de los logs*/
			
			loggerSAFI.info("Cargando Archivo de Propiedades: " + rutaSAFILOG + nombreSAFILog);
			loggerSAFI.info("Cargando Configuracion de Log4J");
			loggerSAFI.info("Nivel del Log: " + nivelLog);
			
			loggerVent.info("Cargando Archivo de Propiedades: " + rutaVENTLOG + nombreVentLog);
			loggerVent.info("Cargando Configuracion de Log4J");
			loggerVent.info("Nivel del Log: " + nivelLog);
			
			loggerISOTRX.info("Cargando Archivo de Propiedades: " + rutaTARJETAWSLOG + nombreTarjetaWSLOG);
			loggerISOTRX.info("Cargando Configuracion de Log4J");
			loggerISOTRX.info("Nivel del Log: " + nivelLog);
			
			loggerPDM.info("Cargando Archivo de Propiedades: " + nombreArchivoLogPDM);
			loggerPDM.info("Cargando Configuracion de Log4J");
			loggerPDM.info("Nivel del Log: " + nivelLog);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse res) {
		
	}
	
}