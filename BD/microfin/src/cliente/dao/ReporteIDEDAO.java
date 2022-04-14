package cliente.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;

import contabilidad.bean.CuentasContablesBean;

import cliente.bean.ReporteIDEBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class ReporteIDEDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean=null;

	public ReporteIDEDAO () {
		super();
	}
	
	//reporte Para reportes IDE
	public List listaIDE(ReporteIDEBean reporteBean){
		//Query con el Store Procedure
				String query = "call COBROIDEREP(?,?,?,?,?,		?,?,?,?,?,?,?);";
				Object[] parametros = {	reporteBean.getTipoReporte(),
										reporteBean.getClienteID(),
										reporteBean.getPeriodo(),		
										reporteBean.getEjercicio(),									
										reporteBean.getSucursal(),
										
										parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										parametrosAuditoriaBean.getNombrePrograma(),
										parametrosAuditoriaBean.getSucursal(),
										Constantes.ENTERO_CERO
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COBROIDEREP(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ReporteIDEBean IDEBean= new ReporteIDEBean();			
						IDEBean.setClienteID(resultSet.getString("ClienteID"));
						IDEBean.setCurp(resultSet.getString("CURP"));
						IDEBean.setRfc(resultSet.getString("RFC"));
						IDEBean.setPrimerNombre(resultSet.getString("PrimerNombre"));
						IDEBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
						IDEBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));						
						IDEBean.setFin(resultSet.getString("FechaCorte"));					
						IDEBean.setCantidad(resultSet.getString("Cantidad"));
						IDEBean.setCantidadExcento(resultSet.getString("CantidadExcento"));
						IDEBean.setDirCompleta(resultSet.getString("DireccionCompleta"));
						IDEBean.setCp(resultSet.getString("CP"));					
						IDEBean.setEsMenorEdad(resultSet.getString("EsMenorEdad"));
						IDEBean.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
						IDEBean.setTelefono(resultSet.getString("Telefono"));					
						IDEBean.setTelCelular(resultSet.getString("TelefonoCelular"));					
						IDEBean.setCorreo(resultSet.getString("Correo"));
						IDEBean.setCuentaAhoID(resultSet.getString("CuentaAhoID"));	
						IDEBean.setTipoPersona(resultSet.getString("TipoPersona"));	
						IDEBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						IDEBean.setConsecutivo(resultSet.getString("Consecutivo"));	

						return IDEBean;				
					}
				});
				return matches;
	}
	
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}	
}
