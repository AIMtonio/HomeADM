


package originacion.dao;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import originacion.bean.SolicitudesCreAsigBean;


public class SolicitudesCreAsigDAO extends BaseDAO{
	public SolicitudesCreAsigDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------

	public MensajeTransaccionBean alta(final SolicitudesCreAsigBean solicitudesCreAsigBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();


		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call SOLICITUDESASIGNACIONESALT("+
										"?,?,?,?,?  ," +
										"?,?,?,?,?	," +
										"?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								try{
								sentenciaStore.setInt("Par_UsuarioID",Utileria.convierteEntero(solicitudesCreAsigBean.getUsuarioID()));
								sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(solicitudesCreAsigBean.getSolicitudCreditoID()));
								sentenciaStore.setInt("Par_TipoAsignacionID",Utileria.convierteEntero(solicitudesCreAsigBean.getTipoAsignacionID()));
								sentenciaStore.setInt("Par_ProductoID",Utileria.convierteEntero(solicitudesCreAsigBean.getProductoID()));
								sentenciaStore.setString("Par_AsignacionAuto",Constantes.STRING_NO);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","SolicitudesCreAsigDAO.alta");

								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);
								loggerSAFI.info(sentenciaStore.toString());
								return sentenciaStore;
								} catch(Exception ex){
									ex.printStackTrace();
									loggerSAFI.info(sentenciaStore.toString());
									return null;
								}

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
					loggerSAFI.error("error en alta de Asignacion de Solicitud Credito", e);
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}


	public MensajeTransaccionBean altaAsignacionAutomatico(final SolicitudesCreAsigBean solicitudesCreAsigBean, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();


		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call ASIGNACIONSOLICITUDESPRO("+
										"?,?,?," +
										"?,?,?,?,?," +
										"?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								try{
								sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(solicitudesCreAsigBean.getSolicitudCreditoID()));
								sentenciaStore.setInt("Par_UsuarioExcluir",Utileria.convierteEntero(solicitudesCreAsigBean.getUsuarioID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","SolicitudesCreAsigDAO.alta");

								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",NumeroTransaccion);
								loggerSAFI.info(sentenciaStore.toString());
								return sentenciaStore;
								} catch(Exception ex){
									ex.printStackTrace();
									loggerSAFI.info(sentenciaStore.toString());
									return null;
								}

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
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
					loggerSAFI.error("error en alta de Asignacion Automatica de Solicitud Credito", e);
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}
	private final static String salidaPantalla = "S";


    public MensajeTransaccionBean altaHistorico(final SolicitudesCreAsigBean solicitudesCreAsigBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call HISSOLICITUDESASIGNACIONESALT(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SolicitudCreditoID",Utileria.convierteEntero(solicitudesCreAsigBean.getSolicitudCreditoID()));
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SolicitudesCreAsigDAO.altaHistorico");
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
						throw new Exception(Constantes.MSG_ERROR + " SolicitudesCreAsigDAO.altaHistorico");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico asignacion de solicitudes Credito ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

    public MensajeTransaccionBean grabaSolicitudAsignacion(final SolicitudesCreAsigBean solicitudesCreAsigBean) {
			transaccionDAO.generaNumeroTransaccion();
			MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try{
						mensajeBean=altaHistorico(solicitudesCreAsigBean);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
							mensajeBean = alta(solicitudesCreAsigBean, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
					}catch (Exception e) {
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



	public MensajeTransaccionBean grabaSolicitudMasiva(final SolicitudesCreAsigBean solicitudesCreAsigBean,final List<SolicitudesCreAsigBean> listaSolicitudes) {
			transaccionDAO.generaNumeroTransaccion();
			MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try{

						for(SolicitudesCreAsigBean detalle : listaSolicitudes){
							mensajeBean=altaHistorico(detalle);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean = altaAsignacionAutomatico(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					}catch (Exception e) {
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

		/* Consuta Solicitudes Asignadas por Llave Principal */
	public SolicitudesCreAsigBean consultaPrincipal(SolicitudesCreAsigBean solicitudesCreAsigBean, int tipoConsulta) {
			// Query con el Store Procedure
			try {
				String query = "call SOLITUDESASIGNADASCON(?,?,?,?,?, ?,?,?,?,?,?,?);";

				Object[] parametros = { solicitudesCreAsigBean.getSolicitudCreditoID(),Constantes.ENTERO_CERO,Constantes.ENTERO_CERO,Constantes.ENTERO_CERO, tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "CreditosDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO };
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLITUDESASIGNADASCON(  " + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						SolicitudesCreAsigBean solicitudesCreAsigBean = new SolicitudesCreAsigBean();
						try {
							solicitudesCreAsigBean.setSolicitudAsignaID(String.valueOf(resultSet.getLong(1)));
							solicitudesCreAsigBean.setUsuarioID(String.valueOf(resultSet.getLong(2)));
							solicitudesCreAsigBean.setSolicitudCreditoID(String.valueOf(resultSet.getLong(3)));
							solicitudesCreAsigBean.setTipoAsignacionID(String.valueOf(resultSet.getLong(4)));
							solicitudesCreAsigBean.setProductoID(String.valueOf(resultSet.getLong(5)));
							solicitudesCreAsigBean.setNombreAnalista(resultSet.getString("NombreCompleto"));
							solicitudesCreAsigBean.setNombreCompletoC(resultSet.getString("NombreCliente"));

						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return solicitudesCreAsigBean;

					}
				});

				return matches.size() > 0 ? (SolicitudesCreAsigBean) matches.get(0) : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			return null;
		}



		/* Consuta Solicitudes Asignadas por Llave Principal */
	public SolicitudesCreAsigBean consultaAnalistasAsig(SolicitudesCreAsigBean solicitudesCreAsigBean, int tipoConsulta) {
			// Query con el Store Procedure
			try {
				String query = "call SOLITUDESASIGNADASCON(?,?,?,?,?, ?,?,?,?,?,?,?);";

				Object[] parametros = { solicitudesCreAsigBean.getSolicitudCreditoID(),solicitudesCreAsigBean.getTipoAsignacionID(),solicitudesCreAsigBean.getProductoID(),solicitudesCreAsigBean.getUsuarioID(), tipoConsulta, Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "CreditosDAO.consultaPrincipal", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO };
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SOLITUDESASIGNADASCON(  " + Arrays.toString(parametros) + ")");

				List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						SolicitudesCreAsigBean solicitudesCreAsigBean = new SolicitudesCreAsigBean();
						try {
							solicitudesCreAsigBean.setUsuarioID(String.valueOf(resultSet.getLong(1)));
							solicitudesCreAsigBean.setNombreAnalista(resultSet.getString("NombreCompleto"));


						} catch (Exception ex) {
							ex.printStackTrace();
							return null;
						}

						return solicitudesCreAsigBean;

					}
				});

				return matches.size() > 0 ? (SolicitudesCreAsigBean) matches.get(0) : null;
			} catch (Exception ex) {
				ex.printStackTrace();
			}
			return null;
		}




	public List<SolicitudesCreAsigBean> lista(SolicitudesCreAsigBean solicitudesCreAsigBean,int tipoLista) {
		// Query con el Store Procedure
		String query = "call SOLICITUDESASIGNADASLIS(?,?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			solicitudesCreAsigBean.getSolicitudCreditoID(),
			tipoLista,
			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"SolicitudesCreAsigDAO.lista",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDESASIGNADASLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				SolicitudesCreAsigBean solicitudes=new SolicitudesCreAsigBean();

				solicitudes.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				solicitudes.setNombreCompletoC(resultSet.getString("NombreCompletoCli"));
				solicitudes.setEstatusSolicitud(resultSet.getString("Estatus"));
				solicitudes.setMontoAutorizadoSolicitud(resultSet.getString("MontoAutorizado"));
				solicitudes.setFechaRegistroSolicitud(resultSet.getString("FechaRegistro"));
				solicitudes.setNombreAnalista((resultSet.getString("AnalistaAsignado")));

				return solicitudes;
			}
		});

		return matches;
	}



	public List<SolicitudesCreAsigBean> listaSolicitudesPorUsuario(SolicitudesCreAsigBean solicitudesCreAsigBean,int tipoLista) {
		// Query con el Store Procedure
		String query = "call SOLICITUDESASIGNADASLIS(?,?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			solicitudesCreAsigBean.getUsuarioID(),
			tipoLista,
			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"SolicitudesCreAsigDAO.lista",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SOLICITUDESASIGNADASLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				SolicitudesCreAsigBean solicitudes=new SolicitudesCreAsigBean();

				solicitudes.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				solicitudes.setProductoID(resultSet.getString("ProductoID"));
				solicitudes.setDescripcionProducto(resultSet.getString("DescripcionProd"));
				solicitudes.setClienteID(resultSet.getString("ClienteID"));
				solicitudes.setNombreCompletoC(resultSet.getString("NombreCompletoCli"));
				solicitudes.setNombreAnalista(resultSet.getString("AnalistaAsignado"));
				solicitudes.setTipoAsignacionID(resultSet.getString("TipoAsignacionID"));
				solicitudes.setUsuarioID(resultSet.getString("UsuarioID"));

				return solicitudes;
			}
		});

		return matches;
	}


	public List<SolicitudesCreAsigBean> listaReporte(final SolicitudesCreAsigBean solicitudesCreAsigBean){
		List<SolicitudesCreAsigBean> ListaResultado=null;
		int tipoReporte = 1;
		try{
		String query = "CALL SOLICITUDESASIGNADASREP(?,?,?," +
												" ?,?,?,?,?," +
												" ?,?)";
		Object[] parametros ={

				Utileria.convierteFecha(solicitudesCreAsigBean.getFechaInicio()),
				Utileria.convierteFecha(solicitudesCreAsigBean.getFechaFin()),
				Utileria.convierteEntero(solicitudesCreAsigBean.getUsuarioID()),

	    		parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),

				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL SOLICITUDESASIGNADASREP(  " + Arrays.toString(parametros) + ");");
		List<SolicitudesCreAsigBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SolicitudesCreAsigBean solicitudesCreBean= new SolicitudesCreAsigBean();

				solicitudesCreBean.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				solicitudesCreBean.setProspectoID(resultSet.getString("ProspectoID"));
				solicitudesCreBean.setNombreAnalista(resultSet.getString("NombreAnalista"));
				solicitudesCreBean.setCreditoID(resultSet.getString("CreditoID"));
				solicitudesCreBean.setNombreEstado(resultSet.getString("NombreEstado"));
				solicitudesCreBean.setDescripcionProducto(resultSet.getString("NombreProducto"));
				solicitudesCreBean.setNombreConvenio(resultSet.getString("NombreConvenio"));
				solicitudesCreBean.setClienteID(resultSet.getString("ClienteID"));
				solicitudesCreBean.setNombreCompletoC(resultSet.getString("NombreCliente"));
				solicitudesCreBean.setMontoSolicitado(resultSet.getString("MontoSolicitado"));
				solicitudesCreBean.setFinalidad(resultSet.getString("Finalidad"));
				solicitudesCreBean.setPlazoID(resultSet.getString("PlazoID"));
				solicitudesCreBean.setMontoMaximo(resultSet.getString("MontoMaximo"));
				solicitudesCreBean.setFechaLiberada(resultSet.getString("FechaLiberada"));
				solicitudesCreBean.setHoraLiberada(resultSet.getString("HoraLiberada"));
				solicitudesCreBean.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
				solicitudesCreBean.setMotivoDevolucion(resultSet.getString("MotivoDevolucion"));
				solicitudesCreBean.setEstatusSolicitud(resultSet.getString("EstatusSolicitud"));
				solicitudesCreBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
				solicitudesCreBean.setAnalistaID(resultSet.getString("AnalistaID"));

				return solicitudesCreBean ;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte asignacion de solicitud credito: ", e);
		}
		return ListaResultado;
	}// fin lista report


}


