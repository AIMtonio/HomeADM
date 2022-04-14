package cuentas.dao;

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

import seguridad.servicio.SeguridadRecursosServicio;
import cuentas.bean.CuentasPersonaBean;
import cuentas.bean.VerificacionPreguntasBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class VerificacionPreguntasDAO extends BaseDAO{

	public VerificacionPreguntasDAO (){
		super();
	}

	// Valida Preguntas de Seguridad
	 public MensajeTransaccionBean validaPreguntasSeguridad(final VerificacionPreguntasBean verificacionPreguntasBean,final List listaCodigosResp) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					VerificacionPreguntasBean respuestasBean;
					for(int i=0; i<listaCodigosResp.size(); i++){
						respuestasBean = (VerificacionPreguntasBean)listaCodigosResp.get(i);
						mensajeBean = validaPreguntasSeguridad(respuestasBean);

						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al registrar preguntas de seguridad", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// Envia preguntas de seguridad
		 public MensajeTransaccionBean enviarPreguntasSeguridad(final VerificacionPreguntasBean verificacionPreguntasBean,final List listaCodigosResp) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						VerificacionPreguntasBean respuestasBean;
						for(int i=0; i<listaCodigosResp.size(); i++){
							respuestasBean = (VerificacionPreguntasBean)listaCodigosResp.get(i);
							mensajeBean = enviarPreguntasSeguridad(respuestasBean);

							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						}

					} catch (Exception e) {
						if(mensajeBean.getNumero()==0){
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al registrar preguntas de seguridad", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	// Valida Preguntas de Seguridad
	public MensajeTransaccionBean validaPreguntasSeguridad(final VerificacionPreguntasBean verificacionPreguntasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					verificacionPreguntasBean.setRespuestas(SeguridadRecursosServicio.encriptaPass(Constantes.STRING_VACIO, verificacionPreguntasBean.getRespuestas()));

					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call VERIFICAPREGUNTASSEGPRO(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(verificacionPreguntasBean.getClienteID()));
								sentenciaStore.setString("Par_Telefono",verificacionPreguntasBean.getNumeroTelefono());
								sentenciaStore.setInt("Par_TipoSoporteID",Utileria.convierteEntero(verificacionPreguntasBean.getTipoSoporteID()));
								sentenciaStore.setInt("Par_PreguntaID",Utileria.convierteEntero(verificacionPreguntasBean.getPreguntaID()));
								sentenciaStore.setString("Par_Respuestas",verificacionPreguntasBean.getRespuestas());

								sentenciaStore.setString("Par_Comentarios",Constantes.STRING_VACIO);
								sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(verificacionPreguntasBean.getUsuarioID()));

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
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString(5));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de Preguntas de Seguridad", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//hace el insert en la tabla VERIFICAPREGUNTASSEG
		public MensajeTransaccionBean enviarPreguntasSeguridad(final VerificacionPreguntasBean verificacionPreguntasBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						verificacionPreguntasBean.setRespuestas(SeguridadRecursosServicio.encriptaPass(Constantes.STRING_VACIO, verificacionPreguntasBean.getRespuestas()));

						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call REGISTRAPREGUNTASSEGPRO(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?, ?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(verificacionPreguntasBean.getClienteID()));
									sentenciaStore.setString("Par_Telefono",verificacionPreguntasBean.getNumeroTelefono());
									sentenciaStore.setInt("Par_TipoSoporteID",Utileria.convierteEntero(verificacionPreguntasBean.getTipoSoporteID()));
									sentenciaStore.setInt("Par_PreguntaID",Utileria.convierteEntero(verificacionPreguntasBean.getPreguntaID()));
									sentenciaStore.setString("Par_Respuestas",verificacionPreguntasBean.getRespuestas());

									sentenciaStore.setString("Par_Comentarios",verificacionPreguntasBean.getComentarios());
									sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(verificacionPreguntasBean.getUsuarioID()));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar lista de Preguntas de Seguridad", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



		/**
		 * Inserta a la tabla de SEGUIMIENTOPDM
		 * @author lvicente
		 * @param verificacionPreguntasBean
		 * @return Retorna mensaje de exito o error del registro del folio para el seguimiento
		 */
				public MensajeTransaccionBean altaFolioSeguimiento(final VerificacionPreguntasBean verificacionPreguntasBean) {
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
											String query = "call SEGUIMIENTOSPDMALT(?,?,?,  ?,?,?,  ?,?,?,?,?, ?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);

											sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(verificacionPreguntasBean.getClienteID()));
											sentenciaStore.setString("Par_Telefono",verificacionPreguntasBean.getNumeroTelefono());
											sentenciaStore.setInt("Par_TipoSoporteID",Utileria.convierteEntero(verificacionPreguntasBean.getTipoSoporteID()));

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
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al generar el folio para el seguimiento", e);
							}
							return mensajeBean;
						}
					});
					return mensaje;
				}



				/**
				 * Inserta a la tabla de COMENTASEGUIMIENTOPDM
				 * @author lvicente
				 * @param verificacionPreguntasBean
				 * @return Retorna mensaje de exito o error del registro del Comentario de folio para el seguimiento
				 */
						public MensajeTransaccionBean altaCometarioFolioSeguimiento(final VerificacionPreguntasBean verificacionPreguntasBean) {
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
													String query = "call COMENTASEGUIMIENTOPDMALT(?,?,?,  ?,?,?,  ?,?,?,?,?, ?,?);";
													CallableStatement sentenciaStore = arg0.prepareCall(query);

													sentenciaStore.setInt("Par_SeguimientoID",Utileria.convierteEntero(verificacionPreguntasBean.getSeguimientoID()));
													sentenciaStore.setString("Par_ComentarioUsuario",verificacionPreguntasBean.getComentarioUsuario());
													sentenciaStore.setString("Par_ComentarioCliente",verificacionPreguntasBean.getComentarioCliente());

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
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al grabar el cometario para el folio del seguimiento", e);
									}
									return mensajeBean;
								}
							});
							return mensaje;
						}


						/**
						 * Modifica a la tabla de COMENTASEGUIMIENTOPDM
						 * @author lvicente
						 * @param verificacionPreguntasBean
						 * @return Retorna mensaje de exito o error de la modificación del folio para el seguimiento Cancelación o Finalización
						 */
								public MensajeTransaccionBean modificaFolioSeguimiento(final VerificacionPreguntasBean verificacionPreguntasBean,final int numModifcacion) {
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
															String query = "call SEGUIMIENTOSPDMMOD(?,?,?,  ?,?,  ?,?,?,?,?, ?,?);";
															CallableStatement sentenciaStore = arg0.prepareCall(query);

															sentenciaStore.setInt("Par_SeguimientoID",Utileria.convierteEntero(verificacionPreguntasBean.getSeguimientoID()));
															sentenciaStore.setInt("Par_NumActualiza",numModifcacion);


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
												loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al modificar el folio del seguimiento", e);
											}
											return mensajeBean;
										}
									});
									return mensaje;
								}
	// Consulta Registros de Preguntas de Seguridad
	public List listaTiposSoporte(int tipoLista,VerificacionPreguntasBean verificacionPreguntasBean) {
		List verificaPreguntasBean = null;
		try{
			//Query con el Store Procedure

			String query = "call CATTIPOSOPORTELIS(?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {
							verificacionPreguntasBean.getTipoSoporteID(),
							Constantes.STRING_VACIO,
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"VerificacionPreguntasDAO.listaCombo",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOSOPORTELIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					VerificacionPreguntasBean bean = new VerificacionPreguntasBean();

					bean.setTipoSoporteID(resultSet.getString("TipoSoporteID"));
					bean.setDescripcion(resultSet.getString("Descripcion"));

					return bean;
				}
			});
			verificaPreguntasBean = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista Combo Tipos de Soporte", e);

		}
		return verificaPreguntasBean;
	}

	// Consulta Registros de Preguntas de Seguridad
	public List listaPreguntaSeguridad(VerificacionPreguntasBean verificacionPreguntasBean, int tipoLista) {
		List verificaPreguntasBean = null;
		try{
			//Query con el Store Procedure

			String query = "call VERIFICAPREGUNTASSEGLIS(?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
									Utileria.convierteEntero(verificacionPreguntasBean.getClienteID()),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"VerificacionPreguntasDAO.listaPreguntas",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call VERIFICAPREGUNTASSEGLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					VerificacionPreguntasBean bean = new VerificacionPreguntasBean();

					bean.setPreguntaID(resultSet.getString("PreguntaID"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					bean.setRespuestas(resultSet.getString("Respuestas"));

					return bean;
				}
			});
			verificaPreguntasBean = matches;

		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista de Preguntas de Seguridad", e);

		}
		return verificaPreguntasBean;
	}



	/**
	 * @author lvicente
	 * @param verificacionPreguntasBean - Bean de entrada con los campos para realizar la lista
	 * @param tipoLista	- Tipo de lista a llamar
	 * @return List<VerificacionPreguntasBean> - Lista de folios para el seguimiento
	 */
		public List<VerificacionPreguntasBean> listaFolioSeguimiento(VerificacionPreguntasBean verificacionPreguntasBean,int tipoLista) {
			List verificaPreguntasBean = null;
			try{
				//Query con el Store Procedure

				String query = "call SEGUIMIENTOSPDMLIS(?,?, ?,?,?,?,?,?,?);";
				Object[] parametros = {
								verificacionPreguntasBean.getSeguimientoID(),
								tipoLista,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"VerificacionPreguntasDAO.listaFolioSeguimiento",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUIMIENTOSPDMLIS(" + Arrays.toString(parametros) +")");
				List<VerificacionPreguntasBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						VerificacionPreguntasBean bean = new VerificacionPreguntasBean();
						bean.setSeguimientoID(resultSet.getString("SeguimientoID"));
						bean.setClienteID(resultSet.getString("ClienteID"));
						bean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						bean.setEstatus(resultSet.getString("Estatus"));

						return bean;
					}
				});
				verificaPreguntasBean = matches;

			}catch(Exception e){

				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista deFolios para el seguimiento", e);

			}
			return verificaPreguntasBean;
		}



		/**
		 * @author lvicente
		 * @param verificacionPreguntasBean - Bean de entrada con los campos para realizar la lista
		 * @param tipoLista	- Tipo de lista a llamar
		 * @return List<VerificacionPreguntasBean> - Lista de folios para el seguimiento
		 */
			public List<VerificacionPreguntasBean> listaComentaFolio(VerificacionPreguntasBean verificacionPreguntasBean,int tipoLista) {
				List verificaPreguntasBean = null;
				try{
					//Query con el Store Procedure

					String query = "call COMENTASEGUIMIENTOPDMLIS(?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
									verificacionPreguntasBean.getSeguimientoID(),
									tipoLista,

									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"VerificacionPreguntasDAO.listaComentaFolio",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMENTASEGUIMIENTOPDMLIS(" + Arrays.toString(parametros) +")");
					List<VerificacionPreguntasBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

							VerificacionPreguntasBean bean = new VerificacionPreguntasBean();
							bean.setConsecutivoID(resultSet.getString("ConsecutivoID"));
							bean.setComentarioUsuario(resultSet.getString("ComentarioUsuario"));
							bean.setComentarioCliente(resultSet.getString("ComentarioCliente"));

							return bean;
						}
					});
					verificaPreguntasBean = matches;

				}catch(Exception e){

					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista deFolios para el seguimiento", e);

				}
				return verificaPreguntasBean;
			}





		/**
		 * @author lvicente
		 * @param verificacionPreguntasBean - Bean con los datos que se envian para realizar la consulta
		 * @param tipoConsulta - Numero de consulta a realizar
		 * @return Retorna un objeto Bean de tipo VerificacionPreguntasBean
		 */
		public VerificacionPreguntasBean consultaFolioSeguimiento(VerificacionPreguntasBean verificacionPreguntasBean,int tipoConsulta) {
			VerificacionPreguntasBean verificaPreguntasBean = null;
			try{
				//Query con el Store Procedure

				String query = "call SEGUIMIENTOSPDMCON(?,?, ?,?,?,?,?,?,?);";
				Object[] parametros = {
								verificacionPreguntasBean.getSeguimientoID(),
								tipoConsulta,

								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"VerificacionPreguntasDAO.listaFolioSeguimiento",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUIMIENTOSPDMCON(" + Arrays.toString(parametros) +")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

						VerificacionPreguntasBean bean = new VerificacionPreguntasBean();
						bean.setSeguimientoID(resultSet.getString("SeguimientoID"));
						bean.setClienteID(resultSet.getString("ClienteID"));
						bean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
						bean.setNumeroTelefono(resultSet.getString("Telefono"));
						bean.setTipoSoporteID(resultSet.getString("TipoSoporteID"));
						bean.setEstatus(resultSet.getString("Estatus"));

						return bean;
					}
				});
				verificaPreguntasBean = matches.size() > 0 ? (VerificacionPreguntasBean) matches.get(0) : null;;

			}catch(Exception e){

				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Lista deFolios para el seguimiento", e);

			}
			return verificaPreguntasBean;
		}

}
