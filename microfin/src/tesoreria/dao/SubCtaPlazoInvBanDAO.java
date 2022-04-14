package tesoreria.dao;

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

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import tesoreria.bean.SubCtaPlazoInvBanBean;

public class SubCtaPlazoInvBanDAO extends BaseDAO {
	private final static String salidaPantalla = "S";

	public SubCtaPlazoInvBanDAO() {
		super();
	}

	/**
	 * Método para dar de alta las subcuentas por plazo de el Modulo de Inversiones Bancarias para la Guia Contable
	 * @param subCtaMonedaInvBan
	 * @return
	 */
	public MensajeTransaccionBean alta(final SubCtaPlazoInvBanBean subCtaPlazoInvBanBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call SUBCTAPLAZOINVBANALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConceptoInvBanID", Utileria.convierteEntero(subCtaPlazoInvBanBean.getConceptoInvBanID()));
							sentenciaStore.setInt("Par_Plazo", Utileria.convierteEntero(subCtaPlazoInvBanBean.getPlazo()==null?"0":subCtaPlazoInvBanBean.getPlazo()));
							sentenciaStore.setString("Par_SubPlazoMenor", subCtaPlazoInvBanBean.getSubPlazoMenor());
							sentenciaStore.setString("Par_SubPlazoMayor", subCtaPlazoInvBanBean.getSubPlazoMayor());
							sentenciaStore.setString("Par_Salida", salidaPantalla);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

							sentenciaStore.setString("Aud_ProgramaID", "SubCtaMonedaInvBanDAO.alta");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SubCtaPlazoInvBanDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .SubCtaPlazoInvBanDAO.alta");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de SubCuenta de Plazo." + e);
					e.printStackTrace();
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

	/**
	 * Método para dar de alta las subcuentas por plazo de el Modulo de Inversiones Bancarias para la Guia Contable
	 * @param subCtaMonedaInvBan
	 * @return
	 */
	public MensajeTransaccionBean modifica(final SubCtaPlazoInvBanBean subCtaPlazoInvBanBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call SUBCTAPLAZOINVBANMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConceptoInvBanID", Utileria.convierteEntero(subCtaPlazoInvBanBean.getConceptoInvBanID()));
							sentenciaStore.setInt("Par_Plazo", Utileria.convierteEntero(subCtaPlazoInvBanBean.getPlazo()==null?"0":subCtaPlazoInvBanBean.getPlazo()));
							sentenciaStore.setString("Par_SubPlazoMenor", subCtaPlazoInvBanBean.getSubPlazoMenor());
							sentenciaStore.setString("Par_SubPlazoMayor", subCtaPlazoInvBanBean.getSubPlazoMayor());
							sentenciaStore.setString("Par_Salida", salidaPantalla);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

							sentenciaStore.setString("Aud_ProgramaID", "SubCtaMonedaInvBanDAO.alta");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SubCtaPlazoInvBanDAO.modifica");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .SubCtaPlazoInvBanDAO.modifica");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Modificación de Subcuenta de Plazo." + e);
					e.printStackTrace();
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

	/**
	 * Método para dar de baja las subcuentas por plazo de el Modulo de Inversiones Bancarias para la Guia Contable
	 * @param subCtaMonedaInvBan
	 * @return
	 */
	public MensajeTransaccionBean baja(final SubCtaPlazoInvBanBean subCtaPlazoInvBanBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call SUBCTAPLAZOINVBANBAJ("
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?, "
									+ "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ConceptoInvBanID", Utileria.convierteEntero(subCtaPlazoInvBanBean.getConceptoInvBanID()));
							sentenciaStore.setString("Par_Salida", salidaPantalla);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "SubCtaMonedaInvBanDAO.alta");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SubCtaPlazoInvBanDAO.baja");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .SubCtaPlazoInvBanDAO.baja");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Eliminación de Subcuenta de Plazos." + e);
					e.printStackTrace();
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

	public SubCtaPlazoInvBanBean consultaPrincipal(SubCtaPlazoInvBanBean subCtaPlazoInvBanBean, int tipoConsulta) {
		String query = "call SUBCTAPLAZOINVBANCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				subCtaPlazoInvBanBean.getConceptoInvBanID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SubCtaPlazoInvBanDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SUBCTAPLAZOINVBANCON" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SubCtaPlazoInvBanBean subCtaMonedaDiv = new SubCtaPlazoInvBanBean();
				subCtaMonedaDiv.setConceptoInvBanID(resultSet.getString("ConceptoInvBanID"));
				subCtaMonedaDiv.setPlazo(resultSet.getString("Plazo"));
				subCtaMonedaDiv.setSubPlazoMenor(resultSet.getString("SubPlazoMenor"));
				subCtaMonedaDiv.setSubPlazoMayor(resultSet.getString("SubPlazoMayor"));
				return subCtaMonedaDiv;
			}
		});
		return matches.size() > 0 ? (SubCtaPlazoInvBanBean) matches.get(0) : null;
	}

}
