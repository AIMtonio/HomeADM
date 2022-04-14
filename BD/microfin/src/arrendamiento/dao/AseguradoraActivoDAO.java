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

import arrendamiento.bean.AseguradoraActivoBean;

public class AseguradoraActivoDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	
	public AseguradoraActivoDAO(){
		super();
	}
	
	/**
	 * Consulta principal por ID de Aseguradora (C1)
	 * @param aseguradoraActivoBean
	 * @param tipoConsulta
	 * @return
	 */
	public AseguradoraActivoBean consultaAseguradoraActivo(AseguradoraActivoBean aseguradoraActivoBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ARRASEGURADORACON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	
				aseguradoraActivoBean.getAseguradoraID(),	
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AseguradoraActivoDAO.consultaAseguradoraActivo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRASEGURADORACON(  " + Arrays.toString(parametros) + ")");
		List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				AseguradoraActivoBean aseguradoraActivoBean = new AseguradoraActivoBean();
				try{
					aseguradoraActivoBean.setAseguradoraID(resultSet.getString("AseguradoraID"));
					aseguradoraActivoBean.setTipoSeguro(resultSet.getString("TipoSeguro"));
					aseguradoraActivoBean.setDescripcion(resultSet.getString("Descripcion"));
					aseguradoraActivoBean.setEstatus(resultSet.getString("Estatus"));
				} catch(Exception ex){
					ex.printStackTrace();
				}
			    return aseguradoraActivoBean;
			}
		});
		return matches.size() > 0 ? (AseguradoraActivoBean) matches.get(0) : null;
	}
	
	/**
	 * Lista de Aseguradoras de Activos (L1)
	 * @param aseguradoraActivoBean
	 * @param tipoLista
	 * @return
	 */
	public List listaAseguradorasActivo(AseguradoraActivoBean aseguradoraActivoBean, int tipoLista){
		List aseguradorasActivo = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRASEGURADORALIS(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {aseguradoraActivoBean.getAseguradoraID(),
									tipoLista,
																		
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"AseguradoraActivoDAO.listaAseguradorasActivo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRASEGURADORALIS(" + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AseguradoraActivoBean aseguradoraActivoBean = new AseguradoraActivoBean();			
					aseguradoraActivoBean.setAseguradoraID(resultSet.getString("AseguradoraID"));
					aseguradoraActivoBean.setDescripcion(resultSet.getString("Descripcion"));
					return aseguradoraActivoBean;
				}
			});
			return aseguradorasActivo = matches.size() > 0 ? matches: null;
			
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la lista de Aseguradoras de Activos.", e);
			e.printStackTrace();			
		}
		return aseguradorasActivo;	
	}
	
	//---------- Getter y Setters ------------------------------------------------------------------------
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
