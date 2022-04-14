package soporte.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import java.util.List;
import java.util.Arrays;

import org.springframework.transaction.support.TransactionCallback;

import general.bean.MensajeTransaccionBean;
import soporte.bean.ValidaCajasTransferBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionTemplate;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

public class ValidaCajasTransferDAO extends BaseDAO{

	public ValidaCajasTransferDAO(){
		super();
	}

	public MensajeTransaccionBean guardar(final ValidaCajasTransferBean instance, final int tipoAct){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final int valCajaParamID = 1;
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call VALCAJASPARAMETROSACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ValCajaParamID", valCajaParamID);
								sentenciaStore.setString("Par_HoraInicio", instance.getHoraInicio());
								sentenciaStore.setInt("Par_NumEjecuciones", Utileria.convierteEntero(instance.getNumEjecuciones()));
								sentenciaStore.setInt("Par_Intervalo", Utileria.convierteEntero(instance.getIntervalo()));
								sentenciaStore.setInt("Par_RemitenteID", Utileria.convierteEntero(instance.getRemitenteID()));
								sentenciaStore.setString("Par_Cron", instance.getExpresionCron());
								sentenciaStore.setInt("Par_NumAct", tipoAct);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ValidaCajasTransferDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ValidaCajasTransferDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar la Actualización" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean grabaDetalle(final ValidaCajasTransferBean instance, final int tipoAct, final List<ValidaCajasTransferBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = guardar(instance, tipoAct);
					if(mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean = bajaDestinatarios(instance);
					if(mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(ValidaCajasTransferBean detalle: listaDetalle) {
						mensajeBean = altaDestinatarios(detalle);
					}
				} catch(Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("grabar");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grabar detalle: ", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});
		return mensajeTransaccion;
	}

	/**
	 * Método de alta para los destinatarios
	 * @param instance : Clase bean que contiene los valores de los parámetros entrada al SP-VALCAJASDESTINATARIOSALT.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 **/
	public MensajeTransaccionBean altaDestinatarios(final ValidaCajasTransferBean instance) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call VALCAJASDESTINATARIOSALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(instance.getDestinatarioID()));
									sentenciaStore.setString("Par_Tipo", instance.getTipo());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call VALCAJASDESTINATARIOSALT "+sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ValCajasTransferDAO.alta");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							});
					if(mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ValCajasTransferDAO.altaDestinatarios");
					} else if(mensajeBean.getNumero() !=0 || mensajeBean.getNumero() != 000){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch(Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Destinatarios: ", e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método de baja de destinatarios
	 * @param instance : Clase bean que contiene los valores de los parámetros entrada al SP-VALCAJASDESTINATARIOSALT.
	 * @return MensajeTransaccionBean : Clase bean con el resultado de la transacción.
	 **/
	public MensajeTransaccionBean bajaDestinatarios(final ValidaCajasTransferBean instance) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call VALCAJASDESTINATARIOSBAJ(?,?,?,?,?,  ?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call VALCAJASDESTINATARIOSBAJ "+sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ValCajasTransferDAO.baja");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							});
					if(mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ValCajasTransferDAO.altaDestinatarios");
					} else if(mensajeBean.getNumero() !=0 || mensajeBean.getNumero() != 000){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch(Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de Destinatarios: ", e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Metodo para realizar las diferentes consultas
	 * @param instance Modelo requerido
	 * @param tipoConsulta Tipo de Transaccion
	 * @return validaCajasTransferBean Modelo que retorna una vez realizada la operacion
	 */
	public ValidaCajasTransferBean consultaPrincipal(ValidaCajasTransferBean instance, int tipoConsulta) {
		ValidaCajasTransferBean modelo = null;
		try{
			// Query con el Store Procedure
			String query = "call VALCAJASPARAMETROSCON(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(instance.getValCajaParamID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ValidaCajasTransferDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call VALCAJASPARAMETROSCON( " + Arrays.toString(parametros) + ")");
			@SuppressWarnings({ "unchecked", "rawtypes" })
			List<ValidaCajasTransferBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					ValidaCajasTransferBean modeloResult = new ValidaCajasTransferBean();

					modeloResult.setHoraInicio(resultSet.getString("HoraInicio"));
					modeloResult.setNumEjecuciones(resultSet.getString("NumEjecuciones"));
					modeloResult.setIntervalo(resultSet.getString("Intervalo"));
					modeloResult.setRemitenteID(resultSet.getString("RemitenteID"));

					return modeloResult;
				}
			});
			modelo =  matches.size() > 0 ? (ValidaCajasTransferBean) matches.get(0) : null;
		}catch(Exception e ){
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consultaPrincipal", e);
		}
		return modelo;
	}

	/**
	 * Metodo para consultar las diferentes listas
	 * @param instance Modelo requerido
	 * @param tipoLista Tipo de Transaccion
	 * @return List Retorna una lista de resultado
	 **/
	public List listaPrincipal(ValidaCajasTransferBean instance, int tipoLista) {
		List lista = null;
		try{
			String query = "call VALCAJASDESTINATARIOSLIS(?,?,?,?,?, ?,?,?);";
			Object[] parametros = {
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ValidaCajasTransferDAO.listaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call VALCAJASDESTINATARIOSLIS(" + Arrays.toString(parametros) +")");
			@SuppressWarnings({ "unchecked", "rawtypes" })
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ValidaCajasTransferBean modeloResult = new ValidaCajasTransferBean();

					modeloResult.setDestinatarioID(resultSet.getString("UsuarioID"));
					modeloResult.setDestinatarioNombre(resultSet.getString("NombreCompleto"));
					modeloResult.setTipo(resultSet.getString("Tipo"));
					modeloResult.setConCopiaID(resultSet.getString("UsuarioID"));
					return modeloResult;
				}
			});
			lista = matches;
		}catch(Exception e){
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en listaPrincipal", e);
		}
		return lista;
	}
}
