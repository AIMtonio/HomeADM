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

import tesoreria.bean.TasaImpuestoISRBean;

public class TasaImpuestoISRDAO extends BaseDAO {

	public TasaImpuestoISRDAO() {
		super();
	}

	public MensajeTransaccionBean actualizaTasaImpuestoISR(final TasaImpuestoISRBean tasaImpuestoISR) {
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
									String query = "call TASASIMPUESTOSACT("
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?,	"
											+ "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_TasaImpuestoID",Utileria.convierteEntero(tasaImpuestoISR.getTasaImpuestoID()));
									sentenciaStore.setString("Par_Nombre",tasaImpuestoISR.getNombre());
									sentenciaStore.setString("Par_Descripcion",tasaImpuestoISR.getDescripcion());
									sentenciaStore.setDouble("Par_Valor",Utileria.convierteDoble(tasaImpuestoISR.getValor()));
									sentenciaStore.setString("Par_Fecha",Utileria.convierteFecha(tasaImpuestoISR.getFechaValor()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASIMPUESTOSACT "+ sentenciaStore.toString());
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

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .TasaImpustoISRDAO.actualiza");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .TasaImpustoISRDAO.actualiza");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Actualización de Tasa ISR" + e);
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

	public TasaImpuestoISRBean consultaPrincipal(final TasaImpuestoISRBean tasaImpuestoISR, final int tipoConsulta){
		TasaImpuestoISRBean tasaBean =null;
		try {
			tasaBean = (TasaImpuestoISRBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						//Query con el Store Procedure
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call TASASIMPUESTOSCON("
									+ "?,?,?,?,?,	"
									+ "?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_TasaImpuestoID",Utileria.convierteEntero(tasaImpuestoISR.getTasaImpuestoID()));
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
							TasaImpuestoISRBean consultaBean = new TasaImpuestoISRBean();
							if(callableStatement.execute()){
								ResultSet resultSet = callableStatement.getResultSet();

								resultSet.next();
								consultaBean.setTasaImpuestoID(resultSet.getString("TasaImpuestoID"));
								consultaBean.setNombre(resultSet.getString("Nombre"));
								consultaBean.setDescripcion(resultSet.getString("Descripcion"));
								consultaBean.setValor(String.valueOf(resultSet.getString("Valor")));
								consultaBean.setFechaValor(String.valueOf(resultSet.getString("Fecha")));
								consultaBean.setTipoTasa(resultSet.getString("TipoTasa"));
							}
							return consultaBean;
						}
					});
			return tasaBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+" error en consulta tasas impuesto ISR: ", e);
			return null;
		}
	}

	public List<TasaImpuestoISRBean> listaTasaImpuestoISR(TasaImpuestoISRBean tasaImpuestoISR, int tipoLista){
		String query = "call TASASIMPUESTOSLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				tasaImpuestoISR.getNombre(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"TasasBaseDAO.listaTasaImpuestoISR",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASIMPUESTOSLIS(" + Arrays.toString(parametros).replace("[", "").replace("]", "") +");");
		List<TasaImpuestoISRBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TasaImpuestoISRBean tasaImpuestoISR = new TasaImpuestoISRBean();
				tasaImpuestoISR.setTasaImpuestoID(resultSet.getString("TasaImpuestoID"));
				tasaImpuestoISR.setNombre(resultSet.getString("Nombre"));
				tasaImpuestoISR.setValor(resultSet.getString("Valor"));
				return tasaImpuestoISR;
			}
		});
		return matches;
	}
}