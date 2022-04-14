package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import operacionesCRCB.beanWS.request.ActualizaDireccionRequest;
import operacionesCRCB.beanWS.request.AltaCuentaAutorizadaRequest;
import operacionesCRCB.beanWS.response.ActualizaDireccionResponse;
import operacionesCRCB.beanWS.response.AltaCuentaAutorizadaResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.PropiedadesSAFIBean;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class DireccionesWSDAO extends BaseDAO {


	public DireccionesWSDAO(){
		super();
	}

	public ActualizaDireccionResponse modificaDireccion(final ActualizaDireccionRequest actualizaDireccion) {
		ActualizaDireccionResponse mensaje = new ActualizaDireccionResponse();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (ActualizaDireccionResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				ActualizaDireccionResponse mensajeBean = null;
				try {
					// Query con el Store Procedure
					mensajeBean = (ActualizaDireccionResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CRCBDIRECCIONESMODWSPRO(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?);";
									//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(actualizaDireccion.getClienteID()));
									sentenciaStore.setInt("Par_DireccionID", Utileria.convierteEntero(actualizaDireccion.getDireccionID()));
									sentenciaStore.setInt("Par_TipoDireccionID", Utileria.convierteEntero(actualizaDireccion.getTipoDireccionID()));
									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(actualizaDireccion.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(actualizaDireccion.getMunicipioID()));

									sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(actualizaDireccion.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(actualizaDireccion.getColoniaID()));
									sentenciaStore.setString("Par_Calle",actualizaDireccion.getCalle());
									sentenciaStore.setString("Par_NumeroCasa",actualizaDireccion.getNumeroCasa());
									sentenciaStore.setString("Par_NumInterior",actualizaDireccion.getNumInterior());

									sentenciaStore.setString("Par_Piso",actualizaDireccion.getPiso());
									sentenciaStore.setString("Par_PrimeraEntreCalle",actualizaDireccion.getPrimeraEntreCalle());
									sentenciaStore.setString("Par_SegundaEntreCalle",actualizaDireccion.getSegundaEntreCalle());
									sentenciaStore.setString("Par_Oficial",actualizaDireccion.getOficial());
									sentenciaStore.setString("Par_Fiscal",actualizaDireccion.getFiscal());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									ActualizaDireccionResponse mensajeTransaccion = new ActualizaDireccionResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("ErrMen"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreCorto")));


									}else{
										mensajeTransaccion.setCodigoRespuesta("999");
										mensajeTransaccion.setMensajeRespuesta(Constantes.MSG_ERROR + " .DireccionesWSDAO.modificaDireccion");

									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new ActualizaDireccionResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception(Constantes.MSG_ERROR + " .DireccionesWSDAO.modificaDireccion");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
								throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {

						if(mensajeBean ==  null){
							mensajeBean = new ActualizaDireccionResponse();
							mensajeBean.setCodigoRespuesta("999");
							mensajeBean.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-ACTUALIZADIRECCION");
						}

						if(Utileria.convierteEntero(mensajeBean.getCodigoRespuesta()) == 0){
							mensajeBean.setCodigoRespuesta("999");
						}


						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en WS de Actualización de Dirección :" + e);
						e.printStackTrace();
						transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	public ActualizaDireccionResponse modificaDireccionReplica(final ActualizaDireccionRequest actualizaDireccion, final String origenReplica) {
		ActualizaDireccionResponse mensaje = new ActualizaDireccionResponse();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (ActualizaDireccionResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenReplica)).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				ActualizaDireccionResponse mensajeBean = null;
				try {
					// Query con el Store Procedure
					mensajeBean = (ActualizaDireccionResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(origenReplica)).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CRCBDIRECCIONESMODWSPRO(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?,?,  ?,?,?,?,?);";
									//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);


									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(actualizaDireccion.getClienteID()));
									sentenciaStore.setInt("Par_DireccionID", Utileria.convierteEntero(actualizaDireccion.getDireccionID()));
									sentenciaStore.setInt("Par_TipoDireccionID", Utileria.convierteEntero(actualizaDireccion.getTipoDireccionID()));
									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(actualizaDireccion.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(actualizaDireccion.getMunicipioID()));

									sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(actualizaDireccion.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(actualizaDireccion.getColoniaID()));
									sentenciaStore.setString("Par_Calle",actualizaDireccion.getCalle());
									sentenciaStore.setString("Par_NumeroCasa",actualizaDireccion.getNumeroCasa());
									sentenciaStore.setString("Par_NumInterior",actualizaDireccion.getNumInterior());

									sentenciaStore.setString("Par_Piso",actualizaDireccion.getPiso());
									sentenciaStore.setString("Par_PrimeraEntreCalle",actualizaDireccion.getPrimeraEntreCalle());
									sentenciaStore.setString("Par_SegundaEntreCalle",actualizaDireccion.getSegundaEntreCalle());
									sentenciaStore.setString("Par_Oficial",actualizaDireccion.getOficial());
									sentenciaStore.setString("Par_Fiscal",actualizaDireccion.getFiscal());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									ActualizaDireccionResponse mensajeTransaccion = new ActualizaDireccionResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("ErrMen"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("NombreCorto")));


									}else{
										mensajeTransaccion.setCodigoRespuesta("999");
										mensajeTransaccion.setMensajeRespuesta(Constantes.MSG_ERROR + " .DireccionesWSDAO.modificaDireccion");

									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new ActualizaDireccionResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception(Constantes.MSG_ERROR + " .DireccionesWSDAO.modificaDireccion");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
								throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {

						if(mensajeBean ==  null){
							mensajeBean = new ActualizaDireccionResponse();
							mensajeBean.setCodigoRespuesta("999");
							mensajeBean.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-ACTUALIZADIRECCION");
						}

						if(Utileria.convierteEntero(mensajeBean.getCodigoRespuesta()) == 0){
							mensajeBean.setCodigoRespuesta("999");
						}


						loggerSAFI.error(origenReplica+"-"+"Error en WS de Actualización de Dirección :" + e);
						e.printStackTrace();
						transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

}
