package originacion.dao;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;
import originacion.bean.ServiciosAdicionalesBean;

public class ServiciosAdicionalesDAO extends BaseDAO{

	private static final String SP_SERVICIOSADICIONALESLIS = "SERVICIOSADICIONALESLIS";

	public ServiciosAdicionalesDAO(){
		super();
	}

	public MensajeTransaccionBean alta(final ServiciosAdicionalesBean instance){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SERVICIOSADICIONALESALT(?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_Descripcion", instance.getDescripcion());
								sentenciaStore.setString("Par_ValidaDocs",instance.getValidaDocs());
								sentenciaStore.setInt("Par_TipoDocumento", Utileria.convierteEntero(instance.getTipoDocumento()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar el alta del servicio" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificar(final ServiciosAdicionalesBean instance){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SERVICIOSADICIONALESMOD(?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ServicioID", Utileria.convierteEntero(instance.getServicioID()));
								sentenciaStore.setString("Par_Descripcion", instance.getDescripcion());
								sentenciaStore.setString("Par_ValidaDocs",instance.getValidaDocs());
								sentenciaStore.setInt("Par_TipoDocumento", Utileria.convierteEntero(instance.getTipoDocumento()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.modificar");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.modificar");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar la modificacion del servicio" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean baja(final ServiciosAdicionalesBean instance){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SERVICIOSADICIONALESBAJ(?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ServicioID", Utileria.convierteEntero(instance.getServicioID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.baja");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.baja");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar la baja del servicio" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Metodo para realizar las diferentes consultas
	 * @param instance Modelo requerido
	 * @param tipoConsulta Tipo de Transaccion
	 * @return ServiciosAdicionalesBean Modelo que retorna una vez realizada la operacion
	 */
	public ServiciosAdicionalesBean consultaPrincipal(ServiciosAdicionalesBean instance, int tipoConsulta) {
		ServiciosAdicionalesBean modelo = null;
		try{
			// Query con el Store Procedure
			String query = "call SERVICIOSADICIONALESCON(" +
					"?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(instance.getServicioID()),
					Constantes.STRING_VACIO,
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ServiciosAdicionalesDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVICIOSADICIONALESCON( " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					ServiciosAdicionalesBean serviciosAdicionalesBean = new ServiciosAdicionalesBean();
					serviciosAdicionalesBean.setServicioID(resultSet.getString("ServicioID"));
					serviciosAdicionalesBean.setDescripcion(resultSet.getString("Descripcion"));
					serviciosAdicionalesBean.setTipoDocumento(resultSet.getString("TipoDocumento"));
					serviciosAdicionalesBean.setValidaDocs(resultSet.getString("ValidaDocs"));
					serviciosAdicionalesBean.setListaEmpresas(resultSet.getString("EmpresasID"));
					serviciosAdicionalesBean.setListaProductosCredito(resultSet.getString("ProductosID"));
					return serviciosAdicionalesBean;
				}
			});
			modelo =  matches.size() > 0 ? (ServiciosAdicionalesBean) matches.get(0) : null;
		}catch(Exception e ){
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consultaPrincipal", e);
		}
		return modelo;
	}

	public ServiciosAdicionalesBean consultaValidaInstitNomina(ServiciosAdicionalesBean instance, int tipoConsulta) {
		ServiciosAdicionalesBean modelo = null;
		try{
			// Query con el Store Procedure
			String query = "call SERVICIOSADICIONALESCON(" +
					"?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(instance.getServicioID()),
					instance.getDescripcion(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ServiciosAdicionalesDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVICIOSADICIONALESCON( " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					ServiciosAdicionalesBean serviciosAdicionalesBean = new ServiciosAdicionalesBean();
					serviciosAdicionalesBean.setDescripcion(resultSet.getString("ValidoNomina"));
					return serviciosAdicionalesBean;
				}
			});
			modelo =  matches.size() > 0 ? (ServiciosAdicionalesBean) matches.get(0) : null;
		}catch(Exception e ){
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consultaPrincipal", e);
		}
		return modelo;
	}

	/**
	 * Metodo para consultar las diferentes listas
	 * @param instance Modelo requerido
	 * @param tipoLista Tipo de Transaccion
	 * @return List Retorna una lista de resultado
	 */
	public List listaPrincipal(ServiciosAdicionalesBean instance, int tipoLista) {
		List lista = null;
		try{
			String query = "call SERVICIOSADICIONALESLIS(?,?,?,?,?, ?,?,?,?,?, ?,? );";
			Object[] parametros = {
					Utileria.convierteEntero(instance.getServicioID()),
					instance.getDescripcion(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"ServiciosAdicionalesDAO.listaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVICIOSADICIONALESLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ServiciosAdicionalesBean modeloResult = new ServiciosAdicionalesBean();
					modeloResult.setServicioID(resultSet.getString("ServicioID"));
					modeloResult.setDescripcion(resultSet.getString("Descripcion"));
					return modeloResult;
				}
			});
			lista = matches;
		}catch(Exception e){
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en listaPrincipal", e);
		}
		return lista;
	}

	public List listaInstitNomina(ServiciosAdicionalesBean instance, int tipoLista) {
		List lista = null;
		try{
			String query = "call SERVICIOSADICIONALESLIS(?,?,?,?,?, ?,?,?,?,?, ?,? );";
			Object[] parametros = {
					Utileria.convierteEntero(instance.getServicioID()),
					instance.getDescripcion(),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"ServiciosAdicionalesDAO.listaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVICIOSADICIONALESLIS(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ServiciosAdicionalesBean modeloResult = new ServiciosAdicionalesBean();
					modeloResult.setServicioID(resultSet.getString("InstitNominaID"));
					modeloResult.setDescripcion(resultSet.getString("NombreInstit"));
					return modeloResult;
				}
			});
			lista = matches;
		}catch(Exception e){
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en listaInstitNomina", e);
		}
		return lista;
	}

	public MensajeTransaccionBean altaServicioProductoCredito(final ServiciosAdicionalesBean instance){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SERVICIOSXPRODUCTOALT(?,?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ServicioID", Utileria.convierteEntero(instance.getServicioID()));
								sentenciaStore.setInt("Par_ProductoCredID", Utileria.convierteEntero(instance.getProductoCreditoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.altaServicioProductoCredito");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.altaServicioProductoCredito");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar el alta del servicio de producto de crédito" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean altaServicioEmpresa(final ServiciosAdicionalesBean instance){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SERVICIOSXEMPRESAALT(?,?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ServicioID", Utileria.convierteEntero(instance.getServicioID()));
								sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(instance.getInstitucionNominaID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.altaServicioEmpresa");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.altaServicioEmpresa");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar el alta del servicio de la institución de nómina" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean bajaServicioProducto(final ServiciosAdicionalesBean instance){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SERVICIOSXPRODUCTOBAJ(?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ServicioID", Utileria.convierteEntero(instance.getServicioID()));

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.baja");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.bajaServicioProducto");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar el baja del servicio del producto de crédito" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean bajaServicioEmpresa(final ServiciosAdicionalesBean instance){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call SERVICIOSXEMPRESABAJ(?, ?,?,?, ?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ServicioID", Utileria.convierteEntero(instance.getServicioID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.bajaServicioEmpresa");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						}
					);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ServiciosAdicionalesDAO.bajaServicioEmpresa");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar el baja del servicio de la institución de nómina" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean altaServiciosAdicionales(final ServiciosAdicionalesBean serviciosAdicionalesBean) {

		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeTransaccionBean = null;
				try {
					mensajeTransaccionBean = alta(serviciosAdicionalesBean);
					String consecutivo = mensajeTransaccionBean.getConsecutivoString();

					if (mensajeTransaccionBean.getNumero() == 0) {
						ServiciosAdicionalesBean newServiciosAdicionalesBean = new ServiciosAdicionalesBean();
						MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
						//Asignamos el numero del servicioID
						newServiciosAdicionalesBean.setServicioID(consecutivo);

						//Damos de baja los servicios x empresa por el servicioID
						mensaje = bajaServicioEmpresa(newServiciosAdicionalesBean);
						if (mensaje.getNumero() != 0) {
							throw new Exception(mensaje.getDescripcion());
						}

						//Damos de baja los servicios x productos por el servicioID
						mensaje = bajaServicioProducto(newServiciosAdicionalesBean);
						if (mensaje.getNumero() != 0) {
							throw new Exception(mensaje.getDescripcion());
						}

						//Damos de alta los servicios x productos ligados al servicioID
						for (int productoCreditoID : serviciosAdicionalesBean.getProducCreditoID()) {
							newServiciosAdicionalesBean = new ServiciosAdicionalesBean();
							newServiciosAdicionalesBean.setServicioID(consecutivo);
							newServiciosAdicionalesBean.setProductoCreditoID(String.valueOf(productoCreditoID));
							mensaje = altaServicioProductoCredito(newServiciosAdicionalesBean);
							if (mensaje.getNumero() != 0) {
								throw new Exception(mensaje.getDescripcion());
							}
						}

						//Damos de alta los servicios x empresas ligados al servicioID
						for (int  institNominaID: serviciosAdicionalesBean.getInstitNominaID()) {
							newServiciosAdicionalesBean = new ServiciosAdicionalesBean();
							newServiciosAdicionalesBean.setServicioID(consecutivo);
							newServiciosAdicionalesBean.setInstitucionNominaID(String.valueOf(institNominaID));
							mensaje = altaServicioEmpresa(newServiciosAdicionalesBean);
							if (mensaje.getNumero() != 0) {
								throw new Exception(mensaje.getDescripcion());
							}
						}
					}else {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al guardar los servicios adicionales" + e);
					e.printStackTrace();
					if (mensajeTransaccionBean == null) {
						mensajeTransaccionBean = new MensajeTransaccionBean();
					}
					mensajeTransaccionBean.setNumero(999);
					mensajeTransaccionBean.setDescripcion(e.getMessage());
					mensajeTransaccionBean.setConsecutivoString("0");
					transaction.setRollbackOnly();
				}
				return mensajeTransaccionBean;
			}
		});

		return mensaje;
	}


	public MensajeTransaccionBean modificaServiciosAdicionales(final ServiciosAdicionalesBean serviciosAdicionalesBean) {

		transaccionDAO.generaNumeroTransaccion();
		MensajeTransaccionBean mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeTransaccionBean = null;
				try {

					mensajeTransaccionBean = modificar(serviciosAdicionalesBean);
					String servicioID = serviciosAdicionalesBean.getServicioID();
					if (mensajeTransaccionBean.getNumero() == 0) {
						ServiciosAdicionalesBean newServiciosAdicionalesBean = new ServiciosAdicionalesBean();
						newServiciosAdicionalesBean.setServicioID(servicioID);
						MensajeTransaccionBean mensaje = new MensajeTransaccionBean();


						//Damos de baja los servicios x empresa por el servicioID
						mensaje = bajaServicioEmpresa(newServiciosAdicionalesBean);
						if (mensaje.getNumero() != 0) {
							throw new Exception(mensaje.getDescripcion());
						}

						//Damos de baja los servicios x productos por el servicioID
						mensaje = bajaServicioProducto(newServiciosAdicionalesBean);
						if (mensaje.getNumero() != 0) {
							throw new Exception(mensaje.getDescripcion());
						}

						//Damos de alta los servicios x productos ligados al servicioID
						for (int productoCreditoID : serviciosAdicionalesBean.getProducCreditoID()) {
							newServiciosAdicionalesBean = new ServiciosAdicionalesBean();
							newServiciosAdicionalesBean.setServicioID(servicioID);
							newServiciosAdicionalesBean.setProductoCreditoID(String.valueOf(productoCreditoID));
							mensaje = altaServicioProductoCredito(newServiciosAdicionalesBean);
							if (mensaje.getNumero() != 0) {
								throw new Exception(mensaje.getDescripcion());
							}
						}

						//Damos de alta los servicios x empresas ligados al servicioID
						for (int  institNominaID: serviciosAdicionalesBean.getInstitNominaID()) {
							newServiciosAdicionalesBean = new ServiciosAdicionalesBean();
							newServiciosAdicionalesBean.setServicioID(servicioID);
							newServiciosAdicionalesBean.setInstitucionNominaID(String.valueOf(institNominaID));
							mensaje = altaServicioEmpresa(newServiciosAdicionalesBean);
							if (mensaje.getNumero() != 0) {
								throw new Exception(mensaje.getDescripcion());
							}
						}
					}else {
						throw new Exception(mensajeTransaccionBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al guardar los servicios adicionales" + e);
					e.printStackTrace();
					if (mensajeTransaccionBean == null) {
						mensajeTransaccionBean = new MensajeTransaccionBean();
					}
					mensajeTransaccionBean.setNumero(999);
					mensajeTransaccionBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}

				return mensajeTransaccionBean;
			}
		});

		return mensaje;
	}

	public List listaComboServiciosAdicionales(int tipoLista) {

		String query = "call SERVICIOSADICIONALESLIS (?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ServiciosAdicionalesDAO.listaServiciosAdicionales",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SERVICIOSADICIONALESLIS (" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ServiciosAdicionalesBean serviciosAdicionalesBean = new ServiciosAdicionalesBean();

				serviciosAdicionalesBean.setServicioID(resultSet.getString("ServicioID"));
				serviciosAdicionalesBean.setDescripcion(resultSet.getString("Descripcion"));

				return serviciosAdicionalesBean;
			}
		});

		return matches;
	}

	@SuppressWarnings("unchecked")
	public List listaServiciosAdicionales(int tipoLista, ServiciosAdicionalesBean serviciosAdicionalesBean) {
		try {
		String query = "call " + SP_SERVICIOSADICIONALESLIS + "(?,?,?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(serviciosAdicionalesBean.getServicioID()),
				Constantes.STRING_VACIO,
				Utileria.convierteEntero(serviciosAdicionalesBean.getProductoCreditoID()),
				Utileria.convierteEntero(serviciosAdicionalesBean.getInstitucionNominaID()),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call " + SP_SERVICIOSADICIONALESLIS + "(" + Arrays.toString(parametros) + ")");
		return ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ServiciosAdicionalesBean serviciosAdicionalesBean = new ServiciosAdicionalesBean();
				serviciosAdicionalesBean.setServicioID(resultSet.getString("ServicioID"));
				serviciosAdicionalesBean.setDescripcion(resultSet.getString("Descripcion"));
				serviciosAdicionalesBean.setInstitucionNominaID(resultSet.getString("InstitNominaID"));
				serviciosAdicionalesBean.setProductoCreditoID(resultSet.getString("ProducCreditoID"));
				return serviciosAdicionalesBean;
			}
		});
		}catch(Exception e) {
			e.printStackTrace();
		}
		return new ArrayList();
	}

}