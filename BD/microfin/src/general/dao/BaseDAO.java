package general.dao;
import general.bean.ParametrosAuditoriaBean;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import seguridad.bean.ConexionOrigenDatosBean;
import soporte.bean.UsuarioBean;

public class BaseDAO {

	protected JdbcTemplate jdbcTemplate;	
	protected ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	protected UsuarioBean usuarioBean = null;
	protected static TransaccionDAO transaccionDAO = null;
	protected TransactionTemplate transactionTemplate;
	protected ConexionOrigenDatosBean conexionOrigenDatosBean;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	protected final Logger loggerVent = Logger.getLogger("Vent");
	protected final Logger loggerISOTRX = Logger.getLogger("ISOTRX");
	
	//------------------ Geters y Seters ------------------------------------------------------
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);		
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}
	
	public void setTransactionTemplate(TransactionTemplate transactionTemplate) {
		this.transactionTemplate = transactionTemplate;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}
	
	public ConexionOrigenDatosBean getConexionOrigenDatosBean() {
		return conexionOrigenDatosBean;
	}

	public void setConexionOrigenDatosBean(
			ConexionOrigenDatosBean conexionOrigenDatosBean) {
		this.conexionOrigenDatosBean = conexionOrigenDatosBean;
	}		

	
}
