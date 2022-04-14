package fira.dao;

import fira.bean.CalendarioMinistracionBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

public class CalendarioMinistracionDAO extends BaseDAO {

	public CalendarioMinistracionDAO() {
		super();
	}

	/**
	 * Registra el Calendario de Ministraciones de un Producto de Crédito Agropecuario.
	 * @param calendarioBean : Clase bean con los valores a los parámetros de entrada al SP-CALENDARIOMINISTRAALT.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean alta(final CalendarioMinistracionBean calendarioBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CALENDARIOMINISTRAALT("
											+ "	?,?,?,?,?,"
											+ "	?,?,?,?,?,"
											+ "	?,?,?,?,?,"
											+ "	?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(calendarioBean.getProductoCreditoID()));
									sentenciaStore.setString("Par_TomaFechaInhabil",calendarioBean.getTomaFechaInhabil());
									sentenciaStore.setString("Par_PermiteCalIrregular",calendarioBean.getPermiteCalIrregular());
									sentenciaStore.setString("Par_DiasCancelacion",calendarioBean.getDiasCancelacion());
									sentenciaStore.setString("Par_DiasMaxMinistraPosterior",calendarioBean.getDiasMaxMinistraPosterior());

									sentenciaStore.setString("Par_Frecuencias",calendarioBean.getFrecuencias());
									sentenciaStore.setString("Par_Plazos",calendarioBean.getPlazos());
									sentenciaStore.setString("Par_TipoCancelacion",calendarioBean.getTipoCancelacion());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de calendario ministraciones: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Modifica el Calendario de Ministraciones de un Producto de Crédito Agropecuario.
	 * @param calendarioBean : Clase bean con los valores a los parámetros de entrada al SP-CALENDARIOMINISTRAMOD.
	 * @return MensajeTransaccionBean con el resultado de la transacción.
	 * @author avelasco
	 */
	public MensajeTransaccionBean modificacion(final CalendarioMinistracionBean calendarioBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CALENDARIOMINISTRAMOD("
											+ "	?,?,?,?,?,"
											+ "	?,?,?,?,?,"
											+ "	?,?,?,?,?,"
											+ "	?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(calendarioBean.getProductoCreditoID()));
									sentenciaStore.setString("Par_TomaFechaInhabil",calendarioBean.getTomaFechaInhabil());
									sentenciaStore.setString("Par_PermiteCalIrregular",calendarioBean.getPermiteCalIrregular());
									sentenciaStore.setString("Par_DiasCancelacion",calendarioBean.getDiasCancelacion());
									sentenciaStore.setString("Par_DiasMaxMinistraPosterior",calendarioBean.getDiasMaxMinistraPosterior());

									sentenciaStore.setString("Par_Frecuencias",calendarioBean.getFrecuencias());
									sentenciaStore.setString("Par_Plazos",calendarioBean.getPlazos());
									sentenciaStore.setString("Par_TipoCancelacion",calendarioBean.getTipoCancelacion());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de calendario ministraciones: ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consulta el Calendario de Ministraciones de un Producto de Crédito Agropecuario.
	 * @param calendarioBean : Clase bean con los valores a los parámetros de entrada al SP-CALENDARIOMINISTRACON.
	 * @param tipoConsulta : Número de la consulta principal [1].
	 * @return CalendarioMinistracionBean con el resultado de la consulta.
	 * @author avelasco
	 */
	public CalendarioMinistracionBean consultaPrincipal(CalendarioMinistracionBean calendarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CALENDARIOMINISTRACON("
				+ "?,?,?,?,?,"
				+ "?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(calendarioBean.getProductoCreditoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALENDARIOMINISTRACON(" + Arrays.toString(parametros) + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CalendarioMinistracionBean calendarioBean = new CalendarioMinistracionBean();
				calendarioBean.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
				calendarioBean.setTomaFechaInhabil(resultSet.getString("TomaFechaInhabil"));
				calendarioBean.setPermiteCalIrregular(resultSet.getString("PermiteCalIrregular"));
				calendarioBean.setDiasCancelacion(resultSet.getString("DiasCancelacion"));
				calendarioBean.setDiasMaxMinistraPosterior(resultSet.getString("DiasMaxMinistraPosterior"));
				calendarioBean.setFrecuencias(resultSet.getString("Frecuencias"));
				calendarioBean.setPlazos(resultSet.getString("Plazos"));
				calendarioBean.setTipoCancelacion(resultSet.getString("TipoCancelacion"));
				return calendarioBean;
			}
		});
		return matches.size() > 0 ? (CalendarioMinistracionBean) matches.get(0) : null;
	}

}