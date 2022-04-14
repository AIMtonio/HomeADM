package soporte.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import soporte.bean.CompaniaBean;
import soporte.bean.UsuarioBean;



public class CompaniaDAO extends BaseDAO{
	public CompaniaDAO() {
		super();
	}
	
	
	/* Consulta de Usuario: Para Pantalla de Login */
	public CompaniaBean consultaPorClave(UsuarioBean usuarioBean, int tipoConsulta) {
		//Query con el Store Procedure
		CompaniaBean companiaBean = null;
		String query = "call COMPANIACON(?,?,?,?,?,	?,?,?);";
		Object[] parametros = {	tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								
								"UsuarioDAO.consultaPorClave",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(usuarioBean.getOrigenDatos()+"-"+"call COMPANIACON(" + Arrays.toString(parametros) +")");
		
		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(usuarioBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CompaniaBean companiaBean = new CompaniaBean();				
					companiaBean.setNombre(resultSet.getString("Nombre"));				
					companiaBean.setLogoCtePantalla(resultSet.getString("LogoCtePantalla"));
					return companiaBean;
				}
			});
			
			companiaBean = matches.size() > 0 ? (CompaniaBean) matches.get(0) : null; 
			companiaBean.setOrigenDatos(usuarioBean.getOrigenDatos());
			
		}catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de logo", e);
		}
		
			
		return companiaBean;
				
	}
}
