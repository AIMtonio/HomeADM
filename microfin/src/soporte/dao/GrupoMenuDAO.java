package soporte.dao;
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
 
import soporte.bean.GrupoMenuBean;
import soporte.bean.PlazasBean;


public class GrupoMenuDAO extends BaseDAO{
	
	public GrupoMenuDAO() {
		super();
	}
	
	// ------------------ Transacciones --------------------------------------
	/* Alta de Grupo Menu */

	public MensajeTransaccionBean alta(final GrupoMenuBean grupoMenu) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call GRUPOSMENUALT(?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							grupoMenu.getMenu(),
							grupoMenu.getDescripcion(),
							grupoMenu.getDesplegado(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"GrupoMenuDAO.alta",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSMENUALT(" + Arrays.toString(parametros) +")");
			
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
				}catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de grupo  menu", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}
	
	

	
	
	/* Modificacion de Grupo Menu */
	public MensajeTransaccionBean modifica(final GrupoMenuBean grupoMenu){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		transaccionDAO.generaNumeroTransaccion();
		
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					
					String query = "call GRUPOSMENUMOD(?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(grupoMenu.getNumero()),
							grupoMenu.getMenu(),
							grupoMenu.getDescripcion(),
							grupoMenu.getDesplegado(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"GrupoMenuDAO.modifica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSMENUMOD(" + Arrays.toString(parametros) +")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modifica grupo menu", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	/* Consuta Grupo menu por Llave Principal*/
	public GrupoMenuBean  consultaPrincipal(GrupoMenuBean grupoMenu, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call GRUPOSMENUCON(?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	Utileria.convierteEntero(grupoMenu.getNumero()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GrupoMenuDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSMENUCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				     GrupoMenuBean grupoMenu = new GrupoMenuBean();
				     grupoMenu.setNumero(String.valueOf(resultSet.getInt(1)));
				     grupoMenu.setMenu(String.valueOf(resultSet.getInt(2)));
				     grupoMenu.setDescripcion(resultSet.getString(3));
				     grupoMenu.setDesplegado(resultSet.getString(4));
				     grupoMenu.setOrden(resultSet.getInt(5));
				     
					
					return grupoMenu;
	
			}
		});
				
		return matches.size() > 0 ? (GrupoMenuBean) matches.get(0) : null;
	}
	
	
	/* Consuta Opcion menu por Llave Foranea*/
	public GrupoMenuBean consultaForanea(GrupoMenuBean grupoMenu, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call GRUPOSMENUCON(?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	Utileria.convierteEntero(grupoMenu.getNumero()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GrupoMenuDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSMENUCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				 GrupoMenuBean grupoMenu = new GrupoMenuBean();
			     grupoMenu.setNumero(String.valueOf(resultSet.getInt(1)));
			     grupoMenu.setDesplegado(resultSet.getString(2));
			     
				return grupoMenu;		
	
			}
		});
				
		return matches.size() > 0 ? (GrupoMenuBean) matches.get(0) : null;
	}
	

	/* Lista de  grupos */
	public List listaPrincipal(GrupoMenuBean grupoMenu, int tipoLista) {
		//Query con el Store Procedure
		String query = "call GRUPOSMENULIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
				     			grupoMenu.getDesplegado(),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GrupoMenuDAO.listaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSMENULIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GrupoMenuBean grupoMenu = new GrupoMenuBean();
					grupoMenu.setNumero(String.valueOf(resultSet.getInt(1)));
					grupoMenu.setDescripcion(resultSet.getString(3));
			    	grupoMenu.setDesplegado(resultSet.getString(4));
				return grupoMenu;			
			}
		});
				
		return matches;
	}	
	
}
