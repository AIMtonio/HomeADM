package operacionesPDM.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_OrdenPagoSpeiRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_OrdenPagoSpeiResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SP_PDM_Ahorros_OrdenPagoSpeiDAO extends BaseDAO{

	public SP_PDM_Ahorros_OrdenPagoSpeiDAO(){
		super();
	}

	public SP_PDM_Ahorros_OrdenPagoSpeiResponse altaOrdenPagoSpeiWS(final SP_PDM_Ahorros_OrdenPagoSpeiRequest ordenPagoBean) {
		SP_PDM_Ahorros_OrdenPagoSpeiResponse mensaje = new SP_PDM_Ahorros_OrdenPagoSpeiResponse();
		transaccionDAO.generaNumeroTransaccionWS();

		mensaje = (SP_PDM_Ahorros_OrdenPagoSpeiResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				SP_PDM_Ahorros_OrdenPagoSpeiResponse mensajeBean = new SP_PDM_Ahorros_OrdenPagoSpeiResponse();
				try{
					// Query con el Store Procedure
					mensajeBean = (SP_PDM_Ahorros_OrdenPagoSpeiResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SPEIENVIOSWSPRO(?,?,?,?,	?,?,?,?,?, ?,?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.registerOutParameter("Par_Folio", Types.CHAR);
								sentenciaStore.registerOutParameter("Par_ClaveRas", Types.VARCHAR);
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(ordenPagoBean.getClienteID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(ordenPagoBean.getCuentaID()));

								sentenciaStore.setDouble("Par_MontoTransferir",Utileria.convierteDoble(ordenPagoBean.getMonto()));
								sentenciaStore.setString("Par_ConceptoPago",ordenPagoBean.getConceptoPago());
								sentenciaStore.setInt("Par_InstiReceptora",Utileria.convierteEntero(ordenPagoBean.getIdInstitucion()));
								sentenciaStore.setInt("Par_TipoCuentaBen",Utileria.convierteEntero(ordenPagoBean.getTipoCuenta()));
								sentenciaStore.setString("Par_CuentaBeneficiario",ordenPagoBean.getCuentaBeneficiario());

								sentenciaStore.setString("Par_NombreBeneficiario",ordenPagoBean.getNombreBeneficiario());
								sentenciaStore.setInt("Par_ReferenciaNum",Utileria.convierteEntero(ordenPagoBean.getReferenciaNumerica()));
								sentenciaStore.setString("Par_RFCBeneficiario",ordenPagoBean.getRFCBeneficiario());
								sentenciaStore.setDouble("Par_IVAPorPagar",Utileria.convierteDoble(ordenPagoBean.getIvaXpagar()));
								sentenciaStore.setString("Par_UsuarioEnvio",ordenPagoBean.getUsuarioEnvio());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","OrdenPagoSpeiDAO.altaOrdenPagoSpeiWS");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());


								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								SP_PDM_Ahorros_OrdenPagoSpeiResponse mensajeTransaccion = new SP_PDM_Ahorros_OrdenPagoSpeiResponse();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setCodigoRespuesta(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setAutFecha(resultadosStore.getString("AutFecha"));
									mensajeTransaccion.setFolioAut(resultadosStore.getString("FolioAut"));
									mensajeTransaccion.setFolioSpei(resultadosStore.getString("FolioSpei"));
									mensajeTransaccion.setClaveRastreo(resultadosStore.getString("ClaveRastreo"));
									mensajeTransaccion.setFechaOperacion(resultadosStore.getString("FechaOperacion"));

								}else{
									mensajeTransaccion.setCodigoRespuesta(999);
									mensajeTransaccion.setMensajeRespuesta("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
						}
						);

					if(mensajeBean ==  null){
						mensajeBean = new SP_PDM_Ahorros_OrdenPagoSpeiResponse();
						mensajeBean.setCodigoRespuesta(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getCodigoRespuesta()!=0){
						throw new Exception(mensajeBean.getMensajeRespuesta());
					}
				} catch (Exception e) {
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Procesar Orden de Pago SPEI WS", e);
					if (mensajeBean.getCodigoRespuesta() == 0) {
						mensajeBean.setCodigoRespuesta(999);
					}
					mensajeBean.setMensajeRespuesta(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

}
