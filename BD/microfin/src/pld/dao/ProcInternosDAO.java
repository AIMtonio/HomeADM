package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import pld.bean.MotivosPreoBean;
import pld.bean.ProcInternosBean;

public class ProcInternosDAO extends BaseDAO {
 
	public ProcInternosDAO() {
		super();
	}
	
	public List listaAlfanumerica(ProcInternosBean procInternosBean, int tipoLista){
		String query = "call PLDCATPROCEDINTLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					
					procInternosBean.getDescripcion(),
					tipoLista,
					
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ProcInternosDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATPROCEDINTLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProcInternosBean procInternosBean = new ProcInternosBean();
				procInternosBean.setCatProcedIntID(resultSet.getString(1));
				procInternosBean.setDescripcion(resultSet.getString(2));

		
				return procInternosBean;
				
			}
		});
		return matches;
	}
	
	
	public List listaAlfExterno(ProcInternosBean procInternosBean, int tipoLista){
		String query = "call PLDCATPROCEDINTLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					
					procInternosBean.getDescripcion(),
					tipoLista,
					
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"ProcInternosDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATPROCEDINTLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(procInternosBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProcInternosBean procInternosBean = new ProcInternosBean();
				procInternosBean.setCatProcedIntID(resultSet.getString(1));
				procInternosBean.setDescripcion(resultSet.getString(2));

		
				return procInternosBean;
				
			}
		});
		return matches;
	}
	
	
	public ProcInternosBean consultaPrincipal(ProcInternosBean procInternos, int tipoConsulta){
		String query = "call PLDCATPROCEDINTCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				
				procInternos.getCatProcedIntID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProcInternosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO 
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATPROCEDINTCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProcInternosBean procInternos = new ProcInternosBean();
				procInternos.setDescripcion(resultSet.getString(1));
			return procInternos;
			}
		});
		return matches.size() > 0 ? (ProcInternosBean) matches.get(0) : null;
	}
	
	public ProcInternosBean consultaPrincipalExterna(ProcInternosBean procInternos, int tipoConsulta){
		String query = "call PLDCATPROCEDINTCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				
				procInternos.getCatProcedIntID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ProcInternosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO 
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATPROCEDINTCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(procInternos.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ProcInternosBean procInternos = new ProcInternosBean();
				procInternos.setDescripcion(resultSet.getString(1));
			return procInternos;
			}
		});
		return matches.size() > 0 ? (ProcInternosBean) matches.get(0) : null;
	}
	
}
