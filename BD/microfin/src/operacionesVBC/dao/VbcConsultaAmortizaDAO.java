package operacionesVBC.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import operacionesVBC.bean.VbcConsultaAmortizacionesBean;
import operacionesVBC.beanWS.request.VbcConsultaAmortizaRequest;
import operacionesVBC.beanWS.response.VbcConsultaAmortizaResponse;

public class VbcConsultaAmortizaDAO extends BaseDAO {
	int consulta = 1; 
	public VbcConsultaAmortizaDAO() {
		super();
	}

	/* LISTA DE AMORTIZACION DE CREDITOS  */
	public List vbcAmortizacionesLista (final VbcConsultaAmortizaRequest bean){
		List matches =new  ArrayList();
		final List matches2 =new  ArrayList();
		try{
			System.out.println("ANTES DE QUERY ");
			final VbcConsultaAmortizaResponse amortizacionCredito = new VbcConsultaAmortizaResponse();
			matches = (List) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {	
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call AMORTICREDITOWSLIS(" +
							"?,?,?,?,?, ?,?,?,?,?," +
							"?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(bean.getCreditoID()));
					sentenciaStore.setString("Par_Usuario",bean.getUsuario());
					sentenciaStore.setString("Par_Clave",bean.getClave());
					sentenciaStore.setInt("Par_NumCon",consulta);
					sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
					
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setDate("Aud_FechaActual",OperacionesFechas.conversionStrDate(Constantes.FECHA_VACIA));
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID",Constantes.STRING_VACIO);
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);				
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOWSLIS(  " + sentenciaStore.toString() + ")");
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
					if(callableStatement.execute()){																		
						ResultSet resultadosStore = callableStatement.getResultSet();
						while (resultadosStore.next()) { 							
							VbcConsultaAmortizacionesBean	respuesta	=new VbcConsultaAmortizacionesBean();
							System.out.println("ANTES DE respuesta ");
							respuesta.setCreditoID(resultadosStore.getString("CreditoID"));
							respuesta.setAmortizacionID(resultadosStore.getString("AmortizacionID"));
							respuesta.setClienteID(resultadosStore.getString("ClienteID"));
							respuesta.setFechaExigible(resultadosStore.getString("FechaExigible"));
							respuesta.setTotalExigible(resultadosStore.getString("TotalExigible"));
							respuesta.setCapital(resultadosStore.getString("Capital"));
							respuesta.setInteres(resultadosStore.getString("Interes"));
							respuesta.setIvaInteres(resultadosStore.getString("IvaInteres"));
							respuesta.setInteresMora(resultadosStore.getString("InteresMora"));
							respuesta.setIvaInteresMora(resultadosStore.getString("IvaInteresMora"));
							respuesta.setEstatus(resultadosStore.getString("Estatus"));
		
							respuesta.setCodigoError(resultadosStore.getString("NumErr"));
							respuesta.setMensajeError(resultadosStore.getString("ErrMen"));
							matches2.add(respuesta);
						}
					}
					return matches2;
				}
			});
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return matches;
	}
	  
}
