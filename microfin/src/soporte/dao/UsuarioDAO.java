package soporte.dao;
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


import soporte.bean.UsuarioBean;

public class UsuarioDAO extends BaseDAO {

	public UsuarioDAO() {
		super();
	}

	/* Alta Usuario */
	public MensajeTransaccionBean altaUsuario(final UsuarioBean usuario) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call USUARIOSALT("
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,?,?,"
									+ "?,"
									+ "?,?,?,?,"
									+ "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_ClavepuestoID", usuario.getClavePuestoID());
							sentenciaStore.setString("Par_Nombre", usuario.getNombre());
							sentenciaStore.setString("Par_ApPaterno", usuario.getApPaterno());
							sentenciaStore.setString("Par_ApMaterno", usuario.getApMaterno());
							sentenciaStore.setString("Par_Clave", usuario.getClave());

							sentenciaStore.setString("Par_Contrasenia", usuario.getContrasenia());
							sentenciaStore.setString("Par_Correo", usuario.getCorreo());
							sentenciaStore.setInt("Par_SucurUsu", Utileria.convierteEntero(usuario.getSucursalUsuario()));
							sentenciaStore.setInt("Par_RolID", Utileria.convierteEntero(usuario.getRolID()));
							sentenciaStore.setString("Par_IPSesion", usuario.getIpSesion());

							sentenciaStore.setString("Par_ConsultaCC", usuario.getRealizaConsultasCC());
							sentenciaStore.setString("Par_UsuarioCirculo", usuario.getUsuarioCirculo());
							sentenciaStore.setString("Par_ContraCirculo", usuario.getContrasenaCirculo());
							sentenciaStore.setString("Par_ConsultaBC", usuario.getRealizaConsultasBC());
							sentenciaStore.setString("Par_UsuarioBuroCredito", usuario.getUsuarioBuroCredito());

							sentenciaStore.setString("Par_ContrasenaBuroCredito", usuario.getContrasenaBuroCredito());
							sentenciaStore.setString("Par_AccesoMonitor", usuario.getAccesoMonitor());
							sentenciaStore.setString("Par_Notificacion", usuario.getNotificacion());
							sentenciaStore.setString("Par_AccederAutorizar", usuario.getAccederAutorizar());
							sentenciaStore.setString("Par_RFC", usuario.getRfc());

							sentenciaStore.setString("Par_CURP", usuario.getCurp());
							sentenciaStore.setString("Par_DireccionCompleta", usuario.getDireccionCompleta().trim());
							sentenciaStore.setString("Par_FolioIdentificacion", usuario.getFolioIdentificacion());
							sentenciaStore.setString("Par_FechaExpedicion", Utileria.convierteFecha(usuario.getFechaExpedicion()));
							sentenciaStore.setString("Par_FechaVencimiento", Utileria.convierteFecha(usuario.getFechaVencimiento()));
							sentenciaStore.setString("Par_UsaAplicacion", usuario.getUsaAplicacion());
							sentenciaStore.setString("Par_IMEI", usuario.getImei());

							sentenciaStore.setLong("Par_EmpleadoID", Utileria.convierteLong(usuario.getEmpleadoID()));
							sentenciaStore.setString("Par_NotificaCierre", usuario.getNotificaCierre());

							//Parametros de OutPut
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

							loggerSAFI.info(sentenciaStore.toString());
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
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .UsuariosDAO.altaUsuario");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .UsuariosDAO.altaUsuario");
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
					loggerSAFI.error("error en alta de usuarios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}



	public MensajeTransaccionBean altaUsuarioBDPrincipal(final UsuarioBean usuario) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					String query = "call USUARIOSALT(?,?,?,?,?,?  ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							usuario.getClave(),
							Utileria.convierteEntero(usuario.getRolID()),
							parametrosAuditoriaBean.getOrigenDatos(),
							parametrosAuditoriaBean.getRutaReportes(),
							parametrosAuditoriaBean.getRutaImgReportes(),
							parametrosAuditoriaBean.getLogoCtePantalla(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"UsuarioDAO.altaUsuarioBDPrincipal",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call principal.USUARIOSALT(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoInt(resultSet.getString(4));
							mensaje.setConsecutivoString(resultSet.getString(4));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de usuario, BD Principal", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modifica Usuario */
	public MensajeTransaccionBean modificaUsuario(final UsuarioBean usuario) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call USUARIOSMOD("
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,?,?,"
									+ "?,"
									+ "?,?,?,?,"
									+ "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_UsuarioID", usuario.getUsuarioID());
							sentenciaStore.setString("Par_ClavePuestoID", usuario.getClavePuestoID());
							sentenciaStore.setString("Par_Nombre", usuario.getNombre());
							sentenciaStore.setString("Par_ApPaterno", usuario.getApPaterno());
							sentenciaStore.setString("Par_ApMaterno", usuario.getApMaterno());

							sentenciaStore.setString("Par_Clave", usuario.getClave());
							sentenciaStore.setString("Par_Correo", usuario.getCorreo());
							sentenciaStore.setInt("Par_SucurUsu", Utileria.convierteEntero(usuario.getSucursalUsuario()));
							sentenciaStore.setInt("Par_RolID", Utileria.convierteEntero(usuario.getRolID()));
							sentenciaStore.setString("Par_IPSesion", usuario.getIpSesion());

							sentenciaStore.setString("Par_ConsultaCC", usuario.getRealizaConsultasCC());
							sentenciaStore.setString("Par_UsuarioCirculo", usuario.getUsuarioCirculo());
							sentenciaStore.setString("Par_ContraCirculo", usuario.getContrasenaCirculo());
							sentenciaStore.setString("Par_ConsultaBC", usuario.getRealizaConsultasBC());
							sentenciaStore.setString("Par_UsuarioBuroCredito", usuario.getUsuarioBuroCredito());

							sentenciaStore.setString("Par_ContrasenaBuroCredito", usuario.getContrasenaBuroCredito());
							sentenciaStore.setString("Par_AccesoMonitor", usuario.getAccesoMonitor());
							sentenciaStore.setString("Par_Notificacion", usuario.getNotificacion());
							sentenciaStore.setString("Par_AccederAutorizar", usuario.getAccederAutorizar());
							sentenciaStore.setString("Par_RFC", usuario.getRfc());

							sentenciaStore.setString("Par_CURP", usuario.getCurp());
							sentenciaStore.setString("Par_DireccionCompleta", usuario.getDireccionCompleta().trim());
							sentenciaStore.setString("Par_FolioIdentificacion", usuario.getFolioIdentificacion());
							sentenciaStore.setString("Par_FechaExpedicion", Utileria.convierteFecha(usuario.getFechaExpedicion()));
							sentenciaStore.setString("Par_FechaVencimiento", Utileria.convierteFecha(usuario.getFechaVencimiento()));
							sentenciaStore.setString("Par_UsaAplicacion", usuario.getUsaAplicacion());
							sentenciaStore.setString("Par_IMEI", usuario.getImei());

							sentenciaStore.setLong("Par_EmpleadoID", Utileria.convierteLong(usuario.getEmpleadoID()));
							sentenciaStore.setString("Par_NotificaCierre", usuario.getNotificaCierre());
							//Parametros de OutPut
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

							loggerSAFI.info(sentenciaStore.toString());
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
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .UsuariosDAO.modificacionUsuario");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .UsuariosDAO.modificacionUsuario");
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
					loggerSAFI.error("error en la modificación de usuarios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaUsuarioBDPrincipal(final UsuarioBean usuario)  {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("principal")).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					String query = "call USUARIOSMOD(?,?,?,?,? ,?,?,?,?);";
					Object[] parametros = {
							usuario.getClave(),
							Utileria.convierteEntero(usuario.getRolID()),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"UsuarioDAO.modificaUsuario",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSMOD(" + Arrays.toString(parametros) +")");
					List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							mensaje.setConsecutivoInt(resultSet.getString(4));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de usuario", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*Metodo Actualizado*/
	/* Actualiza el Numero de Intentos Fallidos de Login */
	public MensajeTransaccionBean actualizaIntentosFallidos(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_Clave",usuario.getClave());
								sentenciaStore.setString("Par_Estatus",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_MotivBloq",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechBloq",Constantes.FECHA_VACIA);

								sentenciaStore.setString("Par_MotivCancel",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechCancel",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Contrasenia",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioIDRespon",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_MotivoReactiva",Constantes.STRING_VACIO);

							    sentenciaStore.setString("Par_FechaReactiva",Constantes.FECHA_VACIA);
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Actualiza Numero de Intentos Fallidos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}


	/*Metodo Actualizado*/
	/* Actualiza el estatus del usuario a bloqueado o desbloqueado*/
	public MensajeTransaccionBean actBloqDesbloqueoUsuario(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Utileria.convierteEntero(usuario.getUsuarioID()));
								sentenciaStore.setString("Par_Clave",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Estatus",usuario.getEstatus());
								sentenciaStore.setString("Par_MotivBloq",usuario.getMotivoBloqueo());
								sentenciaStore.setString("Par_FechBloq",Utileria.convierteFecha(usuario.getFechaBloqueo()));
								sentenciaStore.setString("Par_MotivCancel",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechCancel",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Contrasenia",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioIDRespon",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_MotivoReactiva",Constantes.STRING_VACIO);

							    sentenciaStore.setString("Par_FechaReactiva",Constantes.FECHA_VACIA);
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Actualiza Estatus de Usuario Bloqueado", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}




	/*Metodo Actualizado*/
	/* Actualiza el estatus del usuario a Cancelado*/
	public MensajeTransaccionBean actCancelaUsuario(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Utileria.convierteEntero(usuario.getUsuarioID()));
								sentenciaStore.setString("Par_Clave",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Estatus",usuario.getEstatus());
								sentenciaStore.setString("Par_MotivBloq",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechBloq",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_MotivCancel",usuario.getMotivoCancel());
								sentenciaStore.setString("Par_FechCancel",usuario.getFechaCancel());
								sentenciaStore.setString("Par_Contrasenia",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioIDRespon",Utileria.convierteEntero(usuario.getUsuarioIDRespon()));
								sentenciaStore.setString("Par_MotivoReactiva",Constantes.STRING_VACIO);

							    sentenciaStore.setString("Par_FechaReactiva",Constantes.FECHA_VACIA);
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso deActualiza Estatus de Usuario Cancelado", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	public MensajeTransaccionBean actLimpiaSesion(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Utileria.convierteEntero(usuario.getUsuarioID()));
								sentenciaStore.setString("Par_Clave",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Estatus",usuario.getEstatus());
								sentenciaStore.setString("Par_MotivBloq",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechBloq",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_MotivCancel",usuario.getMotivoCancel());
								sentenciaStore.setString("Par_FechCancel",usuario.getFechaCancel());
								sentenciaStore.setString("Par_Contrasenia",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioIDRespon",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_MotivoReactiva",Constantes.STRING_VACIO);

							    sentenciaStore.setString("Par_FechaReactiva",Constantes.FECHA_VACIA);
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}


    public MensajeTransaccionBean grabaActualizaEstAnalisis(final UsuarioBean usuario,final int tipoActualizacion) {

			MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try{

						mensajeBean=actEstatusAnalista(usuario,tipoActualizacion);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						mensajeBean=altaBitacoraEstAnalista(usuario);

						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

					}catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						mensajeBean.setNombreControl("actualizar");
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en grabar y actualiza estatus analsis ", e);
						return mensajeBean;
					}
					return mensajeBean;
				}
			});
			return mensajeTransaccion;
		}


	/*Metodo actualizado*/
	/*Actualiza el estatus de Analisis Credito*/
	public MensajeTransaccionBean actEstatusAnalista(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Utileria.convierteEntero(usuario.getUsuarioID()));
								sentenciaStore.setString("Par_Clave",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Estatus",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_MotivBloq",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechBloq",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_MotivCancel",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechCancel",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Contrasenia",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioIDRespon",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_MotivoReactiva",Constantes.STRING_VACIO);

							    sentenciaStore.setString("Par_FechaReactiva",Constantes.FECHA_VACIA);
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	/* Alta Bitacora Analista*/
	public MensajeTransaccionBean altaBitacoraEstAnalista(final UsuarioBean usuario) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call BITACORAESTANALISTASALT("
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(usuario.getUsuarioID()));
							sentenciaStore.setString("Par_Estatus", usuario.getEstatusAnalisis());


							//Parametros de OutPut
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "UsuarioDAO.altaBitacoraEstAnalista");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(sentenciaStore.toString());
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
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .UsuariosDAO.altaBitacoraEstAnalista");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .UsuariosDAO.altaBitacoraEstAnalista");
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
					loggerSAFI.error("error en alta de Alta Bitacora Estatus Analista", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/*Metodo Actualizado*/
	/* Actualizacion: resetea password de usuario*/
	public MensajeTransaccionBean resetPasswordUsuario(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Utileria.convierteEntero(usuario.getUsuarioID()));
								sentenciaStore.setString("Par_Clave",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Estatus",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_MotivBloq",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechBloq",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_MotivCancel",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechCancel",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Contrasenia",usuario.getContrasenia());
								sentenciaStore.setInt("Par_UsuarioIDRespon",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_MotivoReactiva",Constantes.STRING_VACIO);

							    sentenciaStore.setString("Par_FechaReactiva",Constantes.FECHA_VACIA);
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Reseteo Password de Usuario", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}



	/*Metodo Confirmacion password*/
	/* Confirmacion: confirma password de usuario*/
	public MensajeTransaccionBean validaUsuario(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSVAL(?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Utileria.convierteEntero(usuario.getUsuarioID()));
								sentenciaStore.setString("Par_Contrasenia",usuario.getContrasenia());
								sentenciaStore.setString("Par_ConfirmarContra",usuario.getConfirmarContra());

							    sentenciaStore.setInt("Par_NumVal",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Reseteo Password de Usuario", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}







	/*Metodo Actualizado*/
	/* Actualiza el estatus del la sesion del usuario a Activo*/
	public MensajeTransaccionBean actStatusSesionActivoUsuario(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_Clave",usuario.getClave());
								sentenciaStore.setString("Par_Estatus",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_MotivBloq",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechBloq",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_MotivCancel",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechCancel",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Contrasenia",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioIDRespon",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_MotivoReactiva",Constantes.STRING_VACIO);

							    sentenciaStore.setString("Par_FechaReactiva",Constantes.FECHA_VACIA);
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Actualiza Estatus de la Sesion Activa", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	/*Metodo Actualizado*/
	/* Actualiza el estatus del la sesion del usuario a Inactivo (cerra sesion)*/
	public MensajeTransaccionBean actStatusSesionInactivoUsuario(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_Clave",usuario.getClave());
								sentenciaStore.setString("Par_Estatus",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_MotivBloq",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechBloq",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_MotivCancel",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechCancel",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Contrasenia",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioIDRespon",Constantes.ENTERO_CERO);
								sentenciaStore.setString("Par_MotivoReactiva",Constantes.STRING_VACIO);

							    sentenciaStore.setString("Par_FechaReactiva",Constantes.FECHA_VACIA);
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Actualización de Sesion Usuario Inactivo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	/* Consuta Usuario por Llave Principal*/
	public UsuarioBean consultaPrincipal(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getUsuarioID(),
								Constantes.STRING_VACIO,//clave
								Constantes.STRING_VACIO,// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();

							usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
							usuario.setClavePuestoID(resultSet.getString("ClavePuestoID"));
							usuario.setNombre(resultSet.getString("Nombre"));
							usuario.setApPaterno(resultSet.getString("ApPaterno"));
							usuario.setApMaterno(resultSet.getString("ApMaterno"));
							usuario.setClave(resultSet.getString("Clave"));
							usuario.setContrasenia("");
							usuario.setCorreo(resultSet.getString("Correo"));
							usuario.setSucursalUsuario(String.valueOf(resultSet.getInt("SucursalUsuario")));
							usuario.setRolID(String.valueOf(resultSet.getInt("RolID")));
							usuario.setIpSesion(resultSet.getString("IPsesion"));
							usuario.setFechUltAcces(resultSet.getString("FechUltimAcces"));
							usuario.setFechUltPass(resultSet.getString("FechUltPass"));
							usuario.setEstatus(resultSet.getString("Estatus"));
							usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
							usuario.setRealizaConsultasCC(resultSet.getString("RealizaConsultasCC"));
							usuario.setUsuarioCirculo(resultSet.getString("UsuarioCirculo"));
							usuario.setContrasenaCirculo(resultSet.getString("ContrasenaCirculo"));
							usuario.setRealizaConsultasBC(resultSet.getString("RealizaConsultasBC"));
							usuario.setUsuarioBuroCredito(resultSet.getString("UsuarioBuroCredito"));
							usuario.setContrasenaBuroCredito(resultSet.getString("ContrasenaBuroCredito"));
							usuario.setAccesoMonitor(resultSet.getString("AccesoMonitor"));
							usuario.setNotificacion(resultSet.getString("Notificacion"));
							usuario.setFechaAlta(resultSet.getString("fechaAlta"));
							usuario.setAccederAutorizar(resultSet.getString("AccederAutorizar"));
							usuario.setRfc(resultSet.getString("RFC"));
							usuario.setCurp(resultSet.getString("CURP"));
							usuario.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
							usuario.setFolioIdentificacion(resultSet.getString("FolioIdentificacion"));
							usuario.setFechaExpedicion(resultSet.getString("FechaExpedicion"));
							usuario.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
							usuario.setEmpleadoID(resultSet.getString("EmpleadoID"));
							usuario.setUsaAplicacion(resultSet.getString("UsaAplicacion"));
							usuario.setImei(resultSet.getString("IMEI"));
							usuario.setNotificaCierre(resultSet.getString("NotificaCierre"));
							return usuario;
			}
		});

		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;
	}

	public UsuarioBean consultaForanea(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getUsuarioID(),
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();

				usuario.setUsuarioID(String.valueOf(resultSet.getInt(1)));
				usuario.setNombreCompleto(resultSet.getString(2));

				return usuario;

			}
		});
		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

	}

	/* Consulta de Usuario: Para Pantalla de Login */
	public UsuarioBean consultaPorClave(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		UsuarioBean usuario = null;
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
				usuarioBean.getClave(),
				Constantes.STRING_VACIO,// contrasenia
				Constantes.STRING_VACIO,// nombre completo
				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"UsuarioDAO.consultaPorClave",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(usuarioBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");


		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(usuarioBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();
					usuario.setUsuarioID(herramientas.Utileria.completaCerosIzquierda(
							resultSet.getInt(1), UsuarioBean.LONGITUD_ID));
					usuario.setNombreCompleto(resultSet.getString(2));
					usuario.setClave(resultSet.getString(3));
					usuario.setContrasenia(resultSet.getString(4));
					usuario.setNombreRol(resultSet.getString(5));
					usuario.setEstatus(resultSet.getString(6));
					usuario.setLoginsFallidos(resultSet.getInt(7));
					usuario.setEstatusSesion(resultSet.getString(8));
					usuario.setIpSesion(resultSet.getString(9));
					usuario.setSalt(resultSet.getString(10));
					usuario.setAccedeHuella(resultSet.getString(11));
					usuario.setAccederAutorizar(resultSet.getString(12));
					return usuario;
				}
			});

			usuario = matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;
			usuario.setOrigenDatos(usuarioBean.getOrigenDatos());
			usuario.setRazonSocial(usuarioBean.getRazonSocial());

		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta por clave", e);
		}


		return usuario;

	}
	/**
	 * Consulta los datos de un usuario por clave. A diferencia delmétodo consultaPorClave()
	 * no se necesita el origen de datos del usuario, lo trae desde los parámetros de auditoría.
	 * @param usuarioBean : Clase bean con la clave del usuario a consultar.
	 * @param tipoConsulta : Número de consulta 3.
	 * @return UsuarioBean con el resultado de la consulta.
	 * @author avelasco
	 */
	public UsuarioBean consultaXClave(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		UsuarioBean usuario = null;
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
				usuarioBean.getClave(),
				Constantes.STRING_VACIO,// contrasenia
				Constantes.STRING_VACIO,// nombre completo
				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"UsuarioDAO.consultaXClave",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +");");

		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();
					usuario.setUsuarioID(herramientas.Utileria.completaCerosIzquierda(resultSet.getInt("UsuarioID"), UsuarioBean.LONGITUD_ID));
					usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
					usuario.setClave(resultSet.getString("Clave"));
					usuario.setContrasenia(resultSet.getString("Contrasenia"));
					usuario.setNombreRol(resultSet.getString("Descripcion"));
					usuario.setEstatus(resultSet.getString("Estatus"));
					usuario.setLoginsFallidos(resultSet.getInt("LoginsFallidos"));
					usuario.setEstatusSesion(resultSet.getString("EstatusSesion"));
					usuario.setIpSesion(resultSet.getString("IPsesion"));
					usuario.setSalt(resultSet.getString("Semilla"));
					return usuario;
				}
			});
			usuario = matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;
		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta por clave", e);
		}
		return usuario;
	}

	/* Consulta de Usuario: Para Pantalla de Login */
	public UsuarioBean consultaPorClaveBDPrincipal(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		UsuarioBean usuario = null;
		String query = "call USUARIOSCON(	?,?,?,?,?	,?,?,?,?,?,	"
			+ "								?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								usuarioBean.getClave(),
								Constantes.STRING_VACIO,// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaPorClave",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info("Principal - "+"call USUARIOSCONBDPrin(" + Arrays.toString(parametros) +")");


		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("principal")).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();
					usuario.setClave(resultSet.getString("Clave"));
					usuario.setNombreRol(resultSet.getString("Descripcion"));
					usuario.setEstatus(resultSet.getString("Estatus"));
					usuario.setLoginsFallidos(resultSet.getInt("LoginsFallidos"));
					usuario.setEstatusSesion(resultSet.getString("EstatusSesion"));
					usuario.setSalt(resultSet.getString("Semilla"));
					usuario.setOrigenDatos(resultSet.getString("OrigenDatos"));
					usuario.setRutaReportes(resultSet.getString("RutaReportes"));
					usuario.setRutaImgReportes(resultSet.getString("RutaImgReportes"));
					usuario.setLogoCtePantalla(resultSet.getString("LogoCtePantalla"));
					usuario.setRazonSocial(resultSet.getString("RazonSocial"));
					usuario.setSubdominio(resultSet.getString("Subdominio"));

					return usuario;
				}
			});

			usuario = matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta por clave", e);
		}


		return usuario;

	}

	/* Consulta de Usuario: Para la pantalla de Bloqueo y Desbloqueo de usuarios */
	public UsuarioBean consultaBloDesbloqueo(UsuarioBean usuarioBean, int tipoConsulta) {
		UsuarioBean usuarioBeanCon = new UsuarioBean();
		try{
			//Query con el Store Procedure
			String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	usuarioBean.getUsuarioID(),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,// contrasenia
									Constantes.STRING_VACIO,// nombre completo
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioDAO.consultaBloDesbloqueo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();
					usuario.setUsuarioID(herramientas.Utileria.completaCerosIzquierda(
											resultSet.getInt(1), UsuarioBean.LONGITUD_ID));
					usuario.setNombreCompleto(resultSet.getString(2));
					usuario.setClave(resultSet.getString(3));
					usuario.setContrasenia("");
					usuario.setFechUltAcces(resultSet.getString(4));
					usuario.setFechUltPass(resultSet.getString(5));
					usuario.setEstatus(resultSet.getString(6));
					usuario.setMotivoBloqueo(resultSet.getString(7));
					usuario.setFechaBloqueo(resultSet.getString(8));
					return usuario;
				}
			});
			usuarioBeanCon =  matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de desbloqueo", e);
		}
		return usuarioBeanCon;
	}

	/* Consulta de Usuario: Para la pantalla de Cancelacion de usuarios */
	public UsuarioBean consultaCancelaUsuario(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getUsuarioID(),
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaCancelaUsuario",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
				usuario.setUsuarioID(herramientas.Utileria.completaCerosIzquierda(
										resultSet.getInt(1), UsuarioBean.LONGITUD_ID));
				usuario.setNombreCompleto(resultSet.getString(2));
				usuario.setClave(resultSet.getString(3));
				usuario.setContrasenia("");
				usuario.setFechUltAcces(resultSet.getString(4));
				usuario.setFechUltPass(resultSet.getString(5));
				usuario.setEstatus(resultSet.getString(6));
				usuario.setMotivoCancel(resultSet.getString(7));
				usuario.setFechaCancel(resultSet.getString(8));
				usuario.setUsuarioIDCancel(resultSet.getString("UsuarioIDCancel"));
				usuario.setMotivoReactiva(resultSet.getString("MotivoReactiva"));
				usuario.setFechaReactiva(resultSet.getString("FechaReactiva"));
				usuario.setUsuarioIDReactiva(resultSet.getString("UsuarioIDReactiva"));
				return usuario;
			}
		});
		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

	}
	/* Consulta Contrasenia de Usuario: Para la pantalla de Cambio de contrasenia*/
	public UsuarioBean consultaContraseniaUsuario(UsuarioBean usuarioBean, int tipoConsulta) {


		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getUsuarioID(),
								Constantes.STRING_VACIO,
								usuarioBean.getContrasenia(),// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaContraseniaUsuario",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
				usuario.setContrasenia(resultSet.getString(1));
				return usuario;
			}
		});
		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

	}
	/*Consulta limpia usuario*/
	public UsuarioBean consultaLimpiaSesion(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getUsuarioID(),
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaLimpiaSesion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
				usuario.setUsuarioID(herramientas.Utileria.completaCerosIzquierda(
										resultSet.getInt(1), UsuarioBean.LONGITUD_ID));
				usuario.setNombreCompleto(resultSet.getString(2));
				usuario.setClave(resultSet.getString(3));
				usuario.setContrasenia("");
				usuario.setFechUltAcces(resultSet.getString(4));
				usuario.setFechUltPass(resultSet.getString(5));
				usuario.setEstatus(resultSet.getString(6));
				usuario.setEstatusSesion(resultSet.getString(7));
				return usuario;
			}
		});
		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

	}

	/* Consuta Usuario*/
	public UsuarioBean consultaWS(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getUsuarioID(),
								Constantes.STRING_VACIO,//clave
								Constantes.STRING_VACIO,// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
							usuario.setSucursalUsuario(resultSet.getString(1));
							usuario.setIpSesion(resultSet.getString(2));
							usuario.setEmpresaID(resultSet.getString(3));
							usuario.setFechaSistema(resultSet.getString(4));
							return usuario;
			}
		});

		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;
	}

	// Consulta de Usuarios con Estatus de Gestor
	public UsuarioBean consultaUsuarioGestor(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getUsuarioID(),
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();

				usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
				usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));

				return usuario;

			}
		});
		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

	}

	// Consulta de Usuarios con Estatus de Supervisor
		public UsuarioBean consultaUsuarioSupervisor(UsuarioBean usuarioBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	usuarioBean.getUsuarioID(),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,// contrasenia
									Constantes.STRING_VACIO,// nombre completo
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();

					usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
					usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));

					return usuario;

				}
			});
			return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

		}

		// metodo que se usa para validaciones ventanilla ajuste sobrante y ajuste faltante
		public String consultaPassUsuario(UsuarioBean usuarioBean, int tipoConsulta) {
			String passUsuAuto = "";

			try{
				String query = "call USUARIOSCON(?,?,?,?,?, ?, ?,?,?,?,?,?,?);";
				Object[] parametros = {	Constantes.STRING_VACIO,
										usuarioBean.getUsuario(),
										Constantes.STRING_VACIO,
										Constantes.STRING_VACIO,
										Constantes.ENTERO_CERO,
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"UsuarioDAO.ConsultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						String passwd = new String();

						passwd=resultSet.getString("Contrasenia");
							return passwd;
					}
				});
			passUsuAuto= matches.size() > 0 ? (String) matches.get(0) : "";
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Password", e);
			}
			return passUsuAuto;
		}

	public UsuarioBean ConEstatusAnalista(UsuarioBean usuarioBean, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	usuarioBean.getUsuarioID(),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioDAO.ConEstatusAnalista",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();

								usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
								usuario.setEstatusAnalisis(resultSet.getString("EstatusAnalisis"));
								usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
								usuario.setClave(resultSet.getString("Clave"));

								return usuario;
				}
			});

			return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;
		}



	public UsuarioBean ConUsuarioAnalistaVirtual(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getUsuarioID(),
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.ConUsuarioAnalistaVirtual",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();

							usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
							usuario.setNombreCompleto(resultSet.getString("AnalistaAsignado"));
							return usuario;
			}
		});

		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;
	}
	/* Lista de Usuarios por Nombre */
	public List listaPrincipal(UsuarioBean usuarioBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call USUARIOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"UsuarioDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
				usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
				usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
				usuario.setSucursalUsuario(resultSet.getString("Sucursal"));
				usuario.setClave(resultSet.getString("Clave"));
				return usuario;
			}
		});

		return matches;
	}

	/* Lista de Usuarios por Nombre */
	public List listaConCorreos(UsuarioBean usuarioBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call USUARIOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"UsuarioDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();

				usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
				usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));

				return usuario;
			}
		});

		return matches;
	}

	/* Lista de Usuarios por Nombre */
	public List listaporSucursal(UsuarioBean usuarioBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call USUARIOSLIS(?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getNombreCompleto(),
								Integer.valueOf(usuarioBean.getSucursalUsuario()),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"UsuarioDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
				usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
				usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
				usuario.setSucursalUsuario(resultSet.getString("Sucursal"));
				usuario.setClave(resultSet.getString("Clave"));
				return usuario;
			}
		});

		return matches;
	}

	/* Consulta de Usuario: Para buscar usuarios por nombre completo  */
	public List consultaUsuarioPorNombre(UsuarioBean usuarioBean, int tipoConsulta) {
		List usuarioBeanCon = null;
		try{
			//Query con el Store Procedure
			String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(usuarioBean.getUsuarioID()),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,// contrasenia
									usuarioBean.getNombreCompleto(),// nombre completo
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioDAO.consultaBloDesbloqueo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();
					usuario.setCorreo(resultSet.getString(1));
					usuario.setNombreCompleto(resultSet.getString(2));
					return usuario;
				}
			});

			usuarioBeanCon= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cnsulta de usuario por nombre ", e);
		}
		return usuarioBeanCon;
	}
	public List consultaUsuarioPorNombreExterno(UsuarioBean usuarioBean, int tipoConsulta) {
		List usuarioBeanCon = null;
		try{
			//Query con el Store Procedure
			String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(usuarioBean.getUsuarioID()),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,// contrasenia
									usuarioBean.getNombreCompleto(),// nombre completo
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioDAO.consultaBloDesbloqueo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(usuarioBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();
					usuario.setCorreo(resultSet.getString(1));
					usuario.setNombreCompleto(resultSet.getString(2));
					return usuario;
				}
			});

			usuarioBeanCon= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cnsulta de usuario por nombre ", e);
		}
		return usuarioBeanCon;
	}

	public List consultaUsuarioPorNombreExterna(UsuarioBean usuarioBean, int tipoConsulta) {
		List usuarioBeanCon = null;
		try{
			//Query con el Store Procedure
			String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(usuarioBean.getUsuarioID()),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,// contrasenia
									usuarioBean.getNombreCompleto(),// nombre completo
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioDAO.consultaBloDesbloqueo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(usuarioBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();
					usuario.setCorreo(resultSet.getString(1));
					usuario.setNombreCompleto(resultSet.getString(2));
					return usuario;
				}
			});

			usuarioBeanCon= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cnsulta de usuario por nombre ", e);
		}
		return usuarioBeanCon;
	}
	/* Lista de Usuarios por Nombre */
	public List listaUsuarioGestor(UsuarioBean usuarioBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call USUARIOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"UsuarioDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
				usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
				usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return usuario;
			}
		});

		return matches;
	}

	/* Lista de Usuarios de Gestores */
	public List listaUsuarioGestProm(UsuarioBean usuarioBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call USUARIOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"UsuarioDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
				usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
				usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return usuario;
			}
		});

		return matches;
	}

	/* Lista de Usuarios de Supervisores*/
	public List listaUsuarioSupervisor(UsuarioBean usuarioBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call USUARIOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"UsuarioDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
				usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
				usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return usuario;
			}
		});

		return matches;
	}
	public List comboGestor(int tipoLista) {
		//Query con el Store Procedure
		String query = "call USUARIOSLIS(?,?,?,	?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario= new UsuarioBean();
				usuario.setUsuarioID(resultSet.getString("UsuarioID"));
				usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
				return usuario;
			}
		});
		return matches;
	}


	/* Valida usuario para WS SMSAP*/
	public UsuarioBean smsapValidaUserWS(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								usuarioBean.getClave(),//clave
								usuarioBean.getContrasenia(),// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								Constantes.ENTERO_CERO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
							usuario.setUsuarioID(resultSet.getString("UsuarioID"));
							usuario.setCodigoResp(resultSet.getString("CodigoResp"));
							usuario.setCodigoDesc(resultSet.getString("CodigoDesc"));
							usuario.setEsValido(resultSet.getString("EsValido"));
							return usuario;
			}
		});

		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;
	}


	/* Valida usuario para WS PDA*/
	public UsuarioBean pdaValidaUserWS(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call USUARIOSCON(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?);";
		Object[] parametros = {	Constantes.ENTERO_CERO,
								usuarioBean.getClave(),//clave
								usuarioBean.getContrasenia(),// contrasenia
								Constantes.STRING_VACIO,// nombre completo
								usuarioBean.getSucursalUsuario(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"UsuarioDAO.consultaWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
							usuario.setUsuarioID(resultSet.getString("UsuarioID"));
							usuario.setCodigoResp(resultSet.getString("CodigoResp"));
							usuario.setCodigoDesc(resultSet.getString("CodigoDesc"));
							usuario.setEsValido(resultSet.getString("EsValido"));
							return usuario;
			}
		});

		return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;
	}

	/* lista de usuarios activos para WS */
	public List listaUsuariosWS(int tipoLista){
		List sucursalesLis = null;
		try{
			String query = "call USUARIOSLIS(?,?,?,?,?,  ?,?,?,?,?);";
			Object[] parametros = {	Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioDAO.listaUsuariosWS",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					UsuarioBean usuarios = new UsuarioBean();

					usuarios.setUsuarioID(resultSet.getString("UsuarioID"));
					usuarios.setNombreCompleto(resultSet.getString("NombreCompleto"));

					return usuarios;
				}
			});
			sucursalesLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de usuarios activos para WS", e);
		}
		return sucursalesLis;
	}// fin de lista para WS

	public UsuarioBean obtieneDataSource(final UsuarioBean usuarioBean){
		UsuarioBean usuario = null;

		System.out.println("Param Sesion" + parametrosAuditoriaBean.getEmpresaID());
		System.out.println("Param Sesion" + parametrosAuditoriaBean.getUsuario());

		return usuario;
	}




		public List consultaUsuarioActivo(int tipoLista){
			List sucursalesLis = null;
			try{
				String query = "call USUARIOSLIS(?,?,?,?,?,  ?,?,?,?,?);";
				Object[] parametros = {	Constantes.STRING_VACIO,
										Constantes.ENTERO_CERO,
										tipoLista,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"UsuarioDAO.listaUsuariosWS",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
						UsuarioBean usuarios = new UsuarioBean();

						usuarios.setUsuarioID(resultSet.getString("UsuarioID"));
						usuarios.setClave(resultSet.getString("Clave"));
						usuarios.setNombreCompleto(resultSet.getString("NombreCompleto"));
						usuarios.setEstatus(resultSet.getString("Estatus"));
						usuarios.setNombreSucurs(resultSet.getString("NombreSucurs"));




						return usuarios;
					}
				});
				sucursalesLis = matches;
			}catch(Exception e){
				 e.printStackTrace();
				 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Usuarios Activos", e);
			}
			return sucursalesLis;
	}

	/* Lista de usuarios para convenciones seccionales*/

		public List lisUsuAsamGral(UsuarioBean usuarioBean, int tipoLista) {
			//Query con el Store Procedure
			String query = "call USUARIOSLIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	usuarioBean.getNombreCompleto(),
									Constantes.ENTERO_CERO,
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"UsuarioDAO.listaPrincipal",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();
					usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
					usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
					return usuario;
				}
			});

			return matches;
		}

		// Consulta usuarios para convenciones seccionales
				public UsuarioBean consultaUsuAsamGral(UsuarioBean usuarioBean, int tipoConsulta) {
					//Query con el Store Procedure
					String query = "call USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {	usuarioBean.getUsuarioID(),
											Constantes.STRING_VACIO,
											Constantes.STRING_VACIO,// contrasenia
											Constantes.STRING_VACIO,// nombre completo
											Constantes.ENTERO_CERO,
											tipoConsulta,
											Constantes.ENTERO_CERO,
											Constantes.ENTERO_CERO,
											Constantes.FECHA_VACIA,
											Constantes.STRING_VACIO,
											"UsuarioDAO.consultaUsuAsamGral",
											Constantes.ENTERO_CERO,
											Constantes.ENTERO_CERO};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							UsuarioBean usuario = new UsuarioBean();

							usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
							usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
							usuario.setNombreRol(resultSet.getString("nombreRol"));
							usuario.setRolID(resultSet.getString("rolID"));

							return usuario;

						}
					});
					return matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

	}

	public List listaActBloq(UsuarioBean usuarioBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call USUARIOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	usuarioBean.getNombreCompleto(),
								Constantes.ENTERO_CERO,
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"UsuarioDAO.listaActBloq",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UsuarioBean usuario = new UsuarioBean();
				usuario.setUsuarioID(String.valueOf(resultSet.getInt("UsuarioID")));
				usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));
				usuario.setSucursalUsuario(resultSet.getString("Sucursal"));
				usuario.setClave(resultSet.getString("Clave"));
				return usuario;
			}
		});

		return matches;
	}


	/*Metodo Actualizado*/
	/* Actualiza a activo el estatus de un usuario que se Cancelo*/
	public MensajeTransaccionBean actReactivaUsuario(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Utileria.convierteEntero(usuario.getUsuarioID()));
								sentenciaStore.setString("Par_Clave",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Estatus",usuario.getEstatus());
								sentenciaStore.setString("Par_MotivBloq",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechBloq",Constantes.FECHA_VACIA);

								sentenciaStore.setString("Par_MotivCancel",usuario.getMotivoCancel());
								sentenciaStore.setString("Par_FechCancel",usuario.getFechaCancel());
								sentenciaStore.setString("Par_Contrasenia",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioIDRespon",Utileria.convierteEntero(usuario.getUsuarioIDRespon()));
								sentenciaStore.setString("Par_MotivoReactiva",usuario.getMotivoReactiva());

							    sentenciaStore.setString("Par_FechaReactiva",usuario.getFechaReactiva());
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

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

									resultadosStore.next();
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Actualizacion de Reactivacion de Usuario Cancelado", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}



	/* METODO PARA BLOQUEO AUTOMATICOS DE USUARIOS QUE NO SE AN LOGEADO ULTIMAMENTE SEGUN LOS DIAS MAXIMO PARAMETRIZADO */
	public MensajeTransaccionBean usuarioBloqueoAut(){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		final int tipoProceso = 1;
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSBLOQPRO(?, ?,?,?,?,? ,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

							    sentenciaStore.setInt("Par_NumPro",tipoProceso);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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

									resultadosStore.next();
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Actualizacion de Bloqueo Automatico de Usuarios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}
	/**
	 * @Descripcion: Consulta el usuario con rol de coordinador
	 */
	public UsuarioBean consultaCoordinador(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		UsuarioBean beanUsuario = null;
		try{
			String query = "CALL USUARIOSCON(?,?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	usuarioBean.getUsuarioID(),
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,// contrasenia
									Constantes.STRING_VACIO,// nombre completo
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"UsuarioDAO.consultaCoordinador",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call USUARIOSCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					UsuarioBean usuario = new UsuarioBean();

					usuario.setUsuarioID(resultSet.getString("UsuarioID"));
					usuario.setSucursalUsuario(resultSet.getString("SucursalUsuario"));
					usuario.setNombreCompleto(resultSet.getString("NombreCompleto"));

					return usuario;

				}
			});

			beanUsuario = matches.size() > 0 ? (UsuarioBean) matches.get(0) : null;

		}catch(Exception  e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de Coordinador[consultaCoordinador]", e);
		}
		return beanUsuario;
	}

	public MensajeTransaccionBean actRegistroHuellas(final UsuarioBean usuario, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call USUARIOSACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? ,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NumUsuario",Utileria.convierteEntero(usuario.getUsuarioID()));
								sentenciaStore.setString("Par_Clave",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_Estatus",usuario.getEstatus());
								sentenciaStore.setString("Par_MotivBloq",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechBloq",Constantes.FECHA_VACIA);

								sentenciaStore.setString("Par_MotivCancel",Constantes.STRING_VACIO);
								sentenciaStore.setString("Par_FechCancel",Constantes.FECHA_VACIA);
								sentenciaStore.setString("Par_Contrasenia",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioIDRespon",Utileria.convierteEntero(usuario.getUsuarioID()));
								sentenciaStore.setString("Par_MotivoReactiva",Constantes.STRING_VACIO);

							    sentenciaStore.setString("Par_FechaReactiva",Constantes.FECHA_VACIA);
							    sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

							    sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();


									resultadosStore.next();
									mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("Consecutivo"));

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
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de Actualizacion de Registro de Usuarios", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

}