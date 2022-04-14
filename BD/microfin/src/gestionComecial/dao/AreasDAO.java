package gestionComecial.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import general.dao.BaseDAO;
import gestionComecial.bean.AreasBean;
import gestionComecial.bean.EmpleadosBean;

public class AreasDAO extends BaseDAO{
	
	public AreasDAO() {
		super();
	}
	
	public List listaAlfanumerica(AreasBean areasBean, int tipoLista){
		String query = "call AREASLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				
					areasBean.getDescripcion(),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"AreasDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AREASLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AreasBean areasBean = new AreasBean();
				areasBean.setAreaID(resultSet.getString(1));
				areasBean.setDescripcion(resultSet.getString(2));
				return areasBean;
				
			}
		});
		return matches;
		}
		
	
	
}
