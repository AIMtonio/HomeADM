package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import herramientas.Constantes;

 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import tesoreria.bean.ConceptosDivBean;

import general.dao.BaseDAO;

public class ConceptosDivDAO extends BaseDAO{

	public ConceptosDivDAO (){
		super();
	}

	//Lista de Conceptos de Divisas	
	public List listaConceptosDiv(int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONCEPTOSDIVLIS(?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoLista,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConceptosDivDAO.listaConceptosDiv",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSDIVLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosDivBean conceptosDiv = new ConceptosDivBean();			
				conceptosDiv.setConceptoMonID(String.valueOf(resultSet.getInt(1)));;
				conceptosDiv.setDescripcion(resultSet.getString(2));
				return conceptosDiv;				
			}
		});
				
		return matches;
	}

}

