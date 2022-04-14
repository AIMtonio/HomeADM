package regulatorios.dao;

import general.dao.BaseDAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioB2612Bean;
import herramientas.Utileria;

public class RegulatorioB2612DAO extends BaseDAO {

	public RegulatorioB2612DAO() {
		super();
	}
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * CSV
	 * 
	 * */
	public List <RegulatorioB2612Bean> reporteRegulatorioB2612Csv(final RegulatorioB2612Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2612REP(?,?,?,?,?, ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2612REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB2612Bean beanResponse= new RegulatorioB2612Bean();
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
	public List <RegulatorioB2612Bean> reporteRegulatorioB2612Socap(final RegulatorioB2612Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2612REP(?,?,?,?,?, ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2612REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioB2612Bean beanResponse= new RegulatorioB2612Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setNumSecuencia(resultSet.getString("NumSecuencia"));
			beanResponse.setIdenComisionista(resultSet.getString("IdenComisionista"));
			beanResponse.setrFCCOmisionista(resultSet.getString("RFCCOmisionista"));
			beanResponse.setTipoMovimiento(resultSet.getString("TipoMovimiento"));
			beanResponse.setClaveModulo(resultSet.getString("ClaveModulo"));
			beanResponse.setLocalidadModulo(resultSet.getString("LocalidadModulo"));
			beanResponse.setCausaBajaModulo(resultSet.getString("CausaBajaModulo"));
			beanResponse.setMunicipio(resultSet.getString("Municipio"));
			beanResponse.setEstado(resultSet.getString("Estado"));
			
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
	public List <RegulatorioB2612Bean> reporteRegulatorioB2612Sofipo(final RegulatorioB2612Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2612REP(?,?,?,?,?, ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2612REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioB2612Bean beanResponse= new RegulatorioB2612Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setNumSecuencia(resultSet.getString("NumSecuencia"));
			beanResponse.setIdenComisionista(resultSet.getString("IdenComisionista"));
			beanResponse.setrFCCOmisionista(resultSet.getString("RFCCOmisionista"));
			beanResponse.setTipoMovimiento(resultSet.getString("TipoMovimiento"));
			beanResponse.setClaveModulo(resultSet.getString("ClaveModulo"));
			beanResponse.setLocalidadModulo(resultSet.getString("LocalidadModulo"));
			beanResponse.setCausaBajaModulo(resultSet.getString("CausaBajaModulo"));
			beanResponse.setMunicipio(resultSet.getString("Municipio"));
			beanResponse.setEstado(resultSet.getString("Estado"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	
	
}
