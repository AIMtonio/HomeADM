package cedes.dao;

import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cedes.bean.ConceptosCedeBean;
import general.dao.BaseDAO;

public class ConceptosCedeDAO extends BaseDAO{
	
	public ConceptosCedeDAO() {
		super();
	}
	 
	//Lista de Conceptos de Inver	
	public List listaConceptosCedes(int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONCEPTOSCEDELIS(? ,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoLista,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"listaConceptosCedes.listaConceptosCedes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSCEDELIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosCedeBean conceptosCede = new ConceptosCedeBean();			
				conceptosCede.setConceptoCedeID(String.valueOf(resultSet.getInt(1)));
				conceptosCede.setDescripcion(resultSet.getString(2));
				return conceptosCede;				
			}
		});
				
		return matches;
	}
	
}
