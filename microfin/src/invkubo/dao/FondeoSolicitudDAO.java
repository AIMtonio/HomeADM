package invkubo.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import invkubo.bean.FondeoSolicitudBean;
import invkubo.bean.TiposFondeadoresBean;

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

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class FondeoSolicitudDAO extends BaseDAO{

	public FondeoSolicitudDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final FondeoSolicitudBean fondeoSolicitud) {
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

								String query = "call FONDEOSOLICITUDALT(?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteEntero(fondeoSolicitud.getSolicitudCreditoID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(fondeoSolicitud.getClienteID()));
								sentenciaStore.setInt("Par_CuentaAhoID",Utileria.convierteEntero(fondeoSolicitud.getCuentaID()));
								sentenciaStore.setString("Par_FechaRegistro",Utileria.convierteFecha(fondeoSolicitud.getFechaRegistro()));
								sentenciaStore.setDouble("Par_MontoFondeo",Utileria.convierteDoble(fondeoSolicitud.getMontoFondeo()));
								sentenciaStore.setDouble("Par_PorceFondeo",Utileria.convierteDoble(fondeoSolicitud.getPorcentajeFondeo()));
								sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(fondeoSolicitud.getMonedaID()));
								sentenciaStore.setDouble("Par_TasaActiva",Utileria.convierteDoble(fondeoSolicitud.getTasaActiva()));
								sentenciaStore.setDouble("Par_TasaPasiva",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Par_TipoFond",Utileria.convierteEntero(fondeoSolicitud.getTipoFondeadorID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								//Parametros de OutPut
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de solicitud de fondeo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


/*
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call FONDEOSOLICITUDALT(?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(fondeoSolicitud.getSolicitudCreditoID()),
							Utileria.convierteEntero(fondeoSolicitud.getClienteID()),
							Utileria.convierteEntero(fondeoSolicitud.getCuentaID()),
							Utileria.convierteFecha(fondeoSolicitud.getFechaRegistro()),
							fondeoSolicitud.getMontoFondeo(),
							fondeoSolicitud.getPorcentajeFondeo(),
							fondeoSolicitud.getMonedaID(),
							fondeoSolicitud.getTasaActiva(),
							Constantes.ENTERO_CERO,
							Utileria.convierteEntero(fondeoSolicitud.getTipoFondeadorID()),
							Constantes.salidaSI,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"FondeoSolicitudDAO.alta",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
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
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}*/

	 public MensajeTransaccionBean proceso(final FondeoSolicitudBean fondeoSolicitud) {
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

									String query = "call FONDEOSOLICITUDPRO(?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_SolicCredID",Utileria.convierteEntero(fondeoSolicitud.getSolicitudCreditoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(fondeoSolicitud.getClienteID()));
									sentenciaStore.setInt("Par_CuentaAhoID",Utileria.convierteEntero(fondeoSolicitud.getCuentaID()));
									sentenciaStore.setDouble("Par_MontoFondeo",Utileria.convierteDoble(fondeoSolicitud.getMontoFondeo()));
									sentenciaStore.setDouble("Par_TasaPasiva",Utileria.convierteDoble(fondeoSolicitud.getTasaPasiva()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									//Parametros de OutPut
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","CreditosDAO.PagoCredito");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en proceso de solicitud de fondeo", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}
        /* MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
         transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
                 public Object doInTransaction(TransactionStatus transaction) {
                         MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
                         try {
                                 String query = "call FONDEOSOLICITUDPRO(?,?,?,?,?, ?,?,?,?,?,?,?);";
                                 Object[] parametros = {
                                                 Utileria.convierteEntero(fondeoSolicitud.getSolicitudCreditoID()),
                                                 Utileria.convierteEntero(fondeoSolicitud.getClienteID()),
                                                 Utileria.convierteEntero(fondeoSolicitud.getCuentaID()),
                                                 Utileria.convierteDoble(fondeoSolicitud.getMontoFondeo()),
                                                 Utileria.convierteDoble(fondeoSolicitud.getTasaPasiva()),

                                                 parametrosAuditoriaBean.getEmpresaID(),
                                                 parametrosAuditoriaBean.getUsuario(),
                                                 parametrosAuditoriaBean.getFecha(),
                                                 parametrosAuditoriaBean.getDireccionIP(),
                                                 parametrosAuditoriaBean.getNombrePrograma(),
                                                 parametrosAuditoriaBean.getSucursal(),
                                                 parametrosAuditoriaBean.getNumeroTransaccion()
                                                 };
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
                         }
                         return mensajeBean;
                 }
         });
         return mensaje;
	 }*/

	public MensajeTransaccionBean cancelar(final FondeoSolicitudBean fondeoSolicitud) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call FONDEOSOLICITUDCAN(?,?,?,?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(fondeoSolicitud.getSolicitudCreditoID()),
							Utileria.convierteEntero(fondeoSolicitud.getClienteID()),
							Utileria.convierteEntero(fondeoSolicitud.getCuentaID()),
							Utileria.convierteDoble(fondeoSolicitud.getMontoFondeo()),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDEOSOLICITUDCAN(" + Arrays.toString(parametros) + ")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en cancelacion de solicitud de fondeo", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}




	/* Lista de Solicitudes de Fondeo en la pantalla de alta de credito kubo*/
	public List listaGridFondeadores(FondeoSolicitudBean fondeoSolicitudBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call FONDEOSOLICITUDLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				fondeoSolicitudBean.getSolicitudCreditoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDEOSOLICITUDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				FondeoSolicitudBean fondeoSolicitud = new FondeoSolicitudBean();
				fondeoSolicitud.setSolicitudCreditoID(String.valueOf(resultSet.getInt(1)));
				fondeoSolicitud.setConsecutivo(resultSet.getString(2));
				fondeoSolicitud.setClienteID(resultSet.getString(3));
				fondeoSolicitud.setFechaRegistro(resultSet.getString(4));
				fondeoSolicitud.setMontoFondeo(resultSet.getString(5));
				fondeoSolicitud.setPorcentajeFondeo(resultSet.getString(6));
				fondeoSolicitud.setTasaPasiva(resultSet.getString(7));
				fondeoSolicitud.setMontoTotal(resultSet.getString(8));  //Monto total
				fondeoSolicitud.setPorcentaje(resultSet.getString(9)); //Porcentaje de monto total
				fondeoSolicitud.setMargen(resultSet.getString(10)); // Margen .- Activo- Pasivo
				return fondeoSolicitud;
			}
		});

		return matches;
	}


	/* Lista de Solicitudes de Fondeo */
	public List listaGridInverKubo(FondeoSolicitudBean fondeoSolicitudBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call FONDEOSOLICITUDLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				fondeoSolicitudBean.getSolicitudCreditoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDEOSOLICITUDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				FondeoSolicitudBean fondeoSolicitud = new FondeoSolicitudBean();
				fondeoSolicitud.setFondeoKuboID(String.valueOf(resultSet.getInt(1)));
				fondeoSolicitud.setClienteID(resultSet.getString(2));
				fondeoSolicitud.setNombreCompleto(resultSet.getString(3));
				fondeoSolicitud.setMontoFondeo(resultSet.getString(4));
				fondeoSolicitud.setPorcentajeFondeo(resultSet.getString(5));
				fondeoSolicitud.setTasaPasiva(resultSet.getString(6));
				return fondeoSolicitud;
			}
		});

		return matches;
	}

	/* Lista de Solicitudes de Fondeo con Inversionistas de Alto Riesgo */
	public List listaInversionistasAltoRiesgo(FondeoSolicitudBean fondeoSolicitudBean, int tipoLista) {
		// Query con el Store Procedure

		String query = "call FONDEOSOLICITUDLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				fondeoSolicitudBean.getSolicitudCreditoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDEOSOLICITUDLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				FondeoSolicitudBean fondeoSolicitud = new FondeoSolicitudBean();
				fondeoSolicitud.setSolFondeoID(String.valueOf(resultSet.getInt(1)));
				fondeoSolicitud.setClienteID(String.valueOf(resultSet.getInt(2)));
				fondeoSolicitud.setNombreCompleto(resultSet.getString(3));
				fondeoSolicitud.setRfcCliente(resultSet.getString(4));
				fondeoSolicitud.setFechaRegistro(resultSet.getString(5));
				fondeoSolicitud.setMontoFondeo(resultSet.getString(6));
				fondeoSolicitud.setPorcentajeFondeo(resultSet.getString(7));
				fondeoSolicitud.setNivelRiesgoCliente(resultSet.getString(8));
				return fondeoSolicitud;
			}
		});

		return matches;
	}


}
