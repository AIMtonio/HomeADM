package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;


import operacionesCRCB.beanWS.request.ActualizaClienteRequest;
import operacionesCRCB.beanWS.response.ActualizaClienteResponse;

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

public class ActualizaClienteDAO extends BaseDAO{

	public ActualizaClienteDAO (){
		super();
	}

	public ActualizaClienteResponse actualizaClienteWS(final int tipoActualizacion,final ActualizaClienteRequest requestBean ){

		ActualizaClienteResponse actualizaClienteResponse = new ActualizaClienteResponse();

		actualizaClienteResponse = (ActualizaClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					@SuppressWarnings("unchecked")
					public Object doInTransaction(TransactionStatus transaction){
						ActualizaClienteResponse response = new ActualizaClienteResponse();
						transaccionDAO.generaNumeroTransaccion();
						try {
							response = (ActualizaClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {

										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CRCBCLIENTESWSACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";

												CallableStatement sentenciaStore = arg0.prepareCall(query);

									    		sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getClienteID()));
									    		sentenciaStore.setString("Par_TelefonoCelular",requestBean.getTelefonoCelular());
									    		sentenciaStore.setString("Par_Telefono",requestBean.getTelefonoParticular());
									    		sentenciaStore.setString("Par_Correo",requestBean.getCorreoElectronico());
									    		sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

												sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

												//Parametros de Auditoria
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
												ActualizaClienteResponse responseBean = new ActualizaClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();

													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreCorto")));


												}else{
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");

												}

												return responseBean;

												}
											}

									);


								if(response ==  null){
									response = new ActualizaClienteResponse();
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transacción Rechazada.");

									throw new Exception(Constantes.MSG_ERROR + " .operacionesCRCB.WS.crcbActualizaCliente");

								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){

									if(Integer.parseInt(response.getCodigoRespuesta())==50){
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Actualizar Datos Cliente: " + response.getMensajeRespuesta());
									} else {
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
										throw new Exception("Transacción Rechazada.");
									}

								}

						} catch (Exception e) {
							// TODO: handle exception

							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Actualizar Datos Cliente " + e);
							e.printStackTrace();

							if( response.getCodigoRespuesta() == null){
								response.setCodigoRespuesta("0");
							}

							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, Transacción Rechazada.");
							}
							transaction.setRollbackOnly();

						}
						return response;
					}
		});

		return actualizaClienteResponse;
	}

	public ActualizaClienteResponse actualizaClienteWSReplica(final int tipoActualizacion,final ActualizaClienteRequest requestBean, final String origenReplica){

		ActualizaClienteResponse actualizaClienteResponse = new ActualizaClienteResponse();

		actualizaClienteResponse = (ActualizaClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenReplica)).execute(
				new TransactionCallback<Object>() {
					@SuppressWarnings({ "unchecked", "rawtypes" })
					public Object doInTransaction(TransactionStatus transaction){
						ActualizaClienteResponse response = new ActualizaClienteResponse();
						transaccionDAO.generaNumeroTransaccion();
						try {
							response = (ActualizaClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(origenReplica)).execute(
									new CallableStatementCreator() {

										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CRCBCLIENTESWSACT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";

												CallableStatement sentenciaStore = arg0.prepareCall(query);

									    		sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getClienteID()));
									    		sentenciaStore.setString("Par_TelefonoCelular",requestBean.getTelefonoCelular());
									    		sentenciaStore.setString("Par_Telefono",requestBean.getTelefonoParticular());
									    		sentenciaStore.setString("Par_Correo",requestBean.getCorreoElectronico());
									    		sentenciaStore.setInt("Par_NumAct",tipoActualizacion);

												sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

												//Parametros de Auditoria
												sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
												sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
												sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
												sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
												sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

												sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
												sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

												loggerSAFI.info(origenReplica+"-"+sentenciaStore.toString());
												return sentenciaStore;
											}
										},new CallableStatementCallback() {
											public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																							DataAccessException {
												ActualizaClienteResponse responseBean = new ActualizaClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();

													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreCorto")));


												}else{
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");

												}

												return responseBean;

												}
											}

									);


								if(response ==  null){
									response = new ActualizaClienteResponse();
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transacción Rechazada.");

									throw new Exception(Constantes.MSG_ERROR + " .operacionesCRCB.WS.crcbActualizaCliente");

								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){

									if(Integer.parseInt(response.getCodigoRespuesta())==50){
										loggerSAFI.error(origenReplica+"-"+"Error en Actualizar Datos Cliente: " + response.getMensajeRespuesta());
									} else {
										loggerSAFI.error(origenReplica+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
										throw new Exception("Transacción Rechazada.");
									}

								}

						} catch (Exception e) {
							// TODO: handle exception

							loggerSAFI.error(origenReplica+"-"+"Error en Actualizar Datos Cliente " + e);
							e.printStackTrace();

							if( response.getCodigoRespuesta() == null){
								response.setCodigoRespuesta("0");
							}

							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, Transacción Rechazada.");
							}
							transaction.setRollbackOnly();

						}
						return response;
					}
		});

		return actualizaClienteResponse;
	}
}
