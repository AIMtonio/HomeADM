package cuentas.dao;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
import inversiones.bean.InversionBean;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import operacionesPDA.beanWS.request.SP_PDA_Ahorros_DescargaRequest;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import bancaMovil.bean.BAMUsuariosBean;
import soporte.bean.SucursalesBean;
import tesoreria.bean.DepositosRefeBean;
import ventanilla.bean.IngresosOperacionesBean;
import cliente.bean.ClienteBean;

import java.sql.ResultSetMetaData;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import cuentas.bean.AnaliticoAhorroBean;
import cuentas.bean.BloqueoCuentaBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.bean.DesbloqueoMasCtaBean;
import cuentas.bean.IDEMensualBean;
import cuentas.bean.RepSaldosGlobalesBean;
import cuentas.beanWS.request.ConsultaCuentasPorClienteRequest;
import cuentas.beanWS.request.ConsultaDisponiblePorClienteRequest;
import cuentas.beanWS.request.ListaCuentaAhoRequest;
import cuentas.beanWS.response.ConsultaCuentasPorClienteResponse;
import cuentas.beanWS.response.ConsultaDisponiblePorClienteResponse;

public class CuentasAhoDAO extends BaseDAO  {

	ParametrosSesionBean parametrosSesionBean;
	PolizaDAO polizaDAO = new PolizaDAO();

	public CuentasAhoDAO() {
		super();
	}
	private final static String salidaPantalla = "S";


	/* Alta del Cuenta de Ahorro*/
	public MensajeTransaccionBean altaCuentasAho(final CuentasAhoBean cuentasAho) {
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

									String query = "call CUENTASAHOALT(" +
											"?,?,?,?,?," +
											"?,?,?,?,?," +
											"?,?," +
											"?,?,?,"+//
											"?,?,?,?,?,?,?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(cuentasAho.getSucursalID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasAho.getClienteID()));
									sentenciaStore.setString("Par_Clabe",cuentasAho.getClabe());
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(cuentasAho.getMonedaID()));
									sentenciaStore.setInt("Par_TipoCuentaID",Utileria.convierteEntero(cuentasAho.getTipoCuentaID()));

									sentenciaStore.setString("Par_FechaReg",Utileria.convierteFecha(cuentasAho.getFechaReg()));
									sentenciaStore.setString("Par_Etiqueta",cuentasAho.getEtiqueta());
									sentenciaStore.setString("Par_EdoCta",cuentasAho.getEstadoCta());
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(cuentasAho.getInstitucionID()));
									sentenciaStore.setString("Par_EsPrincipal",cuentasAho.getEsPrincipal());

									sentenciaStore.setString("Par_TelefonoCelular",cuentasAho.getTelefonoCelular());
									sentenciaStore.registerOutParameter("Par_CuentaAho", Types.BIGINT);

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CuentasAhoDAO.altaCuentasAho");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CuentasAhoDAO.altaCuentasAho");
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de ahorro", e);
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


	/* Alta del Cuenta de Ahorro */
	public MensajeTransaccionBean altaCuentasAhoWS(final CuentasAhoBean cuentasAho) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("microfin")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CUENTASAHOALT(" +
											"?,?,?,?,?," +
											"?,?,?,?,?," +
											"?,?,?,?,?,"+//
											"?,?,?,?,?,?,?);";//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(cuentasAho.getSucursalID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(cuentasAho.getClienteID()));
									sentenciaStore.setString("Par_Clabe",cuentasAho.getClabe());
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(cuentasAho.getMonedaID()));
									sentenciaStore.setInt("Par_TipoCuentaID",Utileria.convierteEntero(cuentasAho.getTipoCuentaID()));

									sentenciaStore.setString("Par_FechaReg",Utileria.convierteFecha(cuentasAho.getFechaReg()));
									sentenciaStore.setString("Par_Etiqueta",cuentasAho.getEtiqueta());
									sentenciaStore.setString("Par_EdoCta",cuentasAho.getEstadoCta());
									sentenciaStore.setInt("Par_InstitucionID",Utileria.convierteEntero(cuentasAho.getInstitucionID()));
									sentenciaStore.setString("Par_EsPrincipal",cuentasAho.getEsPrincipal());

									sentenciaStore.setString("Par_TelefonoCelular",cuentasAho.getTelefonoCelular());
									sentenciaStore.registerOutParameter("Par_CuentaAho", Types.BIGINT);
									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"),""));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CuentasAhoDAO.altaCuentasAho");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CuentasAhoDAO.altaCuentasAho");
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de cuentas de ahorro", e);
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



	public MensajeTransaccionBean modificaCuentasAho(final CuentasAhoBean cuentasAho){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				cuentasAho.setTelefonoCelular(cuentasAho.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call CUENTASAHOMOD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							cuentasAho.getCuentaAhoID(),
							Utileria.convierteEntero(cuentasAho.getSucursalID()),
							Utileria.convierteEntero(cuentasAho.getClienteID()),
							cuentasAho.getClabe(),//CLABE
							Utileria.convierteEntero(cuentasAho.getMonedaID()),
							Utileria.convierteEntero(cuentasAho.getTipoCuentaID()),
							Utileria.convierteFecha(cuentasAho.getFechaReg()),
							cuentasAho.getEtiqueta(),
							cuentasAho.getEstadoCta(),
							Utileria.convierteEntero(cuentasAho.getInstitucionID()),
							cuentasAho.getEsPrincipal(),
							cuentasAho.getTelefonoCelular(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOMOD(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(Utileria.generaLocale(resultSet.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de cuentas de ahorro", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Apertura de la cuenta numero de actualizacion 1
	 * @param cuentasAho
	 * @param tipoActualizacion Autorizacion de la Cuenta:1
	 * @return
	 */
	public MensajeTransaccionBean aperturaCtaAho(final CuentasAhoBean cuentasAho, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL CUENTASAHOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentasAho.getCuentaAhoID()));
									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(cuentasAho.getUsuarioApeID()));
									sentenciaStore.setDate("Par_Fecha", OperacionesFechas.conversionStrDate(cuentasAho.getFechaApertura()));
									sentenciaStore.setString("Par_Motivo", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setNombreControl("cuentaAhoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==501){ /* Error que corresponde cuando se detecta en lista de pers bloqueadas */
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Autorización de la Cuenta: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CuentasAhoDAO.aperturaCtaAho: Error en Autorizacion de la Cuenta.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Bloqueo de la Cuenta de Ahorro
	 * @param cuentasAho Bean de la Cuenta de Ahorro
	 * @param tipoActualizacion Actualizacion 2
	 * @return
	 */
	public MensajeTransaccionBean bloqueoCtaAho(final CuentasAhoBean cuentasAho, final int tipoActualizacion) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL CUENTASAHOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentasAho.getCuentaAhoID()));
									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(cuentasAho.getUsuarioBloID()));
									sentenciaStore.setDate("Par_Fecha", OperacionesFechas.conversionStrDate(cuentasAho.getFechaBlo()));
									sentenciaStore.setString("Par_Motivo", cuentasAho.getMotivoBlo());
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setNombreControl("cuentaAhoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CuentasAhoDAO.bloqueoCtaAho: Error en Bloquero de la Cuenta.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Desbloqueo de la cuenta de ahorro
	 * @param cuentasAho Bean CuentasAhoBean
	 * @param tipoActualizacion Actualizacion 3 Desbloqueo de la cuenta
	 * @return
	 */
	public MensajeTransaccionBean desbloqueoCtaAho(final CuentasAhoBean cuentasAho, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL CUENTASAHOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentasAho.getCuentaAhoID()));
									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(cuentasAho.getUsuarioBloID()));
									sentenciaStore.setDate("Par_Fecha", OperacionesFechas.conversionStrDate(cuentasAho.getFechaBlo()));
									sentenciaStore.setString("Par_Motivo", cuentasAho.getMotivoBlo());
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setNombreControl("cuentaAhoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CuentasAhoDAO.desbloqueoCtaAho: Error en Bloquero de la Cuenta.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Cancelacion de la cuenta de ahorro
	 * @param cuentasAho Bean CuentasAhoBean
	 * @param tipoActualizacion Numero de actualización 4
	 * @return
	 */
	public MensajeTransaccionBean cancelacionCtaAho(final CuentasAhoBean cuentasAho, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL CUENTASAHOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentasAho.getCuentaAhoID()));
									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(cuentasAho.getUsuarioCanID()));
									sentenciaStore.setDate("Par_Fecha", OperacionesFechas.conversionStrDate(cuentasAho.getFechaCan()));
									sentenciaStore.setString("Par_Motivo", cuentasAho.getMotivoCan());
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setNombreControl("cuentaAhoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CuentasAhoDAO.cancelacionCtaAho: Error en Cancelacion de la Cuenta.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public CuentasAhoBean consultaForanea(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
										+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasAhoBean cuentasAho = new CuentasAhoBean();

				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString(2),ClienteBean.LONGITUD_ID));
				return cuentasAho;
			}
		});

		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	//consulta que se hace desde la pantalla de registro
	public CuentasAhoBean consultaPantallaRegistro(CuentasAhoBean cuentasAho, int tipoConsulta){
		CuentasAhoBean cuentasAhoBean = null;
		try{
			String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
					+ "?,?,?,?,?,?,?);";
			Object[] parametros = {
					cuentasAho.getCuentaAhoID(),
					Utileria.convierteLong(cuentasAho.getClienteID()),
					Utileria.convierteEntero(cuentasAho.getMes()),
					Utileria.convierteEntero(cuentasAho.getAnio()),
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasAhoDAO.consultaPantallaRegistro",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasAhoBean cuentasAho = new CuentasAhoBean();

					cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1), CuentasAhoBean.LONGITUD_ID));
					cuentasAho.setSucursalID(Utileria.completaCerosIzquierda(resultSet.getInt(2),SucursalesBean.LONGITUD_ID));
					cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString(3), ClienteBean.LONGITUD_ID));
					cuentasAho.setClabe(resultSet.getString(4));
					cuentasAho.setMonedaID(resultSet.getString(5));

					cuentasAho.setTipoCuentaID(resultSet.getString(6));
					cuentasAho.setFechaReg(resultSet.getString(7));
					cuentasAho.setEtiqueta(resultSet.getString(8));
					cuentasAho.setEstatus(resultSet.getString(9));
					cuentasAho.setEstadoCta(resultSet.getString(10));

					cuentasAho.setInstitucionID(resultSet.getString(11));
					cuentasAho.setEsPrincipal(resultSet.getString(12));
					cuentasAho.setMotivoBlo(resultSet.getString(13));
					cuentasAho.setTelefonoCelular(resultSet.getString(14));
					cuentasAho.setEstatusDepositoActiva(resultSet.getString("EstatusDepositoActiva"));
					return cuentasAho;
				}
			});
			cuentasAhoBean = matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;

		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuenta de ahorro", e);
		}
		return cuentasAhoBean;
	}

	public CuentasAhoBean consultaCampos(CuentasAhoBean cuentasAho, int tipoConsulta){
		CuentasAhoBean cuentasAhoBean = null;

		try{
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Utileria.convierteLong(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaCampos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setSucursalID(Utileria.completaCerosIzquierda(resultSet.getInt(2),SucursalesBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getLong(3), ClienteBean.LONGITUD_ID));
				cuentasAho.setClabe(resultSet.getString(4));
				cuentasAho.setMonedaID(resultSet.getString(5));
				cuentasAho.setDescripcionMoneda(resultSet.getString(6));
				cuentasAho.setTipoCuentaID(resultSet.getString(7));
				cuentasAho.setDescripcionTipoCta(resultSet.getString(8));
				cuentasAho.setFechaReg(resultSet.getString(9));
				cuentasAho.setEtiqueta(resultSet.getString(10));
				cuentasAho.setEstatus(resultSet.getString(11));
				cuentasAho.setTotalPersonas(resultSet.getString(12));
				cuentasAho.setSaldo(resultSet.getString("Saldo"));
				cuentasAho.setSaldoDispon(resultSet.getString("SaldoDispon"));
				cuentasAho.setDescripCortaMon(resultSet.getString("DescriCorta"));

				return cuentasAho;
			}
		});
		cuentasAhoBean = matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuenta de ahorro", e);
		}
		return cuentasAhoBean;
	}


	public CuentasAhoBean cuentasProdAut(CuentasAhoBean cuentasAho, int tipoConsulta){
		CuentasAhoBean cuentas= new CuentasAhoBean();
		try{
			//Query con el Store Procedure
			String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
					+ "?,?,?,?,?,?,?);";
			Object[] parametros = {
					cuentasAho.getCuentaAhoID(),
					cuentasAho.getClienteID(),
					Utileria.convierteEntero(cuentasAho.getMes()),
					Utileria.convierteEntero(cuentasAho.getAnio()),
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasAhoDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};//numTransaccion
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) + ")");

				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CuentasAhoBean CuentasAho = new CuentasAhoBean();
					CuentasAho.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					CuentasAho.setSucursalID(resultSet.getString("SucursalID"));
					CuentasAho.setClienteID(resultSet.getString("ClienteID"));
					CuentasAho.setClabe(resultSet.getString("Clabe"));
					CuentasAho.setMonedaID(resultSet.getString("MonedaID"));

					CuentasAho.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
					CuentasAho.setFechaReg(resultSet.getString("FechaReg"));
					CuentasAho.setFechaApertura(resultSet.getString("FechaApertura"));
					CuentasAho.setUsuarioApeID(resultSet.getString("UsuarioApeID"));
					CuentasAho.setEtiqueta(resultSet.getString("Etiqueta"));

					CuentasAho.setUsuarioCanID(resultSet.getString("UsuarioCanID"));
					CuentasAho.setFechaCan(resultSet.getString("FechaCan"));
					CuentasAho.setMotivoCan(resultSet.getString("MotivoCan"));
					CuentasAho.setMotivoBlo(resultSet.getString("MotivoBlo"));
					CuentasAho.setUsuarioBloID(resultSet.getString("UsuarioBloID"));

					CuentasAho.setMotivoDesbloq(resultSet.getString("MotivoDesbloq"));
					CuentasAho.setFechaDesbloq(resultSet.getString("FechaDesbloq"));
					CuentasAho.setUsuarioDesbID(resultSet.getString("UsuarioDesbID"));
					CuentasAho.setSaldo(resultSet.getString("Saldo"));
					CuentasAho.setSaldoDispon(resultSet.getString("SaldoDispon"));

					CuentasAho.setSaldoBloq(resultSet.getString("SaldoBloq"));
					CuentasAho.setSaldoSBC(resultSet.getString("SaldoSBC"));
					CuentasAho.setSaldoIniMes(resultSet.getString("SaldoIniMes"));
					CuentasAho.setCargosMes(resultSet.getString("CargosMes"));
					CuentasAho.setAbonosMes(resultSet.getString("AbonosMes"));

					CuentasAho.setComisiones(resultSet.getString("Comisiones"));
					CuentasAho.setSaldoProm(resultSet.getString("SaldoProm"));
					CuentasAho.setTasaInteres(resultSet.getString("TasaInteres"));
					CuentasAho.setInteresesGen(resultSet.getString("InteresesGen"));
					CuentasAho.setISR(resultSet.getString("ISR"));

					CuentasAho.setTasaISR(resultSet.getString("TasaISR"));
					CuentasAho.setSaldoIniDia(resultSet.getString("SaldoIniDia"));
					CuentasAho.setCargosDia(resultSet.getString("CargosDia"));
					CuentasAho.setAbonosDia(resultSet.getString("AbonosDia"));
					CuentasAho.setEstatus(resultSet.getString("Estatus"));

					CuentasAho.setEstadoCta(resultSet.getString("EstadoCta"));
					CuentasAho.setInstitucionID(resultSet.getString("InstitucionID"));
					CuentasAho.setEsPrincipal(resultSet.getString("EsPrincipal"));
					CuentasAho.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
					CuentasAho.setTasaRendimiento(resultSet.getString("Tasa"));


					return CuentasAho;


				}// trows ecexeption
			});//lista

			cuentas= matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de Cuentas de Ahorro", e);
		}
		return cuentas;
	}// consultaPrincipal

	/*consulta por saldo*/
	public CuentasAhoBean consultaSaldoDisponible(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(cuentasAho.getCuentaAhoID()),
				Utileria.convierteLong(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaSaldoDisponible",
				Constantes.ENTERO_CERO,
				Utileria.convierteLong(cuentasAho.getNumMensaje())
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getLong("ClienteID"), ClienteBean.LONGITUD_ID));
				cuentasAho.setSaldo(resultSet.getString("Saldo"));
				cuentasAho.setSaldoDispon(resultSet.getString("SaldoDispon"));
				cuentasAho.setSaldoSBC(resultSet.getString("SaldoSBC"));
				cuentasAho.setSaldoBloq(resultSet.getString("SaldoBloq"));
				cuentasAho.setMonedaID(resultSet.getString("MonedaID"));
				cuentasAho.setDescripcionMoneda(resultSet.getString("DescriCorta"));
				cuentasAho.setEstatus(resultSet.getString("Estatus"));
				cuentasAho.setGat(resultSet.getString("Gat"));
				cuentasAho.setSaldoProm(resultSet.getString("SaldoProm"));
				cuentasAho.setValorGatReal(resultSet.getString("GatReal"));
				return cuentasAho;
			}
		});
		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	public CuentasAhoBean consultaSaldos(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaSaldos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getLong("ClienteID"),ClienteBean.LONGITUD_ID));
				cuentasAho.setMonedaID(resultSet.getString("MonedaID"));
				cuentasAho.setSaldoIniMes(resultSet.getString("SaldoIniMes"));
				cuentasAho.setCargosMes(resultSet.getString("CargoMes"));
				cuentasAho.setAbonosMes(resultSet.getString("AbonosMes"));
				cuentasAho.setSaldoIniDia(resultSet.getString("SaldoIniDia"));
				cuentasAho.setCargosDia(resultSet.getString("CargosDia"));
				cuentasAho.setAbonosDia(resultSet.getString("AbonosDia"));
				cuentasAho.setSumCanPenAct(resultSet.getString("Var_SumPenAct"));
				return cuentasAho;
			}
		});
		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	/* Consulta de la Cuenta de Ahorro: Saldo Disponible y Estatus de la Cuenta */
	public CuentasAhoBean consultaSaldoYEstatus(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaSaldoYEstatus",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt(1), ClienteBean.LONGITUD_ID));
				cuentasAho.setSaldoDispon(resultSet.getString(2));
				cuentasAho.setMonedaID(String.valueOf(resultSet.getInt(3)));
				cuentasAho.setEstatus(resultSet.getString(4));
				return cuentasAho;
			}
		});
		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	/* Consulta de la cuenta para la garantia liquida adicional */
	public CuentasAhoBean consultaCtaGLAdicional(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(cuentasAho.getCuentaAhoID()),
				Utileria.convierteLong(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaCtaGLAdicional",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"), CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getLong("ClienteID"), ClienteBean.LONGITUD_ID));
				return cuentasAho;
			}
		});
		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	/*consulta por saldo consultando tambien el Historico*/
	public CuentasAhoBean consultaSaldoDisponibleHistorico(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOHISCON(?,?,?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Constantes.ENTERO_CERO,
				cuentasAho.getMes(),
				cuentasAho.getAnio(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaSaldoDisponible",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOHISCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt(2), ClienteBean.LONGITUD_ID));
				cuentasAho.setSaldo(resultSet.getString(3));
				cuentasAho.setSaldoDispon(resultSet.getString(4));
				cuentasAho.setSaldoSBC(resultSet.getString(5));
				cuentasAho.setSaldoBloq(resultSet.getString(6));
				cuentasAho.setMonedaID(resultSet.getString(7));
				cuentasAho.setDescripcionMoneda(resultSet.getString(8));
				cuentasAho.setEstatus(resultSet.getString(9));
				cuentasAho.setSumCanPenAct(resultSet.getString("Var_SumPenAct"));
				cuentasAho.setGat(resultSet.getString("Gat"));
				cuentasAho.setSaldoProm(resultSet.getString("SaldoProm"));
				cuentasAho.setValorGatReal(resultSet.getString("GatReal"));

				return cuentasAho;
			}
		});
		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	/*consulta por saldo inicial final consultando tambien el Historico*/
	public CuentasAhoBean consultaSaldosHistorico(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOHISCON(" +
				"?,?,?,?,? ,?,?,?,?,?," +
				"?,?);";
		Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Constantes.ENTERO_CERO,
				cuentasAho.getMes(),
				cuentasAho.getAnio(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaSaldos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOHISCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getLong("ClienteID"),ClienteBean.LONGITUD_ID));
				cuentasAho.setMonedaID(resultSet.getString("MonedaID"));
				cuentasAho.setSaldoIniMes(resultSet.getString("SaldoIniMes"));
				cuentasAho.setCargosMes(resultSet.getString("CargoMes"));
				cuentasAho.setAbonosMes(resultSet.getString("AbonosMes"));
				cuentasAho.setSaldoIniDia(resultSet.getString("SaldoIniDia"));
				cuentasAho.setCargosDia(resultSet.getString("CargosDia"));
				cuentasAho.setAbonosDia(resultSet.getString("AbonosDia"));
				cuentasAho.setSumCanPenAct(resultSet.getString("Var_SumPenAct"));
				return cuentasAho;
			}
		});
		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	public ConsultaDisponiblePorClienteResponse consultaDisponiblePorCliente(ConsultaDisponiblePorClienteRequest consultaDisponiblePorCliente,int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(consultaDisponiblePorCliente.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaDisponiblePorCliente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				ConsultaDisponiblePorClienteResponse consultaDisponiblePorClienteResponse = new ConsultaDisponiblePorClienteResponse();
				consultaDisponiblePorClienteResponse.setSaldoDispon(resultSet.getString(1));
				consultaDisponiblePorClienteResponse.setCodigoRespuesta(resultSet.getString(2));
				consultaDisponiblePorClienteResponse.setMensajeRespuesta(resultSet.getString(3));
				return consultaDisponiblePorClienteResponse;
			}
		});
		return matches.size() > 0 ? (ConsultaDisponiblePorClienteResponse) matches.get(0) : null;
	}


	public List consultaCtaCteWS(ConsultaCuentasPorClienteRequest cuentasAho, int tipoConsulta){
		final ConsultaCuentasPorClienteResponse mensajeBean = new ConsultaCuentasPorClienteResponse();
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaCtaCteWS",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConsultaCuentasPorClienteResponse cuentasAho = new ConsultaCuentasPorClienteResponse();
				cuentasAho.setInfocuenta(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID)
						+"&;&"+resultSet.getString(2)+"&;&"+resultSet.getString(3));
				cuentasAho.setCodigoRespuesta(resultSet.getString(4));
				cuentasAho.setMensajeRespuesta(resultSet.getString(5));
				if (Integer.parseInt(cuentasAho.getCodigoRespuesta())== 0) {
					return cuentasAho;
				}
				else return mensajeBean;
			}
		});
		return matches;
	}

	/*consulta para la cuenta principal*/
	public CuentasAhoBean consultaCuentaPrincipal(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaCuentaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasAhoBean cuentasAho = new CuentasAhoBean();

				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString(2),ClienteBean.LONGITUD_ID));
				return cuentasAho;
			}
		});

		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	/*consulta para la cuenta principal con estatus activo, limita a mostar un solo registro*/
	public CuentasAhoBean consultaCuentaPrincipalActiva(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaCuentaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString(2),ClienteBean.LONGITUD_ID));
				return cuentasAho;
			}
		});
		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	/*consulta de cuentas del cliente para la alta en pademobile*/
	public CuentasAhoBean consultaCtaCteAct(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
										+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(cuentasAho.getCuentaAhoID()),
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasAhoDAO.consultaCuentaCliente",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt(2),ClienteBean.LONGITUD_ID));
				cuentasAho.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
				return cuentasAho;
			}
		});
		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}


	public List listaNumCliente(CuentasAhoBean cuentasAho, int tipoLista){
		String query = "call CUENTASAHOLIS(?,?,?,?,?,"
										+ "?,?,?,?,?,"
										+ "?,?);";
		Object[] parametros = {
					0,
					Utileria.convierteEntero(cuentasAho.getClienteID()),
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setEtiqueta(resultSet.getString(2));//devuelve la descripcion de la cuenta de ahorro
				return cuentasAho;
			}
		});
		return matches;
	}

	/* Lista de Cuentas por Nombre del Cliente */

public List listaCuentasAhoWS(ListaCuentaAhoRequest listaCuentaAhoRequest) {
			//Query con el Store Procedure
		String query = "call CUENTASAHOLIS(?,?,?,?,?,"
										+ "?,?,?,?,?,"
										+ "?,?);";
		Object[] parametros = {
								listaCuentaAhoRequest.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								Utileria.convierteEntero(listaCuentaAhoRequest.getNumLis()),

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ClienteDAO.listaClienteWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				cuentasAho.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return cuentasAho;
			}
		});
		return matches;
	}


	public CuentasAhoBean consultaResumenCte(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaResumenCte",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasAhoBean cuentasAho = new CuentasAhoBean();

				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setTipoCuentaID(resultSet.getString(2));
				cuentasAho.setEtiqueta(resultSet.getString(3));
				cuentasAho.setSaldoDispon(resultSet.getString(4));
				return cuentasAho;
			}
		});

		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}

	// consulta que se usa en ventanilla cobro seguro vida ayuda
	public CuentasAhoBean consultaCtaBeneficiario(CuentasAhoBean cuentasAho, int tipoConsulta){
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaResumenCte",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				CuentasAhoBean cuentasAho = new CuentasAhoBean();

				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));

				return cuentasAho;
			}
		});

		return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}



	public List listaCtasCliente(CuentasAhoBean cuentasAho, int tipoLista){
		String query = "call CUENTASAHOLIS(?,?,?,?,?,"
										+ "?,?,?,?,?,"
										+ "?,?);";
		Object[] parametros = {
					cuentasAho.getClienteID(),
					0,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(resultSet.getString(2));//devuelve el nombre del cliente
				cuentasAho.setEtiqueta(resultSet.getString(3));//devuelve la descripcion de la cuenta de ahorro
				return cuentasAho;
			}
		});
		return matches;
	}

	public List listaCtasClienteTodas(CuentasAhoBean cuentasAho, int tipoLista){
		String query = "call CUENTASAHOLIS(?,?,?,?,?,"
										+ "?,?,?,?,?,"
										+ "?,?);";
		Object[] parametros = {
					0,
					Utileria.convierteEntero(cuentasAho.getClienteID()),
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setEtiqueta(resultSet.getString(2));//devuelve la descripcion de la cuenta de ahorro
				return cuentasAho;
			}
		});
		return matches;
	}

	public List<CuentasAhoBean> listaResumenCte(CuentasAhoBean cuentasAho, int tipoLista){
		List<CuentasAhoBean> listaCuentasAhoBean = null;
		try{
			String query = "CALL CUENTASAHOLIS(?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					Utileria.convierteEntero(cuentasAho.getClienteID()),
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasAhoBean cuentasAho = new CuentasAhoBean();
					cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
					cuentasAho.setTipoCuentaID(resultSet.getString(2));
					cuentasAho.setEtiqueta(resultSet.getString(3));
					cuentasAho.setSaldo(resultSet.getString(4));
					cuentasAho.setSaldoDispon(resultSet.getString(5));
					cuentasAho.setSaldoBloq(resultSet.getString(6));
					cuentasAho.setSaldoSBC(resultSet.getString(7));
					cuentasAho.setEstatus(resultSet.getString(8));
					return cuentasAho;

				}
			});

			listaCuentasAhoBean = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Resumen de Cuentas de Ahorro ", exception);
			listaCuentasAhoBean = null;
		}

		return listaCuentasAhoBean;
	}

	public List listaClabeCliente(CuentasAhoBean cuentasAho, int tipoLista){
		String query = "call CUENTASAHOLIS(?,?,?,?,?,"
										+ "?,?,?,?,?,"
										+ "?,?);";
		Object[] parametros = {
					cuentasAho.getClabe(),
					Constantes.ENTERO_CERO,
					cuentasAho.getInstitucionID(),
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setClabe(resultSet.getString(1));
				cuentasAho.setEtiqueta(resultSet.getString(2));
				return cuentasAho;
			}
		});
		return matches;
	}



	/* Lista de Cuentas para pantalla de Asociacion de Tarjetas*/
	public List listaCtasAsocia(CuentasAhoBean cuentasAho, int tipoLista){
		String query = "call CUENTASAHOLIS(?,?,?,?,?,"
										+ "?,?,?,?,?,"
										+ "?,?);";
		Object[] parametros = {
					cuentasAho.getClienteID(),
					0,
					Constantes.ENTERO_CERO,
					cuentasAho.getLisTipoCuentas(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setClienteID(resultSet.getString(2));//devuelve el nombre del cliente
				cuentasAho.setEtiqueta(resultSet.getString(3));//devuelve la descripcion de la cuenta de ahorro
				return cuentasAho;
			}
		});
		return matches;
	}


	/* Consulta de desbloqueo masivo de cuentas */
	public DesbloqueoMasCtaBean consultaDesbloqueoMasivoCuentas(
			DesbloqueoMasCtaBean desbloqueoCuentas, int tipoConsulta) {
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaDesbloqueoMasivoCuentas",

				Constantes.ENTERO_CERO, Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros)
				+ ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				DesbloqueoMasCtaBean desbloqueoCta = new DesbloqueoMasCtaBean();
				desbloqueoCta.setCuentaDesbloq(resultSet.getString(1));
				desbloqueoCta.setSaldoDesbloq(resultSet.getString(2));
				return desbloqueoCta;
			}
		});
		return matches.size() > 0 ? (DesbloqueoMasCtaBean) matches.get(0) : null;
	}

	/* Consulta de la cuenta de bloqueo de automatico masivo */
	public BloqueoCuentaBean consultaCtaBloqueMasivo(
			BloqueoCuentaBean cuentasBloqueo, int tipoConsulta) {
		String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
				+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoConsulta,

				Constantes.ENTERO_CERO, Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA, Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaCtaBloqueMasivo",
				Constantes.ENTERO_CERO, Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros)
				+ ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				BloqueoCuentaBean bloqueoCta = new BloqueoCuentaBean();
				bloqueoCta.setCtaBloqueo(resultSet.getString(1));
				bloqueoCta.setSaldoBloqueo(resultSet.getString(2));
				return bloqueoCta;
			}
		});
		return matches.size() > 0 ? (BloqueoCuentaBean) matches.get(0) : null;
	}


	// Proceso de Desbloqueo Masivo de Cuentas*/
	public MensajeTransaccionBean desbloqueoCuentaMas() {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(
								Connection arg0)
								throws SQLException {
							String query = "call CUEAHOBLOQDESMASPRO(?,?,?,?,?   ,?,?,?,?,?,    ?);";
						   CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_Proceso",	DesbloqueoMasCtaBean.desbloqueo);
							sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
							// Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

							// Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;

						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(
								CallableStatement callableStatement)
								throws SQLException,
								DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR+ " .CuentasAhoDAO.desbloqueoCuentaMas");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
						}
						return mensajeTransaccion;
					}
				});
		if (mensajeBean == null) {
			mensajeBean = new MensajeTransaccionBean();
			mensajeBean.setNumero(999);
			throw new Exception(Constantes.MSG_ERROR
					+ " .CuentasAhoDAO.desbloqueoCuentaMas");
		} else if (mensajeBean.getNumero() != 0) {
			throw new Exception(mensajeBean.getDescripcion());
		}
	} catch (Exception e) {
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Desbloquear Masivo de Cuentas" + e);
		e.printStackTrace();
		if (mensajeBean.getNumero() == 0) {
			mensajeBean.setNumero(999);
			mensajeBean.setDescripcion(e.getMessage());
		}
	}
	return mensajeBean;
}


	// Bloqueo de Cuenta Automatico Masivo de proceso*/
	public MensajeTransaccionBean bloqueoCuentaMasivo() {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(
								Connection arg0)
								throws SQLException {
							String query = "call CUEAHOBLOQDESMASPRO(?,?,?,?,?   ,?,?,?,?,?,    ?);";
						   CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_Proceso",	BloqueoCuentaBean.bloqueo);
							sentenciaStore.setString("Par_Salida",	Constantes.salidaSI);
							// Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

							// Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;

						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(
								CallableStatement callableStatement)
								throws SQLException,
								DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR+ " .CuentasAhoDAO.bloqueoCuentaMasivo");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
			if (mensajeBean == null) {
				mensajeBean = new MensajeTransaccionBean();
				mensajeBean.setNumero(999);
				throw new Exception(Constantes.MSG_ERROR
						+ " .CuentasAhoDAO.bloqueoCuentaMasivo");
			} else if (mensajeBean.getNumero() != 0) {
				throw new Exception(mensajeBean.getDescripcion());
			}
		} catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Bloquear Cuenta Masivo" + e);
			e.printStackTrace();
			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
				mensajeBean.setDescripcion(e.getMessage());
			}
		}
		return mensajeBean;
	}

	public CuentasAhoBean consultaPrincipal(CuentasAhoBean cuentasAho, int tipoConsulta){
		CuentasAhoBean cuentas= new CuentasAhoBean();
		try{
			//Query con el Store Procedure
			String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
					+ "?,?,?,?,?,?,?);";
			Object[] parametros = {
					cuentasAho.getCuentaAhoID(),
					Constantes.ENTERO_CERO,
					Utileria.convierteEntero(cuentasAho.getMes()),
					Utileria.convierteEntero(cuentasAho.getAnio()),
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasAhoDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};//numTransaccion
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) + ")");

				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					CuentasAhoBean CuentasAho = new CuentasAhoBean();
					CuentasAho.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					CuentasAho.setSucursalID(resultSet.getString("SucursalID"));
					CuentasAho.setClienteID(resultSet.getString("ClienteID"));
					CuentasAho.setClabe(resultSet.getString("Clabe"));
					CuentasAho.setMonedaID(resultSet.getString("MonedaID"));

					CuentasAho.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
					CuentasAho.setFechaReg(resultSet.getString("FechaReg"));
					CuentasAho.setFechaApertura(resultSet.getString("FechaApertura"));
					CuentasAho.setUsuarioApeID(resultSet.getString("UsuarioApeID"));
					CuentasAho.setEtiqueta(resultSet.getString("Etiqueta"));

					CuentasAho.setUsuarioCanID(resultSet.getString("UsuarioCanID"));
					CuentasAho.setFechaCan(resultSet.getString("FechaCan"));
					CuentasAho.setMotivoCan(resultSet.getString("MotivoCan"));
					CuentasAho.setMotivoBlo(resultSet.getString("MotivoBlo"));
					CuentasAho.setUsuarioBloID(resultSet.getString("UsuarioBloID"));

					CuentasAho.setMotivoDesbloq(resultSet.getString("MotivoDesbloq"));
					CuentasAho.setFechaDesbloq(resultSet.getString("FechaDesbloq"));
					CuentasAho.setUsuarioDesbID(resultSet.getString("UsuarioDesbID"));
					CuentasAho.setSaldo(resultSet.getString("Saldo"));
					CuentasAho.setSaldoDispon(resultSet.getString("SaldoDispon"));

					CuentasAho.setSaldoBloq(resultSet.getString("SaldoBloq"));
					CuentasAho.setSaldoSBC(resultSet.getString("SaldoSBC"));
					CuentasAho.setSaldoIniMes(resultSet.getString("SaldoIniMes"));
					CuentasAho.setCargosMes(resultSet.getString("CargosMes"));
					CuentasAho.setAbonosMes(resultSet.getString("AbonosMes"));

					CuentasAho.setComisiones(resultSet.getString("Comisiones"));
					CuentasAho.setSaldoProm(resultSet.getString("SaldoProm"));
					CuentasAho.setTasaInteres(resultSet.getString("TasaInteres"));
					CuentasAho.setInteresesGen(resultSet.getString("InteresesGen"));
					CuentasAho.setISR(resultSet.getString("ISR"));

					CuentasAho.setTasaISR(resultSet.getString("TasaISR"));
					CuentasAho.setSaldoIniDia(resultSet.getString("SaldoIniDia"));
					CuentasAho.setCargosDia(resultSet.getString("CargosDia"));
					CuentasAho.setAbonosDia(resultSet.getString("AbonosDia"));
					CuentasAho.setEstatus(resultSet.getString("Estatus"));

					CuentasAho.setEstadoCta(resultSet.getString("EstadoCta"));
					CuentasAho.setInstitucionID(resultSet.getString("InstitucionID"));
					CuentasAho.setEsPrincipal(resultSet.getString("EsPrincipal"));
					CuentasAho.setTelefonoCelular(resultSet.getString("TelefonoCelular"));


					return CuentasAho;


				}// trows ecexeption
			});//lista

			cuentas= matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal de Cuentas de Ahorro", e);
		}
		return cuentas;
	}// consultaPrincipal


	// consulta para reporte en excel de Analitico Ahorro
		public List consultaRepProxAnalitico(final AnaliticoAhorroBean analiticoAhorroBean, int tipoLista){
			List ListaResultado=null;

			try{
			String query = "call ANALITICOAHORROREP(?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteEntero(analiticoAhorroBean.getClienteID()),
								Utileria.convierteEntero(analiticoAhorroBean.getCuentasAho()),
								Utileria.convierteEntero(analiticoAhorroBean.getSucursal()),
								Utileria.convierteEntero(analiticoAhorroBean.getMonedaID()),
								Utileria.convierteEntero(analiticoAhorroBean.getTipoCuentaID()),

								Utileria.convierteEntero(analiticoAhorroBean.getPromotorID()),
								analiticoAhorroBean.getSexo(),
								Utileria.convierteEntero(analiticoAhorroBean.getEstadoID()),
								Utileria.convierteEntero(analiticoAhorroBean.getMunicipioID()),


					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ANALITICOAHORROREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AnaliticoAhorroBean analiticoAhorroBean= new AnaliticoAhorroBean();
					analiticoAhorroBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					analiticoAhorroBean.setRFOficial(resultSet.getString("RFCOficial"));
					analiticoAhorroBean.setCuentasAho(resultSet.getString("CuentaAhoID"));
					analiticoAhorroBean.setEtiqueta(resultSet.getString("Etiqueta"));
					analiticoAhorroBean.setEstatus(resultSet.getString("Estatus"));

					analiticoAhorroBean.setSaldoInicioMes(resultSet.getString("Saldo_IniMes"));

					analiticoAhorroBean.setCargoEnMes(resultSet.getString("CargosMes"));
					analiticoAhorroBean.setAbonoEnMes(resultSet.getString("AbonosMes"));
					analiticoAhorroBean.setSaldoAlDia(resultSet.getString("SaldoAlDia"));
					analiticoAhorroBean.setSaldoBloqueado(resultSet.getString("SaldoBloq"));
					analiticoAhorroBean.setSaldoDisponible(resultSet.getString("Disponible"));
					analiticoAhorroBean.setHora(resultSet.getString("Hora"));
					analiticoAhorroBean.setFechaEmision(resultSet.getString("Fecha"));



					return analiticoAhorroBean;
				}
			});
			ListaResultado= matches;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de reporte de ANALÍTICO", e);
			}
			return ListaResultado;
		}

		/*consulta saldo por cuenta de ahorro*/
public CuentasAhoBean consultaSaldoCta(CuentasAhoBean cuentasAho, int tipoConsulta){
	String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
			+ "?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(cuentasAho.getCuentaAhoID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasAhoDAO.consultaSaldoDisponible",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasAhoBean cuentasAho = new CuentasAhoBean();
					cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
					cuentasAho.setSaldoDispon(resultSet.getString(2));
					cuentasAho.setDescripcionTipoCta(resultSet.getString(3));
					cuentasAho.setCodigoRespuesta(resultSet.getString(4));
					cuentasAho.setMensajeRespuesta(resultSet.getString(5));

					return cuentasAho;
				}
			});
			return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
		}
//consulta ws

public CuentasAhoBean consultaCuentaWS(CuentasAhoBean cuentasAho, int tipoConsulta){
	String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
			+ "?,?,?,?,?,?,?);";
	Object[] parametros = {
			Utileria.convierteLong(cuentasAho.getCuentaAhoID()),
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.STRING_VACIO,
			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"CuentasAhoDAO.consultaSaldoDisponible",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
			};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			CuentasAhoBean cuentasAho = new CuentasAhoBean();

			cuentasAho.setClienteID(resultSet.getString("ClienteID"));
			cuentasAho.setNombreCompleto(resultSet.getString("NombreCompleto"));
			cuentasAho.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
			cuentasAho.setDescripcionTipoCta(resultSet.getString("Descripcion"));


			return cuentasAho;
		}
	});
	return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}// fin metodo consultaCuentaWS

//consulta ws

public CuentasAhoBean consultaSaldosWS(CuentasAhoBean cuentasAho, int tipoConsulta){
	String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
			+ "?,?,?,?,?,?,?);";
	Object[] parametros = {
			Utileria.convierteLong(cuentasAho.getCuentaAhoID()),
			Utileria.convierteEntero(cuentasAho.getClienteID()),
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.STRING_VACIO,
			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"CuentasAhoDAO.consultaSaldoDisponible",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
			};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			CuentasAhoBean cuentasAho = new CuentasAhoBean();

			cuentasAho.setClienteID(resultSet.getString("ClienteID"));
			cuentasAho.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
			cuentasAho.setDescripcionTipoCta(resultSet.getString("TipoCuenta"));
			cuentasAho.setSaldo(resultSet.getString("Saldo"));
			cuentasAho.setSaldoDispon(resultSet.getString("SaldoDisp"));
			cuentasAho.setSaldoSBC(resultSet.getString("SaldoSBC"));
			cuentasAho.setSaldoBloq(resultSet.getString("SaldoBloqueado"));
			cuentasAho.setMonedaID(resultSet.getString("MonedaID"));
			cuentasAho.setDescripcionMoneda(resultSet.getString("DescriCorta"));
			cuentasAho.setEstatus(resultSet.getString("Estatus"));
			cuentasAho.setSaldoIniMes(resultSet.getString("SaldoIniMes"));
			cuentasAho.setCargosMes(resultSet.getString("CargoMes"));
			cuentasAho.setAbonosMes(resultSet.getString("AbonosMes"));
			cuentasAho.setSaldoIniDia(resultSet.getString("SaldoIniDia"));
			cuentasAho.setCargosDia(resultSet.getString("CargosDia"));
			cuentasAho.setAbonosDia(resultSet.getString("AbonosDia"));
			cuentasAho.setSumCanPenAct(resultSet.getString("Var_SumPenAct"));


			return cuentasAho;
		}
	});
	return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}// fin metodo consultaSaldosWS

	/* Consulta para pantalla de Asociacion de Tarjetas */
	public CuentasAhoBean consultaCtasAsocia(CuentasAhoBean cuentasAho, int tipoConsulta){
		CuentasAhoBean cuentasAhoBean = null;
		try{
			String query = "call CUENTASAHOCON(?,?,?,?,?,?,"
											+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getMes()),
				Utileria.convierteEntero(cuentasAho.getAnio()),
				cuentasAho.getLisTipoCuentas(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaPantallaRegistro",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1), CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setSucursalID(Utileria.completaCerosIzquierda(resultSet.getInt(2),SucursalesBean.LONGITUD_ID));
				cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getInt(3), ClienteBean.LONGITUD_ID));
				cuentasAho.setClabe(resultSet.getString(4));
				cuentasAho.setMonedaID(resultSet.getString(5));
				cuentasAho.setTipoCuentaID(resultSet.getString(6));
				cuentasAho.setFechaReg(resultSet.getString(7));
				cuentasAho.setEtiqueta(resultSet.getString(8));
				cuentasAho.setEstatus(resultSet.getString(9));
				cuentasAho.setEstadoCta(resultSet.getString(10));
				cuentasAho.setInstitucionID(resultSet.getString(11));
				cuentasAho.setEsPrincipal(resultSet.getString(12));
				return cuentasAho;
			}
		});
		cuentasAhoBean = matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;

	}catch(Exception e){
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuenta de ahorro", e);
	}
	return cuentasAhoBean;
}

public CuentasAhoBean consultaSaldosHisWS(CuentasAhoBean cuentasAho, int tipoConsulta){
	String query = "call CUENTASAHOHISCON(?,?,?,?,?, ?,?,?,?,?, ?,?);";
	Object[] parametros = {
			Utileria.convierteLong(cuentasAho.getCuentaAhoID()),
			Utileria.convierteEntero(cuentasAho.getClienteID()),
			Utileria.convierteEntero(cuentasAho.getMes()),
			Utileria.convierteEntero(cuentasAho.getAnio()),
			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"CuentasAhoDAO.consultaSaldoDisponibleHis",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
			};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOHISCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			CuentasAhoBean cuentasAho = new CuentasAhoBean();

			cuentasAho.setClienteID(resultSet.getString("ClienteID"));
			cuentasAho.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
			cuentasAho.setDescripcionTipoCta(resultSet.getString("TipoCuenta"));
			cuentasAho.setSaldo(resultSet.getString("Saldo"));
			cuentasAho.setSaldoDispon(resultSet.getString("SaldoDisp"));
			cuentasAho.setSaldoSBC(resultSet.getString("SaldoSBC"));
			cuentasAho.setSaldoBloq(resultSet.getString("SaldoBloqueado"));
			cuentasAho.setMonedaID(resultSet.getString("MonedaID"));
			cuentasAho.setDescripcionMoneda(resultSet.getString("DescriCorta"));
			cuentasAho.setEstatus(resultSet.getString("Estatus"));
			cuentasAho.setSaldoIniMes(resultSet.getString("SaldoIniMes"));
			cuentasAho.setCargosMes(resultSet.getString("CargoMes"));
			cuentasAho.setAbonosMes(resultSet.getString("AbonosMes"));
			cuentasAho.setSaldoIniDia(resultSet.getString("SaldoIniDia"));
			cuentasAho.setCargosDia(resultSet.getString("CargosDia"));
			cuentasAho.setAbonosDia(resultSet.getString("AbonosDia"));
			cuentasAho.setSumCanPenAct(resultSet.getString("Var_SumPenAct"));


			return cuentasAho;
		}
	});
	return matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
	}// fin metodo consultaSaldosWS


public MensajeTransaccionBean transferenciaBE(final CuentasAhoBean cuentasAho) {
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
							String query = "call BETRANSFERINTERPRO(?,?,?,?, ?,?,?, ?,?,?,?,?,?,? );";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_CuentaAhoOriID",Utileria.convierteEntero(cuentasAho.getCuentaOrigen()));
							sentenciaStore.setInt("Par_CuentaAhoDesID",Utileria.convierteEntero(cuentasAho.getCuentaDestino()));
							sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(cuentasAho.getMonto()));
							sentenciaStore.setString("Par_ReferenciaMov",cuentasAho.getReferencia());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la transferencia", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
	}


/* lista de cuentas y/o creditos de clientes que pertenezcan a un grupo no solidario para WS*/
public List listaCuentasWS(int tipoLista){
	List cuentasLis = null;
	try{
		String query = "call CTACREGRUPONOSOLWSLIS(?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CuentasAhoDAO.listaCuentasWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CTACREGRUPONOSOLWSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				CuentasAhoBean cuenta = new CuentasAhoBean();

				cuenta.setCuentaAhoID(resultSet.getString("Id_Cuenta"));
				cuenta.setDescripcionTipoCta(resultSet.getString("NombreCta"));
				cuenta.setTipoCuentaID(resultSet.getString("TipoCta"));
				cuenta.setSaldoMax(resultSet.getString("SaldoMax"));
				cuenta.setSaldoMin(resultSet.getString("SaldoMin"));
				cuenta.setPermiteAbo(resultSet.getString("PermiteAbo"));

				return cuenta;
			}
		});

		cuentasLis = matches;
	}catch(Exception e){
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de cuentas y/o creditos de clientes que pertenecen a un grupo no solidario para WS", e);
	}
	return cuentasLis;
}// fin de lista para WS


/* lista de Cuentas de ahorro de clientes que pertenecen a un grupo no solidario para WS*/
public List listacuentasAhoWS(SP_PDA_Ahorros_DescargaRequest bean,int tipoLista){
	List cuentasLis = null;
	try{
		String query = "call CTAGRUPOSNOSOLLIS(?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(bean.getId_Segmento()),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CuentasAhoDAO.listacuentasAhoWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CTAGRUPOSNOSOLLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				CuentasAhoBean cuenta = new CuentasAhoBean();

				cuenta.setCuentaAhoID(resultSet.getString("Num_Cta"));
				cuenta.setTipoCuentaID(resultSet.getString("Id_Cuenta"));
				cuenta.setClienteID(resultSet.getString("Num_Socio"));
				cuenta.setSaldo(resultSet.getString("SaldoTot"));
				cuenta.setSaldoDispon(resultSet.getString("SaldoDisp"));

				return cuenta;
			}
		});

		cuentasLis = matches;
	}catch(Exception e){
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de socios que pertenecen a un grupo no solidario para WS", e);
	}
	return cuentasLis;
}// fin de lista para WS


// lista para pantalla de ingresos operaciones
public List listaIngresOperaciones(CuentasAhoBean cuentasAho, int tipoLista){
	String query = "call CUENTASAHOLIS(?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?);";
	Object[] parametros = {
				cuentasAho.getNombreCompleto(),
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			CuentasAhoBean cuentasAho = new CuentasAhoBean();
			cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
			cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),10));
			cuentasAho.setNombreCompleto(resultSet.getString("NombreCompleto"));// nombre del cliente
			cuentasAho.setEtiqueta(resultSet.getString("Descripcion"));			//descripcion de la cuenta de ahorro
			cuentasAho.setNombreSucursal(resultSet.getString("NombreSucurs"));	//nombre de la sucursal
			cuentasAho.setFechaNacimiento(resultSet.getString("FechaNacimiento"));	//fecha de Nacimiento
			return cuentasAho;
		}
	});
	return matches;
} // fin de lista



public List listaTipCta(CuentasAhoBean cuentasAho, int tipoLista){
	String query = "call CUENTASAHOLIS(?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?);";
	Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Utileria.convierteEntero(cuentasAho.getInstitucionID()),
				cuentasAho.getTipoCuentaID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			CuentasAhoBean cuentasAho = new CuentasAhoBean();
			cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
			cuentasAho.setEtiqueta(resultSet.getString(2));//devuelve la descripcion de la cuenta de ahorro
			return cuentasAho;
		}
	});
	return matches;
}


public List listaCtasActivasCliente(CuentasAhoBean cuentasAho, int tipoLista){
	String query = "call CUENTASAHOLIS(?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?);";
	Object[] parametros = {
				cuentasAho.getCuentaAhoID(),
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			CuentasAhoBean cuentasAho = new CuentasAhoBean();
			cuentasAho.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
			cuentasAho.setSaldo(resultSet.getString("Saldo"));
			cuentasAho.setDescripcionTipoCta(resultSet.getString("Descripcion"));
			return cuentasAho;
		}
	});
	return matches;
}
/**
 * Validación para los depósitos referenciados.
 * @param cuentasAho clase bean {@linkplain CuentasAhoBean} con los valores de entrada a SP-CUENTASAHOVAL.
 * @return {@linkplain MensajeTransaccionBean} con el resultado de la validación.
 */
public MensajeTransaccionBean validaCuentasAho(final CuentasAhoBean cuentasAho) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
	mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CUENTASAHOVAL(?, ?,?,?, ?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CuentaAho",Utileria.convierteLong(cuentasAho.getCuentaAhoID()));
								sentenciaStore.setString("Par_Salida",salidaPantalla);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();
									ResultSetMetaData metaDatos;

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(2));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(3));
									mensajeTransaccion.setDescripcion(resultadosStore.getString(4));
									metaDatos = (ResultSetMetaData) resultadosStore.getMetaData();

									if(metaDatos.getColumnCount()== 5){
										mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));// PARA OBTENER EL PARAMETRO SI APLICA CONTABILIDAD
									}else{
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_NO);// PARA OBTENER EL PARAMETRO SI APLICA CONTABILIDAD
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
				}
			} catch (Exception e) {
				if (mensajeBean.getNumero() == 0) {
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Validación de Cuenta de ahorro", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}

//validaciones para depositos referenciados en ventanilla y tesoreria
public MensajeTransaccionBean depCuentasValDR(final DepositosRefeBean depRefe) {
	MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call DEPCUENTASVAL(?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_CuentaAhoID",depRefe.getReferenciaMov());
							sentenciaStore.setDouble("Par_MontoMov",Utileria.convierteDoble(depRefe.getMontoMov()));
							sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(depRefe.getFechaOperacion()));
							sentenciaStore.setInt("Par_TipoVal",2);


							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
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

								mensajeTransaccion.setNumero(resultadosStore.getInt(1));
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
				}
//				else if(mensajeBean.getNumero()!=0){
//					throw new Exception(mensajeBean.getDescripcion());
//				}
			} catch (Exception e) {

				if (mensajeBean.getNumero() == 0) {
					mensajeBean.setNumero(999);
				}
				mensajeBean.setDescripcion(e.getMessage());
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la ejecución de SP", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
	}
	/**
	 * Método para Validar los limites de las Cuentas
	 * @param cuentasAhoBean : Bean CuentasAhoBean con la Información de la Cuenta
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaLimExCuentas(final CuentasAhoBean cuentasAhoBean, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call LIMEXCUENTASALT(?,?,?,?,?,?,		?,?,?,?,?," + "							 ?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentasAhoBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", 0);
							sentenciaStore.setInt("Par_SucursalID", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setString("Par_Fecha", cuentasAhoBean.getFechaMovimento());
							sentenciaStore.setInt("Par_Motivo", cuentasAhoBean.getMotivoLimite());//3 o 4 segun el número de error de la validación
							sentenciaStore.setString("Par_Descripcion", cuentasAhoBean.getDescripcionLimite());//Descripción del número de error de la validación

							sentenciaStore.setString("Par_Canal", cuentasAhoBean.getCanal());//es R o E
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
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
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DepositosRefe.altaLimExCuentas");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .DepositosRefe.altaLimExCuentas");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Registro de la cuenta" + e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Registro de la cuenta" + e);
					}
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

public List reporteIDEMensual(int tipoLista,IDEMensualBean IDEMensualBean){
	String query = "call IDEMENSUALREP(?,?,?,?,?,?,?,?,?);";
	String anio=IDEMensualBean.getAnio();
	String mes=IDEMensualBean.getMes();
	Object[] parametros = {
			IDEMensualBean.getAnio(),
			IDEMensualBean.getMes(),
			//Parametros de Auditoria
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"reporteIDEMensual",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
			};
	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call IDEMENSUALREP(" + Arrays.toString(parametros) + ")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			IDEMensualBean repIDEMensBean = new IDEMensualBean();
			repIDEMensBean.setRfc(resultSet.getString("RFC"));
			repIDEMensBean.setCurp(resultSet.getString("CURP"));
			repIDEMensBean.setTipoContr(resultSet.getString("TipoContribuyente"));
			repIDEMensBean.setPrimerNombre(resultSet.getString("PrimerNombre"));
			repIDEMensBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
			repIDEMensBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
			repIDEMensBean.setFechaNac(resultSet.getString("FechaNacimiento"));
			repIDEMensBean.setRaSocial(resultSet.getString("RazonSocial"));
			repIDEMensBean.setFechaCorte(resultSet.getString("FechaCorte"));
			repIDEMensBean.setMonto(resultSet.getString("Monto"));
			repIDEMensBean.setExcedente(resultSet.getString("Excedente"));
			repIDEMensBean.setTipoDep(resultSet.getString("TipoDeposito"));
			repIDEMensBean.setNumSocio(resultSet.getString("ClienteID"));
			repIDEMensBean.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
			repIDEMensBean.setDirCompleta(resultSet.getString("DireccionCompleta"));
			repIDEMensBean.setEsMenorEdad(resultSet.getString("TipoSocio"));
			repIDEMensBean.setCorreo(resultSet.getString("Correo"));
			repIDEMensBean.setTelCelular(resultSet.getString("TelefonoCelular"));
			repIDEMensBean.setTelefono(resultSet.getString("Telefono"));
			repIDEMensBean.setCuentaAhoID(resultSet.getString("Cuentas"));
			repIDEMensBean.setNumeroSocioTut(resultSet.getString("TutorID"));
			repIDEMensBean.setNombreTut(resultSet.getString("TutNombre"));
			repIDEMensBean.setApellidoPaternoTut(resultSet.getString("TutPrimerApell"));
			repIDEMensBean.setApellidoMaternoTut(resultSet.getString("TutSegundoApell"));
			repIDEMensBean.setFechaNacTut(resultSet.getString("TutFechaNac"));
			repIDEMensBean.setRfcTut(resultSet.getString("TutRFC"));
			repIDEMensBean.setCurpTut(resultSet.getString("TutCURP"));
			repIDEMensBean.setSucursalTut(resultSet.getString("TutSucursal"));
			repIDEMensBean.setDirCompletaTut(resultSet.getString("TutDireccionCompleta"));
			repIDEMensBean.setCorreoTut(resultSet.getString("TutCorreo"));
			repIDEMensBean.setTelCelularTut(resultSet.getString("TutTelefono1"));
			repIDEMensBean.setTelefonoTut(resultSet.getString("TutTelefono2"));



			return repIDEMensBean;

		}
	});
	return matches;

}

	//consulta para reporte en excel de Analitico Ahorro
	public List<RepSaldosGlobalesBean> reporteSaldosGlobales(final RepSaldosGlobalesBean repSaldosGlobalesBean, final int tipoLista){
		List<RepSaldosGlobalesBean> reporteSaldosGlobales = null;

		try{
			String query = "CALL SALDOSGLOBALESREP(?,?,?,?,?,"
												+ "?,?,?,?,?,"
												+ "?,?,?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteEntero(repSaldosGlobalesBean.getClienteID()),
								Utileria.convierteEntero(repSaldosGlobalesBean.getTipoCuentaID()),
								Utileria.convierteEntero(repSaldosGlobalesBean.getSucursalID()),
								Utileria.convierteLong(repSaldosGlobalesBean.getCuentaAhoID()),
								Utileria.convierteEntero(repSaldosGlobalesBean.getMonedaID()),

								Utileria.convierteEntero(repSaldosGlobalesBean.getPromotorID()),
								repSaldosGlobalesBean.getGenero(),
								Utileria.convierteEntero(repSaldosGlobalesBean.getEstadoID()),
								Utileria.convierteEntero(repSaldosGlobalesBean.getMunicipioID()),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CuentasAhoDAO.reporteSaldosGlobales",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL SALDOSGLOBALESREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					RepSaldosGlobalesBean saldosGlobales = new RepSaldosGlobalesBean();

					saldosGlobales.setClienteID(resultSet.getString("ClienteID"));
					saldosGlobales.setNombreCompleto(resultSet.getString("NombreCompleto"));
					saldosGlobales.setRfcOficial(resultSet.getString("RFCOficial"));
					saldosGlobales.setSucursalID(resultSet.getString("SucursalID"));
					saldosGlobales.setCuentaAhoID(resultSet.getString("CuentaAhoID"));

					saldosGlobales.setTipoCuenta(resultSet.getString("TipoCuenta"));
					saldosGlobales.setEstatus(resultSet.getString("Estatus"));
					saldosGlobales.setSaldoInicial(resultSet.getString("SaldoInicial"));
					saldosGlobales.setCargos(resultSet.getString("Cargos"));
					saldosGlobales.setAbonos(resultSet.getString("Abonos"));

					saldosGlobales.setSaldo(resultSet.getString("Saldo"));
					saldosGlobales.setSaldoDisponible(resultSet.getString("SaldoDisponible"));
					saldosGlobales.setSaldoBloqueado(resultSet.getString("SaldoBloqueado"));
					saldosGlobales.setHora(resultSet.getString("Hora"));
					saldosGlobales.setFecha(resultSet.getString("Fecha"));

					return saldosGlobales;
				}
			});
			reporteSaldosGlobales = matches;
		}catch(Exception exception){
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de reporte de SALDOSGLOBALES", exception);
		}
		return reporteSaldosGlobales;
	}

	// Cuentas de Ahorro en Guarda Valores
	public List listaGuardaValores(CuentasAhoBean cuentasAho, int tipoLista){

		List<InversionBean> listaCuentasAhorro = null;
		try{
			String query = "CALL CUENTASAHOLIS(?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?);";
			Object[] parametros = {
						cuentasAho.getClienteID(),
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasAhoBean cuentasAho = new CuentasAhoBean();
					cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
					cuentasAho.setNombreCompleto(resultSet.getString("NombreCompleto"));
					cuentasAho.setEtiqueta(resultSet.getString("Descripcion"));
					return cuentasAho;
				}
			});

			listaCuentasAhorro = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Cuentas de Ahorro en Guarda Valores", exception);
			listaCuentasAhorro = null;
		}

		return listaCuentasAhorro;
	}

	public CuentasAhoBean banCuentasAho(CuentasAhoBean cuentasAho, int tipoConsulta){
		CuentasAhoBean cuentasAhoBean = null;

		try{
		String query = "call BANCUENTASAHOCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteLong(cuentasAho.getCuentaAhoID()),
				Utileria.convierteEntero(cuentasAho.getClienteID()),
				Constantes.STRING_VACIO,
				Constantes.STRING_CERO,
				Constantes.STRING_VACIO,
				2,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasAhoDAO.consultaCampos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BANCUENTASAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasAhoBean cuentasAho = new CuentasAhoBean();
				cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
				cuentasAho.setSucursalID(Utileria.completaCerosIzquierda(resultSet.getString("SucursalID"),SucursalesBean.LONGITUD_ID));
				cuentasAho.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
				cuentasAho.setDescripcionTipoCta(resultSet.getString("TipoCuenta"));
				cuentasAho.setFechaApertura(resultSet.getString("FechaApertura"));
				cuentasAho.setNombreSucursal(resultSet.getString("NombreSucurs"));

				return cuentasAho;
			}
		});
		cuentasAhoBean = matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuenta de ahorro", e);
		}
		return cuentasAhoBean;
	}

	// Consulta de Saldos de Cuentas de credito Fogafi
	public CuentasAhoBean saldoCreditosFogafi(CuentasAhoBean cuentasAho, int tipoConsulta){
		CuentasAhoBean cuentas = new CuentasAhoBean();
		try{
			//Query con el Store Procedure
			String query = "CALL CUENTASAHOCON(?,?,?,?,?,?,"
											+ "?,?,?,?,?,?,?);";
			Object[] parametros = {
					cuentasAho.getCuentaAhoID(),
					cuentasAho.getClienteID(),
					Utileria.convierteEntero(cuentasAho.getMes()),
					Utileria.convierteEntero(cuentasAho.getAnio()),
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasAhoDAO.saldoCreditosFogafi",
					Constantes.ENTERO_CERO,
					cuentasAho.getTransaccionID()
				};//numTransaccion
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) + ")");

				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasAhoBean cuentasAho = new CuentasAhoBean();

					cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"), ClienteBean.LONGITUD_ID));
					cuentasAho.setSaldoDispon(resultSet.getString("SaldoDispon"));
					cuentasAho.setMonedaID(resultSet.getString("MonedaID"));
					cuentasAho.setEstatus(resultSet.getString("Estatus"));

					return cuentasAho;

				}// trows ecexeption
			});//lista

			cuentas= matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
		}catch(Exception exception){
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Saldos de Créditos Fogafi de Cuentas de Ahorro", exception);
		}
		return cuentas;
	}// Consulta de Saldos de Cuentas de credito Fogafi

	// LISTA DE CUENTAS DE QUE REQUIEREN DEPOSITO PARA ACTIVACION
	public List listaCtasDepositoActiva(CuentasAhoBean cuentasAho, int tipoLista){

		List<InversionBean> listaCuentasAhorro = null;
		try{
			String query = "CALL CUENTASAHOLIS(?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?);";
			Object[] parametros = {
						cuentasAho.getNombreCompleto(),
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasAhoBean cuentasAho = new CuentasAhoBean();
					cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
					cuentasAho.setNombreCompleto(resultSet.getString("NombreCompleto"));
					cuentasAho.setEtiqueta(resultSet.getString("MontoDepositoActiva"));
					return cuentasAho;
				}
			});

			listaCuentasAhorro = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Cuentas de Ahorro que requieren deposito para activacion", exception);
			listaCuentasAhorro = null;
		}

		return listaCuentasAhorro;
	}

	// Consulta cuenta que requiere deposito para activacion
	public CuentasAhoBean ctaAhoDepositoActiva(CuentasAhoBean cuentasAho, int tipoConsulta){
		CuentasAhoBean cuentas = new CuentasAhoBean();
		try{
			//Query con el Store Procedure
			String query = "CALL CUENTASAHOCON(?,?,?,?,?,?,"
											+ "?,?,?,?,?,?,?);";
			Object[] parametros = {
					cuentasAho.getCuentaAhoID(),
					cuentasAho.getClienteID(),
					Utileria.convierteEntero(cuentasAho.getMes()),
					Utileria.convierteEntero(cuentasAho.getAnio()),
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasAhoDAO.ctaAhoDepositoActiva",
					Constantes.ENTERO_CERO,
					cuentasAho.getTransaccionID()
				};//numTransaccion
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOCON(" + Arrays.toString(parametros) + ")");

				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CuentasAhoBean cuentasAho = new CuentasAhoBean();

					cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
					cuentasAho.setClienteID(Utileria.completaCerosIzquierda(resultSet.getLong("ClienteID"), ClienteBean.LONGITUD_ID));
					cuentasAho.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
					cuentasAho.setDescripcionTipoCta(resultSet.getString("DescripcionTipoCta"));
					cuentasAho.setMonedaID(resultSet.getString("MonedaID"));

					cuentasAho.setDescripcionMoneda(resultSet.getString("DescripcionMoneda"));
					cuentasAho.setMontoDepositoActiva(resultSet.getString("MontoDepositoActiva"));
					cuentasAho.setEstatus(resultSet.getString("Estatus"));
					cuentasAho.setNombreCompleto(resultSet.getString("NombreCompleto"));

					return cuentasAho;

				}// trows ecexeption
			});//lista

			cuentas= matches.size() > 0 ? (CuentasAhoBean) matches.get(0) : null;
		}catch(Exception exception){
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Cuenta que requiere deposito para activacion", exception);
		}
		return cuentas;
	}

	// metodo para validarsi la activacion de la cuenta requiere un deposito desde ventanilla
	public MensajeTransaccionBean aperturaCtaAhoDepositoActivaCta(final CuentasAhoBean cuentasAho, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			final PolizaBean polizaBean = new PolizaBean();
			polizaBean.setConceptoID(IngresosOperacionesBean.concepContaDepActivaCta);
			polizaBean.setConcepto(IngresosOperacionesBean.desDepositoActivaCta+" CTA:"+cuentasAho.getCuentaAhoID());

			//SI EL ESTATUS DEL DEPOSITO ES 2, YA REALIZO EL DEPOSITO EN VENTANILLA Y ES NECESARIO ABONARLO A LA CUENTA Y BLOQUEARLO Y SE GENERA UNA POLIZA
			if(cuentasAho.getEstatusDepositoActiva().equals("2")){
				int contador = 0;
				while (contador <= 3) {
					contador++;
					polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
					if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
						break;
					}
				}

				if (Utileria.convierteEntero(polizaBean.getPolizaID()) <= 0) {
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza no se genero correctamente.");
					mensaje.setNombreControl("cuentaAhoID");
					throw new Exception(mensaje.getDescripcion());
				}
			}

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					MensajeTransaccionBean msjBeanAbonoBloq = new MensajeTransaccionBean();
					try {
						mensajeBean = aperturaCtaAho(cuentasAho, tipoActualizacion);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}

						//SOLO SI EL ESTATUS DEL DEPOSITO ES 2, YA REALIZO EL DEPOSITO EN VENTANILLA Y ES NECESARIO ABONARLO A LA CUENTA Y BLOQUEARLO Y CON LA POLIZA
						if(cuentasAho.getEstatusDepositoActiva().equals("2")){
							cuentasAho.setPolizaID(polizaBean.getPolizaID());
							msjBeanAbonoBloq = depositoActivaCtaAho(cuentasAho);
							if(msjBeanAbonoBloq.getNumero()!=0){
								mensajeBean = msjBeanAbonoBloq;
								throw new Exception(msjBeanAbonoBloq.getDescripcion());
							}
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Resultado Actualización del Deposito por Activación de Cuenta de Ahorro: "+mensajeBean.getNumero()+" - "+mensajeBean.getDescripcion()+". ");
						}

					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Deposito para Activacion de Cuenta. ", e);

					}
					return mensajeBean;
				}
			});
			/* Baja de Poliza en caso de que haya ocurrido un error */
			if(mensaje.getNumero() != 0 && cuentasAho.getEstatusDepositoActiva().equals("2")){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(polizaBean.getPolizaID());
				polizaDAO.bajaPoliza(bajaPolizaBean);
			}
			/* Fin Baja de la Poliza Contable*/

		} catch (Exception ex) {
			loggerSAFI.info("Error en la Actualización del Deposito para Activacion de Cuenta.", ex);
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error en la Actualización del Deposito para Activacion de Cuenta.");
			}
		}
		return mensaje;
	}

	public MensajeTransaccionBean depositoActivaCtaAho(final CuentasAhoBean cuentasAho) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL BLOQUEODEPACTCTAAHOPRO("
											+ "?,?,"
											+ "?,?,?,"
											+ "?,?,?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(cuentasAho.getCuentaAhoID()));
									sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(cuentasAho.getPolizaID()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setNombreControl("cuentaAhoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==501){ /* Error que corresponde cuando se detecta en lista de pers bloqueadas */
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Autorización de la Cuenta: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CuentasAhoDAO.depositoActivaCtaAho: Error en Autorizacion de la Cuenta y su Deposito para Activación.", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// Cuentas de Ahorro con comisiones pendientes de pago
		public List listaComisionesPendientesPag(CuentasAhoBean cuentasAho, int tipoLista){

			List<InversionBean> listaCuentasAhorro = null;
			try{
				String query = "CALL CUENTASAHOLIS(?,?,?,?,?,"
												+ "?,?,?,?,?,"
												+ "?,?);";
				Object[] parametros = {
							Constantes.ENTERO_CERO,
							Utileria.convierteEntero(cuentasAho.getClienteID()),
							Constantes.ENTERO_CERO,
							Constantes.STRING_VACIO,
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						CuentasAhoBean cuentasAho = new CuentasAhoBean();
						cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
						cuentasAho.setDescripcionTipoCta(resultSet.getString("DescripcionTipoCta"));
						cuentasAho.setSaldoDispon(resultSet.getString("SaldoDispon"));
						cuentasAho.setSaldoPendiente(resultSet.getString("SaldoPendiente"));
						return cuentasAho;
					}
				});

				listaCuentasAhorro = matches;

			}catch(Exception exception){
				exception.getMessage();
				exception.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Cuentas de Ahorro en Guarda Valores", exception);
				listaCuentasAhorro = null;
			}

			return listaCuentasAhorro;
		}

		//LISTA LAS CUENTAS ACTIVAS
		public List listaCtasActivas(CuentasAhoBean cuentasAho, int tipoLista){
			String query = "call CUENTASAHOLIS(?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?);";
			Object[] parametros = {
						cuentasAho.getNombreCompleto(),
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.STRING_VACIO,
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasAhoBean cuentasAho = new CuentasAhoBean();
					cuentasAho.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"),CuentasAhoBean.LONGITUD_ID));
					cuentasAho.setNombreCompleto(resultSet.getString("NombreCompleto"));
					return cuentasAho;
				}
			});
			return matches;
		}



	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}
}