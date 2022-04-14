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
import regulatorios.bean.RepCaptacionPorLocalidad821Bean;
import regulatorios.bean.RepRegulatorioCaptacion811Bean;
import regulatorios.bean.ReporteRegulatorioBean;

public class RepRegulatorioCaptacionDAO extends BaseDAO  {
	
	public RepRegulatorioCaptacionDAO() {
		super();
	}

	public List <RepRegulatorioCaptacion811Bean> reporteCaptacion811(final RepRegulatorioCaptacion811Bean reporteBean,int tipoLista){
		List<RepRegulatorioCaptacion811Bean> listaReporte = null;
		try{
			String query = "call REGCAPTRAD811REP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros ={
					reporteBean.getFecha(),
					tipoLista,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RepRegulatorioCaptacionDAO.reporteCaptacion811",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCAPTRAD811REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepRegulatorioCaptacion811Bean reporteRegBean = new RepRegulatorioCaptacion811Bean();
					reporteRegBean.setConcepto(resultSet.getString("Reg_Concepto")); 
					reporteRegBean.setSalCapCie(resultSet.getString("Reg_SalCapCie"));
					reporteRegBean.setSalIntNoPa(resultSet.getString("Reg_SalIntNoPa"));
					reporteRegBean.setSalCieMes(resultSet.getString("Reg_SalCieMes"));
					reporteRegBean.setIntMes(resultSet.getString("Reg_IntMes"));
					reporteRegBean.setComMes(resultSet.getString("Reg_ComMes"));
					return reporteRegBean ;
				}
			});
		
			listaReporte= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de captacion", e);
		}
		return listaReporte ;
	}

	public List <RepRegulatorioCaptacion811Bean> reporteRegulatorio0811Csv(final RepRegulatorioCaptacion811Bean reporteBean,int tipoLista){
		List<RepRegulatorioCaptacion811Bean> listaReporte = null;
		try{
			String query = "call REGCAPTRAD811REP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros ={
					reporteBean.getFecha(),
					tipoLista,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RepRegulatorioCaptacionDAO.reporteCaptacion811",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCAPTRAD811REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepRegulatorioCaptacion811Bean reporteRegBean = new RepRegulatorioCaptacion811Bean();
					reporteRegBean.setValor(resultSet.getString(1)); 
	
					return reporteRegBean ;
				}
			});
		
			listaReporte= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de captacion", e);
		}
		return listaReporte ;
	}
	// Consulta para Reporte en Excel de Regulatorio Captacion Localidad B0821 (2013)
	public List <RepCaptacionPorLocalidad821Bean> reporteCaptacionPorLocalidad8212013(final RepCaptacionPorLocalidad821Bean reporteBean,int tipoLista){
		List<RepCaptacionPorLocalidad821Bean> listaReporte = null;
		try{
			String query = "call REGCAPTLOC821REP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros ={
					reporteBean.getFecha(),
					tipoLista,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"reporteCaptacionPorLocalidad821",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCAPTLOC821REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepCaptacionPorLocalidad821Bean reporteRegBean = new RepCaptacionPorLocalidad821Bean();
					reporteRegBean.setTipoInstrumento(resultSet.getString(1)); 
					reporteRegBean.setClasificacionContable(resultSet.getString(2));
					reporteRegBean.setPeriodo(resultSet.getString(3));
					reporteRegBean.setClaveFederacion(resultSet.getString(4));
					reporteRegBean.setClaveEntidad(resultSet.getString(5));
					reporteRegBean.setClaveNivelEntidad(resultSet.getString(6));
					reporteRegBean.setLocalidad(resultSet.getString(7));
					reporteRegBean.setMonto(resultSet.getString(8));
					reporteRegBean.setNumeroContratos(resultSet.getString(9));
					
					return reporteRegBean ;
				}
			});
		
			listaReporte= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de captacion por localidad", e);
		}
		return listaReporte ;
	}

	// Consulta para Reporte en Excel de Regulatorio Captacion Localidad B0821 (2014)
	public List <RepCaptacionPorLocalidad821Bean> reporteCaptacionPorLocalidad821(final RepCaptacionPorLocalidad821Bean reporteBean,int tipoLista){
		List<RepCaptacionPorLocalidad821Bean> listaReporte = null;
		try{
			String query = "call REGCAPTLOC821REP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros ={
					reporteBean.getFecha(),
					tipoLista,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"reporteCaptacionPorLocalidad821",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCAPTLOC821REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepCaptacionPorLocalidad821Bean reporteRegBean = new RepCaptacionPorLocalidad821Bean();
					reporteRegBean.setTipoInstrumento(resultSet.getString("TipoInstrumento")); 
					reporteRegBean.setClasificacionContable(resultSet.getString("ClasifConta"));
					reporteRegBean.setEstado(resultSet.getString("Estado"));
					reporteRegBean.setMunicipio(resultSet.getString("Municipio"));
					reporteRegBean.setLocalidad(resultSet.getString("Localidad"));
					reporteRegBean.setMonto(resultSet.getString("Monto"));
					reporteRegBean.setNumeroContratos((String.valueOf(resultSet.getInt("NumContratos"))));
					return reporteRegBean ;
				}
			});
		
			listaReporte= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de captacion por localidad", e);
		}
		return listaReporte ;
	}
	
	// Consulta para Reporte en CSV de Regulatorio Captacion Localidad B0821
	public List <RepCaptacionPorLocalidad821Bean> reporteRegulatorioB0821Csv(final RepCaptacionPorLocalidad821Bean reporteBean,int tipoLista){
		
			String query = "call REGCAPTLOC821REP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros ={
					reporteBean.getFecha(),
					tipoLista,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"reporteCaptacionPorLocalidad821",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCAPTLOC821REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					RepCaptacionPorLocalidad821Bean reporteRegBean = new RepCaptacionPorLocalidad821Bean();
					reporteRegBean.setValor(resultSet.getString(1));
					return reporteRegBean ;
				}
			});
			return matches;
		}
	
	// Consulta para Reporte en Excel de Regulatorio A0815 
	public List <ReporteRegulatorioBean> reporteRegulatorio0815(final ReporteRegulatorioBean reporteBean,int tipoLista){
		List<ReporteRegulatorioBean> listaReporte = null;
		try{
			String query = "call REGULATORIO0815REP(?,?,?,	?,?,?,?,?,?,?);";
			Object[] parametros ={
					Utileria.convierteEntero(reporteBean.getAnio()),
					Utileria.convierteEntero(reporteBean.getMes()),
					tipoLista,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RepRegulatorioCaptacionDAO.reporteRegulatorio0815",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIO0815REP(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteRegulatorioBean reporteRegBean = new ReporteRegulatorioBean();
					reporteRegBean.setConcepto(resultSet.getString("Concepto")); 
					reporteRegBean.setSaldo(resultSet.getString("Saldo")); 
					reporteRegBean.setNumCuentas(resultSet.getString("NumCuentas")); 
					
					return reporteRegBean ;
				}
			});
		
			listaReporte= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de captacion", e);
		}
		return listaReporte ;
	}
	
	// Consulta para Reporte de Regulatorio A0815 en Csv
	public List <ReporteRegulatorioBean> reporteRegulatorio0815Csv(final ReporteRegulatorioBean reporteBean,int tipoLista){
		List<ReporteRegulatorioBean> listaReporte = null;
		try{
			String query = "call REGULATORIO0815REP(?,?,?,	?,?,?,?,?,?,?);";
			Object[] parametros ={
					Utileria.convierteEntero(reporteBean.getAnio()),
					Utileria.convierteEntero(reporteBean.getMes()),
					tipoLista,
		    		parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"RepRegulatorioCaptacionDAO.reporteRegulatorio0815",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIO0815REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ReporteRegulatorioBean reporteRegBean = new ReporteRegulatorioBean();
					reporteRegBean.setValor(resultSet.getString(1));
					
					return reporteRegBean ;
				}
			});
		
			listaReporte= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en reporte de captacion", e);
		}
		return listaReporte ;
	}
	
	
}

