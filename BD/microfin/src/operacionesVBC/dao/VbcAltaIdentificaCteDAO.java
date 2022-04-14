package operacionesVBC.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesVBC.beanWS.request.VbcAltaIdentificaCteRequest;
import operacionesVBC.beanWS.response.VbcAltaIdentificaCteResponse;

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

public class VbcAltaIdentificaCteDAO extends BaseDAO{

	public VbcAltaIdentificaCteDAO(){
		super();
	}
	private final static String salidaPantalla = "S";

	public VbcAltaIdentificaCteResponse altaIdentificacionWS(final VbcAltaIdentificaCteRequest requestBean ){
		VbcAltaIdentificaCteResponse altaIdentificacionResponse = new VbcAltaIdentificaCteResponse();
		altaIdentificacionResponse = (VbcAltaIdentificaCteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAltaIdentificaCteResponse response = new VbcAltaIdentificaCteResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAltaIdentificaCteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call IDENTIFICACTEWSVBCALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?);";

												CallableStatement sentenciaStore = arg0.prepareCall(query);
									    		sentenciaStore.setString("Par_ClienteID",requestBean.getClienteID());
												sentenciaStore.setString("Par_IdentificaID",requestBean.getIdentificaID());
												sentenciaStore.setString("Par_TipoIdentiID",requestBean.getTipoIdentiID());
												sentenciaStore.setString("Par_NumIdentifica",requestBean.getNumIdentifica());
												sentenciaStore.setString("Par_FechaExpedicion",requestBean.getFecExIden());

												sentenciaStore.setString("Par_FechaVencimiento",requestBean.getFecVenIden());
												sentenciaStore.setString("Par_Usuario",requestBean.getUsuario());
												sentenciaStore.setString("Par_Clave",requestBean.getClave());
												sentenciaStore.setString("Par_Salida",salidaPantalla);
												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
												//Parametros de Auditoria
												sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
												sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);

												sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
												sentenciaStore.setString("Aud_DireccionIP", "127.0.0.1");
												sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
												sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
												sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

												loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
												return sentenciaStore;
											}
										},new CallableStatementCallback() {
											public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
												VbcAltaIdentificaCteResponse responseBean = new VbcAltaIdentificaCteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();
													responseBean.setIdentificaID(resultadosStore.getString("identificaID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC")));
												}else{
													responseBean.setIdentificaID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");
													responseBean.setIdentificaID(Constantes.STRING_CERO);
												}
												return responseBean;
												}
											}
									);
							if(response ==  null){
									response = new VbcAltaIdentificaCteResponse();
									response.setIdentificaID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transaccion Rechazada.");

									throw new Exception(Constantes.MSG_ERROR + " .operacionesVBC.WS.altaIdentificacionWS");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Transaccion Rechazada.");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Identificacion del Cte " + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setIdentificaID("00");
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, Transaccion Rechazada.");
							}
							response.setIdentificaID("00");
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaIdentificacionResponse;
	}


	public VbcAltaIdentificaCteResponse modificaIdentificacionWS(final VbcAltaIdentificaCteRequest requestBean ){
		VbcAltaIdentificaCteResponse altaIdentificacionResponse = new VbcAltaIdentificaCteResponse();
		altaIdentificacionResponse = (VbcAltaIdentificaCteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAltaIdentificaCteResponse response = new VbcAltaIdentificaCteResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAltaIdentificaCteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call IDENTIFICACTEWSVBCMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);
									    		sentenciaStore.setString("Par_ClienteID",requestBean.getClienteID());
									    		sentenciaStore.setString("Par_IdentificaID",requestBean.getIdentificaID());
												sentenciaStore.setString("Par_TipoIdentiID",requestBean.getTipoIdentiID());
												sentenciaStore.setString("Par_NumIdentifica",requestBean.getNumIdentifica());
												sentenciaStore.setString("Par_FechaExpedicion",requestBean.getFecVenIden());

												sentenciaStore.setString("Par_FechaVencimiento",requestBean.getFecVenIden());
												sentenciaStore.setString("Par_Usuario",requestBean.getUsuario());
												sentenciaStore.setString("Par_Clave",requestBean.getClave());
												sentenciaStore.setString("Par_Salida",salidaPantalla);
												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
												//Parametros de Auditoria
												sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
												sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);

												sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
												sentenciaStore.setString("Aud_DireccionIP", "127.0.0.1");
												sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
												sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
												sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

												loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
												return sentenciaStore;
											}
										},new CallableStatementCallback() {
											public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
												VbcAltaIdentificaCteResponse responseBean = new VbcAltaIdentificaCteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();
													responseBean.setIdentificaID(resultadosStore.getString("identificaID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC")));
												}else{
													responseBean.setIdentificaID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");
													responseBean.setIdentificaID(Constantes.STRING_CERO);
												}
												return responseBean;
												}
											}
									);
							if(response ==  null){
									response = new VbcAltaIdentificaCteResponse();
									response.setIdentificaID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transaccion Rechazada.");

									throw new Exception(Constantes.MSG_ERROR + " .operacionesVBC.WS.modificacionIdentificacionWS");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Transaccion Rechazada.");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Identificacion del Cte " + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setIdentificaID("00");
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, Transaccion Rechazada.");
							}
							response.setIdentificaID("00");
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaIdentificacionResponse;
	}
}
