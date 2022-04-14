package originacion.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.AutorizaSolicitudGrupoBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class AutorizaSolicitudGrupoDAO  extends BaseDAO{
ParametrosSesionBean parametrosSesionBean;

	public AutorizaSolicitudGrupoDAO(){
		super();
	}

	public List listaIntegraSolicitudGrupal(AutorizaSolicitudGrupoBean integraGrupo, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					integraGrupo.getGrupoID(),
					Utileria.convierteEntero(integraGrupo.getCiclo()),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AutorizaSolicitudGrupoDAO.listaIntegrantes",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AutorizaSolicitudGrupoBean integraGrupoBean = new AutorizaSolicitudGrupoBean();

				integraGrupoBean.setSolicitudCreditoID(resultSet.getString("Solicitud"));
				integraGrupoBean.setProductoCreditoID(resultSet.getString("Producto"));
				integraGrupoBean.setProspectoID(resultSet.getString("Prospecto"));
				integraGrupoBean.setClienteID(resultSet.getString("Cliente"));
				integraGrupoBean.setMontoSol(resultSet.getString("MontoSolicitado"));
				integraGrupoBean.setAporte(resultSet.getString("AporteCliente"));
				integraGrupoBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				integraGrupoBean.setSolEstatus(resultSet.getString("Estatus"));
				integraGrupoBean.setNombre(resultSet.getString("ClienteNombre"));
				integraGrupoBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
				integraGrupoBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
				integraGrupoBean.setComentarioEjecutivo(resultSet.getString("ComentarioEjecutivo"));
				integraGrupoBean.setPlazoID(resultSet.getString("Descripcion"));
				integraGrupoBean.setMontoAutorizado(resultSet.getString("MontoAutorizado"));
				integraGrupoBean.setEsquemaGrid(resultSet.getString("EsquemaID"));


				return integraGrupoBean;

			}
		});
		return matches;
	}

		// Metodo de rechazo de solicitudes de credito
		public MensajeTransaccionBean rechazarSolicitudCreditoGrupo(final AutorizaSolicitudGrupoBean autorizaSolicitud,
				final AutorizaSolicitudGrupoBean autoriza, final int tipoActualizacion) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call SOLICITUDCREACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);
										sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(autoriza.getSolicitudCreditoID()));
										sentenciaStore.setDouble("Par_MontoAutor",Utileria.convierteDoble(autoriza.getMontoAutorizado()));
										sentenciaStore.setString("Par_FechAutoriz",Utileria.convierteFecha(autorizaSolicitud.getFechaAutoriza()));
										sentenciaStore.setInt("Par_UsuarioAut",Utileria.convierteEntero(autorizaSolicitud.getUsuarioAutoriza()));
										sentenciaStore.setDouble("Par_AporteCli", Utileria.convierteDoble(autoriza.getAporte()));
										sentenciaStore.setString("Par_ComentEjecutivo", autorizaSolicitud.getComentarioEjecutivo());
										sentenciaStore.setString("Par_ComentMesaControl",autorizaSolicitud.getComentarioMesaControl());
										sentenciaStore.setString("Par_CadenaMotivo",Constantes.STRING_VACIO);
										sentenciaStore.setString("Par_ComentMotivo",Constantes.STRING_VACIO);
										sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
										sentenciaStore.setLong("Aud_NumTransaccion",Utileria.convierteLong(autorizaSolicitud.getNumTransaccion()));
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
											mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en rechazo de solicitud de credito", e);
						}
						return mensajeBean;
					}
				});
				return mensaje;
			}


			// Metodo de regreso a ejecutivo de solicitudes de credito
			public MensajeTransaccionBean autorizarSolicitudCreditoGrupo(final AutorizaSolicitudGrupoBean autorizaSolicitud) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call ESQUEMAAUTFIRMAALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_Solicitud",Utileria.convierteEntero(autorizaSolicitud.getSolicitudCreditoID()));
											sentenciaStore.setInt("Par_Esquema",Utileria.convierteEntero(autorizaSolicitud.getEsquemaID()));
											sentenciaStore.setInt("Par_NumFirma",Utileria.convierteEntero(autorizaSolicitud.getNumFirma()));
											sentenciaStore.setInt("Par_Organo",Utileria.convierteEntero(autorizaSolicitud.getOrganoID()));
											sentenciaStore.setDouble("Par_MontoAutor",Utileria.convierteDoble(autorizaSolicitud.getMontoAutorizado()));
											sentenciaStore.setDouble("Par_AporteCli",Utileria.convierteDoble(autorizaSolicitud.getAporte()));
											sentenciaStore.setString("Par_ComentMesaControl",autorizaSolicitud.getComentarioMesaControl());

											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

											sentenciaStore.setInt("Aud_Empresa",parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
											sentenciaStore.setInt("Aud_SucursalID",parametrosAuditoriaBean.getSucursal());
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
												mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en regresar la ejecucion de solicitud de credito", e);
							}
							return mensajeBean;
						}
					});
					return mensaje;
				}


			// Metodo de regreso a ejecutivo de solicitudes de credito
			public MensajeTransaccionBean regresarEjecSolicitudCreditoGrupo(final AutorizaSolicitudGrupoBean autorizaSolicitud,
					final AutorizaSolicitudGrupoBean rechaza, final int tipoActualizacion) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call SOLICITUDCREACT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_SolicCredID",Utileria.convierteEntero(rechaza.getSolicitudCreditoID()));
											sentenciaStore.setDouble("Par_MontoAutor",Utileria.convierteDoble(rechaza.getMontoAutorizado()));
											sentenciaStore.setString("Par_FechAutoriz",Utileria.convierteFecha(autorizaSolicitud.getFechaAutoriza()));
											sentenciaStore.setInt("Par_UsuarioAut",Utileria.convierteEntero(autorizaSolicitud.getUsuarioAutoriza()));
											sentenciaStore.setDouble("Par_AporteCli", Utileria.convierteDoble(rechaza.getAporte()));
											sentenciaStore.setString("Par_ComentEjecutivo", autorizaSolicitud.getComentarioEjecutivo());
											sentenciaStore.setString("Par_ComentMesaControl",autorizaSolicitud.getComentarioMesaControl());
											sentenciaStore.setString("Par_CadenaMotivo",Constantes.STRING_VACIO);
											sentenciaStore.setString("Par_ComentMotivo",Constantes.STRING_VACIO);
											sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

											sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
											sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
											sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
											sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
											sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
											sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
											sentenciaStore.setLong("Aud_NumTransaccion",Utileria.convierteLong(autorizaSolicitud.getNumTransaccion()));
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
												mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
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
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en regresar la ejecucion de solicitud de credito", e);
							}
							return mensajeBean;
						}
					});
					return mensaje;
				}

			// Rechazo de la solicitud de credito
			public MensajeTransaccionBean rechazarSolicitudCredito(final AutorizaSolicitudGrupoBean autorizaSolicitudGrupo, final int tipoActualizacion,
					final List listaRechazo) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
				final long numTransacc = parametrosAuditoriaBean.getNumeroTransaccion();
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

						try {
							AutorizaSolicitudGrupoBean autoriza = new AutorizaSolicitudGrupoBean();
							autorizaSolicitudGrupo.setNumTransaccion(String.valueOf(numTransacc));

							for(int i=0; i<listaRechazo.size(); i++){
								autoriza = (AutorizaSolicitudGrupoBean)listaRechazo.get(i);
								autoriza.setNumTransaccion(autorizaSolicitudGrupo.getNumTransaccion());

								mensajeBean = rechazarSolicitudCreditoGrupo(autorizaSolicitudGrupo,autoriza, tipoActualizacion);

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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al realizar la operacion", e);

						}
						return mensajeBean;
					}
				});
				return mensaje;
			}


		// Rechazo de la solicitud de credito
		public MensajeTransaccionBean regresarEjecSolicitudCredito(final AutorizaSolicitudGrupoBean autorizaSolicitudGrupo, final int tipoActualizacion,
				final List listaRegresa) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			final long numTransacc = parametrosAuditoriaBean.getNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

					try {
						AutorizaSolicitudGrupoBean autoriza = new AutorizaSolicitudGrupoBean();
						autorizaSolicitudGrupo.setNumTransaccion(String.valueOf(numTransacc));

						for(int i=0; i<listaRegresa.size(); i++){
							autoriza = (AutorizaSolicitudGrupoBean)listaRegresa.get(i);
							autoriza.setNumTransaccion(autorizaSolicitudGrupo.getNumTransaccion());

							mensajeBean = regresarEjecSolicitudCreditoGrupo(autorizaSolicitudGrupo,autoriza, tipoActualizacion);

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al realizar la operacion", e);

					}
					return mensajeBean;
				}
			});
			return mensaje;
		}


		// Autorizacion de la solicitud de credito
		public MensajeTransaccionBean autorizaSolicitudCredito(final List listaAutorizaSolicitud) {
						MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			//final long numTransacc = parametrosAuditoriaBean.getNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						if(listaAutorizaSolicitud !=null){
							for(int i=0; i<listaAutorizaSolicitud.size();i++){
								AutorizaSolicitudGrupoBean autoriza = new AutorizaSolicitudGrupoBean();
								/* obtenemos un bean de la lista */
								autoriza = (AutorizaSolicitudGrupoBean)listaAutorizaSolicitud.get(i);

								mensajeBean = autorizarSolicitudCreditoGrupo(autoriza);

								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}

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

	//* ============== Getter & Setter =============  //*
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
