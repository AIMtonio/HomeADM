package cliente.dao;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import cliente.bean.ReportesPATMIRBean;
import general.dao.BaseDAO;
import herramientas.Constantes;

public class ReportesPATMIRDAO extends BaseDAO{
			
	/*------------Alta de Operaciones-------------*/		
	public List consultaSocioMenor(ReportesPATMIRBean reportesPATMIRBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call REPPATMIR(?,?);";
			Object[] parametros = { 	
									tipoReporte,
									reportesPATMIRBean.getFechaReporte()};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REPPATMIR(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesPATMIRBean repPATMIRBean = new ReportesPATMIRBean();
					
					repPATMIRBean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
					repPATMIRBean.setCurp(resultSet.getString("CURP"));
					repPATMIRBean.setNombre(resultSet.getString("Nombre"));
					repPATMIRBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
					repPATMIRBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
					repPATMIRBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					repPATMIRBean.setFechaBaja(resultSet.getString("FechaBaja"));
					repPATMIRBean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
					repPATMIRBean.setEstadoNacimiento(resultSet.getString("EstadoNacimiento"));
					repPATMIRBean.setGenero(resultSet.getString("Genero"));
					repPATMIRBean.setNombreLocalidad(resultSet.getString("NombreLocalidad"));
					repPATMIRBean.setCalle(resultSet.getString("Calle"));				
					repPATMIRBean.setLengInd(resultSet.getString("LengInd"));
					repPATMIRBean.setEdoCivil(resultSet.getString("EdoCivil"));
					repPATMIRBean.setColonia(resultSet.getString("Colonia"));
					repPATMIRBean.setRecibeServVent(resultSet.getString("RecibeServVent"));
					repPATMIRBean.setIdNivEstudios(resultSet.getString("idNivEstudios"));
					repPATMIRBean.setIdNivIngresos(resultSet.getString("idNivIngresos"));				
										
					return repPATMIRBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPPATMIR", e);
		}
		return matches;
	}
	
	public List consultaParteSocial(ReportesPATMIRBean reportesPATMIRBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call REPPATMIR(?,?);";
			Object[] parametros = { 	
									tipoReporte,
									reportesPATMIRBean.getFechaReporte()};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REPPATMIR(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesPATMIRBean repPATMIRBean= new ReportesPATMIRBean();
					
					repPATMIRBean.setClavePatmir(resultSet.getString("ClavePatmir"));
					repPATMIRBean.setClienteID(resultSet.getString("ClienteID"));
					repPATMIRBean.setParteSocial(resultSet.getString("ParteSocial"));
														
					return repPATMIRBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPPATMIR", e);
		}
		return matches;
	}
	
	public List consultaCreditos(ReportesPATMIRBean reportesPATMIRBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call REPPATMIR(?,?);";
			Object[] parametros = { 	
									tipoReporte,
									reportesPATMIRBean.getFechaReporte()};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REPPATMIR(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesPATMIRBean repPATMIRBean= new ReportesPATMIRBean();
						
					repPATMIRBean.setClavePA(String.valueOf(resultSet.getInt("ClavePA")));
					repPATMIRBean.setSocioID(resultSet.getString("SocioID"));
					repPATMIRBean.setPrestamo(resultSet.getString("Prestamo"));						
								
										
					return repPATMIRBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPPATMIR", e);
		}
		return matches;
	}
	
	public List consultaAhorros(ReportesPATMIRBean reportesPATMIRBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call REPPATMIR(?,?);";
			Object[] parametros = { 	
									tipoReporte,
									reportesPATMIRBean.getFechaReporte()};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REPPATMIR(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesPATMIRBean repPATMIRBean= new ReportesPATMIRBean();
										
					repPATMIRBean.setClavePA(resultSet.getString("ClavePA"));
					repPATMIRBean.setSocio(resultSet.getString("Socio"));
					repPATMIRBean.setAhorro(resultSet.getString("Ahorro"));
					repPATMIRBean.setMontoInv(resultSet.getString("MontoInv"));
					repPATMIRBean.setTotal(resultSet.getString("Total"));
										
					return repPATMIRBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPPATMIR", e);
		}
		return matches;
	}	
	
	public List consultaBajas(ReportesPATMIRBean reportesPATMIRBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call REPPATMIR(?,?);";
			Object[] parametros = { 	
									tipoReporte,
									reportesPATMIRBean.getFechaReporte()};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REPPATMIR(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesPATMIRBean repPATMIRBean = new ReportesPATMIRBean();
					
					repPATMIRBean.setSocio(resultSet.getString("Socio"));
					repPATMIRBean.setFechaBaja(resultSet.getString("FechaBaja"));
														
					return repPATMIRBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de REPPATMIR", e);
		}
		return matches;
	}
	
	// Reportes para Socios Menores 
	
	public List consultaSociosMenores(ReportesPATMIRBean reportesPATMIRBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call PATMIRCLIMENORESREP(?,?, ?,?,?,?,?,?,? );";
			Object[] parametros = { 	
									tipoReporte,
									reportesPATMIRBean.getFechaReporte(),
									
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ReportesPATMIRDAO.consultaSociosMenores",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PATMIRCLIMENORESREP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesPATMIRBean repPATMIRBean = new ReportesPATMIRBean();
					
					repPATMIRBean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
					repPATMIRBean.setCurp(resultSet.getString("CURP"));
					repPATMIRBean.setNombre(resultSet.getString("Nombre"));
					repPATMIRBean.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));
					repPATMIRBean.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
					repPATMIRBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					repPATMIRBean.setFechaBaja(resultSet.getString("FechaBaja"));
					repPATMIRBean.setFechaNacimiento(resultSet.getString("FechaNacimiento"));
					repPATMIRBean.setEstadoNacimiento(resultSet.getString("EstadoNacimiento"));
					repPATMIRBean.setGenero(resultSet.getString("Genero"));
					repPATMIRBean.setNombreLocalidad(resultSet.getString("NombreLocalidad"));
					repPATMIRBean.setCalle(resultSet.getString("Calle"));				
					repPATMIRBean.setLengInd(resultSet.getString("LenguaInd"));
					repPATMIRBean.setEdoCivil(resultSet.getString("EstadoCivil"));
					repPATMIRBean.setColonia(resultSet.getString("Colonia"));
					repPATMIRBean.setRecibeServVent(resultSet.getString("RecibeServVent"));
					repPATMIRBean.setIdNivEstudios(resultSet.getString("idNivEstudios"));
					repPATMIRBean.setIdNivIngresos(resultSet.getString("idNivIngresos"));				
										
					return repPATMIRBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de PATMIRCLIMENORESREP", e);
		}
		return matches;
	}
	
	public List consultaAltasMenores(ReportesPATMIRBean reportesPATMIRBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call PATMIRCLIMENORESREP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { 	
									tipoReporte,
									reportesPATMIRBean.getFechaReporte(),
									
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ReportesPATMIRDAO.consultaAltasMenores",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PATMIRCLIMENORESREP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesPATMIRBean repPATMIRBean = new ReportesPATMIRBean();
					
					repPATMIRBean.setSocio(resultSet.getString("Socio"));
					repPATMIRBean.setFechaAlta(resultSet.getString("FechaAlta"));
														
					return repPATMIRBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de PATMIRCLIMENORESREP", e);
		}
		return matches;
	}
	
	public List consultaAhorrosMenores(ReportesPATMIRBean reportesPATMIRBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call PATMIRCLIMENORESREP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { 	
									tipoReporte,
									reportesPATMIRBean.getFechaReporte(),
									
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ReportesPATMIRDAO.consultaAhorrosMenores",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PATMIRCLIMENORESREP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesPATMIRBean repPATMIRBean= new ReportesPATMIRBean();
										
					repPATMIRBean.setClavePA(resultSet.getString("ClavePA"));
					repPATMIRBean.setSocio(resultSet.getString("Socio"));
					repPATMIRBean.setAhorro(resultSet.getString("Ahorro"));
										
					return repPATMIRBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de PATMIRCLIMENORESREP", e);
		}
		return matches;
	}
	
	public List consultaBajasMenores(ReportesPATMIRBean reportesPATMIRBean, int tipoReporte){
		List matches = null;
		try{
			String query = "call PATMIRCLIMENORESREP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { 	
									tipoReporte,
									reportesPATMIRBean.getFechaReporte(),
									
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"ReportesPATMIRDAO.consultaBajasMenores",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PATMIRCLIMENORESREP(" + Arrays.toString(parametros) +")");
		matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					ReportesPATMIRBean repPATMIRBean = new ReportesPATMIRBean();
					
					repPATMIRBean.setSocio(resultSet.getString("Socio"));
					repPATMIRBean.setFechaBaja(resultSet.getString("FechaBaja"));
														
					return repPATMIRBean;
				}
			});
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de PATMIRCLIMENORESREP", e);
		}
		return matches;
	}
}

