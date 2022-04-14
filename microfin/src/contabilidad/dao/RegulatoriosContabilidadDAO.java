package contabilidad.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import contabilidad.bean.RegulatoriosContabilidadBean;
import general.dao.BaseDAO;
import herramientas.Utileria;

public class RegulatoriosContabilidadDAO extends BaseDAO{

	public RegulatoriosContabilidadDAO() {
		super();
	}
	
	
	/* =========== FUNCIONES PARA OBTENER INFORMACION PARA LOS REPORTES ============= */

	// Consulta para Reporte de  Razones Financieras Relevantes por Entidad B 2021
	public List <RegulatoriosContabilidadBean> reporteRegulatorioB2021(final RegulatoriosContabilidadBean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2021REP(?,?,?,?,?,   ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2021REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
				beanResponse.setConsecutivo(resultSet.getString("TmpID"));
				beanResponse.setConcepto(resultSet.getString("Descripcion"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setValorFijo1(resultSet.getString("ValorFijo1"));
				beanResponse.setNumClientes(resultSet.getString("NumClientes"));
				beanResponse.setSaldo(resultSet.getString("Saldo"));

				return beanResponse ;
			}
		});
		return matches;
	}
	

	// Consulta para Reporte csv de  Razones Financieras Relevantes por Entidad B 2021
	public List <RegulatoriosContabilidadBean> reporteRegulatorioB2021Csv(final RegulatoriosContabilidadBean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOB2021REP(?,?,?,?,?,   ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOB2021REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}

	

	// Consulta para Reporte de  Razones Financieras Relevantes por Entidad B 2021
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA3011(final RegulatoriosContabilidadBean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA3011REP(?,?,?,?,?,   ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA3011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
				
				beanResponse.setPeriodo(resultSet.getString("Periodo"));
				beanResponse.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				beanResponse.setClaveFormulario(resultSet.getString("ClaveFormulario"));
				beanResponse.setEstadoID(resultSet.getString("EstadoID"));
				beanResponse.setMunicipioID(resultSet.getString("MunicipioID"));
				beanResponse.setNumSucursales(resultSet.getString("NumSucursales"));
				beanResponse.setNumCajerosATM(resultSet.getString("NumCajerosATM"));
				beanResponse.setNumMujeres(resultSet.getString("NumMujeres"));
				beanResponse.setNumHombres(resultSet.getString("NumHombres"));
				beanResponse.setParteSocial(resultSet.getString("ParteSocial"));
				beanResponse.setNumContrato(resultSet.getString("NumContrato"));
				beanResponse.setSaldoAcum(resultSet.getString("SaldoAcum"));
				beanResponse.setNumContratoPlazo(resultSet.getString("NumContratoPlazo"));
				beanResponse.setSaldoAcumPlazo(resultSet.getString("SaldoAcumPlazo"));
				beanResponse.setNumContratoTD(resultSet.getString("NumContratoTD"));
				beanResponse.setSaldoAcumTD(resultSet.getString("SaldoAcumTD"));
				beanResponse.setNumContratoTDRecar(resultSet.getString("NumContratoTDRecar"));
				beanResponse.setSaldoAcumTDRecar(resultSet.getString("SaldoAcumTDRecar"));
				beanResponse.setNumRemesas(resultSet.getString("NumRemesas"));
				beanResponse.setMontoRemesas(resultSet.getString("MontoRemesas"));				
				beanResponse.setNumCreditos(resultSet.getString("NumCreditos"));
				beanResponse.setSaldoVigenteCre(resultSet.getString("SaldoVigenteCre"));
				beanResponse.setSaldoVencidoCre(resultSet.getString("SaldoVencidoCre"));
				beanResponse.setNumMicroCreditos(resultSet.getString("NumMicroCreditos"));
				beanResponse.setSaldoVigenteMicroCre(resultSet.getString("SaldoVigenteMicroCre"));
				beanResponse.setSaldoVencidoMicroCre(resultSet.getString("SaldoVencidoMicroCre"));
				beanResponse.setNumContratoTC(resultSet.getString("NumContratoTC"));
				beanResponse.setSaldoVigenteTC(resultSet.getString("SaldoVigenteTC"));
				beanResponse.setSaldoVencidoTC(resultSet.getString("SaldoVencidoTC"));
				beanResponse.setNumCreConsumo(resultSet.getString("NumCreConsumo"));
				beanResponse.setSaldoVigenteCreConsumo(resultSet.getString("SaldoVigenteCreConsumo"));
				beanResponse.setSaldoVencidoCreConsumo(resultSet.getString("SaldoVencidoCreConsumo"));
				beanResponse.setNumCreVivienda(resultSet.getString("NumCreVivienda"));				
				beanResponse.setSaldoVigenteCreVivienda(resultSet.getString("SaldoVigenteCreVivienda"));
				beanResponse.setSaldoVencidoCreVivienda(resultSet.getString("SaldoVencidoCreVivienda"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	
	// Consulta para Reporte csv de  Razones Financieras Relevantes por Entidad B 2021
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA3011Csv(final RegulatoriosContabilidadBean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOA3011REP(?,?,?,?,?,   ?,?,?,?,?)";

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
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA3011REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
				
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	


	// Consulta para Reporte de Cartera coeficiente de liquidez A2011
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA2011(final RegulatoriosContabilidadBean bean, int tipoReporte, int version){	
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
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
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
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA2011Version2015(final RegulatoriosContabilidadBean bean, int tipoReporte, int version){	
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
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
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
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA2011Csv(final RegulatoriosContabilidadBean bean, int tipoReporte, int version){	
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
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA2011CsvVersion2015(final RegulatoriosContabilidadBean bean, int tipoReporte, int version){	
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
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	


	// Consulta para Reporte de Cartera  Requerimientos de Capital por Riesgos A2111
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA2111(final RegulatoriosContabilidadBean bean, int tipoReporte){	
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
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
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
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA2111Csv(final RegulatoriosContabilidadBean bean, int tipoReporte){	
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
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}
	
	/**
	 * Consulta para generar el reporte regulatorio A2112
	 * @param bean
	 * @param tipoReporte
	 * @return
	 */
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA2112(final RegulatoriosContabilidadBean bean, int tipoReporte){	
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
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
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
	public List <RegulatoriosContabilidadBean> reporteRegulatorioA2112Csv(final RegulatoriosContabilidadBean bean, int tipoReporte){	
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
				
				RegulatoriosContabilidadBean beanResponse= new RegulatoriosContabilidadBean();
				beanResponse.setValor(resultSet.getString("Valor"));

				return beanResponse ;
			}
		});
		return matches;
	}

}
