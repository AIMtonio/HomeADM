package cuentas.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import cuentas.bean.ConocimientoCtaBean;
import cuentas.bean.CuentasAhoBean;

public class ConocimientoCtaDAO extends BaseDAO {

	public ConocimientoCtaDAO() {
		super();
	}
	private final static String salidaPantalla = "S";

	public MensajeTransaccionBean alta(final ConocimientoCtaBean conocimientoCta) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONOCIMIENTOCTAALT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(conocimientoCta.getCuentaAhoID()));
									sentenciaStore.setDouble("Par_DepositoCred",Utileria.convierteDoble(conocimientoCta.getDepositoCred()));
									sentenciaStore.setDouble("Par_RetirosCargo",Utileria.convierteDoble(conocimientoCta.getRetirosCargo()));
									sentenciaStore.setString("Par_ProcRecursos",conocimientoCta.getProcRecursos());
									sentenciaStore.setString("Par_ConcentFondo",conocimientoCta.getConcentFondo());

									sentenciaStore.setString("Par_AdmonGtosIng", conocimientoCta.getAdmonGtosIng());
									sentenciaStore.setString("Par_PagoNomina",conocimientoCta.getPagoNomina());
									sentenciaStore.setString("Par_CtaInversion", conocimientoCta.getCtaInversion());
									sentenciaStore.setString("Par_PagoCreditos",conocimientoCta.getPagoCreditos());
									sentenciaStore.setString("Par_OtroUso",conocimientoCta.getOtroUso());

									sentenciaStore.setString("Par_DefineUso", conocimientoCta.getDefineUso());
									sentenciaStore.setString("Par_RecursoProv",conocimientoCta.getRecursoProv());
									sentenciaStore.setString("Par_RecursoProvT",conocimientoCta.getRecursoProvT());
									sentenciaStore.setInt("Par_NumDep",Utileria.convierteEntero(conocimientoCta.getNumDepositos()));
									sentenciaStore.setInt("Par_FrecDep",Utileria.convierteEntero(conocimientoCta.getFrecDepositos()));

									sentenciaStore.setInt("Par_NumRet", Utileria.convierteEntero(conocimientoCta.getNumRetiros()));
									sentenciaStore.setInt("Par_FrecRet",Utileria.convierteEntero(conocimientoCta.getFrecRetiros()));
									sentenciaStore.setString("Par_MediosElectronicos",conocimientoCta.getMediosElectronicos());

									//PARAMETROS OUTPUT
								    sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","ConocimientoCtaDAO.alta");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									MensajeTransaccionBean mensajeBloqueo = null;

									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));


									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + "ConocimientoCtaDAO.alta");
									}
									return mensajeTransaccion;
								}
							});

					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de conocimiento de cuenta", e);
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

	public MensajeTransaccionBean altaWS(final ConocimientoCtaBean conocimientoCta) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get("microfin")).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call CONOCIMIENTOCTAALT(" +
												"?,?,?,?,?, ?,?,?,?,?," +
												"?,?,?,?,?, ?,?,?,?,?," +
												"?,?,?,?,?, ?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(conocimientoCta.getCuentaAhoID()));
										sentenciaStore.setDouble("Par_DepositoCred",Utileria.convierteDoble(conocimientoCta.getDepositoCred()));
										sentenciaStore.setDouble("Par_RetirosCargo",Utileria.convierteDoble(conocimientoCta.getRetirosCargo()));
										sentenciaStore.setString("Par_ProcRecursos",conocimientoCta.getProcRecursos());
										sentenciaStore.setString("Par_ConcentFondo",conocimientoCta.getConcentFondo());

										sentenciaStore.setString("Par_AdmonGtosIng", conocimientoCta.getAdmonGtosIng());
										sentenciaStore.setString("Par_PagoNomina",conocimientoCta.getPagoNomina());
										sentenciaStore.setString("Par_CtaInversion", conocimientoCta.getCtaInversion());
										sentenciaStore.setString("Par_PagoCreditos",conocimientoCta.getPagoCreditos());
										sentenciaStore.setString("Par_OtroUso",conocimientoCta.getOtroUso());

										sentenciaStore.setString("Par_DefineUso", conocimientoCta.getDefineUso());
										sentenciaStore.setString("Par_RecursoProv",conocimientoCta.getRecursoProv());
										sentenciaStore.setString("Par_RecursoProvT",conocimientoCta.getRecursoProvT());
										sentenciaStore.setInt("Par_NumDep",Utileria.convierteEntero(conocimientoCta.getNumDepositos()));
										sentenciaStore.setInt("Par_FrecDep",Utileria.convierteEntero(conocimientoCta.getFrecDepositos()));

										sentenciaStore.setInt("Par_NumRet", Utileria.convierteEntero(conocimientoCta.getNumRetiros()));
										sentenciaStore.setInt("Par_FrecRet",Utileria.convierteEntero(conocimientoCta.getFrecRetiros()));
										sentenciaStore.setString("Par_MediosElectronicos",conocimientoCta.getMediosElectronicos());

										//PARAMETROS OUTPUT
									    sentenciaStore.setString("Par_Salida",salidaPantalla);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										//Parametros de Auditoria
										sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

										sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
										sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
										sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
										sentenciaStore.setString("Aud_ProgramaID","ConocimientoCtaDAO.alta");
										sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());

										sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

										loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

										return sentenciaStore;
									}
								},new CallableStatementCallback() {
									public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
										MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
										MensajeTransaccionBean mensajeBloqueo = null;

										if(callableStatement.execute()){
											ResultSet resultadosStore = callableStatement.getResultSet();

											resultadosStore.next();

											mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
											mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
											mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
											mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));


										}else{
											mensajeTransaccion.setNumero(999);
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + "ConocimientoCtaDAO.altaWS");
										}
										return mensajeTransaccion;
									}
								});

						} catch (Exception e) {
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de conocimiento de cuenta", e);
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

	public MensajeTransaccionBean modifica(final ConocimientoCtaBean conocimientoCta) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CONOCIMIENTOCTAMOD(" +
											"?,?,?,?,?,      " +
											"?,?,?,?,?,      " +
											"?,?,?,?,?,      " +
											"?,?,?,?,?,      " +
											"?,?,?,?,?,      " +
											"?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(conocimientoCta.getCuentaAhoID()));
									sentenciaStore.setDouble("Par_DepositoCred", Utileria.convierteDoble(conocimientoCta.getDepositoCred()));
									sentenciaStore.setDouble("Par_RetirosCargo", Utileria.convierteDoble(conocimientoCta.getRetirosCargo()));
									sentenciaStore.setString("Par_ProcRecursos", conocimientoCta.getProcRecursos());
									sentenciaStore.setString("Par_ConcentFondo", conocimientoCta.getConcentFondo());

									sentenciaStore.setString("Par_AdmonGtosIng", conocimientoCta.getAdmonGtosIng());
									sentenciaStore.setString("Par_PagoNomina", conocimientoCta.getPagoNomina());
									sentenciaStore.setString("Par_CtaInversion", conocimientoCta.getCtaInversion());
									sentenciaStore.setString("Par_PagoCreditos", conocimientoCta.getPagoCreditos());
									sentenciaStore.setString("Par_OtroUso", conocimientoCta.getOtroUso());

									sentenciaStore.setString("Par_DefineUso", conocimientoCta.getDefineUso());
									sentenciaStore.setString("Par_RecursoProv", conocimientoCta.getRecursoProv());
									sentenciaStore.setString("Par_RecursoProvT", conocimientoCta.getRecursoProvT());
									sentenciaStore.setInt("Par_NumDep", Utileria.convierteEntero(conocimientoCta.getNumDepositos()));
									sentenciaStore.setInt("Par_FrecDep", Utileria.convierteEntero(conocimientoCta.getFrecDepositos()));

									sentenciaStore.setInt("Par_NumRet", Utileria.convierteEntero(conocimientoCta.getNumRetiros()));
									sentenciaStore.setInt("Par_FrecRet", Utileria.convierteEntero(conocimientoCta.getFrecRetiros()));
									sentenciaStore.setString("Par_MediosElectronicos", conocimientoCta.getMediosElectronicos());

									//PARAMETROS OUTPUT
									sentenciaStore.setString("Par_Salida", salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "ConocimientoCtaDAO.modifica");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									MensajeTransaccionBean mensajeBloqueo = null;

									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + "ConocimientoCtaDAO.modifica");
									}
									return mensajeTransaccion;
								}
							});

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion de conocimiento de cuenta", e);
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		}catch(Exception ex){
			ex.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error en Modificacion del Conocimiento de la Cuenta");
		}
		return mensaje;
	}

	public ConocimientoCtaBean consultaPrincipal(ConocimientoCtaBean conocimientoCta, int tipoConsulta) {
		try {
			String query = "call CONOCIMIENTOCTACON(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {
					conocimientoCta.getCuentaAhoID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ConocimientoCtaDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CONOCIMIENTOCTACON(" + Arrays.toString(parametros) + ");");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					try {
						ConocimientoCtaBean conocimientoCta = new ConocimientoCtaBean();
						conocimientoCta.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString("CuentaAhoID"), 11));
						conocimientoCta.setDepositoCred(resultSet.getString("DepositoCred"));
						conocimientoCta.setRetirosCargo(resultSet.getString("RetirosCargo"));
						conocimientoCta.setProcRecursos(resultSet.getString("ProcRecursos"));
						conocimientoCta.setConcentFondo(resultSet.getString("ConcentFondo"));

						conocimientoCta.setAdmonGtosIng(resultSet.getString("AdmonGtosIng"));
						conocimientoCta.setPagoNomina(resultSet.getString("PagoNomina"));
						conocimientoCta.setCtaInversion(resultSet.getString("CtaInversion"));
						conocimientoCta.setPagoCreditos(resultSet.getString("PagoCreditos"));
						conocimientoCta.setOtroUso(resultSet.getString("OtroUso"));

						conocimientoCta.setDefineUso(resultSet.getString("DefineUso"));
						conocimientoCta.setRecursoProv(resultSet.getString("RecursoProvProp"));
						conocimientoCta.setRecursoProvT(resultSet.getString("RecursoProvTer"));
						conocimientoCta.setNumDepositos(resultSet.getString("NumDepositos"));
						conocimientoCta.setFrecDepositos(resultSet.getString("FrecDepositos"));

						conocimientoCta.setNumRetiros(resultSet.getString("NumRetiros"));
						conocimientoCta.setFrecRetiros(resultSet.getString("FrecRetiros"));
						conocimientoCta.setMediosElectronicos(resultSet.getString("MediosElectronicos"));

						return conocimientoCta;
					} catch (Exception ex) {
						ex.printStackTrace();
					}
					return null;
				}
			});

			return matches.size() > 0 ? (ConocimientoCtaBean) matches.get(0) : null;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

	//consulta para saber si existe el conocimiento de la cuenta
		public ConocimientoCtaBean consultaExiste(ConocimientoCtaBean conocimientoCta, int tipoConsulta){
			ConocimientoCtaBean conocimientoCtaBean = null;
			try{
				String query = "call CONOCIMIENTOCTACON(?,? ,?,?,?,?,?,?,?);";
				Object[] parametros = {
						conocimientoCta.getCuentaAhoID(),
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ConocimientoCtaDAO.consultaPrincipal",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
					};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONOCIMIENTOCTACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ConocimientoCtaBean conocimientoCta = new ConocimientoCtaBean();
						conocimientoCta.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(1),CuentasAhoBean.LONGITUD_ID));
						return conocimientoCta;
					}
				});
				conocimientoCtaBean = matches.size() > 0 ? (ConocimientoCtaBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de conocimiento de cuenta", e);
			}
			return conocimientoCtaBean;
		}

}

