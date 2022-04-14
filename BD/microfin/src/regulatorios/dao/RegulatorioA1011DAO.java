package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import regulatorios.bean.RegulatorioA1011Bean;

import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioA1011DAO extends BaseDAO{
	
	public RegulatorioA1011DAO() {
		super();
	}
	
	/* REPORTE CSV */
	public List <RegulatorioA1011Bean> reporteRegulatorioA1011Csv(final RegulatorioA1011Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA1011REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getAnio(),
							bean.getMes(),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA1011DAO.reporteRegulatorioA1011Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA1011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA1011Bean beanResponse= new RegulatorioA1011Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	/* REPORTE EXCEL SOFIPO */
	public List <RegulatorioA1011Bean> reporteRegulatorioA1011Excel(final RegulatorioA1011Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA1011REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getAnio(),
							bean.getMes(),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA1011DAO.reporteRegulatorioA1011Excel",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA1011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA1011Bean beanResponse= new RegulatorioA1011Bean();
				
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
