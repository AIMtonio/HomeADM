package soporte.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import soporte.bean.GeneraConstanciaRetencionBean;

public class ConstanciaRecursoDAO extends BaseDAO{
	
	public ConstanciaRecursoDAO(){
		super();
	}

	// CONSULTA DIRECTORIOS CONSTANCIAS DE RETENCION
	public List<GeneraConstanciaRetencionBean> consultaDirecConsRet() {
		try{
			String query = "call CONSTANCIARETCREADIREC("+
									"?,?,?,?,?,?,?);"; //Parametros de auditoria
			Object[] parametros = {
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"GeneraConstanciaRetencionDAO.consultaDirecConsRet",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
		
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CONSTANCIARETCREADIREC(" + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GeneraConstanciaRetencionBean generaConstanciaRetencion = new GeneraConstanciaRetencionBean();
					generaConstanciaRetencion.setRutaConstanciaPDF(resultSet.getString("cmd"));
					return generaConstanciaRetencion;
				}
			});
			
			return matches;
		}catch(Exception ex){
			ex.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Consulta Directorios Constancias de Retencion ", ex);
		}
		
		return null;
	}
}