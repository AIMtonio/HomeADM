package operacionesPDA.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;

import operacionesPDA.beanWS.request.SolAltaClienteRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_Solicitud3ReyesResponse;
import operacionesPDA.beanWS.response.SolAltaClienteResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class SolAltaClienteDAO extends BaseDAO{

	public SolAltaClienteDAO(){
		super();
	}

	public SolAltaClienteResponse solAltaClienteWS(final SolAltaClienteRequest requestBean ){

		SolAltaClienteResponse solAltaClienteResponse = new SolAltaClienteResponse();

		solAltaClienteResponse = (SolAltaClienteResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						SolAltaClienteResponse response = new SolAltaClienteResponse();
						transaccionDAO.generaNumeroTransaccionWS();
						try {
							response = (SolAltaClienteResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {

										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

											String query = "call CLIENTESOLWSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
							                        						+ "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
							                        						+ "?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);

									    		sentenciaStore.setString("Par_PrimerNombre",requestBean.getPrimerNombre());
												sentenciaStore.setString("Par_SegundoNombre",requestBean.getSegundoNombre());
												sentenciaStore.setString("Par_TercerNombre",requestBean.getTercerNombre());
												sentenciaStore.setString("Par_ApPaterno",requestBean.getApPaterno());
												sentenciaStore.setString("Par_ApMaterno",requestBean.getApMaterno());

												sentenciaStore.setDate("Par_FechaNaci",OperacionesFechas.conversionStrDate(requestBean.getFecNacimiento()));
												sentenciaStore.setString("Par_Titulo",requestBean.getTitulo());
												sentenciaStore.setString("Par_RFC",requestBean.getRFC());
												sentenciaStore.setString("Par_CURP",requestBean.getCURP());
												sentenciaStore.setString("Par_EstadoCivil",requestBean.getEstadoCivil());

												sentenciaStore.setInt("Par_SucursalOrigen",Utileria.convierteEntero(requestBean.getSucursal()));
												sentenciaStore.setString("Par_Mail",requestBean.getMail());
												sentenciaStore.setInt("Par_PaisNaci",Utileria.convierteEntero(requestBean.getPaisNacimiento()));
												sentenciaStore.setInt("Par_EstadoNaci",Utileria.convierteEntero(requestBean.getEstadoNacimiento()));
												sentenciaStore.setString("Par_Nacionalidad",requestBean.getNacionalidad());

												sentenciaStore.setInt("Par_PaisResidencia",Utileria.convierteEntero(requestBean.getPaisResidencia()));
												sentenciaStore.setString("Par_Sexo",requestBean.getSexo());
												sentenciaStore.setString("Par_Telefono",requestBean.getTelefono());
												sentenciaStore.setInt("Par_SectorGral",Utileria.convierteEntero(requestBean.getSectorGeneral()));
												sentenciaStore.setString("Par_ActividadBMX",requestBean.getActividadBMX());

												sentenciaStore.setString("Par_ActividadFR",requestBean.getActividadFR());
												sentenciaStore.setInt("Par_PromotorIni",Utileria.convierteEntero(requestBean.getPromotorInicial()));
												sentenciaStore.setInt("Par_PromotorAct",Utileria.convierteEntero(requestBean.getPromotorActual()));
												sentenciaStore.setInt("Par_Numero",Utileria.convierteEntero(requestBean.getNumero()));
												sentenciaStore.setInt("Par_TipoDireccion",Utileria.convierteEntero(requestBean.getTipoDireccion()));

												sentenciaStore.setInt("Par_Estado",Utileria.convierteEntero(requestBean.getEstado()));
												sentenciaStore.setInt("Par_Municipio",Utileria.convierteEntero(requestBean.getMunicipio()));
												sentenciaStore.setString("Par_CodigoPostal",requestBean.getCodigoPostal());
												sentenciaStore.setInt("Par_Localidad",Utileria.convierteEntero(requestBean.getLocalidad()));
												sentenciaStore.setInt("Par_Colonia",Utileria.convierteEntero(requestBean.getColonia()));

												sentenciaStore.setString("Par_Calle",requestBean.getCalle());
												sentenciaStore.setString("Par_NumDireccion",requestBean.getNumeroDireccion());
												sentenciaStore.setString("Par_DirOficial",requestBean.getOficial());
												sentenciaStore.setString("Par_NumIdenti",requestBean.getNumIdentificacion());
												sentenciaStore.setInt("Par_TipoIdenti",Utileria.convierteEntero(requestBean.getTipoIdentificacion()));

												sentenciaStore.setString("Par_EsOficial",requestBean.getEsOficial());
												sentenciaStore.setDate("Par_FechaExp",OperacionesFechas.conversionStrDate(requestBean.getFechaExpedicion()));
												sentenciaStore.setDate("Par_FechaVen",OperacionesFechas.conversionStrDate(requestBean.getFechaVencimiento()));
												sentenciaStore.setString("Par_PriNombreConyu",requestBean.getPrimerNombreConyuge());
												sentenciaStore.setString("Par_SegNombreConyu",requestBean.getSegundoNombreConyuge());

												sentenciaStore.setString("Par_TerNombreConyu",requestBean.getTercerNombreConyuge());
												sentenciaStore.setString("Par_ApPaternoConyu",requestBean.getApPaternoConyuge());
												sentenciaStore.setString("Par_ApMaternoConyu",requestBean.getApMaternoConyuge());
												sentenciaStore.setString("Par_NacionConyu",requestBean.getNacionalidadConyuge());
												sentenciaStore.setInt("Par_PaisNacConyu",Utileria.convierteEntero(requestBean.getPaisNacimientoConyuge()));

												sentenciaStore.setInt("Par_EstadoNacConyu",Utileria.convierteEntero(requestBean.getEstadoNacConyuge()));
												sentenciaStore.setDate("Par_FecNacConyu",OperacionesFechas.conversionStrDate(requestBean.getFechaNacConyuge()));
												sentenciaStore.setString("Par_RFCConyu",requestBean.getRFCConyuge());
												sentenciaStore.setInt("Par_TipoIdentiConyu",Utileria.convierteEntero(requestBean.getTipoIdentiConyuge()));
												sentenciaStore.setString("Par_NumIdentiConyu",requestBean.getFolioIdentiConyuge());

												sentenciaStore.setString("Par_Folio",requestBean.getFolio());
												sentenciaStore.setString("Par_ClaveUsuario",requestBean.getClaveUsuario());
												sentenciaStore.setString("Par_Dispositivo",requestBean.getDispositivo());

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
											public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																							DataAccessException {
												SolAltaClienteResponse responseBean = new SolAltaClienteResponse();
												if(callableStatement.execute()){
													ResultSet resultadosStore = callableStatement.getResultSet();

													resultadosStore.next();

													responseBean.setClienteID(resultadosStore.getString("clienteID"));
													responseBean.setCodigoRespuesta(resultadosStore.getString("codigoRespuesta"));
													responseBean.setMensajeRespuesta(Utileria.generaLocale(resultadosStore.getString("mensajeRespuesta"),PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA")));


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
									response = new SolAltaClienteResponse();
									response.setClienteID("00");
									response.setCodigoRespuesta("998");
									response.setMensajeRespuesta("Error, Transacción Rechazada.");

									throw new Exception(Constantes.MSG_ERROR + " .operacionesPDA.WS.solicitudCreditoWS");
								} else if(Integer.parseInt(response.getCodigoRespuesta())!=0){
									if(Integer.parseInt(response.getCodigoRespuesta())==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Cliente: " + response.getMensajeRespuesta());
									} else {
										loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + response.getCodigoRespuesta() + ", " +response.getMensajeRespuesta());
										throw new Exception("Transacción Rechazada.");
									}
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

		return solAltaClienteResponse;
	}

}
