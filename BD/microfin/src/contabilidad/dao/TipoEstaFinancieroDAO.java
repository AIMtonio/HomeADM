package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;

import contabilidad.bean.TipoEstaFinancieroBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class TipoEstaFinancieroDAO extends BaseDAO{

	public List listatipoEstadoFinan(
			TipoEstaFinancieroBean tipoEstaFinancieroBean, int tipoLista) {
		// TODO Auto-generated method stub
		String query = "call TIPOSESTADFINANLIS(?,?,?,?,?,  ?,?,?,?);";
		Object[] parametros = {	
						tipoEstaFinancieroBean.getDescripcion(),
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"TipoEstaFinancieroDAO.listatipoEstadoFinan",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
		
	

		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSESTADFINANLIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoEstaFinancieroBean tipoEstaFinanciero = new TipoEstaFinancieroBean();
				tipoEstaFinanciero.setEstadoFinanID(String.valueOf(resultSet.getInt("EstadoFinanID")));
				tipoEstaFinanciero.setDescripcion(resultSet.getString("Descripcion"));
				
				
				return tipoEstaFinanciero;
				
			}
		});
				
		return matches;
}
}
