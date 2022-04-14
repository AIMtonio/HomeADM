package cliente.dao;
import general.dao.BaseDAO;
import herramientas.Constantes;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.CatUbicaNegocioBean;


public class CatUbicaNegocioDAO extends BaseDAO{
	
	public CatUbicaNegocioDAO() {
		super();
	}
	
	
	/*=============================== METODOS ==================================*/

	/* Lista el catalogo de ubicacion de negocios*/
	public List listaPrincipal(CatUbicaNegocioBean bean, int tipoLista) {		
		String query = "call CATUBICANEGOCIOLIS(?,?,?,	 ?,?,?,?,?);";
		Object[] parametros = {	
									tipoLista,
									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATUBICANEGOCIOLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CatUbicaNegocioBean beanResultado = new CatUbicaNegocioBean();			
				beanResultado.setUbicaNegocioID(resultSet.getString("UbicaNegocioID"));
				beanResultado.setUbicacion(resultSet.getString("Ubicacion"));
				return beanResultado;				
			}
		});
				
		return matches;
	}	

}//class
