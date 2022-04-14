package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioA2111Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioA2111DAO extends BaseDAO{

	public RegulatorioA2111DAO() {
		super();
	}
	
	// Consulta para Reporte de Cartera  Requerimientos de Capital por Riesgos A2111
	public List <RegulatorioA2111Bean> reporteRegulatorioA2111Socap(final RegulatorioA2111Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2111REP(?,?,?,?,?,   ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2111REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2111Bean beanResponse= new RegulatorioA2111Bean();
				beanResponse.setConcepto(resultSet.getString("Descripcion"));
				beanResponse.setSaldo(resultSet.getString("Saldo"));
				beanResponse.setIndicador(resultSet.getString("Indicador"));
				beanResponse.setFormulaSaldo(resultSet.getString("FormulaSaldo"));
				beanResponse.setFormulaIndicador(resultSet.getString("FormulaIndicador"));
				beanResponse.setColorCeldaSaldo(resultSet.getString("ColorCeldaSaldo"));
				beanResponse.setColorCeldaIndicador(resultSet.getString("ColorCeldaIndicador"));
				beanResponse.setSaldoEsNegrita(resultSet.getString("SaldoEsNegrita"));
				beanResponse.setIndicadorEsNegrita(resultSet.getString("IndicadorEsNegrita"));
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
	
	// Consulta para Reporte csv de Cartera  Requerimientos de Capital por Riesgos A2111
	public List <RegulatorioA2111Bean> reporteRegulatorioA2111Csv(final RegulatorioA2111Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2111REP(?,?,?,?,?,   ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2111REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2111Bean beanResponse= new RegulatorioA2111Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	
	
	// Consulta para Reporte de Cartera  Requerimientos de Capital por Riesgos A2111
		public List <RegulatorioA2111Bean> reporteRegulatorioA2111Sofipo(final RegulatorioA2111Bean bean, int tipoReporte){	
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGULATORIOA2111REP(?,?,?,?,?,   ?,?,?,?,?)";

			Object[] parametros ={
								Utileria.convierteEntero(bean.getAnio()),
								Utileria.convierteEntero(bean.getMes()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2111REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
					RegulatorioA2111Bean beanResponse= new RegulatorioA2111Bean();
					beanResponse.setConcepto(resultSet.getString("Descripcion"));
					beanResponse.setSaldo(resultSet.getString("Saldo"));
					beanResponse.setIndicador(resultSet.getString("Indicador"));
					beanResponse.setFormulaSaldo(resultSet.getString("FormulaSaldo"));
					beanResponse.setFormulaIndicador(resultSet.getString("FormulaIndicador"));
					beanResponse.setColorCeldaSaldo(resultSet.getString("ColorCeldaSaldo"));
					beanResponse.setColorCeldaIndicador(resultSet.getString("ColorCeldaIndicador"));
					beanResponse.setColorCeldaSaldoProm(resultSet.getString("ColorCeldaSaldoProm"));
					beanResponse.setSaldoEsNegrita(resultSet.getString("SaldoEsNegrita"));
					beanResponse.setIndicadorEsNegrita(resultSet.getString("IndicadorEsNegrita"));
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
