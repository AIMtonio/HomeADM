package aportaciones.dao;

import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import aportaciones.bean.ConceptosAportacionBean;
import general.dao.BaseDAO;

public class ConceptosAportacionDAO extends BaseDAO{
	
	public ConceptosAportacionDAO() {
		super();
	}
	
	//Lista de Conceptos de Aportaciones	
		public List listaConceptosAportaciones(int tipoLista) {
			//Query con el Store Procedure
			String query = "call CONCEPTOSAPORTACIONLIS(? ,?,?,?,?,?,?,?);";
			Object[] parametros = {	tipoLista,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"listaConceptosAporta.listaConceptosAportaciones",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};		
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSAPORTACIONLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConceptosAportacionBean conceptosAportacion = new ConceptosAportacionBean();			
					conceptosAportacion.setConceptoAportacionID(String.valueOf(resultSet.getInt(1)));
					conceptosAportacion.setDescripcion(resultSet.getString(2));
					return conceptosAportacion;				
				}
			});
					
			return matches;
		}
		
}
