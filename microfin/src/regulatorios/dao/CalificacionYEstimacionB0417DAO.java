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

public class CalificacionYEstimacionB0417DAO extends BaseDAO {

	public CalificacionYEstimacionB0417DAO() {
		super();
	}
	
	/* =========== FUNCIONES PARA OBTENER INFORMACION PARA LOS REPORTES ============= */
	
	/**
	 * Consulta para Reporte de Cartera de Calificacion y Estimaciones Preventivas
	 * Serie R04: B0417
	 * @param b0417Bean
	 * @param tipoLista
	 * @return
	 */
	public List <CalificacionYEstimacionB0417Bean> consultaRegulatorioB0417(final CalificacionYEstimacionB0417Bean b0417Bean, int tipoLista){	
		
		String query = "call REGCALRESTIPCRE(?,?, ?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(b0417Bean.getFecha()),
							tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCALRESTIPCRE(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CalificacionYEstimacionB0417Bean regB0417Bean= new CalificacionYEstimacionB0417Bean();
				regB0417Bean.setConcepto(resultSet.getString(1));
				regB0417Bean.setCarteraBase(resultSet.getString(2));
				regB0417Bean.setMontoEstimacion(resultSet.getString(3));
				regB0417Bean.setEstilo(resultSet.getString(5));
				regB0417Bean.setColorCelda(resultSet.getString(6));

				return regB0417Bean ;
			}
		});
		return matches;
	}
	
	
	/**
	 * Consulta para Reporte de Cartera de Calificacion y Estimaciones Preventivas
	 * Serie R04: B0417 en CSV
	 * @param b0417Bean
	 * @param tipoLista
	 * @return
	 */
	public List <CalificacionYEstimacionB0417Bean> reporteRegulatorio0417Csv(final CalificacionYEstimacionB0417Bean b0417Bean, int tipoLista){	
		
		String query = "call REGCALRESTIPCRE(?,?, ?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(b0417Bean.getFecha()),
							tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGCALRESTIPCRE(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CalificacionYEstimacionB0417Bean regB0417Bean= new CalificacionYEstimacionB0417Bean();
				regB0417Bean.setValor(resultSet.getString(1));

				return regB0417Bean ;
			}
		});
		return matches;
	}
	
	
	
	/**
	 * Consulta para Reporte de Cartera de Calificacion y Estimaciones Preventivas
	 * Serie R04: B0417 Version 2015
	 * @param b0417Bean
	 * @param tipoLista
	 * @return
	 */
	public List<CalificacionYEstimacionB0417Bean> consultaRegulatorioB0417Socap(
			final CalificacionYEstimacionB0417Bean b0417Bean, int tipoLista) {
		int numero_decimales=2;
		String query = "call REGULATORIOA0417REP(?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(b0417Bean.getFecha()),
							tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA0417REP(" + Arrays.toString(parametros) +")");
		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CalificacionYEstimacionB0417Bean regB0417Bean = new CalificacionYEstimacionB0417Bean();
						regB0417Bean.setDescripcion(resultSet.getString("Descripcion"));
						regB0417Bean.setMontoCartera(String.valueOf(resultSet.getDouble("MontoCartera")));
						regB0417Bean.setMontoEPRC(String.valueOf(resultSet.getDouble("MontoEPRC")));
					
					return regB0417Bean ;
				}
				
			});
		
			return matches;

		}
		catch(Exception ex){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regularorio A0417 Socap Excel " + ex);
			ex.printStackTrace();
		}
		return null;
	}
	
	
	/**
	 * Consulta para Reporte de Cartera de Calificacion y Estimaciones Preventivas
	 * Serie R04: B0417 Version 2017
	 * @param b0417Bean
	 * @param tipoLista
	 * @return
	 */
	public List<CalificacionYEstimacionB0417Bean> consultaRegulatorioB0417Sofipo(
			final CalificacionYEstimacionB0417Bean b0417Bean, int tipoLista) {
		int numero_decimales=2;
		String query = "call REGULATORIOA0417REP(?,?,	?,?,?,?,?,?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(b0417Bean.getFecha()),
							tipoLista,
				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA0417REP(" + Arrays.toString(parametros) +")");
		try{
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CalificacionYEstimacionB0417Bean regB0417Bean = new CalificacionYEstimacionB0417Bean();
						regB0417Bean.setDescripcion(resultSet.getString("Descripcion"));
						regB0417Bean.setMontoCartera(String.valueOf(resultSet.getDouble("Cartera")));
						regB0417Bean.setMontoEPRC(String.valueOf(resultSet.getDouble("Reserva")));
					
					return regB0417Bean ;
				}
				
			});
		
			return matches;
	
			}
		catch(Exception ex){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regularorio A0417 Sofipo Excel " + ex);
			ex.printStackTrace();
		}
		return null;
	}
	
	
	
	
	/**
	 * Consulta para Reporte de Cartera de Calificacion y Estimaciones Preventivas
	 * Serie R04: B0417 Version 2015 en CSV
	 * @param b0417Bean
	 * @param tipoLista
	 * @return
	 */
	public List <CalificacionYEstimacionB0417Bean> reporteRegulatorio0417CSVVersion2015(final CalificacionYEstimacionB0417Bean b0417Bean, int tipoLista){	
		List reporteRegulatorio0417 = null ;
		try{
			String query = "call REGULATORIOA0417REP(?,?,  ?,?,?,?,?,?,?)";
			int numeroDecimales=2;
			Object[] parametros ={
								Utileria.convierteFecha(b0417Bean.getFecha()),
								tipoLista,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA0417REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CalificacionYEstimacionB0417Bean regB0417Bean= new CalificacionYEstimacionB0417Bean();
					regB0417Bean.setValor(resultSet.getString(1));
	
					return regB0417Bean ;
				}
			});
			reporteRegulatorio0417 = matches;
			
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regularorio A0417 CSV " + e);
			e.printStackTrace();
	    }			
	    
		return reporteRegulatorio0417;
	}

}
	