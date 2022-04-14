


package credito.dao;
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

import soporte.bean.UsuarioBean;
import activos.bean.ActivosBean;
import credito.bean.AutorizaAvalesBean;
import credito.bean.PerfilesAnalistasCreBean;
import credito.bean.ProductosCreditoBean;
import credito.beanWS.request.ListaProdCreditoRequest;

public class PerfilesAnalistasCreDAO extends BaseDAO {

	public PerfilesAnalistasCreDAO() {
		super();
	}


	// ------------------ Transacciones ------------------------------------------

	public MensajeTransaccionBean alta(final PerfilesAnalistasCreBean perfilesAnalistasCre, final long NumeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();


		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call PERFILESANALISTASALT("+
										"?,?,?,?,?  ," +
										"?,?,?,?,?	," +
										"?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								try{
								sentenciaStore.setInt("Par_RolID",Utileria.convierteEntero(perfilesAnalistasCre.getPerfilID()));
								sentenciaStore.setString("Par_TipoPerfil",perfilesAnalistasCre.getTipoPerfil());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CreditosDAO");

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
					loggerSAFI.error("error en alta de Analista de Credito", e);
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	private final static String salidaPantalla = "S";


		public MensajeTransaccionBean altaHistorico(final PerfilesAnalistasCreBean perfilesAnalistasCreBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call HISPERFILESANALISTASALT(?,?,?,?,?,"
																			+ "?,?,?,?,?,"
																			+ "?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoPerfil", perfilesAnalistasCreBean.getTipoPerfil());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PerfilesAnalistasCreDAO.altaHistorico");
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
						throw new Exception(Constantes.MSG_ERROR + " .PerfilesAnalistasCreDAO.altaHistorico");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta historico Perfiles Analistas de Credito ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}




	public MensajeTransaccionBean baja(final PerfilesAnalistasCreBean perfilesAnalistasCreBean, final int tipoBaja) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
			try {

/*---------------Query con el SP-------------*/
				String query = "call PERFILESANALISTASBAJ(?,?, ?,?,?,?,?,?,?);";
				Object[] parametros = {
						Utileria.convierteEntero(perfilesAnalistasCreBean.getPerfilID()),
						tipoBaja,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						parametrosAuditoriaBean.getNombrePrograma(),
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERFILESANALISTASBAJ(  " + Arrays.toString(parametros) + ")");


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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de Perfiles Analistas", e);
			}
			return mensajeBean;
		}
	});
	return mensaje;
}
	/* LISTA DE PERFILES */


	public List<PerfilesAnalistasCreBean> lista(PerfilesAnalistasCreBean perfilesAnalistasCreBean,int tipoLista) {
		// Query con el Store Procedure
		String query = "call PERFILESANALISTASLIS(?,"
										   +"?,?,?,?,?,?,?);";

		Object[] parametros = {
			tipoLista,

			parametrosAuditoriaBean.getEmpresaID(),
			parametrosAuditoriaBean.getUsuario(),
			parametrosAuditoriaBean.getFecha(),
			parametrosAuditoriaBean.getDireccionIP(),
			"PerfilesAnalistasCreDAO.listaPerfilesAnalistasCre",
			parametrosAuditoriaBean.getSucursal(),
			Constantes.ENTERO_CERO
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PERFILESANALISTASLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {

				PerfilesAnalistasCreBean perfiles=new PerfilesAnalistasCreBean();
				perfiles.setPerfilID(resultSet.getString("PerfilID"));
				perfiles.setNombreRol(resultSet.getString("NombreRol"));
				perfiles.setTipoPerfil(resultSet.getString("TipoPerfil"));
				perfiles.setRolID(resultSet.getString("RolID"));
				perfiles.setPerfilExpediente(resultSet.getString("PerfilExpediente"));

				return perfiles;
			}
		});

		return matches;
	}




	/* Modifica Usuario */
	public MensajeTransaccionBean modificaPerfilExpediente(final PerfilesAnalistasCreBean perfilExpediente) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PARAMGENERALESMOD("
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_llaveParametro","PerfilEdicionExpediente");
							sentenciaStore.setString("Par_ValorParametro", perfilExpediente.getPerfilExpediente());

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

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .PerfilesAnalistasCreDAO.modificaPerfilExpediente");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .PerfilesAnalistasCreDAO.modificaPerfilExpediente");
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
					loggerSAFI.error("error en la modificación del perfil expediente", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


   public MensajeTransaccionBean grabaDetalle(final PerfilesAnalistasCreBean perfilesBean,final List<PerfilesAnalistasCreBean> listaDetalle) {
		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean=altaHistorico(perfilesBean);
					mensajeBean=modificaPerfilExpediente(perfilesBean);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					for(PerfilesAnalistasCreBean detalle : listaDetalle){
						mensajeBean = alta(detalle, parametrosAuditoriaBean.getNumeroTransaccion());
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

	//Consulta el perfil del analista
	public PerfilesAnalistasCreBean consultaPerfiles(final PerfilesAnalistasCreBean perfilesBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "CALL PERFILESANALISTASCON(?,?,?,?,?,?,?,?);";
		List matches= null;
		try{
		Object[] parametros = {
				tipoConsulta,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL PERFILESANALISTASCON(  " + Arrays.toString(parametros) + ")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PerfilesAnalistasCreBean perfilBean = new PerfilesAnalistasCreBean();
				perfilBean.setPerfilID(resultSet.getString("PerfilID"));
				perfilBean.setRolID(resultSet.getString("RolID"));
				perfilBean.setTipoPerfil(resultSet.getString("TipoPerfil"));

				return perfilBean;
			}
		});
		}catch(Exception e){
			e.printStackTrace();
		}
		return matches.size() > 0 ? (PerfilesAnalistasCreBean) matches.get(0) : null;
	}



}
