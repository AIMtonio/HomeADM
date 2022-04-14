package pld.dao;

import general.bean.MensajeTransaccionArchivoBean;
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

import pld.bean.ArchAdjuntosPLDBean;

public class ArchivosPLDDAO extends BaseDAO {

	public MensajeTransaccionArchivoBean alta(final ArchAdjuntosPLDBean archAdjuntosPLDBean) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDADJUNTOSALT(" + "?,?,?,?,?,	" + "?,?,?,?,?,	" + "?,?,?,?,?,	" + "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_AdjuntoID", Utileria.convierteEntero(archAdjuntosPLDBean.getAdjuntoID()));
							sentenciaStore.setInt("Par_TipoProceso", Utileria.convierteEntero(archAdjuntosPLDBean.getTipoProceso()));
							sentenciaStore.setLong("Par_OpeInusualID", Utileria.convierteLong(archAdjuntosPLDBean.getOpeInusualID()));
							sentenciaStore.setInt("Par_OpeInterPreoID", Utileria.convierteEntero(archAdjuntosPLDBean.getOpeInterPreoID()));
							sentenciaStore.setString("Par_Observacion", archAdjuntosPLDBean.getObservacion());
							sentenciaStore.setString("Par_Recurso", archAdjuntosPLDBean.getRecurso());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
							sentenciaStore.setInt("Aud_Sucursal", Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion", Constantes.ENTERO_CERO);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccion = new MensajeTransaccionArchivoBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ArchivosPLDDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionArchivoBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ArchivosPLDDAO.alta");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de Archivos Adjuntos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionArchivoBean baja(final ArchAdjuntosPLDBean archAdjuntosPLDBean) {
		MensajeTransaccionArchivoBean mensaje = new MensajeTransaccionArchivoBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionArchivoBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionArchivoBean mensajeBean = new MensajeTransaccionArchivoBean();
				try {
					//Query con el Store Procedure
					mensajeBean = (MensajeTransaccionArchivoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLDADJUNTOSBAJ(" + "?,?,?,?,?,	" + "?,?,?,?,?,	" + "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_AdjuntoID", Utileria.convierteEntero(archAdjuntosPLDBean.getAdjuntoID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Aud_EmpresaID", Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);

							sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
							sentenciaStore.setInt("Aud_Sucursal", Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion", Constantes.ENTERO_CERO);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionArchivoBean mensajeTransaccion = new MensajeTransaccionArchivoBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ArchivosPLDDAO.baja");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionArchivoBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .ArchivosPLDDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en baja de archivos PLD", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List<ArchAdjuntosPLDBean> lista(ArchAdjuntosPLDBean archAdjuntosPLDBean, int tipoLista) {
		List<ArchAdjuntosPLDBean> listaPrincipal = null;
		try {
			String query = "call PLDADJUNTOSLIS(" + "?,?,?,?,?,		" + "?,?,?,?,?,		" + "?);";
			Object[] parametros = {Utileria.convierteEntero(archAdjuntosPLDBean.getTipoProceso()), Utileria.convierteLong(archAdjuntosPLDBean.getOpeInusualID()), Utileria.convierteEntero(archAdjuntosPLDBean.getOpeInterPreoID()), tipoLista,

			parametrosAuditoriaBean.getEmpresaID(), parametrosAuditoriaBean.getUsuario(), parametrosAuditoriaBean.getFecha(), parametrosAuditoriaBean.getDireccionIP(), "ArchivosPLDDAO.lista", parametrosAuditoriaBean.getSucursal(), parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDADJUNTOSLIS(" + Arrays.toString(parametros) + ")");
			List<ArchAdjuntosPLDBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					ArchAdjuntosPLDBean bean = new ArchAdjuntosPLDBean();
					bean.setAdjuntoID(resultSet.getString("AdjuntoID"));
					bean.setTipoProceso(resultSet.getString("TipoProceso"));
					bean.setOpeInusualID(resultSet.getString("OpeInusualID"));
					bean.setOpeInterPreoID(resultSet.getString("OpeInterPreoID"));
					bean.setConsecutivo(resultSet.getString("Consecutivo"));
					bean.setObservacion(resultSet.getString("Observacion"));
					bean.setRecurso(resultSet.getString("Recurso"));
					bean.setFechaRegistro(resultSet.getString("FechaRegistro"));

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
