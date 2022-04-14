package operacionesPDA.dao;


import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import operacionesPDA.beanWS.request.SP_PDA_Creditos_Solicitud3ReyesRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_PagoResponse;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_Solicitud3ReyesResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;


public class SP_PDA_Creditos_Solicitud3ReyesDAO extends BaseDAO{
		public SP_PDA_Creditos_Solicitud3ReyesDAO() {
			super();
		}


	/* Realiza la consulta para solicitar credito WS */
		public SP_PDA_Creditos_Solicitud3ReyesResponse solicitudCreditoWS(final SP_PDA_Creditos_Solicitud3ReyesRequest requestBean) {
			SP_PDA_Creditos_Solicitud3ReyesResponse solicitaCred = new SP_PDA_Creditos_Solicitud3ReyesResponse();

					solicitaCred = (SP_PDA_Creditos_Solicitud3ReyesResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				SP_PDA_Creditos_Solicitud3ReyesResponse resultado = new SP_PDA_Creditos_Solicitud3ReyesResponse();
				transaccionDAO.generaNumeroTransaccion();
				try {
					resultado = (SP_PDA_Creditos_Solicitud3ReyesResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call SOLICITUDCREPDAWSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,"
				                        + "?,?,?,?,?,  ?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);

						    		sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getNum_Socio()));
									sentenciaStore.setDouble("Par_MontoSolic",Utileria.convierteDoble(requestBean.getMonto()));
									sentenciaStore.setString("Par_FechaReg",requestBean.getFecha_Mov());

									sentenciaStore.setInt("Par_DestinoCre",Utileria.convierteEntero(requestBean.getDestinoCred()));
									sentenciaStore.setString("Par_Dispersion",requestBean.getDispercion());
									sentenciaStore.setString("Par_TipPago",requestBean.getTipoPago());
									sentenciaStore.setInt("Par_NumCuota",Utileria.convierteEntero(requestBean.getNumCuota()));
									sentenciaStore.setInt("Par_PlazoID",Utileria.convierteEntero(requestBean.getPlazo()));
									sentenciaStore.setString("Par_FecuenciaCap",requestBean.getFecuenciaCap());
									sentenciaStore.setString("Par_FecuenciaInt",requestBean.getFecuenciaInt());

									sentenciaStore.setString("Par_Folio_Pda",requestBean.getFolio_Pda());
									sentenciaStore.setString("Par_Id_Usuario",requestBean.getId_Usuario());
									sentenciaStore.setString("Par_Clave",requestBean.getClave());
									sentenciaStore.setString("Par_Dispositivo",requestBean.getDispositivo());


									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
									sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
									sentenciaStore.setString("Aud_ProgramaID", "operacionesPDA.WS.solicitudCreditoWS");
									sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());


									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									SP_PDA_Creditos_Solicitud3ReyesResponse respuestaBean = new SP_PDA_Creditos_Solicitud3ReyesResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										respuestaBean.setCodigoResp(resultadosStore.getString("CodigoResp"));
										respuestaBean.setCodigoDesc(resultadosStore.getString("CodigoDesc"));
										respuestaBean.setEsValido(resultadosStore.getString("EsValido"));
										respuestaBean.setFolioSol(resultadosStore.getString("FolioSol"));

									}else{
										DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
										DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
										Date fecha = new Date();
										respuestaBean.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
										respuestaBean.setCodigoDesc("Transacción Rechazada");
										respuestaBean.setEsValido("false");
										respuestaBean.setFolioSol(String.valueOf(Constantes.ENTERO_CERO));


									}
									return respuestaBean;
								}
							}
						);

						if(resultado ==  null){
							resultado = new SP_PDA_Creditos_Solicitud3ReyesResponse();
							resultado.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
							resultado.setCodigoDesc("Transacción Rechazada");
							resultado.setEsValido("false");
							resultado.setFolioSol(String.valueOf(Constantes.ENTERO_CERO));


							throw new Exception(Constantes.MSG_ERROR + " .operacionesPDA.WS.solicitudCreditoWS");
						}else if(Integer.parseInt(resultado.getCodigoResp())!=1){
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error No. " + resultado.getCodigoResp() + ", " +resultado.getCodigoDesc());
							throw new Exception("Transacción Rechazada");

						}


					} catch (Exception e) {
						if (Integer.parseInt(resultado.getCodigoResp())==1) {
							resultado.setCodigoResp("0");
						}

						resultado.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setCodigoDesc(e.getMessage());
						resultado.setEsValido("false");
						resultado.setFolioSol(String.valueOf(Constantes.ENTERO_CERO));

						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la solicitud de crédito con  WS", e);

					}
					return resultado;
			}});

			return solicitaCred;
		}

	}


