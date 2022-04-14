package operacionesPDM.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_RetiroCtaRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_RetiroCtaResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SP_PDM_Ahorros_RetiroCtaDAO extends BaseDAO {

	public SP_PDM_Ahorros_RetiroCtaDAO(){
		super();
	}

	public SP_PDM_Ahorros_RetiroCtaResponse retiroCuentaWS(final SP_PDM_Ahorros_RetiroCtaRequest requestBean, final int tipoTransaccion) {
		SP_PDM_Ahorros_RetiroCtaResponse mensaje = new SP_PDM_Ahorros_RetiroCtaResponse();
		transaccionDAO.generaNumeroTransaccionWS();

		mensaje = (SP_PDM_Ahorros_RetiroCtaResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				SP_PDM_Ahorros_RetiroCtaResponse mensajeBean = new SP_PDM_Ahorros_RetiroCtaResponse();
				try{
					// Query con el Store Procedure
					mensajeBean = (SP_PDM_Ahorros_RetiroCtaResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call RETIROCTAPDMWSPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_Num_Socio",Utileria.convierteEntero(requestBean.getNum_Socio()));
								sentenciaStore.setLong("Par_Num_Cta",Utileria.convierteLong(requestBean.getNum_Cta()));
								sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(requestBean.getMonto()));
								sentenciaStore.setString("Par_Fecha_Mov",Utileria.convierteFecha(requestBean.getFecha_Mov()));
								sentenciaStore.setString("Par_Folio_Pda",requestBean.getFolio_Pda());

								sentenciaStore.setString("Par_Id_Usuario",requestBean.getId_Usuario());
								sentenciaStore.setString("Par_Clave",requestBean.getClave());
								sentenciaStore.setInt("Par_IdServ",Utileria.convierteEntero(requestBean.getIdServicio()));
								sentenciaStore.setString("Par_TipoOp",requestBean.getTipoOperacion());
								sentenciaStore.setString("Par_Referencia",requestBean.getReferencia());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","operacionesPDM.WS.retiroCuentaWS");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								SP_PDM_Ahorros_RetiroCtaResponse mensajeTransaccion = new SP_PDM_Ahorros_RetiroCtaResponse();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setCodigoResp(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setCodigoDesc(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setAutFecha(resultadosStore.getString("AutFecha"));
									mensajeTransaccion.setFolioAut(resultadosStore.getString("FolioAut"));
									mensajeTransaccion.setSaldoTot(resultadosStore.getString("SaldoTot"));
									mensajeTransaccion.setSaldoDisp(resultadosStore.getString("SaldoDisp"));

								}else{
									mensajeTransaccion.setCodigoResp(999);
									mensajeTransaccion.setCodigoDesc("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new SP_PDM_Ahorros_RetiroCtaResponse();
						mensajeBean.setCodigoResp(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getCodigoResp()!=0){
						throw new Exception(mensajeBean.getCodigoDesc());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Procesar el Retiro a Cuenta WS", e);
					if (mensajeBean.getCodigoResp() == 0) {
						mensajeBean.setCodigoResp(999);
					}
					mensajeBean.setCodigoDesc(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

}
