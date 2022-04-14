package cliente.dao;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.CliExtranjeroBean;


public class CliExtranjeroDAO extends BaseDAO {
	
	public CliExtranjeroDAO() {
		super();
	}
	
	// ------------------ Transacciones ------------------------------------------


	/* Alta Adicional del Cliente Extranjero */
	public MensajeTransaccionBean altaClientEx(final CliExtranjeroBean cliExBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
						//Query con el Store Procedure
						String query = "call CLIEXTRANJEROALT(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?);";

						Object[] parametros = {	
								cliExBean.getClienteID(),
								cliExBean.getInmigrado(),
								cliExBean.getDocumentoLegal(),
								cliExBean.getMotivoEstancia(),
								cliExBean.getFechaVencimiento(),
//								Utileria.convierteEntero(cliExBean.getPaisID()),
								cliExBean.getEntidad(),
								cliExBean.getLocalidad(),
								cliExBean.getColonia(),
								cliExBean.getCalle(),
								cliExBean.getNumeroCasa(),
								cliExBean.getNumeroIntCasa(),
								cliExBean.getAdi_CoPoEx(),
								Utileria.convierteEntero(cliExBean.getPaisRFC()),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CliExtranjeroDAO.altaClientEx",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIEXTRANJEROALT(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
								mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
								mensaje.setDescripcion(resultSet.getString(2));
								mensaje.setNombreControl(resultSet.getString(3));
								mensaje.setConsecutivoString(resultSet.getString(4));
								return mensaje;
							}
						});
				
						return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				 	}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cliente extranjero" + e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion Adicional del Cliente Extranjero */
	public MensajeTransaccionBean modificaCteExt(final CliExtranjeroBean cliExBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query cons el Store Procedure
					String query = "call CLIEXTRANJEROMOD(?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?);";
					Object[] parametros = {	
							cliExBean.getClienteID(),
							cliExBean.getInmigrado(),
							cliExBean.getDocumentoLegal(),
							cliExBean.getMotivoEstancia(),
							cliExBean.getFechaVencimiento(),
//							Utileria.convierteEntero(cliExBean.getPaisID()),
							cliExBean.getEntidad(),
							cliExBean.getLocalidad(),
							cliExBean.getColonia(),
							cliExBean.getCalle(),
							cliExBean.getNumeroCasa(),
							cliExBean.getNumeroIntCasa(),
							cliExBean.getAdi_CoPoEx(),
							Utileria.convierteEntero(cliExBean.getPaisRFC()),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CliExtranjeroDAO.modificaCteExt",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIEXTRANJEROMOD(" + Arrays.toString(parametros) + ")");
					
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoString(resultSet.getString(4));
							
							return mensaje;
	
						}
					});
				
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
				if(mensajeBean.getNumero()==0){
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion de cliente extranjero" + e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	/* Consuta AdicionalCte por Llave Principal*/
	public CliExtranjeroBean consultaPrincipal(CliExtranjeroBean cliExBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIEXTRANJEROCON(?,?,?,?,?,?,?,?,?);";			
		Object[] parametros = {	cliExBean.getClienteID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CliExtranjeroDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIEXTRANJEROCON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							CliExtranjeroBean cliExBean = new CliExtranjeroBean();			
							cliExBean.setClienteID(Utileria.completaCerosIzquierda(
												resultSet.getInt(1),CliExtranjeroBean.LONGITUD_ID));
							cliExBean.setInmigrado(resultSet.getString(2));
							cliExBean.setDocumentoLegal(resultSet.getString(3));
							cliExBean.setMotivoEstancia(resultSet.getString(4));
							cliExBean.setFechaVencimiento(resultSet.getString(5));
						//	cliExBean.setPaisID(resultSet.getString(6));
							cliExBean.setEntidad(resultSet.getString(6));
							cliExBean.setLocalidad(resultSet.getString(7));
							cliExBean.setColonia(resultSet.getString(8));
							cliExBean.setCalle(resultSet.getString(9));
							cliExBean.setNumeroCasa(resultSet.getString(10));
							cliExBean.setNumeroIntCasa(resultSet.getString(11));
							cliExBean.setAdi_CoPoEx(resultSet.getString(12));
							cliExBean.setPaisRFC(resultSet.getString(13));
							
						return cliExBean;
					}
		});
				
		return matches.size() > 0 ? (CliExtranjeroBean) matches.get(0) : null;
	}
	
	public CliExtranjeroBean consultaForanea(CliExtranjeroBean cliExBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CLIEXTRANJEROCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	cliExBean.getClienteID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CliExtranjeroDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIEXTRANJEROCON(" + Arrays.toString(parametros) + ")");				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CliExtranjeroBean cliExBean = new CliExtranjeroBean();			
					
				cliExBean.setClienteID(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),CliExtranjeroBean.LONGITUD_ID));
				cliExBean.setDocumentoLegal(resultSet.getString(2));				
						
					return cliExBean;
	
			}
		});
		return matches.size() > 0 ? (CliExtranjeroBean) matches.get(0) : null;
				
	}
	
	
}
