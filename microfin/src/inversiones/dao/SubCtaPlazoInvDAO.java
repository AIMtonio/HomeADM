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

import inversiones.bean.SubCtaPlazoInvBean;

public class SubCtaPlazoInvDAO  extends BaseDAO {
	
	public SubCtaPlazoInvDAO() {
		super();
	}

	public MensajeTransaccionBean modifica(final SubCtaPlazoInvBean subCtaPlazoInv){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SUBCTAPLAZOINVMOD(?,?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							subCtaPlazoInv.getConceptoInvID(),
							subCtaPlazoInv.getSubCtaPlazoInvID(),
							subCtaPlazoInv.getSubCuenta(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SubCtaPlazoInvDAO.modifica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()	
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTAPLAZOINVMOD(" + Arrays.toString(parametros) + ")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de subcuenta de plazo de inversion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public MensajeTransaccionBean baja(final SubCtaPlazoInvBean subCtaPlazoInv){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call SUBCTAPLAZOINVBAJ(?,? ,?,?,?,?,?,?,?);";
					Object[] parametros = {
							subCtaPlazoInv.getConceptoInvID(),
							subCtaPlazoInv.getSubCtaPlazoInvID(),
							
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"SubCtaPlazoInvDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()	
							};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTAPLAZOINVBAJ(" + Arrays.toString(parametros) + ")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de subcuenta de plazo de inversion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	public SubCtaPlazoInvBean consultaPrincipal(SubCtaPlazoInvBean subCtaPlazoInv, int tipoConsulta){
		String query = "call SUBCTAPLAZOINVCON(?,?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { 
				subCtaPlazoInv.getConceptoInvID(),
				subCtaPlazoInv.getSubCtaPlazoInvID(),
				tipoConsulta,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SubCtaPlazoInvDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTAPLAZOINVCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SubCtaPlazoInvBean subCtaPlazoInv = new SubCtaPlazoInvBean();
				subCtaPlazoInv.setConceptoInvID(resultSet.getString(1));
				subCtaPlazoInv.setSubCtaPlazoInvID(resultSet.getString(2));
				subCtaPlazoInv.setPlazoInferior(resultSet.getString(3));
				subCtaPlazoInv.setPlazoSuperior(resultSet.getString(4));
				subCtaPlazoInv.setSubCuenta(resultSet.getString(5));
				return subCtaPlazoInv;
			}
		});
		return matches.size() > 0 ? (SubCtaPlazoInvBean) matches.get(0) : null;
	}
	
	//Lista de Plazos de Inversion para la Subcuenta
	public List listaPlazos(SubCtaPlazoInvBean subCtaPlazoInv,int tipoLista) {
		//Query con el Store Procedure
		String query = "call SUBCTAPLAZOINVLIS(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {	
				subCtaPlazoInv.getConceptoInvID(),
				tipoLista,
				
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SubCtaPlazoInvDAO.listaPlazos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};	
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SUBCTAPLAZOINVLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SubCtaPlazoInvBean subCtaPlazoInv = new SubCtaPlazoInvBean();			
				subCtaPlazoInv.setSubCtaPlazoInvID(resultSet.getString(1));
				subCtaPlazoInv.setPlazoInferior(resultSet.getString(2));//Plazos				
				return subCtaPlazoInv;				
			}
		});
				
		return matches;
	}

}

