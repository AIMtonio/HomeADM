package operacionesVBC.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesVBC.beanWS.request.VbcAltaDirecClienteRequest;
import operacionesVBC.beanWS.response.VbcAltaDirecClienteResponse;

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

public class VbcAltaDirecClienteDAO extends BaseDAO{

	public VbcAltaDirecClienteDAO(){
		super();
	}

	public VbcAltaDirecClienteResponse altaDireccionWS(final VbcAltaDirecClienteRequest requestBean ){
		VbcAltaDirecClienteResponse altaDireccionResponse = new VbcAltaDirecClienteResponse();
		altaDireccionResponse = (VbcAltaDirecClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAltaDirecClienteResponse response = new VbcAltaDirecClienteResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAltaDirecClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call DIRECCIONCTEWSVBCALT(" +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getClienteID()));
											sentenciaStore.setInt("Par_DireccionID",Utileria.convierteEntero(requestBean.getDireccionID()));
											sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(requestBean.getEstadoID()));
											sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(requestBean.getMunicipioID()));
											sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(requestBean.getLocalidadID()));

											sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(requestBean.getColoniaID()));
											sentenciaStore.setString("Par_Calle",requestBean.getCalle());
											sentenciaStore.setString("Par_NumeroCasa",requestBean.getNumeroCasa());
											sentenciaStore.setString("Par_CP",requestBean.getCp());
											sentenciaStore.setString("Par_Oficial",requestBean.getOficial());

											sentenciaStore.setString("Par_Fiscal",requestBean.getFiscal());
											sentenciaStore.setString("Par_NumInterior",requestBean.getNumInterior());
											sentenciaStore.setString("Par_Lote",requestBean.getLote());
											sentenciaStore.setString("Par_Manzana",requestBean.getManzana());
											sentenciaStore.setString("Par_Usuario",requestBean.getUsuario());

											sentenciaStore.setString("Par_Clave",requestBean.getClave());
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
											public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
												VbcAltaDirecClienteResponse responseBean = new VbcAltaDirecClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();
													responseBean.setDireccionID(resultadosStore.getString("direccionID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC")));
												}else{
													responseBean.setDireccionID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");
													responseBean.setDireccionID(Constantes.STRING_CERO);
												}
												return responseBean;
												}
											}
									);
								if(response ==  null){
									response = new VbcAltaDirecClienteResponse();
									response.setDireccionID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transaccion Rechazada.");
									throw new Exception(Constantes.MSG_ERROR + " .operacionesVBC.DAO.altaDireccionWS");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Transaccion Rechazada.");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Direccion de Cliente " + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setDireccionID("00");
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, Transaccion Rechazada.");
							}
							response.setDireccionID("00");
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaDireccionResponse;
	}


	public VbcAltaDirecClienteResponse modificaDireccionWS(final VbcAltaDirecClienteRequest requestBean ){
		VbcAltaDirecClienteResponse altaClienteResponse = new VbcAltaDirecClienteResponse();
		altaClienteResponse = (VbcAltaDirecClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAltaDirecClienteResponse response = new VbcAltaDirecClienteResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAltaDirecClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call DIRECCIONCTEWSVBCMOD(?,?,?,?,?,  ?,?,?,?,?," +
																					 "?,?,?,?,?,  ?,?,?,?,?," +
																					 "?,?,?,?,?,?);";
											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getClienteID()));
											sentenciaStore.setInt("Par_DireccionID",Utileria.convierteEntero(requestBean.getDireccionID()));
											sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(requestBean.getEstadoID()));
											sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(requestBean.getMunicipioID()));
											sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(requestBean.getLocalidadID()));

											sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(requestBean.getColoniaID()));
											sentenciaStore.setString("Par_Calle",requestBean.getCalle());
											sentenciaStore.setString("Par_NumeroCasa",requestBean.getNumeroCasa());
											sentenciaStore.setString("Par_CP",requestBean.getCp());
											sentenciaStore.setString("Par_Oficial",requestBean.getOficial());

											sentenciaStore.setString("Par_Fiscal",requestBean.getFiscal());
											sentenciaStore.setString("Par_NumInterior",requestBean.getNumInterior());
											sentenciaStore.setString("Par_Lote",requestBean.getLote());
											sentenciaStore.setString("Par_Manzana",requestBean.getManzana());
											sentenciaStore.setString("Par_Usuario",requestBean.getUsuario());

											sentenciaStore.setString("Par_Clave",requestBean.getClave());
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
											public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
												VbcAltaDirecClienteResponse responseBean = new VbcAltaDirecClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();
													responseBean.setDireccionID(resultadosStore.getString("direccionID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC")));
												}else{
													responseBean.setDireccionID("00");
													responseBean.setCodigoRespuesta("999");
													responseBean.setMensajeRespuesta("Error en la Base de Datos");
													responseBean.setDireccionID(Constantes.STRING_CERO);
												}
												return responseBean;
												}
											}
									);
								if(response ==  null){
									response = new VbcAltaDirecClienteResponse();
									response.setDireccionID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transaccion Rechazada.");
									throw new Exception(Constantes.MSG_ERROR + " .operacionesVBC.WS.modificaDireccionWS");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Transaccion Rechazada.");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificacion Direccion de Cliente WS" + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setDireccionID("00");
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, Transaccion Rechazada.");
							}
							response.setDireccionID("00");
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaClienteResponse;
	}

}