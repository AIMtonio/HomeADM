package regulatorios.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioA2112Bean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatorioA2112DAO extends BaseDAO{

	public RegulatorioA2112DAO() {
		super();
	}
	
	
	/* =========== FUNCIONES PARA OBTENER INFORMACION PARA LOS REPORTES ============= */

	/**
	 * Consulta para generar el reporte regulatorio A2112
	 * @param bean
	 * @param tipoReporte
	 * @return
	 */
	public List <RegulatorioA2112Bean> reporteRegulatorioA2112(final RegulatorioA2112Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2112REP(?,?,? ,?,?,?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2112REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2112Bean beanResponse= new RegulatorioA2112Bean();
				beanResponse.setConcepto(resultSet.getString("Descripcion"));
				beanResponse.setSaldo(resultSet.getString("Saldo"));
				
				beanResponse.setFormulaSaldo(resultSet.getString("FormulaSaldo"));
				beanResponse.setFormulaIndicador(resultSet.getString("FormulaIndicador"));
				beanResponse.setColorCeldaSaldo(resultSet.getString("ColorCeldaSaldo"));
				beanResponse.setColorCeldaIndicador(resultSet.getString("ColorCeldaIndicador"));
				
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
	/**
	 * Consulta del reporte regulatorio Desagregado Req Cap por Riesgo A2112 version CSV
	 * @param bean
	 * @param tipoReporte
	 * @return
	 */
	public List <RegulatorioA2112Bean> reporteRegulatorioA2112Csv(final RegulatorioA2112Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA2112REP(?,?,?,?,?,   ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA2112REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioA2112Bean beanResponse= new RegulatorioA2112Bean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}

}
