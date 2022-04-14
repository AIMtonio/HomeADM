package regulatorios.dao;

import general.dao.BaseDAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioB1413Bean;
import herramientas.Utileria;


public class RegulatorioB1413DAO extends BaseDAO {

	public RegulatorioB1413DAO() {
		super();
	}
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * CSV
	 * 
	 * */
	
	public List <RegulatorioB1413Bean> reporteRegulatorioB1413Csv(final RegulatorioB1413Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1413REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA2610DAO.reporteRegulatorioB1413Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1413REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB1413Bean beanResponse= new RegulatorioB1413Bean();
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
	public List <RegulatorioB1413Bean> reporteRegulatorioB1413Socap(final RegulatorioB1413Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1413REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA2610DAO.reporteRegulatorioB1413Socap",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1413REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioB1413Bean beanResponse= new RegulatorioB1413Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setClaveNivelEntidad(resultSet.getString("ClaveNivelEntidad"));
			
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
	
	public List <RegulatorioB1413Bean> reporteRegulatorioB1413Sofipo(final RegulatorioB1413Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1413REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA2610DAO.reporteRegulatorioB1413Sofipo",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1413REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioB1413Bean beanResponse= new RegulatorioB1413Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
			beanResponse.setNumReporte(resultSet.getString("Subreporte"));
			beanResponse.setClaveNivelEntidad(resultSet.getString("ClaveNivelEntidad"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	
	
}
