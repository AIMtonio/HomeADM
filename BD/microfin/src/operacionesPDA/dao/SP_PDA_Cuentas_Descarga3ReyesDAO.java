package operacionesPDA.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
 
import cuentas.bean.CuentasAhoBean;

public class SP_PDA_Cuentas_Descarga3ReyesDAO extends BaseDAO{

	private SP_PDA_Cuentas_Descarga3ReyesDAO(){
		super();
	}
	

	
	/* lista de cuentas y/o creditos de clientes que pertenezcan a un promotor para 3 Reyes WS*/
	public List listaCuentasWS(int tipoLista){		
		List cuentasLis = null;
		try{
			String query = "call TIPOSCTACREWSLIS(?,?,?,  ?,?,?,?,?);";
			Object[] parametros = {	
									tipoLista,
									
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"operacionesPDA.WS.listaCuentasWS",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSCTACREWSLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					CuentasAhoBean cuenta = new CuentasAhoBean();		
					
					cuenta.setCuentaAhoID(resultSet.getString("Id_Cuenta"));
					cuenta.setDescripcionTipoCta(resultSet.getString("NombreCta"));
					cuenta.setTipoCuentaID(resultSet.getString("TipoCta"));
					cuenta.setSaldoMax(resultSet.getString("SaldoMax"));
					cuenta.setSaldoMin(resultSet.getString("SaldoMin"));
					cuenta.setPermiteAbo(resultSet.getString("PermiteAbo"));
					
					return cuenta;	
				}
			});

			cuentasLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de cuentas y/o creditos de clientes que pertenecen a un grupo no solidario para WS 3 Reyes", e);
		}		
		return cuentasLis;
	}// fin de lista para WS

}
