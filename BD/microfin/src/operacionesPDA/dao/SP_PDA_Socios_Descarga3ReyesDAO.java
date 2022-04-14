package operacionesPDA.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import operacionesPDA.beanWS.request.SP_PDA_Socios_DescargaRequest;

import org.springframework.jdbc.core.RowMapper;
 
import cliente.bean.ClienteBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SP_PDA_Socios_Descarga3ReyesDAO extends BaseDAO{
	
	public SP_PDA_Socios_Descarga3ReyesDAO() {
		super();
	} 
	
	
	/* lista de socios que pertenecen a un grupo no solidario para WS*/
	public List listaSociosWS(SP_PDA_Socios_DescargaRequest bean,int tipoLista){		
		List sociosLis = null;
		try{
			String query = "call CLIENTESWSLIS(?,?,?,?,?,  ?,?,?,?,?, ?,?);";
			Object[] parametros = { Constantes.STRING_VACIO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoLista,
									Utileria.convierteEntero(bean.getId_Segmento()),
									
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"GruposNosolidariosDAO.listaSociosWS",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTESWSLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					ClienteBean socio = new ClienteBean();		
					
					socio.setNumero(resultSet.getString("NumSocio"));
					socio.setNombreCompleto(resultSet.getString("Nombre"));
					socio.setApellidoPaterno(resultSet.getString("ApPaterno"));
					socio.setApellidoMaterno(resultSet.getString("ApMaterno"));
					socio.setFechaNacimiento(resultSet.getString("FecNacimiento"));
					socio.setRFC(resultSet.getString("Rfc"));
					
					return socio;	
				}
			});

			sociosLis = matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de socios que pertenecen a un grupo no solidario para WS", e);
		}		
		return sociosLis;
	}// fin de lista para WS

	

}
