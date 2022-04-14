package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import regulatorios.bean.RegulatorioA2011Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioA2011DAO extends BaseDAO{

	public RegulatorioA2011DAO() {
		super();
	}
	
	// Consulta para Reporte de Cartera coeficiente de liquidez A2011
	public List <RegulatorioA2011Bean> reporteRegulatorioA2011(final RegulatorioA2011Bean bean, int tipoReporte, int version){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2011REP(?,?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
							version,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2011Bean beanResponse= new RegulatorioA2011Bean();
				beanResponse.setConcepto(resultSet.getString("Descripcion"));
				beanResponse.setSaldo(resultSet.getString("Saldo"));
				beanResponse.setSaldoPromedio(resultSet.getString("SaldoPromedio"));
				beanResponse.setFormulaSaldo(resultSet.getString("FormulaSaldo"));
				beanResponse.setFormulaSaldoProm(resultSet.getString("FormulaSaldoProm"));
				beanResponse.setDescripcionEsNegrita(resultSet.getString("DescripcionEsNegrita"));
				beanResponse.setColorCeldaSaldo(resultSet.getString("ColorCeldaSaldo"));
				beanResponse.setColorCeldaSaldoProm(resultSet.getString("ColorCeldaSaldoProm"));
				beanResponse.setCuentaCNBV(resultSet.getString("CuentaCNBV"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setValorFijo1(resultSet.getString("ValorFijo1"));
				beanResponse.setValorFijo2(resultSet.getString("ValorFijo2"));
				beanResponse.setValorFijo3(resultSet.getString("ValorFijo3"));

				return beanResponse ;
			}
		});
		return matches;
	}

	/**
	 * Consulta para generar el reporte A2011 version 2015
	 * @param bean
	 * @param tipoReporte
	 * @return
	 */
	public List <RegulatorioA2011Bean> reporteRegulatorioA2011Version2015(final RegulatorioA2011Bean bean, int tipoReporte, int version){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2011REP(?,?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
							version,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2011Bean beanResponse= new RegulatorioA2011Bean();
				beanResponse.setConcepto(resultSet.getString("Descripcion"));
				beanResponse.setSaldo(resultSet.getString("Saldo"));
				beanResponse.setSaldoPromedio(resultSet.getString("SaldoPromedio"));
				beanResponse.setFormulaSaldo(resultSet.getString("FormulaSaldo"));
				beanResponse.setFormulaSaldoProm(resultSet.getString("FormulaSaldoProm"));
				beanResponse.setDescripcionEsNegrita(resultSet.getString("DescripcionEsNegrita"));
				beanResponse.setColorCeldaSaldo(resultSet.getString("ColorCeldaSaldo"));
				beanResponse.setColorCeldaSaldoProm(resultSet.getString("ColorCeldaSaldoProm"));
				beanResponse.setCuentaCNBV(resultSet.getString("CuentaCNBV"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setValorFijo1(resultSet.getString("ValorFijo1"));
				beanResponse.setValorFijo2(resultSet.getString("ValorFijo2"));
				beanResponse.setValorFijo3(resultSet.getString("ValorFijo3"));

				return beanResponse ;
			}
		});
		return matches;
	}

	// Consulta para Reporte Csv de Cartera coeficiente de liquidez A2011
	public List <RegulatorioA2011Bean> reporteRegulatorioA2011Csv(final RegulatorioA2011Bean bean, int tipoReporte, int version){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2011REP(?,?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
							version,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2011Bean beanResponse= new RegulatorioA2011Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	public List <RegulatorioA2011Bean> reporteRegulatorioA2011CsvVersion2015(final RegulatorioA2011Bean bean, int tipoReporte, int version){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2011REP(?,?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
							version,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2011Bean beanResponse= new RegulatorioA2011Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	
	/**
	 * Consulta para generar el reporte A2011 version 2015
	 * @param bean
	 * @param tipoReporte
	 * @return
	 */
	public List <RegulatorioA2011Bean> reporteRegulatorioA2011Sofipo(final RegulatorioA2011Bean bean, int tipoReporte, int version){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2011REP(?,?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
							version,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2011Bean beanResponse= new RegulatorioA2011Bean();
				beanResponse.setRegistroID(resultSet.getString("RegistroID"));
				beanResponse.setConcepto(resultSet.getString("Descripcion"));
				beanResponse.setSaldo(resultSet.getString("Saldo"));
				beanResponse.setSaldoPromedio(resultSet.getString("SaldoPromedio"));
				beanResponse.setFormulaSaldo(resultSet.getString("FormulaSaldo"));
				beanResponse.setFormulaSaldoProm(resultSet.getString("FormulaSaldoProm"));
				beanResponse.setDescripcionEsNegrita(resultSet.getString("DescripcionEsNegrita"));
				beanResponse.setColorCeldaSaldo(resultSet.getString("ColorCeldaSaldo"));
				beanResponse.setColorCeldaSaldoProm(resultSet.getString("ColorCeldaSaldoProm"));
				beanResponse.setCuentaCNBV(resultSet.getString("CuentaCNBV"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setValorFijo1(resultSet.getString("ValorFijo1"));
				beanResponse.setValorFijo2(resultSet.getString("ValorFijo2"));
				beanResponse.setValorFijo3(resultSet.getString("ValorFijo3"));

				return beanResponse ;
			}
		});
		return matches;
	}
	

}
