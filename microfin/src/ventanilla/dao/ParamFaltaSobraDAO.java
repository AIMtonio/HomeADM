package ventanilla.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.bean.ParamFaltaSobraBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
import seguridad.servicio.SeguridadRecursosServicio;


public class ParamFaltaSobraDAO extends BaseDAO{

	public ParamFaltaSobraDAO (){
		super();
	}

	public MensajeTransaccionBean altaParametrosFaltaSobra(final ParamFaltaSobraBean paramFaltaSobraBean){
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
								String query = "call PARAMFALTASOBRAALT(?,?,?,?,?,    ?,?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(paramFaltaSobraBean.getSucursalID()));
								sentenciaStore.setDouble("Par_MontoMaximoSobra",Utileria.convierteDoble(paramFaltaSobraBean.getMontoMaximoSobra()));
								sentenciaStore.setDouble("Par_MontoMaximoFalta",Utileria.convierteDoble(paramFaltaSobraBean.getMontoMaximoFalta()));

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);

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
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Alta de Parametros Faltantes y Sobrantes", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	public MensajeTransaccionBean modificaParametros(final ParamFaltaSobraBean paramFaltaSobraBean){
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
								String query = "call PARAMFALTASOBRAMOD(?,?,?,?,?,    ?,?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(paramFaltaSobraBean.getSucursalID()));
								sentenciaStore.setDouble("Par_MontoMaximoSobra",Utileria.convierteDoble(paramFaltaSobraBean.getMontoMaximoSobra()));
								sentenciaStore.setDouble("Par_MontoMaximoFalta",Utileria.convierteDoble(paramFaltaSobraBean.getMontoMaximoFalta()));

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.setInt("Par_NumErr",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_ErrMen",Constantes.STRING_VACIO);

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
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificar de Parametros Faltantes y Sobrantes", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Consulta de Parametros de Sobrantes y Faltantes
	public ParamFaltaSobraBean consultaPrincipal(ParamFaltaSobraBean paramFaltaSobraBean, int tipoConsulta) {
		ParamFaltaSobraBean consultaBean = null;

		try{
			String query = "call PARAMFALTASOBRACON(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(paramFaltaSobraBean.getSucursalID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMFALTASOBRACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ParamFaltaSobraBean parametros = new ParamFaltaSobraBean();

					parametros.setParamFaltaSobraID(resultSet.getString("ParamFaltaSobraID"));
					parametros.setSucursalID(resultSet.getString("SucursalID"));
					parametros.setMontoMaximoSobra(resultSet.getString("MontoMaximoSobra"));
					parametros.setMontoMaximoFalta(resultSet.getString("MontoMaximoFalta"));

					return parametros;
				}
			});
			consultaBean= matches.size() > 0 ? (ParamFaltaSobraBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta Principal de Parametros Sobrantes y Faltantes", e);
		}
		return consultaBean;
	}
	/**
	 * se usa en Ventanilla para el ajuste por Sobrante
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean ajusteSobrante(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							ingresosOperacionesBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(ingresosOperacionesBean.getUsuarioAut(), ingresosOperacionesBean.getContraseniaAut()));
							String query = "call AJUSTESOBRANTEPRO(?,?,?,?,?,    ?,?,?,?,?, ?,?,?,?,? ,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_Sucursal", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setString("Par_Clave", ingresosOperacionesBean.getUsuarioAut());
							sentenciaStore.setString("Par_Contrasenia", ingresosOperacionesBean.getContraseniaAut());
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Ajuste por Faltante Ventanilla", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Ajuste por Faltante Ventanilla", e);
					}
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para realizar el ajuste de faltante de la Caja
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean ajusteFaltante(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					ingresosOperacionesBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(ingresosOperacionesBean.getUsuarioAut(), ingresosOperacionesBean.getContraseniaAut()));
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call AJUSTEFALTANTEPRO(?,?,?,?,?,    ?,?,?,?,?, ?,?,?,?,? ,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_Sucursal", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setString("Par_Clave", ingresosOperacionesBean.getUsuarioAut());
							sentenciaStore.setString("Par_Contrasenia", ingresosOperacionesBean.getContraseniaAut());
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Ajuste por Faltante Ventanilla", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Ajuste por Faltante Ventanilla", e);
					}
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


}
