package soporte.dao;

import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cliente.bean.ClienteBean;

import soporte.bean.EdoCtaPerEjecutadoBean;

public class EdoCtaPeriodoEjecutadoDAO extends BaseDAO{
		
	public EdoCtaPeriodoEjecutadoDAO() {
		super();
	}
	
	/* LISTA ANIOS */
	public List listaMesesEjecutados(int tipoLista) {
		// Query con el Store Procedure
		List listaMesesEjecutados = null;
		try{
			String query = "call EDOCTAPERMENEJECUTADOSLIS(?,?," 
											   +"?,?,?,?,?,?,?);";
			
			Object[] parametros = { 
				tipoLista,
				Constantes.STRING_VACIO,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"EdoCtaPeriodoEjecutadoDAO.listaMesesEjecutados",
				parametrosAuditoriaBean.getSucursal(), 
				Constantes.ENTERO_CERO 
			};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPERMENEJECUTADOSLIS(  " + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					
					EdoCtaPerEjecutadoBean edoCtaPerEjecutadoBean = new EdoCtaPerEjecutadoBean();		
	
					edoCtaPerEjecutadoBean.setAnioMes(resultSet.getString("AnioMes"));
					edoCtaPerEjecutadoBean.setPeriodo(resultSet.getString("Periodo"));
					
					return edoCtaPerEjecutadoBean;
				}
			});
			listaMesesEjecutados = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de periodos mensuales ejecutados de estado de cuenta", e);
		}

		return listaMesesEjecutados;
	}

	/* LISTA ANIOS */
	public List listaSemestresEjecutados(int tipoLista) {
		// Query con el Store Procedure
		List listaSemestresEjecutados = null;
		try{
			String query = "call EDOCTAPERMENEJECUTADOSLIS(?,?," 
											   +"?,?,?,?,?,?,?);";
			
			Object[] parametros = { 
				tipoLista,
				Constantes.STRING_VACIO,
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"EdoCtaPeriodoEjecutadoDAO.listaSemestresEjecutados",
				parametrosAuditoriaBean.getSucursal(), 
				Constantes.ENTERO_CERO 
			};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPERMENEJECUTADOSLIS(  " + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
	
					EdoCtaPerEjecutadoBean edoCtaPerEjecutadoBean = new EdoCtaPerEjecutadoBean();		
	
					edoCtaPerEjecutadoBean.setAnioMes(resultSet.getString("AnioMes"));
					edoCtaPerEjecutadoBean.setPeriodo(resultSet.getString("Periodo"));
					
					return edoCtaPerEjecutadoBean;
				}
			});
			listaSemestresEjecutados = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de periodos semestrales ejecutados de estado de cuenta", e);
		}

		return listaSemestresEjecutados;
	}
	
	/* LISTA PERIODO POR MES */
	public List listaPorMeses(EdoCtaPerEjecutadoBean periodo, int tipoLista) {
		// Query con el Store Procedure
		List listaMesesEjecutados = null;
		try{
			String query = "call EDOCTAPERMENEJECUTADOSLIS(?,?," 
											   +"?,?,?,?,?,?,?);";
			
			Object[] parametros = { 
				
				tipoLista,
				periodo.getAnio(),
				
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"EdoCtaPeriodoEjecutadoDAO.listaPorMeses",
				parametrosAuditoriaBean.getSucursal(), 
				Constantes.ENTERO_CERO 
			};
			
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPERMENEJECUTADOSLIS(  " + Arrays.toString(parametros) + ")");
			
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					
					EdoCtaPerEjecutadoBean edoCtaPerEjecutadoBean = new EdoCtaPerEjecutadoBean();		
	
					edoCtaPerEjecutadoBean.setAnioMes(resultSet.getString("AnioMes"));
					
					return edoCtaPerEjecutadoBean;
				}
			});
			listaMesesEjecutados = matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista principal de periodos mensuales ejecutados de estado de cuenta", e);
		}

		return listaMesesEjecutados;
	}
	
	public EdoCtaPerEjecutadoBean consultaPeriodo(EdoCtaPerEjecutadoBean edoCtaPerEjecutadoBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call EDOCTAPERMENEJECUTADOSCON(?,?,?,?,?, ?,?,?,?,?, ?,?);";
		Object[] parametros = {	edoCtaPerEjecutadoBean.getAnio(),
								edoCtaPerEjecutadoBean.getMes(),
								Constantes.ENTERO_CERO,
								Constantes.STRING_VACIO,
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTAPERMENEJECUTADOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				EdoCtaPerEjecutadoBean edoCtaPerEjecutadoBean = new EdoCtaPerEjecutadoBean();			
				edoCtaPerEjecutadoBean.setAnioMes(resultSet.getString("AnioMes"));	
				return edoCtaPerEjecutadoBean;
			}
		});
		return matches.size() > 0 ? (EdoCtaPerEjecutadoBean) matches.get(0) : null;	
	}
	
}
