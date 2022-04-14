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

import pld.bean.NivelRiesgoClienteBean;
import tesoreria.bean.DivisasBean;

public class DivisasDAO extends BaseDAO {

	java.sql.Date	fecha	= null;

	public DivisasDAO() {
		super();
	}

	private final static String	salidaPantalla	= "S";
	/* Alta de Monedas */

	public MensajeTransaccionBean altaMoneda(final DivisasBean divisaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call MONEDASALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_Descripcion", divisaBean.getDescripcion());
							sentenciaStore.setString("Par_DescriCorta", divisaBean.getDescriCorta());
							sentenciaStore.setString("Par_Simbolo", divisaBean.getSimbolo());
							sentenciaStore.setDouble("Par_TipCamComVen", Utileria.convierteDoble(divisaBean.getTipCamComVen()));
							sentenciaStore.setDouble("Par_TipCamVenVen", Utileria.convierteDoble(divisaBean.getTipCamVenVen()));
							sentenciaStore.setDouble("Par_TipCamComInt", Utileria.convierteDoble(divisaBean.getTipCamComInt()));
							sentenciaStore.setDouble("Par_TipCamVenInt", Utileria.convierteDoble(divisaBean.getTipCamVenInt()));
							sentenciaStore.setString("Par_TipoMoneda", (divisaBean.getTipoMoneda()));
							sentenciaStore.setDouble("Par_TipCamFixCom", Utileria.convierteDoble(divisaBean.getTipCamFixCom()));
							sentenciaStore.setDouble("Par_TipCamFixVen", Utileria.convierteDoble(divisaBean.getTipCamFixVen()));
							sentenciaStore.setDouble("Par_TipCamDof", Utileria.convierteDoble(divisaBean.getTipCamDof()));
							sentenciaStore.setString("Par_EqCNBVUIF", divisaBean.getEqCNBVUIF());
							sentenciaStore.setString("Par_EqBuroCre", divisaBean.getEqBuroCred());
							sentenciaStore.setString("Par_MonedaCNBV", divisaBean.getMonedaCNBV());

							sentenciaStore.setString("Par_Salida", salidaPantalla);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DivisasDAO.altaMoneda");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .DivisasDAO.altaMoneda");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de moneda", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public DivisasBean consultaExisteMoneda(DivisasBean divisaBean, int tipoConsulta) {
		String query = "call MONEDASCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {Utileria.convierteEntero(divisaBean.getMonedaId()), tipoConsulta,

		Constantes.ENTERO_CERO, Constantes.ENTERO_CERO, Constantes.FECHA_VACIA, Constantes.STRING_VACIO, "DivisasDAO.consultaExisteMoneda", Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call MONEDASCON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				DivisasBean divisasBean = new DivisasBean();

				divisasBean.setMonedaId(String.valueOf(resultSet.getInt("MonedaId")));
				divisasBean.setDescripcion(resultSet.getString("Descripcion"));
				divisasBean.setDescriCorta(resultSet.getString("DescriCorta"));
				divisasBean.setSimbolo(resultSet.getString("Simbolo"));
				divisasBean.setTipoMoneda(resultSet.getString("TipoMoneda"));
				divisasBean.setTipCamComVen(String.valueOf(resultSet.getString("TipCamComVen")));
				divisasBean.setTipCamVenVen(String.valueOf(resultSet.getString("TipCamVenVen")));
				divisasBean.setTipCamComInt(String.valueOf(resultSet.getString("TipCamComInt")));
				divisasBean.setTipCamVenInt(String.valueOf(resultSet.getString("TipCamVenInt")));
				divisasBean.setTipCamFixCom(String.valueOf(resultSet.getString("TipCamFixCom")));
				divisasBean.setTipCamFixVen(String.valueOf(resultSet.getString("TipCamFixVen")));
				divisasBean.setTipCamDof(String.valueOf(resultSet.getString("TipCamDof")));
				divisasBean.setEqCNBVUIF(resultSet.getString("EqCNBVUIF"));
				divisasBean.setEqBuroCred(resultSet.getString("EqBuroCred"));
				divisasBean.setMonedaCNBV(resultSet.getString("MonedaCNBV"));

				return divisasBean;
			}
		});
		return matches.size() > 0 ? (DivisasBean) matches.get(0) : null;
	}

	/* Modificación  de Monedas */

	public MensajeTransaccionBean ModificaMoneda(final DivisasBean divisaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call MONEDASMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_MonedaId", Utileria.convierteEntero(divisaBean.getMonedaId()));
							sentenciaStore.setInt("Par_EmpresaID", (parametrosAuditoriaBean.getEmpresaID()));
							sentenciaStore.setString("Par_Descripcion", divisaBean.getDescripcion());
							sentenciaStore.setString("Par_DescriCorta", divisaBean.getDescriCorta());
							sentenciaStore.setString("Par_Simbolo", divisaBean.getSimbolo());
							sentenciaStore.setDouble("Par_TipCamComVen", Utileria.convierteDoble(divisaBean.getTipCamComVen()));
							sentenciaStore.setDouble("Par_TipCamVenVen", Utileria.convierteDoble(divisaBean.getTipCamVenVen()));
							sentenciaStore.setDouble("Par_TipCamComInt", Utileria.convierteDoble(divisaBean.getTipCamComInt()));
							sentenciaStore.setDouble("Par_TipCamVenInt", Utileria.convierteDoble(divisaBean.getTipCamVenInt()));
							sentenciaStore.setString("Par_TipoMoneda", (divisaBean.getTipoMoneda()));
							sentenciaStore.setDouble("Par_TipCamFixCom", Utileria.convierteDoble(divisaBean.getTipCamFixCom()));
							sentenciaStore.setDouble("Par_TipCamFixVen", Utileria.convierteDoble(divisaBean.getTipCamFixVen()));
							sentenciaStore.setDouble("Par_TipCamDof", Utileria.convierteDoble(divisaBean.getTipCamDof()));
							sentenciaStore.setString("Par_EqCNBVUIF", divisaBean.getEqCNBVUIF());
							sentenciaStore.setString("Par_EqBuroCred", divisaBean.getEqBuroCred());
							sentenciaStore.setString("Par_MonedaCNBV", divisaBean.getMonedaCNBV());

							sentenciaStore.setString("Par_Salida", salidaPantalla);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DivisasDAO.ModificaMoneda");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .DivisasDAO.ModificaMoneda");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en modifica moneda", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List<DivisasBean> listaReporte(DivisasBean bean, int tipoReporte) {
		List<DivisasBean> ListaResultado = null;
		try {
			String query = "CALL MONEDASREP("
					+ "?,?,?,?,?,"
					+ "?,?,?,?,?,"
					+ "?);";
			Object[] parametros = {
					bean.getMonedaId(),
					bean.getFechaInicio(),
					bean.getFechaFinal(),
					tipoReporte,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"DivisasDAO.listaReporte",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "CALL MONEDASREP(" + Arrays.toString(parametros).replace("[", "").replace("]", "") + ");");
			List<DivisasBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DivisasBean bean = new DivisasBean();
					bean.setMonedaId(resultSet.getString("MonedaId"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					bean.setSimbolo(resultSet.getString("Simbolo"));
					bean.setTipCamComVen(resultSet.getString("TipCamComVen"));
					bean.setTipCamVenVen(resultSet.getString("TipCamVenVen"));
					bean.setTipCamComInt(resultSet.getString("TipCamComInt"));
					bean.setTipCamVenInt(resultSet.getString("TipCamVenInt"));
					bean.setTipoMoneda(resultSet.getString("TipoMoneda"));
					bean.setTipCamFixCom(resultSet.getString("TipCamFixCom"));
					bean.setTipCamFixVen(resultSet.getString("TipCamFixVen"));
					bean.setTipCamDof(resultSet.getString("TipCamDof"));
					bean.setEqCNBVUIF(resultSet.getString("EqCNBVUIF"));
					bean.setEqBuroCred(resultSet.getString("EqBuroCred"));
					bean.setFechaRegistro(resultSet.getString("FechaRegistro"));

					return bean;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en reporte Histórico de Divisas : ", e);
		}
		return ListaResultado;
	}

}
