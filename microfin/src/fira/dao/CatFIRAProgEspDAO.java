package fira.dao;

import fira.bean.CatFIRAProgEspBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

public class CatFIRAProgEspDAO extends BaseDAO {

	public List<CatFIRAProgEspBean> lista(int tipoLista, CatFIRAProgEspBean catFIRAProgEspBean) {
		List<CatFIRAProgEspBean> lista=null;
		String query = "CALL CATFIRAPROGESPLIS("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?);";
		Object[] parametros = { 
				tipoLista, 
				catFIRAProgEspBean.getSubPrograma(),
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO, 
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,

				"CatFIRAProgEspDAO.lista", 
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"call CATCADENAPRODUCTIVALIS(" + Arrays.toString(parametros) + ");");
		try{
			List<CatFIRAProgEspBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatFIRAProgEspBean catFIRAProgEspBean2 = new CatFIRAProgEspBean();
					catFIRAProgEspBean2.setClaveProgramaID(resultSet.getString("ClaveProgramaID"));
					catFIRAProgEspBean2.setCveSubProgramaID(resultSet.getString("CveSubProgramaID"));
					catFIRAProgEspBean2.setSubPrograma(resultSet.getString("SubPrograma"));
					return catFIRAProgEspBean2;
				}
			});
			if(matches!=null){
				return matches;
			}
		} catch(Exception ex){
			loggerSAFI.info("Error en CatFIRAProgEspDAO.lista: "+ex.getMessage());
		}
		return lista;
	}

	public CatFIRAProgEspBean consulta(int tipoConsulta, CatFIRAProgEspBean catFIRAProgEspBean) {
		CatFIRAProgEspBean catCadenaProductivaBean3=null;
		String query = "CALL CATFIRAPROGESPCON("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?);";
		Object[] parametros = { 
				tipoConsulta, 
				catFIRAProgEspBean.getCveSubProgramaID(),
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO, 
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"CatFIRAProgEspDAO.consulta", 
				Constantes.ENTERO_CERO, 
				Constantes.ENTERO_CERO 
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "call CATFIRAPROGESPCON(" + Arrays.toString(parametros) + ");");
		try {
			List<CatFIRAProgEspBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CatFIRAProgEspBean catFIRAProgEspBean2 = new CatFIRAProgEspBean();
					catFIRAProgEspBean2.setClaveProgramaID(resultSet.getString("ClaveProgramaID"));
					catFIRAProgEspBean2.setCveSubProgramaID(resultSet.getString("CveSubProgramaID"));
					catFIRAProgEspBean2.setSubPrograma(resultSet.getString("SubPrograma"));
					catFIRAProgEspBean2.setFrenteTecnologico(resultSet.getString("FrenteTecnologico"));
					catFIRAProgEspBean2.setVigente(resultSet.getString("Vigente"));
					return catFIRAProgEspBean2;
				}
			});
			if (matches != null) {
				return catCadenaProductivaBean3 = matches.size() > 0 ? matches.get(0) : null;
			}
		} catch (Exception ex) {
			loggerSAFI.info("Error en CatFIRAProgEspDAO.consulta: " + ex.getMessage());
		}
		return catCadenaProductivaBean3;
	}
}