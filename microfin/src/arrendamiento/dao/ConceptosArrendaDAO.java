package arrendamiento.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import arrendamiento.bean.ConceptosArrendaBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class ConceptosArrendaDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	Logger log = Logger.getLogger( this.getClass() );

	public ConceptosArrendaDAO() {
		super();
	}

	//Lista de Conceptos de fondeo
	public List listaConceptosArrenda(int tipoLista) {
		List listaInstit = null;
		try{
		//Query con el Store Procedure
		String query = "call CONCEPTOSARRENDALIS(" +
				"?,?,?,?,?, ?,?,?);";
		Object[] parametros = {	
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"ConceptosArrendaDAO.CONCEPTOSARRENDALIS",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSARRENDALIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosArrendaBean conceptos = new ConceptosArrendaBean();			
				conceptos.setConceptoArrendaID(resultSet.getString("ConceptoArrendaID"));;
				conceptos.setDescripcion(resultSet.getString("Descripcion"));
				return conceptos;				
			}
		});
		listaInstit =  matches;
		}catch(Exception e){
			e.printStackTrace();
		}		
		return listaInstit;
	}	

	
}
