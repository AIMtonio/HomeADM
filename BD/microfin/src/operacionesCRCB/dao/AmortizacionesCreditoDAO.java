package operacionesCRCB.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import operacionesCRCB.bean.ConsultaAmortizacionesBean;
import operacionesCRCB.beanWS.request.ActualizaDireccionRequest;
import operacionesCRCB.beanWS.request.AltaCuentaAutorizadaRequest;
import operacionesCRCB.beanWS.request.ConsultaAmortizacionesRequest;
import operacionesCRCB.beanWS.response.ActualizaDireccionResponse;
import operacionesCRCB.beanWS.response.AltaCuentaAutorizadaResponse;
import operacionesCRCB.beanWS.response.ConsultaAmortizacionesResponse;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cliente.bean.ActividadesCompletaBean;

import soporte.PropiedadesSAFIBean;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class AmortizacionesCreditoDAO extends BaseDAO {


	public AmortizacionesCreditoDAO(){
		super();
	}

	@SuppressWarnings("unchecked")
	public List listaAmortiCredito(ConsultaAmortizacionesRequest consultaAmortizacionesRequest , int tipoLista) {

		List listaAmortizacion = null;

		try{
			String query = "call CRCBAMORTICREDITOWSLIS(?,?,?,?,?,  ?,?,?);";
			Object[] parametros = {	consultaAmortizacionesRequest.getCreditoID(),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AmortizacionesCreditoDAO.listaAmortiCredito",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CRCBAMORTICREDITOWSLIS(" + Arrays.toString(parametros) + ")");
			listaAmortizacion	= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ConsultaAmortizacionesBean amortizacion = new ConsultaAmortizacionesBean();


						amortizacion.setCreditoID(resultSet.getString("CreditoID"));
						amortizacion.setClienteID(resultSet.getString("ClienteID"));
						amortizacion.setAmortizacionID(resultSet.getString("AmortizacionID"));
						amortizacion.setFechaInicio(resultSet.getString("FechaInicio"));
						amortizacion.setFechaVencim(resultSet.getString("FechaVencim"));
						amortizacion.setFechaExigible(resultSet.getString("FechaExigible"));
						amortizacion.setCapital(resultSet.getString("Capital"));
						amortizacion.setInteres(resultSet.getString("Interes"));
						amortizacion.setIvaInteres(resultSet.getString("IvaInteres"));
						amortizacion.setTotalPago(resultSet.getString("TotalPago"));
						amortizacion.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
						amortizacion.setDias(resultSet.getString("Dias"));
						amortizacion.setFecUltAmor(resultSet.getString("Var_FechaUltAmor"));
						amortizacion.setFecInicioAmor(resultSet.getString("Var_FechaIniAmor"));
						amortizacion.setMontoCuota(resultSet.getString("Var_MaxMontoCuota"));
						amortizacion.setTotalCap(resultSet.getString("TotalCapital"));
						amortizacion.setTotalInteres(resultSet.getString("TotalInteres"));
						amortizacion.setTotalIva(resultSet.getString("TotalIVA"));

						return amortizacion;

				}

			});
		}catch(Exception e){
			e.printStackTrace();
		}


		return listaAmortizacion;
	}


	public ConsultaAmortizacionesResponse validaConsultaAmortizaciones(final ConsultaAmortizacionesRequest consultaAmortizacionesBean) {
		ConsultaAmortizacionesResponse mensaje = null;

		mensaje = (ConsultaAmortizacionesResponse) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				ConsultaAmortizacionesResponse mensajeBean = null;
				try {
					// Query con el Store Procedure
					mensajeBean = (ConsultaAmortizacionesResponse) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

									String query = "call CRCBAMORTICREDITOWSVAL(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(consultaAmortizacionesBean.getCreditoID()));
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
									ConsultaAmortizacionesResponse mensajeTransaccion = new ConsultaAmortizacionesResponse();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();

										mensajeTransaccion.setCodigoRespuesta(resultadosStore.getString("NumErr"));
										mensajeTransaccion.setMensajeRespuesta(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setCodigoRespuesta("999");
										mensajeTransaccion.setMensajeRespuesta(Constantes.MSG_ERROR + " .AmortizacionesCreditoDAO");

									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new ConsultaAmortizacionesResponse();
							mensajeBean.setCodigoRespuesta("999");
							throw new Exception(Constantes.MSG_ERROR + " .AmortizacionesCreditoDAO");
						}else if(Integer.parseInt(mensajeBean.getCodigoRespuesta())!=0){
								throw new Exception(mensajeBean.getMensajeRespuesta());
						}
					} catch (Exception e) {

						if(mensajeBean ==  null){
							mensajeBean = new ConsultaAmortizacionesResponse();
							mensajeBean.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
									+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: WS-CONSULTAAMORTIZACIONES");
						}

						if(Utileria.convierteEntero(mensajeBean.getCodigoRespuesta()) == 0){
							mensajeBean.setCodigoRespuesta("999");
						}

						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en WS de Validación de Consulta de Amortizaciones :" + e);
						e.printStackTrace();
						transaction.setRollbackOnly();

					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

}
