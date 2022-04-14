package contabilidad.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
 
import contabilidad.bean.RepPolizasIntersucBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class RepPolizasIntersucDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean=null;

	public RepPolizasIntersucDAO () {
		super();
	}
	
	//reporte Para reportes de transferencias bancarias
	public List listaTransCtasBan(RepPolizasIntersucBean reporteBean){
		//Query con el Store Procedure
	
				String query = "call TRANSFERCTASBANREP(?,?, ?,?,?,?,?,?,?);";		
				Object[] parametros = {										
										reporteBean.getFechaInicial(),
										reporteBean.getFechaFinal(),
										
										parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										parametrosAuditoriaBean.getNombrePrograma(),
										parametrosAuditoriaBean.getSucursal(),
										parametrosAuditoriaBean.getNumeroTransaccion()
										};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TRANSFERCTASBANREP(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						RepPolizasIntersucBean repTransferCtasBanBean= new RepPolizasIntersucBean();			
						repTransferCtasBanBean.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
						repTransferCtasBanBean.setCcostosOrigen(resultSet.getString("CCostosOrigen"));
						repTransferCtasBanBean.setCcostoDestino(resultSet.getString("CCostosDestino"));
						repTransferCtasBanBean.setSucursaldestino(resultSet.getString("SucursalDestino"));
						repTransferCtasBanBean.setMontosTranfer(Double.valueOf(resultSet.getString("Monto")).doubleValue());
						repTransferCtasBanBean.setFecha(resultSet.getString("Fecha"));
						repTransferCtasBanBean.setTipoRegistro(resultSet.getString("TipoRegistro"));						
						return repTransferCtasBanBean;				
					}
				});
				return matches;
	}
	
	//reporte Para reportes de Polizas intersucursales
		public List listaPolizasIntersucursales(RepPolizasIntersucBean reporteBean){
			//Query con el Store Procedure
			
					String query = "call POLIZASINTERSUCREP(?,?, ?,?,?,?,?,?,?);";		
					Object[] parametros = {										
											reporteBean.getFechaInicial(),
											reporteBean.getFechaFinal(),
											
											parametrosAuditoriaBean.getEmpresaID(),
											parametrosAuditoriaBean.getUsuario(),
											parametrosAuditoriaBean.getFecha(),
											parametrosAuditoriaBean.getDireccionIP(),
											parametrosAuditoriaBean.getNombrePrograma(),
											parametrosAuditoriaBean.getSucursal(),
											parametrosAuditoriaBean.getNumeroTransaccion()
											};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call POLIZASINTERSUCREP(" + Arrays.toString(parametros) + ")");
					
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							RepPolizasIntersucBean repTransferCtasBanBean= new RepPolizasIntersucBean();			
							repTransferCtasBanBean.setSucursalOrigen(resultSet.getString("SucursalOrigen"));
							repTransferCtasBanBean.setCcostosOrigen(resultSet.getString("CCostosOrigen"));
							repTransferCtasBanBean.setCcostoDestino(resultSet.getString("CCostosDestino"));
							repTransferCtasBanBean.setSucursaldestino(resultSet.getString("SucursalDestino"));
							repTransferCtasBanBean.setCantidad(Double.valueOf(resultSet.getString("Monto")).doubleValue());
							repTransferCtasBanBean.setFecha(resultSet.getString("Fecha"));	
							repTransferCtasBanBean.setTipoRegistro(resultSet.getString("TipoRegistro"));							
							return repTransferCtasBanBean;				
						}
					});
					return matches;
		}
	
		//reporte Para reportes de Facturas Proveedores 
				public List listaFacturaProveedores(RepPolizasIntersucBean reporteBean){
					//Query con el Store Procedure
						String query = "call FACTURASPROVREP(?,?, ?,?,?,?,?,?,?);";		
							Object[] parametros = {										
													reporteBean.getFechaInicial(),
													reporteBean.getFechaFinal(),
													
													parametrosAuditoriaBean.getEmpresaID(),
													parametrosAuditoriaBean.getUsuario(),
													parametrosAuditoriaBean.getFecha(),
													parametrosAuditoriaBean.getDireccionIP(),
													parametrosAuditoriaBean.getNombrePrograma(),
													parametrosAuditoriaBean.getSucursal(),
													parametrosAuditoriaBean.getNumeroTransaccion()
													};
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FACTURASPROVREP(" + Arrays.toString(parametros) + ")");
							
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
								public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
									RepPolizasIntersucBean repFacturasProvBean= new RepPolizasIntersucBean();			
									repFacturasProvBean.setCcostoscxp(resultSet.getString("CCostoCXP"));
									repFacturasProvBean.setCcostosOrigen(resultSet.getString("CCostoOrigen"));
									repFacturasProvBean.setSucursalGasto(resultSet.getString("SucursalGasto"));
									repFacturasProvBean.setCcostoGasto(resultSet.getString("CentroCostoGasto"));
									repFacturasProvBean.setMontoPagado(Double.valueOf(resultSet.getString("MontoPagado")).doubleValue());
									repFacturasProvBean.setFecha(resultSet.getString("Fecha"));
									repFacturasProvBean.setTipoRegistro(resultSet.getString("tipoRegistro"));
									return repFacturasProvBean;				
								}
							});
							return matches;
				}
				
				//reporte Para reportes Gastos por comprobar y anticipos
				public List listaGastosAnticipos(RepPolizasIntersucBean reporteBean){
					//Query con el Store Procedure			
							String query = "call GASTOSANTICIPOSREP(?,?, ?,?,?,?,?,?,?);";		
							Object[] parametros = {										
													reporteBean.getFechaInicial(),
													reporteBean.getFechaFinal(),
													
													parametrosAuditoriaBean.getEmpresaID(),
													parametrosAuditoriaBean.getUsuario(),
													parametrosAuditoriaBean.getFecha(),
													parametrosAuditoriaBean.getDireccionIP(),
													parametrosAuditoriaBean.getNombrePrograma(),
													parametrosAuditoriaBean.getSucursal(),
													parametrosAuditoriaBean.getNumeroTransaccion()
													};
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GASTOSANTICIPOSREP(" + Arrays.toString(parametros) + ")");
							
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
								public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
									RepPolizasIntersucBean repGastosAnticiposBean= new RepPolizasIntersucBean();			
									repGastosAnticiposBean.setSucOperacion(resultSet.getString("SucOperacion"));
									repGastosAnticiposBean.setCcostoOperacion(resultSet.getString("CCostoOperacionSuc"));
									repGastosAnticiposBean.setMovEmpleadosOperacion(resultSet.getString("MovEmpleadoSuc"));
									repGastosAnticiposBean.setCcostoEmpleado(resultSet.getString("CCostoEmpleado"));
									repGastosAnticiposBean.setSalida(Double.valueOf(resultSet.getString("Salida")).doubleValue());
									repGastosAnticiposBean.setEntrada(Double.valueOf(resultSet.getString("Entrada")).doubleValue());
									repGastosAnticiposBean.setFecha(resultSet.getString("Fecha"));
									repGastosAnticiposBean.setTipoRegistro(resultSet.getString("tipoRegistro"));
									return repGastosAnticiposBean;				
								}
							});
							return matches;
				}
				
				//reporte Para reportes Operaciones Ventanilla
				public List listaOperacionesVentanilla(RepPolizasIntersucBean reporteBean){
					//Query con el Store Procedure					
							String query = "call OPEVENTANILLACLIREP(?,?, ?,?,?,?,?,?,?);";		
							Object[] parametros = {										
													reporteBean.getFechaInicial(),
													reporteBean.getFechaFinal(),
													
													parametrosAuditoriaBean.getEmpresaID(),
													parametrosAuditoriaBean.getUsuario(),
													parametrosAuditoriaBean.getFecha(),
													parametrosAuditoriaBean.getDireccionIP(),
													parametrosAuditoriaBean.getNombrePrograma(),
													parametrosAuditoriaBean.getSucursal(),
													parametrosAuditoriaBean.getNumeroTransaccion()
													};
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPEVENTANILLACLIREP(" + Arrays.toString(parametros) + ")");
							
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
								public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
									RepPolizasIntersucBean repOperacionesVenBean= new RepPolizasIntersucBean();			
									repOperacionesVenBean.setSucOperacion(resultSet.getString("SucOperacion"));
									repOperacionesVenBean.setCcostoOperacion(resultSet.getString("CentroOperacion"));
									repOperacionesVenBean.setMovimientosSocio(resultSet.getString("MovSociosSuc"));
									repOperacionesVenBean.setCcostosocio(resultSet.getString("CentroCostoSocio"));
									repOperacionesVenBean.setSalida(Double.valueOf(resultSet.getString("Salidas")).doubleValue());
									repOperacionesVenBean.setEntrada(Double.valueOf(resultSet.getString("Entradas")).doubleValue());
									repOperacionesVenBean.setFecha(resultSet.getString("Fecha"));
									repOperacionesVenBean.setTipoRegistro(resultSet.getString("TipoRegistro"));
									return repOperacionesVenBean;				
								}
							});
							return matches;
				}
	
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}	
}






