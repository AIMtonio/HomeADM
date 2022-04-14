package regulatorios.dao;

import general.dao.BaseDAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.RegulatorioA2610Bean;
import regulatorios.bean.RegulatorioC0452Bean;
import herramientas.Utileria;
 

public class RegulatorioC0452DAO extends BaseDAO {

	public RegulatorioC0452DAO() {
		super();
	}
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * CSV
	 * 
	 * */
	
	public List <RegulatorioC0452Bean> reporteRegulatorioC452Csv(final RegulatorioC0452Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOC0452REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioC0452DAO.reporteRegulatorioC452Csv",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOC0452REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
				RegulatorioC0452Bean beanResponse= new RegulatorioC0452Bean();
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
	
	public List <RegulatorioC0452Bean> reporteRegulatorioC0452Sofipo(final RegulatorioC0452Bean bean, int tipoReporte){	
		transaccionDAO.generaNumeroTransaccion();
		String query = "call REGULATORIOC0452REP(?,?,?,?,?, ?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteEntero(bean.getAnio()),
							Utileria.convierteEntero(bean.getMes()),
							tipoReporte,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"regulatorioC0452DAO.reporteRegulatorioA2610Sofipo",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOC0452REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				
			RegulatorioC0452Bean beanResponse= new RegulatorioC0452Bean();
			
			beanResponse.setPeriodo(resultSet.getString("Var_Periodo"));
			beanResponse.setClaveEntidad(resultSet.getString("Var_ClaveEntidad"));
			beanResponse.setReporte(resultSet.getString("For_0452"));
			beanResponse.setIdencreditoCNBV(resultSet.getString("IdenCreditoCNBV"));
			beanResponse.setNumeroDisposicion(resultSet.getString("NumeroDispo"));
			beanResponse.setClasificacionConta(resultSet.getString("ClasifConta"));
			beanResponse.setFechaCorte(resultSet.getString("FechaCorte"));
			beanResponse.setSaldoInsolutoInicialFC(resultSet.getString("SalInsolutoInicial"));
			beanResponse.setMontoDispuestoFC(resultSet.getString("MontoDispuesto"));	
			beanResponse.setInteresOrdinarioFC(resultSet.getString("SalIntOrdin"));
			beanResponse.setInteresMoratorioFC(resultSet.getString("SalIntMora"));
			beanResponse.setComisionGeneFC(resultSet.getString("MontoComision"));
			beanResponse.setMontoIVAFC(resultSet.getString("SaldoIVA"));	
			beanResponse.setPagoCapitalExFC(resultSet.getString("SalCapitalExigible"));
			beanResponse.setPagoInteresExFC(resultSet.getString("SalIntExigible"));
			beanResponse.setPagoComisionExFC(resultSet.getString("MontoComisionExigible"));
			beanResponse.setCapitalPagEfecFC(resultSet.getString("CapitalPagado"));
			beanResponse.setPagoInteresOrdinarioFC(resultSet.getString("IntOrdiPagado"));
			beanResponse.setPagoInteresMoratoriFC(resultSet.getString("IntMoraPagado"));
			beanResponse.setPagoComisionGeneFC(resultSet.getString("MtoComisiPagado"));
			beanResponse.setPagoAccesoriosFC(resultSet.getString("OtrAccesoriosPagado"));
			beanResponse.setTasaAnualFC(resultSet.getString("TasaAnual"));
			beanResponse.setTasaMoratoriaFC(resultSet.getString("TasaMora"));
			beanResponse.setSaldoInsolutoFinalFC(resultSet.getString("SaldoInsoluto"));
			
			
			beanResponse.setFechaUltimaDispoCP(resultSet.getString("FechaUltDispo"));
			beanResponse.setPlazoVencimienLineaCP(resultSet.getString("PlazoVencimiento"));
			beanResponse.setSaldoPrincipalInicialCP(resultSet.getString("SaldoPrincipalFP"));	
			beanResponse.setMontoDispuestoCP(resultSet.getString("MontoDispuestoFP"));	
			beanResponse.setCredDisponibleLineaCP(resultSet.getString("CredDisponibleFP"));	
			beanResponse.setTasaInteresOrdinariaCP(resultSet.getString("TasaAnualFP"));
			beanResponse.setTasaInteresMoratoriaCP(resultSet.getString("TasaMoraFP"));
			beanResponse.setInteresOrdinarioCP(resultSet.getString("SalIntOrdinFP"));
			beanResponse.setInteresMoratorioCP(resultSet.getString("SalIntMoraFP"));
			beanResponse.setInteresRefinanciadoCP(resultSet.getString("IntereRefinanFP"));
			beanResponse.setInteresReversoCobroCP(resultSet.getString("IntereReversoFP"));
			beanResponse.setSaldoBaseCobroCP(resultSet.getString("SaldoPromedioFP"));
			beanResponse.setNumeroDiasCalculoCP(resultSet.getString("NumDiasIntFP"));
			beanResponse.setComisionGeneCP(resultSet.getString("MontoComisionFP"));
			beanResponse.setMontoCondonacionCP(resultSet.getString("MontoCondonaFP"));
			beanResponse.setMontoQuitasCP(resultSet.getString("MontoQuitasFP"));
			beanResponse.setMontoBonificacionCP(resultSet.getString("MontoBonificaFP"));
			beanResponse.setMontoDescuentosCP(resultSet.getString("MontoDescuentoFP"));	
			beanResponse.setMontoAumentosDecreCP(resultSet.getString("MtoAumenDecrePrincFP"));
			beanResponse.setCapitalPagEfecCP(resultSet.getString("CapitalPagadoFP"));
			beanResponse.setPagoIntOrdinarioCP(resultSet.getString("IntOrdiPagadoFP"));
			beanResponse.setPagoIntMoratorioCP(resultSet.getString("IntMoraPagadoFP"));
			beanResponse.setPagoComisionesCP(resultSet.getString("MtoComisiPagadoFP"));
			beanResponse.setPagoAccesoriosCP(resultSet.getString("OtrAccesoriosPagadoFP"));
			beanResponse.setPagoTotalCP(resultSet.getString("MontoPagadoEfecFP"));
			beanResponse.setSaldoPrincipalFinalCP(resultSet.getString("SalCapitalFP"));
			beanResponse.setSaldoInsolutoCP(resultSet.getString("SaldoInsolutoFP"));
			beanResponse.setSituacionCreditoCP(resultSet.getString("SituacContable"));	
			beanResponse.setTipoRecuperacionCP(resultSet.getString("TipoRecuperacion"));
			beanResponse.setNumeroDiasMoraCP(resultSet.getString("NumDiasAtraso"));
			beanResponse.setFechaUltPagoCompleto(resultSet.getString("FechaUltPagoCompleto"));
			beanResponse.setMontoUltPagocompleto(resultSet.getString("MontoUltiPagoFP"));
			beanResponse.setFechaPrimAmortizacionNC(resultSet.getString("FechaPrimAmortizacionNC"));
			
			
			beanResponse.setTipoGarantia(resultSet.getString("TipoGarantia"));
			beanResponse.setNumeroGarantias(resultSet.getString("NumGarantias"));
			beanResponse.setProgCredGobierno(resultSet.getString("ProgramaCred"));
			beanResponse.setMontoGarantia(resultSet.getString("MontoTotGarantias"));
			beanResponse.setPorcentajeGarSaldo(resultSet.getString("PorcentajeGarantia"));
			beanResponse.setGradoPrelacionGar(resultSet.getString("GradoPrelacionGar"));	
			beanResponse.setFechaValuacion(resultSet.getString("FechaValuacion"));
			beanResponse.setNumeroAvales(resultSet.getString("NumeroAvales"));
			beanResponse.setPorcentajeGarAvales(resultSet.getString("PorcentajeAvales"));
			beanResponse.setNombreGarante(resultSet.getString("NombreGarante"));
			beanResponse.setRfcGarante(resultSet.getString("RFCGarante"));
			
			
			beanResponse.setTipoCartera(resultSet.getString("TipoCartera"));
			beanResponse.setCalParteCubierta(resultSet.getString("CalifCubierta"));
			beanResponse.setCalParteExpuesta(resultSet.getString("CalifExpuesta"));
			beanResponse.setZonaMarginada(resultSet.getString("ZonaMarginada"));
			beanResponse.setClavePrevencion(resultSet.getString("ClavePrevencion"));	
			beanResponse.setFuenteFondeo(resultSet.getString("TipoRecursos"));
			beanResponse.setPorcentajeCubierto(resultSet.getString("PorcentajeCubierto"));
			beanResponse.setMontoCubierto(resultSet.getString("MontoCubierto"));
			beanResponse.setMontoEPRCCubierto(resultSet.getString("ReservaCubierta"));
			beanResponse.setPorcentajeExpuesto(resultSet.getString("PorcentajeExpuesto"));
			beanResponse.setMontoExpuesto(resultSet.getString("MontoExpuesto"));
			beanResponse.setMontoEPRCExpuesto(resultSet.getString("ReservaExpuesta"));
			beanResponse.setMontoEPRCTotales(resultSet.getString("ReservaTotal"));
			beanResponse.setMontoEPRCAdiRiesgoOpe(resultSet.getString("ReservaSIC"));
			beanResponse.setMontoEPRCAdiIntDevNC(resultSet.getString("ReservaAdicional"));
			beanResponse.setMontoEPRCAdiCNBV(resultSet.getString("ReservaAdiCNBV"));
			beanResponse.setMontoEPRCAdiTotales(resultSet.getString("ResevaAdiTotal"));;
			beanResponse.setMontoEPRCAdiCtaOrden(resultSet.getString("ResevaAdiCtaOrden"));
			beanResponse.setMontoEPRCMesAnterior(resultSet.getString("EstimaPrevenMesAnt"));
			
			return beanResponse ;
			}
		});
		return matches;
	}
	
	
}
