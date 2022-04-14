package psl.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import org.apache.commons.codec.binary.Base64;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import psl.bean.PSLCobroSLBean;
import psl.bean.PSLParamBrokerBean;
import psl.bean.PSLRespPagoServBean;
import psl.beanrequest.CompraTiempoAireBean;
import psl.beanrequest.PagoServiciosBean;
import psl.beanresponse.CompraTiempoAireBeanResponse;
import psl.beanresponse.PagoServiciosBeanResponse;
import psl.beanresponse.TransaccionBean;
import psl.rest.BaseBeanResponse;
import psl.rest.ConsumidorRest;
import ventanilla.bean.IngresosOperacionesBean;

public class PSLCobroSLDAO extends BaseDAO {
	PSLParamBrokerDAO pslParamBrokerDAO;
	PSLRespPagoServDAO pslRespPagoServDAO;

	public BaseBeanResponse pagoServicioEnLinea(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion) {
		BaseBeanResponse baseBeanResponse = new BaseBeanResponse();
		try {
			int consultaPrincipal = 1;

			//Consultamos la informacion del broker.
			PSLParamBrokerBean pslParamBrokerBean = new PSLParamBrokerBean();
			PSLParamBrokerBean pslParamBrokerBeanResponse = pslParamBrokerDAO.consultaPrincipal(pslParamBrokerBean, consultaPrincipal);
			if(pslParamBrokerBeanResponse == null) {
				throw new Exception("Error al consultar los parametros del Broker.");
			}

			//Si se estan actualizando los productos cancelamos la operacion.
			if(pslParamBrokerBeanResponse.getActualizandoProductos().equals(Constantes.salidaSI)) {
				throw new Exception("Actualización de productos en proceso.");
			}

			//Realizamos la compra de tiempo aire o pago de servicio desde el Broker de Servicios
			if(ingresosOperacionesBean.getClasificacionServPSL().equals("RE")) {
				baseBeanResponse = consumeWSCompraTiempoAireBroker(ingresosOperacionesBean, pslParamBrokerBeanResponse, numeroTransaccion);
			}
			else {
				baseBeanResponse = consumeWSPagoServiciosBroker(ingresosOperacionesBean, pslParamBrokerBeanResponse, numeroTransaccion);
			}
		}
		catch (Exception e) {
			loggerSAFI.error("Error al realizar el Pago de Servicio en Linea.");
			e.printStackTrace();

			baseBeanResponse.setCodigoRespuesta("999");
			baseBeanResponse.setMensajeRespuesta(e.getMessage());
		}

		return baseBeanResponse;
	}

	public MensajeTransaccionBean altaCobroServicioEnLinea(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
		try {
			//Realizamos el alta del Cobro del Servicio
			PSLCobroSLBean pslCobroSLBean = new PSLCobroSLBean();
			pslCobroSLBean.setProductoID(ingresosOperacionesBean.getProductoID());
			pslCobroSLBean.setServicioID(ingresosOperacionesBean.getServicioIDPSL());
			pslCobroSLBean.setClasificacionServ(ingresosOperacionesBean.getClasificacionServPSL());
			pslCobroSLBean.setTipoUsuario(ingresosOperacionesBean.getTipoUsuario());
			pslCobroSLBean.setNumeroTarjeta(ingresosOperacionesBean.getNumeroTarjetaPSL());
			pslCobroSLBean.setClienteID(ingresosOperacionesBean.getClienteIDPSL());
			pslCobroSLBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhorroPSL());
			pslCobroSLBean.setProducto(ingresosOperacionesBean.getNombreProductoPSL());
			pslCobroSLBean.setFormaPago(ingresosOperacionesBean.getFormaPagoPSL());
			pslCobroSLBean.setPrecio(ingresosOperacionesBean.getPrecio());
			pslCobroSLBean.setTelefono(ingresosOperacionesBean.getTelefonoPSL());
			pslCobroSLBean.setReferencia(ingresosOperacionesBean.getReferenciaPSL());
			pslCobroSLBean.setComisiProveedor(ingresosOperacionesBean.getComisiProveedor());
			pslCobroSLBean.setComisiInstitucion(ingresosOperacionesBean.getComisiInstitucion());
			pslCobroSLBean.setIvaComision(ingresosOperacionesBean.getIvaComisiInstitucion());
			pslCobroSLBean.setTotalComisiones(ingresosOperacionesBean.getTotalComisiones());
			pslCobroSLBean.setTotalPagar(ingresosOperacionesBean.getTotalPagarPSL());
			pslCobroSLBean.setFechaHora(ingresosOperacionesBean.getFechaHoraPSL());
			pslCobroSLBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
			pslCobroSLBean.setCajaID(ingresosOperacionesBean.getCajaID());
			pslCobroSLBean.setCanal(ingresosOperacionesBean.getCanalPSL());
			pslCobroSLBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
			mensajeBean =  altaCobroServicioEnLinea(pslCobroSLBean, numeroTransaccion);

			if(mensajeBean.getNumero() != Constantes.ENTERO_CERO) {
				ingresosOperacionesBean.setCobroID(Constantes.STRING_CERO);
				throw new Exception(mensajeBean.getDescripcion());
			}

			ingresosOperacionesBean.setCobroID(mensajeBean.getConsecutivoInt());
		}
		catch (Exception e) {
			loggerSAFI.error("Error al realizar el alta del Cobro del Servicio en Linea.");
			e.printStackTrace();

			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}

		return mensajeBean;
	}

	private MensajeTransaccionBean altaCobroServicioEnLinea(final PSLCobroSLBean pslCobroSLBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PSLCOBROSLALT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,   ?,?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ProductoID",Utileria.convierteEntero(pslCobroSLBean.getProductoID()));
									sentenciaStore.setInt("Par_ServicioID",Utileria.convierteEntero(pslCobroSLBean.getServicioID()));
									sentenciaStore.setString("Par_ClasificacionServ", pslCobroSLBean.getClasificacionServ());
									sentenciaStore.setString("Par_TipoUsuario", pslCobroSLBean.getTipoUsuario());
									sentenciaStore.setString("Par_NumeroTarjeta", pslCobroSLBean.getNumeroTarjeta());
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(pslCobroSLBean.getClienteID()));

									sentenciaStore.setDouble("Par_CuentaAhoID",Utileria.convierteDoble(pslCobroSLBean.getCuentaAhoID()));
									sentenciaStore.setString("Par_Producto", pslCobroSLBean.getProducto());
									sentenciaStore.setString("Par_FormaPago", pslCobroSLBean.getFormaPago());
									sentenciaStore.setDouble("Par_Precio",Utileria.convierteDoble(pslCobroSLBean.getPrecio()));
									sentenciaStore.setString("Par_Telefono", pslCobroSLBean.getTelefono());

									sentenciaStore.setString("Par_Referencia", pslCobroSLBean.getReferencia());
									sentenciaStore.setDouble("Par_ComisiProveedor",Utileria.convierteDoble(pslCobroSLBean.getComisiProveedor()));
									sentenciaStore.setDouble("Par_ComisiInstitucion",Utileria.convierteDoble(pslCobroSLBean.getComisiInstitucion()));
									sentenciaStore.setDouble("Par_IVAComision",Utileria.convierteDoble(pslCobroSLBean.getIvaComision()));
									sentenciaStore.setDouble("Par_TotalComisiones",Utileria.convierteDoble(pslCobroSLBean.getTotalComisiones()));

									sentenciaStore.setDouble("Par_TotalPagar",Utileria.convierteDoble(pslCobroSLBean.getTotalPagar()));
									sentenciaStore.setString("Par_FechaHora",pslCobroSLBean.getFechaHora());
									sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(pslCobroSLBean.getSucursalID()));
									sentenciaStore.setInt("Par_CajaID",Utileria.convierteEntero(pslCobroSLBean.getCajaID()));
									sentenciaStore.setInt("Par_CajeroID",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setString("Par_Canal",pslCobroSLBean.getCanal());
									sentenciaStore.setString("Par_PolizaID",pslCobroSLBean.getPolizaID());


									//Parametros de salida
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_CobroID", Types.BIGINT);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + ".PSLCobroSLDAO.altaCobroServicioEnLinea");
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
						throw new Exception(Constantes.MSG_ERROR + ".PSLCobroSLDAO.altaCobroServicioEnLinea");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al realizar el alta de cobro de servicio en linea " + e);
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

	public MensajeTransaccionBean confirmacionCobroServicioEnLinea(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion) {
		int confirmacionCobroServicio = 2;
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

		try {
			//Realizamos el alta del Cobro del Servicio
			PSLCobroSLBean pslCobroSLBean = new PSLCobroSLBean();
			pslCobroSLBean.setProductoID(ingresosOperacionesBean.getProductoID());
			pslCobroSLBean.setServicioID(ingresosOperacionesBean.getServicioIDPSL());
			pslCobroSLBean.setClasificacionServ(ingresosOperacionesBean.getClasificacionServPSL());
			pslCobroSLBean.setTipoUsuario(ingresosOperacionesBean.getTipoUsuario());
			pslCobroSLBean.setNumeroTarjeta(ingresosOperacionesBean.getNumeroTarjetaPSL());
			pslCobroSLBean.setClienteID(ingresosOperacionesBean.getClienteIDPSL());
			pslCobroSLBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhorroPSL());
			pslCobroSLBean.setProducto(ingresosOperacionesBean.getNombreProductoPSL());
			pslCobroSLBean.setFormaPago(ingresosOperacionesBean.getFormaPagoPSL());
			pslCobroSLBean.setPrecio(ingresosOperacionesBean.getPrecio());
			pslCobroSLBean.setTelefono(ingresosOperacionesBean.getTelefonoPSL());
			pslCobroSLBean.setReferencia(ingresosOperacionesBean.getReferenciaPSL());
			pslCobroSLBean.setComisiProveedor(ingresosOperacionesBean.getComisiProveedor());
			pslCobroSLBean.setComisiInstitucion(ingresosOperacionesBean.getComisiInstitucion());
			pslCobroSLBean.setIvaComision(ingresosOperacionesBean.getIvaComisiInstitucion());
			pslCobroSLBean.setTotalComisiones(ingresosOperacionesBean.getTotalComisiones());
			pslCobroSLBean.setTotalPagar(ingresosOperacionesBean.getTotalPagarPSL());
			pslCobroSLBean.setFechaHora(ingresosOperacionesBean.getFechaHoraPSL());
			pslCobroSLBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
			pslCobroSLBean.setCajaID(ingresosOperacionesBean.getCajaID());
			pslCobroSLBean.setCanal(ingresosOperacionesBean.getCanalPSL());
			pslCobroSLBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
			pslCobroSLBean.setCobroID(ingresosOperacionesBean.getCobroID());

			mensajeBean = this.confirmacionCobroServicioEnLinea(pslCobroSLBean, confirmacionCobroServicio, numeroTransaccion);
		}
		catch (Exception e) {
			loggerSAFI.error("Error al realizar el Pago de Servicio en Linea.");
			e.printStackTrace();

			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}


		return mensajeBean;
	}

	private MensajeTransaccionBean confirmacionCobroServicioEnLinea(final PSLCobroSLBean pslCobroSLBean, final int numeroActualizacion, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PSLCOBROSLACT(?,?,   ?,   ?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_CobroID",Utileria.convierteEntero(pslCobroSLBean.getCobroID()));
									sentenciaStore.setInt("Par_PolizaID",Utileria.convierteEntero(pslCobroSLBean.getPolizaID()));

									sentenciaStore.setInt("Par_NumAct",numeroActualizacion);

									//Parametros de salida
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + ".PSLCobroSLDAO.bajaCobroServicioEnLinea");
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
						throw new Exception(Constantes.MSG_ERROR + ".PSLCobroSLDAO.bajaCobroServicioEnLinea");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al dar de Baja el cobro de servicio en linea " + e);
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

	public MensajeTransaccionBean bajaCobroServicioEnLinea(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion) {
		int bajaCobroServicio = 1;
		MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

		try {
			//Realizamos el alta del Cobro del Servicio
			PSLCobroSLBean pslCobroSLBean = new PSLCobroSLBean();
			pslCobroSLBean.setProductoID(ingresosOperacionesBean.getProductoID());
			pslCobroSLBean.setServicioID(ingresosOperacionesBean.getServicioIDPSL());
			pslCobroSLBean.setClasificacionServ(ingresosOperacionesBean.getClasificacionServPSL());
			pslCobroSLBean.setTipoUsuario(ingresosOperacionesBean.getTipoUsuario());
			pslCobroSLBean.setNumeroTarjeta(ingresosOperacionesBean.getNumeroTarjetaPSL());
			pslCobroSLBean.setClienteID(ingresosOperacionesBean.getClienteIDPSL());
			pslCobroSLBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhorroPSL());
			pslCobroSLBean.setProducto(ingresosOperacionesBean.getNombreProductoPSL());
			pslCobroSLBean.setFormaPago(ingresosOperacionesBean.getFormaPagoPSL());
			pslCobroSLBean.setPrecio(ingresosOperacionesBean.getPrecio());
			pslCobroSLBean.setTelefono(ingresosOperacionesBean.getTelefonoPSL());
			pslCobroSLBean.setReferencia(ingresosOperacionesBean.getReferenciaPSL());
			pslCobroSLBean.setComisiProveedor(ingresosOperacionesBean.getComisiProveedor());
			pslCobroSLBean.setComisiInstitucion(ingresosOperacionesBean.getComisiInstitucion());
			pslCobroSLBean.setIvaComision(ingresosOperacionesBean.getIvaComisiInstitucion());
			pslCobroSLBean.setTotalComisiones(ingresosOperacionesBean.getTotalComisiones());
			pslCobroSLBean.setTotalPagar(ingresosOperacionesBean.getTotalPagarPSL());
			pslCobroSLBean.setFechaHora(ingresosOperacionesBean.getFechaHoraPSL());
			pslCobroSLBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
			pslCobroSLBean.setCajaID(ingresosOperacionesBean.getCajaID());
			pslCobroSLBean.setCanal(ingresosOperacionesBean.getCanalPSL());
			pslCobroSLBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
			pslCobroSLBean.setCobroID(ingresosOperacionesBean.getCobroID());

			mensajeBean = this.bajaCobroServicioEnLinea(pslCobroSLBean, bajaCobroServicio, numeroTransaccion);
		}
		catch (Exception e) {
			loggerSAFI.error("Error al realizar el Pago de Servicio en Linea.");
			e.printStackTrace();

			if (mensajeBean.getNumero() == 0) {
				mensajeBean.setNumero(999);
			}
			mensajeBean.setDescripcion(e.getMessage());
		}


		return mensajeBean;
	}

	private MensajeTransaccionBean bajaCobroServicioEnLinea(final PSLCobroSLBean pslCobroSLBean, final int numeroActualizacion, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call PSLCOBROSLACT(?,?,   ?,   ?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_CobroID",Utileria.convierteEntero(pslCobroSLBean.getCobroID()));
									sentenciaStore.setInt("Par_PolizaID",Utileria.convierteEntero(pslCobroSLBean.getPolizaID()));

									sentenciaStore.setInt("Par_NumAct",numeroActualizacion);

									//Parametros de salida
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + ".PSLCobroSLDAO.bajaCobroServicioEnLinea");
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
						throw new Exception(Constantes.MSG_ERROR + ".PSLCobroSLDAO.bajaCobroServicioEnLinea");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al dar de Baja el cobro de servicio en linea " + e);
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

	public CompraTiempoAireBeanResponse consumeWSCompraTiempoAireBroker(final IngresosOperacionesBean ingresosOperacionesBean, final PSLParamBrokerBean pslParamBrokerBean, final long numeroTransaccion) {
		loggerSAFI.info("Realizando Compra de tiempo aire con el Proveedor de servicios");
		CompraTiempoAireBeanResponse compraTiempoAireBeanResponse = new CompraTiempoAireBeanResponse();
		//MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
		//String codigoExitoBroker = "000000";
		String url = pslParamBrokerBean.getUrlConexion() + "/brokerTransacciones/compraTiempoAire";
		String usuario = pslParamBrokerBean.getUsuario();
		String password = pslParamBrokerBean.getContrasenia();
		String autentificacion = usuario + ":" + password;
		byte[] encodedBytes = Base64.encodeBase64(autentificacion.getBytes());
		String autentificacionCodificada = new String(encodedBytes);

		try {
			//Establecemos los parametros del Bean Request para el Broker de Servicios
			CompraTiempoAireBean compraTiempoAireBean = new CompraTiempoAireBean();
			compraTiempoAireBean.setTelefono(ingresosOperacionesBean.getTelefonoPSL());
			compraTiempoAireBean.setReferencia(ingresosOperacionesBean.getReferenciaPSL());
			compraTiempoAireBean.setServicioID(ingresosOperacionesBean.getServicioIDPSL());
			compraTiempoAireBean.setProductoID(ingresosOperacionesBean.getProductoID());
			compraTiempoAireBean.setIdentificador(Constantes.STRING_VACIO);
			compraTiempoAireBean.setUsuario("" + parametrosAuditoriaBean.getUsuario());
			compraTiempoAireBean.setUsuarioIP(parametrosAuditoriaBean.getDireccionIP());
			compraTiempoAireBean.setSucursalUsuario("" + parametrosAuditoriaBean.getSucursal());

			//Consumimos el WS para compra de tiempo aire del Broker de servicios
			ConsumidorRest<CompraTiempoAireBeanResponse> consumidorRest = new ConsumidorRest<CompraTiempoAireBeanResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);

			compraTiempoAireBeanResponse = consumidorRest.consumePost(url, compraTiempoAireBean, CompraTiempoAireBeanResponse.class);
			loggerSAFI.info("Respuesta en Compra de tiempo del Proveedor de Servicios:" + compraTiempoAireBeanResponse.getCodigoRespuesta() + " - " + compraTiempoAireBeanResponse.getMensajeRespuesta());
		}
		catch(Exception e) {
			//Devolvemos codigo y mensaje de proceso fallido
			compraTiempoAireBeanResponse = new CompraTiempoAireBeanResponse();
			compraTiempoAireBeanResponse.setCodigoRespuesta("999");
			compraTiempoAireBeanResponse.setMensajeRespuesta("No se pudo realizar la Compra de tiempo aire con el Proveedor de Servicios:" + e.getMessage());
			loggerSAFI.error("No se pudo realizar la Compra de tiempo aire con el Proveedor de Servicios:" + e.getMessage());
			e.printStackTrace();
		}

		return compraTiempoAireBeanResponse;
	}

	public PagoServiciosBeanResponse consumeWSPagoServiciosBroker(final IngresosOperacionesBean ingresosOperacionesBean, final PSLParamBrokerBean pslParamBrokerBean, final long numeroTransaccion) {
		loggerSAFI.info("Realizando Pago de servicios con el Proveedor de servicios");
		PagoServiciosBeanResponse pagoServiciosBeanResponse = new PagoServiciosBeanResponse();
		//MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
		//String codigoExitoBroker = "000000";
		String url = pslParamBrokerBean.getUrlConexion() + "/brokerTransacciones/pagoServicios";
		String usuario = pslParamBrokerBean.getUsuario();
		String password = pslParamBrokerBean.getContrasenia();
		String autentificacion = usuario + ":" + password;
		byte[] encodedBytes = Base64.encodeBase64(autentificacion.getBytes());
		String autentificacionCodificada = new String(encodedBytes);

		try {
			//Establecemos los parametros del Bean Request para el Broker de Servicios
			PagoServiciosBean pagoServiciosBean = new PagoServiciosBean();
			pagoServiciosBean.setTelefono(ingresosOperacionesBean.getTelefonoPSL());
			pagoServiciosBean.setServicioID(ingresosOperacionesBean.getServicioIDPSL());
			pagoServiciosBean.setProductoID(ingresosOperacionesBean.getProductoID());
			pagoServiciosBean.setReferencia(ingresosOperacionesBean.getReferenciaPSL());
			pagoServiciosBean.setMontoPago(ingresosOperacionesBean.getPrecio());
			pagoServiciosBean.setUsuario("" + parametrosAuditoriaBean.getUsuario());
			pagoServiciosBean.setUsuarioIP(parametrosAuditoriaBean.getDireccionIP());
			pagoServiciosBean.setSucursalUsuario("" + parametrosAuditoriaBean.getSucursal());
			//Consumimos el WS para pago de servicios del Broker de servicios
			ConsumidorRest<PagoServiciosBeanResponse> consumidorRest = new ConsumidorRest<PagoServiciosBeanResponse>();
			consumidorRest.addHeader("Autentificacion", autentificacionCodificada);

			pagoServiciosBeanResponse = consumidorRest.consumePost(url, pagoServiciosBean, PagoServiciosBeanResponse.class);
			loggerSAFI.info("Respuesta en Pago de Servicios del Proveedor de Servicios:" + pagoServiciosBeanResponse.getCodigoRespuesta() + " - " + pagoServiciosBeanResponse.getMensajeRespuesta());
		}
		catch(Exception e) {
			//Devolvemos codigo y mensaje de proceso fallido
			pagoServiciosBeanResponse.setCodigoRespuesta("999");
			pagoServiciosBeanResponse.setMensajeRespuesta("No se pudo realizar el Pago de Servicio con el Proveedor de Servicios:" + e.getMessage());
			loggerSAFI.info("No se pudo realizar el Pago de Servicio con el Proveedor de Servicios:" + e.getMessage());
			e.printStackTrace();
		}

		return pagoServiciosBeanResponse;
	}

	public MensajeTransaccionBean altaRespuestaWSBrokerServicios(final IngresosOperacionesBean ingresosOperacionesBean, final BaseBeanResponse baseBeanResponse, final long numeroTransaccion) {
		MensajeTransaccionBean mensajeTransaccionBean = null;

		TransaccionBean transaccionBean = baseBeanResponse.getTransaccion();
		String numTransaccionP = (transaccionBean != null && transaccionBean.getNumTransaccion() != null)?transaccionBean.getNumTransaccion():Constantes.STRING_VACIO;
		String numAutorizacion = (transaccionBean != null && transaccionBean.getNumAutorizacion() != null)?transaccionBean.getNumAutorizacion():Constantes.STRING_CERO;
		String monto = (transaccionBean != null && transaccionBean.getMonto() != null)?transaccionBean.getMonto():Constantes.STRING_CERO;
		String comision = (transaccionBean != null && transaccionBean.getComision() != null)?transaccionBean.getComision():Constantes.STRING_CERO;
		String referencia = (transaccionBean != null && transaccionBean.getReferencia() != null)?transaccionBean.getReferencia():Constantes.STRING_VACIO;
		String saldoRecarga = (transaccionBean != null && transaccionBean.getSaldoRecarga() != null)?transaccionBean.getSaldoRecarga():Constantes.STRING_CERO;
		String saldoServicio = (transaccionBean != null && transaccionBean.getSaldoServicio() != null)?transaccionBean.getSaldoServicio():Constantes.STRING_CERO;

		PSLRespPagoServBean pslRespPagoServBean = new PSLRespPagoServBean();
		pslRespPagoServBean.setCobroID(ingresosOperacionesBean.getCobroID());
		pslRespPagoServBean.setCodigoRespuesta(baseBeanResponse.getCodigoRespuesta());
		pslRespPagoServBean.setMensajeRespuesta(baseBeanResponse.getMensajeRespuesta());
		pslRespPagoServBean.setNumTransaccionP(numTransaccionP);
		pslRespPagoServBean.setNumAutorizacion(numAutorizacion);
		pslRespPagoServBean.setMonto(monto);
		pslRespPagoServBean.setComision(comision);
		pslRespPagoServBean.setReferencia(referencia);
		pslRespPagoServBean.setSaldoRecarga(saldoRecarga);
		pslRespPagoServBean.setSaldoServicio(saldoServicio);

		mensajeTransaccionBean = pslRespPagoServDAO.altaRespPagoServ(pslRespPagoServBean, numeroTransaccion);

		return mensajeTransaccionBean;
	}

	public PSLParamBrokerDAO getPslParamBrokerDAO() {
		return pslParamBrokerDAO;
	}

	public void setPslParamBrokerDAO(PSLParamBrokerDAO pslParamBrokerDAO) {
		this.pslParamBrokerDAO = pslParamBrokerDAO;
	}

	public PSLRespPagoServDAO getPslRespPagoServDAO() {
		return pslRespPagoServDAO;
	}

	public void setPslRespPagoServDAO(PSLRespPagoServDAO pslRespPagoServDAO) {
		this.pslRespPagoServDAO = pslRespPagoServDAO;
	}
}
