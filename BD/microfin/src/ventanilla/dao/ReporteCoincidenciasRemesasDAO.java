package ventanilla.dao;

import general.dao.BaseDAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import ventanilla.bean.ReporteCoincidenciasRemesasBean;

import herramientas.Constantes;
import herramientas.Utileria;

public class ReporteCoincidenciasRemesasDAO extends BaseDAO{
	
	public ReporteCoincidenciasRemesasDAO(){
		super();
	}

	public List <ReporteCoincidenciasRemesasBean> reporteCoincidenciasExcel(ReporteCoincidenciasRemesasBean reporteCoincidenciasRemesasBean){
		try{
		String query = "CALL COINCIDEREMESASUSUSERREP(" +
				"?,?,?,			" +
				"?,?,?,?,?,		" +
				"?,?);";
		Object[] parametros = {
				reporteCoincidenciasRemesasBean.getFechaInicial(),
				reporteCoincidenciasRemesasBean.getFechaFinal(),
				reporteCoincidenciasRemesasBean.getTipoCoincidencia(),
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COINCIDEREMESASUSUSERREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				int count = resultSet.getMetaData().getColumnCount();
				ReporteCoincidenciasRemesasBean repCoinRemesasBean = new ReporteCoincidenciasRemesasBean();
				repCoinRemesasBean.setUsuarioBuscado(resultSet.getString("UsuarioServicioID"));
				repCoinRemesasBean.setrFCBuscado(resultSet.getString("RFC"));
				repCoinRemesasBean.setcURPBuscado(resultSet.getString("CURP"));
				repCoinRemesasBean.setNombreBuscado(resultSet.getString("NombreCompleto"));
				repCoinRemesasBean.setUsuarioCoincidencia(resultSet.getString("UsuarioServCoinID"));
				repCoinRemesasBean.setrFCCoincidencia(resultSet.getString("RFCCoin"));
				repCoinRemesasBean.setcURPCoincidencia(resultSet.getString("CURPCoin"));
				repCoinRemesasBean.setNombreCoincidencia(resultSet.getString("NombreCompletoCoin"));
				repCoinRemesasBean.setPorcentajeCoincidencia(resultSet.getString("PorcConcidencia"));
				
				return  repCoinRemesasBean;
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
