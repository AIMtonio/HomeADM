package credito.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
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

import credito.bean.LineasCreditoBean;
import credito.servicio.LineasCreditoServicio.Enum_Lis_LineasCredito;
import credito.servicio.LineasCreditoServicio.Enum_Tra_LineasCredito;

public class LineasCreditoDAO extends BaseDAO  {
	public LineasCreditoDAO() {
		super();
	}

	// Proceso de Alta/Modificacion de Linea de Credito
	public MensajeTransaccionBean procesoLineaCredito(final LineasCreditoBean lineasCreditoBean, final int tipoTransaccion) {
		MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();

		mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {

				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();

				try {

					switch(tipoTransaccion){
						case Enum_Tra_LineasCredito.alta:
							mensajeTransaccionBean = alta(lineasCreditoBean, numeroTransaccion);
							break;
						case Enum_Tra_LineasCredito.modificacion:
							mensajeTransaccionBean = modifica(lineasCreditoBean, numeroTransaccion);
						break;
						default:
							mensajeTransaccionBean.setNumero(999);
							mensajeTransaccionBean.setDescripcion("Transacción desconocida");
							mensajeTransaccionBean.setConsecutivoString(Constantes.STRING_CERO);
							mensajeTransaccionBean.setConsecutivoInt(Constantes.STRING_CERO);
							mensajeTransaccionBean.setNombreControl("lineaCreditoID");
						break;
					}

					if( mensajeTransaccionBean.getNumero()!= Constantes.ENTERO_CERO ){
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}

				} catch (Exception exception) {

					if( mensajeTransaccionBean == null){
						mensajeTransaccionBean = new MensajeTransaccionBean();
						mensajeTransaccionBean.setNumero(999);
					}else {
						if( mensajeTransaccionBean.getNumero() == Constantes.ENTERO_CERO ){
							mensajeTransaccionBean.setNumero(999);
						}
					}

					mensajeTransaccionBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el proceso de Lineas de Crédito ", exception);
				}
				return mensajeTransaccionBean;
			}
		});
		return mensajeTransaccion;
	}

	public MensajeTransaccionBean alta(final LineasCreditoBean lineasCreditobean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "CALL LINEASCREDITOALT(?,?,?,?,?," +
																	 "?,?,?,?,?," +
																	 "?,?,?,?,?," +
																	 "?,?," +
																	 "?,?,?, " +
																	 "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(lineasCreditobean.getClienteID()));
								sentenciaStore.setLong("Par_CuentaID", Utileria.convierteLong(lineasCreditobean.getCuentaID()));
								sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(lineasCreditobean.getMonedaID()));
								sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(lineasCreditobean.getSucursalID()));
								sentenciaStore.setString("Par_FolioContrato", lineasCreditobean.getFolioContrato());

								sentenciaStore.setDate("Par_FechaInicio", OperacionesFechas.conversionStrDate(lineasCreditobean.getFechaInicio()));
								sentenciaStore.setDate("Par_FechaVencimiento", OperacionesFechas.conversionStrDate(lineasCreditobean.getFechaVencimiento()));
								sentenciaStore.setInt("Par_ProductoCreditoID", Utileria.convierteEntero(lineasCreditobean.getProductoCreditoID()));
								sentenciaStore.setDouble("Par_Solicitado", Utileria.convierteDoble(lineasCreditobean.getSolicitado()));
								sentenciaStore.setString("Par_EsAgropecuario", lineasCreditobean.getEsAgropecuario());

								sentenciaStore.setInt("Par_TipoLineaAgroID", Utileria.convierteEntero(lineasCreditobean.getTipoLineaAgroID()));
								sentenciaStore.setString("Par_ManejaComAdmon", lineasCreditobean.getManejaComAdmon());
								sentenciaStore.setString("Par_ForCobComAdmon", lineasCreditobean.getForCobComAdmon());
								sentenciaStore.setDouble("Par_PorcentajeComAdmon", Utileria.convierteDoble(lineasCreditobean.getPorcentajeComAdmon()));
								sentenciaStore.setString("Par_ManejaComGarantia", lineasCreditobean.getManejaComGarantia());

								sentenciaStore.setString("Par_ForCobComGarantia", lineasCreditobean.getForCobComGarantia());
								sentenciaStore.setDouble("Par_PorcentajeComGarantia", Utileria.convierteDoble(lineasCreditobean.getPorcentajeComGarantia()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en alta de línea de crédito ", exception);

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modifica(final LineasCreditoBean lineasCreditobean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "CALL LINEASCREDITOMOD(?,?,?,?,?," +
																	 "?,?,?,?,?," +
																	 "?,?,?,?,?," +
																	 "?,?,?," +
																	 "?,?,?, " +
																	 "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_LineaCreditoID", Utileria.convierteLong(lineasCreditobean.getLineaCreditoID()));
								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(lineasCreditobean.getClienteID()));
								sentenciaStore.setLong("Par_CuentaID", Utileria.convierteLong(lineasCreditobean.getCuentaID()));
								sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(lineasCreditobean.getMonedaID()));
								sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(lineasCreditobean.getSucursalID()));

								sentenciaStore.setString("Par_FolioContrato", lineasCreditobean.getFolioContrato());
								sentenciaStore.setDate("Par_FechaInicio", OperacionesFechas.conversionStrDate(lineasCreditobean.getFechaInicio()));
								sentenciaStore.setDate("Par_FechaVencimiento", OperacionesFechas.conversionStrDate(lineasCreditobean.getFechaVencimiento()));
								sentenciaStore.setInt("Par_ProductoCreditoID", Utileria.convierteEntero(lineasCreditobean.getProductoCreditoID()));
								sentenciaStore.setDouble("Par_Solicitado", Utileria.convierteDoble(lineasCreditobean.getSolicitado()));

								sentenciaStore.setString("Par_EsAgropecuario", lineasCreditobean.getEsAgropecuario());
								sentenciaStore.setInt("Par_TipoLineaAgroID", Utileria.convierteEntero(lineasCreditobean.getTipoLineaAgroID()));
								sentenciaStore.setString("Par_ManejaComAdmon", lineasCreditobean.getManejaComAdmon());
								sentenciaStore.setString("Par_ForCobComAdmon", lineasCreditobean.getForCobComAdmon());
								sentenciaStore.setDouble("Par_PorcentajeComAdmon", Utileria.convierteDoble(lineasCreditobean.getPorcentajeComAdmon()));

								sentenciaStore.setString("Par_ManejaComGarantia", lineasCreditobean.getManejaComGarantia());
								sentenciaStore.setString("Par_ForCobComGarantia", lineasCreditobean.getForCobComGarantia());
								sentenciaStore.setDouble("Par_PorcentajeComGarantia", Utileria.convierteDoble(lineasCreditobean.getPorcentajeComGarantia()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en modificación de línea de crédito ", exception);

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*
	 * ***********************  Autorización de la Linea ****************************************************
	 */
	public MensajeTransaccionBean autoriza(final LineasCreditoBean lineasCredito, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL LINEASCREDITOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?, ?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_LineaCreditoID",Utileria.convierteLong(lineasCredito.getLineaCreditoID()));
									sentenciaStore.setDouble("Par_Autorizado",Utileria.convierteDoble(lineasCredito.getAutorizado()));
									sentenciaStore.setString("Par_Fecha",	Utileria.convierteFecha(lineasCredito.getFechaAutoriza()));
									sentenciaStore.setInt("Par_Usuario",Utileria.convierteEntero(lineasCredito.getUsuarioAutoriza()));
									sentenciaStore.setString("Par_Motivo",Constantes.STRING_VACIO);

									sentenciaStore.setDouble("Par_Excedente",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_FolioContrato",Utileria.convierteEntero(lineasCredito.getFolioContrato()));
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
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
						mensajeBean.setNombreControl("lineaCreditoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==501){ /* Error que corresponde cuando se detecta en lista de pers bloqueadas */
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de linea de credito" + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de linea de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/*
	 * ***********************  Autorización/Rechazo de Linea de Credito Agro ****************************************************
	 */
	public MensajeTransaccionBean autorizaLineaCreAgro(final LineasCreditoBean lineasCredito, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL LINEASCREDITOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?, ?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_LineaCreditoID",Utileria.convierteLong(lineasCredito.getLineaCreditoID()));
									sentenciaStore.setDouble("Par_Autorizado",Utileria.convierteDoble(lineasCredito.getAutorizado()));
									sentenciaStore.setString("Par_Fecha",	Utileria.convierteFecha(lineasCredito.getFechaAutoriza()));
									sentenciaStore.setInt("Par_Usuario",Utileria.convierteEntero(lineasCredito.getUsuarioAutoriza()));
									sentenciaStore.setString("Par_Motivo",Constantes.STRING_VACIO);

									sentenciaStore.setDouble("Par_Excedente",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_FolioContrato",lineasCredito.getFolioContrato());
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
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
						mensajeBean.setNombreControl("lineaCreditoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==501){ /* Error que corresponde cuando se detecta en lista de pers bloqueadas */
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de linea de credito" + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de linea de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*
	 * ***********************  Bloqueo de la Linea ****************************************************
	 */
	public MensajeTransaccionBean bloqueoLinCred(final LineasCreditoBean lineasCredito, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL LINEASCREDITOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?, ?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_LineaCreditoID",Utileria.convierteLong(lineasCredito.getLineaCreditoID()));
									sentenciaStore.setDouble("Par_Autorizado",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Fecha",	Utileria.convierteFecha(lineasCredito.getFechaBloqueo()));
									sentenciaStore.setInt("Par_Usuario",Utileria.convierteEntero(lineasCredito.getUsuarioBloqueo()));
									sentenciaStore.setString("Par_Motivo",lineasCredito.getMotivoBloquea());

									sentenciaStore.setDouble("Par_Excedente",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_FolioContrato",Utileria.convierteEntero(lineasCredito.getFolioContrato()));
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
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
						mensajeBean.setNombreControl("lineaCreditoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==501){ /* Error que corresponde cuando se detecta en lista de pers bloqueadas */
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de linea de credito" + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar linea de credito", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/*
	 * ***********************  Desbloqueo de la Linea ****************************************************
	 */
	public MensajeTransaccionBean desbloqLinCred(final LineasCreditoBean lineasCredito, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL LINEASCREDITOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?, ?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_LineaCreditoID",Utileria.convierteLong(lineasCredito.getLineaCreditoID()));
									sentenciaStore.setDouble("Par_Autorizado",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Fecha",	Utileria.convierteFecha(lineasCredito.getFechaDesbloqueo()));
									sentenciaStore.setInt("Par_Usuario",Utileria.convierteEntero(lineasCredito.getUsuarioDesbloquea()));
									sentenciaStore.setString("Par_Motivo",lineasCredito.getMotivoDesbloqueo());

									sentenciaStore.setDouble("Par_Excedente",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_FolioContrato",Utileria.convierteEntero(lineasCredito.getFolioContrato()));
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
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
						mensajeBean.setNombreControl("lineaCreditoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==501){ /* Error que corresponde cuando se detecta en lista de pers bloqueadas */
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de linea de credito" + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar linea de credito", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	/*
	 * ***********************  Cambio de Condiciones de Lineas de Credito Agro ****************************************************
	 */
	public MensajeTransaccionBean condicionesLineaAgro(final LineasCreditoBean lineasCredito, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL LINEASCREDITOAGROACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?, ?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_LineaCreditoID",Utileria.convierteLong(lineasCredito.getLineaCreditoID()));
									sentenciaStore.setString("Par_ManejaComAdmon",lineasCredito.getManejaComAdmon());
									sentenciaStore.setDouble("Par_PorcentajeComAdmon",Utileria.convierteDoble(lineasCredito.getPorcentajeComAdmon()));
									sentenciaStore.setString("Par_ForCobComAdmon",lineasCredito.getForCobComAdmon());
									sentenciaStore.setString("Par_ManejaComGarantia",lineasCredito.getManejaComGarantia());

									sentenciaStore.setDouble("Par_PorcentajeComGarantia",Utileria.convierteDoble(lineasCredito.getPorcentajeComGarantia()));
									sentenciaStore.setString("Par_ForCobComGarantia",lineasCredito.getForCobComGarantia());
									sentenciaStore.setString("Par_FechaVencimiento",	Utileria.convierteFecha(lineasCredito.getFechaNuevoVenci()));
									sentenciaStore.setDouble("Par_IncrementoLinea",Utileria.convierteDoble(lineasCredito.getMontoUltimoIncremento()));
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
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
						mensajeBean.setNombreControl("lineaCreditoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==501){ /* Error que corresponde cuando se detecta en lista de pers bloqueadas */
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de linea de credito agro" + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar linea de credito agro", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*
	 * ***********************  Cancelar la Linea ****************************************************
	 */
	public MensajeTransaccionBean cancelarLinCred(final LineasCreditoBean lineasCredito, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL LINEASCREDITOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?, ?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong(		"Par_LineaCreditoID",	Utileria.convierteLong(lineasCredito.getLineaCreditoID()));
									sentenciaStore.setDouble(	"Par_Autorizado",		Constantes.ENTERO_CERO);
									sentenciaStore.setString(	"Par_Fecha",			Utileria.convierteFecha(lineasCredito.getFechaCancelacion()));
									sentenciaStore.setInt(		"Par_Usuario",			Utileria.convierteEntero(lineasCredito.getUsuarioCancela()));
									sentenciaStore.setString(	"Par_Motivo",			lineasCredito.getMotivoCancela());

									sentenciaStore.setDouble(	"Par_Excedente",		Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_FolioContrato",Utileria.convierteEntero(lineasCredito.getFolioContrato()));
									sentenciaStore.setInt(		"Par_NumAct",			tipoActualizacion);
									sentenciaStore.setString(	"Par_Salida", 			Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", 	Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", 	Types.VARCHAR);

									sentenciaStore.setInt(		"Aud_EmpresaID", 		parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt(		"Aud_Usuario", 			parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate(		"Aud_FechaActual", 		parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString(	"Aud_DireccionIP", 		parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString(	"Aud_ProgramaID", 		parametrosAuditoriaBean.getNombrePrograma());

									sentenciaStore.setInt(		"Aud_Sucursal", 		parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong(		"Aud_NumTransaccion", 	parametrosAuditoriaBean.getNumeroTransaccion());

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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
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
						mensajeBean.setNombreControl("lineaCreditoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==501){ /* Error que corresponde cuando se detecta en lista de pers bloqueadas */
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de linea de credito" + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar linea de credito", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean baja(final LineasCreditoBean lineasCredito) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "CALL LINEASCREDITOBAJ(? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							lineasCredito.getLineaCreditoID(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"LineasCreditoDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEASCREDITOBAJ(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de linea de credito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Consulta principal linea de credito
	public LineasCreditoBean consultaPrincipal(LineasCreditoBean lineasCredito, int tipoConsulta) {

		LineasCreditoBean linea = null;
		//Query con el Store Procedure
		try{
			String query = "CALL LINEASCREDITOCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
				lineasCredito.getLineaCreditoID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"LineasCreditoDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEASCREDITOCON(" +Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					LineasCreditoBean lineasCredito = new LineasCreditoBean();
					lineasCredito.setLineaCreditoID(resultSet.getString(1));
					lineasCredito.setClienteID(resultSet.getString(2));
					lineasCredito.setCuentaID(resultSet.getString(3));
					lineasCredito.setMonedaID(resultSet.getString(4));
					lineasCredito.setSucursalID(resultSet.getString(5));
					lineasCredito.setFolioContrato(resultSet.getString(6));
					lineasCredito.setFechaInicio(resultSet.getString(7));
					lineasCredito.setFechaVencimiento(resultSet.getString(8));
					lineasCredito.setProductoCreditoID(resultSet.getString(9));
					lineasCredito.setSolicitado(resultSet.getString(10));
					lineasCredito.setAutorizado(resultSet.getString(11));
					lineasCredito.setDispuesto(resultSet.getString(12));
					lineasCredito.setPagado(resultSet.getString(13));
					lineasCredito.setSaldoDisponible(resultSet.getString(14));
					lineasCredito.setSaldoDeudor(resultSet.getString(15));
					lineasCredito.setEstatus(resultSet.getString(16));
					lineasCredito.setNumeroCreditos(resultSet.getString(17));
					lineasCredito.setIdenCreditoCNBV(resultSet.getString(18));
					lineasCredito.setComisionAnual(resultSet.getString(19));

					lineasCredito.setCobraComAnual(resultSet.getString("CobraComAnual"));
					lineasCredito.setComisionCobrada(resultSet.getString("ComisionCobrada"));

					return lineasCredito;
				}
			});

			linea = matches.size() > 0 ? (LineasCreditoBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta Principal de Lineas Credito ", exception);
			linea = null;
		}

		return linea;
	}

	//Consulta Foranea linea de credito
	public LineasCreditoBean consultaForanea(LineasCreditoBean lineasCredito, int tipoConsulta) {

		LineasCreditoBean linea = null;
		//Query con el Store Procedure
		try{
			String query = "CALL LINEASCREDITOCON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
				lineasCredito.getLineaCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"LineasCreditoDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEASCREDITOCON(" +Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					LineasCreditoBean lineasCredito = new LineasCreditoBean();
					lineasCredito.setLineaCreditoID(resultSet.getString(1));
					lineasCredito.setClienteID(resultSet.getString(2));
					lineasCredito.setCuentaID(resultSet.getString(3));
					return lineasCredito;

				}
			});

			linea = matches.size() > 0 ? (LineasCreditoBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta foranea de Lineas Credito ", exception);
			linea = null;
		}

		return linea;
	}

	//consulta linea de credito por actualizacion, autorizacion, bloqueo o cancelacion
	public LineasCreditoBean consultaActualizacion(LineasCreditoBean lineasCredito, int tipoConsulta) {

		LineasCreditoBean linea = null;
		//Query con el Store Procedure
		try{
			String query = "CALL LINEASCREDITOCON(?,? ,?,?,?,?,?,?,?);";

			Object[] parametros = {
				lineasCredito.getLineaCreditoID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"LineasCreditoDAO.consultaActualizacion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEASCREDITOCON(" +Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					LineasCreditoBean lineasCredito = new LineasCreditoBean();
					lineasCredito.setLineaCreditoID(resultSet.getString(1));
					lineasCredito.setClienteID(resultSet.getString(2));
					lineasCredito.setCuentaID(resultSet.getString(3));////
					lineasCredito.setSolicitado(resultSet.getString(4));
					lineasCredito.setAutorizado(resultSet.getString(5));
					lineasCredito.setEstatus(resultSet.getString(6));
					lineasCredito.setFechaAutoriza(resultSet.getString(7));
					lineasCredito.setUsuarioAutoriza(resultSet.getString(8));
					lineasCredito.setFechaBloqueo(resultSet.getString(9));
					lineasCredito.setUsuarioBloqueo(resultSet.getString(10));
					lineasCredito.setMotivoBloquea(resultSet.getString(11));
					lineasCredito.setFechaDesbloqueo(resultSet.getString(12));
					lineasCredito.setUsuarioDesbloquea(resultSet.getString(13));
					lineasCredito.setMotivoDesbloqueo(resultSet.getString(14));
					lineasCredito.setFechaCancelacion(resultSet.getString(15));
					lineasCredito.setUsuarioCancela(resultSet.getString(16));
					lineasCredito.setMotivoCancela(resultSet.getString(17));
					lineasCredito.setFechaInicio(resultSet.getString("FechaInicio"));
					lineasCredito.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));


					return lineasCredito;
				}
			});

			linea = matches.size() > 0 ? (LineasCreditoBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Actualizacion de Lineas Credito ", exception);
			linea = null;
		}

		return linea;
	}

	public List<LineasCreditoBean> listaLineaCredito(LineasCreditoBean lineasCredito, int tipoLista){

		List<LineasCreditoBean> listaLineasCreditoBean = null;
		//Query con el Store Procedure
		try{

			String query = "CALL LINEASCREDITOLIS(?,?,? ,?,?,?,?,?,?,?);";

			Object[] parametros = {
				lineasCredito.getClienteID(),
				Constantes.STRING_VACIO, // es la descripcion del producto, en esta lista no se usa
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"LineasCreditoDAO.listaLineaCredito",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEASCREDITOLIS(" +Arrays.toString(parametros) + ")");
			List<LineasCreditoBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					LineasCreditoBean lineasCredito = new LineasCreditoBean();
					lineasCredito.setLineaCreditoID(resultSet.getString(1));
					lineasCredito.setClienteID(resultSet.getString(2));
					return lineasCredito;
				}
			});

			listaLineasCreditoBean = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Lineas de Crédito ", exception);
			listaLineasCreditoBean = null;
		}

		return listaLineasCreditoBean;
	}

	// Lista de lineas de credito para pantalla de alta de credito
	public List<LineasCreditoBean> listaLineaAltaCred(LineasCreditoBean lineasCredito, int tipoLista){

		List<LineasCreditoBean> listaLineasCreditoBean = null;
		//Query con el Store Procedure
		try{
			String query = "CALL LINEASCREDITOLIS(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				lineasCredito.getClienteID(),
				lineasCredito.getProductoCreditoID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"LineasCreditoDAO.listaLineaAltaCred",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call LINEASCREDITOLIS(" +Arrays.toString(parametros) + ")");
			List<LineasCreditoBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					LineasCreditoBean lineasCredito = new LineasCreditoBean();
					lineasCredito.setLineaCreditoID(resultSet.getString(1));
					lineasCredito.setProductoCreditoID(resultSet.getString(2));
					lineasCredito.setFechaInicio(resultSet.getString(3));
					lineasCredito.setFechaVencimiento(resultSet.getString(4));

					return lineasCredito;
				}
			});

			listaLineasCreditoBean = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Alta de Lineas de Crédito ", exception);
			listaLineasCreditoBean = null;
		}

		return listaLineasCreditoBean;
	}

	/*Actualización de monto autorizado Y fecha de vencimiento*/
	public MensajeTransaccionBean actMontAutorizado(final LineasCreditoBean lineasCredito, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "CALL LINEASCREDITOACT("
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?,     "
											+ "?,?,?,?,?, ?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_LineaCreditoID",Utileria.convierteLong(lineasCredito.getLineaCreditoID()));
									sentenciaStore.setDouble("Par_Autorizado",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Fecha",	Utileria.convierteFecha(lineasCredito.getFechaVencimiento()));
									sentenciaStore.setInt("Par_Usuario",Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_Motivo",Constantes.STRING_VACIO);

									sentenciaStore.setDouble("Par_Excedente",Utileria.convierteDoble(lineasCredito.getExcedente()));
									sentenciaStore.setInt("Par_FolioContrato",Utileria.convierteEntero(lineasCredito.getFolioContrato()));
									sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
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
						mensajeBean.setNombreControl("lineaCreditoID");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						if(mensajeBean.getNumero()==501){
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en actualizacion de linea de credito" + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizar linea de credito", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean actualizaLineaCreditoAgro(final LineasCreditoBean lineasCreditobean, final int tipoActualizacion, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "CALL LINEASCREDITOAGROACT(?,?,?,?,?," +
																	 	 "?,?,?,?, " +
																	 	 "?,?,?, " +
																	 	 "?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_LineaCreditoID", Utileria.convierteLong(lineasCreditobean.getLineaCreditoID()));
								sentenciaStore.setInt("Par_TipoLineaAgroID", Utileria.convierteEntero(lineasCreditobean.getTipoLineaAgroID()));
								sentenciaStore.setString("Par_ManejaComAdmon", lineasCreditobean.getManejaComAdmon());
								sentenciaStore.setString("Par_ForCobComAdmon", lineasCreditobean.getForCobComAdmon());
								sentenciaStore.setDouble("Par_PorcentajeComAdmon", Utileria.convierteDoble(lineasCreditobean.getPorcentajeComAdmon()));

								sentenciaStore.setString("Par_ManejaComGarantia", lineasCreditobean.getManejaComGarantia());
								sentenciaStore.setString("Par_ForCobComGarantia", lineasCreditobean.getForCobComGarantia());
								sentenciaStore.setDouble("Par_PorcentajeComGarantia", Utileria.convierteDoble(lineasCreditobean.getPorcentajeComGarantia()));
								sentenciaStore.setInt("Par_NumeroActualizacion", tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual",  parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en Actualizacion de linea de crédito Agro", exception);

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Consulta Principal Agro
	public LineasCreditoBean consultaPrincipalAgro(final LineasCreditoBean lineasCreditoBean, final int tipoConsulta) {

		LineasCreditoBean lineasCredito = null;
		//Query con el Store Procedure
		try{
			String query = "CALL LINEASCREDITOCON(?,?,"
										    	+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(lineasCreditoBean.getLineaCreditoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"LineasCreditoDAO.consultaPrincipalAgro",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL LINEASCREDITOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					LineasCreditoBean linea = new LineasCreditoBean();

					linea.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
					linea.setClienteID(resultSet.getString("ClienteID"));
					linea.setCuentaID(resultSet.getString("CuentaID"));
					linea.setMonedaID(resultSet.getString("MonedaID"));
					linea.setSucursalID(resultSet.getString("SucursalID"));

					linea.setFolioContrato(resultSet.getString("FolioContrato"));
					linea.setFechaInicio(resultSet.getString("FechaInicio"));
					linea.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					linea.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
					linea.setSolicitado(resultSet.getString("Solicitado"));

					linea.setAutorizado(resultSet.getString("Autorizado"));
					linea.setDispuesto(resultSet.getString("Dispuesto"));
					linea.setPagado(resultSet.getString("Pagado"));
					linea.setSaldoDisponible(resultSet.getString("SaldoDisponible"));
					linea.setSaldoDeudor(resultSet.getString("SaldoDeudor"));

					linea.setSaldoComAnual(resultSet.getString("SaldoComAnual"));
					linea.setEstatus(resultSet.getString("Estatus"));
					linea.setNumeroCreditos(resultSet.getString("NumeroCreditos"));
					linea.setFechaCancelacion(resultSet.getString("FechaCancelacion"));
					linea.setFechaBloqueo(resultSet.getString("FechaBloqueo"));

					linea.setFechaDesbloqueo(resultSet.getString("FechaDesbloqueo"));
					linea.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
					linea.setUsuarioAutoriza(resultSet.getString("UsuarioAutoriza"));
					linea.setUsuarioBloqueo(resultSet.getString("UsuarioBloqueo"));
					linea.setUsuarioDesbloquea(resultSet.getString("UsuarioDesbloq"));

					linea.setUsuarioCancela(resultSet.getString("UsuarioCancela"));
					linea.setMotivoBloquea(resultSet.getString("MotivoBloqueo"));
					linea.setMotivoDesbloqueo(resultSet.getString("MotivoDesbloqueo"));
					linea.setMotivoCancela(resultSet.getString("MotivoCancela"));
					linea.setIdenCreditoCNBV(resultSet.getString("IdenCreditoCNBV"));

					linea.setCobraComAnual(resultSet.getString("CobraComAnual"));
					linea.setTipoComAnual(resultSet.getString("TipoComAnual"));
					linea.setValorComAnual(resultSet.getString("ValorComAnual"));
					linea.setComisionCobrada(resultSet.getString("ComisionCobrada"));
					linea.setEsAgropecuario(resultSet.getString("EsAgropecuario"));

					linea.setTipoLineaAgroID(resultSet.getString("TipoLineaAgroID"));
					linea.setEsRevolvente(resultSet.getString("EsRevolvente"));
					linea.setManejaComAdmon(resultSet.getString("ManejaComAdmon"));
					linea.setForCobComAdmon(resultSet.getString("ForCobComAdmon"));
					linea.setPorcentajeComAdmon(resultSet.getString("PorcentajeComAdmon"));

					linea.setManejaComGarantia(resultSet.getString("ManejaComGarantia"));
					linea.setForCobComGarantia(resultSet.getString("ForCobComGarantia"));
					linea.setPorcentajeComGarantia(resultSet.getString("PorcentajeComGarantia"));
					linea.setUltFechaDisposicion(resultSet.getString("UltFechaDisposicion"));
					linea.setUltMontoDisposicion(resultSet.getString("UltMontoDisposicion"));

					linea.setCobraTolPriDisposicion(resultSet.getString("CobraTolPriDisposicion"));
					linea.setFechaCobroComision(resultSet.getString("FechaCobroComision"));
					linea.setFechaProximoCobro(resultSet.getString("FechaProximoCobro"));

					return linea;
				}
			});

			lineasCredito = matches.size() > 0 ? (LineasCreditoBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta de Principal de Lineas Credito Agro ", exception);
			lineasCredito = null;
		}

		return lineasCredito;
	}

	// Lista de lineas de credito para pantalla de alta de credito
	public List<LineasCreditoBean> listaLineaCreaditoAgro(final LineasCreditoBean lineasCreditoBean, final int tipoLista){

		List<LineasCreditoBean> listaLineasCreditoBean = null;
		//Query con el Store Procedure
		try{
			String query = "CALL LINEASCREDITOLIS(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
				lineasCreditoBean.getClienteID(),
				lineasCreditoBean.getProductoCreditoID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"LineasCreditoDAO.listaLineaCreaditoAgro",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL LINEASCREDITOLIS(" +Arrays.toString(parametros) + ")");
			List<LineasCreditoBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					LineasCreditoBean lineasCredito = new LineasCreditoBean();
					lineasCredito.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
					switch (tipoLista) {
						case Enum_Lis_LineasCredito.linCredAgropecuaria:
							lineasCredito.setCuentaID(resultSet.getString("CuentaID"));
							lineasCredito.setClienteID(resultSet.getString("ClienteID"));
						break;
						case Enum_Lis_LineasCredito.lisLineaActivaAgro:
							lineasCredito.setDescripcion(resultSet.getString("Descripcion"));
							lineasCredito.setSaldoDisponible(resultSet.getString("SaldoDisponible"));
							lineasCredito.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
						break;
						case Enum_Lis_LineasCredito.lisLineaInactiAgro:
							lineasCredito.setCuentaID(resultSet.getString("CuentaID"));
							lineasCredito.setClienteID(resultSet.getString("ClienteID"));
						break;
					}
					return lineasCredito;
				}
			});

			listaLineasCreditoBean = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Lineas de Crédito Agro ", exception);
			listaLineasCreditoBean = null;
		}

		return listaLineasCreditoBean;
	}


	// Reporte de lineas de credito agro
	public List<LineasCreditoBean> reporteLineasCreditoAgro(int tipoReporte, final LineasCreditoBean lineasCreditoBean){
		List<LineasCreditoBean> ListaResultado = null;
		try{
			transaccionDAO.generaNumeroTransaccion();
			String nombrePrograma = Constantes.STRING_VACIO;
			String query = "CALL LINEASCREDITOAGROREP(?,?,?,?,?, " +
													  "?,?,?," +
													  "?,?,?,?,?,?,?)";

			Object[] parametros ={
				Utileria.convierteFecha(lineasCreditoBean.getFechaInicio()),
				Utileria.convierteFecha(lineasCreditoBean.getFechaVencimiento()),
				Utileria.convierteEntero(lineasCreditoBean.getLineaCreditoID()),
				Utileria.convierteEntero(lineasCreditoBean.getClienteID()),
				Utileria.convierteEntero(lineasCreditoBean.getProductoCreditoID()),
				Utileria.convierteEntero(lineasCreditoBean.getSucursalID()),
				lineasCreditoBean.getEstatus(),
				tipoReporte,

	    		parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				nombrePrograma,
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL LINEASCREDITOAGROREP(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					LineasCreditoBean lineasCreditoBean= new LineasCreditoBean();

					lineasCreditoBean.setLineaCreditoID(resultSet.getString("LineaCreditoID"));
					lineasCreditoBean.setCuentaID(resultSet.getString("CuentaID"));
					lineasCreditoBean.setFolioContrato(resultSet.getString("FolioContrato"));
					lineasCreditoBean.setFechaInicio(resultSet.getString("FechaInicio"));
					lineasCreditoBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));

					lineasCreditoBean.setSolicitado(resultSet.getString("Solicitado"));
					lineasCreditoBean.setAutorizado(resultSet.getString("Autorizado"));
					lineasCreditoBean.setDispuesto(resultSet.getString("Dispuesto"));
					lineasCreditoBean.setPagado(resultSet.getString("Pagado"));
					lineasCreditoBean.setSaldoDisponible(resultSet.getString("SaldoDisponible"));

					lineasCreditoBean.setSaldoDeudor(resultSet.getString("SaldoDeudor"));
					lineasCreditoBean.setNumeroCreditos(resultSet.getString("NumeroCreditos"));
					lineasCreditoBean.setClienteID(resultSet.getString("ClienteID"));
					lineasCreditoBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					lineasCreditoBean.setSucursalID(resultSet.getString("SucursalID"));

					lineasCreditoBean.setSucursal(resultSet.getString("NombreSucurs"));
					lineasCreditoBean.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
					lineasCreditoBean.setDescripcion(resultSet.getString("Descripcion"));
					lineasCreditoBean.setEstatus(resultSet.getString("Estatus"));

					return lineasCreditoBean ;
				}
			});
			ListaResultado= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el reporte de lineas de credito agro", e);
		}
		return ListaResultado;
	}

}