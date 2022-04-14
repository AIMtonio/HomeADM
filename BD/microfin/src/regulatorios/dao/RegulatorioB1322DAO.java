package regulatorios.dao;

import general.dao.BaseDAO;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import regulatorios.bean.RegulatorioB1322Bean;


public class RegulatorioB1322DAO  extends BaseDAO{
	
	public RegulatorioB1322DAO() {
		super();
	}
	
	/* REPORTE CSV */
	public List <RegulatorioB1322Bean> reporteRegulatorioB1322Csv(final RegulatorioB1322Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1322REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getAnio(),
							bean.getMes(),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioB1322DAO.reporteRegulatorioB1322Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1322REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB1322Bean beanResponse= new RegulatorioB1322Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	/* REPORTE EXCEL SOFIPO */
	public List <RegulatorioB1322Bean> reporteRegulatorioB1322Excel(final RegulatorioB1322Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB1322REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							bean.getAnio(),
							bean.getMes(),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioB1322DAO.reporteRegulatorioB1322Excel",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB1322REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioB1322Bean beanResponse= new RegulatorioB1322Bean();
				
				beanResponse.setConcepto(resultSet.getString("Concepto"));
				beanResponse.setSaldo(resultSet.getString("Saldo"));
				return beanResponse ;
			}
		});
		return matches;
	}
}
