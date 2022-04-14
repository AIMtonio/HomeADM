package operacionesPDA.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import operacionesPDA.bean.SP_PDA_OtrosCat_Descarga3ReyesBean;
import operacionesPDA.beanWS.request.SP_PDA_OtrosCat_Descarga3ReyesRequest;

import org.springframework.jdbc.core.RowMapper;

public class SP_PDA_OtrosCat_Descarga3ReyesDAO extends BaseDAO {
 
	public SP_PDA_OtrosCat_Descarga3ReyesDAO() {
		super();
	}

	/* lista los creditos de un grupo no solidario WS*/
public List listaOtrosCatWS(SP_PDA_OtrosCat_Descarga3ReyesRequest bean){		
	List otrosCatLis = null;
		try{
		String query = "call CATALOGOSWSLIS(?,?,?,?,?,   ?,?,?);";
		Object[] parametros = {	bean.getSP_Name(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"operacionesPDA.WS.listaOtrosCat3ReyesWS",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATALOGOSWSLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
				SP_PDA_OtrosCat_Descarga3ReyesBean sp_PDA_OtrosCat_DescargaBean = new SP_PDA_OtrosCat_Descarga3ReyesBean();		
								
				sp_PDA_OtrosCat_DescargaBean.setCampo(resultSet.getString("Id_Campo"));
				sp_PDA_OtrosCat_DescargaBean.setNcampo(resultSet.getString("NombreCampo"));				
				sp_PDA_OtrosCat_DescargaBean.setPadre(resultSet.getString("Id_Padre"));
				
					return sp_PDA_OtrosCat_DescargaBean;	
				}			
			
			});
		

		otrosCatLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de otros catalogos WS", e);
		}		
		return otrosCatLis;
		
  }
// fin de lista para WS 
	  
}
