package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.bean.ConceptoContableBean;

public class ConceptoContableDAO extends BaseDAO {

	public ConceptoContableDAO() {
		super();
	}
	
	// ------------------ Transacciones ------------------------------------------
	
	/* Alta del Concepto Contable */
	public MensajeTransaccionBean alta(final ConceptoContableBean conceptoContable) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
						//Query con el Store Procedure
						String query = "call CONCEPTOSCONTAALT(?,?,?,?,?,?,?,?,?);";

						Object[] parametros = {	
								Utileria.convierteEntero(conceptoContable.getConceptoContableID()),
								parametrosAuditoriaBean.getEmpresaID(),
								conceptoContable.getDescripcion(),
																
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ConceptoContableDAO.alta",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSCONTAALT(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
								mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
								mensaje.setDescripcion(resultSet.getString(2));
								mensaje.setNombreControl(resultSet.getString(3));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de concepto contable", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	
	/* Modificacion del Concepto Contable */
	public MensajeTransaccionBean modifica(final ConceptoContableBean conceptoContable) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
						//Query con el Store Procedure
						String query = "call CONCEPTOSCONTAMOD(?,?,?,?,?,?,?,?,?);";

						Object[] parametros = {	
								Utileria.convierteEntero(conceptoContable.getConceptoContableID()),
								parametrosAuditoriaBean.getEmpresaID(),
								conceptoContable.getDescripcion(),
																
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ConceptoContableDAO.modifica",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSCONTAMOD(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
								mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
								mensaje.setDescripcion(resultSet.getString(2));
								mensaje.setNombreControl(resultSet.getString(3));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion contable", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;		
	}

	/* Baja del Concepto Contable */
	public MensajeTransaccionBean baja(final ConceptoContableBean conceptoContable) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
						//Query con el Store Procedure
						String query = "call CONCEPTOSCONTABAJ(?,?,?,?,?,?,?,?);";

						Object[] parametros = {	
								Utileria.convierteEntero(conceptoContable.getConceptoContableID()),
								parametrosAuditoriaBean.getEmpresaID(),							
																
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ConceptoContableDAO.baja",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSCONTABAJ(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
								mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
								mensaje.setDescripcion(resultSet.getString(2));
								mensaje.setNombreControl(resultSet.getString(3));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de concepto contable", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;		
	}

	/* Consuta Concepto Contable por Llave Principal*/
	public ConceptoContableBean  consultaPrincipal(ConceptoContableBean conceptoContable, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CONCEPTOSCONTACON(?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	Utileria.convierteEntero(conceptoContable.getConceptoContableID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ConceptoContableDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSCONTACON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {					
					ConceptoContableBean conceptoContablebeBean = new ConceptoContableBean();					
					conceptoContablebeBean.setConceptoContableID(String.valueOf(resultSet.getInt(1)));
					conceptoContablebeBean.setDescripcion(String.valueOf(resultSet.getString(2)));
					conceptoContablebeBean.setEmpresaID(String.valueOf(resultSet.getInt(3)));					
					return conceptoContablebeBean;
			}
		});	
		return matches.size() > 0 ? (ConceptoContableBean) matches.get(0) : null;
	}
	
	
	/* Lista Principal de los Conceptos Contables */
	public List listaPrincipal(ConceptoContableBean conceptoContable, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONCEPTOSCONTALIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
						conceptoContable.getDescripcion(),
						Constantes.ENTERO_CERO,
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ConceptoContableDAO.listaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSCONTALIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptoContableBean conceptoContablebeBean = new ConceptoContableBean();					
				conceptoContablebeBean.setConceptoContableID(String.valueOf(resultSet.getInt(1)));
				conceptoContablebeBean.setDescripcion(String.valueOf(resultSet.getString(2)));
				return conceptoContablebeBean;				
				
			}
		});
				
		return matches;
	}	
	
	
}
