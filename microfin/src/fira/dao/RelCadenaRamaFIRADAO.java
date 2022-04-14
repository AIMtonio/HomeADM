package fira.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import fira.bean.RelCadenaRamaFIRABean;

public class RelCadenaRamaFIRADAO extends BaseDAO {

	/**
	 * Método para listar las Relaciones de las Cadena Productiva con las Ramas FIRA
	 * @param tipoLista : Número de Lista
	 * @param RelCadenaRamaFIRABean : {@link RelCadenaRamaFIRABean} Bean con la informacion de la Relacion
	 * @return List<{@link RelCadenaRamaFIRABean}
	 */
	public List<RelCadenaRamaFIRABean> lista(int tipoLista, RelCadenaRamaFIRABean RelCadenaRamaFIRABean) {
		List<RelCadenaRamaFIRABean> lista=null;
		String query = "CALL RELCADENARAMAFIRALIS("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?,?);";
		Object[] parametros = { 
				tipoLista, 
				RelCadenaRamaFIRABean.getCveCadena(),
				RelCadenaRamaFIRABean.getNomCadenaProdSCIAN(),
				RelCadenaRamaFIRABean.getCveRamaFIRA(),
				RelCadenaRamaFIRABean.getDescripcionRamaFIRA(),

				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO, 
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"RelCadenaRamaFIRADAO.lista",

				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call RELCADENARAMAFIRALIS(" + Arrays.toString(parametros) + ");");
		try{
			List<RelCadenaRamaFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RelCadenaRamaFIRABean RelCadenaRamaFIRABean2 = new RelCadenaRamaFIRABean();
					RelCadenaRamaFIRABean2.setCveCadena(resultSet.getString("CveCadena"));
					RelCadenaRamaFIRABean2.setNomCadenaProdSCIAN(resultSet.getString("NomCadenaProdSCIAN"));
					RelCadenaRamaFIRABean2.setCveRamaFIRA(resultSet.getString("CveRamaFIRA"));
					RelCadenaRamaFIRABean2.setDescripcionRamaFIRA(resultSet.getString("DescripcionRamaFIRA"));
					return RelCadenaRamaFIRABean2;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en RelCadenaRamaFIRADAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método para Consultar las Relaciones de la Cande Productiva - Rama FIRA
	 * @param tipoConsulta : Número de Consulta
	 * @param RelCadenaRamaFIRABean : {@link RelCadenaRamaFIRABean} Bean con la Informacion de la Relacion de la Cadena.
	 * @return {@link RelCadenaRamaFIRABean}
	 */
	public RelCadenaRamaFIRABean consulta(int tipoConsulta, RelCadenaRamaFIRABean RelCadenaRamaFIRABean) {
		RelCadenaRamaFIRABean catCadenaProductivaBean3=null;
		String query = "CALL RELCADENARAMAFIRACON("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?);";
		Object[] parametros = { 
				tipoConsulta, 
				RelCadenaRamaFIRABean.getCveCadena(),
				RelCadenaRamaFIRABean.getCveRamaFIRA(),
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO,
				
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"RelCadenaRamaFIRADAO.consulta",
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "call RELCADENARAMAFIRACON(" + Arrays.toString(parametros) + ");");
		try {
			List<RelCadenaRamaFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RelCadenaRamaFIRABean RelCadenaRamaFIRABean2 = new RelCadenaRamaFIRABean();
					RelCadenaRamaFIRABean2.setCveCadena(resultSet.getString("CveCadena"));
					RelCadenaRamaFIRABean2.setNomCadenaProdSCIAN(resultSet.getString("NomCadenaProdSCIAN"));
					RelCadenaRamaFIRABean2.setCveRamaFIRA(resultSet.getString("CveRamaFIRA"));
					RelCadenaRamaFIRABean2.setDescripcionRamaFIRA(resultSet.getString("DescripcionRamaFIRA"));
					return RelCadenaRamaFIRABean2;
				}
			});
			if (matches != null) {
				return catCadenaProductivaBean3 = matches.size() > 0 ? matches.get(0) : null;
			}
		} catch (Exception ex) {
			loggerSAFI.info("Error en RelCadenaRamaFIRADAO.consulta: " + ex.getMessage());
		}
		return catCadenaProductivaBean3;
	}
}
