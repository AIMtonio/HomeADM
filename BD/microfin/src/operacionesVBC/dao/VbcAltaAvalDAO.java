package operacionesVBC.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesVBC.beanWS.request.VbcAltaAvalRequest;
import operacionesVBC.beanWS.response.VbcAltaAvalResponse;

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

public class VbcAltaAvalDAO extends BaseDAO{

	public VbcAltaAvalDAO() {
		super();
	}

	// Alta de referencia
	public VbcAltaAvalResponse altaAvalWs(final VbcAltaAvalRequest requestBean ){
		VbcAltaAvalResponse altaReferenciaResponse = new VbcAltaAvalResponse();
		altaReferenciaResponse = (VbcAltaAvalResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						VbcAltaAvalResponse response = new VbcAltaAvalResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (VbcAltaAvalResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call AVALESWSPRO(" +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?,?,?,?, ?,?,?,?,?," +
													"?,?);";

											CallableStatement sentenciaStore = arg0.prepareCall(query);
											sentenciaStore.setLong("Par_AvalID",Utileria.convierteEntero(requestBean.getAvalID()));
											sentenciaStore.setString("Par_TipoPersona",requestBean.getTipoPersona().toUpperCase());
											sentenciaStore.setString("Par_PrimerNom",requestBean.getPrimerNombre().toUpperCase());
											sentenciaStore.setString("Par_SegundoNom",requestBean.getSegundoNombre().toUpperCase());
											sentenciaStore.setString("Par_TercerNom",requestBean.getTercerNombre().toUpperCase());

											sentenciaStore.setString("Par_ApellidoPat",requestBean.getApellidoPaterno().toUpperCase());
											sentenciaStore.setString("Par_ApellidoMat",requestBean.getApellidoMaterno().toUpperCase());
											sentenciaStore.setDate("Par_FechaNac",OperacionesFechas.conversionStrDate(requestBean.getFechaNac()));
											sentenciaStore.setString("Par_RFC",requestBean.getRfc().toUpperCase());
											sentenciaStore.setString("Par_Telefono",requestBean.getTelefono().toUpperCase());

											sentenciaStore.setString("Par_TelefonoCel",requestBean.getTelefonoCel().toUpperCase());
											sentenciaStore.setString("Par_Calle",requestBean.getCalle().toUpperCase());
											sentenciaStore.setString("Par_NumExterior",requestBean.getNumExterior().toUpperCase());
											sentenciaStore.setString("Par_NumInterior",requestBean.getNumInterior().toUpperCase());
											sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(requestBean.getMunicipioID()));

											sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(requestBean.getEstadoID()));
											sentenciaStore.setString("Par_CP",requestBean.getCp());
											sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(requestBean.getLocalidadID()));
											sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(requestBean.getColoniaID()));
											sentenciaStore.setString("Par_Sexo",requestBean.getSexo());

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
												VbcAltaAvalResponse responseBean = new VbcAltaAvalResponse();
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
									response = new VbcAltaAvalResponse();
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, en Alta de Aval.");
									throw new Exception(Constantes.MSG_ERROR + " .operacionesVBC.WS.AltaAval");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
									throw new Exception("Error, en Alta de Aval.");
								}
						} catch (Exception e) {
							// TODO: handle exception
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Aval " + e);
							e.printStackTrace();
							if (response.getCodigoRespuesta().equals(Constantes.STRING_CERO)) {
								response.setCodigoRespuesta("998");
								response.setMensajeRespuesta("Error, en Alta Aval.");
							}
							transaction.setRollbackOnly();
						}
						return response;
					}
		});
		return altaReferenciaResponse;
	}
}
