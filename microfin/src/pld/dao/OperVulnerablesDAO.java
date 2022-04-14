package pld.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import pld.bean.OperVulnerablesBean;
import soporte.servicio.ParametrosSisServicio;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class OperVulnerablesDAO extends BaseDAO{
	ParametrosSisServicio parametrosSisServicio = null;
	
	public OperVulnerablesDAO() {
		super();
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
	
	
	public List <OperVulnerablesBean> operacionesVulnerablesRep(OperVulnerablesBean perVulnerables, final int tipoRep) {
		
		String query = "call HISPLDOPERVULNERABLESPRO(?,?,?,?,?,		?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(perVulnerables.getAnio() ),
				Utileria.convierteEntero(perVulnerables.getMes()),
				perVulnerables.getFechaActual(),
				Utileria.convierteEntero(perVulnerables.getClienteInstitucion()),
				tipoRep,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasContablesDAO.consultaEstadosCuentaRep",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call HISPLDOPERVULNERABLESPRO(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OperVulnerablesBean perVulnerablesBean = new OperVulnerablesBean();
			
				perVulnerablesBean.setAnio(resultSet.getString("Anio"));
				perVulnerablesBean.setMes(resultSet.getString("Mes"));
				perVulnerablesBean.setFechaReporto(resultSet.getString("FechaReporto"));
				perVulnerablesBean.setClaveEntidadColegiada(resultSet.getString("ClaveEntidadColegiada"));
				perVulnerablesBean.setClaveSujetoObligado(resultSet.getString("ClaveSujetoObligado"));
				perVulnerablesBean.setClaveActividad(resultSet.getString("ClaveActividad"));
				perVulnerablesBean.setExento(resultSet.getString("Exento"));
				perVulnerablesBean.setDominioPlataforma(resultSet.getString("DominioPlataforma"));
				perVulnerablesBean.setReferenciaAviso(resultSet.getString("ReferenciaAviso"));
				perVulnerablesBean.setPrioridad(resultSet.getString("Prioridad"));
				perVulnerablesBean.setFolioModificacion(resultSet.getString("FolioModificacion"));
				perVulnerablesBean.setDescripcionModificacion(resultSet.getString("DescripcionModificacion"));
				perVulnerablesBean.setTipoAlerta(resultSet.getString("TipoAlerta"));
				perVulnerablesBean.setDescripcionAlerta(resultSet.getString("DescripcionAlerta"));
				perVulnerablesBean.setClienteID(resultSet.getString("ClienteID"));
				perVulnerablesBean.setCuentaRelacionada(resultSet.getString("CuentaRelacionada"));
				perVulnerablesBean.setClabeInterbancaria(resultSet.getString("ClabeInterbancaria"));
				perVulnerablesBean.setMonedaCuenta(resultSet.getString("MonedaCuenta"));
				perVulnerablesBean.setNombrePF(resultSet.getString("NombrePF"));
				perVulnerablesBean.setApellidoPaternoPF(resultSet.getString("ApellidoPaternoPF"));
				perVulnerablesBean.setApellidoMaternoPF(resultSet.getString("ApellidoMaternoPF"));
				perVulnerablesBean.setFechaNacimientoPF(resultSet.getString("FechaNacimientoPF"));
				perVulnerablesBean.setrFCPF(resultSet.getString("RFCPF"));
				perVulnerablesBean.setcURPPF(resultSet.getString("CURPPF"));
				perVulnerablesBean.setPaisNacionalidadPF(resultSet.getString("PaisNacionalidadPF"));
				perVulnerablesBean.setActividadEconomicaPF(resultSet.getString("ActividadEconomicaPF"));
				perVulnerablesBean.setTipoIdentificacionPF(resultSet.getString("TipoIdentificacionPF"));
				perVulnerablesBean.setNumeroIdentificacionPF(resultSet.getString("NumeroIdentificacionPF"));
				perVulnerablesBean.setDenominacionRazonPM(resultSet.getString("DenominacionRazonPM"));
				perVulnerablesBean.setFechaConstitucionPM(resultSet.getString("FechaConstitucionPM"));
				perVulnerablesBean.setrFCPM(resultSet.getString("RFCPM"));
				perVulnerablesBean.setPaisNacionalidadPM(resultSet.getString("PaisNacionalidadPM"));
				perVulnerablesBean.setGiroMercantilPM(resultSet.getString("GiroMercantilPM"));
				perVulnerablesBean.setNombreRL(resultSet.getString("NombreRL"));
				perVulnerablesBean.setApellidoPaternoRL(resultSet.getString("ApellidoPaternoRL"));
				perVulnerablesBean.setApellidoMaternoRL(resultSet.getString("ApellidoMaternoRL"));
				perVulnerablesBean.setFechaNacimientoRL(resultSet.getString("FechaNacimientoRL"));
				perVulnerablesBean.setrFCRL(resultSet.getString("RFCRL"));
				perVulnerablesBean.setcURPRL(resultSet.getString("CURPRL"));
				perVulnerablesBean.setTipoIdentificacionRL(resultSet.getString("TipoIdentificacionRL"));
				perVulnerablesBean.setNumeroIdentificacionRL(resultSet.getString("NumeroIdentificacionRL"));
				perVulnerablesBean.setDenominacionRazonFedi(resultSet.getString("DenominacionRazonFedi"));
				perVulnerablesBean.setrFCFedi(resultSet.getString("RFCFedi"));
				perVulnerablesBean.setFideicomisoIDFedi(resultSet.getString("FideicomisoIDFedi"));
				perVulnerablesBean.setNombreApo(resultSet.getString("NombreApo"));
				perVulnerablesBean.setApellidoPaternoApo(resultSet.getString("ApellidoPaternoApo"));
				perVulnerablesBean.setApellidoMaternoApo(resultSet.getString("ApellidoMaternoApo"));
				perVulnerablesBean.setFechaNacimientoApo(resultSet.getString("FechaNacimientoApo"));
				perVulnerablesBean.setrFCApo(resultSet.getString("RFCApo"));
				perVulnerablesBean.setcURPApo(resultSet.getString("CURPApo"));
				perVulnerablesBean.setTipoIdentificacionApo(resultSet.getString("TipoIdentificacionApo"));
				perVulnerablesBean.setNumeroIdentificacionApo(resultSet.getString("NumeroIdentificacionApo"));
				perVulnerablesBean.setColoniaN(resultSet.getString("ColoniaN"));
				perVulnerablesBean.setCalleN(resultSet.getString("CalleN"));
				perVulnerablesBean.setNumeroExteriorN(resultSet.getString("NumeroExteriorN"));
				perVulnerablesBean.setNumeroInteriorN(resultSet.getString("NumeroInteriorN"));
				perVulnerablesBean.setCodigoPostalN(resultSet.getString("CodigoPostalN"));
				perVulnerablesBean.setPaisE(resultSet.getString("PaisE"));
				perVulnerablesBean.setEstadoProvinciaE(resultSet.getString("EstadoProvinciaE"));
				perVulnerablesBean.setCiudadPoblacionE(resultSet.getString("CiudadPoblacionE"));
				perVulnerablesBean.setColoniaE(resultSet.getString("ColoniaE"));
				perVulnerablesBean.setCalleE(resultSet.getString("CalleE"));
				perVulnerablesBean.setNumeroExteriorE(resultSet.getString("NumeroExteriorE"));
				perVulnerablesBean.setNumeroInteriorE(resultSet.getString("NumeroInteriorE"));
				perVulnerablesBean.setCodigoPostalE(resultSet.getString("CodigoPostalE"));
				perVulnerablesBean.setClavePaisPer(resultSet.getString("ClavePaisPer"));
				perVulnerablesBean.setNumeroTelefonoPer(resultSet.getString("NumeroTelefonoPer"));
				perVulnerablesBean.setCorreoElectronicoPer(resultSet.getString("CorreoElectronicoPer"));
				perVulnerablesBean.setNombreDuePF(resultSet.getString("NombreDuePF"));
				perVulnerablesBean.setApellidoPaternoDuePF(resultSet.getString("ApellidoPaternoDuePF"));
				perVulnerablesBean.setApellidoMaternoDuePF(resultSet.getString("ApellidoMaternoDuePF"));
				perVulnerablesBean.setFechaNacimientoDuePF(resultSet.getString("FechaNacimientoDuePF"));
				perVulnerablesBean.setrFCDuePF(resultSet.getString("RFCDuePF"));
				perVulnerablesBean.setcURPDuePF(resultSet.getString("CURPDuePF"));
				perVulnerablesBean.setPaisNacionalidadDuePF(resultSet.getString("PaisNacionalidadDuePF"));
				perVulnerablesBean.setDenominacionRazonDuePM(resultSet.getString("DenominacionRazonDuePM"));
				perVulnerablesBean.setFechaConstitucionDuePM(resultSet.getString("FechaConstitucionDuePM"));
				perVulnerablesBean.setrFCDuePM(resultSet.getString("RFCDuePM"));
				perVulnerablesBean.setPaisNacionalidadDuePM(resultSet.getString("PaisNacionalidadDuePM"));
				perVulnerablesBean.setDenominacionRazonDueFid(resultSet.getString("DenominacionRazonDueFid"));
				perVulnerablesBean.setrFCDueFid(resultSet.getString("RFCDueFid"));
				perVulnerablesBean.setFideicomisoIDDueFid(resultSet.getString("FideicomisoIDDueFid"));
				perVulnerablesBean.setFechaHoraOperacionCom(resultSet.getString("FechaHoraOperacionCom"));
				perVulnerablesBean.setMonedaOperacionCom(resultSet.getString("MonedaOperacionCom"));
				perVulnerablesBean.setMontoOperacionCom(resultSet.getString("MontoOperacionCom"));
				perVulnerablesBean.setActivoVirtualOperadoAV(resultSet.getString("ActivoVirtualOperadoAV"));
				perVulnerablesBean.setDescripcionActivoVirtualAV(resultSet.getString("DescripcionActivoVirtualAV"));
				perVulnerablesBean.setTipoCambioMnAV(resultSet.getString("TipoCambioMnAV"));
				perVulnerablesBean.setCantidadActivoVirtualAV(resultSet.getString("CantidadActivoVirtualAV"));
				perVulnerablesBean.setHashOperacionAV(resultSet.getString("HashOperacionAV"));
				perVulnerablesBean.setFechaHoraOperacionV(resultSet.getString("FechaHoraOperacionV"));
				perVulnerablesBean.setMonedaOperacionV(resultSet.getString("MonedaOperacionV"));
				perVulnerablesBean.setMontoOperacionV(resultSet.getString("MontoOperacionV"));
				perVulnerablesBean.setActivoVirtualOperadoVAV(resultSet.getString("ActivoVirtualOperadoVAV"));
				perVulnerablesBean.setDescripcionActivoVirtualVAV(resultSet.getString("DescripcionActivoVirtualVAV"));
				perVulnerablesBean.setTipoCambioMnVAV(resultSet.getString("TipoCambioMnVAV"));
				perVulnerablesBean.setCantidadActivoVirtualVAV(resultSet.getString("CantidadActivoVirtualVAV"));
				perVulnerablesBean.setHashOperacionVAV(resultSet.getString("HashOperacionVAV"));
				perVulnerablesBean.setFechaHoraOperacionOI(resultSet.getString("FechaHoraOperacionOI"));
				perVulnerablesBean.setActivoVirtualOperadoOIAV(resultSet.getString("ActivoVirtualOperadoOIAV"));
				perVulnerablesBean.setDescripcionActivoVirtualOIAV(resultSet.getString("DescripcionActivoVirtualOIAV"));
				perVulnerablesBean.setTipoCambioMnOIAV(resultSet.getString("TipoCambioMnOIAV"));
				perVulnerablesBean.setCantidadActivoVirtualOIAV(resultSet.getString("CantidadActivoVirtualOIAV"));
				perVulnerablesBean.setMontoOperacionMnOIAV(resultSet.getString("MontoOperacionMnOIAV"));
				perVulnerablesBean.setActivoVirtualOperadoOIAR(resultSet.getString("ActivoVirtualOperadoOIAR"));
				perVulnerablesBean.setDescripcionActivoVirtualOIAR(resultSet.getString("DescripcionActivoVirtualOIAR"));
				perVulnerablesBean.setTipoCambioMnOIAR(resultSet.getString("TipoCambioMnOIAR"));
				perVulnerablesBean.setCantidadActivoVirtualOIAR(resultSet.getString("CantidadActivoVirtualOIAR"));
				perVulnerablesBean.setMontoOperacionMnOIAR(resultSet.getString("MontoOperacionMnOIAR"));
				perVulnerablesBean.setHashOperacionOIAR(resultSet.getString("HashOperacionOIAR"));
				perVulnerablesBean.setFechaHoraOperacionOTE(resultSet.getString("FechaHoraOperacionOTE"));
				perVulnerablesBean.setMontoOperacionMnOTE(resultSet.getString("MontoOperacionMnOTE"));
				perVulnerablesBean.setActivoVirtualOperadoOTAV(resultSet.getString("ActivoVirtualOperadoOTAV"));
				perVulnerablesBean.setDescripcionActivoVirtualOTAV(resultSet.getString("DescripcionActivoVirtualOTAV"));
				perVulnerablesBean.setTipoCambioMnOTAV(resultSet.getString("TipoCambioMnOTAV"));
				perVulnerablesBean.setCantidadActivoVirtualOTAV(resultSet.getString("CantidadActivoVirtualOTAV"));
				perVulnerablesBean.setHashOperacionOTAV(resultSet.getString("HashOperacionOTAV"));
				perVulnerablesBean.setFechaHoraOperacionTR(resultSet.getString("FechaHoraOperacionTR"));
				perVulnerablesBean.setMontoOperacionMnTR(resultSet.getString("MontoOperacionMnTR"));
				perVulnerablesBean.setActivoVirtualOperadoTRA(resultSet.getString("ActivoVirtualOperadoTRA"));
				perVulnerablesBean.setDescripcionActivoVirtualTRA(resultSet.getString("DescripcionActivoVirtualTRA"));
				perVulnerablesBean.setTipoCambioMnTRA(resultSet.getString("TipoCambioMnTRA"));
				perVulnerablesBean.setCantidadActivoVirtualTRA(resultSet.getString("CantidadActivoVirtualTRA"));
				perVulnerablesBean.setHashOperacionTRA(resultSet.getString("HashOperacionTRA"));
				perVulnerablesBean.setFechaHoraOperacionFR(resultSet.getString("FechaHoraOperacionFR"));
				perVulnerablesBean.setInstrumentoMonetarioFR(resultSet.getString("InstrumentoMonetarioFR"));
				perVulnerablesBean.setMonedaOperacionFR(resultSet.getString("MonedaOperacionFR"));
				perVulnerablesBean.setMontoOperacionFR(resultSet.getString("MontoOperacionFR"));
				perVulnerablesBean.setNombreFRPF(resultSet.getString("NombreFRPF"));
				perVulnerablesBean.setApellidoPaternoFRPF(resultSet.getString("ApellidoPaternoFRPF"));
				perVulnerablesBean.setApellidoMaternoFRPF(resultSet.getString("ApellidoMaternoFRPF"));
				perVulnerablesBean.setDenominacionRazonFRPF(resultSet.getString("DenominacionRazonFRPF"));
				perVulnerablesBean.setClabeDestinoFRN(resultSet.getString("ClabeDestinoFRN"));
				perVulnerablesBean.setClaveInstitucionFinancieraFRN(resultSet.getString("ClaveInstitucionFinancieraFRN"));
				perVulnerablesBean.setNumeroCuentaFRE(resultSet.getString("NumeroCuentaFRE"));
				perVulnerablesBean.setNombreBancoFRE(resultSet.getString("NombreBancoFRE"));
				perVulnerablesBean.setFechaHoraOperacionFD(resultSet.getString("FechaHoraOperacionFD"));
				perVulnerablesBean.setInstrumentoMonetarioFD(resultSet.getString("InstrumentoMonetarioFD"));
				perVulnerablesBean.setMonedaOperacionFD(resultSet.getString("MonedaOperacionFD"));
				perVulnerablesBean.setMontoOperacionFD(resultSet.getString("MontoOperacionFD"));
				perVulnerablesBean.setNombreFDPF(resultSet.getString("NombreFDPF"));
				perVulnerablesBean.setApellidoPaternoFDPF(resultSet.getString("ApellidoPaternoFDPF"));
				perVulnerablesBean.setApellidoMaternoFDPF(resultSet.getString("ApellidoMaternoFDPF"));
				perVulnerablesBean.setDenominacionRazonFDPM(resultSet.getString("DenominacionRazonFDPM"));
				perVulnerablesBean.setClabeDestinoFDN(resultSet.getString("ClabeDestinoFDN"));
				perVulnerablesBean.setClaveInstitucionFinancieraFDN(resultSet.getString("ClaveInstitucionFinancieraFDN"));
				perVulnerablesBean.setNumeroCuentaFDE(resultSet.getString("NumeroCuentaFDE"));
				perVulnerablesBean.setNombreBancoFDE(resultSet.getString("NombreBancoFDE"));
				
				
				return perVulnerablesBean;

			}
		});
		return matches;
	}
	
	
	public OperVulnerablesBean consultaPrincipal(OperVulnerablesBean operVulnerables, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CATPLDOPERVULNERABLESCON(?,?, ?,?,?,?,?,?,?);";
							
		Object[] parametros = {	Utileria.convierteEntero(operVulnerables.getClienteInstitucion()),	
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"InstitucionesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CATPLDOPERVULNERABLESCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OperVulnerablesBean perVulnerablesBean = new OperVulnerablesBean();
				
				perVulnerablesBean.setClaveEntidadColegiada(resultSet.getString("ClaveEntidadColegiada"));
				perVulnerablesBean.setClaveSujetoObligado(resultSet.getString("ClaveSujetoObligado"));
				perVulnerablesBean.setClaveActividad(resultSet.getString("ClaveActividad"));
				perVulnerablesBean.setExento(resultSet.getString("Exento"));
				perVulnerablesBean.setDominioPlataforma(resultSet.getString("DominioPlataforma"));
				perVulnerablesBean.setReferenciaAviso(resultSet.getString("ReferenciaAviso"));
				perVulnerablesBean.setPrioridad(resultSet.getString("Prioridad"));
				perVulnerablesBean.setFolioModificacion(resultSet.getString("FolioModificacion"));
				perVulnerablesBean.setDescripcionModificacion(resultSet.getString("DescripcionModificacion"));
				perVulnerablesBean.setTipoAlerta(resultSet.getString("TipoAlerta"));
				perVulnerablesBean.setDescripcionAlerta(resultSet.getString("DescripcionAlerta"));
				perVulnerablesBean.setRutaArchivo(resultSet.getString("RutaArchivo"));
				
				return perVulnerablesBean;
	
			}
		});
				
		return matches.size() > 0 ? (OperVulnerablesBean) matches.get(0) : null;
	}
	
}
