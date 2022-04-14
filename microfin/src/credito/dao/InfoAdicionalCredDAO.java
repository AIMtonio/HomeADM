package credito.dao;

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

import soporte.bean.ParamGeneralesBean;


import credito.bean.InfoAdicionalCredBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class InfoAdicionalCredDAO extends BaseDAO{
	public InfoAdicionalCredDAO(){
		super();
	}

	public MensajeTransaccionBean grabaListaRelaciones(final InfoAdicionalCredBean relacionBean, final List listaRelCred) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					InfoAdicionalCredBean relacionCred;
					mensajeBean = bajaRelacionCredito(relacionBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaRelCred.size(); i++){
						relacionCred = (InfoAdicionalCredBean)listaRelCred.get(i);
						mensajeBean = altaRelacionCredito(relacionCred);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Información Actualizada.");
					mensajeBean.setNombreControl("creditoID");
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Relaciones del Crédito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaRelacionCredito(final InfoAdicionalCredBean relacionBean) {
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
								String query = "call INFOADICIONALCREDALT(?,?,?,?,?," +
																		 "?,?,?,?,?," +
																		 "?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_CreditoID", relacionBean.getCreditoID());
								sentenciaStore.setString("Par_Placa", relacionBean.getPlaca());
								sentenciaStore.setString("Par_GNV", relacionBean.getGnv());
								sentenciaStore.setString("Par_Vin",relacionBean.getVin());
								sentenciaStore.setString("Par_EstatusWS",relacionBean.getEstatusWS());

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if(mensajeBean.getNumero()!=0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Relaciones del Crédito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean bajaRelacionCredito(final InfoAdicionalCredBean relacionCred) {
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
								String query = "call INFOADICIONALCREDBAJ(?,?,?,?,?," +
																		 "?,?,?,?,?," +
																		 "?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_CreditoID", relacionCred.getCreditoID());

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if(mensajeBean.getNumero()!=0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en dar de baja el Crédito", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List listaRelacionesCredito(InfoAdicionalCredBean relacionClienteBean, int tipoLista){
		String query = "call INFOADICIONALCREDLIS(?,?,?,?,?," +
												 "?,?,?,?);";
		Object[] parametros = {
				relacionClienteBean.getCreditoID(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InfoAdicionalCredDAO.listaRelacionesCredito",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INFOADICIONALCREDLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InfoAdicionalCredBean relacionCredito = new InfoAdicionalCredBean();
				relacionCredito.setPlaca(resultSet.getString(1));
				relacionCredito.setGnv(resultSet.getString(2));
				relacionCredito.setVin(resultSet.getString(3));
				relacionCredito.setEstatusWS(resultSet.getString(4));
				return relacionCredito;
			}
		});
		return matches;
	}

	public InfoAdicionalCredBean consultaRelacion(InfoAdicionalCredBean bean, int tipoConsulta) {
		String query = "call INFOADICIONALCREDCON(?,?,?,?,?," +
												 "?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(bean.getCreditoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InfoAdicionalCredDAO.consultaRelacionado",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INFOADICIONALCREDCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InfoAdicionalCredBean relacion = new InfoAdicionalCredBean();
				relacion.setCreditoID(resultSet.getString("CreditoID"));
				relacion.setNombreCom(resultSet.getString("NombreCom"));
				return relacion;
			}
		});
		return matches.size() > 0 ? (InfoAdicionalCredBean) matches.get(0) : null;
	}

	public InfoAdicionalCredBean consultaParamConexion(InfoAdicionalCredBean infoAdicionalCredBean,int tipoConsulta) {
			String query = "call INFOADICIONALCREDCON(?,?,?,?,?," +
					 								 "?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InfoAdicionalCredDAO.ParamConexion",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INFOADICIONALCREDCON(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					InfoAdicionalCredBean infoAdicionalCredBean = new InfoAdicionalCredBean();
					infoAdicionalCredBean.setUrlWSNG(resultSet.getString("UrlServerWS"));
					infoAdicionalCredBean.setUsuarioWSNG(resultSet.getString("UsuarioWS"));
					infoAdicionalCredBean.setPasswordWSNG(resultSet.getString("PasswordWS"));
					infoAdicionalCredBean.setTimeOutConWS(resultSet.getString("TimeOutConWS"));
					return infoAdicionalCredBean;
				}
			});
		return matches.size() > 0 ? (InfoAdicionalCredBean) matches.get(0) : null;
	}

	public InfoAdicionalCredBean consultaEndPoint(InfoAdicionalCredBean infoAdicionalCredBean,int tipoConsulta) {
		String query = "call INFOADICIONALCREDCON(?,?,?,?,?," +
				 								 "?,?,?,?);";
		Object[] parametros = {
			Constantes.ENTERO_CERO,
			tipoConsulta,

			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO,
			Constantes.FECHA_VACIA,
			Constantes.STRING_VACIO,
			"InfoAdicionalCredDAO.ParamConexion",
			Constantes.ENTERO_CERO,
			Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INFOADICIONALCREDCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InfoAdicionalCredBean infoAdicionalCredBean = new InfoAdicionalCredBean();
				infoAdicionalCredBean.setLlaveParametro(resultSet.getString("LlaveParametro"));
				infoAdicionalCredBean.setValorParametro(resultSet.getString("ValorParametro"));
				return infoAdicionalCredBean;
			}
		});
		return matches.size() > 0 ? (InfoAdicionalCredBean) matches.get(0) : null;
	}

	public List consultaDatos(InfoAdicionalCredBean bean, int tipoLista){
		String query = "call INFOADICIONALCREDLIS(?,?,?,?,?," +
												 "?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(bean.getCreditoID()),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"InfoAdicionalCredDAO.consultaDatos",

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INFOADICIONALCREDLIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InfoAdicionalCredBean datos = new InfoAdicionalCredBean();
				datos.setPlaca(resultSet.getString(1));
				datos.setCreditoID(resultSet.getString(2));
				datos.setRecaudo(resultSet.getDouble(3));
				datos.setPlazo(resultSet.getDouble(4));
				datos.setVin(resultSet.getString(5));
				return datos;
			}
		});
		return matches;
	}

	public MensajeTransaccionBean modificaEst(final String placa, final int credito, final double recaudo, final double plazo, final String vin, final int numMod) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call INFOADICIONALCREDMOD("
												+ "?,?,?,?,?,"
												+ "?,?,?,?,?,"
												+ "?,?,?,?,?,"
												+ "?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_Placa", placa);
								sentenciaStore.setInt("Par_CreditoID", credito);
								sentenciaStore.setDouble("Par_Recaudo", recaudo);
								sentenciaStore.setDouble("Par_Plazo", plazo);
								sentenciaStore.setString("Par_Vin", vin);
								sentenciaStore.setInt("Par_NumMod", numMod);

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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificar: " + mensajeBean.getDescripcion());
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Modificación de la Información Adicional", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
}