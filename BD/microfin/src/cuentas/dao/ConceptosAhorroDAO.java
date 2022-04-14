package cuentas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cuentas.bean.ConceptosAhorroBean;

import javax.sql.DataSource;

public class ConceptosAhorroDAO extends BaseDAO {

	public ConceptosAhorroDAO() {
		super();
	}
	//Lista de Conceptos de Ahorro	
	public List listaConceptosAhorro(int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONCEPTOSAHORROLIS(? ,?,?,?,?,?,?,?);";
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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSAHORROLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosAhorroBean conceptosAhorro = new ConceptosAhorroBean();			
				conceptosAhorro.setConceptoAhoID(String.valueOf(resultSet.getInt(1)));;
				conceptosAhorro.setDescripcion(resultSet.getString(2));
				return conceptosAhorro;				
			}
		});
				
		return matches;
	}

}
