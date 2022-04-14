package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import soporte.bean.ApoyoEscCicloBean;
import soporte.bean.FoliosAplicaBean;
import general.dao.BaseDAO;
import herramientas.Constantes;


public class ApoyoEscCicloDAO extends BaseDAO{
	
	public ApoyoEscCicloDAO() {
		super();
	}
	
	
	/*=============================== METODOS ==================================*/

	/* Lista apoyo ciclo escolar*/
	public List listaPrincipal(ApoyoEscCicloBean apoyoEscCicloBean, int tipoLista) {		
		String query = "call APOYOESCCICLOLIS(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {	
								apoyoEscCicloBean.getApoyoEscCicloID(),
								apoyoEscCicloBean.getDescripcion(),
								tipoLista,
									Constantes.ENTERO_CERO,		//	empresaID
									Constantes.ENTERO_CERO,		//	aud_usuario
									Constantes.FECHA_VACIA,		//	fechaActual
									Constantes.STRING_VACIO,	// 	direccionIP
									Constantes.STRING_VACIO, 	//	programaID
									Constantes.ENTERO_CERO,		// 	sucursal
									Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APOYOESCCICLOLIS(" + Arrays.toString(parametros) +")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ApoyoEscCicloBean apoyoEscCiclo = new ApoyoEscCicloBean();			
				apoyoEscCiclo.setApoyoEscCicloID(resultSet.getString("ApoyoEscCicloID"));
				apoyoEscCiclo.setDescripcion(resultSet.getString("Descripcion"));
				return apoyoEscCiclo;				
			}
		});
				
		return matches;
	}	

}//class
