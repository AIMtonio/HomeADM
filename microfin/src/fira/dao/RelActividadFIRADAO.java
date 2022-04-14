package fira.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import fira.bean.RelActividadFIRABean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class RelActividadFIRADAO extends BaseDAO {

	/**
	 * Método para listar las Activiadades FIRA
	 * @param tipoLista : Número de Lista
	 * @param RelCadenaSubRamaFIRABean : {@link RelActividadFIRABean} Bean con la informacion de la Relacion
	 * @return List<{@link RelActividadFIRABean}
	 */
	public List<RelActividadFIRABean> lista(int tipoLista, RelActividadFIRABean relActividadFIRABean) {
		List<RelActividadFIRABean> lista=null;
		String query = "CALL RELACTIVIDADFIRALIS("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?,?,?);";
		Object[] parametros = { 
				tipoLista, 
				relActividadFIRABean.getCveCadena(),
				relActividadFIRABean.getCveRamaFIRA(),
				relActividadFIRABean.getCveSubramaFIRA(),
				relActividadFIRABean.getCveActividadFIRA(),
				
				relActividadFIRABean.getDesActividadFIRA(),
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO, 
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"RelActividadFIRADAO.lista",
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call RELACTIVIDADFIRALIS(" + Arrays.toString(parametros) + ");");
		try{
			List<RelActividadFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RelActividadFIRABean subrama = new RelActividadFIRABean();
					subrama.setCveCadena(resultSet.getString("CveCadena"));
					subrama.setCveRamaFIRA(resultSet.getString("CveRamaFIRA"));
					subrama.setCveSubramaFIRA(resultSet.getString("CveSubramaFIRA"));
					subrama.setCveActividadFIRA(resultSet.getString("CveActividadFIRA"));
					subrama.setDesActividadFIRA(resultSet.getString("DesActividadFIRA"));
					return subrama;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en RelActividadFIRADAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	/**
	 * Método para Consultar las Relaciones las Actividades FIRA
	 * @param tipoConsulta : Número de Consulta
	 * @param RelCadenaSubRamaFIRABean : {@link RelActividadFIRABean} Bean con la Informacion de la Relacion de la Actividad
	 * @return {@link RelActividadFIRABean}
	 */
	public RelActividadFIRABean consulta(int tipoConsulta, RelActividadFIRABean RelCadenaSubRamaFIRABean) {
		RelActividadFIRABean relsubrama=null;
		String query = "CALL RELACTIVIDADFIRACON("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?,?);";
		Object[] parametros = { 
				tipoConsulta, 
				RelCadenaSubRamaFIRABean.getCveCadena(),
				RelCadenaSubRamaFIRABean.getCveRamaFIRA(),
				RelCadenaSubRamaFIRABean.getCveSubramaFIRA(),
				RelCadenaSubRamaFIRABean.getCveActividadFIRA(),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"RelActividadFIRADAO.consulta",
				Constantes.ENTERO_CERO,

				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "call RELACTIVIDADFIRACON(" + Arrays.toString(parametros) + ");");
		try {
			List<RelActividadFIRABean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RelActividadFIRABean subrama = new RelActividadFIRABean();
					subrama.setCveCadena(resultSet.getString("CveCadena"));
					subrama.setCveRamaFIRA(resultSet.getString("CveRamaFIRA"));
					subrama.setCveSubramaFIRA(resultSet.getString("CveSubramaFIRA"));
					subrama.setCveActividadFIRA(resultSet.getString("CveActividadFIRA"));
					subrama.setDesActividadFIRA(resultSet.getString("DesActividadFIRA"));
					return subrama;
				}
			});
			if (matches != null) {
				return relsubrama = matches.size() > 0 ? matches.get(0) : null;
			}
		} catch (Exception ex) {
			loggerSAFI.info("Error en RelActividadFIRADAO.consulta: " + ex.getMessage());
		}
		return relsubrama;
	}
}
