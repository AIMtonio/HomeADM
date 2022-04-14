package operacionesVBC.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesVBC.beanWS.request.VbcAltaSolicitudCreditoRequest;
import operacionesVBC.beanWS.response.VbcAltaSolicitudCreditoResponse;

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
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class VbcAltaSolicitudCreditoDAO extends BaseDAO{

	public VbcAltaSolicitudCreditoDAO() {
		super();
	}

	// Alta de referencia
	public VbcAltaSolicitudCreditoResponse procesoSolicitud(final VbcAltaSolicitudCreditoRequest requestBean ){
		VbcAltaSolicitudCreditoResponse altaReferenciaResponse = new VbcAltaSolicitudCreditoResponse();
		altaReferenciaResponse = (VbcAltaSolicitudCreditoResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAltaSolicitudCreditoResponse response = new VbcAltaSolicitudCreditoResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAltaSolicitudCreditoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call SOLICITUDCREDITOWSPRO(" +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getClienteID()));
											sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(requestBean.getSolicitudCreditoID()));
											sentenciaStore.setInt("Par_ProduCredID",Utileria.convierteEntero(requestBean.getProductoCreditoID()));
											sentenciaStore.setDate("Par_FechaReg",OperacionesFechas.conversionStrDate(requestBean.getFechaRegistro()));
											sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(requestBean.getInstitucionNominaID()));

											sentenciaStore.setString("Par_FolioCtrl",requestBean.getFolioCtrl());
											sentenciaStore.setDouble("Par_MontoSolic",Utileria.convierteDoble(requestBean.getMontoSolici()));
											sentenciaStore.setDouble("Par_TasaFija",Utileria.convierteDoble(requestBean.getTasaActiva()));
											sentenciaStore.setString("Par_FrecCapital",requestBean.getPeriodicidad());
											sentenciaStore.setInt("Par_PlazoID",Utileria.convierteEntero(requestBean.getPlazoID()));

											sentenciaStore.setInt("Par_NumOpe",Utileria.convierteEntero(requestBean.getOperacionID()));
											sentenciaStore.setString("Par_Usuario",requestBean.getUsuario());
											sentenciaStore.setString("Par_Clave",requestBean.getClave());
											sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
											sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

											sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
											sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
											//Parametros de Auditoria
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
												VbcAltaSolicitudCreditoResponse responseBean = new VbcAltaSolicitudCreditoResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();
													responseBean.setCodigoRespuesta(resultadosStore.getString("NumErr"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("ErrMen"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC")));
												}else{
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");
												}
												return responseBean;
												}
											}
									);
							if(response ==  null){
									response = new VbcAltaSolicitudCreditoResponse();
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, en Proceso de Referencia.");
									throw new Exception(Constantes.MSG_ERROR + " .operacionesVBC.WS.AltaSolicitudCredito");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Error, en Alta Solicitud de Credito");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Solicitud de credito " + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, en Alta Solicitud de Credito.");
							}
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaReferenciaResponse;
	}
}
