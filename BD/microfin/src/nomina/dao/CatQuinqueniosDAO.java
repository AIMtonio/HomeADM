package nomina.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;


import nomina.bean.CatQuinqueniosBean;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

public class CatQuinqueniosDAO extends BaseDAO {
	public List<?> listaPrincipal(int tipoLista, CatQuinqueniosBean catQuinqueniosBean) {
		List<?> lista = null;
		try {
			String query = "CALL CATQUINQUENIOSLIS (?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {
					catQuinqueniosBean.getDescripcion(),
					catQuinqueniosBean.getDescripcionCorta(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CatQuinqueniosDAO.listaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CATQUINQUENIOSLIS (" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatQuinqueniosBean resultado = new CatQuinqueniosBean();
					resultado.setQuinquenioID(resultSet.getString("QuinquenioID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					resultado.setDescripcionCorta(resultSet.getString("DescripcionCorta"));

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de catalogo de QUINQUENIOS", e);
		}
		return lista;
	}
	
	
	
	public CatQuinqueniosBean consultaPrincipal(int tipoConsulta, CatQuinqueniosBean catQuinqueniosBean) {
		CatQuinqueniosBean registro = null;
		try {
			String query = "CALL CATQUINQUENIOSCON (?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(catQuinqueniosBean.getQuinquenioID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CatQuinqueniosDAO.listaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL CATQUINQUENIOSCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatQuinqueniosBean resultado = new CatQuinqueniosBean();

					resultado.setQuinquenioID(resultSet.getString("QuinquenioID"));
					resultado.setDescripcion(resultSet.getString("Descripcion"));
					resultado.setDescripcionCorta(resultSet.getString("DescripcionCorta"));

					return resultado;
				}
			});
			registro = matches.size() > 0 ? (CatQuinqueniosBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de QUINQUENIOS", e);
		}
		return registro;
	}
	
	
	
}
