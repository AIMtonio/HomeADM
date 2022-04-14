package operacionesVBC.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesVBC.beanWS.request.VbcAltaReferenciaRequest;
import operacionesVBC.beanWS.response.VbcAltaReferenciaResponse;

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

public class VbcAltaReferenciaDAO extends BaseDAO{

	public VbcAltaReferenciaDAO() {
		super();
	}

	// Alta de referencia
	public VbcAltaReferenciaResponse procesoReferencia(final VbcAltaReferenciaRequest requestBean ){
		VbcAltaReferenciaResponse altaReferenciaResponse = new VbcAltaReferenciaResponse();
		altaReferenciaResponse = (VbcAltaReferenciaResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAltaReferenciaResponse response = new VbcAltaReferenciaResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAltaReferenciaResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call REFERENCIACLIENTEWSPRO(" +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setLong("Par_SolicitudCreditoID",Utileria.convierteLong(requestBean.getSolicitudCreditoID()));
											sentenciaStore.setString("Par_PrimerNombre",requestBean.getPrimerNombre().toUpperCase());
											sentenciaStore.setString("Par_SegundoNombre",requestBean.getSegundoNombre().toUpperCase());
											sentenciaStore.setString("Par_TercerNombre",requestBean.getTercerNombre().toUpperCase());
											sentenciaStore.setString("Par_ApellidoPaterno",requestBean.getApellidoPaterno().toUpperCase());

											sentenciaStore.setString("Par_ApellidoMaterno",requestBean.getApellidoMaterno().toUpperCase());
											sentenciaStore.setString("Par_Telefono",requestBean.getTelefono().toUpperCase());
											sentenciaStore.setString("Par_ExtTelefonoPart",requestBean.getExtTelefonoPart().toUpperCase());
											sentenciaStore.setInt("Par_TipoRelacionID",Utileria.convierteEntero(requestBean.getTipoRelacionID()));
											sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(requestBean.getEstadoID()));

											sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(requestBean.getMunicipioID()));
											sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(requestBean.getLocalidadID()));
											sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(requestBean.getColoniaID()));
											sentenciaStore.setString("Par_Calle",requestBean.getCalle().toUpperCase());
											sentenciaStore.setString("Par_NumeroCasa",requestBean.getNumeroCasa().toUpperCase());

											sentenciaStore.setString("Par_NumInterior",requestBean.getNumInterior().toUpperCase());
											sentenciaStore.setString("Par_Piso",requestBean.getPiso().toUpperCase());
											sentenciaStore.setString("Par_CP",requestBean.getCp().toUpperCase());
											sentenciaStore.setInt("Par_NumOpe",Utileria.convierteEntero(requestBean.getOperacionID()));
											sentenciaStore.setInt("Par_ReferenciaID",Utileria.convierteEntero(requestBean.getReferenciaID()));

											sentenciaStore.setInt("Par_Consecutivo",Utileria.convierteEntero(requestBean.getConsecutivo()));
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
												VbcAltaReferenciaResponse responseBean = new VbcAltaReferenciaResponse();
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
									response = new VbcAltaReferenciaResponse();
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, en Proceso de Referencia.");
									throw new Exception(Constantes.MSG_ERROR + " .operacionesVBC.WS.AltaReferencia");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Error, en Proceso de Referencia.");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Referencia " + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, en Proceso de Referencia.");
							}
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaReferenciaResponse;
	}
}
