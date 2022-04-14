package buroCredito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import buroCredito.bean.EnvioCintaCirculoBean;

public class EnvioCintaCirculoDAO extends BaseDAO {

	public EnvioCintaCirculoDAO() {
		super();
	}

	public List consultaCintaEnvio(EnvioCintaCirculoBean envioCintaCirculoBean){
		
		String query = "CALL CINTACIRCULOCREREP (?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {
					Utileria.convierteFecha(envioCintaCirculoBean.getFechaConsulta()),
					Utileria.convierteEntero(envioCintaCirculoBean.getTipoLista()),
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CINTACIRCULOCREREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EnvioCintaCirculoBean cintaCirculoBean = new EnvioCintaCirculoBean();
				
				cintaCirculoBean.setCreditoID(resultSet.getString("CreditoID"));
				cintaCirculoBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
				cintaCirculoBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
				cintaCirculoBean.setApellidoAdicional(resultSet.getString("ApellidoAdicional"));
				cintaCirculoBean.setNombre(resultSet.getString("Nombre"));
				cintaCirculoBean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
				cintaCirculoBean.setRfc(resultSet.getString("RFC"));
				cintaCirculoBean.setCurp(resultSet.getString("CURP"));
				cintaCirculoBean.setNumeroSeguridadSocial(resultSet.getString("NumeroSeguridadSocial"));
				cintaCirculoBean.setNacionalidad(resultSet.getString("Nacionalidad"));
				cintaCirculoBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
				cintaCirculoBean.setTipoResidencia(resultSet.getString("TipoResidencia"));
				cintaCirculoBean.setSexo(resultSet.getString("Sexo"));				
				cintaCirculoBean.setTipoPersona(resultSet.getString("TipoPersona"));
				cintaCirculoBean.setCalleYNumero(resultSet.getString("CalleYNumero"));
				cintaCirculoBean.setColonia(resultSet.getString("Colonia"));
				cintaCirculoBean.setMunicipio(resultSet.getString("Municipio"));
				cintaCirculoBean.setEstado(resultSet.getString("Estado"));
				cintaCirculoBean.setCodigoPostal(resultSet.getString("CodigoPostal"));
				cintaCirculoBean.setTelefonoDom(resultSet.getString("TelefonoDom"));
				cintaCirculoBean.setTipoDomicilio(resultSet.getString("TipoDomicilio"));
				cintaCirculoBean.setCentroTrabajo(resultSet.getString("CentroTrabajo"));
				cintaCirculoBean.setCalleYNumeroTra(resultSet.getString("CalleYNumeroTra"));
				cintaCirculoBean.setColoniaTra(resultSet.getString("ColoniaTra"));
				cintaCirculoBean.setMunicipioTra(resultSet.getString("MunicipioTra"));
				cintaCirculoBean.setEstadoTra(resultSet.getString("EstadoTra"));
				cintaCirculoBean.setCodigoPostalTra(resultSet.getString("CodigoPostalTra"));
				cintaCirculoBean.setTelefonoTra(resultSet.getString("TelefonoTra"));
				cintaCirculoBean.setPuestoTra(resultSet.getString("PuestoTra"));
				cintaCirculoBean.setTipoRespons(resultSet.getString("TipoRespons"));
				cintaCirculoBean.setTipoContrato(resultSet.getString("TipoContrato"));
				cintaCirculoBean.setMoneda(resultSet.getString("Moneda"));
				cintaCirculoBean.setTipoCuenta(resultSet.getString("TipoCuenta"));
				cintaCirculoBean.setFrecuenciaPago(resultSet.getString("FrecuenciaPago"));
				cintaCirculoBean.setFechaInicio(resultSet.getString("FechaInicio"));
				cintaCirculoBean.setFechaUltPago(resultSet.getString("FechaUltPago"));
				cintaCirculoBean.setPagoActual(resultSet.getString("PagoActual"));
				cintaCirculoBean.setNumAmortizaciones(resultSet.getString("NumAmortizacion"));
				cintaCirculoBean.setTotalCapital(resultSet.getString("TotalCapital"));
				cintaCirculoBean.setTotalDeuda(resultSet.getString("TotalDeuda"));
				cintaCirculoBean.setMontoPagar(resultSet.getString("MontoPagar"));
				cintaCirculoBean.setNumeroCuotasAtraso(resultSet.getString("NoCuotasAtraso"));
				cintaCirculoBean.setTotalVencido(resultSet.getString("TotalVencido"));
				cintaCirculoBean.setCreditoMaximo(resultSet.getString("CreditoMaximo"));
				cintaCirculoBean.setFechaCierre(resultSet.getString("FechaCierre"));
				cintaCirculoBean.setNumeroLicenciaConducir(resultSet.getString("NumLicenciaConducir"));
				cintaCirculoBean.setClaveIFE(resultSet.getString("ClaveElectorIFE"));
				cintaCirculoBean.setNumeroDependientes(resultSet.getString("NumDependientes"));
				cintaCirculoBean.setTipoAsentamiento(resultSet.getString("TipoAsentamiento"));
				cintaCirculoBean.setTipoAsentamientoTrabajo(resultSet.getString("TipoAsentamientoTrabajo"));
				cintaCirculoBean.setNumeroPagosEfectuados(resultSet.getString("NumPagosReportados"));
				cintaCirculoBean.setHistoricoPagos(resultSet.getString("HisPago"));
				cintaCirculoBean.setNumeroCreditoAnterior(resultSet.getString("NumCreditoAnterior"));
				cintaCirculoBean.setClavePrevencion(resultSet.getString("ClavePrevencion"));
				
				cintaCirculoBean.setOrigenDomicilio(resultSet.getString("OrigenDomicilio"));
				cintaCirculoBean.setRazonSocialDomicilio(resultSet.getString("RazonSocialDomicilio"));
				cintaCirculoBean.setFechaCarteraVencida(resultSet.getString("FechaCarteraVencida"));
				cintaCirculoBean.setFechaPrimIncumplimiento(resultSet.getString("FechaPrimerIncumplimiento"));
				cintaCirculoBean.setFormaPagoInteres(resultSet.getString("FormaPagoInteres"));
				cintaCirculoBean.setDiasVencidos(resultSet.getString("DiasVencimiento"));
				cintaCirculoBean.setCorreoElectronico(resultSet.getString("CorreoElectronico"));
				cintaCirculoBean.setTotalInteres(resultSet.getString("TotalInteres"));
				
				
				cintaCirculoBean.setDireccionMatriz(resultSet.getString("DireccionMatriz"));
				cintaCirculoBean.setNumeroElementos(resultSet.getString("NumElementos"));
				cintaCirculoBean.setSumaSaldosTotales(resultSet.getString("SumSaldoTot"));
				cintaCirculoBean.setSumaSaldosVencidos(resultSet.getString("SumSaldoVen"));
				
				cintaCirculoBean.setValorActivoValuacion(resultSet.getString("ValorActivoValuacion"));
				cintaCirculoBean.setMontoUltimoPago(resultSet.getString("MontoUltimoPago"));
				cintaCirculoBean.setPlazoMeses(resultSet.getString("PlazoMeses"));
				cintaCirculoBean.setMontoCreditoOrig(resultSet.getString("MontoCreditoOriginacion"));
				cintaCirculoBean.setFechaDefuncion(resultSet.getString("FechaDefuncion"));
				cintaCirculoBean.setIndicadorDefuncion(resultSet.getString("IndicadorDef"));
				cintaCirculoBean.setMontoSal(resultSet.getString("Monto"));
				cintaCirculoBean.setFechaIngreso(resultSet.getString("FechaIngreso"));
				
				return cintaCirculoBean;
			}
		});
		return matches;
	}
	
	public List consultaCintaEnvioVtaCar(EnvioCintaCirculoBean envioCintaCirculoBean){
		
		String query = "CALL CINTACIRCULOCREVTAREP (?,?,?,?,?,?,?,?,?);";
		List matches = null;
		try {
					
				Object[] parametros = {
							Utileria.convierteFecha(envioCintaCirculoBean.getFechaConsulta()),
							Utileria.convierteEntero(envioCintaCirculoBean.getTipoLista()),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
							};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CINTACIRCULOCREVTAREP(" + Arrays.toString(parametros) + ")");
				
				 matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						EnvioCintaCirculoBean cintaCirculoBean = new EnvioCintaCirculoBean();
						
						cintaCirculoBean.setCreditoID(resultSet.getString("CreditoID"));
						cintaCirculoBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
						cintaCirculoBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
						cintaCirculoBean.setApellidoAdicional(resultSet.getString("ApellidoAdicional"));
						cintaCirculoBean.setNombre(resultSet.getString("Nombre"));
						cintaCirculoBean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
						cintaCirculoBean.setRfc(resultSet.getString("RFC"));
						cintaCirculoBean.setCurp(resultSet.getString("CURP"));
						cintaCirculoBean.setNumeroSeguridadSocial(resultSet.getString("NumeroSeguridadSocial"));
						cintaCirculoBean.setNacionalidad(resultSet.getString("Nacionalidad"));
						cintaCirculoBean.setEstadoCivil(resultSet.getString("EstadoCivil"));
						cintaCirculoBean.setTipoResidencia(resultSet.getString("TipoResidencia"));
						cintaCirculoBean.setSexo(resultSet.getString("Sexo"));				
						cintaCirculoBean.setTipoPersona(resultSet.getString("TipoPersona"));
						cintaCirculoBean.setCalleYNumero(resultSet.getString("CalleYNumero"));
						cintaCirculoBean.setColonia(resultSet.getString("Colonia"));
						cintaCirculoBean.setMunicipio(resultSet.getString("Municipio"));
						cintaCirculoBean.setEstado(resultSet.getString("Estado"));
						cintaCirculoBean.setCodigoPostal(resultSet.getString("CodigoPostal"));
						cintaCirculoBean.setTelefonoDom(resultSet.getString("TelefonoDom"));
						cintaCirculoBean.setTipoDomicilio(resultSet.getString("TipoDomicilio"));
						cintaCirculoBean.setCentroTrabajo(resultSet.getString("CentroTrabajo"));
						cintaCirculoBean.setCalleYNumeroTra(resultSet.getString("CalleYNumeroTra"));
						cintaCirculoBean.setColoniaTra(resultSet.getString("ColoniaTra"));
						cintaCirculoBean.setMunicipioTra(resultSet.getString("MunicipioTra"));
						cintaCirculoBean.setEstadoTra(resultSet.getString("EstadoTra"));
						cintaCirculoBean.setCodigoPostalTra(resultSet.getString("CodigoPostalTra"));
						cintaCirculoBean.setTelefonoTra(resultSet.getString("TelefonoTra"));
						cintaCirculoBean.setPuestoTra(resultSet.getString("PuestoTra"));
						cintaCirculoBean.setTipoRespons(resultSet.getString("TipoRespons"));
						cintaCirculoBean.setTipoContrato(resultSet.getString("TipoContrato"));
						cintaCirculoBean.setMoneda(resultSet.getString("Moneda"));
						cintaCirculoBean.setTipoCuenta(resultSet.getString("TipoCuenta"));
						cintaCirculoBean.setFrecuenciaPago(resultSet.getString("FrecuenciaPago"));
						cintaCirculoBean.setFechaInicio(resultSet.getString("FechaInicio"));
						cintaCirculoBean.setFechaUltPago(resultSet.getString("FechaUltPago"));
						cintaCirculoBean.setPagoActual(resultSet.getString("PagoActual"));
						cintaCirculoBean.setNumAmortizaciones(resultSet.getString("NumAmortizacion"));
						cintaCirculoBean.setTotalCapital(resultSet.getString("TotalCapital"));
						cintaCirculoBean.setTotalDeuda(resultSet.getString("TotalDeuda"));
						cintaCirculoBean.setMontoPagar(resultSet.getString("MontoPagar"));
						cintaCirculoBean.setNumeroCuotasAtraso(resultSet.getString("NoCuotasAtraso"));
						cintaCirculoBean.setTotalVencido(resultSet.getString("TotalVencido"));
						cintaCirculoBean.setCreditoMaximo(resultSet.getString("CreditoMaximo"));
						cintaCirculoBean.setFechaCierre(resultSet.getString("FechaCierre"));
						cintaCirculoBean.setNumeroLicenciaConducir(resultSet.getString("NumLicenciaConducir"));
						cintaCirculoBean.setClaveIFE(resultSet.getString("ClaveElectorIFE"));
						cintaCirculoBean.setNumeroDependientes(resultSet.getString("NumDependientes"));
						cintaCirculoBean.setTipoAsentamiento(resultSet.getString("TipoAsentamiento"));
						cintaCirculoBean.setTipoAsentamientoTrabajo(resultSet.getString("TipoAsentamientoTrabajo"));
						cintaCirculoBean.setNumeroPagosEfectuados(resultSet.getString("NumPagosReportados"));
						cintaCirculoBean.setHistoricoPagos(resultSet.getString("HisPago"));
						cintaCirculoBean.setNumeroCreditoAnterior(resultSet.getString("NumCreditoAnterior"));
						cintaCirculoBean.setClavePrevencion(resultSet.getString("ClavePrevencion"));
						
						cintaCirculoBean.setOrigenDomicilio(resultSet.getString("OrigenDomicilio"));
						cintaCirculoBean.setRazonSocialDomicilio(resultSet.getString("RazonSocialDomicilio"));
						cintaCirculoBean.setFechaCarteraVencida(resultSet.getString("FechaCarteraVencida"));
						cintaCirculoBean.setFechaPrimIncumplimiento(resultSet.getString("FechaPrimerIncumplimiento"));
						cintaCirculoBean.setFormaPagoInteres(resultSet.getString("FormaPagoInteres"));
						cintaCirculoBean.setDiasVencidos(resultSet.getString("DiasVencimiento"));
						cintaCirculoBean.setCorreoElectronico(resultSet.getString("CorreoElectronico"));
						cintaCirculoBean.setTotalInteres(resultSet.getString("TotalInteres"));
						
						
						cintaCirculoBean.setDireccionMatriz(resultSet.getString("DireccionMatriz"));
						cintaCirculoBean.setNumeroElementos(resultSet.getString("NumElementos"));
						cintaCirculoBean.setSumaSaldosTotales(resultSet.getString("SumSaldoTot"));
						cintaCirculoBean.setSumaSaldosVencidos(resultSet.getString("SumSaldoVen"));
						
						cintaCirculoBean.setValorActivoValuacion(resultSet.getString("ValorActivoValuacion"));
						cintaCirculoBean.setMontoUltimoPago(resultSet.getString("MontoUltimoPago"));
						cintaCirculoBean.setPlazoMeses(resultSet.getString("PlazoMeses"));
						cintaCirculoBean.setMontoCreditoOrig(resultSet.getString("MontoCreditoOriginacion"));
						cintaCirculoBean.setFechaDefuncion(resultSet.getString("FechaDefuncion"));
						cintaCirculoBean.setIndicadorDefuncion(resultSet.getString("IndicadorDef"));
						
						return cintaCirculoBean;
					}
				});
				
		}catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error("Error al generar la cinta de circulo para venta de cartera, "+e);
			matches = new ArrayList();
		}
		return matches;
	}

	public List<EnvioCintaCirculoBean> consultaCintaEnvioMoral(EnvioCintaCirculoBean envioCintaCirculoBean){
		
		List reporteCirculoList = null;
		try {
			String query = "CALL CINTACIRCULOCREPMREP(?,?," +
													 "?,?,?,?,?,?,?);";
			
			Object[] parametros = {
				Utileria.convierteFecha(envioCintaCirculoBean.getFechaConsulta()),
				Utileria.convierteEntero(envioCintaCirculoBean.getTipoLista()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CINTACIRCULOCREPMREP(" + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EnvioCintaCirculoBean cintaCirculoBean = new EnvioCintaCirculoBean();

					// Inicio Datos generales de la empresa que se reporta
					cintaCirculoBean.setRfc(resultSet.getString("RFC"));
					cintaCirculoBean.setCurp(resultSet.getString("CURP"));
					cintaCirculoBean.setRazonSocial(resultSet.getString("RazonSocial"));
					cintaCirculoBean.setPrimerNombre(resultSet.getString("PrimerNombre"));
					cintaCirculoBean.setSegundoNombre(resultSet.getString("SegundoNombre"));
					
					cintaCirculoBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
					cintaCirculoBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
					cintaCirculoBean.setNacionalidad(resultSet.getString("Nacionalidad"));
					cintaCirculoBean.setClasificacionCartera(resultSet.getString("ClasificacionCartera"));
					cintaCirculoBean.setClaveBanxico1(resultSet.getString("ClaveBanxico1"));
					
					cintaCirculoBean.setClaveBanxico2(resultSet.getString("ClaveBanxico2"));
					cintaCirculoBean.setClaveBanxico3(resultSet.getString("ClaveBanxico3"));
					cintaCirculoBean.setDireccion1(resultSet.getString("Direccion1"));
					cintaCirculoBean.setDireccion2(resultSet.getString("Direccion2"));
					cintaCirculoBean.setColonia(resultSet.getString("Colonia"));
					
					cintaCirculoBean.setMunicipio(resultSet.getString("Municipio"));
					cintaCirculoBean.setCiudad(resultSet.getString("Ciudad"));
					cintaCirculoBean.setEstado(resultSet.getString("Estado"));
					cintaCirculoBean.setCodigoPostal(resultSet.getString("CodigoPostal"));
					cintaCirculoBean.setTelefono(resultSet.getString("Telefono"));
					
					cintaCirculoBean.setExtension(resultSet.getString("Extension"));
					cintaCirculoBean.setFax(resultSet.getString("Fax"));
					cintaCirculoBean.setTipoCliente(resultSet.getString("TipoCliente"));
					cintaCirculoBean.setEdoExtranjero(resultSet.getString("EdoExtranjero"));
					cintaCirculoBean.setPais(resultSet.getString("Pais"));
					
					cintaCirculoBean.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
					cintaCirculoBean.setCorreoElectronico(resultSet.getString("CorreoElectronico"));
					cintaCirculoBean.setMontoSal(resultSet.getString("SalarioMensual"));
					cintaCirculoBean.setFechaIngreso(resultSet.getString("FechaIngreso"));
					// Fin Datos generales de la empresa que se reporta
					
					// Datos generales de los accionistas de la compañía reportada
					cintaCirculoBean.setRfcCompania(resultSet.getString("RFCAccionista"));
					cintaCirculoBean.setCurpCompania(resultSet.getString("CURPAccionista"));
					cintaCirculoBean.setRazonSocialCompania(resultSet.getString("RazonSocAccionista"));
					cintaCirculoBean.setPrimerNombreCompania(resultSet.getString("PrimerNomAccionista"));
					cintaCirculoBean.setSegundoNombreCompania(resultSet.getString("SegundoNomAccionista"));
					
					cintaCirculoBean.setApellidoPaternoCompania(resultSet.getString("ApePaternoAccionista"));
					cintaCirculoBean.setApellidoMaternoCompania(resultSet.getString("ApeMaternoAccionista"));
					cintaCirculoBean.setPorcentaje(resultSet.getString("Porcentaje"));
					cintaCirculoBean.setDireccionCompania1(resultSet.getString("DireccionAccionista1"));
					cintaCirculoBean.setDireccionCompania2(resultSet.getString("DireccionAccionista2"));
					
					cintaCirculoBean.setColoniaCompania(resultSet.getString("ColoniaAccionista"));
					cintaCirculoBean.setMunicipioCompania(resultSet.getString("MunicipioAccionista"));
					cintaCirculoBean.setCiudadCompania(resultSet.getString("CiudadAccionista"));
					cintaCirculoBean.setEstadoCompania(resultSet.getString("EstadoAccionista"));
					cintaCirculoBean.setCodigoPostalCompania(resultSet.getString("CPAccionista"));
					
					cintaCirculoBean.setTelefonoCompania(resultSet.getString("TelefonoAccionista"));
					cintaCirculoBean.setExtensionCompania(resultSet.getString("ExtAccionista"));
					cintaCirculoBean.setFaxCompania(resultSet.getString("FaxAccionista"));
					cintaCirculoBean.setTipoClienteCompania(resultSet.getString("TipClieAccionista"));
					cintaCirculoBean.setEdoExtranjeroCompania(resultSet.getString("EdoExtAccionista"));
					
					cintaCirculoBean.setPaisCompania(resultSet.getString("PaisAccionista"));
					// Fin Datos generales de los accionistas de la compañía reportada
					
					// Datos del Crédito
					// RFC (Datos generales de la empresa que se reporta)
					cintaCirculoBean.setCreditoID(resultSet.getString("CreditoID"));

					cintaCirculoBean.setNumeroCreditoAnterior(resultSet.getString("NumeroContratoAnt"));
					cintaCirculoBean.setFechaInicio(resultSet.getString("FechaApertura"));
					cintaCirculoBean.setPlazo(resultSet.getString("PlazoCredito"));
					cintaCirculoBean.setTipoContrato(resultSet.getString("TipoCredito"));
					cintaCirculoBean.setMontoCredito(resultSet.getString("SaldoInicial"));

					cintaCirculoBean.setMoneda(resultSet.getString("Moneda"));
					cintaCirculoBean.setNumeroPagos(resultSet.getString("NumeroPagos"));
					cintaCirculoBean.setFrecuenciaPago(resultSet.getString("FrecuenciaPago"));
					cintaCirculoBean.setMontoPagar(resultSet.getString("ImportePago"));
					cintaCirculoBean.setFechaUltimoPago(resultSet.getString("FechaUltimoPago"));

					cintaCirculoBean.setFechaReestrucutura(resultSet.getString("FechaRestructura"));
					cintaCirculoBean.setPagoEfectivo(resultSet.getString("PagoCredito"));
					cintaCirculoBean.setFechaLiquidacion(resultSet.getString("FechaLiquidacion"));
					cintaCirculoBean.setQuitas(resultSet.getString("Quita"));
					cintaCirculoBean.setCondonacion(resultSet.getString("Dacion"));

					cintaCirculoBean.setCastigo(resultSet.getString("Castigo"));
					cintaCirculoBean.setClaveObservacion(resultSet.getString("ClaveObservacion"));
					cintaCirculoBean.setEspeciales(resultSet.getString("Especiales"));
					cintaCirculoBean.setFechaPrimIncumplimiento(resultSet.getString("FechaIncumplimiento"));
					cintaCirculoBean.setSaldoInsoluto(resultSet.getString("SaldoInsoluto"));

					cintaCirculoBean.setCreditoMaximo(resultSet.getString("CreditoMaximo"));
					cintaCirculoBean.setFechaCarteraVencida(resultSet.getString("FechaCartVencida"));
					// Fin Datos del Crédito
					
					// Detalle Crédito del Crédito
					// RFC (Datos generales de la empresa que se reporta)
					// Credito (Datos del Crédito)
					cintaCirculoBean.setNumeroDiasAtraso(resultSet.getString("DiasVencidos"));
					cintaCirculoBean.setSaldoTotal(resultSet.getString("SaldoTotal"));
					cintaCirculoBean.setIntereses(resultSet.getString("Interes"));
					// Fin Detalle Crédito del Crédito
					
					// Datos generales de los Avales
					cintaCirculoBean.setRfcAval(resultSet.getString("RFCAval"));
					cintaCirculoBean.setCurpAval(resultSet.getString("CURPAval"));
					cintaCirculoBean.setRazonSocialAval(resultSet.getString("RazonSocAval"));
					cintaCirculoBean.setPrimerNombreAval(resultSet.getString("PrimerNomAval"));
					cintaCirculoBean.setSegundoNombreAval(resultSet.getString("SegundoNomAval"));
					
					cintaCirculoBean.setApellidoPaternoAval(resultSet.getString("ApePaternoAval"));
					cintaCirculoBean.setApellidoMaternoAval(resultSet.getString("ApeMaternoAval"));
					cintaCirculoBean.setDireccionAval1(resultSet.getString("DireccionAval1"));
					cintaCirculoBean.setDireccionAval2(resultSet.getString("DireccionAval2"));
					cintaCirculoBean.setColoniaAval(resultSet.getString("ColoniaAval"));
					
					cintaCirculoBean.setMunicipioAval(resultSet.getString("MunicipioAval"));
					cintaCirculoBean.setCiudadAval(resultSet.getString("CiudadAval"));
					cintaCirculoBean.setEstadoAval(resultSet.getString("EstadoAval"));
					cintaCirculoBean.setCodigoPostalAval(resultSet.getString("CPAval"));
					cintaCirculoBean.setTelefonoAval(resultSet.getString("TelefonoAval"));
					
					cintaCirculoBean.setExtensionAval(resultSet.getString("ExtAval"));
					cintaCirculoBean.setFaxAval(resultSet.getString("FaxAval"));
					cintaCirculoBean.setTipoClienteAval(resultSet.getString("TipClieAval"));
					cintaCirculoBean.setEdoExtranjeroAval(resultSet.getString("EdoExtAval"));
					cintaCirculoBean.setPaisAval(resultSet.getString("PaisAval"));
					// Fin Datos generales de los Avales
					
					return cintaCirculoBean;
				}
			});
			reporteCirculoList = matches;
		
		} catch (Exception e) {
			
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Reporte de Cinta para Círculo de crédito de Personas Morales y Personas Físicas con Actividad", e);
			
		}
		return reporteCirculoList;
	}
}

