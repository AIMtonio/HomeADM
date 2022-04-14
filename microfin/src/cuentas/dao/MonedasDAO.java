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

import cuentas.bean.MonedasBean;

public class MonedasDAO extends BaseDAO {

	public MonedasDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
// ------------------ Transacciones ------------------------------------------

	
	//consulta de Monedas
	public MonedasBean consultaPrincipal(int monedaID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call MONEDASCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {	monedaID,
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"MonedasDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONEDASCON(" + Arrays.toString(parametros) +")");
		MonedasBean monedas = new MonedasBean();		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MonedasBean monedas = new MonedasBean();
				monedas.setMonedaID(Utileria.completaCerosIzquierda(resultSet.getInt(1), MonedasBean.LONGITUD_ID));
				monedas.setEmpresaID(Utileria.completaCerosIzquierda(resultSet.getInt(2), 6));
				monedas.setDescripcion(resultSet.getString(3));					
				monedas.setDescriCorta(resultSet.getString(4));
				monedas.setSimbolo(resultSet.getString(5));
				return monedas;
	
			}
		});
		return matches.size() > 0 ? (MonedasBean) matches.get(0) : null;
				
	}
	
	public MonedasBean consultaForanea(int monedaID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call MONEDASCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {	monedaID,
								tipoConsulta,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"MonedasDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONEDASCON(" + Arrays.toString(parametros) +")");
		MonedasBean monedas = new MonedasBean();		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				MonedasBean monedas = new MonedasBean();
				monedas.setMonedaID(Utileria.completaCerosIzquierda(resultSet.getInt(1), MonedasBean.LONGITUD_ID));
				monedas.setDescripcion(resultSet.getString(2));		
				return monedas;
			}
		});
		return matches.size() > 0 ? (MonedasBean) matches.get(0) : null;
	}
		
	//Lista de Monedas	
		public List listaMonedas(int tipoLista) {
			//Query con el Store Procedure
			String query = "call MONEDASLIS(?,? ,?,?,?,?,?,?,?);";
			Object[] parametros = {	
					"",
					tipoLista,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"MonedasDAO.listaMonedas",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};		
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONEDASLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MonedasBean monedas = new MonedasBean();			
					monedas.setMonedaID(String.valueOf(resultSet.getInt(1)));;
					monedas.setDescripcion(resultSet.getString(2));
					return monedas;				
				}
			});
					
			return matches;
		}
		
		//Lista de Monedas	
			public List listaMonedaslist(int tipoLista, MonedasBean descripcion) {
				//Query con el Store Procedure
				String query = "call MONEDASLIS(?,? ,?,?,?,?,?,?,?);";
				Object[] parametros = {	
						descripcion.getMonedaID(),
						tipoLista,
						
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"MonedasDAO.listaMonedas",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO
						};		
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call MONEDASLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						MonedasBean monedas = new MonedasBean();			
						monedas.setMonedaID(String.valueOf(resultSet.getInt(1)));;
						monedas.setDescripcion(resultSet.getString(2));
						return monedas;				
					}
				});
						
				return matches;
			}
			
}
