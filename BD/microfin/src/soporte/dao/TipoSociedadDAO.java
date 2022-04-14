package soporte.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import soporte.bean.TipoSociedadBean;
 
public class TipoSociedadDAO extends BaseDAO{

	
	public TipoSociedadDAO() {
		super();
	}
	
	// ------------------ Transacciones ------------------------------------------
	
	//consulta principal de Tipos de  Sociedad
		public TipoSociedadBean consultaPrincipal(TipoSociedadBean sociedad, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPOSOCIEDADCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	sociedad.getTipoSociedadID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoSociedadDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSOCIEDADCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoSociedadBean sociedad = new TipoSociedadBean();
					
				sociedad.setTipoSociedadID(Utileria.completaCerosIzquierda(resultSet.getInt(1),3));
				sociedad.setDescripcion(resultSet.getString(2));
			
					return sociedad;
	
			}
		});
		return matches.size() > 0 ? (TipoSociedadBean) matches.get(0) : null;
				
	}
		
		// consulta foranea de Tipos de  Sociedad
		public TipoSociedadBean consultaForanea(TipoSociedadBean sociedad, int tipoConsulta) {
			//Query con el Store Procedure
			String query = "call TIPOSOCIEDADCON(?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	sociedad.getTipoSociedadID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"TipoSociedadDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSOCIEDADCON(" + Arrays.toString(parametros) +")");
					
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TipoSociedadBean sociedad = new TipoSociedadBean();
						
					sociedad.setTipoSociedadID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt(1),3)));
					sociedad.setDescripcion(resultSet.getString(2));			
					
						return sociedad;
		
				}
			});
			return matches.size() > 0 ? (TipoSociedadBean) matches.get(0) : null;
					
		}
	
	

		
	
	//Lista de Tipos de  Sociedad
	public List listaTiposSociedad(TipoSociedadBean sociedad, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPOSOCIEDADLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	sociedad.getDescripcion(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TipoSociedadDAO.listaTiposDirec",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSOCIEDADLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				TipoSociedadBean sociedad = new TipoSociedadBean();
				sociedad.setTipoSociedadID(Utileria.completaCerosIzquierda(resultSet.getInt(1),3));
				sociedad.setDescripcion(resultSet.getString(2));					
				return sociedad;				
			}
		});
				
		return matches;
	}
	
}
