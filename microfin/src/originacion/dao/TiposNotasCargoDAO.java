package originacion.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.TiposNotasCargoBean;
import general.bean.MensajeTransaccionBean;

public class TiposNotasCargoDAO extends BaseDAO {

	public MensajeTransaccionBean altaTipoNotasCargo(final TiposNotasCargoBean tiposNotasCargoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL TIPOSNOTASCARGOALT (?,?,?,?,?,	?,?,?,?,?,	?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_NombreCorto", tiposNotasCargoBean.getNombreCorto());
									sentenciaStore.setString("Par_Descripcion", tiposNotasCargoBean.getDescripcion());
									sentenciaStore.setString("Par_CobraIVA", tiposNotasCargoBean.getCobraIVA());

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "TiposNotasCargoDAO.altaTipoNotasCargo");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " TiposNotasCargoDAO.altaTipoNotasCargo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " TiposNotasCargoDAO.altaTipoNotasCargo");
					} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+" Error al dar de alta el tipo de notas de cargo" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
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

	public MensajeTransaccionBean modificaTipoNotasCargo(final TiposNotasCargoBean tiposNotasCargoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL TIPOSNOTASCARGOMOD (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_TipNotCarID", Utileria.convierteEntero(tiposNotasCargoBean.getTipoNotaCargoID()));
									sentenciaStore.setString("Par_NombreCorto", tiposNotasCargoBean.getNombreCorto());
									sentenciaStore.setString("Par_Descripcion", tiposNotasCargoBean.getDescripcion());
									sentenciaStore.setString("Par_Estatus", tiposNotasCargoBean.getEstatus());
									sentenciaStore.setString("Par_CobraIVA", tiposNotasCargoBean.getCobraIVA());

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "TiposNotasCargoDAO.modificaTipoNotasCargo");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " TiposNotasCargoDAO.modificaTipoNotasCargo");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " TiposNotasCargoDAO.modificaTipoNotasCargo");
					} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+" Error al modificar el tipo de notas de cargo" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
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

	public TiposNotasCargoBean consultaPrincipal(TiposNotasCargoBean tiposNotasCargoBean, int tipoConsulta) {
		TiposNotasCargoBean registro = null;
		try {
			String query = "CALL TIPOSNOTASCARGOCON (?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					tiposNotasCargoBean.getTipoNotaCargoID(),

					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TiposNotasCargoDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL TIPOSNOTASCARGOCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposNotasCargoBean resultado = new TiposNotasCargoBean();
					resultado.setTipoNotaCargoID(resultSet.getString("TipoNotaCargoID"));
					resultado.setNombreCorto(resultSet.getString("NombreCorto"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setCobraIVA(resultSet.getString("CobraIVA"));
					return resultado;
				}
			});
			registro = matches.size() > 0 ? (TiposNotasCargoBean) matches.get(0) : null;
		} catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de tipo de notas de cargo", e);
		}
		return registro;
	}

	public List<?> listaAyuda(int tipoLista, TiposNotasCargoBean tiposNotasCargoBean) {
		List<?> lista= null;
		try {
			String query = "CALL TIPOSNOTASCARGOLIS (?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					tiposNotasCargoBean.getNombreCorto(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TiposNotasCargoDAO.listaAyuda",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL TIPOSNOTASCARGOLIS (" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposNotasCargoBean resultado = new TiposNotasCargoBean();
					resultado.setTipoNotaCargoID(resultSet.getString("TipoNotaCargoID"));
					resultado.setNombreCorto(resultSet.getString("NombreCorto"));

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de tipos de notas de cargo", e);
		}
		return lista;
	}

	public List<?> listaCombo(int tipoLista, TiposNotasCargoBean tiposNotasCargoBean) {
		List<?> lista= null;
		try {
			String query = "CALL TIPOSNOTASCARGOLIS (?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"TiposNotasCargoDAO.listaCombo",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL TIPOSNOTASCARGOLIS (" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposNotasCargoBean resultado = new TiposNotasCargoBean();
					resultado.setTipoNotaCargoID(resultSet.getString("TipoNotaCargoID"));
					resultado.setNombreCorto(resultSet.getString("NombreCorto"));

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de tipos de notas de cargo", e);
		}
		return lista;
	}
}
