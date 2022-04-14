package seguridad.servicio;

import java.util.StringTokenizer;

import javax.naming.NamingException;
import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.jndi.JndiTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import seguridad.bean.ConexionOrigenDatosBean;
import soporte.PropiedadesSAFIBean;

public class ConexionOrigenDatosServicio {
	
	//Constantes
	public static final String		prefijoURLConexion	= "java:/comp/env/jdbc/";
	protected final Logger			loggerSAFI			= Logger.getLogger("SAFI");
	
	//Atributos o Propiedades
	private ConexionOrigenDatosBean	conexionOrigenDatosBean;
	private JndiTemplate			jndiTemplate;
	
	public void creaConexionesBD() {
		String nombreBD;
		JdbcTemplate jdbcTemplate;
		DataSource dataSource;
		DataSourceTransactionManager dataSourceTransactionManager;
		TransactionTemplate transactionTemplate;
		
		try {
			
			if (PropiedadesSAFIBean.propiedadesSAFI == null) {
				PropiedadesSAFIBean.cargaPropiedadesSAFI();
			}
			
			if (PropiedadesSAFIBean.configuracionLOGS == null) {
				PropiedadesSAFIBean.cargaPropiedadesLOG();
			}
			
			String origenesDatos = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatos");
			StringTokenizer tokensBD = new StringTokenizer(origenesDatos, ",");
			
			while (tokensBD.hasMoreTokens()) {
				
				nombreBD = tokensBD.nextToken();
				dataSource = (DataSource) jndiTemplate.lookup(prefijoURLConexion + nombreBD);
				jdbcTemplate = new JdbcTemplate(dataSource);
				
				conexionOrigenDatosBean.getOrigenDatosMapa().put(nombreBD, jdbcTemplate);
				
				dataSourceTransactionManager = new DataSourceTransactionManager();
				dataSourceTransactionManager.setDataSource(dataSource);
				
				transactionTemplate = new TransactionTemplate();
				transactionTemplate.setTransactionManager(dataSourceTransactionManager);
				
				conexionOrigenDatosBean.getManejadorTransaccionesMapa().put(nombreBD, transactionTemplate);
				
				loggerSAFI.info("Creacion de Objetos de BD para: " + nombreBD);
				
			}
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	// ----------------- Getters y Setters -------------------------------------------
	
	public ConexionOrigenDatosBean getConexionOrigenDatosBean() {
		return conexionOrigenDatosBean;
	}
	
	public void setConexionOrigenDatosBean(ConexionOrigenDatosBean conexionOrigenDatosBean) {
		this.conexionOrigenDatosBean = conexionOrigenDatosBean;
	}
	
	public JndiTemplate getJndiTemplate() {
		return jndiTemplate;
	}
	
	public void setJndiTemplate(JndiTemplate jndiTemplate) {
		this.jndiTemplate = jndiTemplate;
	}
	
}
