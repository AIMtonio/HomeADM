package operacionesVBC.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import operacionesVBC.bean.VbcSimuladorCreditoBean;
import operacionesVBC.beanWS.request.VbcSimuladorCreditoRequest;
import operacionesVBC.beanWS.response.VbcSimuladorCreditoResponse;

public class VbcSimuladorCreditoDAO extends BaseDAO {
 
	public VbcSimuladorCreditoDAO() {
		super();
	}

	/* SIMULADOR DE PAGOS CRECIENTES CON TASA FIJA */
	public List vbcSimuladorCreditoLista (final VbcSimuladorCreditoRequest bean){
		transaccionDAO.generaNumeroTransaccion();
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		VbcSimuladorCreditoResponse amortizacionCred = null;
		final VbcSimuladorCreditoResponse amortizacionCredito = new VbcSimuladorCreditoResponse();
		matches = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {	
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call SIMULADORCREVBCPRO(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?);";
				System.out.println(",bean.getFrecuencia()"+ bean.getFrecuencia());

				System.out.println("Utileria.convierteEntero(bean.getClienteID())"+ Utileria.convierteEntero(bean.getClienteID()));

				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(bean.getMonto()));
				sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(bean.getTasa()));
				sentenciaStore.setString("Par_Frecuencia",bean.getFrecuencia());
				sentenciaStore.setInt("Par_Periodicidad",Utileria.convierteEntero(bean.getPeriodicidad()));
				sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(bean.getFechaInicio()));
				
				sentenciaStore.setInt("Par_NumeroCuotas",Utileria.convierteEntero(bean.getNumeroCuotas()));
				sentenciaStore.setInt("Par_ProdCredID",Utileria.convierteEntero(bean.getProductoCreditoID()));
				sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(bean.getClienteID()));
				sentenciaStore.setDouble("Par_ComAper",Utileria.convierteDoble(bean.getComisionApertura()));
				sentenciaStore.setString("Par_Usuario",bean.getUsuario());
				sentenciaStore.setString("Par_Clave",bean.getClave());
				sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
				sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
				sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
				
				sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
				sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
				sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
				sentenciaStore.setString("Aud_ProgramaID",Constantes.STRING_VACIO);
				sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
				sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());				
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SIMULADORCREVBCPRO(  " + sentenciaStore.toString() + ")");
				return sentenciaStore;
			}
		},new CallableStatementCallback() {
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
				if(callableStatement.execute()){																		
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) { 							
						VbcSimuladorCreditoBean	respuesta	=new VbcSimuladorCreditoBean();
						respuesta.setAmortizacionID(resultadosStore.getString("Tmp_Consecutivo"));
						respuesta.setFechaInicio(resultadosStore.getString("Tmp_FecIni"));
						respuesta.setFechaVencim(resultadosStore.getString("Tmp_FecFin"));
						respuesta.setFechaExigible(resultadosStore.getString("Tmp_FecVig"));
						respuesta.setCapital(resultadosStore.getString("Tmp_Capital"));
						respuesta.setInteres(resultadosStore.getString("Tmp_Interes"));
						respuesta.setIvaInteres(resultadosStore.getString("Tmp_Iva"));
						respuesta.setTotalPago(resultadosStore.getString("Tmp_SubTotal"));
						respuesta.setSaldoInsoluto(resultadosStore.getString("Tmp_Insoluto"));
						respuesta.setDias(resultadosStore.getString("Tmp_Dias"));
						respuesta.setCuotasCapital(resultadosStore.getString("Var_Cuotas"));
						respuesta.setNumTransaccion(resultadosStore.getString("NumTransaccion"));
						respuesta.setCat(resultadosStore.getString("Var_CAT"));
						respuesta.setFecUltAmor(resultadosStore.getString("Par_FechaVenc"));
						respuesta.setFecInicioAmor(resultadosStore.getString("Par_FechaInicio"));
						respuesta.setMontoCuota(resultadosStore.getString("MontoCuota"));
						respuesta.setTotalCap(resultadosStore.getString("TotalCap"));
						respuesta.setTotalInteres(resultadosStore.getString("TotalInt"));
						respuesta.setTotalIva(resultadosStore.getString("TotalIva"));
						respuesta.setCobraSeguroCuota(resultadosStore.getString("CobraSeguroCuota"));
						respuesta.setMontoSeguroCuota(resultadosStore.getString("MontoSeguroCuota"));
						respuesta.setiVASeguroCuota(resultadosStore.getString("IVASeguroCuota"));
						respuesta.setTotalSeguroCuota(resultadosStore.getString("TotalSeguroCuota"));
						respuesta.setTotalIVASeguroCuota(resultadosStore.getString("TotalIVASeguroCuota"));
						respuesta.setCodigoError(resultadosStore.getString("NumErr"));
						respuesta.setMensajeError(resultadosStore.getString("ErrMen"));
						matches2.add(respuesta);
					}
				}
				return matches2;
			}
		});
		VbcSimuladorCreditoBean creditos = new  VbcSimuladorCreditoBean();
		creditos.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
		return matches;
	}
	  
	  
}
