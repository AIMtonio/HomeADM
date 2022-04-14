package fira.dao;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import credito.bean.CreditosBean;
import credito.bean.ReporteMovimientosCreditosBean;
import fira.bean.AnaliticoContBean;
import fira.bean.PagosAnticipadosAgroBean;
import fira.bean.UniConceptosInvAgroBean;
import fira.servicio.CreditosAgroServicio;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
public class CreditosAgroDAO extends BaseDAO {
	ParametrosSesionBean	parametrosSesionBean;
	public CreditosAgroDAO() {
		super();
	}

	/**
	 * Metodo que obtiene los datos para el reporte de Analitico de cartera
	 * @param creditosBean : Bean con la informacion para filtrar
	 * @param tipoLista : Numero de Lista 3
	 * @return List<{@link CreditosBean}>
	 */
	public List<CreditosBean> consultaSaldosTotalesExcel(final CreditosBean creditosBean, int tipoLista) {
		transaccionDAO.generaNumeroTransaccion();
		List<CreditosBean> listaSaldosTot = null;
		try {
			String query = "call SALDOSTOTALESAGROREP(?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?)";

			Object[] parametros = {Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteEntero(creditosBean.getSucursal()),
					Utileria.convierteEntero(creditosBean.getMonedaID()),
					Utileria.convierteEntero(creditosBean.getProducCreditoID()),
					Utileria.convierteEntero(creditosBean.getPromotorID()),
					creditosBean.getSexo(),
					Utileria.convierteEntero(creditosBean.getEstadoID()),
					Utileria.convierteEntero(creditosBean.getMunicipioID()),
					Utileria.convierteEntero(creditosBean.getClasificacion()),

					Utileria.convierteEntero(creditosBean.getAtrasoInicial()),
					Utileria.convierteEntero(creditosBean.getAtrasoFinal()),

					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosAgroDAO.consultaSaldosTotalesExcel",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SALDOSTOTALESAGROREP(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CreditosBean creditosBean = new CreditosBean();
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setProducCreditoID(resultSet.getString("ProductoCreditoID"));
					creditosBean.setDescripcion(resultSet.getString("Descripcion"));
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					creditosBean.setSaldoCapVigent(resultSet.getString("SaldoCapVigent"));
					creditosBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
					creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditosBean.setSaldCapVenNoExi(resultSet.getString("SaldCapVenNoExi"));
					creditosBean.setSaldoInterProvi(resultSet.getString("SaldoInterProvi"));
					creditosBean.setSaldoInterAtras(resultSet.getString("SaldoInterAtras"));
					creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInterVenc"));
					creditosBean.setSaldoIntNoConta(resultSet.getString("SaldoIntNoConta"));
					creditosBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					creditosBean.setSaldoComFaltPago(resultSet.getString("SaldComFaltPago"));
					creditosBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
					creditosBean.setSaldoIVAInteres(resultSet.getString("SaldoIVAInteres"));
					creditosBean.setSaldoIVAMorator(resultSet.getString("SaldoIVAMorator"));
					creditosBean.setSalIVAComFalPag(resultSet.getString("SalIVAComFalPag"));
					creditosBean.setSaldoIVAComisi(resultSet.getString("SaldoIVAComisi"));
					creditosBean.setPasoCapAtraDia(resultSet.getString("PasoCapAtraDia"));
					creditosBean.setPasoCapVenDia(resultSet.getString("PasoCapVenDia"));
					creditosBean.setPasoCapVNEDia(resultSet.getString("PasoCapVNEDia"));
					creditosBean.setPasoIntAtraDia(resultSet.getString("PasoIntAtraDia"));
					creditosBean.setPasoIntVenDia(resultSet.getString("PasoIntVenDia"));
					creditosBean.setCapRegularizado(resultSet.getString("CapRegularizado"));
					creditosBean.setIntOrdDevengado(resultSet.getString("IntOrdDevengado"));
					creditosBean.setIntMorDevengado(resultSet.getString("IntMorDevengado"));
					creditosBean.setComisiDevengado(resultSet.getString("ComisiDevengado"));
					creditosBean.setPagoCapVigDia(resultSet.getString("PagoCapVigDia"));
					creditosBean.setPagoCapAtrDia(resultSet.getString("PagoCapAtrDia"));
					creditosBean.setPagoCapVenDia(resultSet.getString("PagoCapVenDia"));
					creditosBean.setPagoCapVenNexDia(resultSet.getString("PagoCapVenNexDia"));
					creditosBean.setPagoIntOrdDia(resultSet.getString("PagoIntOrdDia"));
					creditosBean.setPagoIntAtrDia(resultSet.getString("PagoIntAtrDia"));
					creditosBean.setPagoIntVenDia(resultSet.getString("PagoIntVenDia"));
					creditosBean.setPagoIntCalNoCon(resultSet.getString("PagoIntCalNoCon"));
					creditosBean.setPagoComisiDia(resultSet.getString("PagoComisiDia"));
					creditosBean.setPagoMoratorios(resultSet.getString("PagoMoratorios"));
					creditosBean.setPagoIvaDia(resultSet.getString("PagoIvaDia"));
					creditosBean.setIntCondonadoDia(resultSet.getString("IntCondonadoDia"));
					creditosBean.setMorCondonadoDia(resultSet.getString("MorCondonadoDia"));
					creditosBean.setIntDevCtaOrden(resultSet.getString("IntDevCtaOrden"));
					creditosBean.setCapCondonadoDia(resultSet.getString("CapCondonadoDia"));
					creditosBean.setComAdmonPagDia(resultSet.getString("ComAdmonPagDia"));
					creditosBean.setComCondonadoDia(resultSet.getString("ComCondonadoDia"));
					creditosBean.setDesembolsosDia(resultSet.getString("DesembolsosDia"));
					creditosBean.setFrecuenciaCap(resultSet.getString("FrecuenciaCap"));
					creditosBean.setFrecuenciaInt(resultSet.getString("FrecuenciaInt"));
					creditosBean.setCapVigenteExi(resultSet.getString("CapVigenteExi"));
					creditosBean.setMontoTotalExi(resultSet.getString("MontoTotalExi"));
					creditosBean.setTasaFija(resultSet.getString("TasaFija"));

					creditosBean.setFechaInicio(resultSet.getString("FechaInicio"));
					creditosBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					creditosBean.setFechaUltAbonoCre(resultSet.getString("FechaUltAbonoCre"));
					creditosBean.setMontoCredito(resultSet.getString("MontoCredito"));
					creditosBean.setDiasAtraso(String.valueOf(resultSet.getInt("DiasAtraso")));
					creditosBean.setSaldoDispon(resultSet.getString("SaldoDispon"));
					creditosBean.setSaldoBloq(resultSet.getString("SaldoBloq"));
					creditosBean.setFechaUltDepCta(resultSet.getString("FechaUltDepCta"));
					creditosBean.setPromotorID(String.valueOf(resultSet.getInt("PromotorID")));
					creditosBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
					creditosBean.setFecha(resultSet.getString("FechaEmision"));
					creditosBean.setHora(resultSet.getString("HoraEmision"));

					creditosBean.setMoraVencido(resultSet.getString("MoraVencido"));
					creditosBean.setMoraCarVen(resultSet.getString("MoraCarVen"));
					creditosBean.setFormula(resultSet.getString("Formula"));
					creditosBean.setMontoSeguroCuota(resultSet.getString("MontoSeguroCuota"));
					creditosBean.setiVASeguroCuota(resultSet.getString("IVASeguroCuota"));
					creditosBean.setCobraSeguroCuota(resultSet.getString("ExisteCredCobraSeguro"));
					creditosBean.setFolioFondeo(resultSet.getString("FolioFondeo"));

					creditosBean.setDestinoCredID(resultSet.getString("DestinoCredID"));
					creditosBean.setDesDestino(resultSet.getString("DesDestino"));
					creditosBean.setFuenteFondeo(resultSet.getString("FuenteFondeo"));
					creditosBean.setCreditoFondeoID(resultSet.getString("CreditoFondeoID"));
					creditosBean.setAcreditadoIDFIRA(resultSet.getString("AcreditadoIDFIRA"));
					creditosBean.setCreditoIDFIRA(resultSet.getString("CreditoIDFIRA"));
					creditosBean.setTipoGarantia(resultSet.getString("TipoGarantia"));
					creditosBean.setClaseCredito(resultSet.getString("ClaseCredito"));
					creditosBean.setCveRamaFIRA(resultSet.getString("CveRamaFIRA"));
					creditosBean.setDescripcionRamaFIRA(resultSet.getString("DescripcionRamaFIRA"));
					creditosBean.setFechaOtorgamiento(resultSet.getString("FechaOtorgamiento"));
					creditosBean.setFechaProxVenc(resultSet.getString("FechaProxVenc"));
					creditosBean.setMontoProxVenc(resultSet.getString("MontoProxVenc"));
					creditosBean.setActividadFIRAID(resultSet.getString("ActividadFIRAID"));
					creditosBean.setActividadDes(resultSet.getString("ActividadDes"));
					creditosBean.setCveCadena(resultSet.getString("CveCadena"));
					creditosBean.setNomCadenaProdSCIAN(resultSet.getString("NomCadenaProdSCIAN"));
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setProgEspecialFIRAID(resultSet.getString("ProgEspecialFIRAID"));
					creditosBean.setSubPrograma(resultSet.getString("SubPrograma"));
					creditosBean.setTipoPersona(resultSet.getString("TipoPersona"));
					creditosBean.setPorcComision(resultSet.getString("PorcComision"));
					creditosBean.setConceptoInv(resultSet.getString("ConceptoInv"));
					creditosBean.setNumeroUnidades(resultSet.getString("NumeroUnidades"));
					creditosBean.setUnidadesMedida(resultSet.getString("UnidadesMedida"));
					creditosBean.setGrupoID(resultSet.getString("GrupoID"));
					creditosBean.setNombreGrupo(resultSet.getString("NombreGrupo"));
					creditosBean.setSaldoCapVigentePas(resultSet.getString("SaldoCapVigentePas"));
					creditosBean.setSaldoCapAtrasadPas(resultSet.getString("SaldoCapAtrasadPas"));
					creditosBean.setSaldoInteresProPas(resultSet.getString("SaldoInteresProPas"));
					creditosBean.setSaldoInteresAtraPas(resultSet.getString("SaldoInteresAtraPas"));
					creditosBean.setNombreSucursal(resultSet.getString("NombreSucursal"));

					return creditosBean;
				}
			});
			listaSaldosTot = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al generar reporte Analitico de cartera activa Agropecuaria" + e);
		}
		return listaSaldosTot;
	}

	/**
	 * Metodo que obtiene los datos para el reporte de Analitico de cartera Contingente
	 * @param creditosBean : Bean con la informacion para filtrar
	 * @param tipoLista : Numero de Lista 4
	 * @return List<{@link CreditosBean}>
	 */
	public List<AnaliticoContBean> consultaSaldosTotalesExcelCont(final CreditosBean creditosBean, int tipoLista) {
		transaccionDAO.generaNumeroTransaccion();
		List<AnaliticoContBean> listaSaldosTot = null;
		try {
			String query = "call SALDOSTOTALESCONTREP("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?,?		"
					+ ")";

			Object[] parametros = {
					parametrosAuditoriaBean.getNumeroTransaccion(),
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					tipoLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),

					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosAgroDAO.consultaSaldosTotalesExcelCont",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call SALDOSTOTALESCONTREP(  " + Arrays.toString(parametros) + ")");
			List<AnaliticoContBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					AnaliticoContBean creditosBean = new AnaliticoContBean();
					creditosBean.setCreditoFondeoID(resultSet.getString("CreditoFondeoID"));
					creditosBean.setCreditoID(resultSet.getString("CreditoID"));
					creditosBean.setCreditoIDCont(resultSet.getString("CreditoIDCont"));
					creditosBean.setAcreditadoIDFIRA(resultSet.getString("AcreditadoIDFIRA"));
					creditosBean.setCreditoIDFIRA(resultSet.getString("CreditoIDFIRA"));
					creditosBean.setClienteID(resultSet.getString("ClienteID"));
					creditosBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					creditosBean.setCreditoIDSinFon(resultSet.getString("CreditoIDSinFon"));
					creditosBean.setCreditoIDPagoFira(resultSet.getString("CreditoIDPagoFira"));
					creditosBean.setFechaOtorgamiento(resultSet.getString("FechaOtorgamiento"));
					creditosBean.setMontoGarAfec(resultSet.getString("MontoGarAfec"));
					creditosBean.setFechaProxVenc(resultSet.getString("FechaProxVenc"));
					creditosBean.setMontoProxVenc(resultSet.getString("MontoProxVenc"));
					creditosBean.setFechaUltVenc(resultSet.getString("FechaUltVenc"));
					creditosBean.setEstatus(resultSet.getString("Estatus"));
					creditosBean.setSalCapVigente(resultSet.getString("SalCapVigente"));
					creditosBean.setSalCapAtrasado(resultSet.getString("SalCapAtrasado"));
					creditosBean.setSalIntProvision(resultSet.getString("SalIntProvision"));
					creditosBean.setSalIntVencido(resultSet.getString("SalIntVencido"));
					creditosBean.setSaldoMoraCarVen(resultSet.getString("SaldoMoraCarVen"));
					creditosBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					creditosBean.setSaldoInterVenc(resultSet.getString("SaldoInterVenc"));
					creditosBean.setSalComFaltaPago(resultSet.getString("SalComFaltaPago"));
					creditosBean.setSalOtrasComisi(resultSet.getString("SalOtrasComisi"));
					creditosBean.setIVAInteresPagado(resultSet.getString("IVAInteresPagado"));
					creditosBean.setIVAInteresVenc(resultSet.getString("IVAInteresVenc"));
					creditosBean.setIVAMoraPag(resultSet.getString("IVAMoraPag"));
					creditosBean.setIVAComFaltaPago(resultSet.getString("IVAComFaltaPago"));
					creditosBean.setIVAOtrasCom(resultSet.getString("IVAOtrasCom"));
					creditosBean.setSucursal(resultSet.getString("Sucursal"));
					creditosBean.setNombreSucurs(resultSet.getString("NombreSucurs"));
					creditosBean.setTipoGarantiaFIRAID(resultSet.getString("TipoGarantiaFIRAID"));
					creditosBean.setGarantiaDes(resultSet.getString("GarantiaDes"));
					creditosBean.setClasificacionCred(resultSet.getString("ClasificacionCred"));
					creditosBean.setRamaFIRAID(resultSet.getString("RamaFIRAID"));
					creditosBean.setRamaFiraDes(resultSet.getString("RamaFiraDes"));
					creditosBean.setActividadFIRAID(resultSet.getString("ActividadFIRAID"));
					creditosBean.setActividadDes(resultSet.getString("ActividadDes"));
					creditosBean.setCadenaProductivaID(resultSet.getString("CadenaProductivaID"));
					creditosBean.setCadenaProDes(resultSet.getString("CadenaProDes"));
					creditosBean.setProgEspecialFIRAID(resultSet.getString("ProgEspecialFIRAID"));
					creditosBean.setProgEspecialDes(resultSet.getString("ProgEspecialDes"));
					creditosBean.setTipoPersona(resultSet.getString("TipoPersona"));
					creditosBean.setConceptoInversion(resultSet.getString("ConceptoInversion"));
					creditosBean.setUnidades(resultSet.getString("Unidades"));
					creditosBean.setConceptoUnidades(resultSet.getString("ConceptoUnidades"));
					creditosBean.setTipoUnidades(resultSet.getString("TipoUnidades"));
					creditosBean.setTasaPasiva(resultSet.getString("TasaPasiva"));
					creditosBean.setNumSocios(resultSet.getString("NumSocios"));

					return creditosBean;
				}
			});
			listaSaldosTot = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al generar reporte Analitico de cartera Contingente Agropecuaria" + e);
		}
		return listaSaldosTot;
	}
	/**
	 * Consulta del reporte de Movimientos de Creditos Contingentes
	 * @param creditosBean : {@link CreditosBean} bean con la informacion a filtrar.
	 * @param tipoLista : {@link CreditosAgroServicio.Enum_Lis_CredRep} Lista 5
	 * @return List<{@link ReporteMovimientosCreditosBean}>
	 */
	public List<ReporteMovimientosCreditosBean> consultaReporteMovimientosCreditoCont(final CreditosBean creditosBean, int tipoLista) {
		List<ReporteMovimientosCreditosBean> ListaResultado = null;
		try {
			String query = "call CREDMOVIMICONTREP("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?,?)";

			Object[] parametros = {
					Utileria.convierteLong(creditosBean.getCreditoID()),
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteFecha(creditosBean.getFechaVencimien()),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDMOVIMICONTREP(  " + Arrays.toString(parametros) + ")");
			List<ReporteMovimientosCreditosBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteMovimientosCreditosBean reporteMovimientosCreditosBean = new ReporteMovimientosCreditosBean();
					reporteMovimientosCreditosBean.setAmortiCreID(resultSet.getString("AmortiCreID"));
					reporteMovimientosCreditosBean.setTransaccion(resultSet.getString("Transaccion"));
					reporteMovimientosCreditosBean.setFechaOperacion(resultSet.getString("FechaOperacion"));
					reporteMovimientosCreditosBean.setFechaAplicacion(resultSet.getString("FechaAplicacion"));
					reporteMovimientosCreditosBean.setDescripcion(resultSet.getString("Descripcion"));
					reporteMovimientosCreditosBean.setTipoMovCreID(resultSet.getString("TipoMovCreID"));
					reporteMovimientosCreditosBean.setNatMovimiento(resultSet.getString("NatMovimiento"));
					reporteMovimientosCreditosBean.setMonedaID(resultSet.getString("MonedaID"));
					reporteMovimientosCreditosBean.setCantidad(resultSet.getString("Cantidad"));
					reporteMovimientosCreditosBean.setReferencia(resultSet.getString("Referencia"));
					reporteMovimientosCreditosBean.setTipoMov(resultSet.getString("TipoMov"));
					reporteMovimientosCreditosBean.setHoraMov(resultSet.getString("HoraMov"));
					reporteMovimientosCreditosBean.setFechaEmision(resultSet.getString("FechaEmision"));
					reporteMovimientosCreditosBean.setCuentaID(resultSet.getString("CuentaID"));
					reporteMovimientosCreditosBean.setHoraEmision(resultSet.getString("HoraEmision"));
					return reporteMovimientosCreditosBean;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta de reporte de movimientos Contingente.", e);
		}
		return ListaResultado;
	}
	/**
	 * Consulta del reporte de Movimientos de Creditos Contingentes Sumarizado
	 * @param creditosBean : {@link CreditosBean} bean con la informacion a filtrar.
	 * @param tipoLista : {@link CreditosAgroServicio.Enum_Lis_CredRep} Lista 6
	 * @return List<{@link ReporteMovimientosCreditosBean}>
	 */
	public List consultaReporteMovimientosCreditoSum(final CreditosBean creditosBean, int tipoLista) {
		List ListaResultado = null;
		try {
			String query = "call CREDMOVIMISUMCONTREP("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?,?)";

			Object[] parametros = {
					Utileria.convierteLong(creditosBean.getCreditoID()),
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteFecha(creditosBean.getFechaVencimien()),

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(), Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call CREDMOVIMISUMCONTREP(  " + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteMovimientosCreditosBean reporteMovimientosCreditosBean = new ReporteMovimientosCreditosBean();
					reporteMovimientosCreditosBean.setFecha(resultSet.getString("Fecha"));
					reporteMovimientosCreditosBean.setDescripcions(resultSet.getString("Descripcion"));
					reporteMovimientosCreditosBean.setMonto(Double.valueOf(resultSet.getString("Monto")).doubleValue());
					reporteMovimientosCreditosBean.setCapital(Double.valueOf(resultSet.getString("PagoCapital")).doubleValue());
					reporteMovimientosCreditosBean.setInteresNormal(Double.valueOf(resultSet.getString("PagoInteres")).doubleValue());
					reporteMovimientosCreditosBean.setIvainteresNormal(Double.valueOf(resultSet.getString("IVAInteres")).doubleValue());
					reporteMovimientosCreditosBean.setInteresMoratorio(Double.valueOf(resultSet.getString("PagoMora")).doubleValue());
					reporteMovimientosCreditosBean.setIvainteresMoratorio(Double.valueOf(resultSet.getString("IVAMora")).doubleValue());
					reporteMovimientosCreditosBean.setComisionFaltapago(Double.valueOf(resultSet.getString("PagoComisiones")).doubleValue());
					reporteMovimientosCreditosBean.setIvaComisiones(Double.valueOf(resultSet.getString("IVAComisiones")).doubleValue());
					reporteMovimientosCreditosBean.setHoraMov(resultSet.getString("HoraEmision"));
					reporteMovimientosCreditosBean.setMonedaID(resultSet.getString("MonedaID"));
					reporteMovimientosCreditosBean.setCuentaID(resultSet.getString("CuentaID"));
					reporteMovimientosCreditosBean.setMontoSeguroCuota(Double.valueOf(resultSet.getString("MontoSeguroCuota")));
					reporteMovimientosCreditosBean.setMontoIVASeguroCuota(Double.valueOf(resultSet.getString("MontoSeguroCuota")));
					reporteMovimientosCreditosBean.setCobraSeguroCuota(resultSet.getString("CobraSeguroCuota"));
					return reporteMovimientosCreditosBean;
				}
			});
			ListaResultado = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en consulta de reporte de movimientos Contingentes Sumarizado.", e);
		}
		return ListaResultado;
	}

	/**
	 * Método para el reporte de Pagos Anticipados de la Cartera Agro.
	 * @param creditosBean : bean con la información para filtrar el reporte
	 * @param tipoLista : Tipo de Reporte
	 * @return List<CreditosBean>
	 */


	public List<PagosAnticipadosAgroBean> pagosAnticipadosAgroRep(final CreditosBean creditosBean, int tipoLista) {
		transaccionDAO.generaNumeroTransaccion();
		List listaSaldosTot = null;
		try {
			String query = "call PAGOSANTICIPADOSREP("
					+ "?,?,?,?,?,		"
					+ "?,?,?,?,?)";

			Object[] parametros = {
					Utileria.convierteFecha(creditosBean.getFechaInicio()),
					Utileria.convierteFecha(creditosBean.getFechaFinal()),
					2,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CreditosDAO.pagosAnticipadosRep",

					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PAGOSANTICIPADOSREP(  " + Arrays.toString(parametros) + ")");
			List<PagosAnticipadosAgroBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PagosAnticipadosAgroBean pagosBean = new PagosAnticipadosAgroBean();
					pagosBean.setClienteID(resultSet.getString("ClienteID"));
					pagosBean.setNombreCliente(resultSet.getString("NombreCliente"));
					pagosBean.setTipoCredito(resultSet.getString("TipoCredito"));
					pagosBean.setCreditoID(resultSet.getString("CreditoID"));
					pagosBean.setNombreSucursal(resultSet.getString("NombreSucursal"));
					pagosBean.setNombreInstFon(resultSet.getString("NombreInstitFon"));
					pagosBean.setCreditoFondeoID(resultSet.getString("CreditoPasivoID"));
					pagosBean.setCreditoFondeadorID(resultSet.getString("CreditoFondeoID"));
					pagosBean.setFechaVencimiento(resultSet.getString("FechaVencim"));
					pagosBean.setFechaDeposito(resultSet.getString("FechaDeposito"));
					pagosBean.setFechaAplicacion(resultSet.getString("FechaAplicacion"));
					pagosBean.setDiasDepAplica(resultSet.getString("DiasDepAplica"));
					pagosBean.setCapital(resultSet.getString("Capital"));
					pagosBean.setInteresOrdinario(resultSet.getString("InteresOrd"));
					pagosBean.setInteresMoratorio(resultSet.getString("InteresMoratorio"));
					pagosBean.setIva(resultSet.getString("IVA"));
					pagosBean.setTotal(resultSet.getString("TotalPagado"));
					pagosBean.setFechaPagoFondeo(resultSet.getString("FechaPagoFondeo"));
					pagosBean.setDiasPagoAplicaFond(resultSet.getString("DiasPagoFondeo"));
					pagosBean.setMontoPagoFondeo(resultSet.getString("MontoPagoFondeo"));
					return pagosBean;
				}
			});
			listaSaldosTot = matches;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error al generar reporte de Pagos por Anticipados Agro " + e);
		}
		return listaSaldosTot;
	}


	public MensajeTransaccionBean altaUnidadConcepto(int tipoTransaccion, final UniConceptosInvAgroBean unidad) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call UNIDADCONINVAGROALT(" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		" +
									"?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							try {
								sentenciaStore.setInt("Par_UniConceptoInvID",Utileria.convierteEntero(unidad.getUniConceptoInvID()));
								sentenciaStore.setString("Par_Unidad", unidad.getUnidad());
								sentenciaStore.setString("Par_Clave", unidad.getClave());
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

								sentenciaStore.setString("Aud_ProgramaID", "ConceptosInverDAO.alta");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							} catch (Exception ex) {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								mensajeTransaccion.setNumero(403);
								mensajeTransaccion.setDescripcion("BASE DE DATOS");
								ex.printStackTrace();
							}

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Alta de Unidad: ." + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaUnidadConcepto(int tipoTransaccion,final UniConceptosInvAgroBean unidad) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call UNIDADCONINVAGROMOD(" +
									"?,?,?,?,?,		" +
									"?,?,?,?,?,		"
									+ "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							try {
								sentenciaStore.setInt("Par_UniConceptoInvID", Utileria.convierteEntero(unidad.getUniConceptoInvID()));
								sentenciaStore.setString("Par_Unidad", unidad.getUnidad());
								sentenciaStore.setString("Par_Clave", unidad.getClave());
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

								sentenciaStore.setString("Aud_ProgramaID", "ConceptosInverDAO.alta");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
							} catch (Exception ex) {
								ex.printStackTrace();
							}

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Modificación de Unidades: ." + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List<UniConceptosInvAgroBean> listaUnidadConceptoInv(UniConceptosInvAgroBean uniConceptosInvAgroBean, int tipoLista) {
		// Query con el Store Procedure
		String query = "call UNIDADCONINVAGROLIS("
				+ "?,?,?,?,?,	"
				+ "?,?,?,?);";
		Object[] parametros = {
				uniConceptosInvAgroBean.getClave(),
				tipoLista,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call UNIDADCONINVAGROLIS(" + Arrays.toString(parametros) + ")");
		List<UniConceptosInvAgroBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UniConceptosInvAgroBean bean = new UniConceptosInvAgroBean();
				bean.setUniConceptoInvID(String.valueOf(resultSet.getLong("UniConceptoInvID")));
				bean.setClave(resultSet.getString("Clave"));
				bean.setUnidad(resultSet.getString("Unidad"));

				return bean;
			}
		});
		return matches;
	}

	public UniConceptosInvAgroBean consultaUnidadConceptoInv(int tipoConsulta, UniConceptosInvAgroBean uniConceptosInvAgroBean) {
		// Query con el Store Procedure
		String query = "call UNIDADCONINVAGROCON("
				+ "?,?,?,?,?,	"
				+ "?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(uniConceptosInvAgroBean.getUniConceptoInvID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call UNIDADCONINVAGROCON(" + Arrays.toString(parametros) + ")");
		List<UniConceptosInvAgroBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				UniConceptosInvAgroBean bean = new UniConceptosInvAgroBean();
				bean.setUniConceptoInvID(String.valueOf(resultSet.getLong("UniConceptoInvID")));
				bean.setClave(resultSet.getString("Clave"));
				bean.setUnidad(resultSet.getString("Unidad"));

				return bean;
			}
		});
		return matches.size() > 0 ? matches.get(0) : null;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}



}