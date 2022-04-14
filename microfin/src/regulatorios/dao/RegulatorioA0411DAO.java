package regulatorios.dao;

import general.dao.BaseDAO;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import regulatorios.bean.CarteraPorTipoA0411Bean;
import herramientas.Utileria;


public class RegulatorioA0411DAO extends BaseDAO {

	public RegulatorioA0411DAO() {
		super();
	}
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * CSV
	 * 
	 * */
	
	public List <CarteraPorTipoA0411Bean> reporteRegulatorioA0411Csv(final CarteraPorTipoA0411Bean bean, int tipoReporte){	
		List reporteRegulatorioA0411Csv = null ;
		try{
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGA041100006REP(?,?, ?,?,?,?,?,?,?)";
	
			Object[] parametros ={
					Utileria.convierteFecha(bean.getFecha()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"regulatorioA2610DAO.reporteRegulatorioA0411Csv",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGA041100006REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
					CarteraPorTipoA0411Bean beanResponse= new CarteraPorTipoA0411Bean();
					beanResponse.setValor(resultSet.getString("Valor"));
	
					return beanResponse ;
				}
			});
			
			reporteRegulatorioA0411Csv = matches;
		
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regulatorio A0411 Csv " + e);
			e.printStackTrace();
        }			
        
		return reporteRegulatorioA0411Csv;
	}

	
	
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * SOCAP
	 * 
	 * */
	public List <CarteraPorTipoA0411Bean> reporteRegulatorioA0411Socap2013(final CarteraPorTipoA0411Bean bean, int tipoReporte){	
		List reporteRegulatorioA0411Socap2013 = null ;
		try{
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGA041100006REP(?,?, ?,?,?,?,?,?,?)";
	
			Object[] parametros ={
								Utileria.convierteFecha(bean.getFecha()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"regulatorioA2610DAO.reporteRegulatorioA0411Socap",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGA041100006REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
				CarteraPorTipoA0411Bean beanResponse= new CarteraPorTipoA0411Bean();
				
				beanResponse.setDescripcion(resultSet.getString(1));
				beanResponse.setSaldoCapital(resultSet.getString(2));
				beanResponse.setSaldoInteres(resultSet.getString(3));
				beanResponse.setSaldoTotal(resultSet.getString(4));
				beanResponse.setInteresMes(resultSet.getString(5));
				beanResponse.setComisionMes(resultSet.getString(6));
				beanResponse.setNegrita(resultSet.getString(7));
				
				return beanResponse ;
				}
			});
			reporteRegulatorioA0411Socap2013 = matches;
		
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regularorio A0411(2013) Excel " + e);
			e.printStackTrace();
	    }			
	    
		return reporteRegulatorioA0411Socap2013;
	}
	
	public List <CarteraPorTipoA0411Bean> reporteRegulatorioA0411Socap2014(final CarteraPorTipoA0411Bean bean, int tipoReporte){	
		List reporteRegulatorioA0411Socap2014 = null ;
		try{
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGA041100006REP(?,?, ?,?,?,?,?,?,?)";
	
			Object[] parametros ={
								Utileria.convierteFecha(bean.getFecha()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"regulatorioA2610DAO.reporteRegulatorioA0411Socap",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGA041100006REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
				CarteraPorTipoA0411Bean beanResponse= new CarteraPorTipoA0411Bean();
				
				beanResponse.setClaveConcepto(resultSet.getString(1));
				beanResponse.setDescripcion(resultSet.getString(2));
				beanResponse.setTotalVigente(resultSet.getString(3));
				beanResponse.setPrincipalVigente(resultSet.getString(4));
				beanResponse.setInteresVigente(resultSet.getString(5));
				beanResponse.setTotSinPagVencido(resultSet.getString(6));
				beanResponse.setPrinSinPagVencido(resultSet.getString(7));
				beanResponse.setInterSinPagVencido(resultSet.getString(8));
				beanResponse.setTotConPagVencido(resultSet.getString(9));
				beanResponse.setPrinConPagVencido(resultSet.getString(10));
				beanResponse.setInterConPagVencido(resultSet.getString(11));
				beanResponse.setTotalVencido(resultSet.getString(12));
				beanResponse.setPrincipalVencido(resultSet.getString(13));
				beanResponse.setInteresVencido(resultSet.getString(14));
				beanResponse.setTipoConcepto(resultSet.getString(15));
				
				return beanResponse ;
				}
			});
			reporteRegulatorioA0411Socap2014 = matches;
		
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regularorio A0411(2014) Excel " + e);
			e.printStackTrace();
	    }			
	    
		return reporteRegulatorioA0411Socap2014;
	}
	
	/* ------------------------------------------------------------------------------------------
	 * ------------------------------------------------------------------------------------------
	 * SOFIPO
	 * 
	 * */
	
	public List <CarteraPorTipoA0411Bean> reporteRegulatorioA2610Sofipo(final CarteraPorTipoA0411Bean bean, int tipoReporte){	
		List reporteRegulatorioA2610Sofipo = null ;
		try{
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGA041100003REP(?,?, ?,?,?,?,?,?,?)";
	
			Object[] parametros ={
								Utileria.convierteFecha(bean.getFecha()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"regulatorioA2610DAO.reporteRegulatorioA2610Sofipo",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGA041100003REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
				CarteraPorTipoA0411Bean beanResponse= new CarteraPorTipoA0411Bean();
				
				beanResponse.setClaveConcepto(resultSet.getString("ClaveConcepto"));
				beanResponse.setDescripcion(resultSet.getString("Descripcion"));
				beanResponse.setClasifConta(resultSet.getString("ClasifConta"));
				beanResponse.setCarTotal(resultSet.getString("CarTotal"));
				beanResponse.setToTalVigente(resultSet.getString("ToTalVigente"));
				beanResponse.setPrincipalVigen(resultSet.getString("PrincipalVigen"));
				beanResponse.setInteresesVigen(resultSet.getString("InteresesVigen"));
				beanResponse.setCredSinPagVen(resultSet.getString("CredSinPagVen"));
				beanResponse.setSinPagVenPrin(resultSet.getString("SinPagVenPrin"));
				beanResponse.setSinPagVenInt(resultSet.getString("SinPagVenInt"));
				beanResponse.setCredConPagVen(resultSet.getString("CredConPagVen"));
				beanResponse.setConPagVenPrin(resultSet.getString("ConPagVenPrin"));
				beanResponse.setConPagVenInt(resultSet.getString("ConPagVenInt"));
				beanResponse.setCartVencida(resultSet.getString("CartVencida"));
				beanResponse.setVenPrincipal(resultSet.getString("VenPrincipal"));
				beanResponse.setVenInteres(resultSet.getString("VenInteres"));
				
				
				return beanResponse ;
				}
			});
			reporteRegulatorioA2610Sofipo = matches;
			
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regularorio A0411 Excel " + e);
			e.printStackTrace();
	    }			
    
		return reporteRegulatorioA2610Sofipo;
	}
	
	public List <CarteraPorTipoA0411Bean> reporteRegulatorioA0411CsvSofipo(final CarteraPorTipoA0411Bean bean, int tipoReporte){	
		List reporteRegulatorioA2610SofipoCSV = null ;
		try{
			transaccionDAO.generaNumeroTransaccion();
			String query = "call REGA041100003REP(?,?, ?,?,?,?,?,?,?)";
	
			Object[] parametros ={
					Utileria.convierteFecha(bean.getFecha()),
								tipoReporte,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"regulatorioA2610DAO.reporteRegulatorioA0411Csv",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGA041100003REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					
					CarteraPorTipoA0411Bean beanResponse= new CarteraPorTipoA0411Bean();
					beanResponse.setValor(resultSet.getString("Valor"));
	
					return beanResponse ;
				}
			});
			reporteRegulatorioA2610SofipoCSV = matches;
		
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regulatorio A0411 Csv " + e);
			e.printStackTrace();
	    }			
    
		return reporteRegulatorioA2610SofipoCSV;
	}
	
}
