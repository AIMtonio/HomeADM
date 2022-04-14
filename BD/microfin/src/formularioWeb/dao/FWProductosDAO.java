package formularioWeb.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
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

import com.google.gson.Gson;

import formularioWeb.bean.FwListaProductosCreditoBean;
import formularioWeb.bean.FwProductoCreditoBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

/**
 * Metodo DAO para el acceso a datos de la tabla PRODUCTOSCREDITOFW
 * @author cardinal
 */
public class FWProductosDAO extends BaseDAO {

	/**
	 * Metodo consumo de SP para alta de productos de creditos.
	 * @param fwProductoCreditoBean -> {@link FwProductoCreditoBean}
	 * @return {@link MensajeTransaccionBean}
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public MensajeTransaccionBean altaProductosCreditoFw(final FwProductoCreditoBean fwProductoCreditoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call PRODUCTOSCREDITOFWPRO(?,?,?,?,?,?,?,?,	?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProductoCreditoFWID", Utileria.convierteEntero(fwProductoCreditoBean.getProductoCreditoFWID()));
								sentenciaStore.setInt("Par_ProductoCreditoID", Utileria.convierteEntero(fwProductoCreditoBean.getProductoCreditoID()));
								sentenciaStore.setInt("Par_DestinoCreditoID", Utileria.convierteEntero(fwProductoCreditoBean.getDestinoCreditoID()));
								sentenciaStore.setString("Par_ClasificacionDestino", fwProductoCreditoBean.getClasificacionDestino());
								sentenciaStore.setInt("Par_PerfilID", Utileria.convierteEntero(fwProductoCreditoBean.getPerfilID()));
								/** Parametros de salida transacciones **/
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								/** Parametros de auditoria **/
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						        loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}

						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"),""));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " FWProductosDAO.altaProductosCreditoFw");
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
						throw new Exception(Constantes.MSG_ERROR + " .FWProductosDAO.altaProductosCreditoFw");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){
							loggerSAFI.error(this.getClass()+" - "+"Error en Alta de producto de creditos.: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					loggerSAFI.error(this.getClass()+" - "+"Error en Alta de productos de credito." + e);
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
	 * Metodo que realiza el consumo de SP para dar de alta la tabla de productos de credito.
	 * @param fwProductoCreditoBean -> {@link FwProductoCreditoBean}
	 * @return {@link MensajeTransaccionBean}
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public MensajeTransaccionBean eliminaProductosCreditoFw(final FwProductoCreditoBean fwProductoCreditoBean) {

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call PRODUCTOSCREDITOFWBAJ(?,?,?,?,	?,?,?,	?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ProductoCreditoFWID", Utileria.convierteEntero(fwProductoCreditoBean.getProductoCreditoFWID()));
								sentenciaStore.setString("Par_ProductoCreditoFWIDs", fwProductoCreditoBean.getProductoCreditoFWIDs());
								sentenciaStore.setInt("Par_ProdCreditoID",Utileria.convierteEntero(fwProductoCreditoBean.getProductoCreditoID()));
								sentenciaStore.setInt("Par_NumBaj", 2);

								/** Parametros de salida transacciones **/
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								/** Parametros de auditoria **/
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						        loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();

								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl("productoID");
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .FWProductosDAO.eliminaProductosCreditoFw");
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
						throw new Exception(Constantes.MSG_ERROR + " .FWProductosDAO.eliminaProductosCreditoFw");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en eliminacion de productos de credito" + e.getMessage());

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
	 * Metodo que realiza el consumo de SP para listar los productos de credito.
	 * @param fwListaProductosCreditoBean
	 * @return {@link List}
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List<FwProductoCreditoBean> listaProductoCreditoFw(FwListaProductosCreditoBean fwListaProductosCreditoBean) {

		String query = "call PRODUCTOSCREDITOFWLIS(?,?,?,?,?,?,?,?,?,?);";


		Object[] parametros = {
				fwListaProductosCreditoBean.getDescripcion(),
				Utileria.convierteEntero(fwListaProductosCreditoBean.getPerfilID()),
				Utileria.convierteEntero(fwListaProductosCreditoBean.getNumLis()),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO};

		loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PRODUCTOSCREDITOFWLIS(" + Arrays.toString(parametros) + ")");

		List matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FwProductoCreditoBean fwProductoCreditoBean = new FwProductoCreditoBean();

				fwProductoCreditoBean.setProductoCreditoFWID(resultSet.getString("ProductoCreditoFWID"));
				fwProductoCreditoBean.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
				fwProductoCreditoBean.setDesCredito(resultSet.getString("DesCredito"));
				fwProductoCreditoBean.setDestinoCreditoID(resultSet.getString("DestinoCreID"));
				fwProductoCreditoBean.setDesDestino(resultSet.getString("DesDestino"));
				fwProductoCreditoBean.setClasificacionDestino(resultSet.getString("ClasifChar"));
				fwProductoCreditoBean.setDesClasificacionDestino(resultSet.getString("Clasificacion"));

				return fwProductoCreditoBean;
			}
		});

		return matches;
	}

}
