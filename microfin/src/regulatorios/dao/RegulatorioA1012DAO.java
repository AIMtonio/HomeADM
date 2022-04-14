package regulatorios.dao;

import general.dao.BaseDAO;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import regulatorios.bean.RegulatorioA1012Bean;


public class RegulatorioA1012DAO extends BaseDAO{
	
	public RegulatorioA1012DAO() {
		super();
	}
	
	/* REPORTE CSV */
	public List <RegulatorioA1012Bean> reporteRegulatorioA1012Csv(final RegulatorioA1012Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA1012REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getAnio(),
							bean.getMes(),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA1012DAO.reporteRegulatorioA1012Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA1012REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA1012Bean beanResponse= new RegulatorioA1012Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	/* REPORTE EXCEL SOFIPO */
	public List <RegulatorioA1012Bean> reporteRegulatorioA1012Excel(final RegulatorioA1012Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA1012REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getAnio(),
							bean.getMes(),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioA1012DAO.reporteRegulatorioA1012Excel",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA1012REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA1012Bean beanResponse= new RegulatorioA1012Bean();
			
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
