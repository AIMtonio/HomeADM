package inversiones.dao;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;
 
import javax.sql.DataSource;

import inversiones.bean.SubCtaTiProInvBean;

public class SubCtaTiProInvDAO  extends BaseDAO  {


	public SubCtaTiProInvDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final SubCtaTiProInvBean subCtaTiProInv) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SUBCTATIPROINVALT(?,?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							subCtaTiProInv.getConceptoInvID(),
							subCtaTiProInv.getTipoProductoID(),
							subCtaTiProInv.getSubCuenta(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SubCtaTiProInvDAO.alta",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()	
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTATIPROINVALT(" + Arrays.toString(parametros) + ")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de subcuenta de inversion de tipo de producto", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public MensajeTransaccionBean modifica(final SubCtaTiProInvBean subCtaTiProInv){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SUBCTATIPROINVMOD(?,?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							subCtaTiProInv.getConceptoInvID(),
							subCtaTiProInv.getTipoProductoID(),
							subCtaTiProInv.getSubCuenta(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SubCtaTiProInvDAO.modifica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()	
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTATIPROINVMOD(" + Arrays.toString(parametros) + ")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de subcuenta de inversion de tipo de producto", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public MensajeTransaccionBean baja(final SubCtaTiProInvBean subCtaTiProInv){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SUBCTATIPROINVBAJ(?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							subCtaTiProInv.getConceptoInvID(),
							subCtaTiProInv.getTipoProductoID(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SubCtaTiProInvDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()	
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTATIPROINVBAJ(" + Arrays.toString(parametros) + ")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de subcuenta de tipo de producto de inversion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public SubCtaTiProInvBean consultaPrincipal(SubCtaTiProInvBean subCtaTiProInv, int tipoConsulta){
		String query = "call SUBCTATIPROINVCON(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				subCtaTiProInv.getConceptoInvID(),
				subCtaTiProInv.getTipoProductoID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SubCtaTiProInvDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTATIPROINVCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SubCtaTiProInvBean subCtaTiProInv = new SubCtaTiProInvBean();
				subCtaTiProInv.setConceptoInvID(resultSet.getString(1));
				subCtaTiProInv.setTipoProductoID(resultSet.getString(2));
				subCtaTiProInv.setSubCuenta(resultSet.getString(3));
				return subCtaTiProInv;
			}
		});
		return matches.size() > 0 ? (SubCtaTiProInvBean) matches.get(0) : null;
	}

}
