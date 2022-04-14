package operacionesPDA.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import operacionesPDA.beanWS.request.SP_PDA_Creditos_DescargaRequest;

import org.springframework.jdbc.core.RowMapper;
 
import credito.bean.CreditosBean;


public class SP_PDA_Creditos_Descarga3ReyesDAO extends BaseDAO {
	
	public SP_PDA_Creditos_Descarga3ReyesDAO() {
		super();
	}

	/* lista los creditos de socios por promotores WS*/
public List lisCreditosWS(SP_PDA_Creditos_DescargaRequest bean, int tipoLista){		
	List creditosLis = null;
	try{
		String query = "call CREDITOSWSLIS(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(bean.getId_Segmento()),
				                tipoLista,
				
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"operacionesPDA.WS.listaCreditosGNS3ReyesWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSWSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				CreditosBean credito = new CreditosBean();		
				
					credito.setCuentaID(resultSet.getString("Num_Cta"));
					credito.setClienteID(resultSet.getString("Num_Socio"));
					credito.setCreditoID(resultSet.getString("Id_Cuenta"));
					credito.setAdeudoTotal(resultSet.getString("Saldo"));
					credito.setPagoExigible(resultSet.getString("PagoMinimo"));
					credito.setMontoExigible(resultSet.getString("PagoMensual"));
					credito.setSaldCapVenNoExi(resultSet.getString("Saldo"));
					credito.setSaldoComFaltPago(resultSet.getString("GastosCobranza"));
					credito.setFechaUltAbonoCre(resultSet.getString("FechaUltAbono"));
					credito.setEstatus(resultSet.getString("Estatus"));
					credito.setIntOrdDevengado(resultSet.getString("InteresOrd"));
					credito.setIntMorDevengado(resultSet.getString("InteresMor"));					
					credito.setSaldoIVAMorato(resultSet.getString("IvaIntMor"));
					credito.setIVAInteres(resultSet.getString("IvaIntNor"));
					credito.setTasaFija(resultSet.getString("TasaInteres"));

					return credito;	
				}
			});

		creditosLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de creditos por promotor para WS", e);
		}		
		return creditosLis;
		
}
// fin de lista para WS
}
