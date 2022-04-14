package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import pld.bean.EstadosPreocupantesBean;
 
import cuentas.bean.TiposCuentaBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class EstadosPreocupantesDAO extends BaseDAO {

	public EstadosPreocupantesDAO() {
		super();
	}
	
	
	//Lista para combo
		public List listaPrincipal(int tipoLista) {
			//Query con el Store Procedure
			String query = "call PLDCATEDOSPREOLIS(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {	"",tipoLista,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"EstadosPreocupantesDAO.listaTiposCuentas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};		
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATEDOSPREOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EstadosPreocupantesBean edos = new EstadosPreocupantesBean();
					edos.setCatEdosPreoID(String.valueOf(resultSet.getString(1))); 
					edos.setDescripcion(resultSet.getString(2));
					return edos;					
				}
			});
					
			return matches;
		}
}
