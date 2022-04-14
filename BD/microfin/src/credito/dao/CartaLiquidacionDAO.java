package credito.dao;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Blob;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import javax.sql.rowset.serial.SerialBlob;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import credito.bean.CartaLiquidacionBean;
import credito.bean.CreditosBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class CartaLiquidacionDAO extends BaseDAO {

	public CartaLiquidacionDAO(){
		super();
	}

	public MensajeTransaccionBean alta(final CartaLiquidacionBean instance){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			@SuppressWarnings({"unchecked", "rawtypes"})
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CARTALIQUIDACIONALT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(instance.getCreditoID()));
								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(instance.getClienteID()));
								sentenciaStore.setString("Par_FechaVencimien", instance.getFechaVencimiento());
								sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(instance.getInstitucionID()));
								sentenciaStore.setLong("Par_Convenio", Utileria.convierteLong(instance.getConvenio()));
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
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CartaLiquidacionDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
								return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " CartaLiquidacionDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar el alta" + e);
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

	public MensajeTransaccionBean modifica(final CartaLiquidacionBean instance, final int tipoActualizacion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			@SuppressWarnings({"unchecked", "rawtypes"})
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CARTALIQUIDACIONACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_CartaLiquidaID", Utileria.convierteEntero(instance.getCartaLiquidaID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(instance.getCreditoID()));
								sentenciaStore.setInt("Par_ArchivoIDCarta", Utileria.convierteEntero(instance.getArchivoIdCarta()));
								sentenciaStore.setBytes("Par_CodigoQR", instance.getQrImage() != null ? instance.getQrImage() : Constantes.STRING_VACIO.getBytes());
								sentenciaStore.setInt("Par_TipoAct", tipoActualizacion);

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
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CartaLiquidacionDAO.modifica");
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
						throw new Exception(Constantes.MSG_ERROR + " CartaLiquidacionDAO.modifica");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar la actualización" + e);
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
	 * @param tipoConsulta Tipo de consulta
	 * @return CartaLiquidacionBean Modelo que retorna una vez realizada la operacion
	 */
	public CartaLiquidacionBean consulta(CartaLiquidacionBean cartaLiquidacionBean, int tipoConsulta) {
		CartaLiquidacionBean modelo = null;
		try{
			// Query con el Store Procedure
			String query = "call CARTALIQUIDACIONCON(?,?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(cartaLiquidacionBean.getCreditoID()),
				Utileria.convierteEntero(cartaLiquidacionBean.getClienteID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CartaLiquidacionDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARTALIQUIDACIONCON( " + Arrays.toString(parametros) + ")");
			@SuppressWarnings({ "unchecked", "rawtypes" })
			List<CartaLiquidacionBean> matches= ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					CartaLiquidacionBean cartaLiquidacionBean = new CartaLiquidacionBean();
					try {
						cartaLiquidacionBean.setClienteID(resultSet.getString("ClienteID"));
						cartaLiquidacionBean.setCartaLiquidaID(resultSet.getString("CartaLiquidaID"));
						cartaLiquidacionBean.setCliente(resultSet.getString("NombreCompleto"));
						cartaLiquidacionBean.setMontoOriginal(resultSet.getString("MontoOriginal"));
						cartaLiquidacionBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
						cartaLiquidacionBean.setInstitucionID(resultSet.getString("InstitucionID"));
						cartaLiquidacionBean.setInstitucion(resultSet.getString("Nombre"));
						cartaLiquidacionBean.setConvenio(resultSet.getString("Convenio"));
					} catch(Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return cartaLiquidacionBean;
				}
			});
			modelo =  matches.size() > 0 ? (CartaLiquidacionBean) matches.get(0) : null;
		}catch(Exception e ){
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consultaPrincipal", e);
		}
		return modelo;
	}

	/**
	 * Método para la consulta del Monto proyectado
	 * @param instance Modelo requerido
	 * @param tipoConsulta Tipo de consulta
	 * @return CartaLiquidacionBean Modelo que retorna una vez realizada la operacion
	 **/
	public CartaLiquidacionBean consultaMontoPoyectado(CartaLiquidacionBean cartaLiquidacionBean, int tipoConsulta) {
		CartaLiquidacionBean modelo = null;
		try {
			String query = "call CARTALIQUIDACIONCON(?,?,?,?,?,?,?, ?,?,?);";
			Object[] parametros = {
				Utileria.convierteLong(cartaLiquidacionBean.getCreditoID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CartaLiquidacionDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARTALIQUIDACIONCON( " + Arrays.toString(parametros) + ")");
			@SuppressWarnings({ "unchecked", "rawtypes" })
			List<CartaLiquidacionBean> matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					CartaLiquidacionBean cartaLiquidacionBean = new CartaLiquidacionBean();
					try {
						cartaLiquidacionBean.setCreditoID(resultSet.getString("CreditoID"));
						cartaLiquidacionBean.setFechaGeneracion(resultSet.getString("FechaRegistro"));
						cartaLiquidacionBean.setMontoProyectado(resultSet.getString("MontoLiquidar"));
						cartaLiquidacionBean.setUsuarioGenara(resultSet.getString("Clave"));
					} catch(Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return cartaLiquidacionBean;
				}
			});
			modelo = matches.size() > 0 ? (CartaLiquidacionBean) matches.get(0) : null;
		} catch (Exception e) {
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consultaMontoPoyectado", e);
		}
		return modelo;
	}

	/**
	 * Método para la consulta del recurso (path) donde almacena el archivo PDF
	 * @param tipoConsulta - Determina la consulta que se realizará
	 * @return CartaLiquidaconBean Modelo que retorna una vez realizada la operación
	 **/
	public CartaLiquidacionBean consultaRecurso(CartaLiquidacionBean cartaLiquidacionBean, int tipoConsulta) {
		CartaLiquidacionBean modelo = null;
		try {
			// Query con el stored procedure
			String query = "call CARTALIQUIDACIONCON(?,?,?,?,?,?, ?,?,?,?)";
			Object[] parametros = {
				Utileria.convierteLong(cartaLiquidacionBean.getCreditoID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CartaLiquidacionDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CARTALIQUIDACIONCON( " + Arrays.toString(parametros) + ")");
			@SuppressWarnings({ "unchecked", "rawtypes" })
			List<CartaLiquidacionBean> matches= ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					CartaLiquidacionBean cartaLiquidacionBean = new CartaLiquidacionBean();
					try {
						cartaLiquidacionBean.setCreditoID(resultSet.getString("CreditoID"));
						cartaLiquidacionBean.setFechaGeneracion(resultSet.getString("FechaVencimiento"));
						cartaLiquidacionBean.setComentario(resultSet.getString("Comentario"));
						cartaLiquidacionBean.setRecurso(resultSet.getString("Recurso"));
						cartaLiquidacionBean.setArchivoIdCarta(resultSet.getString("DigCreaID"));
					} catch(Exception ex) {
						ex.printStackTrace();
						return null;
					}

					return cartaLiquidacionBean;
				}
			});
			modelo =  matches.size() > 0 ? (CartaLiquidacionBean) matches.get(0) : null;
		} catch (Exception e) {
			// TODO: handle exception
			e.getMessage();
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consultaRecurso", e);
		}

		return modelo;
	}

	/**
	 * Método para actualizar y guardar el QR en la tabla cartaliquidaciondet
	 * tipoAct - Determina la actualización a realizarse
	 * @return MensajeTransaccionBean Modelo que retorna una cez realizada la operación
	 **/
	public MensajeTransaccionBean guardaQR(final CartaLiquidacionBean instance, final int tipoAct) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call CARTALIQUIDACIONACT(?,?,?,?,?,  ?,?,?,?,?,  ?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CartaLiquidaID", Utileria.convierteLong(instance.getCartaLiquidaID()));
								sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(instance.getCreditoID()));
								sentenciaStore.setInt("Par_ArchivoIDCarta", Utileria.convierteEntero(instance.getArchivoIdCarta()));
								sentenciaStore.setBytes("Par_CodigoQR", instance.getQrImage());
								sentenciaStore.setInt("Par_TipoAct", tipoAct);

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
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
							}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " CartaLiquidacionDAO.guardaQR");
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
						throw new Exception(Constantes.MSG_ERROR + " CartaLiquidacionDAO.guardaQR");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Realizar la actualización" + e);
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
}
