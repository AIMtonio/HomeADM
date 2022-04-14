package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.RowMapper;

import contabilidad.bean.ReporteISRRetenidoBean;
public class ReporteISRRetenidoDAO extends BaseDAO{

	public ReporteISRRetenidoDAO (){
		super();
	}
	
	
	public List <ReporteISRRetenidoBean> repISRRetener( ReporteISRRetenidoBean isrRetenidoBean,int TipoConsulta){
		try{
		String query = "CALL ISRRETENIDOREP(" +
				"?,?,?,?,?,   ?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(isrRetenidoBean.getAnio()),
				TipoConsulta,
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ISRRETENIDOREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				int count = resultSet.getMetaData().getColumnCount();
				ReporteISRRetenidoBean isrretenidoBean = new ReporteISRRetenidoBean();
				isrretenidoBean.setSocio(resultSet.getString("SocioID"));
				isrretenidoBean.setPrimermes(resultSet.getString("PrimerMes"));
				isrretenidoBean.setUltimomes(resultSet.getString("UltimoMes"));
				isrretenidoBean.setSucursal(resultSet.getString("Sucursal"));
				isrretenidoBean.setNombre(resultSet.getString("NombreSocio"));
				isrretenidoBean.setRfc(resultSet.getString("RFC"));
				isrretenidoBean.setCurp(resultSet.getString("CURP"));
				isrretenidoBean.setIntereses(resultSet.getString("Intereses"));
				isrretenidoBean.setIsr(resultSet.getString("ISR"));
				isrretenidoBean.setEstatus(resultSet.getString("Estatus"));
				isrretenidoBean.setEsmenor(resultSet.getString("EsMenorEdad"));
				isrretenidoBean.setNombre_tutor(resultSet.getString("NombreTutor"));
				isrretenidoBean.setRfc_tutor(resultSet.getString("RFCTutor"));
				isrretenidoBean.setCurp_tutor(resultSet.getString("CURPTutor"));
				return isrretenidoBean;	 
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
	public List listaAniosISR(int TipoConsulta) {
		//Query con el Store Procedure
		String query = "CALL ISRRETENANIOLIST(" +
				"?,?,?,?,?,   ?,?);";
		Object[] parametros = {
				TipoConsulta,
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ISRRETENANIOLIST(" + Arrays.toString(parametros) +")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReporteISRRetenidoBean isrretenidoBean = new ReporteISRRetenidoBean();			
				isrretenidoBean.setAnio(String.valueOf(resultSet.getString("anio")));
				return isrretenidoBean;					
			}
		});
				
		return matches;
	} 
}
