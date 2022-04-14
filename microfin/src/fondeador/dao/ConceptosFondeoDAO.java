package fondeador.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;

import fondeador.bean.ConceptosFondeoBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class ConceptosFondeoDAO extends BaseDAO{

	public ConceptosFondeoDAO() {
		super();
	}
	//Lista de Conceptos de fondeo
	public List listaConceptosFondeo(int tipoLista) {
		List listaInstit = null;
		try{
		//Query con el Store Procedure
		String query = "call CONCEPTOSFONDEOLIS(? ,?,?,?,?,?,?,?);";
		Object[] parametros = {	
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ConceptosAhorroDAO.listaConceptosAhorro",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSFONDEOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosFondeoBean conceptosFondeo = new ConceptosFondeoBean();			
				conceptosFondeo.setConceptoFondID(String.valueOf(resultSet.getInt(1)));;
				conceptosFondeo.setDescripcion(resultSet.getString(2));
				return conceptosFondeo;				
			}
		});
		listaInstit =  matches;
		}catch(Exception e){
			e.printStackTrace();
		}		
		return listaInstit;
	}

}
