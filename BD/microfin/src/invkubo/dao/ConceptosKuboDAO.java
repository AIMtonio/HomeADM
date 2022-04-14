package invkubo.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import invkubo.bean.ConceptosKuboBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;


import general.dao.BaseDAO;
import herramientas.Constantes;
 
public class ConceptosKuboDAO extends BaseDAO{

	public ConceptosKuboDAO() {
		super();
	}

	
	//Lista de Conceptos de Kubo	
	public List listaConceptosKubo(int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONCEPTOSKUBOLIS(?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoLista,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConceptosKuboDAO.listaConceptosKubo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSKUBOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosKuboBean conceptosKubo = new ConceptosKuboBean();			
				conceptosKubo.setConceptoKuboID(String.valueOf(resultSet.getInt(1)));;
				conceptosKubo.setDescripcion(resultSet.getString(2));
				return conceptosKubo;				
			}
		});
				
		return matches;
	}
}
