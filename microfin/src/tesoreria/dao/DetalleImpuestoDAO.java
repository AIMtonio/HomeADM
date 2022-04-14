package tesoreria.dao;

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

import tesoreria.bean.DetalleImpuestoBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class DetalleImpuestoDAO extends BaseDAO{

	public DetalleImpuestoDAO() {
		super();
	}

	// Alta de detalle de impuestos
	public MensajeTransaccionBean altaDetalleImpuesto(final DetalleImpuestoBean detalleimpuestoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					// Query con el Store Procedure
				mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call DETALLEIMPFACTALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?,?,"
																	+ "?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProveedorID",Utileria.convierteEntero(detalleimpuestoBean.getProveedorID()));
								sentenciaStore.setString("Par_NoFactura",detalleimpuestoBean.getNoFactura());
								sentenciaStore.setString("Par_NoPartidaID",detalleimpuestoBean.getNoPartidaID());
								sentenciaStore.setString("Par_PagoAnticipado",detalleimpuestoBean.getPagoAnticipado());
								sentenciaStore.setString("Par_TipoPagoAnt", detalleimpuestoBean.getTipoPagoAnt());
								sentenciaStore.setString("Par_FechaFactura",Utileria.convierteFecha(detalleimpuestoBean.getFechaFactura()));
								sentenciaStore.setInt("Par_CentroCostoID",Utileria.convierteEntero(detalleimpuestoBean.getCentroCostoID()));
								sentenciaStore.setInt("Par_CenCostoAntID",Utileria.convierteEntero(detalleimpuestoBean.getCenCostoAntID()));
								sentenciaStore.setInt("Par_CenCostoManualID",Utileria.convierteEntero(detalleimpuestoBean.getCenCostoManualID()));
								sentenciaStore.setInt("Par_EmpleadoID",Utileria.convierteEntero(detalleimpuestoBean.getNoEmpleadoID()));
								sentenciaStore.setString("Par_FolioUUID",detalleimpuestoBean.getFolioUUID());

								sentenciaStore.setInt("Par_ImpuestoID",Utileria.convierteEntero(detalleimpuestoBean.getImpuestoID()));
								sentenciaStore.setDouble("Par_ImporteImpuesto",Utileria.convierteDoble(detalleimpuestoBean.getImporteImpuesto()));
								sentenciaStore.setLong("Par_Poliza",Utileria.convierteLong(detalleimpuestoBean.getPoliza()));
								sentenciaStore.setString("Par_ProrrateaImp",detalleimpuestoBean.getProrrateaImp());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI );
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",Utileria.convierteLong(detalleimpuestoBean.getNumTransaccion()));
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de detalle de impuestos ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public List listaImporteImp(DetalleImpuestoBean detalleimpuestoBean, int tipoLista){

		String query = "call DETALLEIMPFACTLIS(?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
								detalleimpuestoBean.getNoFactura(),
								Utileria.convierteEntero(detalleimpuestoBean.getProveedorID()),
								Utileria.convierteEntero(detalleimpuestoBean.getNoPartidaID()),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"DetalleImpuestoDAO.lista",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEIMPFACTLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				DetalleImpuestoBean detalleimpuestoBean = new DetalleImpuestoBean();
				detalleimpuestoBean.setImpuestoID(resultSet.getString(1));
				detalleimpuestoBean.setImporteImpuesto(resultSet.getString(2));
				detalleimpuestoBean.setNoPartidaID(resultSet.getString(3));
				detalleimpuestoBean.setNoTotalImpuesto(resultSet.getString("NoTotalImpuesto"));
				detalleimpuestoBean.setConsecutivo(resultSet.getString("Consecutivo"));
				return detalleimpuestoBean;

			}
		});
		return matches;
	}


}
