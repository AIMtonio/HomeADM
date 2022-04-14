package cuentas.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
 
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;

import cuentas.bean.ParentescosBean;

public class ParentescosDAO extends BaseDAO  {

	//Variables
	
	public ParentescosDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
// ------------------ Transacciones ------------------------------------------

	//consulta de Promotores
	public ParentescosBean consultaPrincipal(ParentescosBean parentescosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPORELACIONESCON(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	parentescosBean.getParentescoID(),
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ParentescosDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPORELACIONESCON(" + Arrays.toString(parametros) +")");
		ParentescosBean parentesco = new ParentescosBean();		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParentescosBean parentesco = new ParentescosBean();
				parentesco.setParentescoID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 6));
				parentesco.setEmpresa(Utileria.completaCerosIzquierda(resultSet.getInt(2), 6));
				parentesco.setDescripcion(resultSet.getString(3));
				return parentesco;
	
			}
		});
		return matches.size() > 0 ? (ParentescosBean) matches.get(0) : null;
				
	}
	
	public ParentescosBean consultaForanea(ParentescosBean parentescosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPORELACIONESCON(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	parentescosBean.getParentescoID(),
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ParentescosDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPORELACIONESCON(" + Arrays.toString(parametros) +")");
		ParentescosBean parentesco = new ParentescosBean();		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParentescosBean parentesco = new ParentescosBean();
				parentesco.setParentescoID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 6));
				parentesco.setDescripcion(resultSet.getString(2));		
				return parentesco;
			}
		});
		return matches.size() > 0 ? (ParentescosBean) matches.get(0) : null;
	}
		
	public ParentescosBean consultaParentescos(ParentescosBean parentescosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call TIPORELACIONESCON(?,?,  ?,?,?,?,?,?,?);";
		Object[] parametros = {	parentescosBean.getParentescoID(),
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"ParentescosDAO.consultaParentescos",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPORELACIONESCON(" + Arrays.toString(parametros) +")");
		ParentescosBean parentesco = new ParentescosBean();
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParentescosBean parentesco = new ParentescosBean();
				parentesco.setParentescoID(Utileria.completaCerosIzquierda(resultSet.getInt(1), 6));
				parentesco.setEmpresa(Utileria.completaCerosIzquierda(resultSet.getInt(2), 6));
				parentesco.setDescripcion(resultSet.getString(3));
				parentesco.setTipo(resultSet.getString(4));
				parentesco.setGrado(resultSet.getString(5));
				parentesco.setLinea(resultSet.getString(6));
				return parentesco;
	
			}
		});
		return matches.size() > 0 ? (ParentescosBean) matches.get(0) : null;
				
	}
	
	//Lista de Parentescos	
	public List listaParentescos(ParentescosBean parentesco, int tipoLista) {
		//Query con el Store Procedure
		String query = "call TIPORELACIONESLIS(?,?, ?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	
								Constantes.ENTERO_CERO,
								parentesco.getDescripcion(),
								tipoLista,
								
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"ParentescosDAO.listaParentescos",
								parametrosAuditoriaBean.getSucursal(),
								parametrosAuditoriaBean.getNumeroTransaccion()
								};		
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPORELACIONESLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ParentescosBean parentesco = new ParentescosBean();			
				parentesco.setParentescoID(String.valueOf(resultSet.getInt(1)));;
				parentesco.setDescripcion(resultSet.getString(2));
				return parentesco;
			}
		});
				
		return matches;
	}	
	//------------------ Geters y Seters ------------------------------------------------------

}
