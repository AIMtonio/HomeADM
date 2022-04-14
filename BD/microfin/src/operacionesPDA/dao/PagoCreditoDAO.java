package operacionesPDA.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import operacionesPDA.beanWS.request.PagoCreditoRequest;
import operacionesPDA.beanWS.response.PagoCreditoResponse;
import general.bean.ParametrosAuditoriaBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class PagoCreditoDAO extends BaseDAO{
	// PAGO DE CREDITO PARA SANA TUS FINANZAS
	public ParametrosSesionBean parametrosSesionBean;
	public ParametrosAuditoriaBean parametrosAuditoriaBean;

	public PagoCreditoDAO(){
		super();
	}

	public PagoCreditoResponse pagoCreditoWS(final PagoCreditoRequest requestBean){
		PagoCreditoResponse solicitaCred = new PagoCreditoResponse();
		transaccionDAO.generaNumeroTransaccion();
		solicitaCred = (PagoCreditoResponse)((TransactionTemplate)conexionOrigenDatosBean
				.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos()))
				.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				PagoCreditoResponse resultado = new PagoCreditoResponse();
				try {
					resultado = (PagoCreditoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call PAGOCREDWSPRO("
																		+ "?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(requestBean.getCreditoID()));
						    		sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(requestBean.getMonto()));
						    		sentenciaStore.setDouble("Par_MontoGL", Utileria.convierteDoble(requestBean.getMontoGL()));

									sentenciaStore.setString("Par_Folio",requestBean.getFolio());
									sentenciaStore.setString("Par_ClaveUsuario",requestBean.getClaveUsuario());
									sentenciaStore.setString("Par_Dispositivo",requestBean.getDispositivo());
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									PagoCreditoResponse respuestaBean = new PagoCreditoResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										respuestaBean.setCreditoID(resultadosStore.getString("creditoID"));
										respuestaBean.setNumTransaccion(resultadosStore.getString("numTransaccion"));
										respuestaBean.setSaldoExigible(resultadosStore.getString("saldoExigible"));
										respuestaBean.setSaldoTotalActual(resultadosStore.getString("saldoTotalActual"));
										respuestaBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
										respuestaBean.setMensajeRespuesta(resultadosStore.getString("mensajeRespuesta"));

									}else{
										respuestaBean.setCreditoID(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setSaldoExigible(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setSaldoTotalActual(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setCodigoRespuesta("999");
										respuestaBean.setMensajeRespuesta("Transacción Rechazada.");
									}
									return respuestaBean;
								}
							}
						);

						if(resultado ==  null){
							resultado = new PagoCreditoResponse();
							resultado.setCreditoID(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setSaldoExigible(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setSaldoTotalActual(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setCodigoRespuesta("999");
							resultado.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDWSPRO");
							throw new Exception(Constantes.MSG_ERROR + " .operacionesPDA.WS.pagoCreditoWS");

						} else if(Integer.parseInt(resultado.getCodigoRespuesta())!=0){
							transaction.setRollbackOnly();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No.: " + resultado.getCodigoRespuesta() + ", " +resultado.getMensajeRespuesta());
						}

					} catch (Exception e) {
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Pago de crédito con WS: ", e);
						resultado.setCreditoID(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setSaldoExigible(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setSaldoTotalActual(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setCodigoRespuesta("999");
						resultado.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
								+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDWSPRO");
					}
					return resultado;
		}});
		return solicitaCred;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
}
