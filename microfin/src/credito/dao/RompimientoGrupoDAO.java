package credito.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import credito.bean.RompimientoGrupoBean;


public class RompimientoGrupoDAO extends BaseDAO{

	ParametrosSesionBean parametrosSesionBean;

	public RompimientoGrupoDAO(){
		super();
	}



	/*=============================== METODOS ==================================*/


	/* Procesa el rompimiento del grupo, desintegrando a un cliente del grupo de credito */
	public MensajeTransaccionBean procesar(final RompimientoGrupoBean bean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call ROMPIMIENTOSGRUPOPRO(?,?,?,?,?,  	?,?,?,?,?, ?,?,?,?,?,	?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(bean.getGrupoID()));
									sentenciaStore.setInt("Par_Ciclo", Utileria.convierteEntero(bean.getCicloActual()));
									sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(bean.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(bean.getUsuarioID()));
									sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(bean.getSucursalID()));
									sentenciaStore.setString("Par_Motivo", bean.getMotivo());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ROMPIMIENTOSGRUPOPRO(" + sentenciaStore.toString() + ")");

									return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesar rompimiento de grupo", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// fin de procesar

	/* Procesa el rompimiento del grupo, desintegrando a un cliente del grupo de creditop or Web Service */
	public MensajeTransaccionBean rompimientoWebService(final RompimientoGrupoBean rompimientoGrupoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "CALL ROMPIMIENTOSGRUPOPRO(?,?,?,?,?," +
																	 "?," +
																	 "?,?,?," +
																	 "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(rompimientoGrupoBean.getGrupoID()));
							sentenciaStore.setInt("Par_Ciclo", Utileria.convierteEntero(rompimientoGrupoBean.getCicloActual()));
							sentenciaStore.setInt("Par_SolicitudCreditoID", Utileria.convierteEntero(rompimientoGrupoBean.getSolicitudCreditoID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(rompimientoGrupoBean.getUsuarioID()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(rompimientoGrupoBean.getSucursalID()));

							sentenciaStore.setString("Par_Motivo", rompimientoGrupoBean.getMotivo());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL ROMPIMIENTOSGRUPOPRO(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivoInt"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					});


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesar rompimiento de grupo", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// fin de procesar

	/* bitacora de Rompimiento de Grupo por Web Service */
	public MensajeTransaccionBean bitacoraRompimiento(final RompimientoGrupoBean rompimientoGrupoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "CALL BITACORAEXCLUSIONESALT(?,?,?,?,?," +
																	   "?,?,?," +
																	   "?,?,?," +
																	   "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_RompimientoID", Utileria.convierteEntero(rompimientoGrupoBean.getRompimientoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(rompimientoGrupoBean.getClienteID()));
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(rompimientoGrupoBean.getCreditoID()));
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(rompimientoGrupoBean.getGrupoID()));
							sentenciaStore.setInt("Par_CicloID", Utileria.convierteEntero(rompimientoGrupoBean.getCicloActual()));

							sentenciaStore.setDouble("Par_DeudaGrupal", Utileria.convierteDoble(rompimientoGrupoBean.getExigibleGrupal()));
							sentenciaStore.setInt("Par_UsuarioRegistroID", Utileria.convierteEntero(rompimientoGrupoBean.getUsuarioID()));
							sentenciaStore.setInt("Par_SucursalRegistroID", Utileria.convierteEntero(rompimientoGrupoBean.getSucursalID()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL BITACORAEXCLUSIONESALT(" + sentenciaStore.toString() + ")");

							return sentenciaStore;

						} //public sql exception

					} // new CallableStatementCreator
					,new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																										DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningún Resultado.");
							}
							return mensajeTransaccion;
						}// public

					}// CallableStatementCallback
					);


				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningún Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}


			} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en procesar rompimiento de grupo", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// fin de procesar

	// Lista integrantes de un grupo de credito
	public List listaIntegrantesGrupo(RompimientoGrupoBean bean, int tipoLista){
		String query = "call INTEGRAGRUPOSLIS(?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
					Utileria.convierteEntero(bean.getGrupoID()),
					Utileria.convierteEntero(bean.getCicloActual()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RompimientoGrupoDAO.listaIntegrantesGrupo",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion(),
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INTEGRAGRUPOSLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				RompimientoGrupoBean beanIntegrantes = new RompimientoGrupoBean();

				beanIntegrantes.setSolicitudCreditoID(resultSet.getString("SolicitudCreditoID"));
				beanIntegrantes.setClienteID(resultSet.getString("ClienteID"));
				beanIntegrantes.setCreditoID(resultSet.getString("CreditoID"));
				beanIntegrantes.setNombreCliente(resultSet.getString("NombreCompleto"));
				beanIntegrantes.setMonto(resultSet.getString("MontoCredito"));
				beanIntegrantes.setFechaInicio(resultSet.getString("FechaInicio"));
				beanIntegrantes.setFechaVencimiento(resultSet.getString("FechaVencimien"));
				beanIntegrantes.setEstatusCredito(resultSet.getString("Estatus"));

				return beanIntegrantes;
			}
		});
		return matches;
	}

	// Consulta Exigible Grupal
	public RompimientoGrupoBean funcionExibileGrupal(final RompimientoGrupoBean rompimientoGrupoBean, final int tipoConsulta) {

		RompimientoGrupoBean rompimientoGrupo = null;
		//Query con el Store Procedure
		try{
			String query = "CALL ROMPIMIENTOSGRUPOCON(?,?,"
													+"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(rompimientoGrupoBean.getGrupoID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"RompimientoGrupoDAO.funcionExibileGrupal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL ROMPIMIENTOSGRUPOCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RompimientoGrupoBean rompimiento = new RompimientoGrupoBean();
					rompimiento.setExigibleGrupal(resultSet.getString("ExigibleGrupal"));
					return rompimiento;
				}
			});

			rompimientoGrupo = matches.size() > 0 ? (RompimientoGrupoBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta del Exigible Grupal ", exception);
			rompimientoGrupo = null;
		}

		return rompimientoGrupo;
	}

	//* ============== GETTER & SETTER =============  //*
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
