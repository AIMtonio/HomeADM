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
import contabilidad.bean.PermisosContablesBean;


public class PermisosContablesDAO extends BaseDAO{
	public PermisosContablesDAO() {
		super();
	}
	
	public MensajeTransaccionBean alta(final PermisosContablesBean permisosContablesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();		
		try{
		
			String query = "call PERMISOSCONTABLESALT(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {					
					
					permisosContablesBean.getUsuarioID(),					
					permisosContablesBean.getAfectacionFeVa(),
					permisosContablesBean.getCierreEjercicio(),
					permisosContablesBean.getCierrePeriodo(),
					permisosContablesBean.getModificaPolizas(),
					
					parametrosAuditoriaBean.getEmpresaID(),					
					
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PermisosContablesDAO.alta",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info("call PERMISOSCONTABLESALT(" + Arrays.toString(parametros) + ")");
	
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					return mensaje;
				}
			});
			mensaje =  matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
		} catch (Exception e) {
		
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error("error en alta de permiso contable ", e);
		}
		return mensaje;		
	}
	
	public MensajeTransaccionBean modifica(final PermisosContablesBean permisosContablesBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call PERMISOSCONTABLESMOD(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {					
					
					permisosContablesBean.getUsuarioID(),					
					permisosContablesBean.getAfectacionFeVa(),
					permisosContablesBean.getCierreEjercicio(),
					permisosContablesBean.getCierrePeriodo(),
					permisosContablesBean.getModificaPolizas(),
					
					parametrosAuditoriaBean.getEmpresaID(),					
					
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PermisosContablesDAO.alta",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info("call PERMISOSCONTABLESMOD(" + Arrays.toString(parametros) + ")");
	
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error("error en modificacion de permiso contable", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public MensajeTransaccionBean baja(final PermisosContablesBean permisosContables){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call PERMISOSCONTABLESBAJ(?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							permisosContables.getUsuarioID(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"PermisosContablesDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info("call PERMISOSCONTABLESBAJ(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error("error en baja de permiso contable", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	/* Consuta PermisosContables por Llave Principal*/
	public PermisosContablesBean consultaPrincipal(PermisosContablesBean permisosContables, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PERMISOSCONTABLESCON(?,?, ?,?,?,?,?,?,?);";
		
		Object[] parametros = {	permisosContables.getUsuarioID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"PermisosContablesDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info("call PERMISOSCONTABLESCON(" + Arrays.toString(parametros) + ")");
		
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PermisosContablesBean permisosContables = new PermisosContablesBean();
					permisosContables.setUsuarioID(String.valueOf(resultSet.getInt(1)));
					permisosContables.setAfectacionFeVa(resultSet.getString(2));
					permisosContables.setCierreEjercicio(resultSet.getString(3));				
					permisosContables.setCierrePeriodo(resultSet.getString(4));
					permisosContables.setModificaPolizas(resultSet.getString(5));
					return permisosContables;
	
			}
		});
				
		return matches.size() > 0 ? (PermisosContablesBean) matches.get(0) : null;
	}

}
