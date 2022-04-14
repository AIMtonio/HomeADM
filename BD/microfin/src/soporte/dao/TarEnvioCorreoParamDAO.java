package soporte.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

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

import soporte.bean.TarEnvioCorreoParamBean;

public class TarEnvioCorreoParamDAO extends BaseDAO{

	public ParametrosSesionBean parametrosSesionBean = null;
	public TarEnvioCorreoParamDAO() {
		super();
	}

	// Alta de correo
		public MensajeTransaccionBean altaCorreo(final TarEnvioCorreoParamBean tarEnvioCorreoParam) {

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

									String query = "call TARENVIOCORREOPARAMALT( ?,?,?,?,?," +
																				"?,?,?,?,?," +
																				"?,?,?,?,?," +
																				"?,?,?,?,?," +
																				"?,?); " ;

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_Descripcion",tarEnvioCorreoParam.getDescripcion());
									sentenciaStore.setString("Par_ServidorSMTP",tarEnvioCorreoParam.getServidorSMTP());
									sentenciaStore.setString("Par_PuertoServerSMTP",tarEnvioCorreoParam.getPuertoServerSMTP());
									sentenciaStore.setString("Par_TipoSeguridad",tarEnvioCorreoParam.getTipoSeguridad());
									sentenciaStore.setString("Par_CorreoSalida",tarEnvioCorreoParam.getCorreoSalida());
									sentenciaStore.setString("Par_ConAutentificacion",tarEnvioCorreoParam.getConAutentificacion());
									sentenciaStore.setString("Par_Contrasenia",tarEnvioCorreoParam.getContrasenia());
									sentenciaStore.setString("Par_Estatus",tarEnvioCorreoParam.getEstatus());
									sentenciaStore.setString("Par_Comentario",tarEnvioCorreoParam.getComentario());
									sentenciaStore.setString("Par_AliasRemitente",tarEnvioCorreoParam.getAliasRemitente());
									sentenciaStore.setString("Par_TamanioMax",tarEnvioCorreoParam.getTamanioMax());
									sentenciaStore.setString("Par_Tipo",tarEnvioCorreoParam.getTipo());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNombreControl(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
						}else if(mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Remitentes de Correo: " + mensajeBean.getDescripcion());
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Alta de Remitentes de Correo", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	// Modificacion de correo

	public MensajeTransaccionBean modificacionCorreo(final TarEnvioCorreoParamBean tarEnvioCorreoParam) {
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

								String query = "call TARENVIOCORREOPARAMMOD( ?,?,?,?,?," +
																				"?,?,?,?,?," +
																				"?,?,?,?,?," +
																				"?,?,?,?,?," +
																				"?,?,?); " ;

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_RemitenteID",tarEnvioCorreoParam.getRemitenteID());
								sentenciaStore.setString("Par_Descripcion",tarEnvioCorreoParam.getDescripcion());
								sentenciaStore.setString("Par_ServidorSMTP",tarEnvioCorreoParam.getServidorSMTP());
								sentenciaStore.setString("Par_PuertoServerSMTP",tarEnvioCorreoParam.getPuertoServerSMTP());
								sentenciaStore.setString("Par_TipoSeguridad",tarEnvioCorreoParam.getTipoSeguridad());
								sentenciaStore.setString("Par_CorreoSalida",tarEnvioCorreoParam.getCorreoSalida());
								sentenciaStore.setString("Par_ConAutentificacion",tarEnvioCorreoParam.getConAutentificacion());
								sentenciaStore.setString("Par_Contrasenia",tarEnvioCorreoParam.getContrasenia());
								sentenciaStore.setString("Par_Estatus",tarEnvioCorreoParam.getEstatus());
								sentenciaStore.setString("Par_Comentario",tarEnvioCorreoParam.getComentario());
								sentenciaStore.setString("Par_AliasRemitente",tarEnvioCorreoParam.getAliasRemitente());
								sentenciaStore.setString("Par_TamanioMax",tarEnvioCorreoParam.getTamanioMax());
								sentenciaStore.setString("Par_Tipo",tarEnvioCorreoParam.getTipo());


								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
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
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNombreControl(resultadosStore.getString("NumErr"));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificacion de Remitentes de Correo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// consulta de correo
	public TarEnvioCorreoParamBean consultaCorreo(TarEnvioCorreoParamBean tarEnvioCorreoParam, int tipoConsulta) {
		//Query con el Store Procedure

		loggerSAFI.info("entrando a llamada");
		String query = "call TARENVIOCORREOPARAMCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { tarEnvioCorreoParam.getRemitenteID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARENVIOCORREOPARAMCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {


				TarEnvioCorreoParamBean tarEnvioCorreoParamBean = new TarEnvioCorreoParamBean();


				tarEnvioCorreoParamBean.setServidorSMTP(resultSet.getString("ServidorSMTP"));
				tarEnvioCorreoParamBean.setPuertoServerSMTP(resultSet.getString("PuertoServerSMTP"));
				tarEnvioCorreoParamBean.setTipoSeguridad(resultSet.getString("TipoSeguridad"));
				tarEnvioCorreoParamBean.setCorreoSalida(resultSet.getString("CorreoSalida"));
				tarEnvioCorreoParamBean.setConAutentificacion(resultSet.getString("ConAutentificacion"));
				tarEnvioCorreoParamBean.setContrasenia(resultSet.getString("contrasenia"));
				tarEnvioCorreoParamBean.setEstatus(resultSet.getString("Estatus"));
				tarEnvioCorreoParamBean.setComentario(resultSet.getString("Comentario"));
				tarEnvioCorreoParamBean.setAliasRemitente(resultSet.getString("AliasRemitente"));
				tarEnvioCorreoParamBean.setTamanioMax(resultSet.getString("TamanioMax"));
				tarEnvioCorreoParamBean.setTipo(resultSet.getString("Tipo"));
				tarEnvioCorreoParamBean.setDescripcion(resultSet.getString("Descripcion"));




				return tarEnvioCorreoParamBean;
			}
		});
		return matches.size() > 0 ? (TarEnvioCorreoParamBean) matches.get(0) : null;
	}
	// consulta de correo del usuario
	public TarEnvioCorreoParamBean consultaCorreoUsuario(TarEnvioCorreoParamBean tarEnvioCorreoParam, int tipoConsulta) {
		//Query con el Store Procedure

		loggerSAFI.info("entrando a llamada");
		String query = "call TARENVIOCORREOPARAMCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { tarEnvioCorreoParam.getRemitenteID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARENVIOCORREOPARAMCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {


				TarEnvioCorreoParamBean tarEnvioCorreoParamBean = new TarEnvioCorreoParamBean();

				tarEnvioCorreoParamBean.setDescripcion(resultSet.getString("Descripcion"));

				return tarEnvioCorreoParamBean;
			}
		});
		return matches.size() > 0 ? (TarEnvioCorreoParamBean) matches.get(0) : null;
	}


	// consulta de correo de usuario activo
		public TarEnvioCorreoParamBean consultaCorreoUsuarioAct(TarEnvioCorreoParamBean tarEnvioCorreoParam, int tipoConsulta) {
			//Query con el Store Procedure

			loggerSAFI.info("entrando a llamada");
			String query = "call TARENVIOCORREOPARAMCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = { tarEnvioCorreoParam.getRemitenteID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARENVIOCORREOPARAMCON(  " + Arrays.toString(parametros) + ")");
			@SuppressWarnings({ "unchecked", "rawtypes" })
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {


					TarEnvioCorreoParamBean tarEnvioCorreoParamBean = new TarEnvioCorreoParamBean();

					tarEnvioCorreoParamBean.setRemitenteID(resultSet.getString("RemitenteID"));
					tarEnvioCorreoParamBean.setDescripcion(resultSet.getString("Descripcion"));
					tarEnvioCorreoParamBean.setCorreoSalida(resultSet.getString("CorreoSalida"));

					return tarEnvioCorreoParamBean;
				}
			});
			return matches.size() > 0 ? (TarEnvioCorreoParamBean) matches.get(0) : null;
		}

	public List listaCorreo(TarEnvioCorreoParamBean tarEnvioCorreoParamBean, int tipoLista){
		String query = "CALL TARENVIOCORREOPARAMLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { tarEnvioCorreoParamBean.getDescripcion(),

				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARENVIOCORREOPARAMLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarEnvioCorreoParamBean tarEnvioCorreoParamBean = new TarEnvioCorreoParamBean();


				tarEnvioCorreoParamBean.setRemitenteID(resultSet.getString("RemitenteID"));
				tarEnvioCorreoParamBean.setDescripcion(resultSet.getString("Descripcion"));

				return tarEnvioCorreoParamBean;


			}
		});
		return matches;
	}


	public List listaCorreoGrid(TarEnvioCorreoParamBean tarEnvioCorreoParamBean, int tipoLista){
		String query = "CALL TARENVIOCORREOPARAMLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { Constantes.STRING_VACIO,

				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"tarEnvioCorreoParamDAO.listaCorreo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARENVIOCORREOPARAMLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarEnvioCorreoParamBean tarEnvioCorreoParamBean = new TarEnvioCorreoParamBean();


				tarEnvioCorreoParamBean.setRemitenteID(resultSet.getString("RemitenteID"));
				tarEnvioCorreoParamBean.setDescripcion(resultSet.getString("Descripcion"));
				tarEnvioCorreoParamBean.setServidorSMTP(resultSet.getString("ServidorSMTP"));
				tarEnvioCorreoParamBean.setTipoSeguridad(resultSet.getString("TipoSeguridad"));
				tarEnvioCorreoParamBean.setCorreoSalida(resultSet.getString("CorreoSalida"));
				tarEnvioCorreoParamBean.setEstatus(resultSet.getString("Estatus"));

				return tarEnvioCorreoParamBean;


			}
		});
		return matches;
	}
	//Lista correos de usuarios del SAFI
	public List listaUsuariosDestinatarios(TarEnvioCorreoParamBean tarEnvioCorreoParamBean, int tipoLista){
		String query = "CALL TARENVIOCORREOPARAMLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { Constantes.STRING_VACIO,

				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"tarEnvioCorreoParamDAO.listaCorreo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TARENVIOCORREOPARAMLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TarEnvioCorreoParamBean tarEnvioCorreoParamBean = new TarEnvioCorreoParamBean();

				tarEnvioCorreoParamBean.setRemitenteID(resultSet.getString("RemitenteID"));
				tarEnvioCorreoParamBean.setDescripcion(resultSet.getString("Descripcion"));

				return tarEnvioCorreoParamBean;


			}
		});
		return matches;
	}


	// Baja de correo

		public MensajeTransaccionBean bajaCorreo(final TarEnvioCorreoParamBean tarEnvioCorreoParam, final int numAct) {
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

									String query = "call TARENVIOCORREOPARAMACT(?,?,?,?,?," +
																				"?,?,?,?,?," +
																				"?,?,?)" ;

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_RemitenteID",tarEnvioCorreoParam.getRemitenteID());

									sentenciaStore.setString("Par_Estatus",tarEnvioCorreoParam.getEstatus());

									sentenciaStore.setInt("Par_NumAct",numAct);
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNombreControl(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Baja de Remitentes de Correo", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



	public ParametrosSesionBean getParametrosSesionBean() {
		return getParametrosSesionBean();
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


}
