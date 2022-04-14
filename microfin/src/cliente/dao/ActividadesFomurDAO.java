package cliente.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import cliente.bean.ActividadesFomurBean;
import cliente.bean.ClienteBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class ActividadesFomurDAO extends BaseDAO{

	public ActividadesFomurDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
	//Lista de para combo
	public List listaActividadesCombo(ClienteBean actividades, int tipoLista) {

		//Query con el Store Procedure
		List actividadesFomurBean = null;
		try{	
			
		
		String query = "call ACTIVIDADESFOMURLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	actividades.getActividadBancoMX(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ActividadesDAO.listaActividades",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ACTIVIDADESFOMURLIS(" +Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ActividadesFomurBean actividades = new ActividadesFomurBean();			
				actividades.setActividadFOMURID(String.valueOf(resultSet.getString(1)));
				
				actividades.setDescripcion(resultSet.getString(2));
		
				return actividades;
			}
		});
				
		actividadesFomurBean =  matches;
		}catch(Exception e){	
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de actividades combo", e);
		}
		return actividadesFomurBean;
	}
	
	
	
	//Lista de para comboFiltrada
	public List listaActividadesFomurFiltro(ClienteBean actividades, int tipoLista) {
	
		//Query con el Store Procedure
		List actividadesFomurBean = null;
		try{			
		
		String query = "call ACTIVIDADESFOMURLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	actividades.getActividadBancoMX(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ActividadesDAO.listaActividades",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ACTIVIDADESFOMURLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ActividadesFomurBean actividades = new ActividadesFomurBean();			
				actividades.setActividadFOMURID(String.valueOf(resultSet.getString(1)));
		
				actividades.setDescripcion(resultSet.getString(2));
			
				return actividades;
			}
		});
				
		actividadesFomurBean =  matches;
		}catch(Exception e){	
			e.printStackTrace();
		}
		return actividadesFomurBean;
	}

}
