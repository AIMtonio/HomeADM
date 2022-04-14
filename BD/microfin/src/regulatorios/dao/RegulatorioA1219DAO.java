package regulatorios.dao;

import general.dao.BaseDAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioA1219Bean;
import herramientas.Utileria;


public class RegulatorioA1219DAO extends BaseDAO {

	public RegulatorioA1219DAO() {
		super();
	}
	 
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * CSV
	 * 
	 * */
	
	public List <RegulatorioA1219Bean> reporteRegulatorioA1219Csv(final RegulatorioA1219Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA1219REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getAnio(),
							bean.getMes(),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA1219DAO.reporteRegulatorioA1219Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA1219REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA1219Bean beanResponse= new RegulatorioA1219Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

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
	
	public List <RegulatorioA1219Bean> reporteRegulatorioA1219Sofipo(final RegulatorioA1219Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA1219REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getAnio(),
							bean.getMes(),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA1219DAO.reporteRegulatorioA1219Sofipo",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA1219REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA1219Bean beanResponse= new RegulatorioA1219Bean();
				
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setReporte(resultSet.getString("Subreporte"));
				beanResponse.setConcepto(resultSet.getString("Concepto"));
				beanResponse.setEstadoFinanciero(resultSet.getString("EstadoFinanciero"));
				beanResponse.setBalanceSubsidiaria1(resultSet.getString("BalanceSubsidiaria1"));
				beanResponse.setBalanceSubsidiariaN(resultSet.getString("BalanceSubsidiariaN"));
				beanResponse.setSumEstFinanSubsidiaria(resultSet.getString("SumEstFinanSubsidiaria"));
				beanResponse.setSumEstFinanSofipo(resultSet.getString("SumEstFinanSofipo"));
				beanResponse.setEliminacionesDebe(resultSet.getString("EliminacionesDebe"));
				beanResponse.setEliminacionesHaber(resultSet.getString("EliminacionesHaber"));
				beanResponse.setEstFinanSofipoConsol(resultSet.getString("EstFinanSofipoConsol"));
				return beanResponse;
			}
		});
		return matches;
	}
}
