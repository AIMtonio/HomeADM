package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import soporte.bean.FoliosAplicaBean;

public class FoliosAplicaDAO extends BaseDAO {
 
	public FoliosAplicaDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// ------------------ Transacciones ------------------------------------------
		
	/* Consuta Creditos por Llave Principal */
	public FoliosAplicaBean consultaFolioAplicacion(FoliosAplicaBean foliosAplicaBean, int tipoConsulta) {
				// Query con el Store Procedure
		String query = "call FOLIOSAPLICACON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { foliosAplicaBean.getTabla(), 
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA, 
								Constantes.STRING_VACIO,
								"consultaFolioAplicacion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FOLIOSAPLICACON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				FoliosAplicaBean foliosAplicaBean = new FoliosAplicaBean();
				foliosAplicaBean.setFolio(String.valueOf(resultSet.getString(1)));
				return foliosAplicaBean;
			}
		});
		return matches.size() > 0 ? (FoliosAplicaBean) matches.get(0) : null;
	}
	
	
}
