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

import soporte.bean.OpcionMenuBean;

public class OpcionMenuDAO extends BaseDAO{
	
	public OpcionMenuDAO() {
		super();
	}
	
	// ------------------ Transacciones ------------------------------------------


	/* Alta de Opcion del menu */

	public MensajeTransaccionBean alta(final OpcionMenuBean opcionMenu) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
				
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							String query = "call OPCIONESMENUALT(?,?,?,?,?,?,?,?,?,?,?);";
							Object[] parametros = {
									
									Utileria.convierteEntero(opcionMenu.getGrupoMenu()),
									opcionMenu.getDescripcion(),
									opcionMenu.getDesplegado(),
									opcionMenu.getRecurso(),
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"OpcionMenuDAO.alta",
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()};
									
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESMENUALT(" + Arrays.toString(parametros) +")");
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
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de opcion menu", e);
						}
						return mensajeBean;
					}
				});
				return mensaje;
			}
	
	
	/* Modificacion de Opcion del menu  */
	public MensajeTransaccionBean modifica(final OpcionMenuBean opcionMenu){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		transaccionDAO.generaNumeroTransaccion();
		
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					
					String query = "call OPCIONESMENUMOD(?,?,?,?,?,?,?,?,?,?,?,?);";
					Object[] parametros = {
							Utileria.convierteEntero(opcionMenu.getNumero()),
							Utileria.convierteEntero(opcionMenu.getGrupoMenu()),
							opcionMenu.getDescripcion(),
							opcionMenu.getDesplegado(),
							opcionMenu.getRecurso(),
							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"OpcionMenuDAO.modifica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESMENUMOD(" + Arrays.toString(parametros) +")");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modifica opcion menu", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	
	/* Consuta Opcion menu por Llave Principal*/
	public OpcionMenuBean  consultaPrincipal(OpcionMenuBean opcionMenu, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call OPCIONESMENUCON(?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	Utileria.convierteEntero(opcionMenu.getNumero()),
								Constantes.STRING_VACIO, //De la clave de usuario
								Constantes.ENTERO_CERO,	//Del rol de usuario
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"OpcionMenuDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESMENUCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					OpcionMenuBean opcionMenu = new OpcionMenuBean();
					opcionMenu.setNumero(String.valueOf(resultSet.getInt(1)));
					opcionMenu.setGrupoMenu(String.valueOf(resultSet.getInt(2)));
					opcionMenu.setDescripcion(resultSet.getString(3));
					opcionMenu.setDesplegado(resultSet.getString(4));
					opcionMenu.setRecurso(resultSet.getString(5));
					opcionMenu.setOrden(resultSet.getInt(6));
					
					return opcionMenu;
	
			}
		});
				
		return matches.size() > 0 ? (OpcionMenuBean) matches.get(0) : null;
	}
	
	
	/* Consuta Opcion menu por Llave Foranea*/
	public OpcionMenuBean consultaForanea(OpcionMenuBean opcionMenu, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call OPCIONESMENUCON(?,?,?,?,?,?,?,?,?,?);";
		
		Object[] parametros = {	Utileria.convierteEntero(opcionMenu.getNumero()),
								Utileria.convierteEntero(opcionMenu.getGrupoMenu()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"OpcionMenuDAO.consultaForanea",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESMENUCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpcionMenuBean opcionMenu = new OpcionMenuBean();
				opcionMenu.setNumero(String.valueOf(resultSet.getInt(1)));
				opcionMenu.setGrupoMenu(String.valueOf(resultSet.getInt(2)));
				opcionMenu.setDesplegado(resultSet.getString(4));
				return opcionMenu;		
	
			}
		});
				
		return matches.size() > 0 ? (OpcionMenuBean) matches.get(0) : null;
	}
	

	/* Lista de  por Titular */
	public List listaPrincipal(OpcionMenuBean opcionMenu, int tipoLista) {
		//Query con el Store Procedure
		String query = "call OPCIONESMENUCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {	
								Utileria.convierteEntero(opcionMenu.getNumero()),
								Utileria.convierteEntero(opcionMenu.getGrupoMenu()),
								tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"OpcionMenuDAO.listaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call OPCIONESMENUCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				OpcionMenuBean opcionMenu = new OpcionMenuBean();
				opcionMenu.setNumero(String.valueOf(resultSet.getInt(1)));
				opcionMenu.setGrupoMenu(String.valueOf(resultSet.getInt(2)));
				opcionMenu.setDesplegado(resultSet.getString(4));
				return opcionMenu;			
			}
		});
				
		return matches;
	}	
	
}
