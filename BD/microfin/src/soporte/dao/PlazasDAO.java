package soporte.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.SistemaLogging;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import soporte.bean.PlazasBean;
import soporte.bean.UsuarioBean;



public class PlazasDAO extends BaseDAO{

	public PlazasDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------


	/* Alta de Plaza */

	public MensajeTransaccionBean alta(final PlazasBean plazas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PLAZASALT(?,?,?,?,?, ?,?,?,?,?, ?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Nombre", plazas.getNombre());
								sentenciaStore.setString("Par_PlazaCLABE", plazas.getPlazaCLABE());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de plaza", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
					return mensajeBean;
				}
			});
			return mensaje;
		}




	/* Modificacion de Plaza */
	public MensajeTransaccionBean modifica(final PlazasBean plazas){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PLAZASMOD(?,?,?," +
														  "?,?,?," +
														  "?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setString("Par_PlazaID", plazas.getPlazaID());
							sentenciaStore.setString("Par_Nombre", plazas.getNombre());
							sentenciaStore.setString("Par_PlazaCLABE", plazas.getPlazaCLABE());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
				if(mensajeBean ==  null){
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(999);
					throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
				}else if(mensajeBean.getNumero()!=0){
					throw new Exception(mensajeBean.getDescripcion());
				}
			}catch (Exception e) {

				if (mensajeBean.getNumero() == 0) {
					mensajeBean.setNumero(999);
				}
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la Modificacion de plaza", e);
				mensajeBean.setDescripcion(e.getMessage());
				transaction.setRollbackOnly();
			}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Consuta Plaza por Llave Principal*/
	public PlazasBean consultaPrincipal(PlazasBean plazas, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PLAZASCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {	plazas.getPlazaID(),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"PlazasDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZASCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PlazasBean plazas = new PlazasBean();
					plazas.setPlazaID(String.valueOf(resultSet.getInt(1)));
					plazas.setNombre(resultSet.getString(2));
					plazas.setPlazaCLABE(String.valueOf(resultSet.getInt(3)));

					return plazas;

			}
		});

		return matches.size() > 0 ? (PlazasBean) matches.get(0) : null;
	}


	/* Consuta Notaria por Llave Foranea*/
	public PlazasBean consultaForanea(PlazasBean plazas, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call PLAZASCON(?,?,?,?,?,?,?,?,?);";

		Object[] parametros = {		plazas.getPlazaID(),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"PlazasDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZASCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PlazasBean plazas = new PlazasBean();
					plazas.setPlazaID(String.valueOf(resultSet.getInt(1)));
					plazas.setNombre(resultSet.getString(2));
					return plazas;

			}
		});

		return matches.size() > 0 ? (PlazasBean) matches.get(0) : null;
	}


	/* Lista de Notarias por Titular */
	public List listaPrincipal(PlazasBean plazas, int tipoLista) {
		//Query con el Store Procedure
		String query = "call PLAZASLIS(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
								plazas.getNombre(),
								tipoLista,
								parametrosAuditoriaBean.getEmpresaID(),
								parametrosAuditoriaBean.getUsuario(),
								parametrosAuditoriaBean.getFecha(),
								parametrosAuditoriaBean.getDireccionIP(),
								"PlazasDAO.listaPrincipal",
								parametrosAuditoriaBean.getSucursal(),
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZASLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PlazasBean plazas = new PlazasBean();
				plazas.setPlazaID(String.valueOf(resultSet.getInt(1)));
				plazas.setNombre(resultSet.getString(2));
				return plazas;
			}
		});

		return matches;
	}

	public List listaPlazas(PlazasBean plazas, int tipoLista){
		List segtoPlazas = null ;
		try{
			String query = "call PLAZASLIS(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Constantes.STRING_VACIO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"SeguimientoDAO.consultaSegtoProducto",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PLAZASLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					PlazasBean plazas = new PlazasBean();
					plazas.setPlazaID(String.valueOf(resultSet.getInt(1)));
					plazas.setNombre(resultSet.getString(2));
					return plazas;
				}
			});
			segtoPlazas =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de lista por plazas", e);
		}
		return segtoPlazas;
	}

}
