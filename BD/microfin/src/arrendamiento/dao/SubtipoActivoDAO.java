package arrendamiento.dao;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import arrendamiento.bean.SubtipoActivoBean;

public class SubtipoActivoDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	
	public SubtipoActivoDAO(){
		super();
	}
	
	/**
	 * Consulta principal de subtipos por ID (C1)
	 * @param subtipoActivoBean
	 * @param tipoConsulta
	 * @return subtipoActivoBean
	 */
	public SubtipoActivoBean consultaSubtipoActivo(SubtipoActivoBean subtipoActivoBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ARRCSUBTIPOACTIVOCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	
				subtipoActivoBean.getSubtipoActivoID(),	
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SubtipoActivoDAO.consultaSubtipoActivo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRCSUBTIPOACTIVOCON(  " + Arrays.toString(parametros) + ")");
		List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SubtipoActivoBean subtipoActivo = new SubtipoActivoBean();
				try{
					subtipoActivo.setSubtipoActivoID(resultSet.getString("SubtipoActivoID"));
					subtipoActivo.setDescripcion(resultSet.getString("Descripcion"));
					subtipoActivo.setEstatus(resultSet.getString("Estatus"));
									
				} catch(Exception ex){
					ex.printStackTrace();
				}
			    return subtipoActivo;
			}
		});
		return matches.size() > 0 ? (SubtipoActivoBean) matches.get(0) : null;
	}
	
	/**
	 * Lista de subtipos (L1)
	 * @param subtipoActivoBean
	 * @param tipoLista
	 * @return
	 */
	public List listaSubtiposActivo(SubtipoActivoBean subtipoActivoBean, int tipoLista){
		List subtipos = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRCSUBTIPOACTIVOLIS(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {subtipoActivoBean.getSubtipoActivoID(),
									tipoLista,
																		
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SubtipoActivoDAO.listaSubtiposActivo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRCSUBTIPOACTIVOLIS(" + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SubtipoActivoBean subtipoActivo = new SubtipoActivoBean();			
					subtipoActivo.setSubtipoActivoID(resultSet.getString("SubtipoActivoID"));
					subtipoActivo.setDescripcion(resultSet.getString("Descripcion"));
					return subtipoActivo;
				}
			});
			return subtipos = matches.size() > 0 ? matches: null;
			
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la lista de Subtipos.", e);
			e.printStackTrace();			
		}
		return subtipos;	
	}
	
	//---------- Getter y Setters ------------------------------------------------------------------------
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
