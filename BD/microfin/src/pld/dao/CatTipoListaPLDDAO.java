package pld.dao;

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

import pld.bean.CatTipoListaPLDBean;
import pld.bean.PLDListaNegrasBean;
import pld.bean.PLDListasPersBloqBean;

public class CatTipoListaPLDDAO extends BaseDAO {

	/**
	 * Método para grabar el catalogo de listas de PLD
	 * @param catalogoListasPLDBean: Bean con los datos para grabar
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean grabar(final CatTipoListaPLDBean catalogoListasPLDBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CATTIPOLISTAPLDALT("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_TipoListaID", catalogoListasPLDBean.getTipoListaID());
									sentenciaStore.setString("Par_Descripcion", catalogoListasPLDBean.getDescripcion());
									sentenciaStore.setString("Par_Estatus", catalogoListasPLDBean.getEstatus());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatalogoListasPLDDAO.grabar");
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
						throw new Exception(Constantes.MSG_ERROR + " .CatalogoListasPLDDAO.grabar");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en grabar Catalogo de listas PLD", e);
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
	public MensajeTransaccionBean modifica(final CatTipoListaPLDBean catalogoListasPLDBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call CATTIPOLISTAPLDMOD("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_TipoListaID", catalogoListasPLDBean.getTipoListaID());
									sentenciaStore.setString("Par_Descripcion", catalogoListasPLDBean.getDescripcion());
									sentenciaStore.setString("Par_Estatus", catalogoListasPLDBean.getEstatus());
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatalogoListasPLDDAO.modifica");
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
						throw new Exception(Constantes.MSG_ERROR + " .CatalogoListasPLDDAO.modifica");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modificacion de Catalogo de listas PLD", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Consulta Principal
	 * @param catTipoListaPLDBean: Bean con los datos para realizar la consulta.
	 * @param tipoConsulta: Numero de Consulta (1 la Principal)
	 * @return CatTipoListaPLDBean
	 */
	public CatTipoListaPLDBean consultaPrincipal(CatTipoListaPLDBean catTipoListaPLDBean, int tipoConsulta) {

		CatTipoListaPLDBean bean = null;
		try {
			String query = "call CATTIPOLISTAPLDCON("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					catTipoListaPLDBean.getTipoListaID(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatTipoListaPLDDAO.lista",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CATTIPOLISTAPLDCON(" + Arrays.toString(parametros) + ")");
			List<CatTipoListaPLDBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CatTipoListaPLDBean bean = new CatTipoListaPLDBean();
					bean.setTipoListaID(resultSet.getString("TipoListaID"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					bean.setEstatus(resultSet.getString("Estatus"));
					return bean;
				}
			});
			bean = matches.size() > 0 ? (CatTipoListaPLDBean) matches.get(0) : null;

		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista principal de lista PLD", e);
		}
		return bean;
	}

	/**
	 * Método para traer la lista del catalago de listas de PLD
	 * @param catTipoListaPLDBean
	 * @param tipoLista
	 * @return
	 */
	public List<CatTipoListaPLDBean> lista(CatTipoListaPLDBean catTipoListaPLDBean, int tipoLista) {
		List<CatTipoListaPLDBean> listaPrincipal = null;
		try {
			String query = "call CATTIPOLISTAPLDLIS("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?);";
			Object[] parametros = {
					catTipoListaPLDBean.getDescripcion(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CatTipoListaPLDDAO.lista",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CATTIPOLISTAPLDLIS(" + Arrays.toString(parametros) + ")");
			List<CatTipoListaPLDBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					CatTipoListaPLDBean bean = new CatTipoListaPLDBean();
					bean.setTipoListaID(resultSet.getString("TipoListaID"));
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

}
