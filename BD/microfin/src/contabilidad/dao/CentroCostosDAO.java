package contabilidad.dao;
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

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import contabilidad.bean.CentroCostosBean;

public class CentroCostosDAO extends BaseDAO{

	
	public CentroCostosDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
// ------------------ Transacciones ------------------------------------------

	/* Alta de Sucursales */
	public MensajeTransaccionBean altaCentroCostos(final CentroCostosBean centro) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query con el Store Procedure
					String query = "call CENTROCOSTOSALT(?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {	Utileria.convierteEntero(centro.getCentroCostoID()),
											centro.getDescripcion(),
											centro.getResponsable(),
											Utileria.convierteEntero(centro.getPlazaID()),
											parametrosAuditoriaBean.getEmpresaID(),
											parametrosAuditoriaBean.getUsuario(),
											parametrosAuditoriaBean.getFecha(),
											parametrosAuditoriaBean.getDireccionIP(),
											"CentroCostosDAO.altaCentroCostos",
											parametrosAuditoriaBean.getSucursal(),
											parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CENTROCOSTOSALT(" + Arrays.toString(parametros) + ")");
					
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
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de sucursales", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion de la sucursal */
	public MensajeTransaccionBean modificaCentroCostos(final CentroCostosBean centro) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					//Query cons el Store Procedure
					String query = "call CENTROCOSTOSMOD(?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {	Utileria.convierteEntero(centro.getCentroCostoID()),
											centro.getDescripcion(),
											centro.getResponsable(),
											Utileria.convierteEntero(centro.getPlazaID()),
											parametrosAuditoriaBean.getEmpresaID(),
											parametrosAuditoriaBean.getUsuario(),
											parametrosAuditoriaBean.getFecha(),
											parametrosAuditoriaBean.getDireccionIP(),
											"CentroCostosDAO.modificaCentroCostos",
											parametrosAuditoriaBean.getSucursal(),
											parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CENTROCOSTOSMOD(" + Arrays.toString(parametros) + ")");
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
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de la sucursal", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	
	//consulta de sucursales 
	public CentroCostosBean consultaPrincipal(CentroCostosBean centro, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CENTROCOSTOSCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(centro.getCentroCostoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CentroCostosDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CENTROCOSTOSCON(" + Arrays.toString(parametros) + ")");
				
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CentroCostosBean centro = new CentroCostosBean();
				centro.setCentroCostoID(String.valueOf(resultSet.getInt(1)));
				centro.setDescripcion(resultSet.getString(2));
				centro.setResponsable(resultSet.getString(3));
				centro.setPlazaID(String.valueOf(resultSet.getInt(4)));
					
					return centro;
	
			}
		});
		return matches.size() > 0 ? (CentroCostosBean) matches.get(0) : null;
				
	}
		
	public CentroCostosBean consultaForanea(CentroCostosBean centro, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call CENTROCOSTOSCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(centro.getCentroCostoID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"CentroCostosDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CENTROCOSTOSCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CentroCostosBean centro = new CentroCostosBean();
				centro.setCentroCostoID(String.valueOf(resultSet.getInt(1)));
				centro.setDescripcion(resultSet.getString(2));				
						
					return centro;
	
			}
		});
		return matches.size() > 0 ? (CentroCostosBean) matches.get(0) : null;
				
	}
	
	//Lista de sucursales	
	public List lista(CentroCostosBean centro, int tipoLista) {
		//Query con el Store Procedure
		String query = "call CENTROCOSTOSLIS(?,?,?,?,?,		?,?,?,?,?);";
		Object[] parametros = {	centro.getDescripcion(),
								tipoLista,
								Constantes.ENTERO_CERO,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"CentroCostosDAO.lista",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CENTROCOSTOSLIS(" + Arrays.toString(parametros) + ")");					
		
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CentroCostosBean centro = new CentroCostosBean();			
				centro.setCentroCostoID(String.valueOf(resultSet.getInt(1)));
				centro.setDescripcion(resultSet.getString(2));		
				return centro;				
			}
		});
				
		return matches;
	}
	
	public List listaGrid(CentroCostosBean centro, int tipoLista) {
		List centroCostos = null;
		//Query con el Store Procedure
		String query = "call CENTROCOSTOSLIS(?,?,?,?,?,		?,?,?,?,?);";
		try{
			Object[] parametros = {	
					Constantes.STRING_VACIO,
					tipoLista,
					centro.getProrrateoID(),
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CentroCostosDAO.lista",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CENTROCOSTOSLIS(" + Arrays.toString(parametros) + ")");			
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CentroCostosBean centro = new CentroCostosBean();			
				centro.setCentroCostoID(String.valueOf(resultSet.getInt("CentroCostoID")));
				centro.setDescripcion(resultSet.getString("Descripcion"));
				centro.setProrrateoID(resultSet.getString("ProrrateoID"));
				centro.setPorcentaje(resultSet.getString("Porcentaje"));				
				return centro;
			}
			});				
			centroCostos= matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al en la lista del grid de Centros de Costos "+e);
		}			
		return centroCostos;
	}

	

}
