package cliente.dao;
 
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import cliente.bean.ActividadesBMXBean;
import cliente.bean.ActividadesCompletaBean;
import cliente.bean.ActividadesFRBean;
import cliente.bean.ClienteBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class ActividadesFRDAO extends BaseDAO{
	
	
	public ActividadesFRDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	//Lista de para combo
	public List listaActividadesCombo(ClienteBean actividades, int tipoLista) {
		//Query con el Store Procedure
		List actividadesFRBean = null;
		try{	
			
		
		String query = "call ACTIVIDADESFRLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	actividades.getActividadBancoMX(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ActividadesDAO.listaActividades",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ACTIVIDADESFRLIS (" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ActividadesFRBean actividades = new ActividadesFRBean();			
				actividades.setActividadFRID(String.valueOf(resultSet.getString(1)));
				actividades.setDescripcion(resultSet.getString(2));
				return actividades;				
			}
		});
				
		actividadesFRBean =  matches;
		}catch(Exception e){	
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error del DAO en la lista ", e);
			
			
			
		}
		return actividadesFRBean;
	}
	
	
	
	//Lista de para comboFiltrada
	public List listaActividadesFRFiltro(ClienteBean actividades, int tipoLista) {
		//Query con el Store Procedure
		List actividadesFRBean = null;
		try{	
			
		
		String query = "call ACTIVIDADESFRLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	actividades.getActividadBancoMX(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ActividadesDAO.listaActividades",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ACTIVIDADESFRLIS(" + Arrays.toString(parametros) + ")");		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ActividadesFRBean actividades = new ActividadesFRBean();			
				actividades.setActividadFRID(String.valueOf(resultSet.getString(1)));
				
				actividades.setDescripcion(resultSet.getString(2));
				
				return actividades;				
			}
		});
				
		actividadesFRBean =  matches;
		}catch(Exception e){	
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el filtro de lista", e);
			e.printStackTrace();
		}
		return actividadesFRBean;
	}
}
