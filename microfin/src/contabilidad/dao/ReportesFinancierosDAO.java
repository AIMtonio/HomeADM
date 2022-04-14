package contabilidad.dao;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;








import contabilidad.bean.ConceptoContableBean;
import contabilidad.bean.ReporteFinancierosBean;
import general.dao.BaseDAO;
import guardaValores.bean.DocumentosGuardaValoresBean;
import herramientas.Constantes;
import herramientas.Utileria;
import soporte.bean.ParamGeneralesBean;

public class ReportesFinancierosDAO extends BaseDAO{
	
	
	
	/**
	 * @author lvicente 
	 * @param reporteFinancierosBean
	 * @return Lista con Mapa de Estado de Resultado
	 */
	public List  estadoResultado(ReporteFinancierosBean reporteFinancierosBean) {
		//Query con el Store Procedure
		String query = "call EDORESINTERNOREP(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
		
		Object[] parametros = {	reporteFinancierosBean.getEjercicio(),
								reporteFinancierosBean.getPeriodo(),
								reporteFinancierosBean.getFecha(),
								reporteFinancierosBean.getTipoConsulta(),
								Constantes.STRING_SI,
								
								reporteFinancierosBean.getCifras(),
								reporteFinancierosBean.getCcInicial(),
								reporteFinancierosBean.getCcFinal(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ReportesFinancierosDAO.estadoResultado",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDORESINTERNOREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					Map<String,String> mapaReportes = new HashMap<String,String>();
					ResultSetMetaData meta = resultSet.getMetaData();
					for(int i=1;i<=meta.getColumnCount();i++){
						mapaReportes.put(meta.getColumnName(i),resultSet.getString(meta.getColumnName(i)));
					}
					return mapaReportes;
			}
		});	
		return matches;
	}
	
	
	public List flujoEfectivo(ReporteFinancierosBean reporteFinancierosBean) {
		//Query con el Store Procedure
		String query = "call EDOFLUJOEFECTIVOREP(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
		
		Object[] parametros = {	reporteFinancierosBean.getEjercicio(),
								reporteFinancierosBean.getPeriodo(),
								reporteFinancierosBean.getFecha(),
								reporteFinancierosBean.getTipoConsulta(),
								Constantes.STRING_SI,
								
								reporteFinancierosBean.getCifras(),
								reporteFinancierosBean.getCcInicial(),
								reporteFinancierosBean.getCcFinal(),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								
								Constantes.FECHA_VACIA,
								parametrosAuditoriaBean.getDireccionIP(),
								"ReportesFinancierosDAO.flujoEfectivo",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOFLUJOEFECTIVOREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					Map<String,String> mapaReportes = new HashMap<String,String>();
					ResultSetMetaData meta = resultSet.getMetaData();
					for(int i=1;i<=meta.getColumnCount();i++){
						mapaReportes.put(meta.getColumnName(i),resultSet.getString(meta.getColumnName(i)));
					}
					return mapaReportes;
			}
		});	
		return matches;
	}
	
	
	
	public List balanceGeneral(ReporteFinancierosBean reporteFinancierosBean) {
		//Query con el Store Procedure
		String query = "call BALANCEINTERNOREP(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
		
		Object[] parametros = {	reporteFinancierosBean.getEjercicio(),
								reporteFinancierosBean.getPeriodo(),
								reporteFinancierosBean.getFecha(),
								reporteFinancierosBean.getTipoConsulta(),
								Constantes.STRING_SI,
								
								reporteFinancierosBean.getCifras(),
								reporteFinancierosBean.getCcInicial(),
								reporteFinancierosBean.getCcFinal(),
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								
								Constantes.FECHA_VACIA,
								parametrosAuditoriaBean.getDireccionIP(),
								"ReportesFinancierosDAO.balanceGeneral",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BALANCEINTERNOREP(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					Map<String,String> mapaReportes = new HashMap<String,String>();
					ResultSetMetaData meta = resultSet.getMetaData();
					for(int i=1;i<=meta.getColumnCount();i++){
						mapaReportes.put(meta.getColumnName(i),resultSet.getString(meta.getColumnName(i)));
					}
					return mapaReportes;
			}
		});	
		return matches;
	}
	
	
	
	
	public List cabeceraEstadoVariacion(ReporteFinancierosBean reporteFinancierosBean ){
		String query = "call PARAMEDOVARIACIONESCON(?,?,?,?,?, ?,?,?,?);";
		int ConstanteEnteroUno = 1;
		Object[] parametros = {	Constantes.ENTERO_CERO,
								ConstanteEnteroUno,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								
								Constantes.FECHA_VACIA,
								parametrosAuditoriaBean.getDireccionIP(),
								"ReportesFinancierosDAO.cabeceraEstadoVariacion",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMEDOVARIACIONESCON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					Map<String,String> mapaReportes = new HashMap<String,String>();
					ResultSetMetaData meta = resultSet.getMetaData();
					for(int i=1;i<=meta.getColumnCount();i++){
						mapaReportes.put(meta.getColumnName(i),resultSet.getString(meta.getColumnName(i)));
					}
					return mapaReportes;
			}
		});	
		return matches;
	}
	
	
	public List estadoVariacion(ReporteFinancierosBean reporteFinancierosBean, final ParamGeneralesBean paramGeneralesBean){
		//Query con el Store Procedure
		List<ReporteFinancierosBean> listaReporte = null;
		//Query con el Store Procedure
		try{
				String query = "CALL EDOVARIACIONESREP(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
				
				Object[] parametros = {	reporteFinancierosBean.getEjercicio(),
										reporteFinancierosBean.getPeriodo(),
										reporteFinancierosBean.getFecha(),
										reporteFinancierosBean.getTipoConsulta(),
										Constantes.STRING_SI,
										
										reporteFinancierosBean.getCifras(),
										reporteFinancierosBean.getCcInicial(),
										reporteFinancierosBean.getCcFinal(),
										parametrosAuditoriaBean.getEmpresaID(),
										parametrosAuditoriaBean.getUsuario(),
										
										parametrosAuditoriaBean.getFecha(),
										parametrosAuditoriaBean.getDireccionIP(),
										"ReportesFinancierosDAO.estadoVariacion",
										parametrosAuditoriaBean.getSucursal(),
										Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOVARIACIONESREP(" + Arrays.toString(parametros) + ")");
					List matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								ReporteFinancierosBean repEstadoVariacionBean = new ReporteFinancierosBean();
						
						repEstadoVariacionBean.setDescripcion(resultSet.getString("Descripcion"));
						repEstadoVariacionBean.setParticipacionControladora(resultSet.getString("ParticipacionControladora"));
						repEstadoVariacionBean.setCapitalSocial(resultSet.getString("CapitalSocial"));
						repEstadoVariacionBean.setAportacionesCapital(resultSet.getString("AportacionesCapital"));
						repEstadoVariacionBean.setPrimaVenta(resultSet.getString("PrimaVenta"));
						
						repEstadoVariacionBean.setObligacionesSubordinadas(resultSet.getString("ObligacionesSubordinadas"));
						repEstadoVariacionBean.setIncorporacionSocFinancieras(resultSet.getString("IncorporacionSocFinancieras"));
						repEstadoVariacionBean.setReservaCapital(resultSet.getString("ReservaCapital"));
						repEstadoVariacionBean.setResultadoEjerAnterior(resultSet.getString("ResultadoEjerAnterior"));
						repEstadoVariacionBean.setResultadoTitulosVenta(resultSet.getString("ResultadoTitulosVenta"));
						
						repEstadoVariacionBean.setResultadoValuacionInstrumentos(resultSet.getString("ResultadoValuacionInstrumentos"));
						repEstadoVariacionBean.setEfectoAcomulado(resultSet.getString("EfectoAcomulado"));
						repEstadoVariacionBean.setBeneficioEmpleados(resultSet.getString("BeneficioEmpleados"));
						repEstadoVariacionBean.setResultadoMonetario(resultSet.getString("ResultadoMonetario"));
						repEstadoVariacionBean.setResultadoActivos(resultSet.getString("ResultadoActivos"));
						
						repEstadoVariacionBean.setParticipacionNoControladora(resultSet.getString("ParticipacionNoControladora"));
						repEstadoVariacionBean.setCapitalContable(resultSet.getString("CapitalContable"));
						
						if(Utileria.convierteEntero(paramGeneralesBean.getValorParametro()) == Constantes.ClienteEspecifico.NatGas){
							repEstadoVariacionBean.setDirectorFinanzas(resultSet.getString("Par_DirectorFinanzas"));
							repEstadoVariacionBean.setGerenteGeneral(resultSet.getString("Par_GerenteGral"));
							repEstadoVariacionBean.setJefeContabilidad(resultSet.getString("Par_JefeContabilidad"));

						}
						return repEstadoVariacionBean;
						}
				});
				listaReporte = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el Reporte de Estado de Variacion ", exception);
			listaReporte = null;
		}

		return listaReporte;
				
	}
	
}
