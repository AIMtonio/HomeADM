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

import arrendamiento.bean.MarcaActivoBean;

public class MarcaActivoDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	
	public MarcaActivoDAO(){
		super();
	}
	
	/**
	 * Consulta principal de Marcas de activos por ID(C1)
	 * @param marcaActivoBean
	 * @param tipoConsulta
	 * @return
	 */
	public MarcaActivoBean consultaMarcaActivo(MarcaActivoBean marcaActivoBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ARRMARCAACTIVOCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	
				marcaActivoBean.getMarcaID(),	
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"MarcaActivoDAO.consultaMarcaActivo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRMARCAACTIVOCON(  " + Arrays.toString(parametros) + ")");
		List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MarcaActivoBean marcaActivoBean = new MarcaActivoBean();
				try{
					marcaActivoBean.setMarcaID(resultSet.getString("MarcaID"));
					marcaActivoBean.setTipoActivo(resultSet.getString("TipoActivo"));
					marcaActivoBean.setDescripcion(resultSet.getString("Descripcion"));
					marcaActivoBean.setEstatus(resultSet.getString("Estatus"));
									
				} catch(Exception ex){
					ex.printStackTrace();
				}
			    return marcaActivoBean;
			}
		});
		return matches.size() > 0 ? (MarcaActivoBean) matches.get(0) : null;
	}
	
	/**
	 * Lista de marcas de activos (L1)
	 * @param marcaActivoBean
	 * @param tipoLista
	 * @return
	 */
	public List listaMarcasActivo(MarcaActivoBean marcaActivoBean, int tipoLista){
		List marcas = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRMARCAACTIVOLIS(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {marcaActivoBean.getMarcaID(),
									tipoLista,
																		
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"MarcaActivoDAO.listaMarcasActivo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRMARCAACTIVOLIS(" + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MarcaActivoBean marcaActivoBean = new MarcaActivoBean();					
					marcaActivoBean.setMarcaID(resultSet.getString("MarcaID"));
					marcaActivoBean.setDescripcion(resultSet.getString("Descripcion"));
					return marcaActivoBean;
				}
			});
			return marcas = matches.size() > 0 ? matches: null;
			
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la lista de Marcas de Activos.", e);
			e.printStackTrace();			
		}
		return marcas;	
	}
	
	//---------- Getter y Setters ------------------------------------------------------------------------
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
