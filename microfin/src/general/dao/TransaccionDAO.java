package general.dao;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

public class TransaccionDAO extends BaseDAO{

	public TransaccionDAO() {
		super();
	}
	
	// ------------------ Transacciones ------------------------------------------
	
	public void generaNumeroTransaccion(){
		Long numeroTransaccion;
		

			numeroTransaccion = (Long) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				long transaccion = 0;
				try {					
					//Query con el Store Procedure
					String query = "call TRANSACCIONESALT();";					
					Object[] parametros = {};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TRANSACCIONESALT(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								long transaccion = resultSet.getLong(1);					
								return transaccion;
				
						}
					});					
					transaccion = matches.size() > 0 ? ((Long) matches.get(0)).longValue() : 0; 
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de transacciones", e);
					transaction.setRollbackOnly();
				}
				return transaccion;
			}
		});
		parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion.longValue());
		
	}
	
	/**
	 * Método para generar el Número de Transacción
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 */
	public void generaNumeroTransaccion(final boolean origenVentanilla) {
		Long numeroTransaccion;
		numeroTransaccion = (Long) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				long transaccion = 0;
				try {
					// Query con el Store Procedure
					String query = "call TRANSACCIONESALT();";
					Object[] parametros = {};
					if (origenVentanilla) {
						loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call TRANSACCIONESALT(" + Arrays.toString(parametros) + ")");
					} else {
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call TRANSACCIONESALT(" + Arrays.toString(parametros) + ")");
					}
					List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							long transaccion = resultSet.getLong(1);
							return transaccion;
						}
					});
					transaccion = matches.size() > 0 ? ((Long) matches.get(0)).longValue() : 0;
				} catch (Exception e) {
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de transacciones", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de transacciones", e);
					}
					transaction.setRollbackOnly();
				}
				return transaccion;
			}
		});
		parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion.longValue());

	}
	
	public void generaNumeroTransaccionOpeInusuales(final String origenDatos){
		Long numeroTransaccion;
		

			numeroTransaccion = (Long) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenDatos)).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				long transaccion = 0;
				try {					
					//Query con el Store Procedure
					String query = "call TRANSACCIONESALT();";					
					Object[] parametros = {};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TRANSACCIONESALT(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(origenDatos)).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								long transaccion = resultSet.getLong(1);					
								return transaccion;
				
						}
					});					
					transaccion = matches.size() > 0 ? ((Long) matches.get(0)).longValue() : 0; 
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de transacciones", e);
					transaction.setRollbackOnly();
				}
				return transaccion;
			}
		});
		parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion.longValue());
		
	}
	
	public void generaNumeroTransaccionWS(){
		Long numeroTransaccion;
		

			numeroTransaccion = (Long) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				long transaccion = 0;
				try {					
					//Query con el Store Procedure
					String query = "call TRANSACCIONESALT();";					
					Object[] parametros = {};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TRANSACCIONESALT(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								long transaccion = resultSet.getLong(1);					
								return transaccion;
				
						}
					});					
					transaccion = matches.size() > 0 ? ((Long) matches.get(0)).longValue() : 0; 
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de transacciones", e);
					transaction.setRollbackOnly();
				}
				return transaccion;
			}
		});
		parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion.longValue());
		
	}

	public  long generaNumeroTransaccionOut(){
		long numeroTransaccion;
		
		numeroTransaccion = (Long) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				long transaccion = 0;
				try {					
					//Query con el Store Procedure
					String query = "call TRANSACCIONESALT();";					
					Object[] parametros = {};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TRANSACCIONESALT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								long transaccion = resultSet.getLong(1);					
								return transaccion;
				
						}
					});					
					transaccion = matches.size() > 0 ? ((Long) matches.get(0)).longValue() : 0; 
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al generar numero de transaccion", e);
					transaction.setRollbackOnly();
				}
				return transaccion;
			}
		});
		return numeroTransaccion;
		
		
	}
	
	public  long generaNumeroTransaccionOutWS(){
		long numeroTransaccion;
		
		numeroTransaccion = (Long) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				long transaccion = 0;
				try {					
					//Query con el Store Procedure
					String query = "call TRANSACCIONESALT();";					
					Object[] parametros = {};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TRANSACCIONESALT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								long transaccion = resultSet.getLong(1);					
								return transaccion;
				
						}
					});					
					transaccion = matches.size() > 0 ? ((Long) matches.get(0)).longValue() : 0; 
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al generar numero de transaccion", e);
					transaction.setRollbackOnly();
				}
				return transaccion;
			}
		});
		return numeroTransaccion;
		
		
	}
	//------------------ Geters y Seters ------------------------------------------------------
	
	
}
