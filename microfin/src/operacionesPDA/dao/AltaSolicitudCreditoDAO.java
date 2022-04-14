package operacionesPDA.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import operacionesPDA.beanWS.request.AltaSolicitudGrupalRequest;
import operacionesPDA.beanWS.request.AltaSolicitudCreditoRequest;
import operacionesPDA.beanWS.response.AltaSolicitudGrupalResponse;
import operacionesPDA.beanWS.response.AltaSolicitudCreditoResponse;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class AltaSolicitudCreditoDAO extends BaseDAO {
	// ALTA DE SOLICITUD DE CREDITO PARA SANA TUS FINANZAS
	ParametrosSesionBean parametrosSesionBean;
	String tipoCredito = "N";	// Tipo de Credito Nuevo
	int numCreditos = 1;		// Numero de Creditos : 1

	public AltaSolicitudCreditoDAO(){
		super();
	}

	// Alta de Solicitud de Crédito Individual
	public AltaSolicitudCreditoResponse altaSolicitudCreditoWS (final AltaSolicitudCreditoRequest requestBean){
		AltaSolicitudCreditoResponse solicitaCred = new AltaSolicitudCreditoResponse();
		solicitaCred = (AltaSolicitudCreditoResponse)((TransactionTemplate)conexionOrigenDatosBean
				.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos()))
				.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				AltaSolicitudCreditoResponse resultado = new AltaSolicitudCreditoResponse();
				try {
					resultado = (AltaSolicitudCreditoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call SOLICITUDCREDWSALT("
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
												                        + "?,?,?,?,?,"
												                        + "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ProspectoID", Utileria.convierteEntero(requestBean.getProspectoID()));
						    		sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getClienteID()));
						    		sentenciaStore.setInt("Par_ProduCredID", Utileria.convierteEntero(requestBean.getProductoCreditoID()));
									sentenciaStore.setDouble("Par_MontoSolic",Utileria.convierteDoble(requestBean.getMontoSolici()));
									sentenciaStore.setString("Par_Periodicidad",requestBean.getPeriodicidad());

									sentenciaStore.setString("Par_PlazoID",requestBean.getPlazo());
									sentenciaStore.setInt("Par_DestinoCredID",Utileria.convierteEntero(requestBean.getDestinoCredito()));
									sentenciaStore.setString("Par_Proyecto",requestBean.getProyecto());
									sentenciaStore.setString("Par_TipoDispersion",requestBean.getTipoDispersion());
									sentenciaStore.setString("Par_CuentaCLABE",requestBean.getCuentaCLABE());

									sentenciaStore.setString("Par_TipoPagoCapital",requestBean.getTipoPagoCapital());
									sentenciaStore.setString("Par_TipoCredito", requestBean.getTipoCredito());
									sentenciaStore.setInt("Par_NumCreditos", Utileria.convierteEntero(requestBean.getNumeroCredito()==null?"0":requestBean.getNumeroCredito()));
									sentenciaStore.setInt("Par_GrupoID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_TipoIntegrante", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_Folio_Pda",requestBean.getFolio());
									sentenciaStore.setString("Par_ClaveUsuario",requestBean.getClaveUsuario());
									sentenciaStore.setString("Par_Dispositivo",requestBean.getDispositivo());
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									AltaSolicitudCreditoResponse respuestaBean = new AltaSolicitudCreditoResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										respuestaBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
										respuestaBean.setMensajeRespuesta(resultadosStore.getString("mensajeRespuesta"));
										respuestaBean.setSolicitudCreditoID(resultadosStore.getString("solicitudCreditoID"));

									}else{
										respuestaBean.setCodigoRespuesta(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setMensajeRespuesta("Transacción Rechazada.");
										respuestaBean.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
									}
									return respuestaBean;
								}
							}
						);

						if(resultado ==  null){
							resultado = new AltaSolicitudCreditoResponse();
							resultado.setCodigoRespuesta("999");
							resultado.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDWSALT");
							resultado.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
							throw new Exception(Constantes.MSG_ERROR + " .operacionesPDA.WS.solicitudCreditoWS");

						} else if(Integer.parseInt(resultado.getCodigoRespuesta())!=0){
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No.: " + resultado.getCodigoRespuesta() + ", " +resultado.getMensajeRespuesta());
						}

					} catch (Exception e) {
						resultado.setCodigoRespuesta("999");
						resultado.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
								+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDWSALT");
						resultado.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el alta de solicitud de crédito con WS: ", e);

					}
					return resultado;
		}});
		return solicitaCred;
	}
	// Alta de Solicitud de Crédito Grupal
	public AltaSolicitudGrupalResponse altaSolicitudGrupalWS (final AltaSolicitudGrupalRequest requestBean){
		AltaSolicitudGrupalResponse solicitaCred = new AltaSolicitudGrupalResponse();
		transaccionDAO.generaNumeroTransaccion();
		solicitaCred = (AltaSolicitudGrupalResponse)((TransactionTemplate)conexionOrigenDatosBean
				.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos()))
				.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				AltaSolicitudGrupalResponse resultado = new AltaSolicitudGrupalResponse();
				try {
					resultado = (AltaSolicitudGrupalResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call SOLICITUDCREDWSALT("
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
																		+ "?,?,?,?,?,"
												                        + "?,?,?,?,?,"
												                        + "?,?,?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ProspectoID", Utileria.convierteEntero(requestBean.getProspectoID()));
						    		sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getClienteID()));
						    		sentenciaStore.setInt("Par_ProduCredID", Utileria.convierteEntero(requestBean.getProductoCreditoID()));
									sentenciaStore.setDouble("Par_MontoSolic",Utileria.convierteDoble(requestBean.getMontoSolici()));
									sentenciaStore.setString("Par_Periodicidad",(requestBean.getPeriodicidad().trim()=="?"?Constantes.STRING_VACIO:requestBean.getPeriodicidad().trim()));

									sentenciaStore.setString("Par_PlazoID",(requestBean.getPlazo().trim()=="?"?Constantes.STRING_VACIO:requestBean.getPlazo().trim()));
									sentenciaStore.setInt("Par_DestinoCredID",Utileria.convierteEntero(requestBean.getDestinoCredito()));
									sentenciaStore.setString("Par_Proyecto",(requestBean.getProyecto().trim()=="?"?Constantes.STRING_VACIO:requestBean.getProyecto().trim()));
									sentenciaStore.setString("Par_TipoDispersion",(requestBean.getTipoDispersion().trim()=="?"?Constantes.STRING_VACIO:requestBean.getTipoDispersion().trim()));
									sentenciaStore.setString("Par_CuentaCLABE",(requestBean.getCuentaCLABE().trim()=="?"?Constantes.STRING_VACIO:requestBean.getCuentaCLABE().trim()));

									sentenciaStore.setString("Par_TipoPagoCapital",(requestBean.getTipoPagoCapital().trim()=="?"?Constantes.STRING_VACIO:requestBean.getTipoPagoCapital().trim()));
									sentenciaStore.setString("Par_TipoCredito", tipoCredito);
									sentenciaStore.setInt("Par_NumCreditos", numCreditos);
									sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(requestBean.getGrupoID()));
									sentenciaStore.setInt("Par_TipoIntegrante", Utileria.convierteEntero(requestBean.getTipoIntegrante()));

									sentenciaStore.setString("Par_Folio_Pda",(requestBean.getFolio().trim()=="?"?Constantes.STRING_VACIO:requestBean.getFolio().trim()));
									sentenciaStore.setString("Par_ClaveUsuario",(requestBean.getClaveUsuario().trim()=="?"?Constantes.STRING_VACIO:requestBean.getClaveUsuario().trim()));
									sentenciaStore.setString("Par_Dispositivo",(requestBean.getDispositivo().trim()=="?"?Constantes.STRING_VACIO:requestBean.getDispositivo().trim()));
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									AltaSolicitudGrupalResponse respuestaBean = new AltaSolicitudGrupalResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										respuestaBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
										respuestaBean.setMensajeRespuesta(resultadosStore.getString("mensajeRespuesta"));
										respuestaBean.setSolicitudCreditoID(resultadosStore.getString("solicitudCreditoID"));
										respuestaBean.setClienteID(resultadosStore.getString("clienteID"));

									}else{
										respuestaBean.setCodigoRespuesta(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setMensajeRespuesta("Transacción Rechazada.");
										respuestaBean.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setClienteID(String.valueOf(Constantes.ENTERO_CERO));
									}
									return respuestaBean;
								}
							}
						);

						if(resultado ==  null){
							resultado = new AltaSolicitudGrupalResponse();
							resultado.setCodigoRespuesta("999");
							resultado.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDWSALT");
							resultado.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setClienteID(String.valueOf(Constantes.ENTERO_CERO));
							throw new Exception(Constantes.MSG_ERROR + " .operacionesPDA.WS.solicitudCreditoWS");

						} else if(Integer.parseInt(resultado.getCodigoRespuesta())!=0){
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No.: " + resultado.getCodigoRespuesta() + ", " +resultado.getMensajeRespuesta());
							throw new Exception("Error No.: " + resultado.getCodigoRespuesta() + ", " +resultado.getMensajeRespuesta());
						}

					} catch (Exception e) {
						if(Integer.parseInt(resultado.getCodigoRespuesta())!=0&&Integer.parseInt(resultado.getCodigoRespuesta())==999){
							resultado.setCodigoRespuesta("999");
							resultado.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDWSALT");
						}
						resultado.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setClienteID(String.valueOf(Constantes.ENTERO_CERO));
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el alta de solicitud de crédito con WS: ", e);

					}
					return resultado;
		}});
		return solicitaCred;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
