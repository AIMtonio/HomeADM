package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesCRCB.beanWS.request.AltaCreditoRequest;
import operacionesCRCB.beanWS.response.AltaCreditoResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.PropiedadesSAFIBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class AltaCreditoDAO extends BaseDAO{

	public AltaCreditoDAO () {
		super();
	}


	public AltaCreditoResponse altaCreditoWS(final AltaCreditoRequest requestBean) {

		AltaCreditoResponse altaCreditoResponse = new AltaCreditoResponse();

		altaCreditoResponse = (AltaCreditoResponse) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				@SuppressWarnings("unchecked")
				public Object doInTransaction(TransactionStatus transaction) {

					AltaCreditoResponse response = new AltaCreditoResponse();

					transaccionDAO.generaNumeroTransaccion();

					try {

						response = (AltaCreditoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {

							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call CRCBCREDITOSWSPRO(" + "?,?,?,?,?,	" + "?,?,?,?,?,	" + "?,?,?,?,?,	" + "?,?,?,?,?,	" + "?,?,?,?,?,	" + "?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(requestBean.getClienteID()));
									sentenciaStore.setInt("Par_ProductoCreditoID", Utileria.convierteEntero(requestBean.getProductoCreditoID()));
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(requestBean.getMonto()));
									sentenciaStore.setDouble("Par_TasaFija", Utileria.convierteDoble(requestBean.getTasaFija()));
									sentenciaStore.setString("Par_Frecuencia", requestBean.getFrecuencia());

									sentenciaStore.setString("Par_DiaPago", requestBean.getDiaPago());
									sentenciaStore.setInt("Par_DiaMesPago", Utileria.convierteEntero(requestBean.getDiaMesPago()));
									sentenciaStore.setInt("Par_PlazoID", Utileria.convierteEntero(requestBean.getPlazoID()));
									sentenciaStore.setInt("Par_DestinoCreID", Utileria.convierteEntero(requestBean.getDestinoCredito()));
									sentenciaStore.setInt("Par_TipoIntegrante", Utileria.convierteEntero(requestBean.getTipoIntegrante()));

									sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(requestBean.getGrupoID()));
									sentenciaStore.setString("Par_TipoDispersion", requestBean.getTipoDispersion());
									sentenciaStore.setDouble("Par_MontoPorComAper", Utileria.convierteDoble(requestBean.getMontoPorComAper()));
									sentenciaStore.setInt("Par_PromotorID", Utileria.convierteEntero(requestBean.getPromotorID()));
									sentenciaStore.setString("Par_CuentaClabe", requestBean.getCuentaClabe());

									sentenciaStore.setString("Par_FechaIniPrimAmor", Utileria.convierteFecha(requestBean.getFechaIniPrimAmor()));
									sentenciaStore.setString("Par_TipoConsultaSIC", requestBean.getTipoConsultaSIC());
									sentenciaStore.setString("Par_FolioConsultaSIC", (requestBean.getFolioConsultaSIC()));
									sentenciaStore.setString("Par_ReferenciaPago", (requestBean.getReferenciaPago()));

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									// Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
								AltaCreditoResponse responseBean = new AltaCreditoResponse();
								if (callableStatement.execute()) {
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();

									responseBean.setCreditoID(resultadosStore.getString("creditoID"));
									responseBean.setCuentaAhoID(resultadosStore.getString("cuentaAhoID"));
									responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
									responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"), PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreCorto")));

								} else {
									responseBean.setCreditoID("00");
									responseBean.setCuentaAhoID("00");
									responseBean.setCodigoRespuesta("999");
									responseBean.setMensajeRespuesta("Error en la Base de Datos");
									responseBean.setCreditoID(Constantes.STRING_CERO);
									responseBean.setCuentaAhoID(Constantes.STRING_CERO);

								}
								return responseBean;
							}
						}

						);

						if (response == null) {
							response = new AltaCreditoResponse();
							response.setCreditoID("00");
							response.setCodigoRespuesta("998");
							response.setMensajeRespuesta("Error, Transacción Rechazada.");

							throw new Exception(Constantes.MSG_ERROR + " .operacionesCRCB.WS.crcbAltaCredito");
						} else if (Integer.parseInt(response.getCodigoRespuesta()) != 0) {
							if (Integer.parseInt(response.getCodigoRespuesta()) == 50) { // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Credito: " + response.getMensajeRespuesta());
							} else {
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error No. " + response.getCodigoRespuesta() + ", " + response.getMensajeRespuesta());
								throw new Exception("Transacción Rechazada.");
							}
						}

					} catch (Exception e) {
						// TODO: handle exception

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Credito " + e);
							e.printStackTrace();

						if (response.getCodigoRespuesta() == null) {
							response.setCodigoRespuesta("0");
						}

						if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
							response.setCreditoID("00");
							response.setCodigoRespuesta("998");
							response.setMensajeRespuesta("Error, Transacción Rechazada.");
						}
						response.setCreditoID("00");
						transaction.setRollbackOnly();

					}
					return response;
				}
			});

		return altaCreditoResponse;
	}
}
