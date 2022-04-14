package fira.dao;

import fira.bean.RelSubRamaFIRABean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

public class RelSubRamaFIRADAO extends BaseDAO {

	/**
	 * Método para listar las Sub Ramas FIRA
	 * @param tipoLista : Número de Lista
	 * @param RelCadenaSubRamaFIRABean : {@link RelSubRamaFIRABean} Bean con la informacion de la Relacion
	 * @return List<{@link RelSubRamaFIRABean}
	 */
	public List<RelSubRamaFIRABean> lista(int tipoLista, RelSubRamaFIRABean RelCadenaSubRamaFIRABean) {
		List<RelSubRamaFIRABean> lista=null;
		String query = "CALL RELSUBRAMAFIRALIS("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?,?);";
		Object[] parametros = { 
				tipoLista, 
				RelCadenaSubRamaFIRABean.getCveCadena(),
				RelCadenaSubRamaFIRABean.getCveRamaFIRA(),
				RelCadenaSubRamaFIRABean.getCveSubramaFIRA(),
				RelCadenaSubRamaFIRABean.getDescSubramaFIRA(),

				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO, 
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"RelSubRamaFIRADAO.lista",

				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call RELSUBRAMAFIRALIS(" + Arrays.toString(parametros) + ");");
		try{
			List<RelSubRamaFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RelSubRamaFIRABean subrama = new RelSubRamaFIRABean();
					subrama.setCveCadena(resultSet.getString("CveCadena"));
					subrama.setCveRamaFIRA(resultSet.getString("CveRamaFIRA"));
					subrama.setCveSubramaFIRA(resultSet.getString("CveSubramaFIRA"));
					subrama.setDescSubramaFIRA(resultSet.getString("DescSubramaFIRA"));
					return subrama;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en RelSubRamaFIRADAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método para Consultar las Relaciones de l subrama FIRA
	 * @param tipoConsulta : Número de Consulta
	 * @param RelCadenaSubRamaFIRABean : {@link RelSubRamaFIRABean} Bean con la Informacion de la Relacion de la Subrama.
	 * @return {@link RelSubRamaFIRABean}
	 */
	public RelSubRamaFIRABean consulta(int tipoConsulta, RelSubRamaFIRABean RelCadenaSubRamaFIRABean) {
		RelSubRamaFIRABean relsubrama=null;
		String query = "CALL RELSUBRAMAFIRACON("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?);";
		Object[] parametros = { 
				tipoConsulta, 
				RelCadenaSubRamaFIRABean.getCveCadena(),
				RelCadenaSubRamaFIRABean.getCveRamaFIRA(),
				RelCadenaSubRamaFIRABean.getCveSubramaFIRA(),
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"RelSubRamaFIRADAO.consulta",
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "call RELSUBRAMAFIRACON(" + Arrays.toString(parametros) + ");");
		try {
			List<RelSubRamaFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RelSubRamaFIRABean subrama = new RelSubRamaFIRABean();
					subrama.setCveCadena(resultSet.getString("CveCadena"));
					subrama.setCveRamaFIRA(resultSet.getString("CveRamaFIRA"));
					subrama.setCveSubramaFIRA(resultSet.getString("CveSubramaFIRA"));
					subrama.setDescSubramaFIRA(resultSet.getString("DescSubramaFIRA"));
					return subrama;
				}
			});
			if (matches != null) {
				return relsubrama = matches.size() > 0 ? matches.get(0) : null;
			}
		} catch (Exception ex) {
			loggerSAFI.info("Error en RelSubRamaFIRADAO.consulta: " + ex.getMessage());
		}
		return relsubrama;
	}
}
