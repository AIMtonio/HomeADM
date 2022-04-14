package originacion.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import originacion.bean.FrecuenciaBean;

public class CatFrecuenciasDAO extends BaseDAO{

	/**
	 * Lista las frecuencias de los productos de crédito
	 * @param tipoLista
	 * @param frecuenciaBean
	 * @return
	 */
	public List<FrecuenciaBean> listaFrecuencias(int tipoLista, FrecuenciaBean frecuenciaBean) {
		String query = "call CATFRECUENCIALIS(" +
				"?,?,?,?,?,     " +
				"?,?,?,?,?);";
		Object[] parametros = {	
								frecuenciaBean.getProducCreditoID(),
								Constantes.STRING_VACIO,
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATFRECUENCIALIS(" + Arrays.toString(parametros) + ")");
		List<FrecuenciaBean> matches;
		try{
			matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FrecuenciaBean frecuencia = new FrecuenciaBean();			
					frecuencia.setFrecuenciaID(resultSet.getString("FrecuenciaID"));
					frecuencia.setOrden(resultSet.getString("Orden"));
					frecuencia.setDias(resultSet.getString("Dias"));
					frecuencia.setDescSingular(resultSet.getString("DescSingular"));
					frecuencia.setDescInfinitivo(resultSet.getString("DescInfinitivo"));
					return frecuencia;				
				}
			});
		}
		catch(Exception ex){
			ex.printStackTrace();
			matches=new ArrayList<FrecuenciaBean>();
		}
					
		return matches;
	}
}
