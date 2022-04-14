package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
 
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import regulatorios.bean.CalificacionYEstimacionB0417Bean;
import regulatorios.bean.EstimacionPreventivaA419Bean;
import regulatorios.bean.DesagregadoCarteraC0451Bean;

public class RegulatoriosCarteraDAO extends BaseDAO {

	public RegulatoriosCarteraDAO() {
		super();
	}
	
	/* =========== FUNCIONES PARA OBTENER INFORMACION PARA LOS REPORTES ============= */
	
	/**
	 * Consulta para Reporte de Cartera de Calificacion y Estimaciones Preventivas
	 * Serie R04: B0417
	 * @param b0417Bean
	 * @param tipoLista
	 * @return
	 */
	public List <CalificacionYEstimacionB0417Bean> consultaRegulatorioB0417(final CalificacionYEstimacionB0417Bean b0417Bean, int tipoLista){	
		
		String query = "call REGCALRESTIPCRE(?,?, ?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(b0417Bean.getFecha()),
							tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCALRESTIPCRE(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CalificacionYEstimacionB0417Bean regB0417Bean= new CalificacionYEstimacionB0417Bean();
				regB0417Bean.setConcepto(resultSet.getString(1));
				regB0417Bean.setCarteraBase(resultSet.getString(2));
				regB0417Bean.setMontoEstimacion(resultSet.getString(3));
				regB0417Bean.setEstilo(resultSet.getString(5));
				regB0417Bean.setColorCelda(resultSet.getString(6));

				return regB0417Bean ;
			}
		});
		return matches;
	}
	
	/**
	 * Consulta para Reporte de Cartera de Calificacion y Estimaciones Preventivas
	 * Serie R04: B0417 Version 2015
	 * @param b0417Bean
	 * @param tipoLista
	 * @return
	 */
	public List<CalificacionYEstimacionB0417Bean> consultaRegulatorioB0417Version2015(
			final CalificacionYEstimacionB0417Bean b0417Bean, int tipoLista) {
		int numero_decimales=2;
		String query = "call REGCARTERA417REP(?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(b0417Bean.getFecha()),
							tipoLista,
							numero_decimales,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCARTERA417REP(" + Arrays.toString(parametros) +")");
	try{
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CalificacionYEstimacionB0417Bean regB0417Bean = new CalificacionYEstimacionB0417Bean();
					regB0417Bean.setPeriodo(resultSet.getString("Periodo"));
					regB0417Bean.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					regB0417Bean.setConceptoID(String.valueOf(resultSet.getLong("ConceptoID")));
					regB0417Bean.setClaveConcepto(resultSet.getString("ClaveConcepto"));
					regB0417Bean.setDescripcion(resultSet.getString("Descripcion"));
					regB0417Bean.setTipoCartera(String.valueOf(resultSet.getLong("TipoCartera")));
					regB0417Bean.setMontoCartera(String.valueOf(resultSet.getDouble("MontoCartera")));
					regB0417Bean.setClasificacion(resultSet.getString("Clasificacion"));
					regB0417Bean.setNivel(resultSet.getString("Nivel"));
					regB0417Bean.setFormulario(resultSet.getString("Formulario"));
					regB0417Bean.setTipomoneda(resultSet.getString("Tipomoneda"));
					regB0417Bean.setTipo_Saldo(resultSet.getString("Tipo_Saldo"));
				
				return regB0417Bean ;
			}
			
		});
	
		return matches;

		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	return null;
	}
	/**
	 * Consulta para Reporte de Cartera de Calificacion y Estimaciones Preventivas
	 * Serie R04: B0417 en CSV
	 * @param b0417Bean
	 * @param tipoLista
	 * @return
	 */
	public List <CalificacionYEstimacionB0417Bean> reporteRegulatorio0417Csv(final CalificacionYEstimacionB0417Bean b0417Bean, int tipoLista){	
		
		String query = "call REGCALRESTIPCRE(?,?, ?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(b0417Bean.getFecha()),
							tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCALRESTIPCRE(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CalificacionYEstimacionB0417Bean regB0417Bean= new CalificacionYEstimacionB0417Bean();
				regB0417Bean.setValor(resultSet.getString(1));

				return regB0417Bean ;
			}
		});
		return matches;
	}
	
	/**
	 * Consulta para Reporte de Cartera de Calificacion y Estimaciones Preventivas
	 * Serie R04: B0417 Version 2015 en CSV
	 * @param b0417Bean
	 * @param tipoLista
	 * @return
	 */
	public List <CalificacionYEstimacionB0417Bean> reporteRegulatorio0417CSVVersion2015(final CalificacionYEstimacionB0417Bean b0417Bean, int tipoLista){	
		
		String query = "call REGCARTERA417REP(?,?,?,  ?,?,?,?,?,?,?)";
		int numeroDecimales=2;
		Object[] parametros ={
							Utileria.convierteFecha(b0417Bean.getFecha()),
							tipoLista,
							numeroDecimales,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCARTERA417REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CalificacionYEstimacionB0417Bean regB0417Bean= new CalificacionYEstimacionB0417Bean();
				regB0417Bean.setValor(resultSet.getString(1));

				return regB0417Bean ;
			}
		});
		return matches;
	}
	
	// 
	/**
	 * Consulta para Reporte de Desagregado de Cartera
	 * Serie R04: C0451 en Excel version 2014
	 * @param c0451Bea
	 * @param tipoLista
	 * @return
	 */
	public List <DesagregadoCarteraC0451Bean> consultaRegulatorioC0451(final DesagregadoCarteraC0451Bean c0451Bea,int tipoLista){	
		
		String query = "call REGDESCARTERAREP(?,?,	?,?,?,?,?,?,?)";
		Object[] parametros ={
								Utileria.convierteFecha(c0451Bea.getFecha()),
								tipoLista,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGDESCARTERAREP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DesagregadoCarteraC0451Bean regC0451Bean = new DesagregadoCarteraC0451Bean();
					regC0451Bean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					regC0451Bean.setNumeroCliente(String.valueOf(resultSet.getLong("ClienteID")));
					regC0451Bean.setNumeroCredito(String.valueOf(resultSet.getLong("CreditoID")));
					regC0451Bean.setTipoPersona(String.valueOf(resultSet.getInt("TipoPersona")));
					regC0451Bean.setRfc(resultSet.getString("RFCOficial"));
					regC0451Bean.setClasifContable(resultSet.getString("ClasifConta"));
					regC0451Bean.setMontoOtorgado(resultSet.getString("MontoCredito"));
					regC0451Bean.setSaldoTotal(resultSet.getString("Responsabilidad"));
					regC0451Bean.setFechaDisposicion(resultSet.getString("FechaDisp"));
					regC0451Bean.setFechaVencimiento(resultSet.getString("FechaVencim"));
					regC0451Bean.setFormaAmortizacion(String.valueOf(resultSet.getInt("TipoAmorti")));
					regC0451Bean.setTasaInteres(resultSet.getString("Tasa"));
					regC0451Bean.setInteresNoCobrado(resultSet.getString("IntDevNoCob"));
					regC0451Bean.setInteresVencido(resultSet.getString("IntVencido"));
					regC0451Bean.setInteresCapitalizado(resultSet.getString("IntCapitalizado"));
					regC0451Bean.setSituacionCredito(String.valueOf(resultSet.getInt("SituacionCred")));
					regC0451Bean.setNumeroReestructuras(String.valueOf(resultSet.getInt("NumReest")));
					regC0451Bean.setCalifCubierta(resultSet.getString("CalifCubierta"));
					regC0451Bean.setCalifExpuesta(resultSet.getString("CalifExpuesta"));
					regC0451Bean.setEstimacionCubierta(resultSet.getString("EstimCubierta"));
					regC0451Bean.setEstimacionExpuesta(resultSet.getString("EstimExpuesta"));
					regC0451Bean.setEstimacionTotal(resultSet.getString("EstimTotales"));
					regC0451Bean.setPorcentajeGarAval(resultSet.getString("PorcGarAval"));
					regC0451Bean.setValorGarantia(resultSet.getString("ValorEnGarantia"));
					regC0451Bean.setFechaValuaGarantia(resultSet.getString("FechaValuac"));
					regC0451Bean.setPrelacionGarantia(String.valueOf(resultSet.getInt("GradoPrela")));
					regC0451Bean.setClienteRelacionado(String.valueOf(resultSet.getInt("CteRelacio")));
					regC0451Bean.setClaveRelacionado(String.valueOf(resultSet.getInt("TipoRelaci")));
					regC0451Bean.setDiasAtraso(String.valueOf(resultSet.getInt("NumDiasMora")));
					regC0451Bean.setReciprocidad(resultSet.getString("Reciproc"));

					return regC0451Bean ;
				}
			});
			return matches;
	}
	/**
	 * Consulta para Reporte de Desagregado de Cartera
	 * Serie R04: C0451 en Excel version 2015
	 * @param c0451Bea
	 * @param tipoLista
	 * @return
	 */
	public List <DesagregadoCarteraC0451Bean> consultaRegulatorioC0451Ver2015(final DesagregadoCarteraC0451Bean c0451Bea,int tipoLista){	
		int numero_decimales=2;
		String query = "call REGDESCARTERAIIREP(?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(c0451Bea.getFecha()),
							tipoLista,
							numero_decimales,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGDESCARTERAIIREP(" + Arrays.toString(parametros) +")");
	try{
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {DesagregadoCarteraC0451Bean regC0451Bean = new DesagregadoCarteraC0451Bean();
				regC0451Bean.setApellidoMat(resultSet.getString("ApellidoMat"));
				regC0451Bean.setApellidoPat(resultSet.getString("ApellidoPat"));
				regC0451Bean.setCalifCubierta(resultSet.getString("CalifCubierta"));
				regC0451Bean.setCalifExpuesta(resultSet.getString("CalifExpuesta"));
				regC0451Bean.setCalifiIndiv(resultSet.getString("CalifiIndiv"));
				regC0451Bean.setClasifConta(resultSet.getString("ClasifConta"));
				regC0451Bean.setClaveSIC(resultSet.getString("ClaveSIC"));
				regC0451Bean.setClaveSucursal(resultSet.getString("ClaveSucursal"));
				regC0451Bean.setClienteID(String.valueOf(resultSet.getLong("ClienteID")));
				regC0451Bean.setCreditoID(String.valueOf(resultSet.getLong("CreditoID")));
				regC0451Bean.setCURP(resultSet.getString("CURP"));
				regC0451Bean.setDenominacion(resultSet.getString("Denominacion"));
				regC0451Bean.setEPRCAdiCarVen(resultSet.getString("EPRCAdiCarVen"));
				regC0451Bean.setEPRCAdiCNVB(resultSet.getString("EPRCAdiCNVB"));
				regC0451Bean.setEPRCAdiSIC(resultSet.getString("EPRCAdiSIC"));
				regC0451Bean.setEstadoClave(resultSet.getString("EstadoClave"));
				regC0451Bean.setFecConsultaSIC(resultSet.getString("FecConsultaSIC"));
				regC0451Bean.setFechaDisp(resultSet.getString("FechaDisp"));
				regC0451Bean.setFechaVencim(resultSet.getString("FechaVencim"));
				regC0451Bean.setFecPrimAtraso(resultSet.getString("FecPrimAtraso"));
				regC0451Bean.setFecUltCondona(resultSet.getString("FecUltCondona"));
				regC0451Bean.setFecUltPagoCap(resultSet.getString("FecUltPagoCap"));
				regC0451Bean.setFecUltPagoInt(resultSet.getString("FecUltPagoInt"));
				regC0451Bean.setGenero(resultSet.getString("Genero"));
				regC0451Bean.setGtiaHipotecaria(resultSet.getString("GtiaHipotecaria"));
				regC0451Bean.setIntereRefinan(resultSet.getString("IntereRefinan"));
				regC0451Bean.setMontoCondona(resultSet.getString("MontoCondona"));			
				regC0451Bean.setMontoCredito(resultSet.getString("MontoCredito"));
				regC0451Bean.setMonUltPagoCap(resultSet.getString("MonUltPagoCap"));
				regC0451Bean.setMonUltPagoInt(resultSet.getString("MonUltPagoInt"));
				regC0451Bean.setMunicipioClave(resultSet.getString("MunicipioClave"));
				regC0451Bean.setNumDiasAtraso(String.valueOf(resultSet.getInt("NumDiasAtraso")));
				regC0451Bean.setPeriodicidadCap(String.valueOf(resultSet.getInt("PeriodicidadCap")));
				regC0451Bean.setPeriodicidadInt(String.valueOf(resultSet.getInt("PeriodicidadInt")));
				regC0451Bean.setProductoCredito(resultSet.getString("ProductoCredito"));
				regC0451Bean.setReservaCubierta(resultSet.getString("ReservaCubierta"));
				regC0451Bean.setReservaExpuesta(resultSet.getString("ReservaExpuesta"));
				regC0451Bean.setRFC(resultSet.getString("RFC"));
				regC0451Bean.setSalCapital(resultSet.getString("SalCapital"));
				regC0451Bean.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));
				regC0451Bean.setSalIntCtaOrden(resultSet.getString("SalIntCtaOrden"));
				regC0451Bean.setSalIntMora(resultSet.getString("SalIntMora"));
				regC0451Bean.setSalIntOrdin(resultSet.getString("SalIntOrdin"));
				regC0451Bean.setSalMoraCtaOrden(resultSet.getString("SalMoraCtaOrden"));
				regC0451Bean.setSituacContable(resultSet.getString("SituacContable"));
				//regC0451Bean.setSubReporte(String.valueOf(resultSet.getInt("SubReporte")));
				regC0451Bean.setTasaInteres(resultSet.getString("TasaInteres"));
				regC0451Bean.setTipCarCalifi(resultSet.getString("TipCarCalifi"));
				regC0451Bean.setTipoAmorti(String.valueOf(resultSet.getInt("TipoAmorti")));
				regC0451Bean.setTipoCredito(resultSet.getString("TipoCredito"));
				regC0451Bean.setTipoPersona(resultSet.getString("TipoPersona"));
				regC0451Bean.setTipoRelacion(resultSet.getString("TipoRelacion"));
				regC0451Bean.setTotGtiaLiquida(resultSet.getString("TotGtiaLiquida"));
				
				regC0451Bean.setVar_ClaveEntidad(resultSet.getString("Var_ClaveEntidad"));
				regC0451Bean.setVar_Periodo(resultSet.getString("Var_Periodo"));
				regC0451Bean.setFor_0451(resultSet.getString("For_0451"));
				
				return regC0451Bean ;
			}
			
		});
	
		return matches;

		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	return null;
	}
	
	/**
	 * Consulta para reporte de Desagregado de Cartera 
	 * Serie R04: C0451 en CSV Version 2014
	 * @param c0451Bea
	 * @param tipoLista
	 * @return
	 */
	public List <DesagregadoCarteraC0451Bean> reporteRegulatorio0451Csv(final DesagregadoCarteraC0451Bean c0451Bea,int tipoLista){	

		String query = "call REGDESCARTERAREP(?,?,	?,?,?,?,?,?,?)";
		Object[] parametros ={
								Utileria.convierteFecha(c0451Bea.getFecha()),
								tipoLista,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGDESCARTERAREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DesagregadoCarteraC0451Bean regC0451Bean = new DesagregadoCarteraC0451Bean();
				regC0451Bean.setValor(resultSet.getString(1));
				return regC0451Bean ;
			}
		});
		return matches;
	}
	
	/**
	 * Consulta para reporte de Desagregado de Cartera 
	 * Serie R04: C0451 en CSV Version 2015
	 * @param c0451Bea
	 * @param tipoLista
	 * @return
	 */
	public List <DesagregadoCarteraC0451Bean> reporteRegulatorio0451Version2015Csv(final DesagregadoCarteraC0451Bean c0451Bea,int tipoLista){	

		try
		{
		int numero_decimales=2;
		String query = "call REGDESCARTERAIIREP(?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(c0451Bea.getFecha()),
							tipoLista,
							numero_decimales,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGDESCARTERAIIREP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DesagregadoCarteraC0451Bean regC0451Bean = new DesagregadoCarteraC0451Bean();
				regC0451Bean.setValor(resultSet.getString(1));
				return regC0451Bean ;
			}
		});
		return matches;
		}
		catch(Exception x)
		{
			x.printStackTrace();
		}
		return null;
	}
	
	/**
	 * Consulta para Reporte de Estimación Preventiva A-0419
	 * Serie R04: A0419
	 * @param b0419Bean
	 * @param tipoLista
	 * @return
	 */
	public List <EstimacionPreventivaA419Bean> consultaRegulatorioA0419(final EstimacionPreventivaA419Bean a0419Bean, int tipoLista){	
		
		String query = "call REGCARTERA419REP(?,?,?, ?,?,?,?,?,?,?)";
		int numero_decimales=2;
		Object[] parametros ={
							Utileria.convierteFecha(a0419Bean.getFecha()),
							tipoLista,
							numero_decimales,
							
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCARTERA419REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EstimacionPreventivaA419Bean regA0419Bean= new EstimacionPreventivaA419Bean();
				regA0419Bean.setPeriodo(resultSet.getString("Periodo"));
				regA0419Bean.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				regA0419Bean.setSubReporte(resultSet.getString("SubReporte"));
				regA0419Bean.setClaveConcepto(resultSet.getString("ClaveConcepto"));
				regA0419Bean.setDescripcion(resultSet.getString("Descripcion"));
				regA0419Bean.setFormulario(resultSet.getString("Formulario"));
				regA0419Bean.setTipoMoneda(resultSet.getString("TipoMoneda"));
				regA0419Bean.setTipoCartera(resultSet.getString("TipoCartera"));
				regA0419Bean.setTipoSaldo(resultSet.getString("TipoSaldo"));
				regA0419Bean.setMonto(resultSet.getString("Monto"));
							
				
				return regA0419Bean ;
			}
		});
		return matches;
	}
	
	/**
	 * Consulta para Reporte de Estimación Preventiva A-0419
	 * Serie R04: A0419 en CSV
	 * @param a0419Bean
	 * @param tipoLista
	 * @return
	 */
	public List <EstimacionPreventivaA419Bean> reporteRegulatorio0419(final EstimacionPreventivaA419Bean a0419Bean, int tipoLista){	
		
		String query = "call REGCARTERA419REP(?,?,?,  ?,?,?,?,?,?,?)";
		int numeroDecimales=2;
		Object[] parametros ={
							Utileria.convierteFecha(a0419Bean.getFecha()),
							tipoLista,
							numeroDecimales,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCARTERA419REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EstimacionPreventivaA419Bean regA0419Bean= new EstimacionPreventivaA419Bean();
				regA0419Bean.setValor(resultSet.getString(1));

				return regA0419Bean ;
			}
		});
		return matches;
	}
}
