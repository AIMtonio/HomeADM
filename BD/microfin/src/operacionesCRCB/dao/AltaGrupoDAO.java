package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesCRCB.beanWS.request.AltaGrupoRequest;
import operacionesCRCB.beanWS.response.AltaGrupoResponse;

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

public class AltaGrupoDAO extends BaseDAO{

	public AltaGrupoDAO (){

	}

	public AltaGrupoResponse altaGrupoWS(final AltaGrupoRequest requestBean ){

		AltaGrupoResponse altaGrupoResponse = new AltaGrupoResponse();

		altaGrupoResponse = (AltaGrupoResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						AltaGrupoResponse response = new AltaGrupoResponse();
						transaccionDAO.generaNumeroTransaccion();
						try {
							response = (AltaGrupoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {

										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CRCBGRUPOSCREDITOWSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?);";

												CallableStatement sentenciaStore = arg0.prepareCall(query);

												sentenciaStore.setString("Par_NombreGrupo",requestBean.getNombreGrupo());
												sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(requestBean.getSucursalID()));
												sentenciaStore.setInt("Par_CicloActual",Utileria.convierteEntero(requestBean.getCicloActual()));

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
												AltaGrupoResponse responseBean = new AltaGrupoResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();

													responseBean.setGrupoID(resultadosStore.getString("grupoID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreCorto")));


												}else{
													responseBean.setGrupoID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");
													responseBean.setGrupoID(Constantes.STRING_CERO);

												}
												return responseBean;
												}
											}

									);


								if(response ==  null){
									response = new AltaGrupoResponse();
									response.setGrupoID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transacción Rechazada.");

									throw new Exception(Constantes.MSG_ERROR + " .operacionesCRCB.WS.crcbAltaGrupo");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									if(Integer.parseInt(response.getCodigoRespuesta())==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Grupo: " + response.getMensajeRespuesta());
									} else {
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
										throw new Exception("Transacción Rechazada.");
									}
								}

						} catch (Exception e) {
							// TODO: handle exception

							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Grupo " + e);
							e.printStackTrace();

							if( response.getCodigoRespuesta() == null){
								response.setCodigoRespuesta("0");
							}

							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setGrupoID("00");
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, Transacción Rechazada.");
							}
							response.setGrupoID("00");
							transaction.setRollbackOnly();

						}
						return response;
					}
		});

		return altaGrupoResponse;
	}
}
