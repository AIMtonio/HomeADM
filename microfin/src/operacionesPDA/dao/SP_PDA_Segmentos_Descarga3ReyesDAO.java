package operacionesPDA.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import operacionesPDA.beanWS.request.SP_PDA_Segmentos_DescargaRequest;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import cliente.bean.PromotoresBean;

public class SP_PDA_Segmentos_Descarga3ReyesDAO extends BaseDAO {

	 
	//Lista de Promotores que pertenecen a una Sucursal WS Segmentos
	public List listaPromSucur(SP_PDA_Segmentos_DescargaRequest bean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PROMOTORESLIS(?,?,?,?,?,  ?,?,?,?,?);";
		Object[] parametros = {	
				Constantes.STRING_CERO,
				Utileria.convierteEntero(bean.getId_Sucursal()),
				tipoLista,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_CERO,
				"SP_PDA_Promotores_DescargaDAO.lisPromotoresWS",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROMOTORESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {	
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PromotoresBean promotores = new PromotoresBean();	
				
				promotores.setPromotorID(String.valueOf(resultSet.getInt("Id_Segmento")));;
				promotores.setNombrePromotor(resultSet.getString("descSegmento"));
				
				return promotores;				
			}
		});
		return matches;
		}
	
}
