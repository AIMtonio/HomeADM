package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
 
import credito.bean.ConceptosCarteraBean;

import general.dao.BaseDAO;
import herramientas.Constantes;

public class ConceptosCarteraDAO extends BaseDAO{
	
	public ConceptosCarteraDAO(){
		super();
	}
	
	public List listaConceptosCartera(int tipoLista){
		String query = "call CONCEPTOSCARTERALIS(?,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoLista,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConceptosCarteraDAO.listaConceptosDiv",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSCARTERALIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosCarteraBean conceptosCartera = new ConceptosCarteraBean();
				conceptosCartera.setConceptoCarID(resultSet.getString(1));
				conceptosCartera.setDescripcion(resultSet.getString(2));
				return conceptosCartera;
			}
		});	
		
		return matches;
	}

}
