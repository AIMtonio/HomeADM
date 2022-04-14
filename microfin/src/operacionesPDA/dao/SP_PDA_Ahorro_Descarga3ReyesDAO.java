package operacionesPDA.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import operacionesPDA.beanWS.request.SP_PDA_Ahorros_DescargaRequest;

import org.springframework.jdbc.core.RowMapper;

import cuentas.bean.CuentasAhoBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

public class SP_PDA_Ahorro_Descarga3ReyesDAO extends BaseDAO{
	
	public SP_PDA_Ahorro_Descarga3ReyesDAO() {
		super();
	}

/* lista de Cuentas de ahorro de clientes que pertenecen a un promotor para WS*/
public List listacuentasAhoWS(SP_PDA_Ahorros_DescargaRequest bean,int tipoLista){		
	List cuentasLis = null;
	try{
		String query = "call CUENTASAHOWSLIS(?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(bean.getId_Segmento()),
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CuentasAho3ReyesDAO.listacuentasAhoWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASAHOWSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				CuentasAhoBean cuenta = new CuentasAhoBean();		
				
				cuenta.setCuentaAhoID(resultSet.getString("Num_Cta"));
				cuenta.setTipoCuentaID(resultSet.getString("Id_Cuenta"));
				cuenta.setClienteID(resultSet.getString("Num_Socio"));
				cuenta.setSaldo(resultSet.getString("SaldoTot"));
				cuenta.setSaldoDispon(resultSet.getString("SaldoDisp"));
				
				return cuenta;	
			}
		});

		cuentasLis = matches;
	}catch(Exception e){
		 e.printStackTrace();
		 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de socios que pertenecen a un promotor para WS", e);
	}		
	return cuentasLis;
}// fin de lista para WS



}
