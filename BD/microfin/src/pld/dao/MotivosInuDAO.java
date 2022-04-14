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

import pld.bean.MotivosInuBean;
import pld.bean.MotivosPreoBean;
 
public class MotivosInuDAO extends BaseDAO {

	public MotivosInuDAO() {
		super();
	}
	
	public List listaAlfanumerica(MotivosInuBean motivosInuBean, int tipoLista){
		String query = "call PLDCATMOTIVINULIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				
					motivosInuBean.getCatMotivInuID(),
					tipoLista,
					
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"MotivosInuDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATMOTIVINULIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivosInuBean motivosInuBean = new MotivosInuBean();
				motivosInuBean.setCatMotivInuID(resultSet.getString(1));
				motivosInuBean.setDesCorta(resultSet.getString(2));
				motivosInuBean.setDesLarga(resultSet.getString(3));
		
				return motivosInuBean;
				
			}
		});
		return matches;
		}
	/**
	 * Método que trae la lista de Motivos para Operaciones Inusuales
	 * @param motivosInuBean: Cadena para filtrar la Lista
	 * @param tipoLista: Número de Lista
	 * @return: Retorna una Lista con todos los motivos
	 */
	public List listaAlfExterno(MotivosInuBean motivosInuBean, int tipoLista) {
		try {
			String query = "call PLDCATMOTIVINULIS("
					+ "?,?,?,?,?,      "
					+ "?,?,?,?);";
			Object[] parametros = {
					
					motivosInuBean.getCatMotivInuID(),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"MotivosInuDAO.listaAlfanumerica",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call PLDCATMOTIVINULIS(" + Arrays.toString(parametros) + ")");
			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(motivosInuBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					try {
						MotivosInuBean motivosInuBean = new MotivosInuBean();
						motivosInuBean.setCatMotivInuID(resultSet.getString(1));
						motivosInuBean.setDesCorta(resultSet.getString(2));
						motivosInuBean.setDesLarga(resultSet.getString(3));
						return motivosInuBean;
					} catch (Exception ex) {
						ex.printStackTrace();
					}
					return null;
				}
			});
			return matches;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}
	
	
	
	public MotivosInuBean consultaPrincipal(MotivosInuBean motivosInu, int tipoConsulta){
		String query = "call PLDCATMOTIVINUCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				
				motivosInu.getCatMotivInuID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"MotivosInuDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO 
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATMOTIVINUCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivosInuBean motivosInu = new MotivosInuBean();
				motivosInu.setDesLarga(resultSet.getString(1));
			return motivosInu;
			}
		});
		return matches.size() > 0 ? (MotivosInuBean) matches.get(0) : null;
	}
	
	public MotivosInuBean consultaPrincipalExterna(MotivosInuBean motivosInu, int tipoConsulta){
		String query = "call PLDCATMOTIVINUCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				
				motivosInu.getCatMotivInuID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"MotivosInuDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO 
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLDCATMOTIVINUCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(motivosInu.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MotivosInuBean motivosInu = new MotivosInuBean();
				motivosInu.setDesLarga(resultSet.getString(1));
			return motivosInu;
			}
		});
		return matches.size() > 0 ? (MotivosInuBean) matches.get(0) : null;
	}
	
	
	
}
