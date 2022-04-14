package cliente.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

//import seguimiento.bean.RegistroGestorBean;


import ventanilla.bean.IngresosOperacionesBean;

import java.sql.ResultSetMetaData;

import cuentas.bean.CuentasAhoBean;
import cliente.bean.ClienteBean;
import cliente.bean.ClientesCancelaBean;
import cliente.bean.ProtecionAhorroCreditoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;

public class ClientesCancelaDAO extends BaseDAO {
	ParametrosSesionBean parametrosSesionBean;

	public ClientesCancelaDAO() {
		super();
	}

	private final static String salidaPantalla = "S";

	// ------------------ Transacciones ------------------------------------------
	/* Alta de la solicitud de cancelacion de socio */
	public MensajeTransaccionBean procesoCancelAlta(final ClientesCancelaBean clientesCancela) {
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
									String query = "call CLIENTESCANCELAPRO(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(clientesCancela.getClienteID()));
										sentenciaStore.setString("Par_AreaCancela",clientesCancela.getAreaCancela());
										sentenciaStore.setInt("Par_UsuarioRegistra",Utileria.convierteEntero(clientesCancela.getUsuarioRegistra()));
										sentenciaStore.setInt("Par_MotivoActivaID",Utileria.convierteEntero(clientesCancela.getMotivoActivaID()));
										sentenciaStore.setString("Par_Comentarios",clientesCancela.getComentarios());
										sentenciaStore.setString("Par_AplicaSeguro",clientesCancela.getAplicaSeguro());
										sentenciaStore.setString("Par_ActaDefuncion",clientesCancela.getActaDefuncion());
										sentenciaStore.setDate("Par_FechaDefuncion",OperacionesFechas.conversionStrDate(clientesCancela.getFechaDefuncion()));

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
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																													DataAccessException {
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if(callableStatement.execute()){
											ResultSet resultadosStore = callableStatement.getResultSet();

											resultadosStore.next();
											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
											mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
											mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
											mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesCancelaDAO.altaClientesCancela");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ClientesCancelaDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Cliente Cancela" + e);
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
	}// fin de alta de clientes cancela


	/**
	 * Alta de la solicitud de cancelacion de socio, método invocado desde la ventanilla
	 * @param clientesCancela : {@link ClientesCancelaBean} con la información del Cliente que va cancelarse
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean pagoCancelacionSocio(final ClientesCancelaBean clientesCancela, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CLIENTESCANCELPAGPRO(" + "?,?,?,?,?, ?,?,?,?,?," + "?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_CliCancelaEntregaID", Utileria.convierteEntero(clientesCancela.getCliCancelaEntregaID()));
							sentenciaStore.setInt("Par_ClienteCancelaID", Utileria.convierteEntero(clientesCancela.getClienteCancelaID()));
							sentenciaStore.setString("Par_AltaEncPoliza", clientesCancela.getAltaEncPoliza());
							sentenciaStore.setString("Par_NombreRecibePago", clientesCancela.getNombreRecibePago());
							sentenciaStore.setString("Par_Salida", salidaPantalla);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(clientesCancela.getPolizaID()));
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);

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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesCancelaDAO.altaClientesCancela");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ClientesCancelaDAO.alta");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Registro de Cliente Cancela" + e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Registro de Cliente Cancela" + e);
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


	/* Alta de la solicitud de cancelacion de socio */
	public MensajeTransaccionBean actualizacion(final ClientesCancelaBean clientesCancela, final int tipoActualizacion) {
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
									String query = "call CLIENTESCANCELAACT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_ClienteCancelaID", Utileria.convierteEntero(clientesCancela.getClienteCancelaID()));
										sentenciaStore.setInt("Par_UsuarioAutoriza",Utileria.convierteEntero(clientesCancela.getUsuarioAutoriza()));
										sentenciaStore.setInt("Par_NumAct",tipoActualizacion);
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
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																													DataAccessException {
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										if(callableStatement.execute()){
											ResultSet resultadosStore = callableStatement.getResultSet();
											ResultSetMetaData metaDatos;

											resultadosStore.next();
											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
											mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString(2), parametrosSesionBean.getNomCortoInstitucion()));
											mensajeTransaccion.setNombreControl(resultadosStore.getString(3));

											metaDatos = (ResultSetMetaData) resultadosStore.getMetaData();
											if(metaDatos.getColumnCount()== 4){
												mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
											}else{
												mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
											}

										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ClientesCancelaDAO.actualizaClientesCancela");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}
										return mensajeTransaccion;
									}
								});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ClientesCancelaDAO.actualiza");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error la actualizacion de Cliente Cancela" + e);
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
	}// fin de alta de clientes profun



	//Consulta de Clientes PROFUN
	public ClientesCancelaBean consultaPrincipal(ClientesCancelaBean clientesCancela, int tipoConsulta){
		ClientesCancelaBean clientesCancelaBean = null;
		try{
			String query = "call CLIENTESCANCELACON(" +
					"?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(clientesCancela.getClienteCancelaID()),
					Utileria.convierteEntero(clientesCancela.getClienteID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,

					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ClientesCancelaDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCANCELACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClientesCancelaBean clientesCancela = new ClientesCancelaBean();
					clientesCancela.setClienteCancelaID(resultSet.getString("ClienteCancelaID"));
					clientesCancela.setClienteID(resultSet.getString("ClienteID"));
					clientesCancela.setAreaCancela(resultSet.getString("AreaCancela"));
					clientesCancela.setUsuarioRegistra(resultSet.getString("UsuarioRegistra"));
					clientesCancela.setFechaRegistro(resultSet.getString("FechaRegistro"));

					clientesCancela.setSucursalRegistro(resultSet.getString("SucursalRegistro"));
					clientesCancela.setEstatus(resultSet.getString("Estatus"));
					clientesCancela.setMotivoActivaID(resultSet.getString("MotivoActivaID"));
					clientesCancela.setComentarios(resultSet.getString("Comentarios"));
					clientesCancela.setUsuarioAutoriza(resultSet.getString("UsuarioAutoriza"));

					clientesCancela.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
					clientesCancela.setSucursalAutoriza(resultSet.getString("SucursalAutoriza"));
					clientesCancela.setAplicaSeguro(resultSet.getString("AplicaSeguro"));
					clientesCancela.setActaDefuncion(resultSet.getString("ActaDefuncion"));
					clientesCancela.setFechaDefuncion(resultSet.getString("FechaDefuncion"));

					clientesCancela.setSaldoFavorCliente(resultSet.getString("SaldoFavorCliente"));

					return clientesCancela;
				}
			});
			clientesCancelaBean  = matches.size() > 0 ? (ClientesCancelaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de solicitud de cancelacion", e);
		}
		return clientesCancelaBean;
	}

	public ClientesCancelaBean consultaCliente(ClientesCancelaBean clientesCancela, int tipoConsulta){
		ClientesCancelaBean clientesCancelaBean = null;
		try{
			String query = "call CLIENTESCANCELACON(" +
					"?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(clientesCancela.getClienteCancelaID()),
					Utileria.convierteEntero(clientesCancela.getClienteID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,

					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ClientesCancelaDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCANCELACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClientesCancelaBean clientesCancela = new ClientesCancelaBean();
					clientesCancela.setClienteCancelaID(resultSet.getString("ClienteCancelaID"));
					clientesCancela.setClienteID(resultSet.getString("ClienteID"));
					clientesCancela.setAreaCancela(resultSet.getString("AreaCancela"));
					clientesCancela.setUsuarioRegistra(resultSet.getString("UsuarioRegistra"));
					clientesCancela.setFechaRegistro(resultSet.getString("FechaRegistro"));

					clientesCancela.setSucursalRegistro(resultSet.getString("SucursalRegistro"));
					clientesCancela.setEstatus(resultSet.getString("Estatus"));
					clientesCancela.setMotivoActivaID(resultSet.getString("MotivoActivaID"));
					clientesCancela.setComentarios(resultSet.getString("Comentarios"));
					clientesCancela.setUsuarioAutoriza(resultSet.getString("UsuarioAutoriza"));

					clientesCancela.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
					clientesCancela.setSucursalAutoriza(resultSet.getString("SucursalAutoriza"));
					clientesCancela.setAplicaSeguro(resultSet.getString("AplicaSeguro"));
					clientesCancela.setActaDefuncion(resultSet.getString("ActaDefuncion"));
					clientesCancela.setFechaDefuncion(resultSet.getString("FechaDefuncion"));
					clientesCancela.setPermiteReactivacion(resultSet.getString("PermiteReactivacion"));

					return clientesCancela;
				}
			});
			clientesCancelaBean  = matches.size() > 0 ? (ClientesCancelaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de solicitud de cancelacion", e);
		}
		return clientesCancelaBean;
	}

	//Consulta de Clientes PROFUN
	public ClientesCancelaBean consultaProtecciones(ClientesCancelaBean clientesCancela, int tipoConsulta){
		ClientesCancelaBean clientesCancelaBean = null;
		try{
			String query = "call CLIENTESCANCELACON(" +
					"?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(clientesCancela.getClienteCancelaID()),
					Utileria.convierteEntero(clientesCancela.getClienteID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,

					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ClientesCancelaDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCANCELACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ClientesCancelaBean clientesCancela = new ClientesCancelaBean();
					clientesCancela.setClienteCancelaID(resultSet.getString("ClienteCancelaID"));
					clientesCancela.setClienteID(resultSet.getString("ClienteID"));
					clientesCancela.setEstatus(resultSet.getString("Estatus"));
					clientesCancela.setAplicaSeguro(resultSet.getString("AplicaSeguro"));
					clientesCancela.setActaDefuncion(resultSet.getString("ActaDefuncion"));

					clientesCancela.setFechaDefuncion(resultSet.getString("FechaDefuncion"));
					return clientesCancela;
				}
			});
			clientesCancelaBean  = matches.size() > 0 ? (ClientesCancelaBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de solicitud de cancelacion", e);
		}
		return clientesCancelaBean;
	}

	//Consulta de Clientes autorizadas por proteccion
		public ClientesCancelaBean consultaProteccionesAutorizadas(ClientesCancelaBean clientesCancela, int tipoConsulta){
			ClientesCancelaBean clientesCancelaBean = null;
			try{
				String query = "call CLIENTESCANCELACON(" +
						"?,?,?,?,?, ?,?,?,?,?);";
				Object[] parametros = {
						Utileria.convierteEntero(clientesCancela.getClienteCancelaID()),
						Utileria.convierteEntero(clientesCancela.getClienteID()),
						tipoConsulta,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,

						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ClientesCancelaDAO.consultaProtecciones",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO

				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCANCELACON(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ClientesCancelaBean clientesCancela = new ClientesCancelaBean();
						clientesCancela.setClienteCancelaID(resultSet.getString("ClienteCancelaID"));
						clientesCancela.setClienteID(resultSet.getString("ClienteID"));
						clientesCancela.setUsuarioRegistra(resultSet.getString("UsuarioRegistra"));
						clientesCancela.setFechaRegistro(resultSet.getString("FechaRegistro"));
						clientesCancela.setEstatus(resultSet.getString("Estatus"));

//						clientesCancela.setMontoRecibir(resultSet.getString("SaldoFavorCliente"));




						return clientesCancela;
					}
				});
				clientesCancelaBean  = matches.size() > 0 ? (ClientesCancelaBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de solicitud de cancelacion", e);
			}
			return clientesCancelaBean;
		}

		// se usa para validación en ventanilla
		public ClientesCancelaBean consultaDatosCancelacionSocio(ClientesCancelaBean clientesCancelaBean, int tipoConsulta) {
			ClientesCancelaBean ingresos  = null;
				loggerSAFI.debug("ClienteEntrega: " +clientesCancelaBean.getCliCancelaEntregaID());
			try{
				String query = "call CLIENTESCANCELACON(?,?,?,  ?,?,?,?,?,?,?);";
				Object[] parametros = {	Utileria.convierteEntero(clientesCancelaBean.getClienteCancelaID()),
										Utileria.convierteEntero(clientesCancelaBean.getCliCancelaEntregaID()),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"ClientesCancelaDAO.ConsultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCANCELACON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						ClientesCancelaBean clientesCancelaBean = new ClientesCancelaBean();

						clientesCancelaBean.setCantidadRecibir(resultSet.getString("CantidadRecibir"));
						clientesCancelaBean.setEstatus(resultSet.getString("Estatus"));
						clientesCancelaBean.setAreaCancela(resultSet.getString("AreaCancela"));
							return clientesCancelaBean;
					}
				});
			ingresos  = matches.size() > 0 ? (ClientesCancelaBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Datos de pago cancelación cliente", e);
			}
			return ingresos;
		}


		public ClientesCancelaBean consultaFolioCancela(ClientesCancelaBean clientesCancela, int tipoConsulta){
			ClientesCancelaBean clientesCancelaBean = null;
			try{
				String query = "call CLIENTESCANCELACON(" +
						"?,?,?,?,?, ?,?,?,?,?);";
				Object[] parametros = {
						Utileria.convierteEntero(clientesCancela.getClienteCancelaID()),
						Utileria.convierteEntero(clientesCancela.getClienteID()),
						tipoConsulta,
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,

						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ClientesCancelaDAO.consultaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO

				};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCANCELACON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ClientesCancelaBean clientesCancela = new ClientesCancelaBean();
						clientesCancela.setClienteCancelaID(resultSet.getString("ClienteCancelaID"));
						return clientesCancela;
					}
				});
				clientesCancelaBean  = matches.size() > 0 ? (ClientesCancelaBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de solicitud de cancelacion", e);
			}
			return clientesCancelaBean;
		}


	public List listaPrincipal(ClientesCancelaBean clientesCancelaBean, int tipoLista){
		String query = "call CLIENTESCANCELALIS(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
					clientesCancelaBean.getNombreCompleto(),
					clientesCancelaBean.getAreaCancela(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),

					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCANCELALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClientesCancelaBean clientesCancelaBean = new ClientesCancelaBean();
				clientesCancelaBean.setClienteCancelaID(resultSet.getString("ClienteCancelaID"));
				clientesCancelaBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),ClienteBean.LONGITUD_ID));
				clientesCancelaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				clientesCancelaBean.setEstatus(resultSet.getString("Estatus"));
				clientesCancelaBean.setEstatusDes(resultSet.getString("EstatusDes"));
				return clientesCancelaBean;
			}
		});
		return matches;
	}

	public List listaAutorizadas(ClientesCancelaBean clientesCancelaBean, int tipoLista){
		String query = "call CLIENTESCANCELALIS(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
					clientesCancelaBean.getNombreCompleto(),
					clientesCancelaBean.getAreaCancela(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),

					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCANCELALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClientesCancelaBean clientesCancelaBean = new ClientesCancelaBean();
				clientesCancelaBean.setClienteCancelaID(resultSet.getString("ClienteCancelaID"));
				clientesCancelaBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),ClienteBean.LONGITUD_ID));
				clientesCancelaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				clientesCancelaBean.setEstatus(resultSet.getString("Estatus"));
				clientesCancelaBean.setEstatusDes(resultSet.getString("EstatusDes"));
				return clientesCancelaBean;
			}
		});
		return matches;
	}

	/* Listas autorizadas por proteccion */
	public List listaAutorizadasProteccion(ClientesCancelaBean clientesCancelaBean, int tipoLista){
		String query = "call CLIENTESCANCELALIS(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
					clientesCancelaBean.getNombreCompleto(),
					clientesCancelaBean.getAreaCancela(),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),

					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESCANCELALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClientesCancelaBean clientesCancelaBean = new ClientesCancelaBean();
				clientesCancelaBean.setClienteCancelaID(resultSet.getString("ClienteCancelaID"));
				clientesCancelaBean.setClienteID(Utileria.completaCerosIzquierda(resultSet.getString("ClienteID"),ClienteBean.LONGITUD_ID));
				clientesCancelaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				clientesCancelaBean.setEstatus(resultSet.getString("Estatus"));
				clientesCancelaBean.setEstatusDes(resultSet.getString("EstatusDes"));
				return clientesCancelaBean;
			}
		});
		return matches;
	}

	/* Lista de Beneficiarios de Cuentas por proteccion */
	public List listaGridBeneficiariosCta(ClientesCancelaBean clientesCancelaBean, int tipoLista){
		String query = "call PROTECCIONESCTALIS(" +
				"?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
					Utileria.convierteEntero(clientesCancelaBean.getClienteID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),

					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROTECCIONESCTALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClientesCancelaBean clientesCancelaBean = new ClientesCancelaBean();

				clientesCancelaBean.setTipoCuentaID(resultSet.getString("TipoCuentaID"));
				clientesCancelaBean.setDescripcionTipoCta(resultSet.getString("Descripcion"));
				clientesCancelaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				clientesCancelaBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
				clientesCancelaBean.setPersonaID(resultSet.getString("PersonaID"));
				clientesCancelaBean.setClienteBenID(resultSet.getString("ClienteID"));
				clientesCancelaBean.setParentescoID(resultSet.getString("ParentescoID"));
				return clientesCancelaBean;
			}
		});
		return matches;
	}

	/* Lista de Beneficiarios de Inversion por proteccion */
	public List listaGridBeneficiariosInv(ClientesCancelaBean clientesCancelaBean, int tipoLista){
		String query = "call PROTECCIONESINVLIS(" +
				"?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
					Utileria.convierteEntero(clientesCancelaBean.getClienteID()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),

					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROTECCIONESINVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ClientesCancelaBean clientesCancelaBean = new ClientesCancelaBean();

				clientesCancelaBean.setTipoInversionID(resultSet.getString("TipoInversionID"));
				clientesCancelaBean.setDescripcionTipoInv(resultSet.getString("Descripcion"));
				clientesCancelaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
				clientesCancelaBean.setInversionID(resultSet.getString("InversionID"));
				clientesCancelaBean.setBeneInverID(resultSet.getString("BenefInverID"));
				clientesCancelaBean.setClienteBenID(resultSet.getString("ClienteID"));
				clientesCancelaBean.setParentescoID(resultSet.getString("TipoRelacionID"));
				return clientesCancelaBean;
			}
		});
		return matches;
	}

	// Aplicacion de distribucion de beneficios
	public MensajeTransaccionBean aplicaDistribucionBeneficios(final ClientesCancelaBean clientesCancelaBean,
			final List distribucionLista) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					ClientesCancelaBean clientesCancela = new ClientesCancelaBean();
					mensajeBean = bajaDistribucionBeneficios(clientesCancelaBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					for(int i=0; i<distribucionLista.size(); i++){

						clientesCancela = (ClientesCancelaBean)distribucionLista.get(i);

						//mensajeBean = altaDistribucionBeneficios(clientesCancelaBean,clientesCancela);

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Distribucion de Beneficios Agregado Exitosamente: "+clientesCancelaBean.getClienteCancelaID());
					mensajeBean.setNombreControl("clienteCancelaID");
					mensajeBean.setConsecutivoString(clientesCancelaBean.getClienteCancelaID());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al realizar la operacion", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	 	// Alta de distribución de Beneficios
//		public MensajeTransaccionBean altaDistribucionBeneficios(final ClientesCancelaBean clientesCancelaBean,
//				final ClientesCancelaBean clientesCancela) {
//			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
//mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
//					new TransactionCallback<Object>() {
//				public Object doInTransaction(TransactionStatus transaction) {
//					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
//					try {
//
//						// Query con el Store Procedure
//						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
//							new CallableStatementCreator() {
//								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
//									String query = "call CLICANCELAENTREGAALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
//									CallableStatement sentenciaStore = arg0.prepareCall(query);
//
//									sentenciaStore.setInt("Par_ClienteCancelaID",Utileria.convierteEntero(clientesCancelaBean.getClienteCancelaID()));
//									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(clientesCancelaBean.getClienteID()));
//									sentenciaStore.setInt("Par_CuentaAhoID",Utileria.convierteEntero(clientesCancela.getCuentaAhoID()));
//									sentenciaStore.setInt("Par_PersonaID",Utileria.convierteEntero(clientesCancela.getPersonaID()));
//
//									sentenciaStore.setInt("Par_ClienteBenID",Utileria.convierteEntero(clientesCancela.getClienteBenID()));
//									sentenciaStore.setInt("Par_Parentesco",Utileria.convierteEntero(clientesCancela.getParentescoID()));
//									sentenciaStore.setString("Par_NombreBeneficiario",clientesCancela.getNombreBeneficiario());
//									sentenciaStore.setDouble("Par_Porcentaje",Utileria.convierteDoble(clientesCancela.getPorcentaje()));

//									sentenciaStore.setDouble("Par_CantidadRecibir",Utileria.convierteDoble(clientesCancela.getCantidadRecibir()));
//									sentenciaStore.setString("Par_NombreRecibePago",clientesCancela.getNombreRecibePago());
//									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
//									sentenciaStore.registerOutParameter("Par_NumErr", Types.CHAR);
//									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
//
//									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
//									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
//									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
//									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
//									sentenciaStore.setString("Aud_ProgramaID","ClientesCancelaDAO.altaDistribucionBeneficios");
//									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
//									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
//									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
//									return sentenciaStore;
//								}
//							},new CallableStatementCallback() {
//								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
//																												DataAccessException {
//									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
//									if(callableStatement.execute()){
//										ResultSet resultadosStore = callableStatement.getResultSet();
//
//										resultadosStore.next();
//										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
//										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
//										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
//										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
//
//									}else{
//										mensajeTransaccion.setNumero(999);
//										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
//									}
//
//									return mensajeTransaccion;
//								}
//							}
//							);
//
//						if(mensajeBean ==  null){
//							mensajeBean = new MensajeTransaccionBean();
//							mensajeBean.setNumero(999);
//							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
//						}else if(mensajeBean.getNumero()!=0){
//							throw new Exception(mensajeBean.getDescripcion());
//						}
//					} catch (Exception e) {
//
//						if (mensajeBean.getNumero() == 0) {
//							mensajeBean.setNumero(999);
//						}
//						mensajeBean.setDescripcion(e.getMessage());
//						transaction.setRollbackOnly();
//						e.printStackTrace();
//						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de distribucion de beneficios", e);
//					}
//					return mensajeBean;
//				}
//			});
//			return mensaje;
//		}


		/* Baja de Distribucion de Beneficios  */
		public MensajeTransaccionBean bajaDistribucionBeneficios(final ClientesCancelaBean clientesCancelaBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						String query = "call CLICANCELAENTREGABAJ(?, ?,?,?,?,?,?,?);";
						Object[] parametros = {
								Utileria.convierteEntero(clientesCancelaBean.getClienteCancelaID()),

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ClientesCancelaDAO.bajaDistribucionBeneficios",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
						loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLICANCELAENTREGABAJ(" +Arrays.toString(parametros) + ")");
						List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
							public Object mapRow(ResultSet resultSet, int rowNum)
									throws SQLException {
								MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
								mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
								mensaje.setDescripcion(resultSet.getString(2));
								mensaje.setNombreControl(resultSet.getString(3));
								mensaje.setConsecutivoString(resultSet.getString(4));
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Gestores", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}


	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}

