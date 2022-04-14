package contabilidad.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
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

import contabilidad.bean.CatIngresosEgresosBean;
import credito.bean.ProductosCreditoBean;


public class CatIngresosEgresosDAO extends BaseDAO {

	/**
	 * Método para grabar en el Catalogo Egresos
	 * @param catIngresosEgresosBean: Bean con los datos para grabar
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaCatEgresos(final CatIngresosEgresosBean catIngresosEgresosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CATTIPOEGRESOSALT("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Tipo", catIngresosEgresosBean.getTipo());
									sentenciaStore.setString("Par_Numero", catIngresosEgresosBean.getNumero());
									sentenciaStore.setString("Par_Descripcion", catIngresosEgresosBean.getDescripcion());
									sentenciaStore.setString("Par_Estatus", catIngresosEgresosBean.getEstatus());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "procesaCatalogoIngresos");
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.grabar");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.grabar");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en grabar Catalogo Egresos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para grabar el catalogo de Ingresos
	 * @param catIngresosEgresosBean: Bean con los datos para grabar
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaCatIngresos(final CatIngresosEgresosBean catIngresosEgresosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CATTIPOINGRESOSALT("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Tipo", catIngresosEgresosBean.getTipo());
									sentenciaStore.setString("Par_Numero", catIngresosEgresosBean.getNumero());
									sentenciaStore.setString("Par_Descripcion", catIngresosEgresosBean.getDescripcion());
									sentenciaStore.setString("Par_Estatus", catIngresosEgresosBean.getEstatus());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "procesaCatalogoIngresos");
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.grabar");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.grabar");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en grabar Catalogo Ingresos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para modificar el catalogo de listas de PLD
	 * @param catalogoListasPLDBean: Bean con los datos para grabar
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean modificaCatEgresos(final CatIngresosEgresosBean catIngresosEgresosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CATTIPOEGRESOSMOD("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Tipo", catIngresosEgresosBean.getTipo());
									sentenciaStore.setString("Par_Numero", catIngresosEgresosBean.getNumero());
									sentenciaStore.setString("Par_Descripcion", catIngresosEgresosBean.getDescripcion());
									sentenciaStore.setString("Par_Estatus", catIngresosEgresosBean.getEstatus());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID", "procesaEgresos");
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.modificaCatEgresos");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.modificaCatEgresos");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion de Egresos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/**
	 * Método para modificar el catalogo de listas de PLD
	 * @param catalogoListasPLDBean: Bean con los datos para grabar
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean modificaCatIngresos(final CatIngresosEgresosBean catIngresosEgresosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CATTIPOINGRESOSMOD("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Tipo", catIngresosEgresosBean.getTipo());
									sentenciaStore.setString("Par_Numero", catIngresosEgresosBean.getNumero());
									sentenciaStore.setString("Par_Descripcion", catIngresosEgresosBean.getDescripcion());
									sentenciaStore.setString("Par_Estatus", catIngresosEgresosBean.getEstatus());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID", "procesaListasPersBloq");
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
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.modificaCatIngresos");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.modificaCatIngresos");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion Ingresos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consulta Principal
	 * @param catIngresosEgresosBean: Bean con los datos para realizar la consulta.
	 * @param tipoConsulta: Numero de Consulta (1 la Principal)
	 * @return CatIngresosEgresosBean
	 */
	public CatIngresosEgresosBean consultaPrincipalEgresos(CatIngresosEgresosBean catIngresosEgresosBean, int tipoConsulta) {

		CatIngresosEgresosBean bean = null;
		try {
			String query = "call CATTIPOEGRESOSCON("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					catIngresosEgresosBean.getNumero(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatTipoListaPLDDAO.lista",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CATTIPOEGRESOSCON(" + Arrays.toString(parametros) + ")");
			List<CatIngresosEgresosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CatIngresosEgresosBean bean = new CatIngresosEgresosBean();
					bean.setNumero(resultSet.getString("Numero"));
					bean.setTipo(resultSet.getString("Tipo"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					bean.setEstatus(resultSet.getString("Estatus"));
					return bean;
				}
			});
			bean = matches.size() > 0 ? (CatIngresosEgresosBean) matches.get(0) : null;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta principal de egresos", e);
		}
		return bean;
	}

	/**
	 * Consulta Principal
	 * @param catIngresosEgresosBean: Bean con los datos para realizar la consulta.
	 * @param tipoConsulta: Numero de Consulta (1 la Principal)
	 * @return CatIngresosEgresosBean
	 */
	public CatIngresosEgresosBean consultaPrincipalIngresos(CatIngresosEgresosBean catIngresosEgresosBean, int tipoConsulta) {

		CatIngresosEgresosBean bean = null;
		try {
			String query = "call CATTIPOINGRESOSCON("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					catIngresosEgresosBean.getNumero(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatTipoListaPLDDAO.lista",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CATTIPOINGRESOSCON(" + Arrays.toString(parametros) + ")");
			List<CatIngresosEgresosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CatIngresosEgresosBean bean = new CatIngresosEgresosBean();
					bean.setNumero(resultSet.getString("Numero"));
					bean.setTipo(resultSet.getString("Tipo"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					bean.setEstatus(resultSet.getString("Estatus"));
					return bean;
				}
			});
			bean = matches.size() > 0 ? (CatIngresosEgresosBean) matches.get(0) : null;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta principal de ingresos", e);
		}
		return bean;
	}

	/**
	 * Método para traer la lista del catalago de listas de PLD
	 * @param catTipoListaPLDBean
	 * @param tipoLista
	 * @return
	 */
	public List<CatIngresosEgresosBean> listaEgresos(CatIngresosEgresosBean catIngresosEgresosBean, int tipoLista) {
		List<CatIngresosEgresosBean> listaPrincipal = null;
		try {
			String query = "call CATTIPOEGRESOSLIS("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					catIngresosEgresosBean.getDescripcion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatTipoListaPLDDAO.lista",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CATTIPOEGRESOSLIS(" + Arrays.toString(parametros) + ")");
			List<CatIngresosEgresosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CatIngresosEgresosBean bean = new CatIngresosEgresosBean();
					bean.setNumero(resultSet.getString("Numero"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					return bean;
				}
			});
			listaPrincipal = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista principal de lista PLD", e);
		}
		return listaPrincipal;
	}

	/**
	 * Método para traer la lista del catalago de listas de PLD
	 * @param catTipoListaPLDBean
	 * @param tipoLista
	 * @return
	 */
	public List<CatIngresosEgresosBean> listaIngresos(CatIngresosEgresosBean catIngresosEgresosBean, int tipoLista) {
		List<CatIngresosEgresosBean> listaPrincipal = null;
		try {
			String query = "call CATTIPOINGRESOSLIS("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					catIngresosEgresosBean.getDescripcion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatTipoListaPLDDAO.lista",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CATTIPOINGRESOSLIS(" + Arrays.toString(parametros) + ")");
			List<CatIngresosEgresosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CatIngresosEgresosBean bean = new CatIngresosEgresosBean();
					bean.setNumero(resultSet.getString("Numero"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					return bean;
				}
			});
			listaPrincipal = matches;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista principal de lista PLD", e);
		}
		return listaPrincipal;
	}

	public List listaIngresos(int tipoLista) {
		//Query con el Store Procedure
		String query = "call CATTIPOINGRESOSLIS(?,?,?,?,?,"
											+ "?,?,?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProductosCreditoDAO.listaProductos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOINGRESOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatIngresosEgresosBean productos = new CatIngresosEgresosBean();
				productos.setNumero(resultSet.getString(1));
				productos.setDescripcion(resultSet.getString(2));
				return productos;
			}
		});

		return matches;
	}

	public List listaEgresos(int tipoLista) {
		//Query con el Store Procedure
		String query = "call CATTIPOEGRESOSLIS(?,?,?,?,?,"
											+ "?,?,?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProductosCreditoDAO.listaProductos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATTIPOEGRESOSLIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatIngresosEgresosBean productos = new CatIngresosEgresosBean();
				productos.setNumero(resultSet.getString(1));
				productos.setDescripcion(resultSet.getString(2));
				return productos;
			}
		});

		return matches;
	}


}
