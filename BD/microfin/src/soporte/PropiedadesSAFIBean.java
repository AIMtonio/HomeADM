package soporte;

import java.io.FileInputStream;
import java.util.Properties;

public class PropiedadesSAFIBean {
	
	public static Properties	propiedadesSAFI		= null;
	public static Properties	configuracionLOGS	= null;
	private static String		OS					= System.getProperty("os.name").toLowerCase();
	
	public static void cargaPropiedadesSAFI() {
		
		try {
			propiedadesSAFI = new Properties();
			
			FileInputStream archivoLocal = null;
			//Cargo el archivo properties dependiendo el Sistema Operativo
			if (esUnix() || esMac() || esSolaris()) {
				
				archivoLocal = new FileInputStream(System.getProperty("file.separator") + "opt" + System.getProperty("file.separator") + "SAFI" + System.getProperty("file.separator") + "SAFI.properties");
			} else {
				archivoLocal = new FileInputStream("C:" + System.getProperty("file.separator") + "SAFI" + System.getProperty("file.separator") + "SAFI.properties");
				
			}
			propiedadesSAFI.load(archivoLocal);
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	/**
	 * Carga la configuración de los Logs.
	 */
	public static void cargaPropiedadesLOG() {
		System.out.println("Se agregan propiedades de la configuracion");
		try {
			configuracionLOGS = new Properties();
			
			FileInputStream archivoLocal = null;
			//Cargo el archivo properties dependiendo el Sistema Operativo
			if (esUnix() || esMac() || esSolaris()) {
				
				archivoLocal = new FileInputStream(System.getProperty("file.separator") + "opt" + System.getProperty("file.separator") + "SAFI" + System.getProperty("file.separator") + "SOPORTE" + System.getProperty("file.separator") + "ConfiguracionLOGS.properties");
			} else {
				archivoLocal = new FileInputStream("C:" + System.getProperty("file.separator") + "SAFI" + System.getProperty("file.separator") + "SOPORTE" + System.getProperty("file.separator") + "ConfiguracionLOGS.properties");
				
			}
			configuracionLOGS.load(archivoLocal);
			
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}
	
	private static boolean esWindows() {
		return (OS.indexOf("win") >= 0);
	}
	
	private static boolean esMac() {
		return (OS.indexOf("mac") >= 0);
	}
	
	private static boolean esUnix() {
		return (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") > 0);
	}
	
	private static boolean esSolaris() {
		return (OS.indexOf("sunos") >= 0);
	}
	
}
