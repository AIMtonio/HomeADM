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
import regulatorios.bean.EstimacionPreventivaA419Bean;


public class EstimacionPreventivaA419DAO extends BaseDAO {

	public EstimacionPreventivaA419DAO() {
		super();
	}
	
	/* =========== FUNCIONES PARA OBTENER INFORMACION PARA LOS REPORTES ============= */
	/**
	 * Consulta para Reporte de Estimación Preventiva A-0419 - SOCAP
	 * Serie R04: A0419
	 * @param b0419Bean
	 * @param tipoLista
	 * @return
	 */
	public List <EstimacionPreventivaA419Bean> consultaRegulatorioA0419Socap(final EstimacionPreventivaA419Bean a0419Bean, int tipoLista){	
		List reporteRegulatorioA0419Socap = null ;
		try{
			String query = "call REGULATORIOA0419REP(?,?,?, ?,?,?,?,?,?,?)";
			int numero_decimales=2;
			Object[] parametros ={
								Utileria.convierteFecha(a0419Bean.getFecha()),
								tipoLista,
								numero_decimales,
								
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
			};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA0419REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EstimacionPreventivaA419Bean regA0419Bean= new EstimacionPreventivaA419Bean();
					regA0419Bean.setPeriodo(resultSet.getString("Periodo"));
					regA0419Bean.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					regA0419Bean.setSubReporte(resultSet.getString("SubReporte"));
					regA0419Bean.setClaveConcepto(resultSet.getString("ClaveConcepto"));
					regA0419Bean.setDescripcion(resultSet.getString("Descripcion"));
					regA0419Bean.setFormulario(resultSet.getString("Formulario"));
					regA0419Bean.setTipoMoneda(resultSet.getString("TipoMoneda"));
					regA0419Bean.setTipoCartera(resultSet.getString("TipoCartera"));
					regA0419Bean.setTipoSaldo(resultSet.getString("TipoSaldo"));
					regA0419Bean.setMonto(resultSet.getString("Monto"));
								
					
					return regA0419Bean ;
				}
			});
			reporteRegulatorioA0419Socap = matches;
			
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regularorio A0419 Excel " + e);
			e.printStackTrace();
	    }			
	    
		return reporteRegulatorioA0419Socap;

	}
	
	/**
	 * Consulta para Reporte de Estimación Preventiva A-0419 - SOCAP
	 * Serie R04: A0419
	 * @param b0419Bean
	 * @param tipoLista
	 * @return
	 */
	public List <EstimacionPreventivaA419Bean> consultaRegulatorioA0419Sofipo(final EstimacionPreventivaA419Bean a0419Bean, int tipoLista){	
		List reporteRegulatorioA0419Sofipo = null ;
		try{
			String query = "call REGULATORIOA0419REP(?,?,?, ?,?,?,?,?,?,?)";
			int numero_decimales=2;
			Object[] parametros ={
								Utileria.convierteFecha(a0419Bean.getFecha()),
								tipoLista,
								numero_decimales,
								
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
			};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA0419REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EstimacionPreventivaA419Bean regA0419Bean= new EstimacionPreventivaA419Bean();
					regA0419Bean.setPeriodo(resultSet.getString("Periodo"));
					regA0419Bean.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					regA0419Bean.setSubReporte(resultSet.getString("SubReporte"));
					regA0419Bean.setClaveConcepto(resultSet.getString("ClaveConcepto"));
					regA0419Bean.setDescripcion(resultSet.getString("Descripcion"));
					regA0419Bean.setFormulario(resultSet.getString("Formulario"));
					regA0419Bean.setTipoMoneda(resultSet.getString("TipoMoneda"));
					regA0419Bean.setTipoCartera(resultSet.getString("TipoCartera"));
					regA0419Bean.setTipoSaldo(resultSet.getString("TipoSaldo"));
					regA0419Bean.setMonto(resultSet.getString("Monto"));
								
					
					return regA0419Bean ;
				}
			});
			reporteRegulatorioA0419Sofipo = matches;
			
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regularorio A0419 Excel " + e);
			e.printStackTrace();
	    }			
	    
		return reporteRegulatorioA0419Sofipo;
	}

	
	/**
	 * Consulta para Reporte de Estimación Preventiva A-0419
	 * Serie R04: A0419 en CSV
	 * @param a0419Bean
	 * @param tipoLista
	 * @return
	 */
	public List <EstimacionPreventivaA419Bean> reporteRegulatorio0419(final EstimacionPreventivaA419Bean a0419Bean, int tipoLista){	
		List reporteRegulatorioA0419 = null ;
		try{
			String query = "call REGULATORIOA0419REP(?,?,?,  ?,?,?,?,?,?,?)";
			int numeroDecimales=2;
			Object[] parametros ={
								Utileria.convierteFecha(a0419Bean.getFecha()),
								tipoLista,
								numeroDecimales,
					    		parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								parametrosAuditoriaBean.getNombrePrograma(),
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call REGULATORIOA0419REP(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EstimacionPreventivaA419Bean regA0419Bean= new EstimacionPreventivaA419Bean();
					regA0419Bean.setValor(resultSet.getString(1));
	
					return regA0419Bean ;
				}
			});
			reporteRegulatorioA0419 = matches;
			
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte Regularorio A0419 CSV " + e);
			e.printStackTrace();
	    }			
	    
		return reporteRegulatorioA0419;
	}
}
