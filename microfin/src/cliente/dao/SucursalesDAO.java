package cliente.dao;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import javax.sql.DataSource;

import org.apache.log4j.Logger;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionTemplate;

import seguridad.bean.ConexionOrigenDatosBean;
import credito.bean.CreditosBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
import cliente.bean.SucursalesBean;

public class SucursalesDAO {

	//Variables
	private JdbcTemplate jdbcTemplate;		
	Logger log = Logger.getLogger( this.getClass() );
	
	private ConexionOrigenDatosBean conexionOrigenDatosBean=null;
	private ParametrosAuditoriaBean parametrosAuditoriaBean=null;
	
	public SucursalesDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
// ------------------ Transacciones ------------------------------------------

	/* Alta de Sucursales */
	public MensajeTransaccionBean altaSucursal(SucursalesBean sucursal) {
		//Query con el Store Procedure
		String query = "call SUCURSALESALT(?,?,?);";
		Object[] parametros = {	sucursal.getEmpresaID(),
								sucursal.getNombreSucurs(),
								sucursal.getTipoSucursal()};
		
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
	
			}
		});
				
		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}

	/* Modificacion de la sucursal */
	public MensajeTransaccionBean modificaSucursal(SucursalesBean sucursal) {
		//Query cons el Store Procedure
		String query = "call SUCURSALESMOD(?,?,?,?);";
		Object[] parametros = {	Integer.parseInt(sucursal.getSucursalID()),
				Integer.parseInt(sucursal.getEmpresaID()),
				sucursal.getNombreSucurs(),
				sucursal.getTipoSucursal()};
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();			
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
	
			}
		});
				
		return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
	}
	
	
	//consulta de sucursales 
	public SucursalesBean consultaPrincipal(int sucursalID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SUCURSALESCON(?,?);";
		Object[] parametros = {	sucursalID,
								tipoConsulta};
		
		SucursalesBean sucursales = new SucursalesBean();		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();
				sucursales.setSucursalID(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),SucursalesBean.LONGITUD_ID));
					sucursales.setEmpresaID(String.valueOf(resultSet.getInt(2)));
					sucursales.setNombreSucurs(resultSet.getString(3));					
					sucursales.setTipoSucursal(resultSet.getString(4));					

					
					
					return sucursales;
	
			}
		});
		return matches.size() > 0 ? (SucursalesBean) matches.get(0) : null;
				
	}
		
	public SucursalesBean consultaForanea(int sucursalID, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SUCURSALESCON(?,?);";
		Object[] parametros = {	sucursalID,
								tipoConsulta};
		
		SucursalesBean sucursales = new SucursalesBean();		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();
				sucursales.setSucursalID(Utileria.completaCerosIzquierda(
						resultSet.getInt(1),SucursalesBean.LONGITUD_ID));
				sucursales.setNombreSucurs(resultSet.getString(2));					
						
					return sucursales;
	
			}
		});
		return matches.size() > 0 ? (SucursalesBean) matches.get(0) : null;
				
	}
	
	//Lista de sucursales	
	public List listaSucursales(SucursalesBean sucursales, int tipoLista) {
		//Query con el Store Procedure
		String query = "call SUCURSALESLIS(?, ?);";
		Object[] parametros = {	sucursales.getNombreSucurs(),
								tipoLista
								};		
		
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();			
				sucursales.setSucursalID(String.valueOf(resultSet.getInt(1)));
				sucursales.setNombreSucurs(resultSet.getString(2));
				return sucursales;				
			}
		});
				
		return matches;
	}


	//Lista de sucursales para Combo Box	
	public List listaCombo(SucursalesBean sucursales, int tipoLista) {
		//Query con el Store Procedure
		String query = "call SUCURSALESLIS(?, ?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								tipoLista
								};		
		
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SucursalesBean sucursales = new SucursalesBean();			
				sucursales.setSucursalID(String.valueOf(resultSet.getInt(1)));
				sucursales.setNombreSucurs(resultSet.getString(2));
				return sucursales;				
			}
		});
				
		return matches;
	}
	
	
	//------------------ Geters y Seters ------------------------------------------------------
	public void setDataSource(DataSource dataSource) {
		this.jdbcTemplate = new JdbcTemplate(dataSource);
	}

	public void setConexionOrigenDatosBean(
			ConexionOrigenDatosBean conexionOrigenDatosBean) {
		this.conexionOrigenDatosBean = conexionOrigenDatosBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}

}
