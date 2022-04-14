package fira.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import fira.bean.CatTipoGarantiaFIRABean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class CatTipoGarantiaFIRADAO extends BaseDAO {

	/**
	 * Método para listar los Tipos de Garantia FIRA para los Creditos agropecuarios
	 * @param tipoLista : Número de Lista 
	 * @param catTipoGarantiaFIRABean : {@link CatTipoGarantiaFIRABean} con la descripción de la lista
	 * @return List<{@link CatTipoGarantiaFIRABean}>
	 */
	public List<CatTipoGarantiaFIRABean> lista(int tipoLista, CatTipoGarantiaFIRABean catTipoGarantiaFIRABean) {
		List<CatTipoGarantiaFIRABean> lista=null;
		String query = "CALL CATTIPOGARANTIAFIRALIS("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?);";
		Object[] parametros = { 
				tipoLista, 
				catTipoGarantiaFIRABean.getDescripcion(),
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO, 
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"CatTipoGarantiaFIRADAO.lista", 
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call CATTIPOGARANTIAFIRALIS(" + Arrays.toString(parametros) + ");");
		try{
			List<CatTipoGarantiaFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatTipoGarantiaFIRABean catTipoGarantiaFIRABean2 = new CatTipoGarantiaFIRABean();
					catTipoGarantiaFIRABean2.setTipoGarantiaID(resultSet.getString("TipoGarantiaID"));
					catTipoGarantiaFIRABean2.setDescripcion(resultSet.getString("Descripcion"));
					return catTipoGarantiaFIRABean2;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en CatTipoGarantiaFIRADAO.lista: "+ex.getMessage());
		}
		return lista;
	}
}
