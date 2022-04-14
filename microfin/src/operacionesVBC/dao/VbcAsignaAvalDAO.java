package operacionesVBC.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesVBC.beanWS.request.VbcAsignaAvalRequest;
import operacionesVBC.beanWS.response.VbcAsignaAvalResponse;

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

public class VbcAsignaAvalDAO extends BaseDAO{

	public VbcAsignaAvalDAO() {
		super();
	}

	// Alta de referencia
	public VbcAsignaAvalResponse procesoReferencia(final VbcAsignaAvalRequest requestBean ){
		VbcAsignaAvalResponse altaReferenciaResponse = new VbcAsignaAvalResponse();
		altaReferenciaResponse = (VbcAsignaAvalResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAsignaAvalResponse response = new VbcAsignaAvalResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAsignaAvalResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call AVALESPORSOLIWSALT(" +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?,?,?, ?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_SolCreditoID",Utileria.convierteEntero(requestBean.getSolicitudCreditoID()));
											sentenciaStore.setInt("Par_AvalID",Utileria.convierteEntero(requestBean.getAvalID()));
											sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getClienteID()));
											sentenciaStore.setDate("Par_FechaRegistro",OperacionesFechas.conversionStrDate(requestBean.getFechaRegistro()));
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
												VbcAsignaAvalResponse responseBean = new VbcAsignaAvalResponse();
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
									response = new VbcAsignaAvalResponse();
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, en Proceso de Referencia.");
									throw new Exception(Constantes.MSG_ERROR + " .operacionesVBC.WS.AsignaAval");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Error, en Asignacion de Avales.");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Asignacion de Avales " + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, en Asignacion de Avales.");
							}
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaReferenciaResponse;
	}
}
