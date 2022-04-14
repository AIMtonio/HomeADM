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

import originacion.bean.DestinosCredProdBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class DestinosCredProdDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	public DestinosCredProdDAO() {
		super();
	}

	/* Alta del Cliente */
	public MensajeTransaccionBean altaDestinoCreditoPorProducto(final DestinosCredProdBean destinosCredProdBean, final Long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call DESTINOSCREDPRODALT(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?);";//parametros de auditoria
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(destinosCredProdBean.getProductoCreditoID()));
								sentenciaStore.setInt("Par_DestinoCreID",Utileria.convierteEntero(destinosCredProdBean.getDestinoCreID()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
						        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DestinosCredProdDAO.altaDestinoCreditoPorProducto");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .DestinosCredProdDAO.altaDestinoCreditoPorProducto");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Destinos por producto: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Destinos por producto " + e);
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

	/* Alta del Cliente */
	public MensajeTransaccionBean bajaDestinoCreditoPorProducto(final DestinosCredProdBean destinosCredProdBean, final Long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call DESTINOSCREDPRODBAJ(" +
									"?,?,?,?,?, ?,?,?,?,?," +
									"?,?);";//parametros de auditoria
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_ProductoCreditoID",Utileria.convierteEntero(destinosCredProdBean.getProductoCreditoID()));
								sentenciaStore.setInt("Par_DestinoCreID",Utileria.convierteEntero(destinosCredProdBean.getDestinoCreID()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);
						        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
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
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DestinosCredProdDAO.bajaDestinoCreditoPorProducto");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .DestinosCredProdDAO.bajaDestinoCreditoPorProducto");
					}else if(mensajeBean.getNumero()!=0){
						if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Destinos por producto: " + mensajeBean.getDescripcion());
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				}catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Baja de Destinos por producto " + e);
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

	/* Lista de Destinos por producto de credito */
	public List listaDestinosPorProducto(DestinosCredProdBean destinosCredProdBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call DESTINOSCREDPRODLIS("
				+ "?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				destinosCredProdBean.getProductoCreditoID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),

				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DESTINOSCREDPRODLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				DestinosCredProdBean destinosCredProd = new DestinosCredProdBean();
				destinosCredProd.setDestinoCreID(resultSet.getString("DestinoCreID"));
				destinosCredProd.setDescripcion(resultSet.getString("Descripcion"));
				destinosCredProd.setSubClasifID(resultSet.getString("SubClasifID"));
				destinosCredProd.setDescripClasifica(resultSet.getString("DescripClasifica"));
				destinosCredProd.setProductoCreditoID(resultSet.getString("ProductoCreditoID"));
				destinosCredProd.setClasificacion(resultSet.getString("Clasificacion"));
				return destinosCredProd;
			}
		});
		return matches;
	}


	public MensajeTransaccionBean grabaDestinosPorProducto(final DestinosCredProdBean destinosCredProdBean,final ArrayList listaDestinosPorProducto ){
		MensajeTransaccionBean resultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		resultado = (MensajeTransaccionBean)transactionTemplate.execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean resultadoBean = new MensajeTransaccionBean();
				DestinosCredProdBean destinosCredProdLista =null;
				try{
					// SE VERIFICA QUE LA LISTA NO VENGA VACIA
					if(listaDestinosPorProducto != null){
						resultadoBean = bajaDestinoCreditoPorProducto(destinosCredProdBean, parametrosAuditoriaBean.getNumeroTransaccion());
						if(resultadoBean.getNumero()!=0){
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else{
							resultadoBean.setNumero(0);
							resultadoBean.setDescripcion("Destinos de Crédito Actualizados Exitosamente");
							resultadoBean.setNombreControl("productoCreditoID");
							resultadoBean.setConsecutivoString(destinosCredProdBean.getProductoCreditoID());
						}
						for(int i=0; i < listaDestinosPorProducto.size(); i++){
							destinosCredProdLista = (DestinosCredProdBean) listaDestinosPorProducto.get(i);
							if(destinosCredProdLista.getDestinoCreID().equals(Constantes.STRING_CERO)){
								resultadoBean.setNumero(0);
								resultadoBean.setDescripcion("Destinos de Crédito Actualizados Exitosamente");
								resultadoBean.setNombreControl("productoCreditoID");
								resultadoBean.setConsecutivoString(destinosCredProdBean.getProductoCreditoID());
							}else{
								destinosCredProdLista.setProductoCreditoID(destinosCredProdBean.getProductoCreditoID());
								resultadoBean = altaDestinoCreditoPorProducto(destinosCredProdLista, parametrosAuditoriaBean.getNumeroTransaccion());
								if(resultadoBean.getNumero()!=0){
									throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
							}
						}
					}else{
						resultadoBean.setNumero(0);
						resultadoBean.setDescripcion("Destinos de Crédito Actualizados Exitosamente");
						resultadoBean.setNombreControl("productoCreditoID");
						resultadoBean.setConsecutivoString(destinosCredProdBean.getProductoCreditoID());
					}
				}catch(Exception e){
					if (resultadoBean.getNumero() == 0) {
						resultadoBean.setNumero(999);
						resultadoBean.setDescripcion(e.getMessage());
						resultadoBean.setNombreControl(resultadoBean.getNombreControl());
						resultadoBean.setConsecutivoString(Constantes.STRING_CERO);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de destinos por producto", e);
					transaction.setRollbackOnly();
				}
				return resultadoBean;
			}
		});
		return resultado;
	}


	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


}
