package tesoreria.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import herramientas.Constantes;
import inversiones.bean.SubCtaMonedaInvBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import tesoreria.bean.SubCtaMonedaDivBean;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;

public class SubCtaMonedaDivDAO extends BaseDAO{
	
	public SubCtaMonedaDivDAO(){
		super();
	}
	
	public MensajeTransaccionBean alta(final SubCtaMonedaDivBean subCtaMonedaDiv) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SUBCTAMONEDADIVALT(?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							subCtaMonedaDiv.getConceptoMonID(),
							subCtaMonedaDiv.getMonedaID(),
							subCtaMonedaDiv.getSubCuenta(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SubCtaMonedaDivDAO.alta",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()	
							};
					loggerSAFI.info("call SUBCTAMONEDADIVALT(" + Arrays.toString(parametros) +")");
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
					loggerSAFI.error("error en alta de subcuenta moneda", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	
	public MensajeTransaccionBean modifica(final SubCtaMonedaDivBean subCtaMonedaDiv){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SUBCTAMONEDADIVMOD(?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							subCtaMonedaDiv.getConceptoMonID(),
							subCtaMonedaDiv.getMonedaID(),
							subCtaMonedaDiv.getSubCuenta(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SubCtaMonedaDivDAO.modifica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()	
							};
					loggerSAFI.info("call SUBCTAMONEDADIVMOD(" + Arrays.toString(parametros) +")");
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
					loggerSAFI.error("error en modifica subcuenta moneda", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	
	public MensajeTransaccionBean baja(final SubCtaMonedaDivBean subCtaMonedaDiv){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SUBCTAMONEDADIVBAJ(?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							subCtaMonedaDiv.getConceptoMonID(),
							subCtaMonedaDiv.getMonedaID(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SubCtaMonedaDivDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()	
							};
					loggerSAFI.info("call SUBCTAMONEDADIVBAJ(" + Arrays.toString(parametros) +")");
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
					loggerSAFI.error("error en baja de subcuenta moneda", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public SubCtaMonedaDivBean consultaPrincipal(SubCtaMonedaDivBean subCtaMonedaDiv, int tipoConsulta){
		String query = "call SUBCTAMONEDADIVCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				subCtaMonedaDiv.getConceptoMonID(),
				subCtaMonedaDiv.getMonedaID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SubCtaMonedaDivDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info("call SUBCTAMONEDADIVCON" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SubCtaMonedaDivBean subCtaMonedaDiv = new SubCtaMonedaDivBean();
				subCtaMonedaDiv.setConceptoMonID(resultSet.getString(1));
				subCtaMonedaDiv.setMonedaID(resultSet.getString(2));
				subCtaMonedaDiv.setSubCuenta(resultSet.getString(3));
				return subCtaMonedaDiv;
			}
		});
		return matches.size() > 0 ? (SubCtaMonedaDivBean) matches.get(0) : null;
	}
	

}
