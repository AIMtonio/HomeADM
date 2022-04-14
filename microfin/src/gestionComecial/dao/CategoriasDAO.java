package gestionComecial.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import gestionComecial.bean.AreasBean;
import gestionComecial.bean.CategoriasBean;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

public class CategoriasDAO extends BaseDAO{
	
	public CategoriasDAO() {
		super();
	}
	
	public List listaAlfanumerica(CategoriasBean categoriasBean, int tipoLista){
		String query = "call CATEGORIAPTOLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				
					categoriasBean.getDescripcion(),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CategoriasDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATEGORIAPTOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CategoriasBean categoriasBean = new CategoriasBean();
				categoriasBean.setCategoriaID(resultSet.getString(1));
				categoriasBean.setDescripcion(resultSet.getString(2));
				return categoriasBean;
				
			}
		});
		return matches;
		}
		
	
	
}
