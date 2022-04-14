package regulatorios.dao;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import regulatorios.bean.DesagreCaptaD0841Bean;
import regulatorios.bean.ReporteRegulatorioBean;


public class RegulatorioD0841DAO extends BaseDAO {
	
	
	/**
	 * Consulta para el reporte Desagregado de Captacion D0841 formato CSV
	 * @param reporteBean
	 * @param tipoLista
	 * @return
	 */
	public List <DesagreCaptaD0841Bean> consultaRegulatorioD0841CSV(final DesagreCaptaD0841Bean reporteBean,int tipoLista){
		List<DesagreCaptaD0841Bean> listaReporte = null;
		try{
			String query = "call REGULATORIOD0841REP(?,?,?,	?,?,?,?,?,?,?);";
			int numero_decimales=2;
			Object[] parametros ={
					Utileria.convierteFecha(reporteBean.getFecha()),
					tipoLista,
					numero_decimales,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RegulatorioD841DAO.consultaRegulatorioD0841CSV",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD0841REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DesagreCaptaD0841Bean reporteRegBean = new DesagreCaptaD0841Bean();
					reporteRegBean.setValor(resultSet.getString(1));
					return reporteRegBean ;
				}
			});
		
			listaReporte= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte de D0481: \n", e);
		}
		return listaReporte ;
	}

	
	
	/**
	 * SOCAPS
	 * Consulta para el reporte Desagregado de Captacion D0841 formato Excel
	 * @param reporteBean
	 * @param tipoLista
	 * @return
	 */
	public List <DesagreCaptaD0841Bean> consultaRegulatorioD0841Socap(final DesagreCaptaD0841Bean reporteBean,int tipoLista){
		List<DesagreCaptaD0841Bean> listaReporte = null;
		try{
			String query = "call REGULATORIOD0841REP(?,?,?,	?,?,?,?,?,?,?);";
			int numero_decimales=2;
			Object[] parametros ={
					Utileria.convierteFecha(reporteBean.getFecha()),
					tipoLista,
					numero_decimales,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RegulatorioD841DAO.consultaRegulatorioD0841Socap",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD0841REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DesagreCaptaD0841Bean reporteRegBean = new DesagreCaptaD0841Bean();
					reporteRegBean.setVar_Periodo(resultSet.getString("Var_Periodo"));
					reporteRegBean.setVar_ClaveEntidad(resultSet.getString("Var_ClaveEntidad")); 
					reporteRegBean.setFormulario(resultSet.getString("Formulario")); 
					reporteRegBean.setNumIdentificacion(resultSet.getString("NumIdentificacion")); 
					reporteRegBean.setTipoPersona(resultSet.getString("TipoPersona")); 
					reporteRegBean.setNombre(resultSet.getString("Nombre")); 
					reporteRegBean.setApellidoPat(resultSet.getString("ApellidoPat")); 
					reporteRegBean.setApellidoMat(resultSet.getString("ApellidoMat")); 
					reporteRegBean.setRFC(resultSet.getString("RFC")); 
					reporteRegBean.setCURP(resultSet.getString("CURP")); 
					reporteRegBean.setGenero(String.valueOf(resultSet.getInt("Genero"))); 
					reporteRegBean.setFechaNac(resultSet.getString("FechaNac")); 
					reporteRegBean.setCodigoPostal(resultSet.getString("CodigoPostal")); 
					reporteRegBean.setLocalidad(resultSet.getString("Localidad")); 
					reporteRegBean.setEstadoClave(resultSet.getString("EstadoClave")); 
					reporteRegBean.setCodigoPais(resultSet.getString("CodigoPais")); 
					reporteRegBean.setNumAportacion(String.valueOf(resultSet.getInt("NumAportacion"))); 
					reporteRegBean.setMtoAportacion(resultSet.getString("MtoAportacion")); 
					reporteRegBean.setNumAportaVol(String.valueOf(resultSet.getInt("NumAportaVol"))); 
					reporteRegBean.setMtoAportaVol(resultSet.getString("MtoAportaVol")); 
					reporteRegBean.setNumContrato(resultSet.getString("NumContrato")); 
					reporteRegBean.setNumeroCuenta(resultSet.getString("NumeroCuenta")); 
					reporteRegBean.setSucursal(resultSet.getString("Sucursal")); 
					reporteRegBean.setFechaApertura(resultSet.getString("FechaApertura")); 
					reporteRegBean.setTipoProducto(String.valueOf(resultSet.getInt("TipoProducto")));
					reporteRegBean.setTipoModalidad(resultSet.getString("TipoModalidad")); 
					reporteRegBean.setTasaInteres(resultSet.getString("TasaInteres")); 
					reporteRegBean.setMoneda(resultSet.getString("Moneda")); 
					reporteRegBean.setPlazo(String.valueOf(resultSet.getInt("Plazo"))); 
					reporteRegBean.setFechaVencim(resultSet.getString("FechaVencim")); 
					reporteRegBean.setSaldoIniPer(resultSet.getString("SaldoIniPer")); 
					reporteRegBean.setMtoDepositos(resultSet.getString("MtoDepositos")); 
					reporteRegBean.setMtoRetiros(resultSet.getString("MtoRetiros")); 
					reporteRegBean.setIntDevNoPago(resultSet.getString("IntDevNoPago")); 
					reporteRegBean.setSaldoFinal(resultSet.getString("SaldoFinal"));
					reporteRegBean.setFecUltMov(resultSet.getString("FecUltMov"));
					reporteRegBean.setTipoApertura(resultSet.getString("TipoApertura"));
					
					return reporteRegBean ;
				}
			});
		
			listaReporte= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte de D0481: \n", e);
		}
		return listaReporte ;
	}
	
	
	/**
	 * SOFIPO
	 * Consulta para el reporte Desagregado de Captacion D0841 formato Excel
	 * @param reporteBean
	 * @param tipoLista
	 * @return
	 */	
	public List <DesagreCaptaD0841Bean> consultaRegulatorioD0841Sofipo(final DesagreCaptaD0841Bean reporteBean,int tipoLista){
		List<DesagreCaptaD0841Bean> listaReporte = null;
		try{
			String query = "call REGULATORIOD0841REP(?,?,?,	?,?,?,?,?,?,?);";
			int numero_decimales=2;
			Object[] parametros ={
					Utileria.convierteFecha(reporteBean.getFecha()),
					tipoLista,
					numero_decimales,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RegulatorioD841DAO.consultaRegulatorioD0841Sofipo",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
				};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOD0841REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DesagreCaptaD0841Bean reporteRegBean = new DesagreCaptaD0841Bean();
					reporteRegBean.setVar_Periodo(resultSet.getString("Var_Periodo"));
					reporteRegBean.setVar_ClaveEntidad(resultSet.getString("Var_ClaveEntidad")); 
					reporteRegBean.setFormulario(resultSet.getString("Formulario")); 
					
					reporteRegBean.setClienteID(resultSet.getString("ClienteID"));			
			        reporteRegBean.setNombre(resultSet.getString("Nombre"));			

			        reporteRegBean.setApellidoPat(resultSet.getString("ApellidoPat"));			
			        reporteRegBean.setApellidoMat(resultSet.getString("ApellidoMat"));			
			        reporteRegBean.setPersJuridica(resultSet.getString("PersJuridica"));
			        reporteRegBean.setGradoRiesgo(resultSet.getString("GradoRiesgo"));		
			        reporteRegBean.setActividadEco(resultSet.getString("ActividadEco"));	

			        reporteRegBean.setNacionalidad(resultSet.getString("Nacionalidad"));			
			        reporteRegBean.setFechaNac(resultSet.getString("FechaNac"));				
			        reporteRegBean.setRFC(resultSet.getString("RFC"));					
			        reporteRegBean.setCURP(resultSet.getString("CURP"));				
			        reporteRegBean.setGenero(resultSet.getString("Genero"));			

			        reporteRegBean.setCalle(resultSet.getString("Calle"));					
			        reporteRegBean.setNumeroExt(resultSet.getString("NumeroExt"));				
			        reporteRegBean.setColoniaDes(resultSet.getString("ColoniaDes"));
			        reporteRegBean.setCodigoPostal(resultSet.getString("CodigoPostal"));		
			        reporteRegBean.setLocalidad(resultSet.getString("Localidad"));		

			        reporteRegBean.setEstadoID(resultSet.getString("EstadoID"));				
			        reporteRegBean.setMunicipioID(resultSet.getString("MunicipioID"));			
			        reporteRegBean.setCodigoPais(resultSet.getString("CodigoPais"));			
			        reporteRegBean.setClaveSucursal(resultSet.getString("ClaveSucursal"));		
			        reporteRegBean.setNumeroCuenta(resultSet.getString("NumeroCuenta"));	

			        reporteRegBean.setNumContrato(resultSet.getString("NumContrato"));			
			        reporteRegBean.setTipoCliente(resultSet.getString("TipoCliente"));			
			        reporteRegBean.setClasfContable(resultSet.getString("ClasfContable"));				
			        reporteRegBean.setClasfBursatil(resultSet.getString("ClasfBursatil"));		
			        reporteRegBean.setTipoInstrumento(resultSet.getString("TipoInstrumento"));

			        reporteRegBean.setFechaApertura(resultSet.getString("FechaApertura"));			
			        reporteRegBean.setFechaDepoIni(resultSet.getString("FechaDepoIni"));			
			        reporteRegBean.setMontoDepoIniOri(resultSet.getString("MontoDepoIniOri"));	
			        reporteRegBean.setMontoDepoIniPes(resultSet.getString("MontoDepoIniPes"));	
			        reporteRegBean.setFechaDepoVenc(resultSet.getString("FechaDepoVenc"));	

			        reporteRegBean.setPlazoAlVencimi(resultSet.getString("PlazoAlVencimi"));			
			        reporteRegBean.setRangoPlazo(resultSet.getString("RangoPlazo"));				
			        reporteRegBean.setPeriodicidad(resultSet.getString("Periodicidad"));	
			        reporteRegBean.setTipoTasa(resultSet.getString("TipoTasa"));			
			        reporteRegBean.setTasaInteres(resultSet.getString("TasaInteres"));	

			        reporteRegBean.setTasaPeriodo(resultSet.getString("TasaPeriodo"));			
			        reporteRegBean.setTasaReferencia(resultSet.getString("TasaReferencia"));			
			        reporteRegBean.setDiferencialTasa(resultSet.getString("DiferencialTasa"));				
			        reporteRegBean.setOpeDiferencial(resultSet.getString("OpeDiferencial"));		
			        reporteRegBean.setFrecRevTasa(resultSet.getString("FrecRevTasa"));			

			        reporteRegBean.setMoneda(resultSet.getString("Moneda"));					
			        reporteRegBean.setSaldoIniPer(resultSet.getString("SaldoIniPer"));			
			        reporteRegBean.setMtoDepositos(resultSet.getString("MtoDepositos"));				
			        reporteRegBean.setMtoRetiros(resultSet.getString("MtoRetiros"));			
			        reporteRegBean.setIntDevNoPago(resultSet.getString("IntDevNoPago"));	

			        reporteRegBean.setSaldoFinal(resultSet.getString("SaldoFinal"));				
			        reporteRegBean.setInteresMes(resultSet.getString("InteresMes"));				
			        reporteRegBean.setComisionMes(resultSet.getString("ComisionMes"));
			        reporteRegBean.setFecUltMov(resultSet.getString("FecUltMov"));			
			        reporteRegBean.setMontoUltMov(resultSet.getString("MontoUltMov"));	

			        reporteRegBean.setSaldoProm(resultSet.getString("SaldoProm"));				
			        reporteRegBean.setRetiroAnt(resultSet.getString("RetiroAnt"));				
			        reporteRegBean.setMontoFondPro(resultSet.getString("MontoFondPro"));
			        reporteRegBean.setPorcFondoPro(resultSet.getString("PorcFondoPro"));		
			        reporteRegBean.setPorcGarantia(resultSet.getString("PorcGarantia"));
					
					return reporteRegBean ;
				}
			});
		
			listaReporte= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en reporte de D0481: \n", e);
		}
		return listaReporte ;
	}
	
	
}
