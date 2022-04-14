package tarjetas.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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

import tarjetas.servicio.TarDebConciliaCorrespServicio;
import tarjetas.bean.TarDebConciliaCorrespBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class TarDebConciliaCorrespDAO extends BaseDAO {

	TarDebConciliaCorrespServicio	tarDebConciliaCorrepServ	= null;
	public TarDebConciliaCorrespDAO() {
		super();
	}

	// Metodo para grabar las operaciones de corresponsales
	public MensajeTransaccionBean grabaConcilia(final List listaParametros, final int tipoActualizacion) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					TarDebConciliaCorrespBean tarDebConcilia;

					if (listaParametros.size() > 0) {
						for (int i = 0; i < listaParametros.size(); i++) {
							tarDebConcilia = new TarDebConciliaCorrespBean();
							tarDebConcilia = (TarDebConciliaCorrespBean) listaParametros.get(i);

							mensajeBean = alta(tarDebConcilia, tipoActualizacion);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} else {
						mensajeBean.setDescripcion("Lista de Movimientos Vacía");
						throw new Exception(mensajeBean.getDescripcion());
					}

				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Proceso Batch de Corresponsales", e);
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

	// Método de alta para las operaciones de corresponsales
	public MensajeTransaccionBean alta(final TarDebConciliaCorrespBean tarDebConcilia, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call TRASPASOCTACONCPRO(" + "?,?,?,?,?,  ?,?,?,?,?," + "?,?,?,?,?,	?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_NumAutoriza", tarDebConcilia.getNumAutorizacion());
							sentenciaStore.setString("Par_ConciliaID", tarDebConcilia.getConciliaID());
							sentenciaStore.setString("Par_DetalleID", tarDebConcilia.getDetalleID());
							sentenciaStore.setString("Par_NumCuenta", tarDebConcilia.getNumCuenta());
							sentenciaStore.setString("Par_TipoTrans", tarDebConcilia.getTipoOperacion());

							sentenciaStore.setString("Par_Estatus_Con", tarDebConcilia.getEstatusConci());
							sentenciaStore.setString("Par_Monto", tarDebConcilia.getMonto());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							// Parametros de Auditoria
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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TarDebConciliaCorrespDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .TarDebConciliaCorrespDAO.alta");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Proceso Batch de Corresponsales" + e);
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

	public List listaConsultaMovs(TarDebConciliaCorrespBean tarDebCorresp, int tipoConsulta) {
		List listaConsulta = null;
		try {
			String query = "call CONCILIAMOVSCORRESCON(?,?,?,?,?,?,?,?);";

			Object[] parametros = {
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaConsultaMovs",
					Constantes.ENTERO_CERO, Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CONCILIAMOVSCORRESCON(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TarDebConciliaCorrespBean movimientosGridBean = new TarDebConciliaCorrespBean();

					// Datos de la tabla TARDEBCONCILIADETA
					movimientosGridBean.setNumAutorizacion(resultSet.getString("NumAutorizacion"));
					movimientosGridBean.setFechaProceso(resultSet.getString("FechaProcesoExt"));
					movimientosGridBean.setFechaConsumo(resultSet.getString("FechaConsumoExt"));
					movimientosGridBean.setConciliaID(resultSet.getString("ConciliaID"));
					movimientosGridBean.setDetalleID(resultSet.getString("DetalleID"));
					movimientosGridBean.setTipoOperacion(resultSet.getString("TipoTransaccion"));
					movimientosGridBean.setDescTipoOperacion(resultSet.getString("DescTransaccion"));
					movimientosGridBean.setNumCuenta(resultSet.getString("NumCuenta"));
					movimientosGridBean.setMonto(resultSet.getString("MontoOpera"));

					return movimientosGridBean;
				}
			});
			listaConsulta = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en lista de consulta de movimientos de corresponsales", e);
		}
		return listaConsulta;
	}

	public TarDebConciliaCorrespServicio getTarDebConciliaCorrepServ() {
		return tarDebConciliaCorrepServ;
	}

	public void setTarDebConciliaCorrepServ(TarDebConciliaCorrespServicio tarDebConciliaCorrepServ) {
		this.tarDebConciliaCorrepServ = tarDebConciliaCorrepServ;
	}

}
