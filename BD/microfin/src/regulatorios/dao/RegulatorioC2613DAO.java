package regulatorios.dao;

import general.dao.BaseDAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioC2613Bean;
import herramientas.Utileria;


public class RegulatorioC2613DAO extends BaseDAO {
	
	public RegulatorioC2613DAO() {
		super();
	}
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * CSV
	 * 
	 * */
	
	public List <RegulatorioC2613Bean> reporteRegulatorioC2613Csv(final RegulatorioC2613Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOC2613REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SerieR26",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOC2613REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioC2613Bean beanResponse= new RegulatorioC2613Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * SOCAP
	 * 
	 * */
	public List <RegulatorioC2613Bean> reporteRegulatorioC2613Socap(final RegulatorioC2613Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOC2613REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SerieR26",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOC2613REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioC2613Bean beanResponse= new RegulatorioC2613Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setCaptacionMensual(resultSet.getString("CaptacionMensual"));
			beanResponse.setNumSecuencia(resultSet.getString("NumSecuencia"));
			beanResponse.setIdenAdministrador(resultSet.getString("IdenAdministrador"));
			beanResponse.setIdenComisionista(resultSet.getString("IdenComisionista"));
			beanResponse.setClaveModulo(resultSet.getString("ClaveModulo"));
			beanResponse.setLocalidadModulo(resultSet.getString("LocalidadModulo"));
			beanResponse.setTipoOperacion(resultSet.getString("TipoOperacion"));
			beanResponse.setMedioPago(resultSet.getString("MedioPago"));
			beanResponse.setMontoOperaciones(resultSet.getString("MontoOperaciones"));
			beanResponse.setNumOperaciones(resultSet.getString("NumOperaciones"));
			beanResponse.setNumClientes(resultSet.getString("NumClientes"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * SOFIPO
	 * 
	 * */
	
	public List <RegulatorioC2613Bean> reporteRegulatorioC2613Sofipo(final RegulatorioC2613Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOC2613REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SerieR26",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOC2613REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioC2613Bean beanResponse= new RegulatorioC2613Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setCaptacionMensual(resultSet.getString("CaptacionMensual"));
			beanResponse.setNumSecuencia(resultSet.getString("NumSecuencia"));
			beanResponse.setIdenAdministrador(resultSet.getString("IdenAdministrador"));
			beanResponse.setIdenComisionista(resultSet.getString("IdenComisionista"));
			beanResponse.setClaveModulo(resultSet.getString("ClaveModulo"));
			beanResponse.setLocalidadModulo(resultSet.getString("LocalidadModulo"));
			beanResponse.setTipoOperacion(resultSet.getString("TipoOperacion"));
			beanResponse.setMedioPago(resultSet.getString("MedioPago"));
			beanResponse.setMontoOperaciones(resultSet.getString("MontoOperaciones"));
			beanResponse.setNumOperaciones(resultSet.getString("NumOperaciones"));
			beanResponse.setNumClientes(resultSet.getString("NumClientes"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
}
