package fira.dao;

import fira.bean.CatCadenaProductivaBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

public class CatCadenaProductivaDAO extends BaseDAO {

	/**
	 * Método para Listar las Cadenas Productivas para los Créditos Agropecuarios
	 * @param tipoLista : Número de Lista
	 * @param CatCadenaProductivaBean : {@link CatCadenaProductivaBean} Bean con el nombre de la Cadena Productiva
	 * @return List<{@link CatCadenaProductivaBean}>
	 */
	public List<CatCadenaProductivaBean> lista(int tipoLista, CatCadenaProductivaBean CatCadenaProductivaBean) {
		List<CatCadenaProductivaBean> lista=null;
		String query = "CALL CATCADENAPRODUCTIVALIS("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?);";
		Object[] parametros = { 
				tipoLista, 
				CatCadenaProductivaBean.getNomCadenaProdSCIAN(),
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO, 
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"CatTipoGarantiaFIRADAO.lista", 
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call CATCADENAPRODUCTIVALIS(" + Arrays.toString(parametros) + ");");
		try{
			List<CatCadenaProductivaBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatCadenaProductivaBean CatCadenaProductivaBean2 = new CatCadenaProductivaBean();
					CatCadenaProductivaBean2.setCveCadena(resultSet.getString("CveCadena"));
					CatCadenaProductivaBean2.setNomCadenaProdSCIAN(resultSet.getString("NomCadenaProdSCIAN"));
					return CatCadenaProductivaBean2;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en CatCadenaProductivaDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método para consultar las Cadenas Productivas SCIA
	 * @param tipoConsulta : Tipo de Consulta 
	 * @param CatCadenaProductivaBean : {@link CatCadenaProductivaBean} Trae la Clave de la CAdena Productiva a consultar
	 * @return {@link CatCadenaProductivaBean}
	 */
	public CatCadenaProductivaBean consulta(int tipoConsulta, CatCadenaProductivaBean CatCadenaProductivaBean) {
		CatCadenaProductivaBean catCadenaProductivaBean3=null;
		String query = "CALL CATCADENAPRODUCTIVACON("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?);";
		Object[] parametros = { 
				tipoConsulta, 
				CatCadenaProductivaBean.getCveCadena(),
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO, 
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"CatTipoGarantiaFIRADAO.consulta", 
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "call CATCADENAPRODUCTIVACON(" + Arrays.toString(parametros) + ");");
		try {
			List<CatCadenaProductivaBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatCadenaProductivaBean CatCadenaProductivaBean2 = new CatCadenaProductivaBean();
					CatCadenaProductivaBean2.setCveCadena(resultSet.getString("CveCadena"));
					CatCadenaProductivaBean2.setNomCadenaProdSCIAN(resultSet.getString("NomCadenaProdSCIAN"));
					return CatCadenaProductivaBean2;
				}
			});
			if (matches != null) {
				return catCadenaProductivaBean3 = matches.size() > 0 ? matches.get(0) : null;
			}
		} catch (Exception ex) {
			loggerSAFI.info("Error en CatCadenaProductivaDAO.consulta: " + ex.getMessage());
		}
		return catCadenaProductivaBean3;
	}
}
