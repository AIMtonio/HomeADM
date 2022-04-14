package cliente.dao;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import cliente.bean.MotivActivacionBean;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class MotivActivacionDAO extends BaseDAO{

	public MotivActivacionDAO(){
		super();
	}
	
	
	public MotivActivacionBean consultaPrincipal(MotivActivacionBean motivActivaBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call MOTIVACTIVACIONCON(?,?,  ?,?,? ,?,?,? ,?);";
		Object[] parametros = {	
								motivActivaBean.getMotivoActivaID(),
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"MotivActivacion.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MOTIVACTIVACIONCON(" + Arrays.toString(parametros) + ")");
		
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivActivacionBean motivoBean = new MotivActivacionBean();			
					
				motivoBean.setDescripcion(resultSet.getString(1));
				motivoBean.setPermiteReactivacion(resultSet.getString("PermiteReactivacion"));
				motivoBean.setRequiereCobro(resultSet.getString("RequiereCobro"));
				return motivoBean;
	
			}
		});
		return matches.size() > 0 ? (MotivActivacionBean) matches.get(0) : null;
	}

	
	public List listaMotivosActivacion(MotivActivacionBean motivActiva, int tipoLista) {
		//Query con el Store Procedure
		String query = "call MOTIVACTIVACIONLIS(?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	
								motivActiva.getMotivoActivaID(),
								motivActiva.getTipoMovimiento(),
								motivActiva.getDescripcion(),
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"MotivActivacion.listaMotivosActivacion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MOTIVACTIVACIONLIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivActivacionBean motivoBean = new MotivActivacionBean();
				motivoBean.setMotivoActivaID(String.valueOf(resultSet.getInt(1)));
				motivoBean.setDescripcion(resultSet.getString(2));
				return motivoBean;
			}
		});
		return matches;
	}
	
	
	public List listaMotivosActiva(MotivActivacionBean motivActiva, int tipoLista) {
		//Query con el Store Procedure
		String query = "call MOTIVACTIVACIONLIS(?,?,?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	
								motivActiva.getMotivoActivaID(),
								motivActiva.getTipoMovimiento(),
								Constantes.STRING_VACIO,
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"MotivActivacion.listaCombo",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MOTIVACTIVACIONLIS(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivActivacionBean motivoBean = new MotivActivacionBean();
				motivoBean.setMotivoActivaID(String.valueOf(resultSet.getInt(1)));
				motivoBean.setDescripcion(resultSet.getString(2));
				return motivoBean;
			}
		});
		return matches;
	}
}
