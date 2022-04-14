package ventanilla.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import ventanilla.bean.ReporteRemitentesUsuarioBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class ReporteRemitentesUsuarioDAO extends BaseDAO{
	
	public ReporteRemitentesUsuarioDAO(){
		super();
	}

	public List <ReporteRemitentesUsuarioBean> reporteRemitentesExcel(ReporteRemitentesUsuarioBean reporteRemitentesUsuarioBean){
		try{
		String query = "CALL REMITENTESUSUARIOSERVREP(" +
				"?,?,?,			" +
				"?,?,?,?,?,		" +
				"?,?);";
		Object[] parametros = {
				reporteRemitentesUsuarioBean.getFechaInicial(),
				reporteRemitentesUsuarioBean.getFechaFinal(),
				reporteRemitentesUsuarioBean.getUsuario(),
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REMITENTESUSUARIOSERVREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				int count = resultSet.getMetaData().getColumnCount();
				ReporteRemitentesUsuarioBean repRemiUsuarioBean = new ReporteRemitentesUsuarioBean();
				repRemiUsuarioBean.setUsuario(resultSet.getString("UsuarioServicioID"));
				repRemiUsuarioBean.setNombreCompletoUsuario(resultSet.getString("NombreUsuario"));
				repRemiUsuarioBean.setRemitente(resultSet.getString("RemitenteID"));
				repRemiUsuarioBean.setNombreCompletoRemitente(resultSet.getString("NombreCompleto"));
				repRemiUsuarioBean.setTipoPersona(resultSet.getString("TipoPersona"));
				repRemiUsuarioBean.setrFC(resultSet.getString("RFC"));
				repRemiUsuarioBean.setcURP(resultSet.getString("CURP"));
				repRemiUsuarioBean.setDomicilio(resultSet.getString("Domicilio"));
				repRemiUsuarioBean.setTipoIdentificacion(resultSet.getString("TipoIdentiID"));
				repRemiUsuarioBean.setNumIdentificacion(resultSet.getString("NumIdentific"));
				repRemiUsuarioBean.setNacionalidad(resultSet.getString("Nacionalidad"));
				repRemiUsuarioBean.setPaisResidencia(resultSet.getString("PaisResidencia"));
				
			
				return  repRemiUsuarioBean;
			}
		});
		return matches;
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
		return null;
	}

}
