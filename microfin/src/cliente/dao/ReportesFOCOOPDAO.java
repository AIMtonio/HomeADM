package cliente.dao;

 
import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.ReportesFOCOOPBean;


public class ReportesFOCOOPDAO extends BaseDAO{
			
	/*------------Alta de Operaciones-------------*/		
	public List consultaCaptacion(ReportesFOCOOPBean reportesFOCOOPBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call REPFOCOOP(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = { 	
									tipoReporte,
									reportesFOCOOPBean.getFechaReporte(),									
									reportesFOCOOPBean.getEmpresaID(),				
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,								
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REPFOCOOP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesFOCOOPBean repFOCOOPBean = new ReportesFOCOOPBean();
					
					repFOCOOPBean.setNumSocio(String.valueOf(resultSet.getInt("Num_Socio")));
					repFOCOOPBean.setNombreSocio(resultSet.getString("Nombre_Socio"));					
					repFOCOOPBean.setNumCuenta(String.valueOf(resultSet.getString("Num_Cuenta")));
					repFOCOOPBean.setSucursal(resultSet.getString("Sucursal"));
					repFOCOOPBean.setFechaApertura(resultSet.getString("FechaApertura"));
					repFOCOOPBean.setTipoCuenta(resultSet.getString("Tipo_Cuenta"));
					repFOCOOPBean.setFechaUltDeposito(resultSet.getString("Fecha_Ult_Deposito"));
					repFOCOOPBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					repFOCOOPBean.setPlazoDeposito(resultSet.getString("PlazoDeposito"));
					repFOCOOPBean.setFormaPagRendimientos(resultSet.getString("FormaPagRendimientos"));
					repFOCOOPBean.setDiasCalculoInt(resultSet.getString("DiasCalculoInt"));
					repFOCOOPBean.setTasaNominal(resultSet.getString("TasaNominal"));
					repFOCOOPBean.setSaldoPromedio(resultSet.getString("SaldoPromedio"));
					repFOCOOPBean.setCapital(resultSet.getString("Capital"));
					repFOCOOPBean.setIntDevenNoPagados(resultSet.getString("IntDevenNoPagados"));
					repFOCOOPBean.setSaldoTotalCieMes(resultSet.getString("SaldoTotalCieMes"));
					repFOCOOPBean.setInteresesGeneradoMes(resultSet.getString("InteresGeneradoMes"));		
					repFOCOOPBean.setHora(resultSet.getString("HoraEmision"));
					return repFOCOOPBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPFOCOOP", e);
		}
		return matches;
	}
	public List consultaCartera(ReportesFOCOOPBean reportesFOCOOPBean,int tipoReporte ){
		List matches = null;
		try{
			String query = "call REPFOCOOP(?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = { 
									tipoReporte,
									reportesFOCOOPBean.getFechaReporte(),
									reportesFOCOOPBean.getEmpresaID(),		
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,								
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REPFOCOOP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesFOCOOPBean repFOCOOPBean = new ReportesFOCOOPBean();
					
					repFOCOOPBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
					repFOCOOPBean.setNumSocio(String.valueOf(resultSet.getInt("Numero_Socio")));					
					repFOCOOPBean.setContrato(resultSet.getString("Contrato"));
					repFOCOOPBean.setSucursal(resultSet.getString("Sucursal"));
					repFOCOOPBean.setClasificacion(resultSet.getString("Clasificacion"));
					repFOCOOPBean.setProducto(resultSet.getString("Producto"));
					repFOCOOPBean.setModalidaPago(resultSet.getString("MODALIDAD_PAGO"));
					repFOCOOPBean.setFechaOtorgamiento(resultSet.getString("Fecha_Otorgamiento"));
					repFOCOOPBean.setMontoOriginal(resultSet.getString("Monto_Original"));
					repFOCOOPBean.setFechaVencimien(resultSet.getString("Fecha_Vencimien"));
					
					repFOCOOPBean.setTasaOrdinaria(resultSet.getString("Tasa_Ordinaria"));
					repFOCOOPBean.setTasaMoratoria(resultSet.getString("Tasa_Moratoria"));
					repFOCOOPBean.setPlazoCredito(resultSet.getString("PlazoCredito"));
					repFOCOOPBean.setFrecuenciaPagoCapital(resultSet.getString("FrecuenciaPagoCapital"));
					repFOCOOPBean.setFrecuenciaPagoIn(resultSet.getString("FrecuenciaPagoInt"));
					repFOCOOPBean.setDiasMora(resultSet.getString("Dias_Mora"));
					repFOCOOPBean.setSaldoCapitalVigente(resultSet.getString("Saldo_Capital_Vigente"));
					repFOCOOPBean.setSaldoCapitalVencido(resultSet.getString("SaldoCapitalVencido"));
					repFOCOOPBean.setInteresDevNoCobVig(resultSet.getString("Interes_Dev_NoCob_Vig"));
					repFOCOOPBean.setInteresDevNoCobVen(resultSet.getString("Interes_Dev_NoCob_Ven"));
					
					repFOCOOPBean.setInteresDevenNoCobCuentasOrden(resultSet.getString("INTERES_DEVEN_NOCOB_CuentasOrden"));
					repFOCOOPBean.setInteresMoratorio(resultSet.getString("InteresMoratorio"));//se agrega
					repFOCOOPBean.setFechaUltPagCap(resultSet.getString("FechaUltPagoCap"));
					repFOCOOPBean.setMontoUltPagCap(resultSet.getString("MontoUltPagCap"));
					repFOCOOPBean.setFechaUltPagoInteres(resultSet.getString("FechaUltPagoInteres"));
					repFOCOOPBean.setMontoUltPagInteres(resultSet.getString("MontoUltPagInteres"));
					repFOCOOPBean.setRenReesNor(resultSet.getString("RenReesNor"));
					repFOCOOPBean.setEmproblemado(resultSet.getString("Emproblemado"));
					repFOCOOPBean.setVigenteVencido(resultSet.getString("Vigente_Vencido"));
					repFOCOOPBean.setCargoDelAcreditado(resultSet.getString("CargoDelAcreditado"));
					repFOCOOPBean.setMontoGarantiaLiquida(resultSet.getString("MontoGarantiaLiquida"));
					repFOCOOPBean.setGarantiaLiquida(resultSet.getString("GarantiaLiquida"));
					repFOCOOPBean.setMontoGarantiaPrendaria(resultSet.getString("MontoGarantiaPrendaria"));
					repFOCOOPBean.setMontoGarantiaHipoteca(resultSet.getString("MontoGarantiaHipoteca"));
					repFOCOOPBean.setEprCubierta(resultSet.getString("EPR_Cubierta"));
					repFOCOOPBean.setEprExpuesta(resultSet.getString("EPR_EXPUESTA"));
					repFOCOOPBean.setEprInteresesCaVe(resultSet.getString("EPR_InteresesCaVe"));
					repFOCOOPBean.setHora(resultSet.getString("HoraEmision"));
					repFOCOOPBean.setFormula(resultSet.getString("Formula"));
					
					repFOCOOPBean.setNumeroRenov(resultSet.getString("NumeroRenov"));
					repFOCOOPBean.setNumeroReest(resultSet.getString("NumeroReest"));
					
					return repFOCOOPBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPFOCOOP", e);
		}
		return matches;
	}	
	
	public List aportacionSocio(ReportesFOCOOPBean reportesFOCOOPBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call REPFOCOOP(?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = { 									
									tipoReporte,
									reportesFOCOOPBean.getFechaReporte(),
									reportesFOCOOPBean.getEmpresaID(),		
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									Constantes.STRING_VACIO,								
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REPFOCOOP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesFOCOOPBean bean=new ReportesFOCOOPBean();
					
					bean.setNumSocio(String.valueOf(resultSet.getInt("ClienteID")));
					bean.setNombreSocio(resultSet.getString("Nombre"));					
					bean.setApellidoPaterno(String.valueOf(resultSet.getString("ApellidoPaterno")));
					bean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
					bean.setCURP(resultSet.getString("CURP"));
					bean.setTipoAportacion(resultSet.getString("TipoAportacion"));
					bean.setFechaIngreso(resultSet.getString("FechaAlta"));
					bean.setSexo(resultSet.getString("Sexo"));
					bean.setAporteSocio(resultSet.getString("ParteSocial"));
					bean.setHora(resultSet.getString("HoraEmision"));
					
					return bean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPFOCOOP", e);
		}
		return matches;
	}
}
