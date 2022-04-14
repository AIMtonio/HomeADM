package inversiones.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import general.servicio.BaseServicio;
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

import inversiones.bean.ConceptosInverBean;

import javax.sql.DataSource;

public class ConceptosInverDAO  extends BaseDAO {


	public ConceptosInverDAO() {
		super();
	}



	//Lista de Conceptos de Inver	
	public List listaConceptosInver(int tipoLista) {
		//Query con el Store Procedure
		String query = "call CONCEPTOSINVERLIS(? ,?,?,?,?,?,?,?);";
		Object[] parametros = {	tipoLista,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ConceptosInverDAO.listaConceptosInver",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONCEPTOSINVERLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConceptosInverBean conceptosInver = new ConceptosInverBean();			
				conceptosInver.setConceptoInvID(String.valueOf(resultSet.getInt(1)));;
				conceptosInver.setDescripcion(resultSet.getString(2));
				return conceptosInver;				
			}
		});
				
		return matches;
	}


}
