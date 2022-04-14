package pld.dao;

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

import pld.bean.ParametrosAlertasBean;

public class ParametrosAlertasDAO extends BaseDAO {

	java.sql.Date	fecha	= null;

	public ParametrosAlertasDAO() {
		super();
	}

	private final static String	salidaPantalla	= "S";

	/**
	 * Alta de Parámetros de Alertas Automáticas
	 * @param parametrosAlertasBean {@link parametrosAlertasBean}
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean altaParametrosalertas(final ParametrosAlertasBean parametrosAlertasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDPARALOPINUSALT("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_TipoPersona", parametrosAlertasBean.getTipoPersona());
							sentenciaStore.setString("Par_NivelRiesgo", parametrosAlertasBean.getNivelRiesgo());
							sentenciaStore.setDate("Par_FechaVigencia", OperacionesFechas.conversionStrDate(parametrosAlertasBean.getFechaVigencia()));
							sentenciaStore.setString("Par_TipoInstruMonID", parametrosAlertasBean.getTipoInstruMonID());
							sentenciaStore.setDouble("Par_VarPTrans", Utileria.convierteDoble(parametrosAlertasBean.getVarPTrans()));

							sentenciaStore.setDouble("Par_VarPagos", Utileria.convierteDoble(parametrosAlertasBean.getVarPagos()));
							sentenciaStore.setInt("Par_VarPlazo", Utileria.convierteEntero(parametrosAlertasBean.getVarPlazo()));
							sentenciaStore.setString("Par_LiquidAnticipad", parametrosAlertasBean.getLiquidAnticipad());
							sentenciaStore.setString("Par_Estatus", parametrosAlertasBean.getEstatus());
							sentenciaStore.setDouble("Par_VarNumDep", Utileria.convierteDoble(parametrosAlertasBean.getVarNumDep()));

							sentenciaStore.setDouble("Par_VarNumRet", Utileria.convierteDoble(parametrosAlertasBean.getVarNumRet()));
							sentenciaStore.setDouble("Par_PorcAmoAnt", Utileria.convierteDoble(parametrosAlertasBean.getPorcAmoAnt()));
							sentenciaStore.setDouble("Par_PorcLiqAnt", Utileria.convierteDoble(parametrosAlertasBean.getPorcLiqAnt()));
							sentenciaStore.setDouble("Par_PorcDiasLiqAnt", Utileria.convierteDoble(parametrosAlertasBean.getPorcDiasLiqAnt()));
							sentenciaStore.setString("Par_Salida", salidaPantalla);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParametrosAlertasDAO.altaParametrosAlertas");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ParametrosAlertasDAO.altaParametrosAlertas");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de parametros de alerta", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Modificación de Parámetros de Alertas Automáticas
	 * @param parametrosAlertasBean
	 * @return
	 */
	public MensajeTransaccionBean modificaParametrosalertas(final ParametrosAlertasBean parametrosAlertasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDPARALOPINUSMOD("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_TipoPersona", parametrosAlertasBean.getTipoPersona());
							sentenciaStore.setString("Par_NivelRiesgo", parametrosAlertasBean.getNivelRiesgo());
							sentenciaStore.setInt("Par_FolioID", Utileria.convierteEntero(parametrosAlertasBean.getFolioID()));
							sentenciaStore.setDate("Par_FechaVigencia", OperacionesFechas.conversionStrDate(parametrosAlertasBean.getFechaVigencia()));
							sentenciaStore.setString("Par_TipoInstruMonID", parametrosAlertasBean.getTipoInstruMonID());

							sentenciaStore.setDouble("Par_VarPTrans", Utileria.convierteDoble(parametrosAlertasBean.getVarPTrans()));
							sentenciaStore.setDouble("Par_VarPagos", Utileria.convierteDoble(parametrosAlertasBean.getVarPagos()));
							sentenciaStore.setInt("Par_VarPlazo", Utileria.convierteEntero(parametrosAlertasBean.getVarPlazo()));
							sentenciaStore.setString("Par_LiquidAnticipad", parametrosAlertasBean.getLiquidAnticipad());
							sentenciaStore.setString("Par_Estatus", parametrosAlertasBean.getEstatus());

							sentenciaStore.setDouble("Par_VarNumDep", Utileria.convierteDoble(parametrosAlertasBean.getVarNumDep()));
							sentenciaStore.setDouble("Par_VarNumRet", Utileria.convierteDoble(parametrosAlertasBean.getVarNumRet()));
							sentenciaStore.setDouble("Par_PorcAmoAnt", Utileria.convierteDoble(parametrosAlertasBean.getPorcAmoAnt()));
							sentenciaStore.setDouble("Par_PorcLiqAnt", Utileria.convierteDoble(parametrosAlertasBean.getPorcLiqAnt()));
							sentenciaStore.setDouble("Par_PorcDiasLiqAnt", Utileria.convierteDoble(parametrosAlertasBean.getPorcDiasLiqAnt()));

							sentenciaStore.setString("Par_Salida", salidaPantalla);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ParametrosAlertasDAO.modificaParametrosAlertas");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ParametrosAlertasDAO.modificaParametrosAlertas");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion de parametros de alerta", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consulta de Parámetros de Alertas Automáticas
	 * @param parametrosAlertasBean
	 * @param tipoConsulta
	 * @return
	 */
	public ParametrosAlertasBean consultaPrincipal(final ParametrosAlertasBean parametrosAlertasBean, final int tipoConsulta) {
		ParametrosAlertasBean alertasBean = null;
		try {
			alertasBean = (ParametrosAlertasBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				//Query con el Store Procedure
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call PLDPARALOPINUSCON("
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?,		"
							+ "?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setString("Par_TipoPersona", parametrosAlertasBean.getTipoPersona());
					sentenciaStore.setString("Par_NivelRiesgo", parametrosAlertasBean.getNivelRiesgo());
					sentenciaStore.setInt("Par_FolioID", Utileria.convierteEntero(parametrosAlertasBean.getFolioID()));
					sentenciaStore.setInt("Par_NumCon", tipoConsulta);

					sentenciaStore.setInt("Aud_EmpresaID", Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setDate("Aud_FechaActual", fecha);
					sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID", "ParametrosAlertasDAO.consultaPrincipal");
					sentenciaStore.setInt("Aud_Sucursal", Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion", Constantes.ENTERO_CERO);

					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
					return sentenciaStore;
				}
			}, new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
					ParametrosAlertasBean alertas = new ParametrosAlertasBean();
					if (callableStatement.execute()) {
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						alertas.setFolioID(resultadosStore.getString("FolioID"));
						alertas.setFechaVigencia(resultadosStore.getString("FechaVigencia"));
						alertas.setTipoInstruMonID(resultadosStore.getString("TipoInstruMonID"));
						alertas.setVarPTrans(resultadosStore.getString("VarPTrans"));
						alertas.setVarPagos(resultadosStore.getString("VarPagos"));
						alertas.setVarPlazo(resultadosStore.getString("VarPlazo"));
						alertas.setLiquidAnticipad(resultadosStore.getString("LiquidAnticipad"));
						alertas.setEstatus(resultadosStore.getString("Estatus"));
						alertas.setVarNumDep(resultadosStore.getString("VarNumDep"));
						alertas.setVarNumRet(resultadosStore.getString("VarNumRet"));
						alertas.setTipoPersona(resultadosStore.getString("TipoPersona"));
						alertas.setNivelRiesgo(resultadosStore.getString("NivelRiesgo"));
						alertas.setPorcAmoAnt(resultadosStore.getString("PorcAmoAnt"));
						alertas.setPorcLiqAnt(resultadosStore.getString("PorcLiqAnt"));
						alertas.setPorcDiasLiqAnt(resultadosStore.getString("PorcDiasLiqAnt"));
					}
					return alertas;
				}
			});
			return alertasBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta principal de parametros de alerta", e);
			return null;
		}
	}

	/**
	 * Actualización de Parámetros de Alertas Automáticas
	 * @param parametrosAlertasBean
	 * @return
	 */
	public MensajeTransaccionBean actualizacion(final ParametrosAlertasBean parametrosAlertasBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query cons el Store Procedure
					String query = "call PLDPARALOPINUSACT(?,?,?,?,?,?,?,?);";
					Object[] parametros = {

					parametrosAlertasBean.getFolioID(),

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ParametrosAlertasDAO.actualizacion",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO

					};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDPARALOPINUSACT(" + Arrays.toString(parametros) + ")");
					List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));

							return mensaje;

						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en actualizar parametro de alerta", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Lista de Parámetros de Alertas Automáticas
	 * @param parametrosAlertasBean
	 * @param tipoLista
	 * @return
	 */
	public List listaAlfanumerica(ParametrosAlertasBean parametrosAlertasBean, int tipoLista) {
		String query = "call PLDPARALOPINUSLIS("
				+ "?,?,?,?,?,		"
				+ "?,?,?,?,?,		"
				+ "?);";
		Object[] parametros = {
				parametrosAlertasBean.getTipoPersona(),
				parametrosAlertasBean.getNivelRiesgo(),
				parametrosAlertasBean.getFolioID(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"parametrosAlertasDAO.listaAlfanumerica",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDPARALOPINUSLIS(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParametrosAlertasBean parametrosAlertasBean = new ParametrosAlertasBean();
				parametrosAlertasBean.setFolioID(resultSet.getString(1));
				parametrosAlertasBean.setFechaVigencia(resultSet.getString(2));
				return parametrosAlertasBean;
			}
		});
		return matches;
	}

	/**
	 * Consulta Parametros de Alerta con folio vigente
	 * @param parametrosAlertasBean
	 * @param tipoConsulta
	 * @return
	 */
	public ParametrosAlertasBean consultaFoliovigente(final ParametrosAlertasBean parametrosAlertasBean, final int tipoConsulta) {
		ParametrosAlertasBean alertasBean = null;
		try {
			alertasBean = (ParametrosAlertasBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
				//Query con el Store Procedure
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call PLDPARALOPINUSCON("
							+ "?,?,?,?,?,		"
							+ "?,?,?,?,?,		"
							+ "?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setString("Par_TipoPersona", parametrosAlertasBean.getTipoPersona());
					sentenciaStore.setString("Par_NivelRiesgo", parametrosAlertasBean.getNivelRiesgo());
					sentenciaStore.setInt("Par_FolioID", Utileria.convierteEntero(parametrosAlertasBean.getFolioID()));
					sentenciaStore.setInt("Par_NumCon", tipoConsulta);

					sentenciaStore.setInt("Aud_EmpresaID", Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setDate("Aud_FechaActual", fecha);
					sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID", "ConsultaGrupos");
					sentenciaStore.setInt("Aud_Sucursal", Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion", Constantes.ENTERO_CERO);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
					return sentenciaStore;
				}
			}, new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
					ParametrosAlertasBean alertas = new ParametrosAlertasBean();
					if (callableStatement.execute()) {
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						alertas.setFolioID(resultadosStore.getString("FolioID"));
						alertas.setFechaVigencia(resultadosStore.getString("FechaVigencia"));
						alertas.setTipoInstruMonID(resultadosStore.getString("TipoInstruMonID"));
						alertas.setVarPTrans(resultadosStore.getString("VarPTrans"));
						alertas.setVarPagos(resultadosStore.getString("VarPagos"));
						alertas.setVarPlazo(resultadosStore.getString("VarPlazo"));
						alertas.setLiquidAnticipad(resultadosStore.getString("LiquidAnticipad"));
						alertas.setEstatus(resultadosStore.getString("Estatus"));
						alertas.setVarNumDep(resultadosStore.getString("VarNumDep"));
						alertas.setVarNumRet(resultadosStore.getString("VarNumRet"));
						alertas.setNivelRiesgo(resultadosStore.getString("NivelRiesgo"));
						alertas.setTipoPersona(resultadosStore.getString("TipoPersona"));
						alertas.setPorcAmoAnt(resultadosStore.getString("PorcAmoAnt"));
						alertas.setPorcLiqAnt(resultadosStore.getString("PorcLiqAnt"));
						alertas.setPorcDiasLiqAnt(resultadosStore.getString("PorcDiasLiqAnt"));
					}
					return alertas;
				}
			});
			return alertasBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta de Folio Vigente de parametros de alerta", e);
			return null;
		}
	}

}
