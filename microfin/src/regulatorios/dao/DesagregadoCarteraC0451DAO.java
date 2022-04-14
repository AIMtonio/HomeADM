package regulatorios.dao;
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
import regulatorios.bean.DesagregadoCarteraC0451Bean;

public class DesagregadoCarteraC0451DAO extends BaseDAO {

	public DesagregadoCarteraC0451DAO() {
		super();
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
					regC0451Bean.setFormula(resultSet.getString("Formula"));

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
				regC0451Bean.setFormula(resultSet.getString("Formula"));
				
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
	
	
	
	/*
	 * ===========================================================================================================================================
	 * 			SOFIPOS
	 * ===========================================================================================================================================
	 */
	/**
	 * Consulta para Reporte de Desagregado de Cartera
	 * Serie R04: C0451 en Excel version 2015
	 * @param c0451Bea
	 * @param tipoLista
	 * @return
	 */
	public List <DesagregadoCarteraC0451Bean> consultaRegulatorioC0451Sofipo(final DesagregadoCarteraC0451Bean c0451Bea,int tipoLista){	
		int numero_decimales=2;
		String query = "call REGULATORIOC0451REP(?,?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(c0451Bea.getFecha()),
							tipoLista,
							numero_decimales,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"consultaRegulatorioC0451Sofipo",
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOC0451REP(" + Arrays.toString(parametros) +")");
	try{
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DesagregadoCarteraC0451Bean regC0451Bean = new DesagregadoCarteraC0451Bean();
			
				regC0451Bean.setPeriodo(resultSet.getString("Periodo"));
				regC0451Bean.setClaveEntidad(resultSet.getString("ClaveEntidad"));
				regC0451Bean.setFor_0451(resultSet.getString("Reporte"));
				regC0451Bean.setClienteID(resultSet.getString("ClienteID"));
				regC0451Bean.setTipoCliente(resultSet.getString("TipoCliente"));
				regC0451Bean.setNombre(resultSet.getString("Nombre"));
				
				
				regC0451Bean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
				regC0451Bean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
				regC0451Bean.setPersoJuridica(resultSet.getString("PersoJuridica"));
				regC0451Bean.setGrupoRiesgo(resultSet.getString("GrupoRiesgo"));
				regC0451Bean.setActividadEco(resultSet.getString("ActividadEco"));
				
				regC0451Bean.setNacionalidad(resultSet.getString("Nacionalidad"));
				regC0451Bean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
				regC0451Bean.setRfc(resultSet.getString("RFC"));
				regC0451Bean.setCURP(resultSet.getString("CURP"));
				regC0451Bean.setGenero(resultSet.getString("Genero"));				
				
				regC0451Bean.setCalle(resultSet.getString("Calle"));
				regC0451Bean.setNumeroExt(resultSet.getString("NumeroExt"));
				regC0451Bean.setColonia(resultSet.getString("Colonia"));
				regC0451Bean.setCodigoPostal(resultSet.getString("CodigoPostal"));
				regC0451Bean.setLocalidad(resultSet.getString("Localidad"));
				
				regC0451Bean.setEstado(resultSet.getString("Estado"));
				regC0451Bean.setMunicipio(resultSet.getString("Municipio"));
				regC0451Bean.setPais(resultSet.getString("Pais"));
				regC0451Bean.setTipoRelacionado(resultSet.getString("TipoRelacionado"));
				regC0451Bean.setNumConsultaSIC(resultSet.getString("NumConsultaSIC"));
				
				regC0451Bean.setIngresosMes(resultSet.getString("IngresosMes"));
				regC0451Bean.setTamanioAcred(resultSet.getString("TamanioAcred"));
				regC0451Bean.setIdenCreditoCNBV(resultSet.getString("IdenCreditoCNBV"));
				regC0451Bean.setIdenGrupalCNBV(resultSet.getString("IdenGrupalCNBV"));
				regC0451Bean.setFechaOtorga(resultSet.getString("FechaOtorga"));
				
				regC0451Bean.setTipoAlta(resultSet.getString("TipoAlta"));
				regC0451Bean.setTipoCartera(resultSet.getString("TipoCartera"));
				regC0451Bean.setTipoProducto(resultSet.getString("TipoProducto"));
				regC0451Bean.setDestinoCred(resultSet.getString("DestinoCred"));
				regC0451Bean.setClaveSucursal(resultSet.getString("ClaveSucursal"));
				
				regC0451Bean.setNumeroCuenta(resultSet.getString("NumeroCuenta"));
				regC0451Bean.setNumContrato(resultSet.getString("NumContrato"));
				regC0451Bean.setNombreFacto(resultSet.getString("NombreFacto"));
				regC0451Bean.setrFCFactorado(resultSet.getString("RFCFactorado"));			
				regC0451Bean.setMontoLineaPes(resultSet.getString("MontoLineaPes"));
				
				regC0451Bean.setMontoLineaOri(resultSet.getString("MontoLineaOri"));
				regC0451Bean.setFechaMaxima(resultSet.getString("FechaMaxima"));		
				regC0451Bean.setFechaVencimien(resultSet.getString("FechaVencimien"));
				regC0451Bean.setFormaDisposi(resultSet.getString("FormaDisposi"));
				regC0451Bean.setTasaReferencia(resultSet.getString("TasaReferencia"));		
				
				regC0451Bean.setDiferencial(resultSet.getString("Diferencial"));
				regC0451Bean.setOpeDirencial(resultSet.getString("OpeDiferencial"));		
				regC0451Bean.setTipoMoneda(resultSet.getString("TipoMoneda"));
				regC0451Bean.setPeriodicidadCap(resultSet.getString("PeriodicidadCap"));
				regC0451Bean.setPeriodicidadInt(resultSet.getString("PeriodicidadInt"));	
				regC0451Bean.setPeriodoFactura(resultSet.getString("PeriodoFactura"));
				
				regC0451Bean.setComisionAper(resultSet.getString("ComisionAper"));		
				regC0451Bean.setMontoComAper(resultSet.getString("MontoComAper"));
				regC0451Bean.setComisionDispo(resultSet.getString("ComisionDispo"));
				regC0451Bean.setMontoComDispo(resultSet.getString("MontoComDispo"));
				regC0451Bean.setValorVivienda(resultSet.getString("ValorVivienda"));
				
				regC0451Bean.setValoAvaluo(resultSet.getString("ValoAvaluo"));
				regC0451Bean.setNumeroAvaluo(resultSet.getString("NumeroAvaluo"));
				regC0451Bean.setLTV(resultSet.getString("LTV"));
				regC0451Bean.setLocalidadCred(resultSet.getString("LocalidadCred"));
				regC0451Bean.setMunicipioCred(resultSet.getString("MunicipioCred"));
				
				regC0451Bean.setEstadoCred(resultSet.getString("EstadoCred"));
				regC0451Bean.setActividadEcoCred(resultSet.getString("ActividadEcoCred"));
				
				
				
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
	public List <DesagregadoCarteraC0451Bean> reporteRegulatorio0451SofipoCsv(final DesagregadoCarteraC0451Bean c0451Bea,int tipoLista){	
		int numero_decimales = 2;
		String query = "call REGULATORIOC0451REP(?,?,?,	?,?,?,?,?,?,?)";
		Object[] parametros ={
								Utileria.convierteFecha(c0451Bea.getFecha()),
								tipoLista,
								numero_decimales,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"reporteRegulatorio0451SofipoCsv",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOC0451REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DesagregadoCarteraC0451Bean regC0451Bean = new DesagregadoCarteraC0451Bean();
				regC0451Bean.setValor(resultSet.getString(1));
				return regC0451Bean ;
			}
		});
		return matches;
	}
	
	
}
	