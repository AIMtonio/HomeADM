package operacionesPDA.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import operacionesPDA.beanWS.request.SP_PDA_Creditos_PagoRequest;
import operacionesPDA.beanWS.response.SP_PDA_Creditos_PagoResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

public class SP_PDA_Creditos_PagoDAO extends BaseDAO{
	public SP_PDA_Creditos_PagoDAO() {
		super();
	}


/* Realiza la consulta del abono a una cuenta WS */
	public SP_PDA_Creditos_PagoResponse pagoCreditoWS(final SP_PDA_Creditos_PagoRequest requestBean, final int tipoTransaccion) {
		SP_PDA_Creditos_PagoResponse creditosPagoResponse = new SP_PDA_Creditos_PagoResponse();
		transaccionDAO.generaNumeroTransaccion();
		creditosPagoResponse = (SP_PDA_Creditos_PagoResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
		public Object doInTransaction(TransactionStatus transaction) {
			SP_PDA_Creditos_PagoResponse resultado = new SP_PDA_Creditos_PagoResponse();
			try {
				resultado = (SP_PDA_Creditos_PagoResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PAGOCREDITOWSPRO(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(requestBean.getNum_Socio()));
								sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(requestBean.getNum_Cta()));
								sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(requestBean.getMonto()));
								sentenciaStore.setString("Par_ClaveUsuario",requestBean.getId_Usuario());
								sentenciaStore.setString("Par_Contrasenia",requestBean.getClave());
								sentenciaStore.setInt("Par_NumTra",tipoTransaccion);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setString("Aud_FechaActual", Constantes.FECHA_VACIA);
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID", "operacionesPDAYanga.WS.pagoCreditoWS");

								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								SP_PDA_Creditos_PagoResponse respuestaBean = new SP_PDA_Creditos_PagoResponse();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();

									respuestaBean.setCodigoResp(resultadosStore.getString("NumErr"));
									respuestaBean.setCodigoDesc(resultadosStore.getString("ErrMen"));
									respuestaBean.setEsValido(resultadosStore.getString("EsValido"));
									respuestaBean.setAutFecha(resultadosStore.getString("FechaAuditoria"));
									respuestaBean.setFolioAut(resultadosStore.getString("NumTransaccion"));
									respuestaBean.setSaldo(resultadosStore.getString("AdeudoTotal"));
									respuestaBean.setCapitalPagado(resultadosStore.getString("CapitalPagado"));
									respuestaBean.setIntOrdPagado(resultadosStore.getString("IntOrdPagado"));
									respuestaBean.setIvaIntOrdPagado(resultadosStore.getString("IvaIntOrdPagado"));
									respuestaBean.setIntMorPagado(resultadosStore.getString("IntMoraPagado"));
									respuestaBean.setIvaIntMorPagado(resultadosStore.getString("IvaIntMoraPagado"));
								}else{
									DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
									DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
									Date fecha = new Date();
									respuestaBean.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
									respuestaBean.setCodigoDesc("Transacción Rechazada");
									respuestaBean.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
									respuestaBean.setEsValido("false");
									respuestaBean.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
									respuestaBean.setSaldo(String.valueOf(Constantes.DOUBLE_VACIO));
									respuestaBean.setCapitalPagado(String.valueOf(Constantes.DOUBLE_VACIO));
									respuestaBean.setIntOrdPagado(String.valueOf(Constantes.DOUBLE_VACIO));
									respuestaBean.setIvaIntOrdPagado(String.valueOf(Constantes.DOUBLE_VACIO));
									respuestaBean.setIntMorPagado(String.valueOf(Constantes.DOUBLE_VACIO));
									respuestaBean.setIvaIntMorPagado(String.valueOf(Constantes.DOUBLE_VACIO));
								}
								return respuestaBean;
							}
						}
					);

					if(resultado ==  null){
						resultado = new SP_PDA_Creditos_PagoResponse();
						DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
						DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
						Date fecha = new Date();
						resultado.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
						resultado.setCodigoDesc("Transacción Rechazada");
						resultado.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setEsValido("false");
						resultado.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
						resultado.setSaldo(String.valueOf(Constantes.DOUBLE_VACIO));
						resultado.setCapitalPagado(String.valueOf(Constantes.DOUBLE_VACIO));
						resultado.setIntOrdPagado(String.valueOf(Constantes.DOUBLE_VACIO));
						resultado.setIvaIntOrdPagado(String.valueOf(Constantes.DOUBLE_VACIO));
						resultado.setIntMorPagado(String.valueOf(Constantes.DOUBLE_VACIO));
						resultado.setIvaIntMorPagado(String.valueOf(Constantes.DOUBLE_VACIO));

						throw new Exception(Constantes.MSG_ERROR + " .SP_PDA_Creditos_PagoResponse.pagoCreditoWS");
					}else if(Integer.parseInt(resultado.getCodigoResp())!=1){
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error: " + resultado.getCodigoDesc());
						throw new Exception("Transacción Rechazada");
					}

				} catch (Exception e) {

					if (Integer.parseInt(resultado.getCodigoResp())==1) {
						resultado.setCodigoResp("0");
					}
					DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
					DateFormat timeFormat = new SimpleDateFormat("HH:mm:ss");
					Date fecha = new Date();
					resultado.setAutFecha(dateFormat.format(fecha)+"T"+timeFormat.format(fecha));
					resultado.setCodigoDesc(e.getMessage());
					resultado.setCodigoResp(String.valueOf(Constantes.ENTERO_CERO));
					resultado.setEsValido("false");
					resultado.setFolioAut(String.valueOf(Constantes.ENTERO_CERO));
					resultado.setSaldo(String.valueOf(Constantes.DOUBLE_VACIO));
					resultado.setCapitalPagado(String.valueOf(Constantes.DOUBLE_VACIO));
					resultado.setIntOrdPagado(String.valueOf(Constantes.DOUBLE_VACIO));
					resultado.setIvaIntOrdPagado(String.valueOf(Constantes.DOUBLE_VACIO));
					resultado.setIntMorPagado(String.valueOf(Constantes.DOUBLE_VACIO));
					resultado.setIvaIntMorPagado(String.valueOf(Constantes.DOUBLE_VACIO));

					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en pago de credito con  WS", e);
				}
				return resultado;
		}});

		return creditosPagoResponse;
	}

}



