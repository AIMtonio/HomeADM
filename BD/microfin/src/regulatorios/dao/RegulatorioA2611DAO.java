package regulatorios.dao;

import general.dao.BaseDAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioA2611Bean;
import herramientas.Utileria;

public class RegulatorioA2611DAO extends BaseDAO {
	
	public RegulatorioA2611DAO() {
		super();
	}
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * CSV
	 * 
	 * */
	
	
	public List <RegulatorioA2611Bean> reporteRegulatorioA2611Csv(final RegulatorioA2611Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2611REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA2611DAO.reporteRegulatorioA2611Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2611REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2611Bean beanResponse= new RegulatorioA2611Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}

	

	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * SECCION SOCAPS
	 * 
	 * */
	public List <RegulatorioA2611Bean> reporteRegulatorioA2611Socap(final RegulatorioA2611Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2611REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA2611DAO.reporteRegulatorioA2611Socap",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2611REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioA2611Bean beanResponse= new RegulatorioA2611Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setNumSecuencia(resultSet.getString("NumSecuencia"));
			beanResponse.setOperacionConAdmin(resultSet.getString("OperacionConAdmin"));
			beanResponse.setIdenAdministrador(resultSet.getString("IdenAdministrador"));
			beanResponse.setrFCAdministrador(resultSet.getString("RFCAdministrador"));
			beanResponse.setTipoMovimiento(resultSet.getString("TipoMovimiento"));
			beanResponse.setIdenComisionista(resultSet.getString("IdenComisionista"));
			beanResponse.setNombreComisionista(resultSet.getString("NombreComisionista"));
			beanResponse.setrFCCOmisionista(resultSet.getString("RFCCOmisionista"));
			beanResponse.setPersJuridicaComi(resultSet.getString("PersJuridicaComi"));
			beanResponse.setActividadComision(resultSet.getString("ActividadComision"));
			beanResponse.setOperaContratadas(resultSet.getString("OperaContratadas"));
			beanResponse.setCausaBaja(resultSet.getString("CausaBaja"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * SECCION SOFIPOS
	 * 
	 * */
	
	public List <RegulatorioA2611Bean> reporteRegulatorioA2611Sofipo(final RegulatorioA2611Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2611REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"reporteRegulatorioA2611Socap.reporteRegulatorioA2611Sofipo",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2611REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioA2611Bean beanResponse= new RegulatorioA2611Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setNumSecuencia(resultSet.getString("NumSecuencia"));
			beanResponse.setOperacionConAdmin(resultSet.getString("OperacionConAdmin"));
			beanResponse.setIdenAdministrador(resultSet.getString("IdenAdministrador"));
			beanResponse.setrFCAdministrador(resultSet.getString("RFCAdministrador"));
			beanResponse.setTipoMovimiento(resultSet.getString("TipoMovimiento"));
			beanResponse.setIdenComisionista(resultSet.getString("IdenComisionista"));
			beanResponse.setNombreComisionista(resultSet.getString("NombreComisionista"));
			beanResponse.setrFCCOmisionista(resultSet.getString("RFCCOmisionista"));
			beanResponse.setPersJuridicaComi(resultSet.getString("PersJuridicaComi"));
			beanResponse.setOperaContratadas(resultSet.getString("OperaContratadas"));
			beanResponse.setCausaBaja(resultSet.getString("CausaBaja"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
}
