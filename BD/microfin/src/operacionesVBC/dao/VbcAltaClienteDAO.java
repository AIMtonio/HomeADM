package operacionesVBC.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesVBC.beanWS.request.VbcAltaClienteRequest;
import operacionesVBC.beanWS.response.VbcAltaClienteResponse;

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

public class VbcAltaClienteDAO extends BaseDAO{

	public VbcAltaClienteDAO(){
		super();
	}
	private final static String salidaPantalla = "S";

	public VbcAltaClienteResponse altaClienteWS(final VbcAltaClienteRequest requestBean ){
		VbcAltaClienteResponse altaClienteResponse = new VbcAltaClienteResponse();
		altaClienteResponse = (VbcAltaClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAltaClienteResponse response = new VbcAltaClienteResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAltaClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call CLIENTESWSVBCALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
							                        						+ "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,? );";
												CallableStatement sentenciaStore = arg0.prepareCall(query);
									    		sentenciaStore.setString("Par_PrimerNombre",requestBean.getPrimerNombre());
												sentenciaStore.setString("Par_SegundoNombre",requestBean.getSegundoNombre());
												sentenciaStore.setString("Par_TercerNombre",requestBean.getTercerNombre());
												sentenciaStore.setString("Par_ApPaterno",requestBean.getApPaterno());
												sentenciaStore.setString("Par_ApMaterno",requestBean.getApMaterno());

												sentenciaStore.setDate("Par_FechaNaci",OperacionesFechas.conversionStrDate(requestBean.getFechaNacimiento()));
												sentenciaStore.setString("Par_CURP",requestBean.getCurp());
												sentenciaStore.setInt("Par_Estado",Utileria.convierteEntero(requestBean.getEstadoID()));
												sentenciaStore.setString("Par_Sexo",requestBean.getSexo());
												sentenciaStore.setString("Par_Telefono",requestBean.getTelefono());

												sentenciaStore.setString("Par_Clasificacion",requestBean.getClasificacion());
												sentenciaStore.setString("Par_TelCelular",requestBean.getTelefonoCelular());
												sentenciaStore.setString("Par_Mail",requestBean.getCorreo());
												sentenciaStore.setString("Par_RFC",requestBean.getRfc());
												sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(requestBean.getOcupacionID()));

												sentenciaStore.setString("Par_LugarTrabajo",requestBean.getLugardeTrabajo());
												sentenciaStore.setString("Par_Puesto",requestBean.getPuesto());
												sentenciaStore.setString("Par_TelTrabajo",requestBean.getTelTrabajo());
												sentenciaStore.setString("Par_ExtTelTrabajo",requestBean.getExtTelefonoTrab());
												sentenciaStore.setInt("Par_NoEmpleado",Utileria.convierteEntero(requestBean.getNoEmpleado()));

												sentenciaStore.setDouble("Par_AntiguedadTra",Utileria.convierteDoble(requestBean.getAntiguedadTra()));
												sentenciaStore.setString("Par_TipoEmpleado",requestBean.getTipoEmpleado());
												sentenciaStore.setInt("Par_TipoPuesto",Utileria.convierteEntero(requestBean.getTipoPuesto()));
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
												VbcAltaClienteResponse responseBean = new VbcAltaClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();
													responseBean.setClienteID(resultadosStore.getString("clienteID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC")));
												}else{
													responseBean.setClienteID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");
													responseBean.setClienteID(Constantes.STRING_CERO);
												}
												return responseBean;
												}
											}
									);
								if(response ==  null){
									response = new VbcAltaClienteResponse();
									response.setClienteID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transaccion Rechazada.");
									throw new Exception(Constantes.MSG_ERROR + " .operacionesVBC.WS.solicitudCreditoWS");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Transacción Rechazada.");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente " + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setClienteID("00");
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, Transacción Rechazada.");
							}
							response.setClienteID("00");
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaClienteResponse;
	}


	public VbcAltaClienteResponse modificaClienteWS(final VbcAltaClienteRequest requestBean ){
		VbcAltaClienteResponse altaClienteResponse = new VbcAltaClienteResponse();
		altaClienteResponse = (VbcAltaClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAltaClienteResponse response = new VbcAltaClienteResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAltaClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call CLIENTESWSVBCMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
							                        						+ "?,?,?,?,?, ?,?,?,?,?,?, ?,?,?,?,? );";
												CallableStatement sentenciaStore = arg0.prepareCall(query);

												sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getClienteID()));
									    		sentenciaStore.setString("Par_PrimerNombre",requestBean.getPrimerNombre());
												sentenciaStore.setString("Par_SegundoNombre",requestBean.getSegundoNombre());
												sentenciaStore.setString("Par_TercerNombre",requestBean.getTercerNombre());
												sentenciaStore.setString("Par_ApPaterno",requestBean.getApPaterno());

												sentenciaStore.setString("Par_ApMaterno",requestBean.getApMaterno());
												sentenciaStore.setDate("Par_FechaNaci",OperacionesFechas.conversionStrDate(requestBean.getFechaNacimiento()));
												sentenciaStore.setString("Par_CURP",requestBean.getCurp());
												sentenciaStore.setInt("Par_Estado",Utileria.convierteEntero(requestBean.getEstadoID()));
												sentenciaStore.setString("Par_Sexo",requestBean.getSexo());

												sentenciaStore.setString("Par_Telefono",requestBean.getTelefono());
												sentenciaStore.setString("Par_Clasificacion",requestBean.getClasificacion());
												sentenciaStore.setString("Par_TelCelular",requestBean.getTelefonoCelular());
												sentenciaStore.setString("Par_Mail",requestBean.getCorreo());
												sentenciaStore.setString("Par_RFC",requestBean.getRfc());

												sentenciaStore.setInt("Par_OcupacionID",Utileria.convierteEntero(requestBean.getOcupacionID()));
												sentenciaStore.setString("Par_LugarTrabajo",requestBean.getLugardeTrabajo());
												sentenciaStore.setString("Par_Puesto",requestBean.getPuesto());
												sentenciaStore.setString("Par_TelTrabajo",requestBean.getTelTrabajo());
												sentenciaStore.setString("Par_ExtTelTrabajo",requestBean.getExtTelefonoTrab());

												sentenciaStore.setInt("Par_NoEmpleado",Utileria.convierteEntero(requestBean.getNoEmpleado()));
												sentenciaStore.setDouble("Par_AntiguedadTra",Utileria.convierteDoble(requestBean.getAntiguedadTra()));
												sentenciaStore.setString("Par_TipoEmpleado",requestBean.getTipoEmpleado());
												sentenciaStore.setInt("Par_TipoPuesto",Utileria.convierteEntero(requestBean.getTipoPuesto()));
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
												VbcAltaClienteResponse responseBean = new VbcAltaClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();
													responseBean.setClienteID(resultadosStore.getString("clienteID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC")));
												}else{
													responseBean.setClienteID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");
													responseBean.setClienteID(Constantes.STRING_CERO);
												}
												return responseBean;
												}
											}
									);
								if(response ==  null){
									response = new VbcAltaClienteResponse();
									response.setClienteID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transaccion Rechazada.");
									throw new Exception(Constantes.MSG_ERROR + " .operacionesPDA.WS.solicitudCreditoWS");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Transacción Rechazada.");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente " + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setClienteID("00");
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, Transacción Rechazada.");
							}
							response.setClienteID("00");
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaClienteResponse;
	}




}
