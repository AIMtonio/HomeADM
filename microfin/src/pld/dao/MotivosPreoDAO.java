package pld.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.dao.BaseDAO;
import gestionComecial.bean.AreasBean;
import herramientas.Constantes;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;
 
import org.springframework.jdbc.core.RowMapper;

import pld.bean.EstadosPreocupantesBean;
import pld.bean.MotivosPreoBean;
import pld.bean.OpIntPreocupantesBean;

public class MotivosPreoDAO extends BaseDAO {

	public MotivosPreoDAO() {
		super();
	}
	
	public List listaAlfanumerica(MotivosPreoBean motivosPreoBean, int tipoLista){
		String query = "call PLDCATMOTIVPREOLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				
					motivosPreoBean.getCatMotivPreoID(),
					tipoLista,
					
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"MotivosPreoDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATMOTIVPREOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivosPreoBean motivosPreoBean = new MotivosPreoBean();
				motivosPreoBean.setCatMotivPreoID(resultSet.getString(1));
				motivosPreoBean.setDesCorta(resultSet.getString(2));
				motivosPreoBean.setDesLarga(resultSet.getString(3));
		
				return motivosPreoBean;
				
			}
		});
		return matches;
		}
	public List listaAlfanumericaExterna(MotivosPreoBean motivosPreoBean, int tipoLista){
		String query = "call PLDCATMOTIVPREOLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				
					motivosPreoBean.getCatMotivPreoID(),
					tipoLista,
					
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"MotivosPreoDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATMOTIVPREOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(motivosPreoBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivosPreoBean motivosPreoBean = new MotivosPreoBean();
				motivosPreoBean.setCatMotivPreoID(resultSet.getString(1));
				motivosPreoBean.setDesCorta(resultSet.getString(2));
				motivosPreoBean.setDesLarga(resultSet.getString(3));
		
				return motivosPreoBean;
				
			}
		});
		return matches;
		}
	
	public MotivosPreoBean consultaPrincipal(MotivosPreoBean motivosPreo, int tipoConsulta){
		String query = "call PLDCATMOTIVPREOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				
				motivosPreo.getCatMotivPreoID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"MotivosPreoDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO 
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATMOTIVPREOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivosPreoBean motivosPreo = new MotivosPreoBean();
				motivosPreo.setDesLarga(resultSet.getString(1));
			return motivosPreo;
			}
		});
		return matches.size() > 0 ? (MotivosPreoBean) matches.get(0) : null;
	}
	
	public MotivosPreoBean consultaPrincipalExterna(MotivosPreoBean motivosPreo, int tipoConsulta){
		String query = "call PLDCATMOTIVPREOCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				
				motivosPreo.getCatMotivPreoID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"MotivosPreoDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO 
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATMOTIVPREOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(motivosPreo.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivosPreoBean motivosPreo = new MotivosPreoBean();
				motivosPreo.setDesLarga(resultSet.getString(1));
			return motivosPreo;
			}
		});
		return matches.size() > 0 ? (MotivosPreoBean) matches.get(0) : null;
	}
	
	
}
