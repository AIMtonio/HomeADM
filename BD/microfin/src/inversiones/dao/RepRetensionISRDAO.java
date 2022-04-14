package inversiones.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import inversiones.bean.RepRetensionISRBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;


public class RepRetensionISRDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean=null;

	public RepRetensionISRDAO () {
		super();
	}
	
	//Lista para el reporte Retension ISR
	public List consultaRetensionISR(RepRetensionISRBean reporteBean){
		//Query con el Store Procedure	
	
				String query = "call RETENSIONISRREP(?,?, ?,?,?,?,?,?,?);";		
				Object[] parametros = {										
										reporteBean.getFechaInicial(),
										reporteBean.getFechaFinal(),										
										
										parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										parametrosAuditoriaBean.getNombrePrograma(),
										parametrosAuditoriaBean.getSucursal(),
										parametrosAuditoriaBean.getNumeroTransaccion()
										};
				loggerSAFI.info("call RETENSIONISRREP(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RepRetensionISRBean repRetensionISRBean= new RepRetensionISRBean();			
						repRetensionISRBean.setClienteID(resultSet.getString("ClienteID"));
						repRetensionISRBean.setNombrecompleto(resultSet.getString("NombreCompleto"));
						repRetensionISRBean.setRfc(resultSet.getString("RFC"));
						repRetensionISRBean.setCurp(resultSet.getString("CURP"));
						repRetensionISRBean.setMontoinversion(Double.valueOf(resultSet.getString("MontoInversion")).doubleValue());
						repRetensionISRBean.setPlazoinversion(resultSet.getString("PlazoInversion"));
						repRetensionISRBean.setInteresretenido(Double.valueOf(resultSet.getString("InteresRetenido")).doubleValue());
						repRetensionISRBean.setFechaInicial(resultSet.getString("FechaInicio"));
						repRetensionISRBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
						repRetensionISRBean.setHoraEmision(resultSet.getString("HoraEmision"));						
						
						return repRetensionISRBean;				
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






