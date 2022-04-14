package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.CalendarioProdBean;


public class CalendarioProdDAO extends BaseDAO{

	public CalendarioProdDAO() {
		super();
	}

	// Alta de Calendario por Producto de Credito
	public MensajeTransaccionBean altaCalendarioProducto(final CalendarioProdBean calendarioProdBean) {
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
									String query = "call CALENDARIOPRODALT("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProduCredID",Utileria.convierteEntero(calendarioProdBean.getProductoCreditoID()));
									sentenciaStore.setString("Par_FecHabTom",calendarioProdBean.getFecInHabTomar());
									sentenciaStore.setString("Par_AjFecExVen",calendarioProdBean.getAjusFecExigVenc());
									sentenciaStore.setString("Par_PermCalIrr",calendarioProdBean.getPermCalenIrreg());
									sentenciaStore.setString("Par_AjFecUAmVe",calendarioProdBean.getAjusFecUlAmoVen());

									sentenciaStore.setString("Par_TipoPagCap",calendarioProdBean.getTipoPagoCapital());
									sentenciaStore.setString("Par_IgCalInCap",calendarioProdBean.getIguaCalenIntCap());
									sentenciaStore.setString("Par_Frecuenc",calendarioProdBean.getFrecuencias());
									sentenciaStore.setString("Par_PlazoID",calendarioProdBean.getPlazoID());
									sentenciaStore.setString("Par_DiaPagoCap",calendarioProdBean.getDiaPagoCapital());

									sentenciaStore.setString("Par_DiaPagoInt",calendarioProdBean.getDiaPagoInteres());
									sentenciaStore.setString("Par_TipoDisp",calendarioProdBean.getTipoDispersion());
									sentenciaStore.setString("Par_DiaPagoQuincenal",calendarioProdBean.getDiaPagoQuincenal());
									sentenciaStore.setInt("Par_DiasReqPrimerAmor",Utileria.convierteEntero(calendarioProdBean.getDiasReqPrimerAmor()));

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de calendario del producto", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	// Modificacion de Calendario por Producto de Credito
	public MensajeTransaccionBean modificacionCalendarioProducto(final CalendarioProdBean calendarioProdBean) {

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
									String query = "call CALENDARIOPRODMOD("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ProduCredID",Utileria.convierteEntero(calendarioProdBean.getProductoCreditoID()));
									sentenciaStore.setString("Par_FecHabTom",calendarioProdBean.getFecInHabTomar());
									sentenciaStore.setString("Par_AjFecExVen",calendarioProdBean.getAjusFecExigVenc());
									sentenciaStore.setString("Par_PermCalIrr",calendarioProdBean.getPermCalenIrreg());
									sentenciaStore.setString("Par_AjFecUAmVe",calendarioProdBean.getAjusFecUlAmoVen());

									sentenciaStore.setString("Par_TipoPagCap",calendarioProdBean.getTipoPagoCapital());
									sentenciaStore.setString("Par_IgCalInCap",calendarioProdBean.getIguaCalenIntCap());
									sentenciaStore.setString("Par_Frecuenc",calendarioProdBean.getFrecuencias());
									sentenciaStore.setString("Par_PlazoID",calendarioProdBean.getPlazoID());
									sentenciaStore.setString("Par_DiaPagoCap",calendarioProdBean.getDiaPagoCapital());

									sentenciaStore.setString("Par_DiaPagoInt",calendarioProdBean.getDiaPagoInteres());
									sentenciaStore.setString("Par_TipoDisp",calendarioProdBean.getTipoDispersion());
									sentenciaStore.setString("Par_DiaPagoQuincenal",calendarioProdBean.getDiaPagoQuincenal());
									sentenciaStore.setInt("Par_DiasReqPrimerAmor",Utileria.convierteEntero(calendarioProdBean.getDiasReqPrimerAmor()));

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de calendario de producto", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	/* Consuta Principal de Calendario por Producto de credito*/
	public CalendarioProdBean consultaPrincipal(CalendarioProdBean calendarioProdBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CALENDARIOPRODCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(calendarioProdBean.getProductoCreditoID()),
				tipoConsulta,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CALENDARIOPRODCON(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CalendarioProdBean calendarioProdBean = new CalendarioProdBean();
				calendarioProdBean.setProductoCreditoID(String.valueOf(resultSet.getInt("ProductoCreditoID")));
				calendarioProdBean.setFecInHabTomar(resultSet.getString("FecInHabTomar"));
				calendarioProdBean.setAjusFecExigVenc(resultSet.getString("AjusFecExigVenc"));
				calendarioProdBean.setPermCalenIrreg(resultSet.getString("PermCalenIrreg"));
				calendarioProdBean.setAjusFecUlAmoVen(resultSet.getString("AjusFecUlAmoVen"));
				calendarioProdBean.setTipoPagoCapital(resultSet.getString("TipoPagoCapital"));
				calendarioProdBean.setIguaCalenIntCap(resultSet.getString("IguaCalenIntCap"));
				calendarioProdBean.setFrecuencias(resultSet.getString("Frecuencias"));
				calendarioProdBean.setPlazoID(resultSet.getString("PlazoID"));
				calendarioProdBean.setDiaPagoCapital(resultSet.getString("DiaPagoCapital"));
				calendarioProdBean.setDiaPagoInteres(resultSet.getString("DiaPagoInteres"));
				calendarioProdBean.setTipoDispersion(resultSet.getString("TipoDispersion"));
				calendarioProdBean.setDiaPagoQuincenal(resultSet.getString("DiaPagoQuincenal"));
				calendarioProdBean.setDiasReqPrimerAmor(resultSet.getString("DiasReqPrimerAmor"));

				return calendarioProdBean;

			}
		});
		return matches.size() > 0 ? (CalendarioProdBean) matches.get(0) : null;
	}

}
